-- ============================================================
-- SCOREED — Supabase Schema Migration
-- ============================================================

-- Tabla legacy arbitros (referenciada por partidos.id_arbitro y profiles.id_arbitro_ref)
CREATE TABLE IF NOT EXISTS public.arbitros (
  id_arbitro SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL DEFAULT ''
);

-- Funciones RPC para crear/eliminar árbitros desde el panel admin
CREATE OR REPLACE FUNCTION public.create_arbitro(
  p_email TEXT, p_password TEXT, p_nombre TEXT
) RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path = 'public' AS $$
DECLARE v_user_id UUID; v_encrypted_pw TEXT; v_arbitro_id INTEGER;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND rol = 'admin') THEN
    RETURN jsonb_build_object('error', 'Solo administradores pueden crear árbitros');
  END IF;
  v_user_id := extensions.gen_random_uuid();
  v_encrypted_pw := extensions.crypt(p_password, extensions.gen_salt('bf'));
  INSERT INTO auth.users (id, instance_id, email, encrypted_password, email_confirmed_at, confirmation_sent_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, aud, role, is_sso_user)
    VALUES (v_user_id, '00000000-0000-0000-0000-000000000000', p_email, v_encrypted_pw, NOW(), NOW(), '{"provider":"email","providers":["email"]}', jsonb_build_object('nombre', p_nombre, 'rol', 'arbitro'), NOW(), NOW(), 'authenticated', 'authenticated', false);
  INSERT INTO public.arbitros (nombre) VALUES (p_nombre) RETURNING id_arbitro INTO v_arbitro_id;
  INSERT INTO public.profiles (id, email, nombre, rol, id_arbitro_ref)
    VALUES (v_user_id, p_email, p_nombre, 'arbitro', v_arbitro_id)
    ON CONFLICT (id) DO UPDATE SET id_arbitro_ref = v_arbitro_id;
  RETURN jsonb_build_object('id', v_user_id::TEXT, 'email', p_email, 'id_arbitro', v_arbitro_id);
END; $$;

CREATE OR REPLACE FUNCTION public.delete_arbitro(p_user_id UUID)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path = 'public' AS $$
DECLARE v_ref INTEGER;
BEGIN
  SELECT id_arbitro_ref INTO v_ref FROM public.profiles WHERE id = p_user_id;
  IF NOT EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND rol = 'admin') THEN
    RETURN jsonb_build_object('error', 'Solo administradores pueden eliminar árbitros');
  END IF;
  DELETE FROM public.profiles WHERE id = p_user_id;
  DELETE FROM auth.users WHERE id = p_user_id;
  IF v_ref IS NOT NULL THEN DELETE FROM public.arbitros WHERE id_arbitro = v_ref; END IF;
  RETURN jsonb_build_object('deleted', true);
END; $$;

GRANT EXECUTE ON FUNCTION public.create_arbitro TO authenticated;
GRANT EXECUTE ON FUNCTION public.delete_arbitro TO authenticated;

-- Fix RLS: perfiles visibles para todos los autenticados (admin necesita ver árbitros)
DROP POLICY IF EXISTS "Users view own profile" ON public.profiles;
CREATE POLICY "Profiles select for authenticated" ON public.profiles FOR SELECT USING (auth.role() = 'authenticated');

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS public.deportes (
  id_deporte SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL,
  tiene_empate BOOLEAN NOT NULL DEFAULT TRUE,
  unidad_marcador TEXT NOT NULL DEFAULT 'puntos'
);

CREATE TABLE IF NOT EXISTS public.reglas_puntos (
  id_regla SERIAL PRIMARY KEY,
  id_deporte INTEGER NOT NULL REFERENCES public.deportes(id_deporte) ON DELETE CASCADE,
  resultado TEXT NOT NULL CHECK (resultado IN ('victoria','empate','derrota')),
  puntos INTEGER NOT NULL DEFAULT 0,
  UNIQUE(id_deporte, resultado)
);

CREATE TABLE IF NOT EXISTS public.cursos (
  id_curso SERIAL PRIMARY KEY,
  anio INTEGER,
  division INTEGER
);

CREATE TABLE IF NOT EXISTS public.estados (
  id_estado SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS public.torneos (
  id_torneo SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL DEFAULT '',
  anio INTEGER DEFAULT 2026,
  descripcion TEXT DEFAULT '',
  id_deporte INTEGER NOT NULL DEFAULT 1 REFERENCES public.deportes(id_deporte) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS public.equipos (
  id_equipo SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL DEFAULT '',
  id_torneo INTEGER REFERENCES public.torneos(id_torneo) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.participantes (
  id_participante SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL DEFAULT '',
  apellido TEXT NOT NULL DEFAULT '',
  dni TEXT DEFAULT ''
);

CREATE TABLE IF NOT EXISTS public.plantilla (
  id_plantilla SERIAL PRIMARY KEY,
  id_equipo INTEGER REFERENCES public.equipos(id_equipo) ON DELETE CASCADE,
  id_participante INTEGER REFERENCES public.participantes(id_participante) ON DELETE CASCADE,
  id_curso INTEGER REFERENCES public.cursos(id_curso) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS public.tipos_evento (
  id_tipo_evento SERIAL PRIMARY KEY,
  id_deporte INTEGER NOT NULL DEFAULT 1 REFERENCES public.deportes(id_deporte) ON DELETE CASCADE,
  nombre TEXT NOT NULL,
  afecta_marcador BOOLEAN NOT NULL DEFAULT FALSE,
  valor INTEGER NOT NULL DEFAULT 0,
  afecta_propio BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS public.partidos (
  id_partido SERIAL PRIMARY KEY,
  id_equipo_local INTEGER REFERENCES public.equipos(id_equipo) ON DELETE CASCADE,
  id_equipo_visitante INTEGER REFERENCES public.equipos(id_equipo) ON DELETE CASCADE,
  id_torneo INTEGER REFERENCES public.torneos(id_torneo) ON DELETE CASCADE,
  fecha DATE,
  marcador_local INTEGER DEFAULT NULL,
  marcador_visitante INTEGER DEFAULT NULL,
  id_arbitro INTEGER,
  id_estado INTEGER REFERENCES public.estados(id_estado) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS public.eventos_partido (
  id_evento SERIAL PRIMARY KEY,
  id_partido INTEGER REFERENCES public.partidos(id_partido) ON DELETE CASCADE,
  id_participante INTEGER REFERENCES public.participantes(id_participante) ON DELETE SET NULL,
  id_tipo_evento INTEGER REFERENCES public.tipos_evento(id_tipo_evento) ON UPDATE CASCADE,
  minuto INTEGER DEFAULT NULL,
  comentarios TEXT DEFAULT '',
  equipo_rol TEXT DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  nombre TEXT DEFAULT '',
  rol TEXT NOT NULL CHECK (rol IN ('admin','arbitro')) DEFAULT 'arbitro',
  id_arbitro_ref INTEGER DEFAULT NULL,
  foto_url TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, nombre, rol, id_arbitro_ref)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'nombre', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.raw_user_meta_data->>'rol', 'arbitro'),
    (NEW.raw_user_meta_data->>'id_arbitro')::INTEGER
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

ALTER TABLE public.deportes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reglas_puntos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cursos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.estados ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.torneos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.equipos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.participantes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.plantilla ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tipos_evento ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.partidos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.eventos_partido ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Lectura autenticados" ON public.deportes FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Lectura autenticados" ON public.reglas_puntos FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Lectura autenticados" ON public.cursos FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Lectura autenticados" ON public.estados FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Lectura autenticados" ON public.torneos FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Lectura autenticados" ON public.equipos FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Lectura autenticados" ON public.participantes FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Lectura autenticados" ON public.plantilla FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Lectura autenticados" ON public.tipos_evento FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Lectura autenticados" ON public.partidos FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Lectura autenticados" ON public.eventos_partido FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Admin full access" ON public.deportes FOR ALL USING (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND rol = 'admin')
);
CREATE POLICY "Admin full access" ON public.torneos FOR ALL USING (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND rol = 'admin')
);
CREATE POLICY "Admin full access" ON public.equipos FOR ALL USING (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND rol = 'admin')
);
CREATE POLICY "Admin full access" ON public.participantes FOR ALL USING (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND rol = 'admin')
);
CREATE POLICY "Admin full access" ON public.plantilla FOR ALL USING (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND rol = 'admin')
);
CREATE POLICY "Admin full access" ON public.cursos FOR ALL USING (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND rol = 'admin')
);
CREATE POLICY "Admin full access" ON public.reglas_puntos FOR ALL USING (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND rol = 'admin')
);
CREATE POLICY "Admin full access" ON public.tipos_evento FOR ALL USING (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND rol = 'admin')
);
CREATE POLICY "Admin full access" ON public.partidos FOR ALL USING (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND rol = 'admin')
);
CREATE POLICY "Admin full access" ON public.eventos_partido FOR ALL USING (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND rol = 'admin')
);

CREATE POLICY "Arbitro insert eventos" ON public.eventos_partido FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND rol = 'arbitro')
);
CREATE POLICY "Arbitro delete eventos" ON public.eventos_partido FOR DELETE USING (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND rol = 'arbitro')
);
CREATE POLICY "Arbitro update estado partido" ON public.partidos FOR UPDATE USING (
  id_arbitro = (SELECT id_arbitro_ref FROM public.profiles WHERE id = auth.uid())
);

CREATE POLICY "Users view own profile" ON public.profiles FOR SELECT USING (id = auth.uid());
CREATE POLICY "Users update own profile" ON public.profiles FOR UPDATE USING (id = auth.uid());
