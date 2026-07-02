-- ============================================================
--  Tabla de confirmaciones para la invitación Moana
--  Pega este script en:  Supabase → SQL Editor → Run
-- ============================================================

create table if not exists public.confirmaciones_moana (
  id          bigint generated always as identity primary key,
  name        text        not null,
  phone       text        not null unique,   -- 10 dígitos; único para poder actualizar
  attending   boolean     not null default true,
  party_size  int         not null default 1,
  lang        text        default 'es',
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

alter table public.confirmaciones_moana enable row level security;

-- Cualquier invitado puede confirmar (insert) y corregir su respuesta (update)
drop policy if exists "moana anon insert" on public.confirmaciones_moana;
create policy "moana anon insert"
  on public.confirmaciones_moana for insert to anon with check (true);

drop policy if exists "moana anon update" on public.confirmaciones_moana;
create policy "moana anon update"
  on public.confirmaciones_moana for update to anon using (true) with check (true);

-- Lectura para el dashboard.
-- NOTA: con esta política, cualquiera con la llave pública puede leer las confirmaciones.
-- Para una fiesta está bien; si quieres blindarlo, quita esta policy y lee con la service_role
-- desde un backend, o protege el dashboard con Supabase Auth.
drop policy if exists "moana anon select" on public.confirmaciones_moana;
create policy "moana anon select"
  on public.confirmaciones_moana for select to anon using (true);
