-- =============================================================================
-- Instemaq — módulo Recibos de dinero
-- =============================================================================
-- Solo DML (catálogo). La tabla `recibos_dinero` ya existe en el schema.
-- Idempotente.
-- =============================================================================

INSERT INTO instemaq.modulos (id, nombre, slug, descripcion)
SELECT gen_random_uuid(), 'Recibos', 'recibos', 'Recibos de dinero (comprobante interno no fiscal)'
WHERE NOT EXISTS (SELECT 1 FROM instemaq.modulos WHERE slug = 'recibos');

INSERT INTO instemaq.empresa_modulos (empresa_id, modulo_id, activo)
SELECT '20863e7f-39f3-4bb7-87bf-90fd7e08f396', m.id, true
FROM instemaq.modulos m
WHERE m.slug = 'recibos'
  AND NOT EXISTS (
    SELECT 1 FROM instemaq.empresa_modulos em
    WHERE em.empresa_id = '20863e7f-39f3-4bb7-87bf-90fd7e08f396' AND em.modulo_id = m.id
  );
