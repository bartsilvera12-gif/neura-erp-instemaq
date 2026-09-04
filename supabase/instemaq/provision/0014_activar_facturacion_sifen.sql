-- =============================================================================
-- Instemaq — ACTIVAR facturación electrónica automática al confirmar la venta
-- =============================================================================
-- Pone empresa_facturacion_modo.modo = 'sifen': a partir de acá, cada venta
-- confirmada crea la factura y emite el DE SIFEN (no bloqueante).
-- Requiere que el código de la feature esté desplegado (commit facturación al vender).
-- Reversible: volver a 'sin_factura_fiscal' desactiva la emisión automática.
-- Idempotente.
-- =============================================================================

INSERT INTO instemaq.empresa_facturacion_modo (empresa_id, modo, activo)
VALUES ('20863e7f-39f3-4bb7-87bf-90fd7e08f396'::uuid, 'sifen', true)
ON CONFLICT (empresa_id) DO UPDATE SET
  modo = 'sifen',
  activo = true,
  updated_at = now();
