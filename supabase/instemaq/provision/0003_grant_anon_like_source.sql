-- =============================================================================
-- Instemaq — igualar permisos del rol `anon` al schema fuente (ferrecolor)
-- =============================================================================
-- El clonador (neura_clone_schema_full) otorga privilegios a `authenticated` y
-- `service_role`, pero NO a `anon`. En ferrecolor, `anon` tiene ALL sobre todas
-- las tablas y el acceso real lo filtra RLS (idéntico en instemaq). La app usa el
-- rol `anon` en rutas públicas (browser sin sesión), por lo que sin estos grants
-- PostgREST responde 401/42501 "permission denied".
--
-- Seguridad: NO afecta el aislamiento — las 402 políticas RLS de instemaq siguen
-- filtrando fila por fila; además instemaq no contiene datos operativos.
-- Idempotente.
--
-- IMPORTANTE: las tablas son propiedad de `supabase_admin`. El rol `postgres`
-- (no superusuario, sin GRANT OPTION) ejecuta estos GRANT sin error pero sin
-- efecto ("no privileges were granted"). Aplicar con conexión `supabase_admin`
-- /superusuario (p. ej. psql dentro del contenedor `db` de Supabase self-hosted).
-- Sin estos grants, solo fallan las rutas públicas (rol anon); el rol
-- `authenticated` ya tiene permisos y la app funciona para usuarios logueados.
-- =============================================================================

GRANT USAGE ON SCHEMA instemaq TO anon;
GRANT ALL ON ALL TABLES IN SCHEMA instemaq TO anon;
GRANT ALL ON ALL SEQUENCES IN SCHEMA instemaq TO anon;
GRANT EXECUTE ON ALL ROUTINES IN SCHEMA instemaq TO anon;
