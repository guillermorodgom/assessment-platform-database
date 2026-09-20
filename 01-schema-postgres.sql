-- ============================================
-- SCHEMA PostgreSQL — Assessment Platform
-- BD: postgres (local), Schema: assessment_platform
-- Ejecutar: psql -U postgres -d postgres -f 01-schema-postgres.sql
-- ============================================

SET search_path TO assessment_platform;

-- ============================================
-- USUARIOS Y ROLES (assessment-platform-auth)
-- ============================================

CREATE TABLE IF NOT EXISTS usuarios (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    nombre_completo VARCHAR(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS user_roles (
    usuario_id BIGINT NOT NULL,
    rol VARCHAR(20) NOT NULL,
    PRIMARY KEY (usuario_id, rol),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- ============================================
-- CUESTIONARIOS (assessment-platform-mngr)
-- ============================================

CREATE TABLE IF NOT EXISTS cuestionarios (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    tiempo_limite INT NOT NULL,
    cantidad_preguntas INT NOT NULL DEFAULT 0,
    max_intentos INT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    creado_por BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (creado_por) REFERENCES usuarios(id)
);

-- ============================================
-- PREGUNTAS
-- ============================================

CREATE TABLE IF NOT EXISTS preguntas (
    id BIGSERIAL PRIMARY KEY,
    titulo VARCHAR(300) NOT NULL,
    descripcion TEXT,
    tipo_pregunta VARCHAR(30) NOT NULL,
    puntaje DECIMAL(5,2) NOT NULL DEFAULT 1.00
);

-- ============================================
-- TABLA DE UNION: CUESTIONARIO <-> PREGUNTAS (M2M)
-- ============================================

CREATE TABLE IF NOT EXISTS cuestionario_preguntas (
    cuestionario_id BIGINT NOT NULL,
    pregunta_id BIGINT NOT NULL,
    PRIMARY KEY (cuestionario_id, pregunta_id),
    FOREIGN KEY (cuestionario_id) REFERENCES cuestionarios(id) ON DELETE CASCADE,
    FOREIGN KEY (pregunta_id) REFERENCES preguntas(id) ON DELETE CASCADE
);

-- ============================================
-- LENGUAJES PERMITIDOS POR PREGUNTA (solo CODIGO)
-- ============================================

CREATE TABLE IF NOT EXISTS pregunta_lenguajes (
    pregunta_id BIGINT NOT NULL,
    lenguaje VARCHAR(20) NOT NULL,
    PRIMARY KEY (pregunta_id, lenguaje),
    FOREIGN KEY (pregunta_id) REFERENCES preguntas(id) ON DELETE CASCADE
);

-- ============================================
-- OPCIONES DE RESPUESTA (preguntas teoricas)
-- ============================================

CREATE TABLE IF NOT EXISTS opciones_respuesta (
    id BIGSERIAL PRIMARY KEY,
    texto VARCHAR(500) NOT NULL,
    es_correcta BOOLEAN NOT NULL DEFAULT FALSE,
    pregunta_id BIGINT NOT NULL,
    FOREIGN KEY (pregunta_id) REFERENCES preguntas(id) ON DELETE CASCADE
);

-- ============================================
-- CASOS DE PRUEBA (preguntas de codigo)
-- ============================================

CREATE TABLE IF NOT EXISTS casos_de_prueba (
    id BIGSERIAL PRIMARY KEY,
    input TEXT,
    expected_output TEXT NOT NULL,
    pregunta_id BIGINT NOT NULL,
    FOREIGN KEY (pregunta_id) REFERENCES preguntas(id) ON DELETE CASCADE
);

-- ============================================
-- INTENTOS DE EXAMEN
-- ============================================

CREATE TABLE IF NOT EXISTS intentos_examen (
    id BIGSERIAL PRIMARY KEY,
    candidato_id BIGINT NOT NULL,
    cuestionario_id BIGINT NOT NULL,
    fecha_inicio TIMESTAMP NOT NULL,
    fecha_fin TIMESTAMP,
    estado VARCHAR(20) NOT NULL DEFAULT 'EN_PROGRESO',
    puntaje_total DECIMAL(5,2),
    puntaje_maximo DECIMAL(5,2),
    tiempo_consumido INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (candidato_id) REFERENCES usuarios(id),
    FOREIGN KEY (cuestionario_id) REFERENCES cuestionarios(id)
);

CREATE INDEX IF NOT EXISTS idx_intentos_candidato ON intentos_examen(candidato_id);
CREATE INDEX IF NOT EXISTS idx_intentos_cuestionario ON intentos_examen(cuestionario_id);

-- ============================================
-- ASIGNACIONES DE CUESTIONARIO A CANDIDATOS
-- ============================================

CREATE TABLE IF NOT EXISTS asignaciones_cuestionario (
    id BIGSERIAL PRIMARY KEY,
    cuestionario_id BIGINT NOT NULL,
    candidato_id BIGINT NOT NULL,
    disponible_desde TIMESTAMP NOT NULL,
    disponible_hasta TIMESTAMP NOT NULL,
    asignado_por BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cuestionario_id) REFERENCES cuestionarios(id) ON DELETE CASCADE,
    FOREIGN KEY (candidato_id) REFERENCES usuarios(id),
    FOREIGN KEY (asignado_por) REFERENCES usuarios(id),
    UNIQUE (cuestionario_id, candidato_id)
);

CREATE INDEX IF NOT EXISTS idx_asignacion_candidato ON asignaciones_cuestionario(candidato_id);

-- ============================================
-- RESPUESTAS DEL CANDIDATO
-- ============================================

CREATE TABLE IF NOT EXISTS respuestas_candidato (
    id BIGSERIAL PRIMARY KEY,
    intento_examen_id BIGINT NOT NULL,
    pregunta_id BIGINT NOT NULL,
    codigo_fuente TEXT,
    lenguaje VARCHAR(20),
    opciones_seleccionadas TEXT,
    resultado_ejecucion VARCHAR(30),
    salida_obtenida TEXT,
    es_correcta BOOLEAN NOT NULL DEFAULT FALSE,
    puntaje_obtenido DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (intento_examen_id) REFERENCES intentos_examen(id) ON DELETE CASCADE,
    FOREIGN KEY (pregunta_id) REFERENCES preguntas(id)
);

CREATE INDEX IF NOT EXISTS idx_respuestas_intento ON respuestas_candidato(intento_examen_id);
