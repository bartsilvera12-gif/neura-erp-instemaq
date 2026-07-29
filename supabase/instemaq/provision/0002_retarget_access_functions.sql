-- =============================================================================
-- Instemaq — corrección de referencias heredadas a `enlodemari` en funciones
-- =============================================================================
-- El schema instemaq se clonó desde ferrecolor, que a su vez arrastra en su linaje
-- funciones con `SET search_path TO 'enlodemari'`. En las funciones de control de
-- acceso (RLS) el cuerpo YA referencia `instemaq.*` de forma calificada, por lo que
-- ese search_path era inerte; aun así se retarget-ea a `instemaq` para dejar las
-- funciones de acceso apuntando explícitamente al schema propio.
--
-- Idempotente: ALTER FUNCTION ... SET search_path y DROP FUNCTION IF EXISTS.
-- =============================================================================

-- Funciones de acceso usadas por las políticas RLS de instemaq.
ALTER FUNCTION instemaq.jwt_email_normalized() SET search_path TO 'instemaq';
ALTER FUNCTION instemaq.empresa_id_actual()    SET search_path TO 'instemaq';
ALTER FUNCTION instemaq.es_super_admin()        SET search_path TO 'instemaq';

-- Guard heredado específico de enlodemari (hardcodea el UUID de la empresa
-- enlodemari y fuerza data_schema='enlodemari'). No está asociado a ningún
-- trigger en instemaq. Se elimina para no dejar el hardcode del tenant ajeno.
DROP FUNCTION IF EXISTS instemaq.neura_enlodemari_block_other_empresas();
