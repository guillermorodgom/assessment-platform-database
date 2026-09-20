SET search_path TO assessment_platform;

-- ============================================
-- USUARIOS
-- Credenciales seed (todas usan password123):
--   admin      / password123  (ADMIN)
--   candidato1 / password123  (CANDIDATO)
--   candidato2 / password123  (CANDIDATO)
-- ============================================

-- admin / password123
INSERT INTO assessment_platform.usuarios (id, username, password, email, nombre_completo)
VALUES (1, 'admin', '$2a$10$M0pf.89UgE/aBWVf2aXwp.x0sPmLtPjU9JPD0na7VSCn8yWNl60ma', 'admin@assessment.com', 'Administrador');
INSERT INTO assessment_platform.user_roles (usuario_id, rol) VALUES (1, 'ADMIN');

-- candidato1 / password123
INSERT INTO assessment_platform.usuarios (id, username, password, email, nombre_completo)
VALUES (2, 'candidato1', '$2a$10$M0pf.89UgE/aBWVf2aXwp.x0sPmLtPjU9JPD0na7VSCn8yWNl60ma', 'candidato1@test.com', 'Juan Perez');
INSERT INTO assessment_platform.user_roles (usuario_id, rol) VALUES (2, 'CANDIDATO');

-- candidato2 / password123
INSERT INTO assessment_platform.usuarios (id, username, password, email, nombre_completo)
VALUES (3, 'candidato2', '$2a$10$M0pf.89UgE/aBWVf2aXwp.x0sPmLtPjU9JPD0na7VSCn8yWNl60ma', 'candidato2@test.com', 'Maria Garcia');
INSERT INTO assessment_platform.user_roles (usuario_id, rol) VALUES (3, 'CANDIDATO');

-- Sincronizar secuencias después de inserts con ID explícito
SELECT setval('assessment_platform.usuarios_id_seq', (SELECT MAX(id) FROM assessment_platform.usuarios));

-- ============================================
-- CUESTIONARIO DE EJEMPLO
-- ============================================

INSERT INTO assessment_platform.cuestionarios (nombre, descripcion, tiempo_limite, cantidad_preguntas, max_intentos, activo, creado_por)
VALUES ('Evaluacion Programacion Basica', 'Evaluacion de conocimientos basicos de programacion incluyendo Java, Python y JavaScript con preguntas teoricas y de codigo', 60, 5, 3, TRUE, 1);

-- ============================================
-- PREGUNTAS (5 preguntas, 20 puntos cada una = 100)
-- ============================================

-- Pregunta 1: Codigo (Java, Python, JavaScript)
INSERT INTO assessment_platform.preguntas (titulo, descripcion, tipo_pregunta, puntaje)
VALUES ('Suma de dos numeros', 'Escriba una funcion que reciba dos numeros enteros por entrada estandar (cada uno en una linea) y retorne su suma.', 'CODIGO', 20.00);

-- Pregunta 2: Codigo (Python, JavaScript)
INSERT INTO assessment_platform.preguntas (titulo, descripcion, tipo_pregunta, puntaje)
VALUES ('Numero par o impar', 'Escriba un programa que lea un numero entero de la entrada estandar e imprima "par" si es par o "impar" si es impar.', 'CODIGO', 20.00);

-- Pregunta 3: Codigo (JavaScript, Python, Java)
INSERT INTO assessment_platform.preguntas (titulo, descripcion, tipo_pregunta, puntaje)
VALUES ('Invertir un string', 'Escriba un programa que lea un string de la entrada estandar e imprima el string invertido.', 'CODIGO', 20.00);

-- Pregunta 4: Unica respuesta
INSERT INTO assessment_platform.preguntas (titulo, descripcion, tipo_pregunta, puntaje)
VALUES ('Paradigma de Java', 'Cual es el paradigma principal de programacion de Java?', 'OPCION_UNICA', 20.00);

-- Pregunta 5: Multiple respuesta
INSERT INTO assessment_platform.preguntas (titulo, descripcion, tipo_pregunta, puntaje)
VALUES ('Tipos primitivos en Java', 'Cuales de los siguientes son tipos primitivos en Java? (seleccione todos los correctos)', 'OPCION_MULTIPLE', 20.00);

-- ============================================
-- ASOCIAR PREGUNTAS AL CUESTIONARIO (M2M)
-- ============================================

INSERT INTO assessment_platform.cuestionario_preguntas (cuestionario_id, pregunta_id) VALUES (1, 1);
INSERT INTO assessment_platform.cuestionario_preguntas (cuestionario_id, pregunta_id) VALUES (1, 2);
INSERT INTO assessment_platform.cuestionario_preguntas (cuestionario_id, pregunta_id) VALUES (1, 3);
INSERT INTO assessment_platform.cuestionario_preguntas (cuestionario_id, pregunta_id) VALUES (1, 4);
INSERT INTO assessment_platform.cuestionario_preguntas (cuestionario_id, pregunta_id) VALUES (1, 5);

-- ============================================
-- LENGUAJES PERMITIDOS POR PREGUNTA
-- ============================================

-- Pregunta 1: Suma - todos los lenguajes
INSERT INTO assessment_platform.pregunta_lenguajes (pregunta_id, lenguaje) VALUES (1, 'JAVA');
INSERT INTO assessment_platform.pregunta_lenguajes (pregunta_id, lenguaje) VALUES (1, 'PYTHON');
INSERT INTO assessment_platform.pregunta_lenguajes (pregunta_id, lenguaje) VALUES (1, 'JAVASCRIPT');

-- Pregunta 2: Par/Impar - Python y JavaScript
INSERT INTO assessment_platform.pregunta_lenguajes (pregunta_id, lenguaje) VALUES (2, 'PYTHON');
INSERT INTO assessment_platform.pregunta_lenguajes (pregunta_id, lenguaje) VALUES (2, 'JAVASCRIPT');

-- Pregunta 3: Invertir string - todos los lenguajes
INSERT INTO assessment_platform.pregunta_lenguajes (pregunta_id, lenguaje) VALUES (3, 'JAVA');
INSERT INTO assessment_platform.pregunta_lenguajes (pregunta_id, lenguaje) VALUES (3, 'PYTHON');
INSERT INTO assessment_platform.pregunta_lenguajes (pregunta_id, lenguaje) VALUES (3, 'JAVASCRIPT');

-- ============================================
-- CASOS DE PRUEBA (preguntas de codigo)
-- ============================================

-- Test cases para pregunta 1 (Suma - Java)
-- Usamos E'...' (escape strings) para que \n sea un salto de linea real
INSERT INTO assessment_platform.casos_de_prueba (input, expected_output, pregunta_id) VALUES (E'3\n5', '8', 1);
INSERT INTO assessment_platform.casos_de_prueba (input, expected_output, pregunta_id) VALUES (E'0\n0', '0', 1);
INSERT INTO assessment_platform.casos_de_prueba (input, expected_output, pregunta_id) VALUES (E'-1\n1', '0', 1);
INSERT INTO assessment_platform.casos_de_prueba (input, expected_output, pregunta_id) VALUES (E'100\n200', '300', 1);

-- Test cases para pregunta 2 (Par/Impar - Python)
INSERT INTO assessment_platform.casos_de_prueba (input, expected_output, pregunta_id) VALUES ('4', 'par', 2);
INSERT INTO assessment_platform.casos_de_prueba (input, expected_output, pregunta_id) VALUES ('7', 'impar', 2);
INSERT INTO assessment_platform.casos_de_prueba (input, expected_output, pregunta_id) VALUES ('0', 'par', 2);

-- Test cases para pregunta 3 (Invertir string - JavaScript)
INSERT INTO assessment_platform.casos_de_prueba (input, expected_output, pregunta_id) VALUES ('hola', 'aloh', 3);
INSERT INTO assessment_platform.casos_de_prueba (input, expected_output, pregunta_id) VALUES ('javascript', 'tpircsavaj', 3);
INSERT INTO assessment_platform.casos_de_prueba (input, expected_output, pregunta_id) VALUES ('a', 'a', 3);
INSERT INTO assessment_platform.casos_de_prueba (input, expected_output, pregunta_id) VALUES ('12345', '54321', 3);

-- ============================================
-- OPCIONES DE RESPUESTA (preguntas teoricas)
-- ============================================

-- Opciones para pregunta 4 (Paradigma de Java)
INSERT INTO assessment_platform.opciones_respuesta (texto, es_correcta, pregunta_id) VALUES ('Programacion orientada a objetos', TRUE, 4);
INSERT INTO assessment_platform.opciones_respuesta (texto, es_correcta, pregunta_id) VALUES ('Programacion funcional', FALSE, 4);
INSERT INTO assessment_platform.opciones_respuesta (texto, es_correcta, pregunta_id) VALUES ('Programacion logica', FALSE, 4);
INSERT INTO assessment_platform.opciones_respuesta (texto, es_correcta, pregunta_id) VALUES ('Programacion imperativa pura', FALSE, 4);

-- Opciones para pregunta 5 (Tipos primitivos)
INSERT INTO assessment_platform.opciones_respuesta (texto, es_correcta, pregunta_id) VALUES ('int', TRUE, 5);
INSERT INTO assessment_platform.opciones_respuesta (texto, es_correcta, pregunta_id) VALUES ('String', FALSE, 5);
INSERT INTO assessment_platform.opciones_respuesta (texto, es_correcta, pregunta_id) VALUES ('boolean', TRUE, 5);
INSERT INTO assessment_platform.opciones_respuesta (texto, es_correcta, pregunta_id) VALUES ('double', TRUE, 5);
INSERT INTO assessment_platform.opciones_respuesta (texto, es_correcta, pregunta_id) VALUES ('Integer', FALSE, 5);

-- Sincronizar todas las secuencias
SELECT setval('assessment_platform.cuestionarios_id_seq', (SELECT MAX(id) FROM assessment_platform.cuestionarios));
SELECT setval('assessment_platform.preguntas_id_seq', (SELECT MAX(id) FROM assessment_platform.preguntas));
SELECT setval('assessment_platform.opciones_respuesta_id_seq', (SELECT MAX(id) FROM assessment_platform.opciones_respuesta));
SELECT setval('assessment_platform.casos_de_prueba_id_seq', (SELECT MAX(id) FROM assessment_platform.casos_de_prueba));
