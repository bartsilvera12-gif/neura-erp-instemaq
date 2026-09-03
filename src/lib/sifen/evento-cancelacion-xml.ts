/**
 * XML del Evento de Cancelación SIFEN (v150).
 *
 * Estructura del grupo firmable `rGesEve` → `rEve` (Id del evento) → `gGroupTiEvt`
 * → `rGeVeCan` (Id = CDC del DE, mOtEve = motivo). La firma XML-DSig se agrega
 * después (ver `signSifenEventoXml` en `sign-xml.ts`). El envoltorio SOAP
 * `rEnviEventoDe` lo arma `enviar-evento-sifen.ts`.
 */
import { SIFEN_EKUATIA_TARGET_NS } from "./sifen-xsi-schema-location";
import { escapeXml } from "./xml";

const SIFEN_NS = SIFEN_EKUATIA_TARGET_NS;

/** Timestamp `YYYY-MM-DDTHH:MM:SS` en hora de Paraguay (America/Asuncion). */
export function fechaFirmaEventoSifen(d: Date = new Date()): string {
  const parts = new Intl.DateTimeFormat("en-CA", {
    timeZone: "America/Asuncion",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
    hour12: false,
  }).formatToParts(d);
  const get = (t: string) => parts.find((p) => p.type === t)?.value ?? "00";
  return `${get("year")}-${get("month")}-${get("day")}T${get("hour")}:${get("minute")}:${get("second")}`;
}

export interface BuildEventoCancelacionInput {
  /** CDC (44 dígitos) del documento electrónico a cancelar. */
  cdc: string;
  /** Motivo de cancelación (5–500 caracteres). */
  motivo: string;
  /** Id del evento (numérico, secuencial/único por emisor). */
  eventoId: number;
  /** Fecha de firma; por defecto ahora (hora Paraguay). */
  fechaFirma?: string;
}

/**
 * Devuelve el grupo `rGesEve` (SIN firmar) con el evento de cancelación.
 * El nodo `rEve` lleva `Id` (referenciado por la firma).
 */
export function buildEventoCancelacionXml(input: BuildEventoCancelacionInput): string {
  const cdc = String(input.cdc ?? "").replace(/\s/g, "").trim();
  if (cdc.length !== 44) {
    throw new Error("CDC inválido para el evento de cancelación (se esperan 44 dígitos).");
  }
  const motivo = String(input.motivo ?? "").trim();
  if (motivo.length < 5 || motivo.length > 500) {
    throw new Error("El motivo de cancelación debe tener entre 5 y 500 caracteres.");
  }
  const eventoId = Math.trunc(Number(input.eventoId));
  if (!Number.isFinite(eventoId) || eventoId <= 0) {
    throw new Error("Id de evento inválido.");
  }
  const dFecFirma = input.fechaFirma ?? fechaFirmaEventoSifen();

  return (
    `<rGesEve xmlns="${SIFEN_NS}">` +
    `<rEve Id="${eventoId}">` +
    `<dFecFirma>${dFecFirma}</dFecFirma>` +
    `<dVerFor>150</dVerFor>` +
    `<gGroupTiEvt>` +
    `<rGeVeCan>` +
    `<Id>${cdc}</Id>` +
    `<mOtEve>${escapeXml(motivo)}</mOtEve>` +
    `</rGeVeCan>` +
    `</gGroupTiEvt>` +
    `</rEve>` +
    `</rGesEve>`
  );
}
