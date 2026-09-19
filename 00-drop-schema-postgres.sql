-- ============================================
-- DROP SCHEMA PostgreSQL — Assessment Platform
-- Ejecutar: psql -U postgres -d postgres -f 00-drop-schema-postgres.sql
-- Orden inverso por dependencias (FK)
-- ============================================

SET search_path TO assessment_platform;

DROP TABLE IF EXISTS respuestas_candidato CASCADE;
DROP TABLE IF EXISTS intentos_examen CASCADE;
DROP TABLE IF EXISTS casos_de_prueba CASCADE;
DROP TABLE IF EXISTS opciones_respuesta CASCADE;
DROP TABLE IF EXISTS pregunta_lenguajes CASCADE;
DROP TABLE IF EXISTS preguntas CASCADE;
DROP TABLE IF EXISTS cuestionarios CASCADE;
DROP TABLE IF EXISTS user_roles CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;
