/**
 * Envío del Evento de Cancelación al SET (siRecepEvento).
 * Envuelve el grupo `rGesEve` firmado en `rEnviEventoDe` (dId + dEvReg → gGroupGesEve),
 * SOAP 1.2, y lo transmite por mTLS con el .p12 de la empresa (igual que recibe-lote).
 */
import * as https from "node:https";
import { URL } from "node:url";
import type { AmbienteSifen } from "./types";
import { extractKeyAndCertFromP12 } from "./sign-xml";
import { SIFEN_EKUATIA_TARGET_NS } from "./sifen-xsi-schema-location";
import { urlRecepEvento } from "./sifen-ws-urls";

const SOAP_ENV = "http://www.w3.org/2003/05/soap-envelope";
const SIFEN_NS = SIFEN_EKUATIA_TARGET_NS;

/** Código SET de evento procesado/registrado con éxito. */
const COD_EVENTO_OK = "0600";

export interface EnviarEventoCancelacionResult {
  aceptado: boolean;
  dCodRes: string | null;
  dMsgRes: string | null;
  httpStatus: number;
  cuerpoSoapCrudo: string;
}

function generarDId(): number {
  const mod = BigInt("999999999999999");
  let n = Number(BigInt(Date.now()) % mod);
  if (!Number.isFinite(n) || n < 1) n = 1;
  return n;
}

/** Extrae texto de un elemento hoja (prefijo opcional) de la respuesta SOAP. */
function extraerTextoElemento(xml: string, local: string): string | null {
  const re = new RegExp(
    `<(?:[^\\s/>:]+:)?${local}\\b[^>]*>([\\s\\S]*?)</(?:[^\\s/>:]+:)?${local}\\b[^>]*>`,
    "i"
  );
  const m = xml.match(re);
  if (!m?.[1]) return null;
  const inner = m[1].replace(/<[^>]+>/g, "").trim();
  return inner.length > 0 ? inner : null;
}

function postHttpsMtls(
  urlStr: string,
  body: string,
  certPem: string,
  keyPem: string,
  contentType: string
): Promise<{ status: number; body: string }> {
  const url = new URL(urlStr);
  const port = url.port ? Number(url.port) : 443;
  return new Promise((resolve, reject) => {
    const req = https.request(
      {
        hostname: url.hostname,
        port,
        path: `${url.pathname}${url.search}`,
        method: "POST",
        cert: certPem,
        key: keyPem,
        rejectUnauthorized: true,
        headers: {
          "Content-Type": contentType,
          "Content-Length": Buffer.byteLength(body, "utf8"),
        },
      },
      (res) => {
        const chunks: Buffer[] = [];
        res.on("data", (ch) => chunks.push(ch as Buffer));
        res.on("end", () => {
          resolve({ status: res.statusCode ?? 0, body: Buffer.concat(chunks).toString("utf8") });
        });
      }
    );
    // Falla rápido si el SET no responde (evita que el request de cancelación se
    // cuelgue y el proxy devuelva un HTML de timeout).
    // Timeout corto: Vercel no respeta maxDuration en esta cuenta (cap ~10s), así que
    // si el SET no responde rápido debemos fallar con JSON ANTES de que el gateway
    // mate la función y devuelva un 502 sin cuerpo.
    req.setTimeout(6_000, () => {
      req.destroy(new Error("Timeout esperando respuesta del SET (eventos, 6s)."));
    });
    req.on("error", reject);
    req.write(body, "utf8");
    req.end();
  });
}

export async function enviarEventoCancelacionSifen(args: {
  rGesEveFirmado: string;
  ambiente: AmbienteSifen;
  certificadoP12: Buffer;
  certificadoPassword: string;
  dId?: number;
}): Promise<EnviarEventoCancelacionResult> {
  if (args.ambiente !== "test" && args.ambiente !== "produccion") {
    throw new Error('ambiente debe ser "test" o "produccion".');
  }
  const dId = args.dId ?? generarDId();
  const inner = args.rGesEveFirmado
    .replace(/^﻿?/, "")
    .replace(/^<\?xml[^?]*\?>\s*/i, "")
    .trim();

  const soap =
    `<?xml version="1.0" encoding="UTF-8"?>` +
    `<env:Envelope xmlns:env="${SOAP_ENV}">` +
    `<env:Header/>` +
    `<env:Body>` +
    `<rEnviEventoDe xmlns="${SIFEN_NS}">` +
    `<dId>${dId}</dId>` +
    `<dEvReg>` +
    `<gGroupGesEve>${inner}</gGroupGesEve>` +
    `</dEvReg>` +
    `</rEnviEventoDe>` +
    `</env:Body>` +
    `</env:Envelope>`;

  const { privateKeyPem, certificatePem } = extractKeyAndCertFromP12(
    args.certificadoP12,
    args.certificadoPassword
  );

  const serviceUrl = urlRecepEvento(args.ambiente);
  let httpStatus: number;
  let cuerpo: string;
  try {
    const res = await postHttpsMtls(serviceUrl, soap, certificatePem, privateKeyPem, "application/xml; charset=utf-8");
    httpStatus = res.status;
    cuerpo = res.body;
  } catch (e) {
    const msg = e instanceof Error ? e.message : String(e);
    const label = args.ambiente === "produccion" ? "SIFEN producción" : "SIFEN TEST";
    throw new Error(`Fallo HTTPS/mTLS (eventos) contra ${label}: ${msg}`);
  }

  const dCodRes = extraerTextoElemento(cuerpo, "dCodRes");
  const dMsgRes = extraerTextoElemento(cuerpo, "dMsgRes");
  const codSinCeros = (dCodRes ?? "").replace(/^0+/, "") || "";
  const aceptado = dCodRes === COD_EVENTO_OK || codSinCeros === "600";

  return { aceptado, dCodRes, dMsgRes, httpStatus, cuerpoSoapCrudo: cuerpo };
}
