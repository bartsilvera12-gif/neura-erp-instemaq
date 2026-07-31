-- =============================================================================
-- Instemaq — script para ejecutar en el SQL Editor de Supabase
-- =============================================================================
-- Ejecutar COMPLETO, de una sola vez. Es idempotente: se puede correr varias veces.
--
-- Requiere rol propietario (supabase_admin / superusuario). El rol `postgres`
-- de la cadena de conexión NO tiene permiso de DDL sobre el schema `instemaq`
-- (owner = supabase_admin), por eso estos pasos no se pudieron automatizar.
--
-- Contenido:
--   1) Tablas de Remisión / Recepción (multi-depósito)
--   2) movimientos_inventario: columna ubicacion_id + origen 'nota_remision'
--   3) Permisos del rol anon (rutas públicas)
--   4) Funciones de acceso RLS apuntando a instemaq
--   5) Catálogo de módulos: Remisión y Recepción
-- =============================================================================


-- -----------------------------------------------------------------------------
-- 1) TABLAS DE REMISIÓN / RECEPCIÓN
-- -----------------------------------------------------------------------------

-- Stock por depósito (base del multi-depósito).
CREATE TABLE IF NOT EXISTS instemaq.productos_stock_ubicacion (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  empresa_id   uuid NOT NULL,
  producto_id  uuid NOT NULL REFERENCES instemaq.productos(id) ON DELETE CASCADE,
  ubicacion_id uuid NOT NULL REFERENCES instemaq.inventario_ubicaciones(id) ON DELETE CASCADE,
  stock        numeric NOT NULL DEFAULT 0,
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT productos_stock_ubicacion_empresa_producto_ubicacion_key
    UNIQUE (empresa_id, producto_id, ubicacion_id)
);
CREATE INDEX IF NOT EXISTS idx_psu_producto    ON instemaq.productos_stock_ubicacion (producto_id);
CREATE INDEX IF NOT EXISTS idx_psu_ubicacion   ON instemaq.productos_stock_ubicacion (ubicacion_id);
CREATE INDEX IF NOT EXISTS idx_psu_empresa_ubi ON instemaq.productos_stock_ubicacion (empresa_id, ubicacion_id);

-- Cabecera de la nota de remisión (documento NO fiscal).
CREATE TABLE IF NOT EXISTS instemaq.notas_remision (
  id                    uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  empresa_id            uuid NOT NULL,
  numero                text NOT NULL,
  fecha                 timestamptz NOT NULL DEFAULT now(),
  emisor                text NOT NULL,
  ubicacion_origen_id   uuid NOT NULL REFERENCES instemaq.inventario_ubicaciones(id),
  ubicacion_destino_id  uuid NOT NULL REFERENCES instemaq.inventario_ubicaciones(id),
  motivo                text NOT NULL DEFAULT 'traslado',
  estado                text NOT NULL DEFAULT 'pendiente',
  motivo_rechazo        text,
  aprobada_at           timestamptz,
  aprobada_por          text,
  transportista         text,
  ruc_transportista     text,
  conductor             text,
  ci_conductor          text,
  chapa                 text,
  fecha_inicio_traslado date,
  fecha_fin_traslado    date,
  observaciones         text,
  created_at            timestamptz NOT NULL DEFAULT now(),
  updated_at            timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT notas_remision_empresa_id_numero_key UNIQUE (empresa_id, numero),
  CONSTRAINT notas_remision_estado_check CHECK (estado = ANY (ARRAY['pendiente','aprobada','rechazada'])),
  CONSTRAINT notas_remision_motivo_check CHECK (motivo = ANY (ARRAY['traslado','venta','devolucion']))
);
CREATE INDEX IF NOT EXISTS idx_nr_empresa ON instemaq.notas_remision (empresa_id);
CREATE INDEX IF NOT EXISTS idx_nr_estado  ON instemaq.notas_remision (empresa_id, estado);
CREATE INDEX IF NOT EXISTS idx_nr_destino ON instemaq.notas_remision (ubicacion_destino_id, estado);

-- Ítems de la nota de remisión.
CREATE TABLE IF NOT EXISTS instemaq.notas_remision_items (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nota_remision_id uuid NOT NULL REFERENCES instemaq.notas_remision(id) ON DELETE CASCADE,
  producto_id      uuid NOT NULL REFERENCES instemaq.productos(id),
  cantidad         numeric NOT NULL,
  created_at       timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_nri_nr       ON instemaq.notas_remision_items (nota_remision_id);
CREATE INDEX IF NOT EXISTS idx_nri_producto ON instemaq.notas_remision_items (producto_id);

-- RLS: mismo patrón del resto del schema, usando la función PROPIA de instemaq.
ALTER TABLE instemaq.productos_stock_ubicacion ENABLE ROW LEVEL SECURITY;
ALTER TABLE instemaq.notas_remision            ENABLE ROW LEVEL SECURITY;
ALTER TABLE instemaq.notas_remision_items      ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS psu_all ON instemaq.productos_stock_ubicacion;
CREATE POLICY psu_all ON instemaq.productos_stock_ubicacion
  FOR ALL USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

DROP POLICY IF EXISTS nr_all ON instemaq.notas_remision;
CREATE POLICY nr_all ON instemaq.notas_remision
  FOR ALL USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- Los ítems heredan el permiso de su cabecera.
DROP POLICY IF EXISTS nri_all ON instemaq.notas_remision_items;
CREATE POLICY nri_all ON instemaq.notas_remision_items
  FOR ALL USING (EXISTS (
    SELECT 1 FROM instemaq.notas_remision nr
    WHERE nr.id = nota_remision_id AND instemaq.puede_acceder_empresa(nr.empresa_id)
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM instemaq.notas_remision nr
    WHERE nr.id = nota_remision_id AND instemaq.puede_acceder_empresa(nr.empresa_id)
  ));

GRANT ALL ON instemaq.productos_stock_ubicacion, instemaq.notas_remision, instemaq.notas_remision_items
  TO anon, authenticated, service_role;


-- -----------------------------------------------------------------------------
-- 2) MOVIMIENTOS DE INVENTARIO: soporte de depósito y origen 'nota_remision'
-- -----------------------------------------------------------------------------
ALTER TABLE instemaq.movimientos_inventario
  ADD COLUMN IF NOT EXISTS ubicacion_id uuid REFERENCES instemaq.inventario_ubicaciones(id);

CREATE INDEX IF NOT EXISTS idx_mov_ubicacion ON instemaq.movimientos_inventario (ubicacion_id);

-- El CHECK actual de `origen` no admite 'nota_remision'; se reemplaza incluyéndolo.
DO $$
DECLARE v_con text;
BEGIN
  SELECT co.conname INTO v_con
  FROM pg_constraint co
  JOIN pg_class cl ON cl.oid = co.conrelid
  JOIN pg_namespace n ON n.oid = cl.relnamespace
  WHERE n.nspname = 'instemaq' AND cl.relname = 'movimientos_inventario'
    AND co.contype = 'c' AND pg_get_constraintdef(co.oid) LIKE '%origen%';
  IF v_con IS NOT NULL THEN
    EXECUTE format('ALTER TABLE instemaq.movimientos_inventario DROP CONSTRAINT %I', v_con);
  END IF;
  ALTER TABLE instemaq.movimientos_inventario
    ADD CONSTRAINT movimientos_inventario_origen_check
    CHECK (origen = ANY (ARRAY['compra','venta','ajuste_manual','inventario_inicial',
                               'produccion','devolucion_venta','nota_remision']));
END $$;


-- -----------------------------------------------------------------------------
-- 3) PERMISOS DEL ROL anon (rutas públicas). RLS sigue filtrando fila por fila.
-- -----------------------------------------------------------------------------
GRANT USAGE ON SCHEMA instemaq TO anon;
GRANT ALL ON ALL TABLES     IN SCHEMA instemaq TO anon;
GRANT ALL ON ALL SEQUENCES  IN SCHEMA instemaq TO anon;
GRANT EXECUTE ON ALL ROUTINES IN SCHEMA instemaq TO anon;


-- -----------------------------------------------------------------------------
-- 4) FUNCIONES DE ACCESO RLS APUNTANDO A instemaq
--    (heredaban `search_path` del tenant enlodemari; el cuerpo ya es correcto)
-- -----------------------------------------------------------------------------
ALTER FUNCTION instemaq.jwt_email_normalized() SET search_path TO 'instemaq';
ALTER FUNCTION instemaq.empresa_id_actual()    SET search_path TO 'instemaq';
ALTER FUNCTION instemaq.es_super_admin()       SET search_path TO 'instemaq';
ALTER FUNCTION instemaq.puede_acceder_empresa(uuid) SET search_path TO 'instemaq';

-- Guard heredado de otro tenant (hardcodea su UUID). No está usado por ningún trigger.
DROP FUNCTION IF EXISTS instemaq.neura_enlodemari_block_other_empresas();


-- -----------------------------------------------------------------------------
-- 5) CATÁLOGO DE MÓDULOS: Remisión y Recepción (habilitados para Instemaq)
-- -----------------------------------------------------------------------------
INSERT INTO instemaq.modulos (id, nombre, slug, descripcion)
SELECT gen_random_uuid(), 'Remisión', 'remision', 'Emisión de notas de remisión (traslado entre depósitos)'
WHERE NOT EXISTS (SELECT 1 FROM instemaq.modulos WHERE slug = 'remision');

INSERT INTO instemaq.modulos (id, nombre, slug, descripcion)
SELECT gen_random_uuid(), 'Recepción', 'recepcion', 'Recepción y aprobación de remisiones entrantes'
WHERE NOT EXISTS (SELECT 1 FROM instemaq.modulos WHERE slug = 'recepcion');

INSERT INTO instemaq.empresa_modulos (empresa_id, modulo_id, activo)
SELECT '20863e7f-39f3-4bb7-87bf-90fd7e08f396', m.id, true
FROM instemaq.modulos m
WHERE m.slug IN ('remision', 'recepcion')
  AND NOT EXISTS (
    SELECT 1 FROM instemaq.empresa_modulos em
    WHERE em.empresa_id = '20863e7f-39f3-4bb7-87bf-90fd7e08f396' AND em.modulo_id = m.id
  );


-- =============================================================================
-- Verificación rápida (debe devolver todo en OK)
-- =============================================================================
SELECT
  (SELECT count(*) FROM information_schema.tables
     WHERE table_schema='instemaq'
       AND table_name IN ('notas_remision','notas_remision_items','productos_stock_ubicacion')) AS tablas_creadas_de_3,
  (SELECT count(*) FROM information_schema.columns
     WHERE table_schema='instemaq' AND table_name='movimientos_inventario' AND column_name='ubicacion_id') AS ubicacion_id_ok,
  (SELECT count(*) FROM information_schema.role_table_grants
     WHERE table_schema='instemaq' AND grantee='anon' AND privilege_type='SELECT') AS tablas_con_anon_select,
  (SELECT count(*) FROM instemaq.modulos WHERE slug IN ('remision','recepcion')) AS modulos_nuevos_de_2;
