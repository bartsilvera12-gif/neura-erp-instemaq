-- =============================================================================
-- Instemaq — reapuntar policies RLS al schema propio
-- =============================================================================
-- Ejecutar COMPLETO en el SQL Editor de Supabase (requiere supabase_admin).
-- Idempotente: se puede correr varias veces.
--
-- PROBLEMA: 398 policies de `instemaq` invocan funciones del schema
-- `reservacaacupe` (otro tenant), heredadas por la clonación desde ferrecolor.
-- Esas funciones leen `reservacaacupe.usuarios`, por lo que la RLS de Instemaq
-- NO evalúa su propia lógica (resultado: deny). La app funciona porque el
-- servidor usa service_role, que ignora RLS.
--
-- Además, algunas policies consultan TABLAS del otro tenant
-- (reservacaacupe.usuarios, reservacaacupe.chat_flow_nodes): eso sí es una
-- lectura cruzada real entre inquilinos durante la evaluación de RLS.
--
-- SOLUCIÓN: recrear cada policy idéntica, cambiando `reservacaacupe.<obj>` por
-- `instemaq.<obj>`. Todos los objetos equivalentes ya existen en instemaq:
--   funciones: empresa_id_actual, es_super_admin, jwt_email_normalized,
--              puede_acceder_empresa
--   tablas:    usuarios, chat_flow_nodes
--
-- No cambia nombres, comandos, roles ni la lógica: solo el schema de los objetos.
-- =============================================================================

BEGIN;


-- ── chat_agents ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_agents_delete" ON instemaq."chat_agents";
CREATE POLICY "chat_agents_delete" ON instemaq."chat_agents" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_agents_insert" ON instemaq."chat_agents";
CREATE POLICY "chat_agents_insert" ON instemaq."chat_agents" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_agents_select" ON instemaq."chat_agents";
CREATE POLICY "chat_agents_select" ON instemaq."chat_agents" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_agents_update" ON instemaq."chat_agents";
CREATE POLICY "chat_agents_update" ON instemaq."chat_agents" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_campaign_events ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_campaign_events_delete" ON instemaq."chat_campaign_events";
CREATE POLICY "chat_campaign_events_delete" ON instemaq."chat_campaign_events" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_campaign_events_insert" ON instemaq."chat_campaign_events";
CREATE POLICY "chat_campaign_events_insert" ON instemaq."chat_campaign_events" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_campaign_events_select" ON instemaq."chat_campaign_events";
CREATE POLICY "chat_campaign_events_select" ON instemaq."chat_campaign_events" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_campaign_events_update" ON instemaq."chat_campaign_events";
CREATE POLICY "chat_campaign_events_update" ON instemaq."chat_campaign_events" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_campaign_jobs ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_campaign_jobs_delete" ON instemaq."chat_campaign_jobs";
CREATE POLICY "chat_campaign_jobs_delete" ON instemaq."chat_campaign_jobs" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_campaign_jobs_insert" ON instemaq."chat_campaign_jobs";
CREATE POLICY "chat_campaign_jobs_insert" ON instemaq."chat_campaign_jobs" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_campaign_jobs_select" ON instemaq."chat_campaign_jobs";
CREATE POLICY "chat_campaign_jobs_select" ON instemaq."chat_campaign_jobs" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_campaign_jobs_update" ON instemaq."chat_campaign_jobs";
CREATE POLICY "chat_campaign_jobs_update" ON instemaq."chat_campaign_jobs" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_campaign_recipients ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_campaign_recipients_delete" ON instemaq."chat_campaign_recipients";
CREATE POLICY "chat_campaign_recipients_delete" ON instemaq."chat_campaign_recipients" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_campaign_recipients_insert" ON instemaq."chat_campaign_recipients";
CREATE POLICY "chat_campaign_recipients_insert" ON instemaq."chat_campaign_recipients" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_campaign_recipients_select" ON instemaq."chat_campaign_recipients";
CREATE POLICY "chat_campaign_recipients_select" ON instemaq."chat_campaign_recipients" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_campaign_recipients_update" ON instemaq."chat_campaign_recipients";
CREATE POLICY "chat_campaign_recipients_update" ON instemaq."chat_campaign_recipients" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_campaign_templates ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_campaign_templates_delete" ON instemaq."chat_campaign_templates";
CREATE POLICY "chat_campaign_templates_delete" ON instemaq."chat_campaign_templates" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_campaign_templates_insert" ON instemaq."chat_campaign_templates";
CREATE POLICY "chat_campaign_templates_insert" ON instemaq."chat_campaign_templates" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_campaign_templates_select" ON instemaq."chat_campaign_templates";
CREATE POLICY "chat_campaign_templates_select" ON instemaq."chat_campaign_templates" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_campaign_templates_update" ON instemaq."chat_campaign_templates";
CREATE POLICY "chat_campaign_templates_update" ON instemaq."chat_campaign_templates" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_campaigns ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_campaigns_delete" ON instemaq."chat_campaigns";
CREATE POLICY "chat_campaigns_delete" ON instemaq."chat_campaigns" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_campaigns_insert" ON instemaq."chat_campaigns";
CREATE POLICY "chat_campaigns_insert" ON instemaq."chat_campaigns" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_campaigns_select" ON instemaq."chat_campaigns";
CREATE POLICY "chat_campaigns_select" ON instemaq."chat_campaigns" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_campaigns_update" ON instemaq."chat_campaigns";
CREATE POLICY "chat_campaigns_update" ON instemaq."chat_campaigns" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_channel_quick_replies ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_channel_quick_replies_delete" ON instemaq."chat_channel_quick_replies";
CREATE POLICY "chat_channel_quick_replies_delete" ON instemaq."chat_channel_quick_replies" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_channel_quick_replies_insert" ON instemaq."chat_channel_quick_replies";
CREATE POLICY "chat_channel_quick_replies_insert" ON instemaq."chat_channel_quick_replies" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_channel_quick_replies_select" ON instemaq."chat_channel_quick_replies";
CREATE POLICY "chat_channel_quick_replies_select" ON instemaq."chat_channel_quick_replies" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_channel_quick_replies_update" ON instemaq."chat_channel_quick_replies";
CREATE POLICY "chat_channel_quick_replies_update" ON instemaq."chat_channel_quick_replies" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_channels ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_channels_delete" ON instemaq."chat_channels";
CREATE POLICY "chat_channels_delete" ON instemaq."chat_channels" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_channels_insert" ON instemaq."chat_channels";
CREATE POLICY "chat_channels_insert" ON instemaq."chat_channels" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_channels_select" ON instemaq."chat_channels";
CREATE POLICY "chat_channels_select" ON instemaq."chat_channels" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_channels_update" ON instemaq."chat_channels";
CREATE POLICY "chat_channels_update" ON instemaq."chat_channels" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_comprobante_validaciones ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_comp_val_delete" ON instemaq."chat_comprobante_validaciones";
CREATE POLICY "chat_comp_val_delete" ON instemaq."chat_comprobante_validaciones" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_comp_val_insert" ON instemaq."chat_comprobante_validaciones";
CREATE POLICY "chat_comp_val_insert" ON instemaq."chat_comprobante_validaciones" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_comp_val_select" ON instemaq."chat_comprobante_validaciones";
CREATE POLICY "chat_comp_val_select" ON instemaq."chat_comprobante_validaciones" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_comp_val_update" ON instemaq."chat_comprobante_validaciones";
CREATE POLICY "chat_comp_val_update" ON instemaq."chat_comprobante_validaciones" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_contacts ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_contacts_delete" ON instemaq."chat_contacts";
CREATE POLICY "chat_contacts_delete" ON instemaq."chat_contacts" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_contacts_insert" ON instemaq."chat_contacts";
CREATE POLICY "chat_contacts_insert" ON instemaq."chat_contacts" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_contacts_select" ON instemaq."chat_contacts";
CREATE POLICY "chat_contacts_select" ON instemaq."chat_contacts" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_contacts_update" ON instemaq."chat_contacts";
CREATE POLICY "chat_contacts_update" ON instemaq."chat_contacts" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_conversation_closures ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_conversation_closures_insert" ON instemaq."chat_conversation_closures";
CREATE POLICY "chat_conversation_closures_insert" ON instemaq."chat_conversation_closures" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_conversation_closures_select" ON instemaq."chat_conversation_closures";
CREATE POLICY "chat_conversation_closures_select" ON instemaq."chat_conversation_closures" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_conversations ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_conversations_delete" ON instemaq."chat_conversations";
CREATE POLICY "chat_conversations_delete" ON instemaq."chat_conversations" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_conversations_insert" ON instemaq."chat_conversations";
CREATE POLICY "chat_conversations_insert" ON instemaq."chat_conversations" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_conversations_select" ON instemaq."chat_conversations";
CREATE POLICY "chat_conversations_select" ON instemaq."chat_conversations" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_conversations_update" ON instemaq."chat_conversations";
CREATE POLICY "chat_conversations_update" ON instemaq."chat_conversations" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_empresa_operator_roles ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_empresa_operator_roles_delete" ON instemaq."chat_empresa_operator_roles";
CREATE POLICY "chat_empresa_operator_roles_delete" ON instemaq."chat_empresa_operator_roles" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_empresa_operator_roles_insert" ON instemaq."chat_empresa_operator_roles";
CREATE POLICY "chat_empresa_operator_roles_insert" ON instemaq."chat_empresa_operator_roles" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_empresa_operator_roles_select" ON instemaq."chat_empresa_operator_roles";
CREATE POLICY "chat_empresa_operator_roles_select" ON instemaq."chat_empresa_operator_roles" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_empresa_operator_roles_update" ON instemaq."chat_empresa_operator_roles";
CREATE POLICY "chat_empresa_operator_roles_update" ON instemaq."chat_empresa_operator_roles" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_flow_data ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_flow_data_delete" ON instemaq."chat_flow_data";
CREATE POLICY "chat_flow_data_delete" ON instemaq."chat_flow_data" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_data_insert" ON instemaq."chat_flow_data";
CREATE POLICY "chat_flow_data_insert" ON instemaq."chat_flow_data" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_data_select" ON instemaq."chat_flow_data";
CREATE POLICY "chat_flow_data_select" ON instemaq."chat_flow_data" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_data_update" ON instemaq."chat_flow_data";
CREATE POLICY "chat_flow_data_update" ON instemaq."chat_flow_data" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_flow_events ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_flow_events_delete" ON instemaq."chat_flow_events";
CREATE POLICY "chat_flow_events_delete" ON instemaq."chat_flow_events" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_events_insert" ON instemaq."chat_flow_events";
CREATE POLICY "chat_flow_events_insert" ON instemaq."chat_flow_events" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_events_select" ON instemaq."chat_flow_events";
CREATE POLICY "chat_flow_events_select" ON instemaq."chat_flow_events" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_events_update" ON instemaq."chat_flow_events";
CREATE POLICY "chat_flow_events_update" ON instemaq."chat_flow_events" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_flow_node_blocks ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_flow_node_blocks_delete_empresa" ON instemaq."chat_flow_node_blocks";
CREATE POLICY "chat_flow_node_blocks_delete_empresa" ON instemaq."chat_flow_node_blocks" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_node_blocks_insert_empresa" ON instemaq."chat_flow_node_blocks";
CREATE POLICY "chat_flow_node_blocks_insert_empresa" ON instemaq."chat_flow_node_blocks" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_node_blocks_select_empresa" ON instemaq."chat_flow_node_blocks";
CREATE POLICY "chat_flow_node_blocks_select_empresa" ON instemaq."chat_flow_node_blocks" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_node_blocks_update_empresa" ON instemaq."chat_flow_node_blocks";
CREATE POLICY "chat_flow_node_blocks_update_empresa" ON instemaq."chat_flow_node_blocks" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_flow_nodes ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_flow_nodes_delete" ON instemaq."chat_flow_nodes";
CREATE POLICY "chat_flow_nodes_delete" ON instemaq."chat_flow_nodes" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_nodes_insert" ON instemaq."chat_flow_nodes";
CREATE POLICY "chat_flow_nodes_insert" ON instemaq."chat_flow_nodes" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_nodes_select" ON instemaq."chat_flow_nodes";
CREATE POLICY "chat_flow_nodes_select" ON instemaq."chat_flow_nodes" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_nodes_update" ON instemaq."chat_flow_nodes";
CREATE POLICY "chat_flow_nodes_update" ON instemaq."chat_flow_nodes" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_flow_options ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_flow_options_delete" ON instemaq."chat_flow_options";
CREATE POLICY "chat_flow_options_delete" ON instemaq."chat_flow_options" AS PERMISSIVE FOR DELETE
  USING ((EXISTS ( SELECT 1
   FROM instemaq.chat_flow_nodes n
  WHERE ((n.id = chat_flow_options.node_id) AND instemaq.puede_acceder_empresa(n.empresa_id)))));
DROP POLICY IF EXISTS "chat_flow_options_insert" ON instemaq."chat_flow_options";
CREATE POLICY "chat_flow_options_insert" ON instemaq."chat_flow_options" AS PERMISSIVE FOR INSERT
  WITH CHECK ((EXISTS ( SELECT 1
   FROM instemaq.chat_flow_nodes n
  WHERE ((n.id = chat_flow_options.node_id) AND instemaq.puede_acceder_empresa(n.empresa_id)))));
DROP POLICY IF EXISTS "chat_flow_options_select" ON instemaq."chat_flow_options";
CREATE POLICY "chat_flow_options_select" ON instemaq."chat_flow_options" AS PERMISSIVE FOR SELECT
  USING ((EXISTS ( SELECT 1
   FROM instemaq.chat_flow_nodes n
  WHERE ((n.id = chat_flow_options.node_id) AND instemaq.puede_acceder_empresa(n.empresa_id)))));
DROP POLICY IF EXISTS "chat_flow_options_update" ON instemaq."chat_flow_options";
CREATE POLICY "chat_flow_options_update" ON instemaq."chat_flow_options" AS PERMISSIVE FOR UPDATE
  USING ((EXISTS ( SELECT 1
   FROM instemaq.chat_flow_nodes n
  WHERE ((n.id = chat_flow_options.node_id) AND instemaq.puede_acceder_empresa(n.empresa_id)))))
  WITH CHECK ((EXISTS ( SELECT 1
   FROM instemaq.chat_flow_nodes n
  WHERE ((n.id = chat_flow_options.node_id) AND instemaq.puede_acceder_empresa(n.empresa_id)))));

-- ── chat_flow_recontact_rules ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_flow_recontact_rules_delete" ON instemaq."chat_flow_recontact_rules";
CREATE POLICY "chat_flow_recontact_rules_delete" ON instemaq."chat_flow_recontact_rules" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_recontact_rules_insert" ON instemaq."chat_flow_recontact_rules";
CREATE POLICY "chat_flow_recontact_rules_insert" ON instemaq."chat_flow_recontact_rules" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_recontact_rules_select" ON instemaq."chat_flow_recontact_rules";
CREATE POLICY "chat_flow_recontact_rules_select" ON instemaq."chat_flow_recontact_rules" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_recontact_rules_update" ON instemaq."chat_flow_recontact_rules";
CREATE POLICY "chat_flow_recontact_rules_update" ON instemaq."chat_flow_recontact_rules" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_flow_recontact_runs ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_flow_recontact_runs_delete" ON instemaq."chat_flow_recontact_runs";
CREATE POLICY "chat_flow_recontact_runs_delete" ON instemaq."chat_flow_recontact_runs" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_recontact_runs_insert" ON instemaq."chat_flow_recontact_runs";
CREATE POLICY "chat_flow_recontact_runs_insert" ON instemaq."chat_flow_recontact_runs" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_recontact_runs_select" ON instemaq."chat_flow_recontact_runs";
CREATE POLICY "chat_flow_recontact_runs_select" ON instemaq."chat_flow_recontact_runs" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_recontact_runs_update" ON instemaq."chat_flow_recontact_runs";
CREATE POLICY "chat_flow_recontact_runs_update" ON instemaq."chat_flow_recontact_runs" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_flow_sessions ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_flow_sessions_delete" ON instemaq."chat_flow_sessions";
CREATE POLICY "chat_flow_sessions_delete" ON instemaq."chat_flow_sessions" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_sessions_insert" ON instemaq."chat_flow_sessions";
CREATE POLICY "chat_flow_sessions_insert" ON instemaq."chat_flow_sessions" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_sessions_select" ON instemaq."chat_flow_sessions";
CREATE POLICY "chat_flow_sessions_select" ON instemaq."chat_flow_sessions" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flow_sessions_update" ON instemaq."chat_flow_sessions";
CREATE POLICY "chat_flow_sessions_update" ON instemaq."chat_flow_sessions" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_flows ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_flows_delete" ON instemaq."chat_flows";
CREATE POLICY "chat_flows_delete" ON instemaq."chat_flows" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flows_insert" ON instemaq."chat_flows";
CREATE POLICY "chat_flows_insert" ON instemaq."chat_flows" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flows_select" ON instemaq."chat_flows";
CREATE POLICY "chat_flows_select" ON instemaq."chat_flows" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_flows_update" ON instemaq."chat_flows";
CREATE POLICY "chat_flows_update" ON instemaq."chat_flows" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_messages ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_messages_delete" ON instemaq."chat_messages";
CREATE POLICY "chat_messages_delete" ON instemaq."chat_messages" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_messages_insert" ON instemaq."chat_messages";
CREATE POLICY "chat_messages_insert" ON instemaq."chat_messages" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_messages_select" ON instemaq."chat_messages";
CREATE POLICY "chat_messages_select" ON instemaq."chat_messages" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_messages_update" ON instemaq."chat_messages";
CREATE POLICY "chat_messages_update" ON instemaq."chat_messages" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_omnicanal_work_schedules ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_omn_sched_delete" ON instemaq."chat_omnicanal_work_schedules";
CREATE POLICY "chat_omn_sched_delete" ON instemaq."chat_omnicanal_work_schedules" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_omn_sched_insert" ON instemaq."chat_omnicanal_work_schedules";
CREATE POLICY "chat_omn_sched_insert" ON instemaq."chat_omnicanal_work_schedules" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_omn_sched_select" ON instemaq."chat_omnicanal_work_schedules";
CREATE POLICY "chat_omn_sched_select" ON instemaq."chat_omnicanal_work_schedules" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_omn_sched_update" ON instemaq."chat_omnicanal_work_schedules";
CREATE POLICY "chat_omn_sched_update" ON instemaq."chat_omnicanal_work_schedules" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_queue_channels ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_queue_channels_delete" ON instemaq."chat_queue_channels";
CREATE POLICY "chat_queue_channels_delete" ON instemaq."chat_queue_channels" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_queue_channels_insert" ON instemaq."chat_queue_channels";
CREATE POLICY "chat_queue_channels_insert" ON instemaq."chat_queue_channels" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_queue_channels_select" ON instemaq."chat_queue_channels";
CREATE POLICY "chat_queue_channels_select" ON instemaq."chat_queue_channels" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_queue_channels_update" ON instemaq."chat_queue_channels";
CREATE POLICY "chat_queue_channels_update" ON instemaq."chat_queue_channels" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_queue_closure_states ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_queue_closure_states_delete" ON instemaq."chat_queue_closure_states";
CREATE POLICY "chat_queue_closure_states_delete" ON instemaq."chat_queue_closure_states" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_queue_closure_states_insert" ON instemaq."chat_queue_closure_states";
CREATE POLICY "chat_queue_closure_states_insert" ON instemaq."chat_queue_closure_states" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_queue_closure_states_select" ON instemaq."chat_queue_closure_states";
CREATE POLICY "chat_queue_closure_states_select" ON instemaq."chat_queue_closure_states" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_queue_closure_states_update" ON instemaq."chat_queue_closure_states";
CREATE POLICY "chat_queue_closure_states_update" ON instemaq."chat_queue_closure_states" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_queue_closure_substates ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_queue_closure_substates_delete" ON instemaq."chat_queue_closure_substates";
CREATE POLICY "chat_queue_closure_substates_delete" ON instemaq."chat_queue_closure_substates" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_queue_closure_substates_insert" ON instemaq."chat_queue_closure_substates";
CREATE POLICY "chat_queue_closure_substates_insert" ON instemaq."chat_queue_closure_substates" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_queue_closure_substates_select" ON instemaq."chat_queue_closure_substates";
CREATE POLICY "chat_queue_closure_substates_select" ON instemaq."chat_queue_closure_substates" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_queue_closure_substates_update" ON instemaq."chat_queue_closure_substates";
CREATE POLICY "chat_queue_closure_substates_update" ON instemaq."chat_queue_closure_substates" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_queue_supervisors ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_queue_supervisors_delete" ON instemaq."chat_queue_supervisors";
CREATE POLICY "chat_queue_supervisors_delete" ON instemaq."chat_queue_supervisors" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_queue_supervisors_insert" ON instemaq."chat_queue_supervisors";
CREATE POLICY "chat_queue_supervisors_insert" ON instemaq."chat_queue_supervisors" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_queue_supervisors_select" ON instemaq."chat_queue_supervisors";
CREATE POLICY "chat_queue_supervisors_select" ON instemaq."chat_queue_supervisors" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_queue_supervisors_update" ON instemaq."chat_queue_supervisors";
CREATE POLICY "chat_queue_supervisors_update" ON instemaq."chat_queue_supervisors" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_queues ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_queues_delete" ON instemaq."chat_queues";
CREATE POLICY "chat_queues_delete" ON instemaq."chat_queues" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_queues_insert" ON instemaq."chat_queues";
CREATE POLICY "chat_queues_insert" ON instemaq."chat_queues" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_queues_select" ON instemaq."chat_queues";
CREATE POLICY "chat_queues_select" ON instemaq."chat_queues" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_queues_update" ON instemaq."chat_queues";
CREATE POLICY "chat_queues_update" ON instemaq."chat_queues" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_routing_events ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_routing_events_insert" ON instemaq."chat_routing_events";
CREATE POLICY "chat_routing_events_insert" ON instemaq."chat_routing_events" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_routing_events_select" ON instemaq."chat_routing_events";
CREATE POLICY "chat_routing_events_select" ON instemaq."chat_routing_events" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_supervisor_agents ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_supervisor_agents_delete" ON instemaq."chat_supervisor_agents";
CREATE POLICY "chat_supervisor_agents_delete" ON instemaq."chat_supervisor_agents" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_supervisor_agents_insert" ON instemaq."chat_supervisor_agents";
CREATE POLICY "chat_supervisor_agents_insert" ON instemaq."chat_supervisor_agents" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_supervisor_agents_select" ON instemaq."chat_supervisor_agents";
CREATE POLICY "chat_supervisor_agents_select" ON instemaq."chat_supervisor_agents" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_supervisor_agents_update" ON instemaq."chat_supervisor_agents";
CREATE POLICY "chat_supervisor_agents_update" ON instemaq."chat_supervisor_agents" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── chat_usuario_omnicanal ──────────────────────────────────────────────
DROP POLICY IF EXISTS "chat_usuario_omnicanal_delete" ON instemaq."chat_usuario_omnicanal";
CREATE POLICY "chat_usuario_omnicanal_delete" ON instemaq."chat_usuario_omnicanal" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_usuario_omnicanal_insert" ON instemaq."chat_usuario_omnicanal";
CREATE POLICY "chat_usuario_omnicanal_insert" ON instemaq."chat_usuario_omnicanal" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_usuario_omnicanal_select" ON instemaq."chat_usuario_omnicanal";
CREATE POLICY "chat_usuario_omnicanal_select" ON instemaq."chat_usuario_omnicanal" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "chat_usuario_omnicanal_update" ON instemaq."chat_usuario_omnicanal";
CREATE POLICY "chat_usuario_omnicanal_update" ON instemaq."chat_usuario_omnicanal" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── cliente_historial ──────────────────────────────────────────────
DROP POLICY IF EXISTS "cliente_historial_insert" ON instemaq."cliente_historial";
CREATE POLICY "cliente_historial_insert" ON instemaq."cliente_historial" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "cliente_historial_select" ON instemaq."cliente_historial";
CREATE POLICY "cliente_historial_select" ON instemaq."cliente_historial" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));

-- ── cliente_obligaciones_tributarias ──────────────────────────────────────────────
DROP POLICY IF EXISTS "cliente_obligaciones_tributarias_delete" ON instemaq."cliente_obligaciones_tributarias";
CREATE POLICY "cliente_obligaciones_tributarias_delete" ON instemaq."cliente_obligaciones_tributarias" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "cliente_obligaciones_tributarias_insert" ON instemaq."cliente_obligaciones_tributarias";
CREATE POLICY "cliente_obligaciones_tributarias_insert" ON instemaq."cliente_obligaciones_tributarias" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "cliente_obligaciones_tributarias_select" ON instemaq."cliente_obligaciones_tributarias";
CREATE POLICY "cliente_obligaciones_tributarias_select" ON instemaq."cliente_obligaciones_tributarias" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "cliente_obligaciones_tributarias_update" ON instemaq."cliente_obligaciones_tributarias";
CREATE POLICY "cliente_obligaciones_tributarias_update" ON instemaq."cliente_obligaciones_tributarias" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── cliente_perfil_tributario ──────────────────────────────────────────────
DROP POLICY IF EXISTS "cliente_perfil_tributario_delete" ON instemaq."cliente_perfil_tributario";
CREATE POLICY "cliente_perfil_tributario_delete" ON instemaq."cliente_perfil_tributario" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "cliente_perfil_tributario_insert" ON instemaq."cliente_perfil_tributario";
CREATE POLICY "cliente_perfil_tributario_insert" ON instemaq."cliente_perfil_tributario" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "cliente_perfil_tributario_select" ON instemaq."cliente_perfil_tributario";
CREATE POLICY "cliente_perfil_tributario_select" ON instemaq."cliente_perfil_tributario" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "cliente_perfil_tributario_update" ON instemaq."cliente_perfil_tributario";
CREATE POLICY "cliente_perfil_tributario_update" ON instemaq."cliente_perfil_tributario" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── cliente_tipos_servicio_catalogo ──────────────────────────────────────────────
DROP POLICY IF EXISTS "cliente_tipos_servicio_catalogo_delete" ON instemaq."cliente_tipos_servicio_catalogo";
CREATE POLICY "cliente_tipos_servicio_catalogo_delete" ON instemaq."cliente_tipos_servicio_catalogo" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "cliente_tipos_servicio_catalogo_insert" ON instemaq."cliente_tipos_servicio_catalogo";
CREATE POLICY "cliente_tipos_servicio_catalogo_insert" ON instemaq."cliente_tipos_servicio_catalogo" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "cliente_tipos_servicio_catalogo_select" ON instemaq."cliente_tipos_servicio_catalogo";
CREATE POLICY "cliente_tipos_servicio_catalogo_select" ON instemaq."cliente_tipos_servicio_catalogo" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "cliente_tipos_servicio_catalogo_update" ON instemaq."cliente_tipos_servicio_catalogo";
CREATE POLICY "cliente_tipos_servicio_catalogo_update" ON instemaq."cliente_tipos_servicio_catalogo" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── clientes ──────────────────────────────────────────────
DROP POLICY IF EXISTS "clientes_delete" ON instemaq."clientes";
CREATE POLICY "clientes_delete" ON instemaq."clientes" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "clientes_insert" ON instemaq."clientes";
CREATE POLICY "clientes_insert" ON instemaq."clientes" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "clientes_select" ON instemaq."clientes";
CREATE POLICY "clientes_select" ON instemaq."clientes" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "clientes_update" ON instemaq."clientes";
CREATE POLICY "clientes_update" ON instemaq."clientes" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── comision_ajustes ──────────────────────────────────────────────
DROP POLICY IF EXISTS "comision_ajustes_delete" ON instemaq."comision_ajustes";
CREATE POLICY "comision_ajustes_delete" ON instemaq."comision_ajustes" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_ajustes_insert" ON instemaq."comision_ajustes";
CREATE POLICY "comision_ajustes_insert" ON instemaq."comision_ajustes" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_ajustes_select" ON instemaq."comision_ajustes";
CREATE POLICY "comision_ajustes_select" ON instemaq."comision_ajustes" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_ajustes_update" ON instemaq."comision_ajustes";
CREATE POLICY "comision_ajustes_update" ON instemaq."comision_ajustes" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── comision_equipo_miembros ──────────────────────────────────────────────
DROP POLICY IF EXISTS "comision_equipo_miembros_delete" ON instemaq."comision_equipo_miembros";
CREATE POLICY "comision_equipo_miembros_delete" ON instemaq."comision_equipo_miembros" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_equipo_miembros_insert" ON instemaq."comision_equipo_miembros";
CREATE POLICY "comision_equipo_miembros_insert" ON instemaq."comision_equipo_miembros" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_equipo_miembros_select" ON instemaq."comision_equipo_miembros";
CREATE POLICY "comision_equipo_miembros_select" ON instemaq."comision_equipo_miembros" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_equipo_miembros_update" ON instemaq."comision_equipo_miembros";
CREATE POLICY "comision_equipo_miembros_update" ON instemaq."comision_equipo_miembros" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── comision_equipos ──────────────────────────────────────────────
DROP POLICY IF EXISTS "comision_equipos_delete" ON instemaq."comision_equipos";
CREATE POLICY "comision_equipos_delete" ON instemaq."comision_equipos" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_equipos_insert" ON instemaq."comision_equipos";
CREATE POLICY "comision_equipos_insert" ON instemaq."comision_equipos" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_equipos_select" ON instemaq."comision_equipos";
CREATE POLICY "comision_equipos_select" ON instemaq."comision_equipos" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_equipos_update" ON instemaq."comision_equipos";
CREATE POLICY "comision_equipos_update" ON instemaq."comision_equipos" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── comision_escalas ──────────────────────────────────────────────
DROP POLICY IF EXISTS "comision_escalas_delete" ON instemaq."comision_escalas";
CREATE POLICY "comision_escalas_delete" ON instemaq."comision_escalas" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_escalas_insert" ON instemaq."comision_escalas";
CREATE POLICY "comision_escalas_insert" ON instemaq."comision_escalas" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_escalas_select" ON instemaq."comision_escalas";
CREATE POLICY "comision_escalas_select" ON instemaq."comision_escalas" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_escalas_update" ON instemaq."comision_escalas";
CREATE POLICY "comision_escalas_update" ON instemaq."comision_escalas" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── comision_lineas ──────────────────────────────────────────────
DROP POLICY IF EXISTS "comision_lineas_delete" ON instemaq."comision_lineas";
CREATE POLICY "comision_lineas_delete" ON instemaq."comision_lineas" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_lineas_insert" ON instemaq."comision_lineas";
CREATE POLICY "comision_lineas_insert" ON instemaq."comision_lineas" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_lineas_select" ON instemaq."comision_lineas";
CREATE POLICY "comision_lineas_select" ON instemaq."comision_lineas" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_lineas_update" ON instemaq."comision_lineas";
CREATE POLICY "comision_lineas_update" ON instemaq."comision_lineas" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── comision_periodos ──────────────────────────────────────────────
DROP POLICY IF EXISTS "comision_periodos_delete" ON instemaq."comision_periodos";
CREATE POLICY "comision_periodos_delete" ON instemaq."comision_periodos" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_periodos_insert" ON instemaq."comision_periodos";
CREATE POLICY "comision_periodos_insert" ON instemaq."comision_periodos" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_periodos_select" ON instemaq."comision_periodos";
CREATE POLICY "comision_periodos_select" ON instemaq."comision_periodos" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_periodos_update" ON instemaq."comision_periodos";
CREATE POLICY "comision_periodos_update" ON instemaq."comision_periodos" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── comision_politica_versiones ──────────────────────────────────────────────
DROP POLICY IF EXISTS "comision_politica_versiones_delete" ON instemaq."comision_politica_versiones";
CREATE POLICY "comision_politica_versiones_delete" ON instemaq."comision_politica_versiones" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_politica_versiones_insert" ON instemaq."comision_politica_versiones";
CREATE POLICY "comision_politica_versiones_insert" ON instemaq."comision_politica_versiones" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_politica_versiones_select" ON instemaq."comision_politica_versiones";
CREATE POLICY "comision_politica_versiones_select" ON instemaq."comision_politica_versiones" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_politica_versiones_update" ON instemaq."comision_politica_versiones";
CREATE POLICY "comision_politica_versiones_update" ON instemaq."comision_politica_versiones" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── comision_politicas ──────────────────────────────────────────────
DROP POLICY IF EXISTS "comision_politicas_delete" ON instemaq."comision_politicas";
CREATE POLICY "comision_politicas_delete" ON instemaq."comision_politicas" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_politicas_insert" ON instemaq."comision_politicas";
CREATE POLICY "comision_politicas_insert" ON instemaq."comision_politicas" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_politicas_select" ON instemaq."comision_politicas";
CREATE POLICY "comision_politicas_select" ON instemaq."comision_politicas" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "comision_politicas_update" ON instemaq."comision_politicas";
CREATE POLICY "comision_politicas_update" ON instemaq."comision_politicas" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── compras ──────────────────────────────────────────────
DROP POLICY IF EXISTS "compras_delete" ON instemaq."compras";
CREATE POLICY "compras_delete" ON instemaq."compras" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "compras_insert" ON instemaq."compras";
CREATE POLICY "compras_insert" ON instemaq."compras" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "compras_select" ON instemaq."compras";
CREATE POLICY "compras_select" ON instemaq."compras" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "compras_update" ON instemaq."compras";
CREATE POLICY "compras_update" ON instemaq."compras" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── crm_etapas ──────────────────────────────────────────────
DROP POLICY IF EXISTS "crm_etapas_delete" ON instemaq."crm_etapas";
CREATE POLICY "crm_etapas_delete" ON instemaq."crm_etapas" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "crm_etapas_insert" ON instemaq."crm_etapas";
CREATE POLICY "crm_etapas_insert" ON instemaq."crm_etapas" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "crm_etapas_select" ON instemaq."crm_etapas";
CREATE POLICY "crm_etapas_select" ON instemaq."crm_etapas" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "crm_etapas_update" ON instemaq."crm_etapas";
CREATE POLICY "crm_etapas_update" ON instemaq."crm_etapas" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── crm_notas ──────────────────────────────────────────────
DROP POLICY IF EXISTS "crm_notas_delete" ON instemaq."crm_notas";
CREATE POLICY "crm_notas_delete" ON instemaq."crm_notas" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "crm_notas_insert" ON instemaq."crm_notas";
CREATE POLICY "crm_notas_insert" ON instemaq."crm_notas" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "crm_notas_select" ON instemaq."crm_notas";
CREATE POLICY "crm_notas_select" ON instemaq."crm_notas" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "crm_notas_update" ON instemaq."crm_notas";
CREATE POLICY "crm_notas_update" ON instemaq."crm_notas" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── crm_prospectos ──────────────────────────────────────────────
DROP POLICY IF EXISTS "crm_prospectos_delete" ON instemaq."crm_prospectos";
CREATE POLICY "crm_prospectos_delete" ON instemaq."crm_prospectos" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "crm_prospectos_insert" ON instemaq."crm_prospectos";
CREATE POLICY "crm_prospectos_insert" ON instemaq."crm_prospectos" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "crm_prospectos_select" ON instemaq."crm_prospectos";
CREATE POLICY "crm_prospectos_select" ON instemaq."crm_prospectos" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "crm_prospectos_update" ON instemaq."crm_prospectos";
CREATE POLICY "crm_prospectos_update" ON instemaq."crm_prospectos" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── dashboard_views ──────────────────────────────────────────────
DROP POLICY IF EXISTS "dashboard_views_all_super" ON instemaq."dashboard_views";
CREATE POLICY "dashboard_views_all_super" ON instemaq."dashboard_views" AS PERMISSIVE FOR ALL
  USING (instemaq.es_super_admin())
  WITH CHECK (instemaq.es_super_admin());

-- ── empresa_dashboard_views ──────────────────────────────────────────────
DROP POLICY IF EXISTS "edv_delete" ON instemaq."empresa_dashboard_views";
CREATE POLICY "edv_delete" ON instemaq."empresa_dashboard_views" AS PERMISSIVE FOR DELETE
  USING ((instemaq.es_super_admin() OR instemaq.puede_acceder_empresa(empresa_id)));
DROP POLICY IF EXISTS "edv_mutate" ON instemaq."empresa_dashboard_views";
CREATE POLICY "edv_mutate" ON instemaq."empresa_dashboard_views" AS PERMISSIVE FOR INSERT
  WITH CHECK ((instemaq.es_super_admin() OR instemaq.puede_acceder_empresa(empresa_id)));
DROP POLICY IF EXISTS "edv_select" ON instemaq."empresa_dashboard_views";
CREATE POLICY "edv_select" ON instemaq."empresa_dashboard_views" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "edv_update" ON instemaq."empresa_dashboard_views";
CREATE POLICY "edv_update" ON instemaq."empresa_dashboard_views" AS PERMISSIVE FOR UPDATE
  USING ((instemaq.es_super_admin() OR instemaq.puede_acceder_empresa(empresa_id)))
  WITH CHECK ((instemaq.es_super_admin() OR instemaq.puede_acceder_empresa(empresa_id)));

-- ── empresa_modulos ──────────────────────────────────────────────
DROP POLICY IF EXISTS "empresa_modulos_delete" ON instemaq."empresa_modulos";
CREATE POLICY "empresa_modulos_delete" ON instemaq."empresa_modulos" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "empresa_modulos_insert" ON instemaq."empresa_modulos";
CREATE POLICY "empresa_modulos_insert" ON instemaq."empresa_modulos" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "empresa_modulos_select" ON instemaq."empresa_modulos";
CREATE POLICY "empresa_modulos_select" ON instemaq."empresa_modulos" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "empresa_modulos_update" ON instemaq."empresa_modulos";
CREATE POLICY "empresa_modulos_update" ON instemaq."empresa_modulos" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── empresa_sifen_config ──────────────────────────────────────────────
DROP POLICY IF EXISTS "empresa_sifen_config_delete" ON instemaq."empresa_sifen_config";
CREATE POLICY "empresa_sifen_config_delete" ON instemaq."empresa_sifen_config" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "empresa_sifen_config_insert" ON instemaq."empresa_sifen_config";
CREATE POLICY "empresa_sifen_config_insert" ON instemaq."empresa_sifen_config" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "empresa_sifen_config_select" ON instemaq."empresa_sifen_config";
CREATE POLICY "empresa_sifen_config_select" ON instemaq."empresa_sifen_config" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "empresa_sifen_config_update" ON instemaq."empresa_sifen_config";
CREATE POLICY "empresa_sifen_config_update" ON instemaq."empresa_sifen_config" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── empresas ──────────────────────────────────────────────
DROP POLICY IF EXISTS "empresas_delete" ON instemaq."empresas";
CREATE POLICY "empresas_delete" ON instemaq."empresas" AS PERMISSIVE FOR DELETE
  USING (instemaq.es_super_admin());
DROP POLICY IF EXISTS "empresas_insert" ON instemaq."empresas";
CREATE POLICY "empresas_insert" ON instemaq."empresas" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.es_super_admin());
DROP POLICY IF EXISTS "empresas_select" ON instemaq."empresas";
CREATE POLICY "empresas_select" ON instemaq."empresas" AS PERMISSIVE FOR SELECT
  USING ((instemaq.es_super_admin() OR (id = instemaq.empresa_id_actual())));
DROP POLICY IF EXISTS "empresas_update" ON instemaq."empresas";
CREATE POLICY "empresas_update" ON instemaq."empresas" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(id))
  WITH CHECK (instemaq.puede_acceder_empresa(id));

-- ── entidades_bancarias ──────────────────────────────────────────────
DROP POLICY IF EXISTS "entidades_bancarias_delete" ON instemaq."entidades_bancarias";
CREATE POLICY "entidades_bancarias_delete" ON instemaq."entidades_bancarias" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "entidades_bancarias_insert" ON instemaq."entidades_bancarias";
CREATE POLICY "entidades_bancarias_insert" ON instemaq."entidades_bancarias" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "entidades_bancarias_select" ON instemaq."entidades_bancarias";
CREATE POLICY "entidades_bancarias_select" ON instemaq."entidades_bancarias" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "entidades_bancarias_update" ON instemaq."entidades_bancarias";
CREATE POLICY "entidades_bancarias_update" ON instemaq."entidades_bancarias" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── factura_electronica ──────────────────────────────────────────────
DROP POLICY IF EXISTS "factura_electronica_delete" ON instemaq."factura_electronica";
CREATE POLICY "factura_electronica_delete" ON instemaq."factura_electronica" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "factura_electronica_insert" ON instemaq."factura_electronica";
CREATE POLICY "factura_electronica_insert" ON instemaq."factura_electronica" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "factura_electronica_select" ON instemaq."factura_electronica";
CREATE POLICY "factura_electronica_select" ON instemaq."factura_electronica" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "factura_electronica_update" ON instemaq."factura_electronica";
CREATE POLICY "factura_electronica_update" ON instemaq."factura_electronica" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── factura_electronica_evento ──────────────────────────────────────────────
DROP POLICY IF EXISTS "factura_electronica_evento_delete" ON instemaq."factura_electronica_evento";
CREATE POLICY "factura_electronica_evento_delete" ON instemaq."factura_electronica_evento" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "factura_electronica_evento_insert" ON instemaq."factura_electronica_evento";
CREATE POLICY "factura_electronica_evento_insert" ON instemaq."factura_electronica_evento" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "factura_electronica_evento_select" ON instemaq."factura_electronica_evento";
CREATE POLICY "factura_electronica_evento_select" ON instemaq."factura_electronica_evento" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "factura_electronica_evento_update" ON instemaq."factura_electronica_evento";
CREATE POLICY "factura_electronica_evento_update" ON instemaq."factura_electronica_evento" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── factura_items ──────────────────────────────────────────────
DROP POLICY IF EXISTS "factura_items_delete" ON instemaq."factura_items";
CREATE POLICY "factura_items_delete" ON instemaq."factura_items" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "factura_items_insert" ON instemaq."factura_items";
CREATE POLICY "factura_items_insert" ON instemaq."factura_items" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "factura_items_select" ON instemaq."factura_items";
CREATE POLICY "factura_items_select" ON instemaq."factura_items" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "factura_items_update" ON instemaq."factura_items";
CREATE POLICY "factura_items_update" ON instemaq."factura_items" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── facturas ──────────────────────────────────────────────
DROP POLICY IF EXISTS "facturas_delete" ON instemaq."facturas";
CREATE POLICY "facturas_delete" ON instemaq."facturas" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "facturas_insert" ON instemaq."facturas";
CREATE POLICY "facturas_insert" ON instemaq."facturas" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "facturas_select" ON instemaq."facturas";
CREATE POLICY "facturas_select" ON instemaq."facturas" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "facturas_update" ON instemaq."facturas";
CREATE POLICY "facturas_update" ON instemaq."facturas" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── gastos ──────────────────────────────────────────────
DROP POLICY IF EXISTS "gastos_delete" ON instemaq."gastos";
CREATE POLICY "gastos_delete" ON instemaq."gastos" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "gastos_insert" ON instemaq."gastos";
CREATE POLICY "gastos_insert" ON instemaq."gastos" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "gastos_select" ON instemaq."gastos";
CREATE POLICY "gastos_select" ON instemaq."gastos" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "gastos_update" ON instemaq."gastos";
CREATE POLICY "gastos_update" ON instemaq."gastos" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── marketing_calendarios ──────────────────────────────────────────────
DROP POLICY IF EXISTS "marketing_calendarios_delete" ON instemaq."marketing_calendarios";
CREATE POLICY "marketing_calendarios_delete" ON instemaq."marketing_calendarios" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "marketing_calendarios_insert" ON instemaq."marketing_calendarios";
CREATE POLICY "marketing_calendarios_insert" ON instemaq."marketing_calendarios" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "marketing_calendarios_select" ON instemaq."marketing_calendarios";
CREATE POLICY "marketing_calendarios_select" ON instemaq."marketing_calendarios" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "marketing_calendarios_update" ON instemaq."marketing_calendarios";
CREATE POLICY "marketing_calendarios_update" ON instemaq."marketing_calendarios" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── marketing_comentarios ──────────────────────────────────────────────
DROP POLICY IF EXISTS "marketing_comentarios_delete" ON instemaq."marketing_comentarios";
CREATE POLICY "marketing_comentarios_delete" ON instemaq."marketing_comentarios" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "marketing_comentarios_insert" ON instemaq."marketing_comentarios";
CREATE POLICY "marketing_comentarios_insert" ON instemaq."marketing_comentarios" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "marketing_comentarios_select" ON instemaq."marketing_comentarios";
CREATE POLICY "marketing_comentarios_select" ON instemaq."marketing_comentarios" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "marketing_comentarios_update" ON instemaq."marketing_comentarios";
CREATE POLICY "marketing_comentarios_update" ON instemaq."marketing_comentarios" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── marketing_historial_estados ──────────────────────────────────────────────
DROP POLICY IF EXISTS "marketing_historial_estados_delete" ON instemaq."marketing_historial_estados";
CREATE POLICY "marketing_historial_estados_delete" ON instemaq."marketing_historial_estados" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "marketing_historial_estados_insert" ON instemaq."marketing_historial_estados";
CREATE POLICY "marketing_historial_estados_insert" ON instemaq."marketing_historial_estados" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "marketing_historial_estados_select" ON instemaq."marketing_historial_estados";
CREATE POLICY "marketing_historial_estados_select" ON instemaq."marketing_historial_estados" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "marketing_historial_estados_update" ON instemaq."marketing_historial_estados";
CREATE POLICY "marketing_historial_estados_update" ON instemaq."marketing_historial_estados" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── marketing_piezas ──────────────────────────────────────────────
DROP POLICY IF EXISTS "marketing_piezas_delete" ON instemaq."marketing_piezas";
CREATE POLICY "marketing_piezas_delete" ON instemaq."marketing_piezas" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "marketing_piezas_insert" ON instemaq."marketing_piezas";
CREATE POLICY "marketing_piezas_insert" ON instemaq."marketing_piezas" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "marketing_piezas_select" ON instemaq."marketing_piezas";
CREATE POLICY "marketing_piezas_select" ON instemaq."marketing_piezas" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "marketing_piezas_update" ON instemaq."marketing_piezas";
CREATE POLICY "marketing_piezas_update" ON instemaq."marketing_piezas" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── marketing_tasks ──────────────────────────────────────────────
DROP POLICY IF EXISTS "marketing_tasks_delete" ON instemaq."marketing_tasks";
CREATE POLICY "marketing_tasks_delete" ON instemaq."marketing_tasks" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "marketing_tasks_insert" ON instemaq."marketing_tasks";
CREATE POLICY "marketing_tasks_insert" ON instemaq."marketing_tasks" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "marketing_tasks_select" ON instemaq."marketing_tasks";
CREATE POLICY "marketing_tasks_select" ON instemaq."marketing_tasks" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "marketing_tasks_update" ON instemaq."marketing_tasks";
CREATE POLICY "marketing_tasks_update" ON instemaq."marketing_tasks" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── modulos ──────────────────────────────────────────────
DROP POLICY IF EXISTS "modulos_delete" ON instemaq."modulos";
CREATE POLICY "modulos_delete" ON instemaq."modulos" AS PERMISSIVE FOR DELETE
  USING (instemaq.es_super_admin());
DROP POLICY IF EXISTS "modulos_insert" ON instemaq."modulos";
CREATE POLICY "modulos_insert" ON instemaq."modulos" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.es_super_admin());
DROP POLICY IF EXISTS "modulos_update" ON instemaq."modulos";
CREATE POLICY "modulos_update" ON instemaq."modulos" AS PERMISSIVE FOR UPDATE
  USING (instemaq.es_super_admin())
  WITH CHECK (instemaq.es_super_admin());

-- ── movimientos_inventario ──────────────────────────────────────────────
DROP POLICY IF EXISTS "movimientos_delete" ON instemaq."movimientos_inventario";
CREATE POLICY "movimientos_delete" ON instemaq."movimientos_inventario" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "movimientos_insert" ON instemaq."movimientos_inventario";
CREATE POLICY "movimientos_insert" ON instemaq."movimientos_inventario" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "movimientos_select" ON instemaq."movimientos_inventario";
CREATE POLICY "movimientos_select" ON instemaq."movimientos_inventario" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "movimientos_update" ON instemaq."movimientos_inventario";
CREATE POLICY "movimientos_update" ON instemaq."movimientos_inventario" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── nota_credito ──────────────────────────────────────────────
DROP POLICY IF EXISTS "nota_credito_delete" ON instemaq."nota_credito";
CREATE POLICY "nota_credito_delete" ON instemaq."nota_credito" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "nota_credito_insert" ON instemaq."nota_credito";
CREATE POLICY "nota_credito_insert" ON instemaq."nota_credito" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "nota_credito_select" ON instemaq."nota_credito";
CREATE POLICY "nota_credito_select" ON instemaq."nota_credito" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "nota_credito_update" ON instemaq."nota_credito";
CREATE POLICY "nota_credito_update" ON instemaq."nota_credito" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── nota_credito_electronica ──────────────────────────────────────────────
DROP POLICY IF EXISTS "nota_credito_electronica_delete" ON instemaq."nota_credito_electronica";
CREATE POLICY "nota_credito_electronica_delete" ON instemaq."nota_credito_electronica" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "nota_credito_electronica_insert" ON instemaq."nota_credito_electronica";
CREATE POLICY "nota_credito_electronica_insert" ON instemaq."nota_credito_electronica" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "nota_credito_electronica_select" ON instemaq."nota_credito_electronica";
CREATE POLICY "nota_credito_electronica_select" ON instemaq."nota_credito_electronica" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "nota_credito_electronica_update" ON instemaq."nota_credito_electronica";
CREATE POLICY "nota_credito_electronica_update" ON instemaq."nota_credito_electronica" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── nota_credito_evento ──────────────────────────────────────────────
DROP POLICY IF EXISTS "nota_credito_evento_delete" ON instemaq."nota_credito_evento";
CREATE POLICY "nota_credito_evento_delete" ON instemaq."nota_credito_evento" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "nota_credito_evento_insert" ON instemaq."nota_credito_evento";
CREATE POLICY "nota_credito_evento_insert" ON instemaq."nota_credito_evento" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "nota_credito_evento_select" ON instemaq."nota_credito_evento";
CREATE POLICY "nota_credito_evento_select" ON instemaq."nota_credito_evento" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "nota_credito_evento_update" ON instemaq."nota_credito_evento";
CREATE POLICY "nota_credito_evento_update" ON instemaq."nota_credito_evento" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── pagos ──────────────────────────────────────────────
DROP POLICY IF EXISTS "pagos_delete" ON instemaq."pagos";
CREATE POLICY "pagos_delete" ON instemaq."pagos" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "pagos_insert" ON instemaq."pagos";
CREATE POLICY "pagos_insert" ON instemaq."pagos" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "pagos_select" ON instemaq."pagos";
CREATE POLICY "pagos_select" ON instemaq."pagos" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "pagos_update" ON instemaq."pagos";
CREATE POLICY "pagos_update" ON instemaq."pagos" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── planes ──────────────────────────────────────────────
DROP POLICY IF EXISTS "planes_delete" ON instemaq."planes";
CREATE POLICY "planes_delete" ON instemaq."planes" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "planes_insert" ON instemaq."planes";
CREATE POLICY "planes_insert" ON instemaq."planes" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "planes_select" ON instemaq."planes";
CREATE POLICY "planes_select" ON instemaq."planes" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "planes_update" ON instemaq."planes";
CREATE POLICY "planes_update" ON instemaq."planes" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── productos ──────────────────────────────────────────────
DROP POLICY IF EXISTS "productos_delete" ON instemaq."productos";
CREATE POLICY "productos_delete" ON instemaq."productos" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "productos_insert" ON instemaq."productos";
CREATE POLICY "productos_insert" ON instemaq."productos" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "productos_select" ON instemaq."productos";
CREATE POLICY "productos_select" ON instemaq."productos" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "productos_update" ON instemaq."productos";
CREATE POLICY "productos_update" ON instemaq."productos" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── proveedor_categoria_rel ──────────────────────────────────────────────
DROP POLICY IF EXISTS "proveedor_categoria_rel_delete" ON instemaq."proveedor_categoria_rel";
CREATE POLICY "proveedor_categoria_rel_delete" ON instemaq."proveedor_categoria_rel" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proveedor_categoria_rel_insert" ON instemaq."proveedor_categoria_rel";
CREATE POLICY "proveedor_categoria_rel_insert" ON instemaq."proveedor_categoria_rel" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proveedor_categoria_rel_select" ON instemaq."proveedor_categoria_rel";
CREATE POLICY "proveedor_categoria_rel_select" ON instemaq."proveedor_categoria_rel" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proveedor_categoria_rel_update" ON instemaq."proveedor_categoria_rel";
CREATE POLICY "proveedor_categoria_rel_update" ON instemaq."proveedor_categoria_rel" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── proveedor_categorias ──────────────────────────────────────────────
DROP POLICY IF EXISTS "proveedor_categorias_delete" ON instemaq."proveedor_categorias";
CREATE POLICY "proveedor_categorias_delete" ON instemaq."proveedor_categorias" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proveedor_categorias_insert" ON instemaq."proveedor_categorias";
CREATE POLICY "proveedor_categorias_insert" ON instemaq."proveedor_categorias" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proveedor_categorias_select" ON instemaq."proveedor_categorias";
CREATE POLICY "proveedor_categorias_select" ON instemaq."proveedor_categorias" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proveedor_categorias_update" ON instemaq."proveedor_categorias";
CREATE POLICY "proveedor_categorias_update" ON instemaq."proveedor_categorias" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── proveedor_productos ──────────────────────────────────────────────
DROP POLICY IF EXISTS "proveedor_productos_delete" ON instemaq."proveedor_productos";
CREATE POLICY "proveedor_productos_delete" ON instemaq."proveedor_productos" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proveedor_productos_insert" ON instemaq."proveedor_productos";
CREATE POLICY "proveedor_productos_insert" ON instemaq."proveedor_productos" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proveedor_productos_select" ON instemaq."proveedor_productos";
CREATE POLICY "proveedor_productos_select" ON instemaq."proveedor_productos" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proveedor_productos_update" ON instemaq."proveedor_productos";
CREATE POLICY "proveedor_productos_update" ON instemaq."proveedor_productos" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── proveedores ──────────────────────────────────────────────
DROP POLICY IF EXISTS "proveedores_delete" ON instemaq."proveedores";
CREATE POLICY "proveedores_delete" ON instemaq."proveedores" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proveedores_insert" ON instemaq."proveedores";
CREATE POLICY "proveedores_insert" ON instemaq."proveedores" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proveedores_select" ON instemaq."proveedores";
CREATE POLICY "proveedores_select" ON instemaq."proveedores" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proveedores_update" ON instemaq."proveedores";
CREATE POLICY "proveedores_update" ON instemaq."proveedores" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── proyecto_archivos ──────────────────────────────────────────────
DROP POLICY IF EXISTS "proyecto_archivos_delete" ON instemaq."proyecto_archivos";
CREATE POLICY "proyecto_archivos_delete" ON instemaq."proyecto_archivos" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_archivos_insert" ON instemaq."proyecto_archivos";
CREATE POLICY "proyecto_archivos_insert" ON instemaq."proyecto_archivos" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_archivos_select" ON instemaq."proyecto_archivos";
CREATE POLICY "proyecto_archivos_select" ON instemaq."proyecto_archivos" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_archivos_update" ON instemaq."proyecto_archivos";
CREATE POLICY "proyecto_archivos_update" ON instemaq."proyecto_archivos" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── proyecto_comentarios ──────────────────────────────────────────────
DROP POLICY IF EXISTS "proyecto_comentarios_delete" ON instemaq."proyecto_comentarios";
CREATE POLICY "proyecto_comentarios_delete" ON instemaq."proyecto_comentarios" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_comentarios_insert" ON instemaq."proyecto_comentarios";
CREATE POLICY "proyecto_comentarios_insert" ON instemaq."proyecto_comentarios" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_comentarios_select" ON instemaq."proyecto_comentarios";
CREATE POLICY "proyecto_comentarios_select" ON instemaq."proyecto_comentarios" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_comentarios_update" ON instemaq."proyecto_comentarios";
CREATE POLICY "proyecto_comentarios_update" ON instemaq."proyecto_comentarios" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── proyecto_estado_historial ──────────────────────────────────────────────
DROP POLICY IF EXISTS "proyecto_estado_historial_delete" ON instemaq."proyecto_estado_historial";
CREATE POLICY "proyecto_estado_historial_delete" ON instemaq."proyecto_estado_historial" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_estado_historial_insert" ON instemaq."proyecto_estado_historial";
CREATE POLICY "proyecto_estado_historial_insert" ON instemaq."proyecto_estado_historial" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_estado_historial_select" ON instemaq."proyecto_estado_historial";
CREATE POLICY "proyecto_estado_historial_select" ON instemaq."proyecto_estado_historial" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_estado_historial_update" ON instemaq."proyecto_estado_historial";
CREATE POLICY "proyecto_estado_historial_update" ON instemaq."proyecto_estado_historial" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── proyecto_estados ──────────────────────────────────────────────
DROP POLICY IF EXISTS "proyecto_estados_delete" ON instemaq."proyecto_estados";
CREATE POLICY "proyecto_estados_delete" ON instemaq."proyecto_estados" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_estados_insert" ON instemaq."proyecto_estados";
CREATE POLICY "proyecto_estados_insert" ON instemaq."proyecto_estados" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_estados_select" ON instemaq."proyecto_estados";
CREATE POLICY "proyecto_estados_select" ON instemaq."proyecto_estados" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_estados_update" ON instemaq."proyecto_estados";
CREATE POLICY "proyecto_estados_update" ON instemaq."proyecto_estados" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── proyecto_prioridades_config ──────────────────────────────────────────────
DROP POLICY IF EXISTS "proyecto_prioridades_config_delete" ON instemaq."proyecto_prioridades_config";
CREATE POLICY "proyecto_prioridades_config_delete" ON instemaq."proyecto_prioridades_config" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_prioridades_config_insert" ON instemaq."proyecto_prioridades_config";
CREATE POLICY "proyecto_prioridades_config_insert" ON instemaq."proyecto_prioridades_config" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_prioridades_config_select" ON instemaq."proyecto_prioridades_config";
CREATE POLICY "proyecto_prioridades_config_select" ON instemaq."proyecto_prioridades_config" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_prioridades_config_update" ON instemaq."proyecto_prioridades_config";
CREATE POLICY "proyecto_prioridades_config_update" ON instemaq."proyecto_prioridades_config" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── proyecto_tareas ──────────────────────────────────────────────
DROP POLICY IF EXISTS "proyecto_tareas_delete" ON instemaq."proyecto_tareas";
CREATE POLICY "proyecto_tareas_delete" ON instemaq."proyecto_tareas" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_tareas_insert" ON instemaq."proyecto_tareas";
CREATE POLICY "proyecto_tareas_insert" ON instemaq."proyecto_tareas" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_tareas_select" ON instemaq."proyecto_tareas";
CREATE POLICY "proyecto_tareas_select" ON instemaq."proyecto_tareas" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_tareas_update" ON instemaq."proyecto_tareas";
CREATE POLICY "proyecto_tareas_update" ON instemaq."proyecto_tareas" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── proyecto_tipos ──────────────────────────────────────────────
DROP POLICY IF EXISTS "proyecto_tipos_delete" ON instemaq."proyecto_tipos";
CREATE POLICY "proyecto_tipos_delete" ON instemaq."proyecto_tipos" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_tipos_insert" ON instemaq."proyecto_tipos";
CREATE POLICY "proyecto_tipos_insert" ON instemaq."proyecto_tipos" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_tipos_select" ON instemaq."proyecto_tipos";
CREATE POLICY "proyecto_tipos_select" ON instemaq."proyecto_tipos" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyecto_tipos_update" ON instemaq."proyecto_tipos";
CREATE POLICY "proyecto_tipos_update" ON instemaq."proyecto_tipos" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── proyectos ──────────────────────────────────────────────
DROP POLICY IF EXISTS "proyectos_delete" ON instemaq."proyectos";
CREATE POLICY "proyectos_delete" ON instemaq."proyectos" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyectos_insert" ON instemaq."proyectos";
CREATE POLICY "proyectos_insert" ON instemaq."proyectos" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyectos_select" ON instemaq."proyectos";
CREATE POLICY "proyectos_select" ON instemaq."proyectos" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "proyectos_update" ON instemaq."proyectos";
CREATE POLICY "proyectos_update" ON instemaq."proyectos" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── receta_items ──────────────────────────────────────────────
DROP POLICY IF EXISTS "receta_items_delete" ON instemaq."receta_items";
CREATE POLICY "receta_items_delete" ON instemaq."receta_items" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "receta_items_insert" ON instemaq."receta_items";
CREATE POLICY "receta_items_insert" ON instemaq."receta_items" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "receta_items_select" ON instemaq."receta_items";
CREATE POLICY "receta_items_select" ON instemaq."receta_items" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "receta_items_update" ON instemaq."receta_items";
CREATE POLICY "receta_items_update" ON instemaq."receta_items" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── recetas ──────────────────────────────────────────────
DROP POLICY IF EXISTS "recetas_delete" ON instemaq."recetas";
CREATE POLICY "recetas_delete" ON instemaq."recetas" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "recetas_insert" ON instemaq."recetas";
CREATE POLICY "recetas_insert" ON instemaq."recetas" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "recetas_select" ON instemaq."recetas";
CREATE POLICY "recetas_select" ON instemaq."recetas" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "recetas_update" ON instemaq."recetas";
CREATE POLICY "recetas_update" ON instemaq."recetas" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── sorteo_conversaciones ──────────────────────────────────────────────
DROP POLICY IF EXISTS "sorteo_conv_delete" ON instemaq."sorteo_conversaciones";
CREATE POLICY "sorteo_conv_delete" ON instemaq."sorteo_conversaciones" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteo_conv_insert" ON instemaq."sorteo_conversaciones";
CREATE POLICY "sorteo_conv_insert" ON instemaq."sorteo_conversaciones" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteo_conv_select" ON instemaq."sorteo_conversaciones";
CREATE POLICY "sorteo_conv_select" ON instemaq."sorteo_conversaciones" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteo_conv_update" ON instemaq."sorteo_conversaciones";
CREATE POLICY "sorteo_conv_update" ON instemaq."sorteo_conversaciones" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── sorteo_cupones ──────────────────────────────────────────────
DROP POLICY IF EXISTS "sorteo_cup_delete" ON instemaq."sorteo_cupones";
CREATE POLICY "sorteo_cup_delete" ON instemaq."sorteo_cupones" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteo_cup_insert" ON instemaq."sorteo_cupones";
CREATE POLICY "sorteo_cup_insert" ON instemaq."sorteo_cupones" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteo_cup_select" ON instemaq."sorteo_cupones";
CREATE POLICY "sorteo_cup_select" ON instemaq."sorteo_cupones" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteo_cup_update" ON instemaq."sorteo_cupones";
CREATE POLICY "sorteo_cup_update" ON instemaq."sorteo_cupones" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── sorteo_entradas ──────────────────────────────────────────────
DROP POLICY IF EXISTS "sorteo_ent_delete" ON instemaq."sorteo_entradas";
CREATE POLICY "sorteo_ent_delete" ON instemaq."sorteo_entradas" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteo_ent_insert" ON instemaq."sorteo_entradas";
CREATE POLICY "sorteo_ent_insert" ON instemaq."sorteo_entradas" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteo_ent_select" ON instemaq."sorteo_entradas";
CREATE POLICY "sorteo_ent_select" ON instemaq."sorteo_entradas" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteo_ent_update" ON instemaq."sorteo_entradas";
CREATE POLICY "sorteo_ent_update" ON instemaq."sorteo_entradas" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── sorteo_revendedor_clicks ──────────────────────────────────────────────
DROP POLICY IF EXISTS "sorteo_rev_clicks_delete" ON instemaq."sorteo_revendedor_clicks";
CREATE POLICY "sorteo_rev_clicks_delete" ON instemaq."sorteo_revendedor_clicks" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteo_rev_clicks_insert" ON instemaq."sorteo_revendedor_clicks";
CREATE POLICY "sorteo_rev_clicks_insert" ON instemaq."sorteo_revendedor_clicks" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteo_rev_clicks_select" ON instemaq."sorteo_revendedor_clicks";
CREATE POLICY "sorteo_rev_clicks_select" ON instemaq."sorteo_revendedor_clicks" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteo_rev_clicks_update" ON instemaq."sorteo_revendedor_clicks";
CREATE POLICY "sorteo_rev_clicks_update" ON instemaq."sorteo_revendedor_clicks" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── sorteo_revendedores ──────────────────────────────────────────────
DROP POLICY IF EXISTS "sorteo_rev_delete" ON instemaq."sorteo_revendedores";
CREATE POLICY "sorteo_rev_delete" ON instemaq."sorteo_revendedores" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteo_rev_insert" ON instemaq."sorteo_revendedores";
CREATE POLICY "sorteo_rev_insert" ON instemaq."sorteo_revendedores" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteo_rev_select" ON instemaq."sorteo_revendedores";
CREATE POLICY "sorteo_rev_select" ON instemaq."sorteo_revendedores" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteo_rev_update" ON instemaq."sorteo_revendedores";
CREATE POLICY "sorteo_rev_update" ON instemaq."sorteo_revendedores" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── sorteo_ticket_deliveries ──────────────────────────────────────────────
DROP POLICY IF EXISTS "sorteo_ticket_deliveries_delete" ON instemaq."sorteo_ticket_deliveries";
CREATE POLICY "sorteo_ticket_deliveries_delete" ON instemaq."sorteo_ticket_deliveries" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteo_ticket_deliveries_insert" ON instemaq."sorteo_ticket_deliveries";
CREATE POLICY "sorteo_ticket_deliveries_insert" ON instemaq."sorteo_ticket_deliveries" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteo_ticket_deliveries_select" ON instemaq."sorteo_ticket_deliveries";
CREATE POLICY "sorteo_ticket_deliveries_select" ON instemaq."sorteo_ticket_deliveries" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteo_ticket_deliveries_update" ON instemaq."sorteo_ticket_deliveries";
CREATE POLICY "sorteo_ticket_deliveries_update" ON instemaq."sorteo_ticket_deliveries" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── sorteos ──────────────────────────────────────────────
DROP POLICY IF EXISTS "sorteos_delete" ON instemaq."sorteos";
CREATE POLICY "sorteos_delete" ON instemaq."sorteos" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteos_insert" ON instemaq."sorteos";
CREATE POLICY "sorteos_insert" ON instemaq."sorteos" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteos_select" ON instemaq."sorteos";
CREATE POLICY "sorteos_select" ON instemaq."sorteos" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "sorteos_update" ON instemaq."sorteos";
CREATE POLICY "sorteos_update" ON instemaq."sorteos" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── suscripciones ──────────────────────────────────────────────
DROP POLICY IF EXISTS "suscripciones_delete" ON instemaq."suscripciones";
CREATE POLICY "suscripciones_delete" ON instemaq."suscripciones" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "suscripciones_insert" ON instemaq."suscripciones";
CREATE POLICY "suscripciones_insert" ON instemaq."suscripciones" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "suscripciones_select" ON instemaq."suscripciones";
CREATE POLICY "suscripciones_select" ON instemaq."suscripciones" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "suscripciones_update" ON instemaq."suscripciones";
CREATE POLICY "suscripciones_update" ON instemaq."suscripciones" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── tipificaciones ──────────────────────────────────────────────
DROP POLICY IF EXISTS "tipificaciones_delete" ON instemaq."tipificaciones";
CREATE POLICY "tipificaciones_delete" ON instemaq."tipificaciones" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "tipificaciones_insert" ON instemaq."tipificaciones";
CREATE POLICY "tipificaciones_insert" ON instemaq."tipificaciones" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "tipificaciones_select" ON instemaq."tipificaciones";
CREATE POLICY "tipificaciones_select" ON instemaq."tipificaciones" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "tipificaciones_update" ON instemaq."tipificaciones";
CREATE POLICY "tipificaciones_update" ON instemaq."tipificaciones" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── usuario_dashboard_views ──────────────────────────────────────────────
DROP POLICY IF EXISTS "udv_delete" ON instemaq."usuario_dashboard_views";
CREATE POLICY "udv_delete" ON instemaq."usuario_dashboard_views" AS PERMISSIVE FOR DELETE
  USING ((instemaq.es_super_admin() OR (EXISTS ( SELECT 1
   FROM (instemaq.usuarios ua
     JOIN instemaq.usuarios ut ON ((ut.id = usuario_dashboard_views.usuario_id)))
  WHERE ((lower(TRIM(BOTH FROM COALESCE(ua.email, ''::text))) = lower(TRIM(BOTH FROM COALESCE((auth.jwt() ->> 'email'::text), ''::text)))) AND (ua.empresa_id IS NOT NULL) AND (ua.empresa_id = ut.empresa_id) AND (COALESCE(ua.rol, ''::text) = ANY (ARRAY['admin'::text, 'administrador'::text])))))));
DROP POLICY IF EXISTS "udv_insert" ON instemaq."usuario_dashboard_views";
CREATE POLICY "udv_insert" ON instemaq."usuario_dashboard_views" AS PERMISSIVE FOR INSERT
  WITH CHECK ((instemaq.es_super_admin() OR (EXISTS ( SELECT 1
   FROM (instemaq.usuarios ua
     JOIN instemaq.usuarios ut ON ((ut.id = usuario_dashboard_views.usuario_id)))
  WHERE ((lower(TRIM(BOTH FROM COALESCE(ua.email, ''::text))) = lower(TRIM(BOTH FROM COALESCE((auth.jwt() ->> 'email'::text), ''::text)))) AND (ua.empresa_id IS NOT NULL) AND (ua.empresa_id = ut.empresa_id) AND (COALESCE(ua.rol, ''::text) = ANY (ARRAY['admin'::text, 'administrador'::text])))))));
DROP POLICY IF EXISTS "udv_select" ON instemaq."usuario_dashboard_views";
CREATE POLICY "udv_select" ON instemaq."usuario_dashboard_views" AS PERMISSIVE FOR SELECT
  USING ((instemaq.es_super_admin() OR (usuario_id IN ( SELECT usuarios.id
   FROM instemaq.usuarios
  WHERE (lower(TRIM(BOTH FROM COALESCE(usuarios.email, ''::text))) = lower(TRIM(BOTH FROM COALESCE((auth.jwt() ->> 'email'::text), ''::text))))))));
DROP POLICY IF EXISTS "udv_update" ON instemaq."usuario_dashboard_views";
CREATE POLICY "udv_update" ON instemaq."usuario_dashboard_views" AS PERMISSIVE FOR UPDATE
  USING ((instemaq.es_super_admin() OR (EXISTS ( SELECT 1
   FROM (instemaq.usuarios ua
     JOIN instemaq.usuarios ut ON ((ut.id = usuario_dashboard_views.usuario_id)))
  WHERE ((lower(TRIM(BOTH FROM COALESCE(ua.email, ''::text))) = lower(TRIM(BOTH FROM COALESCE((auth.jwt() ->> 'email'::text), ''::text)))) AND (ua.empresa_id IS NOT NULL) AND (ua.empresa_id = ut.empresa_id) AND (COALESCE(ua.rol, ''::text) = ANY (ARRAY['admin'::text, 'administrador'::text])))))))
  WITH CHECK ((instemaq.es_super_admin() OR (EXISTS ( SELECT 1
   FROM (instemaq.usuarios ua
     JOIN instemaq.usuarios ut ON ((ut.id = usuario_dashboard_views.usuario_id)))
  WHERE ((lower(TRIM(BOTH FROM COALESCE(ua.email, ''::text))) = lower(TRIM(BOTH FROM COALESCE((auth.jwt() ->> 'email'::text), ''::text)))) AND (ua.empresa_id IS NOT NULL) AND (ua.empresa_id = ut.empresa_id) AND (COALESCE(ua.rol, ''::text) = ANY (ARRAY['admin'::text, 'administrador'::text])))))));

-- ── usuario_modulos ──────────────────────────────────────────────
DROP POLICY IF EXISTS "usuario_modulos_delete" ON instemaq."usuario_modulos";
CREATE POLICY "usuario_modulos_delete" ON instemaq."usuario_modulos" AS PERMISSIVE FOR DELETE
  USING ((instemaq.es_super_admin() OR (EXISTS ( SELECT 1
   FROM (instemaq.usuarios ua
     JOIN instemaq.usuarios ut ON ((ut.id = usuario_modulos.usuario_id)))
  WHERE ((lower(TRIM(BOTH FROM COALESCE(ua.email, ''::text))) = instemaq.jwt_email_normalized()) AND (ua.empresa_id IS NOT NULL) AND (ua.empresa_id = ut.empresa_id) AND (COALESCE(ua.rol, ''::text) = ANY (ARRAY['admin'::text, 'administrador'::text])))))));
DROP POLICY IF EXISTS "usuario_modulos_insert" ON instemaq."usuario_modulos";
CREATE POLICY "usuario_modulos_insert" ON instemaq."usuario_modulos" AS PERMISSIVE FOR INSERT
  WITH CHECK ((instemaq.es_super_admin() OR (EXISTS ( SELECT 1
   FROM (instemaq.usuarios ua
     JOIN instemaq.usuarios ut ON ((ut.id = usuario_modulos.usuario_id)))
  WHERE ((lower(TRIM(BOTH FROM COALESCE(ua.email, ''::text))) = instemaq.jwt_email_normalized()) AND (ua.empresa_id IS NOT NULL) AND (ua.empresa_id = ut.empresa_id) AND (COALESCE(ua.rol, ''::text) = ANY (ARRAY['admin'::text, 'administrador'::text])))))));
DROP POLICY IF EXISTS "usuario_modulos_select" ON instemaq."usuario_modulos";
CREATE POLICY "usuario_modulos_select" ON instemaq."usuario_modulos" AS PERMISSIVE FOR SELECT
  USING ((instemaq.es_super_admin() OR (usuario_id IN ( SELECT usuarios.id
   FROM instemaq.usuarios
  WHERE (lower(TRIM(BOTH FROM COALESCE(usuarios.email, ''::text))) = instemaq.jwt_email_normalized())))));
DROP POLICY IF EXISTS "usuario_modulos_update" ON instemaq."usuario_modulos";
CREATE POLICY "usuario_modulos_update" ON instemaq."usuario_modulos" AS PERMISSIVE FOR UPDATE
  USING ((instemaq.es_super_admin() OR (EXISTS ( SELECT 1
   FROM (instemaq.usuarios ua
     JOIN instemaq.usuarios ut ON ((ut.id = usuario_modulos.usuario_id)))
  WHERE ((lower(TRIM(BOTH FROM COALESCE(ua.email, ''::text))) = instemaq.jwt_email_normalized()) AND (ua.empresa_id IS NOT NULL) AND (ua.empresa_id = ut.empresa_id) AND (COALESCE(ua.rol, ''::text) = ANY (ARRAY['admin'::text, 'administrador'::text])))))))
  WITH CHECK ((instemaq.es_super_admin() OR (EXISTS ( SELECT 1
   FROM (instemaq.usuarios ua
     JOIN instemaq.usuarios ut ON ((ut.id = usuario_modulos.usuario_id)))
  WHERE ((lower(TRIM(BOTH FROM COALESCE(ua.email, ''::text))) = instemaq.jwt_email_normalized()) AND (ua.empresa_id IS NOT NULL) AND (ua.empresa_id = ut.empresa_id) AND (COALESCE(ua.rol, ''::text) = ANY (ARRAY['admin'::text, 'administrador'::text])))))));

-- ── usuarios ──────────────────────────────────────────────
DROP POLICY IF EXISTS "usuarios_delete" ON instemaq."usuarios";
CREATE POLICY "usuarios_delete" ON instemaq."usuarios" AS PERMISSIVE FOR DELETE
  USING (instemaq.es_super_admin());
DROP POLICY IF EXISTS "usuarios_insert" ON instemaq."usuarios";
CREATE POLICY "usuarios_insert" ON instemaq."usuarios" AS PERMISSIVE FOR INSERT
  WITH CHECK ((instemaq.es_super_admin() OR ((empresa_id = instemaq.empresa_id_actual()) AND (empresa_id IS NOT NULL))));
DROP POLICY IF EXISTS "usuarios_select" ON instemaq."usuarios";
CREATE POLICY "usuarios_select" ON instemaq."usuarios" AS PERMISSIVE FOR SELECT
  USING ((instemaq.es_super_admin() OR (empresa_id = instemaq.empresa_id_actual()) OR ((empresa_id IS NULL) AND (rol = 'super_admin'::text)) OR (auth_user_id = auth.uid())));
DROP POLICY IF EXISTS "usuarios_update" ON instemaq."usuarios";
CREATE POLICY "usuarios_update" ON instemaq."usuarios" AS PERMISSIVE FOR UPDATE
  USING ((instemaq.es_super_admin() OR (empresa_id = instemaq.empresa_id_actual()) OR ((empresa_id IS NULL) AND (rol = 'super_admin'::text))))
  WITH CHECK ((instemaq.es_super_admin() OR (empresa_id = instemaq.empresa_id_actual()) OR ((empresa_id IS NULL) AND (rol = 'super_admin'::text))));

-- ── ventas ──────────────────────────────────────────────
DROP POLICY IF EXISTS "ventas_delete" ON instemaq."ventas";
CREATE POLICY "ventas_delete" ON instemaq."ventas" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "ventas_insert" ON instemaq."ventas";
CREATE POLICY "ventas_insert" ON instemaq."ventas" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "ventas_select" ON instemaq."ventas";
CREATE POLICY "ventas_select" ON instemaq."ventas" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "ventas_update" ON instemaq."ventas";
CREATE POLICY "ventas_update" ON instemaq."ventas" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── ventas_items ──────────────────────────────────────────────
DROP POLICY IF EXISTS "ventas_items_delete" ON instemaq."ventas_items";
CREATE POLICY "ventas_items_delete" ON instemaq."ventas_items" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "ventas_items_insert" ON instemaq."ventas_items";
CREATE POLICY "ventas_items_insert" ON instemaq."ventas_items" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "ventas_items_select" ON instemaq."ventas_items";
CREATE POLICY "ventas_items_select" ON instemaq."ventas_items" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "ventas_items_update" ON instemaq."ventas_items";
CREATE POLICY "ventas_items_update" ON instemaq."ventas_items" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

-- ── ventas_pagos_detalle ──────────────────────────────────────────────
DROP POLICY IF EXISTS "ventas_pagos_detalle_delete" ON instemaq."ventas_pagos_detalle";
CREATE POLICY "ventas_pagos_detalle_delete" ON instemaq."ventas_pagos_detalle" AS PERMISSIVE FOR DELETE
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "ventas_pagos_detalle_insert" ON instemaq."ventas_pagos_detalle";
CREATE POLICY "ventas_pagos_detalle_insert" ON instemaq."ventas_pagos_detalle" AS PERMISSIVE FOR INSERT
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "ventas_pagos_detalle_select" ON instemaq."ventas_pagos_detalle";
CREATE POLICY "ventas_pagos_detalle_select" ON instemaq."ventas_pagos_detalle" AS PERMISSIVE FOR SELECT
  USING (instemaq.puede_acceder_empresa(empresa_id));
DROP POLICY IF EXISTS "ventas_pagos_detalle_update" ON instemaq."ventas_pagos_detalle";
CREATE POLICY "ventas_pagos_detalle_update" ON instemaq."ventas_pagos_detalle" AS PERMISSIVE FOR UPDATE
  USING (instemaq.puede_acceder_empresa(empresa_id))
  WITH CHECK (instemaq.puede_acceder_empresa(empresa_id));

COMMIT;

-- =============================================================================
-- Verificación: debe devolver 0 policies con referencias a otro tenant
-- =============================================================================
SELECT count(*) AS policies_apuntando_a_otro_tenant
FROM pg_policy pol
JOIN pg_class cl ON cl.oid = pol.polrelid
JOIN pg_namespace n ON n.oid = cl.relnamespace
WHERE n.nspname = 'instemaq'
  AND (coalesce(pg_get_expr(pol.polqual, pol.polrelid), '') LIKE '%reservacaacupe.%'
    OR coalesce(pg_get_expr(pol.polwithcheck, pol.polrelid), '') LIKE '%reservacaacupe.%');
