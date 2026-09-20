# Base de datos PostgreSQL

Scripts SQL para el esquema `assessment_platform` que comparten auth y mngr en el perfil `dev`. No hay scripts MySQL.

| Archivo | Contenido |
| --- | --- |
| `01-schema-postgres.sql` | Tablas, relaciones e índices |
| `02-seed-data.sql` | Usuarios y evaluación de ejemplo |
| `00-drop-schema-postgres.sql` | Eliminación parcial de tablas |

## Preparación

Los scripts no crean el esquema. Con PostgreSQL local y acceso a la base `postgres`:

```bash
psql -U postgres -d postgres -c "CREATE SCHEMA IF NOT EXISTS assessment_platform;"
psql -v ON_ERROR_STOP=1 -U postgres -d postgres -f 01-schema-postgres.sql
```

**No ejecute el seed tal como está:** su `INSERT` de `cuestionarios` omite `max_intentos`, columna obligatoria del esquema. Corríjalo antes de usar `psql -v ON_ERROR_STOP=1 -U postgres -d postgres -f 02-seed-data.sql`. Los `data.sql` de auth y mngr también insertan datos y no deben cargarse encima de este seed; además, no coinciden con el esquema actual.

El seed declara `admin`, `candidato1` y `candidato2`, todos con contraseña de ejemplo `password123`. Úselos solo en desarrollo.

`00-drop-schema-postgres.sql` no elimina `asignaciones_cuestionario` ni `cuestionario_preguntas`; las claves foráneas pueden impedir borrar otras tablas. Los servicios usan `ddl-auto=validate`, así que necesitan un esquema completo y compatible antes de arrancar.
