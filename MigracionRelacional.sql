-- Crear el esquema si no existe
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'DROPDATABASE')
    EXEC('CREATE SCHEMA DROPDATABASE AUTHORIZATION dbo;');
GO

/* 
   ===========================================================
   TABLAS BASE SIN FKs
   =========================================================== 
*/

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Profesor' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Profesor (
        prof_id BIGINT IDENTITY(1,1) NOT NULL,
        prof_nombre VARCHAR(255) NOT NULL,
        prof_apellido VARCHAR(255) NOT NULL,
        prof_dni BIGINT NOT NULL,
        prof_fecha_nacimiento DATETIME2(6),
        prof_mail VARCHAR(255),
        prof_direccion VARCHAR(255),
        prof_localidad VARCHAR(255),
        prof_provincia VARCHAR(255),
        prof_telefono VARCHAR(255),

        CONSTRAINT PK_Profesor PRIMARY KEY (prof_id),
        CONSTRAINT UQ_Profesor_dni UNIQUE (prof_dni)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Alumno' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Alumno (
        alum_id BIGINT IDENTITY(1,1) NOT NULL,
        alum_nombre VARCHAR(255) NOT NULL,
        alum_apellido VARCHAR(255) NOT NULL,
        alum_dni BIGINT NOT NULL,
        alum_legajo BIGINT NOT NULL,
        alum_fecha_nacimiento DATETIME2(6),
        alum_mail VARCHAR(255),
        alum_direccion VARCHAR(255),
        alum_localidad VARCHAR(255),
        alum_provincia VARCHAR(255),
        alum_telefono VARCHAR(255),

        CONSTRAINT PK_Alumno PRIMARY KEY (alum_id),
        CONSTRAINT UQ_Alumno_dni UNIQUE (alum_dni),
        CONSTRAINT UQ_Alumno_legajo UNIQUE (alum_legajo)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Sede' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Sede (
        sede_id BIGINT IDENTITY(1,1) NOT NULL,
        sede_nombre VARCHAR(255) NOT NULL,
        CONSTRAINT PK_Sede PRIMARY KEY (sede_id)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Pregunta' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Pregunta (
        pregunta_id BIGINT IDENTITY(1,1) NOT NULL,
        pregunta_detalle VARCHAR(255) NOT NULL,
        CONSTRAINT PK_Pregunta PRIMARY KEY (pregunta_id)
    );
END
GO

/* 
   ===========================================================
   TABLAS CON FKs
   =========================================================== 
*/

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Curso' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Curso (
        cur_id BIGINT IDENTITY(1,1) NOT NULL,
        cur_sede BIGINT NOT NULL,
        cur_profesor BIGINT NOT NULL,
        cur_nombre VARCHAR(255),
        cur_descripcion VARCHAR(255),
        cur_categoria VARCHAR(255),
        cur_fecha_inicio DATETIME2(6),
        cur_fecha_fin DATETIME2(6),
        cur_duracion_meses BIGINT,
        cur_turno VARCHAR(255),
        cur_precio_mensual DECIMAL(38,2),

        CONSTRAINT PK_Curso PRIMARY KEY (cur_id),
        CONSTRAINT FK_Curso_Sede FOREIGN KEY (cur_sede) REFERENCES DROPDATABASE.Sede,
        CONSTRAINT FK_Curso_Profesor FOREIGN KEY (cur_profesor) REFERENCES DROPDATABASE.Profesor,
        CONSTRAINT CK_Curso_Turno CHECK (cur_turno IN ('MANANA','TARDE','NOCHE'))
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Factura' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Factura (
        fact_nro BIGINT IDENTITY(1,1) NOT NULL,
        fact_fecha DATETIME2(6),
        fact_vencimiento DATETIME2(6),
        fact_alumno BIGINT NOT NULL,
        fact_total DECIMAL(18,2),

        CONSTRAINT PK_Factura PRIMARY KEY (fact_nro),
        CONSTRAINT FK_Factura_Alumno FOREIGN KEY (fact_alumno) REFERENCES DROPDATABASE.Alumno
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Encuesta' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Encuesta (
        encu_nro BIGINT IDENTITY(1,1) NOT NULL,
        encu_curso BIGINT NOT NULL,
        encu_fecha DATETIME2(6),
        encu_observaciones VARCHAR(255),

        CONSTRAINT PK_Encuesta PRIMARY KEY (encu_nro),
        CONSTRAINT FK_Encuesta_Curso FOREIGN KEY (encu_curso) REFERENCES DROPDATABASE.Curso
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Curso_Dias' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Curso_Dias (
        cur_id BIGINT NOT NULL,
        dia_semana VARCHAR(255),
        CONSTRAINT PK_Curso_Dias PRIMARY KEY (cur_id, dia_semana),
        CONSTRAINT FK_Dias_Curso FOREIGN KEY (cur_id) REFERENCES DROPDATABASE.Curso
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Inscripcion_Curso' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Inscripcion_Curso (
        insc_nro BIGINT IDENTITY(1,1) NOT NULL,
        insc_alumno BIGINT NOT NULL,
        insc_curso BIGINT NOT NULL,
        insc_fecha DATETIME2(6),
        insc_estado VARCHAR(255),
        insc_fecha_respuesta DATETIME2(6),

        CONSTRAINT PK_Inscripcion_Curso PRIMARY KEY (insc_nro),
        CONSTRAINT FK_Alumno_Inscripcion_Curso FOREIGN KEY (insc_alumno) REFERENCES DROPDATABASE.Alumno,
        CONSTRAINT FK_Curso_Inscripcion_Curso FOREIGN KEY (insc_curso) REFERENCES DROPDATABASE.Curso,
        CONSTRAINT CK_Inscripcion_Estado CHECK (insc_estado IN ('PENDIENTE','CONFIRMADA','RECHAZADA'))
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Cursada' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Cursada (
        cursa_curso BIGINT NOT NULL,
        cursa_alumno BIGINT NOT NULL,
        CONSTRAINT PK_Cursada PRIMARY KEY (cursa_curso, cursa_alumno),
        CONSTRAINT FK_Cursada_Curso FOREIGN KEY (cursa_curso) REFERENCES DROPDATABASE.Curso,
        CONSTRAINT FK_Cursada_Alumno FOREIGN KEY (cursa_alumno) REFERENCES DROPDATABASE.Alumno
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Modulo' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Modulo (
        mod_id BIGINT IDENTITY(1,1) NOT NULL,
        mod_curso BIGINT NOT NULL,
        mod_descripcion VARCHAR(255),

        CONSTRAINT PK_Modulo PRIMARY KEY (mod_id),
        CONSTRAINT FK_Modulo_Curso FOREIGN KEY (mod_curso) REFERENCES DROPDATABASE.Curso
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Factura_Detalle' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Factura_Detalle (
        fact_nro BIGINT NOT NULL,
        fact_curso BIGINT NOT NULL,
        fact_referencia DATETIME2(6),
        fact_total DECIMAL(18,2),

        CONSTRAINT PK_Factucar_Detalle PRIMARY KEY (fact_nro, fact_curso),
        CONSTRAINT FK_Factura_Detalle FOREIGN KEY (fact_nro) REFERENCES DROPDATABASE.Factura,
        CONSTRAINT FK_Factura_Detalle_Curso FOREIGN KEY (fact_curso) REFERENCES DROPDATABASE.Curso
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Final' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Final (
        final_id BIGINT IDENTITY(1,1) NOT NULL,
        final_fecha DATETIME2(6),
        final_curso BIGINT NOT NULL,

        CONSTRAINT PK_Final PRIMARY KEY (final_id),
        CONSTRAINT FK_Final_Curso FOREIGN KEY (final_curso) REFERENCES DROPDATABASE.Curso
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Pago' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Pago (
        pago_id BIGINT IDENTITY(1,1) NOT NULL,
        pago_fact BIGINT NOT NULL,
        pago_fecha DATETIME2(6),
        pago_importe DECIMAL(18,2),
        pago_medio_pago VARCHAR(255),

        CONSTRAINT PK_Pago PRIMARY KEY (pago_id),
        CONSTRAINT FK_Factura_Pago FOREIGN KEY (pago_fact) REFERENCES DROPDATABASE.Factura
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Inscripcion_Final' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Inscripcion_Final (
        insc_nro BIGINT IDENTITY(1,1) NOT NULL,
        insc_fecha DATETIME2(6),
        insc_alumno BIGINT NOT NULL,
        insc_final BIGINT NOT NULL,

        CONSTRAINT PK_Inscripcion_Final PRIMARY KEY (insc_nro),
        CONSTRAINT FK_Alumno_Inscripcion_Final FOREIGN KEY (insc_alumno) REFERENCES DROPDATABASE.Alumno,
        CONSTRAINT FK_Final_Inscripcion FOREIGN KEY (insc_final) REFERENCES DROPDATABASE.Final
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Final_Alumno' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Final_Alumno (
        final_id BIGINT NOT NULL,
        final_alum BIGINT NOT NULL,
        presente BIT,
        final_nota BIGINT,
        final_prof BIGINT NOT NULL,

        CONSTRAINT PK_Final_Alumno PRIMARY KEY (final_id, final_alum),
        CONSTRAINT FK_Final_Alumno_Final FOREIGN KEY (final_id) REFERENCES DROPDATABASE.Final,
        CONSTRAINT FK_Final_Alumno_Alumno FOREIGN KEY (final_alum) REFERENCES DROPDATABASE.Alumno
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Tp' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Tp (
        tp_curso BIGINT NOT NULL,
        tp_alumno BIGINT NOT NULL,
        tp_nota BIGINT NOT NULL,
        tp_fecha_eval DATETIME2(6),

        CONSTRAINT PK_Tp PRIMARY KEY (tp_curso, tp_alumno),
        CONSTRAINT FK_Tp_Cursada FOREIGN KEY (tp_curso, tp_alumno) REFERENCES DROPDATABASE.Cursada
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Evaluacion' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Evaluacion (
        eval_alumno BIGINT NOT NULL,
        eval_modulo BIGINT NOT NULL,
        eval_nota BIGINT,
        eval_fecha DATETIME2(6),
        eval_instancia BIGINT,
        eval_presente BIT,

        CONSTRAINT PK_Evaluacion PRIMARY KEY (eval_alumno, eval_modulo),
        CONSTRAINT FK_Evaluacion_Alumno FOREIGN KEY (eval_alumno) REFERENCES DROPDATABASE.Alumno,
        CONSTRAINT FK_Evaluacion_Modulo FOREIGN KEY (eval_modulo) REFERENCES DROPDATABASE.Modulo
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Pregunta_Encuesta' AND schema_id = SCHEMA_ID('DROPDATABASE'))
BEGIN
    CREATE TABLE DROPDATABASE.Pregunta_Encuesta (
        encuesta_pregunta BIGINT NOT NULL,
        encuesta_nro BIGINT NOT NULL,
        respuesta BIGINT,

        CONSTRAINT PK_Pregunta_Encuesta PRIMARY KEY (encuesta_pregunta, encuesta_nro),
        CONSTRAINT FK_Pregunta_Encuesta_Pregunta FOREIGN KEY (encuesta_pregunta) REFERENCES DROPDATABASE.Pregunta,
        CONSTRAINT FK_Pregunta_Encuesta_Encuesta FOREIGN KEY (encuesta_nro) REFERENCES DROPDATABASE.Encuesta
    );
END
GO

-- Helpers
SET XACT_ABORT ON;
GO
/* ===========================================================
   MIGRACIÓN DE DATOS DESDE gd_esquema.Maestra
   =========================================================== */
CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_profesores
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT DISTINCT
      -- Normalización de strings y tolerancia a casing en nombres de columnas
      prof_nombre   = NULLIF(LTRIM(RTRIM(COALESCE(m.Profesor_Nombre,    m.Profesor_nombre))), ''),
      prof_apellido = NULLIF(LTRIM(RTRIM(COALESCE(m.Profesor_Apellido,  m.Profesor_apellido))), ''),
      prof_dni      = TRY_CONVERT(BIGINT, COALESCE(m.Profesor_Dni,      m.Profesor_dni)),
      prof_fecha    = TRY_CONVERT(DATETIME2(6), COALESCE(m.Profesor_FechaNacimiento, m.Profesor_FechaNacimiento)),
      prof_mail     = NULLIF(LTRIM(RTRIM(COALESCE(m.Profesor_Mail,      m.Profesor_mail))), ''),
      prof_dir      = NULLIF(LTRIM(RTRIM(COALESCE(m.Profesor_Direccion, m.Profesor_direccion))), ''),
      prof_loc      = NULLIF(LTRIM(RTRIM(COALESCE(m.Profesor_Localidad, m.Profesor_localidad))), ''),
      prof_prov     = NULLIF(LTRIM(RTRIM(COALESCE(m.Profesor_Provincia, m.Profesor_provincia))), ''),
      prof_tel      = NULLIF(LTRIM(RTRIM(COALESCE(m.Profesor_Telefono,  m.Profesor_telefono))), '')
    FROM gd_esquema.Maestra m
    WHERE COALESCE(m.Profesor_Dni, m.Profesor_dni) IS NOT NULL
  ),
  cleaned AS (
    SELECT *
    FROM src
    WHERE prof_dni IS NOT NULL AND prof_dni > 0
  )
  MERGE DROPDATABASE.Profesor AS tgt
  USING cleaned AS s
     ON tgt.prof_dni = s.prof_dni
  WHEN MATCHED THEN
    UPDATE SET
      tgt.prof_nombre            = COALESCE(s.prof_nombre, tgt.prof_nombre),
      tgt.prof_apellido          = COALESCE(s.prof_apellido, tgt.prof_apellido),
      tgt.prof_fecha_nacimiento  = COALESCE(s.prof_fecha, tgt.prof_fecha_nacimiento),
      tgt.prof_mail              = COALESCE(s.prof_mail, tgt.prof_mail),
      tgt.prof_direccion         = COALESCE(s.prof_dir, tgt.prof_direccion),
      tgt.prof_localidad         = COALESCE(s.prof_loc, tgt.prof_localidad),
      tgt.prof_provincia         = COALESCE(s.prof_prov, tgt.prof_provincia),
      tgt.prof_telefono          = COALESCE(s.prof_tel, tgt.prof_telefono)
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (prof_nombre, prof_apellido, prof_dni, prof_fecha_nacimiento,
            prof_mail, prof_direccion, prof_localidad, prof_provincia, prof_telefono)
    VALUES (s.prof_nombre, s.prof_apellido, s.prof_dni, s.prof_fecha,
            s.prof_mail, s.prof_dir, s.prof_loc, s.prof_prov, s.prof_tel);
END;
GO

/* ===========================================================
   =========================================================== */

CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_alumnos
AS
BEGIN
  SET NOCOUNT ON;

  IF OBJECT_ID('tempdb..#cleaned')       IS NOT NULL DROP TABLE #cleaned;
  IF OBJECT_ID('tempdb..#dni_ready')     IS NOT NULL DROP TABLE #dni_ready;
  IF OBJECT_ID('tempdb..#legajo_ready')  IS NOT NULL DROP TABLE #legajo_ready;

  ;WITH raw AS (
    SELECT
      COALESCE(m.Alumno_Nombre,      m.Alumno_nombre)      AS nombre_raw,
      COALESCE(m.Alumno_Apellido,    m.Alumno_apellido)    AS apellido_raw,
      COALESCE(m.Alumno_Dni,         m.Alumno_dni)         AS dni_raw,
      COALESCE(m.Alumno_Legajo,      m.Alumno_legajo)      AS legajo_raw,
      COALESCE(m.Alumno_Mail,        m.Alumno_mail)        AS mail_raw,
      COALESCE(m.Alumno_Direccion,   m.Alumno_direccion)   AS dir_raw,
      COALESCE(m.Alumno_Localidad,   m.Alumno_localidad)   AS loc_raw,
      COALESCE(m.Alumno_Provincia,   m.Alumno_provincia)   AS prov_raw,
      COALESCE(m.Alumno_Telefono,    m.Alumno_telefono)    AS tel_raw,
      m.Alumno_FechaNacimiento                              AS fecha_raw
    FROM gd_esquema.Maestra m
  ),
  norm AS (
    SELECT DISTINCT
      alum_nombre    = NULLIF(LTRIM(RTRIM(CAST(nombre_raw   AS nvarchar(255)))), ''),
      alum_apellido  = NULLIF(LTRIM(RTRIM(CAST(apellido_raw AS nvarchar(255)))), ''),
      dni_clean_str    = REPLACE(REPLACE(REPLACE(CAST(dni_raw    AS nvarchar(50)),'.',''),'-',''),' ',''),
      legajo_clean_str = REPLACE(REPLACE(REPLACE(CAST(legajo_raw AS nvarchar(50)),'.',''),'-',''),' ',''),
      alum_mail      = NULLIF(LTRIM(RTRIM(CAST(mail_raw AS nvarchar(255)))), ''),
      alum_direccion = NULLIF(LTRIM(RTRIM(CAST(dir_raw  AS nvarchar(255)))), ''),
      alum_localidad = NULLIF(LTRIM(RTRIM(CAST(loc_raw  AS nvarchar(255)))), ''),
      alum_provincia = NULLIF(LTRIM(RTRIM(CAST(prov_raw AS nvarchar(255)))), ''),
      alum_telefono  = NULLIF(LTRIM(RTRIM(CAST(tel_raw  AS nvarchar(255)))), ''),
      alum_fecha     = TRY_CONVERT(DATETIME2(6), fecha_raw)
    FROM raw
  )
  SELECT
      alum_nombre,
      alum_apellido,
      alum_dni    = TRY_CONVERT(BIGINT, dni_clean_str),
      alum_legajo = TRY_CONVERT(BIGINT, legajo_clean_str),
      alum_mail, alum_direccion, alum_localidad, alum_provincia, alum_telefono, alum_fecha
  INTO #cleaned
  FROM norm;

  
  ;WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
             PARTITION BY alum_dni
             ORDER BY CASE WHEN alum_legajo IS NOT NULL THEN 0 ELSE 1 END,
                      CASE WHEN alum_fecha  IS NOT NULL THEN 0 ELSE 1 END
           ) AS rn
    FROM #cleaned
    WHERE alum_dni IS NOT NULL AND alum_dni > 0
  )
  SELECT alum_nombre, alum_apellido, alum_dni, alum_legajo, alum_mail,
         alum_direccion, alum_localidad, alum_provincia, alum_telefono, alum_fecha
  INTO #dni_ready
  FROM cte
  WHERE rn = 1;

  MERGE DROPDATABASE.Alumno AS tgt
  USING #dni_ready AS s
     ON tgt.alum_dni = s.alum_dni
  WHEN MATCHED THEN
    UPDATE SET
      tgt.alum_nombre            = COALESCE(s.alum_nombre,  tgt.alum_nombre),
      tgt.alum_apellido          = COALESCE(s.alum_apellido,tgt.alum_apellido),
      tgt.alum_legajo            = COALESCE(s.alum_legajo,  tgt.alum_legajo),
      tgt.alum_fecha_nacimiento  = COALESCE(s.alum_fecha,   tgt.alum_fecha_nacimiento),
      tgt.alum_mail              = COALESCE(s.alum_mail,    tgt.alum_mail),
      tgt.alum_direccion         = COALESCE(s.alum_direccion,tgt.alum_direccion),
      tgt.alum_localidad         = COALESCE(s.alum_localidad,tgt.alum_localidad),
      tgt.alum_provincia         = COALESCE(s.alum_provincia,tgt.alum_provincia),
      tgt.alum_telefono          = COALESCE(s.alum_telefono,tgt.alum_telefono)
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (alum_nombre, alum_apellido, alum_dni, alum_legajo, alum_fecha_nacimiento,
            alum_mail, alum_direccion, alum_localidad, alum_provincia, alum_telefono)
    VALUES (s.alum_nombre, s.alum_apellido, s.alum_dni, s.alum_legajo, s.alum_fecha,
            s.alum_mail, s.alum_direccion, s.alum_localidad, s.alum_provincia, s.alum_telefono);

 
  ;WITH candidatos AS (
    SELECT *
    FROM #cleaned
    WHERE (alum_dni IS NULL OR alum_dni <= 0)
      AND alum_legajo IS NOT NULL AND alum_legajo > 0
  ),
  sin_existentes AS (
    SELECT c.*
    FROM candidatos c
    LEFT JOIN DROPDATABASE.Alumno a
           ON a.alum_legajo = c.alum_legajo
    WHERE a.alum_legajo IS NULL  
  ),
  cte2 AS (
    SELECT *,
           ROW_NUMBER() OVER (
             PARTITION BY alum_legajo
             ORDER BY CASE WHEN alum_fecha IS NOT NULL THEN 0 ELSE 1 END
           ) AS rn
    FROM sin_existentes
  )
  SELECT alum_nombre, alum_apellido, alum_dni, alum_legajo, alum_mail,
         alum_direccion, alum_localidad, alum_provincia, alum_telefono, alum_fecha
  INTO #legajo_ready
  FROM cte2
  WHERE rn = 1;

  MERGE DROPDATABASE.Alumno AS tgt
  USING #legajo_ready AS s
     ON tgt.alum_legajo = s.alum_legajo
  WHEN MATCHED THEN
    UPDATE SET
      tgt.alum_nombre            = COALESCE(s.alum_nombre,  tgt.alum_nombre),
      tgt.alum_apellido          = COALESCE(s.alum_apellido,tgt.alum_apellido),
      tgt.alum_dni               = COALESCE(tgt.alum_dni, s.alum_dni), -- si ahora aparece un DNI
      tgt.alum_fecha_nacimiento  = COALESCE(s.alum_fecha,   tgt.alum_fecha_nacimiento),
      tgt.alum_mail              = COALESCE(s.alum_mail,    tgt.alum_mail),
      tgt.alum_direccion         = COALESCE(s.alum_direccion,tgt.alum_direccion),
      tgt.alum_localidad         = COALESCE(s.alum_localidad,tgt.alum_localidad),
      tgt.alum_provincia         = COALESCE(s.alum_provincia,tgt.alum_provincia),
      tgt.alum_telefono          = COALESCE(s.alum_telefono,tgt.alum_telefono)
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (alum_nombre, alum_apellido, alum_dni, alum_legajo, alum_fecha_nacimiento,
            alum_mail, alum_direccion, alum_localidad, alum_provincia, alum_telefono)
    VALUES (s.alum_nombre, s.alum_apellido, s.alum_dni, s.alum_legajo, s.alum_fecha,
            s.alum_mail, s.alum_direccion, s.alum_localidad, s.alum_provincia, s.alum_telefono);

  DROP TABLE IF EXISTS #cleaned, #dni_ready, #legajo_ready;
END;
GO


/* ===========================================================
   =========================================================== */

CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_sedes
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT DISTINCT
      sede_nombre_norm = NULLIF(LTRIM(RTRIM(UPPER(CAST(m.Sede_Nombre AS nvarchar(255))))), '')
    FROM gd_esquema.Maestra m
    WHERE m.Sede_Nombre IS NOT NULL
  ),
  cleaned AS (
    SELECT sede_nombre = sede_nombre_norm
    FROM src
    WHERE sede_nombre_norm IS NOT NULL
  )
  MERGE DROPDATABASE.Sede AS tgt
  USING cleaned AS s
     ON UPPER(tgt.sede_nombre) = s.sede_nombre
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (sede_nombre) VALUES (s.sede_nombre);
END;
GO


/* ===========================================================
   =========================================================== */

CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_cursos
AS
BEGIN
  SET NOCOUNT ON;

  IF OBJECT_ID('tempdb..#src_cursos') IS NOT NULL DROP TABLE #src_cursos;

  ;WITH raw AS (
    SELECT
      curso_nombre_raw      = m.Curso_Nombre,
      curso_desc_raw        = m.Curso_Descripcion,
      curso_cat_raw         = m.Curso_Categoria,
      curso_ini_raw         = m.Curso_FechaInicio,
      curso_fin_raw         = m.Curso_FechaFin,
      curso_dur_raw         = m.Curso_DuracionMeses,
      curso_turno_raw       = m.Curso_Turno,
      curso_precio_raw      = m.Curso_PrecioMensual,

      sede_nombre_raw       = m.Sede_Nombre,

      prof_dni_raw          = COALESCE(m.Profesor_Dni, m.Profesor_dni),
      prof_nom_raw          = COALESCE(m.Profesor_Nombre, m.Profesor_nombre),
      prof_ape_raw          = COALESCE(m.Profesor_Apellido, m.Profesor_apellido)
    FROM gd_esquema.Maestra m
  ),
  norm AS (
    SELECT DISTINCT
      cur_nombre   = NULLIF(LTRIM(RTRIM(CAST(curso_nombre_raw AS nvarchar(255)))), ''),
      cur_desc     = NULLIF(LTRIM(RTRIM(CAST(curso_desc_raw   AS nvarchar(255)))), ''),
      cur_cat      = NULLIF(LTRIM(RTRIM(CAST(curso_cat_raw    AS nvarchar(255)))), ''),
      cur_ini      = TRY_CONVERT(DATETIME2(6), curso_ini_raw),
      cur_fin      = TRY_CONVERT(DATETIME2(6), curso_fin_raw),
      cur_dur      = TRY_CONVERT(BIGINT, curso_dur_raw),

      cur_turno     =
        CASE
          WHEN UPPER(REPLACE(CAST(curso_turno_raw AS nvarchar(50)),'Ñ','N')) LIKE '%MANANA%' THEN 'MANANA'
          WHEN UPPER(CAST(curso_turno_raw AS nvarchar(50))) LIKE '%TARDE%'   THEN 'TARDE'
          WHEN UPPER(CAST(curso_turno_raw AS nvarchar(50))) LIKE '%NOCHE%'   THEN 'NOCHE'
          ELSE NULL
        END,

      cur_precio   = TRY_CONVERT(DECIMAL(38,2), curso_precio_raw),

      sede_nombre_norm = NULLIF(LTRIM(RTRIM(UPPER(CAST(sede_nombre_raw AS nvarchar(255))))), ''),

      prof_dni_clean_str = REPLACE(REPLACE(REPLACE(CAST(prof_dni_raw AS nvarchar(50)),'.',''),'-',''),' ',''),
      prof_nombre_norm   = NULLIF(LTRIM(RTRIM(UPPER(CAST(prof_nom_raw AS nvarchar(255))))) , ''),
      prof_apellido_norm = NULLIF(LTRIM(RTRIM(UPPER(CAST(prof_ape_raw AS nvarchar(255))))) , '')
    FROM raw
  )
  SELECT
      cur_nombre, cur_desc, cur_cat, cur_ini, cur_fin, cur_dur, cur_turno, cur_precio,
      sede_nombre_norm,
      prof_dni = TRY_CONVERT(BIGINT, prof_dni_clean_str),
      prof_nombre_norm, prof_apellido_norm
  INTO #src_cursos
  FROM norm
  WHERE cur_nombre IS NOT NULL
;
  ;WITH sedes AS (
    SELECT s.sede_id, sede_nombre_norm = UPPER(LTRIM(RTRIM(s.sede_nombre)))
    FROM DROPDATABASE.Sede s
  ),
  prof_dni AS (
    SELECT p.prof_id, p.prof_dni
    FROM DROPDATABASE.Profesor p
    WHERE p.prof_dni IS NOT NULL
  ),
  prof_nombre AS (
    SELECT p.prof_id,
           prof_apellido_norm = UPPER(LTRIM(RTRIM(p.prof_apellido))),
           prof_nombre_norm   = UPPER(LTRIM(RTRIM(p.prof_nombre)))
    FROM DROPDATABASE.Profesor p
  )
  SELECT
      c.cur_nombre, c.cur_desc, c.cur_cat, c.cur_ini, c.cur_fin, c.cur_dur, c.cur_turno, c.cur_precio,
      s.sede_id,
      prof_id = COALESCE(pdni.prof_id, pnom.prof_id)
  INTO #cursos_resueltos
  FROM #src_cursos c
  INNER JOIN sedes s
          ON s.sede_nombre_norm = c.sede_nombre_norm
  LEFT  JOIN prof_dni  pdni
          ON pdni.prof_dni = c.prof_dni
  LEFT  JOIN prof_nombre pnom
          ON c.prof_dni IS NULL
         AND pnom.prof_apellido_norm = c.prof_apellido_norm
         AND pnom.prof_nombre_norm   = c.prof_nombre_norm
  WHERE COALESCE(pdni.prof_id, pnom.prof_id) IS NOT NULL
;

  MERGE DROPDATABASE.Curso AS tgt
  USING (
    SELECT DISTINCT *
    FROM #cursos_resueltos
  ) AS s
     ON UPPER(tgt.cur_nombre) = UPPER(s.cur_nombre)
    AND tgt.cur_sede = s.sede_id
  WHEN MATCHED THEN
    UPDATE SET
      tgt.cur_profesor       = s.prof_id,
      tgt.cur_descripcion    = s.cur_desc,
      tgt.cur_categoria      = s.cur_cat,
      tgt.cur_fecha_inicio   = s.cur_ini,
      tgt.cur_fecha_fin      = s.cur_fin,
      tgt.cur_duracion_meses = s.cur_dur,
      tgt.cur_turno          = s.cur_turno,
      tgt.cur_precio_mensual = s.cur_precio
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (cur_sede, cur_profesor, cur_nombre, cur_descripcion, cur_categoria,
            cur_fecha_inicio, cur_fecha_fin, cur_duracion_meses, cur_turno, cur_precio_mensual)
    VALUES (s.sede_id, s.prof_id, s.cur_nombre, s.cur_desc, s.cur_cat,
            s.cur_ini, s.cur_fin, s.cur_dur, s.cur_turno, s.cur_precio);

  DROP TABLE IF EXISTS #src_cursos, #cursos_resueltos;
END;
GO

/* ===========================================================
   =========================================================== */

CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_curso_dias
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT DISTINCT
      curso_nombre = NULLIF(LTRIM(RTRIM(CAST(m.Curso_Nombre AS nvarchar(255)))), ''),
      sede_nombre_norm = NULLIF(LTRIM(RTRIM(UPPER(CAST(m.Sede_Nombre AS nvarchar(255))))), ''),
      dia_semana = NULLIF(LTRIM(RTRIM(UPPER(CAST(m.Curso_Dia AS nvarchar(255))))), '')
    FROM gd_esquema.Maestra m
    WHERE m.Curso_Nombre IS NOT NULL 
      AND m.Sede_Nombre IS NOT NULL
      AND m.Curso_Dia IS NOT NULL
  ),
  curso_lookup AS (
    SELECT c.cur_id, c.cur_nombre, s.sede_nombre
    FROM DROPDATABASE.Curso c
    INNER JOIN DROPDATABASE.Sede s ON c.cur_sede = s.sede_id
  ),
  dias_con_curso AS (
    SELECT DISTINCT
      cl.cur_id,
      src.dia_semana
    FROM src
    INNER JOIN curso_lookup cl
      ON UPPER(cl.cur_nombre) = UPPER(src.curso_nombre)
      AND UPPER(cl.sede_nombre) = src.sede_nombre_norm
  )
  MERGE DROPDATABASE.Curso_Dias AS tgt
  USING dias_con_curso AS s
     ON tgt.cur_id = s.cur_id 
    AND tgt.dia_semana = s.dia_semana
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (cur_id, dia_semana)
    VALUES (s.cur_id, s.dia_semana);
END;
GO


/* ===========================================================
   =========================================================== */

CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_inscripciones_curso
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT DISTINCT
      alumno_dni_str = REPLACE(REPLACE(REPLACE(CAST(COALESCE(m.Alumno_Dni, m.Alumno_dni) AS nvarchar(50)),'.',''),'-',''),' ',''),
      alumno_legajo_str = REPLACE(REPLACE(REPLACE(CAST(COALESCE(m.Alumno_Legajo, m.Alumno_legajo) AS nvarchar(50)),'.',''),'-',''),' ',''),
      curso_nombre = NULLIF(LTRIM(RTRIM(CAST(m.Curso_Nombre AS nvarchar(255)))), ''),
      sede_nombre_norm = NULLIF(LTRIM(RTRIM(UPPER(CAST(m.Sede_Nombre AS nvarchar(255))))), ''),
      insc_numero = TRY_CONVERT(BIGINT, m.Inscripcion_Numero),
      insc_fecha = TRY_CONVERT(DATETIME2(6), m.Inscripcion_Fecha),
      insc_estado = NULLIF(LTRIM(RTRIM(UPPER(CAST(m.Inscripcion_Estado AS nvarchar(255))))), ''),
      insc_fecha_resp = TRY_CONVERT(DATETIME2(6), m.Inscripcion_FechaRespuesta)
    FROM gd_esquema.Maestra m
    WHERE (COALESCE(m.Alumno_Dni, m.Alumno_dni) IS NOT NULL OR COALESCE(m.Alumno_Legajo, m.Alumno_legajo) IS NOT NULL)
      AND m.Curso_Nombre IS NOT NULL
      AND m.Sede_Nombre IS NOT NULL
  ),
  clean_src AS (
    SELECT 
      alumno_dni = TRY_CONVERT(BIGINT, alumno_dni_str),
      alumno_legajo = TRY_CONVERT(BIGINT, alumno_legajo_str),
      curso_nombre, sede_nombre_norm, insc_numero, insc_fecha,
      insc_estado = CASE 
        WHEN insc_estado IN ('Pendiente', 'Confirmada', 'Rechazada') THEN insc_estado
        ELSE 'Pendiente'
      END,
      insc_fecha_resp
    FROM src
  ),
  alumno_lookup AS (
    SELECT a.alum_id, a.alum_dni, a.alum_legajo
    FROM DROPDATABASE.Alumno a
  ),
  curso_lookup AS (
    SELECT c.cur_id, c.cur_nombre, s.sede_nombre
    FROM DROPDATABASE.Curso c
    INNER JOIN DROPDATABASE.Sede s ON c.cur_sede = s.sede_id
  ),
  inscripciones_resueltas AS (
    SELECT DISTINCT
      al.alum_id,
      cl.cur_id,
      cs.insc_numero,
      cs.insc_fecha,
      cs.insc_estado,
      cs.insc_fecha_resp
    FROM clean_src cs
    INNER JOIN alumno_lookup al 
      ON (al.alum_dni = cs.alumno_dni AND cs.alumno_dni IS NOT NULL AND cs.alumno_dni > 0)
      OR (al.alum_legajo = cs.alumno_legajo AND cs.alumno_legajo IS NOT NULL AND cs.alumno_legajo > 0)
    INNER JOIN curso_lookup cl
      ON UPPER(cl.cur_nombre) = UPPER(cs.curso_nombre)
      AND UPPER(cl.sede_nombre) = cs.sede_nombre_norm
  )
  MERGE DROPDATABASE.Inscripcion_Curso AS tgt
  USING inscripciones_resueltas AS s
     ON tgt.insc_alumno = s.alum_id 
    AND tgt.insc_curso = s.cur_id
  WHEN MATCHED THEN
    UPDATE SET
      tgt.insc_fecha = COALESCE(s.insc_fecha, tgt.insc_fecha),
      tgt.insc_estado = COALESCE(s.insc_estado, tgt.insc_estado),
      tgt.insc_fecha_respuesta = COALESCE(s.insc_fecha_resp, tgt.insc_fecha_respuesta)
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (insc_alumno, insc_curso, insc_fecha, insc_estado, insc_fecha_respuesta)
    VALUES (s.alum_id, s.cur_id, s.insc_fecha, s.insc_estado, s.insc_fecha_resp);
END;
GO


/* ===========================================================
   =========================================================== */

CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_cursadas
AS
BEGIN
  SET NOCOUNT ON;

  
  ;WITH inscripciones_confirmadas AS (
    SELECT DISTINCT ic.insc_curso, ic.insc_alumno
    FROM DROPDATABASE.Inscripcion_Curso ic
    WHERE ic.insc_estado = 'CONFIRMADA'
  ),
  datos_academicos AS (
    SELECT DISTINCT c.cur_id AS curso_id, a.alum_id AS alumno_id
    FROM gd_esquema.Maestra m
    INNER JOIN DROPDATABASE.Alumno a ON (
      (a.alum_dni = m.Alumno_Dni AND m.Alumno_Dni IS NOT NULL AND m.Alumno_Dni > 0)
      OR 
      (a.alum_legajo = m.Alumno_Legajo AND m.Alumno_Legajo IS NOT NULL AND m.Alumno_Legajo > 0)
    )
    INNER JOIN DROPDATABASE.Curso c ON UPPER(LTRIM(RTRIM(c.cur_nombre))) = UPPER(LTRIM(RTRIM(m.Curso_Nombre)))
    INNER JOIN DROPDATABASE.Sede s ON c.cur_sede = s.sede_id 
      AND UPPER(LTRIM(RTRIM(s.sede_nombre))) = UPPER(LTRIM(RTRIM(m.Sede_Nombre)))
    WHERE m.Curso_Nombre IS NOT NULL 
      AND m.Sede_Nombre IS NOT NULL
      AND (
        m.Evaluacion_Curso_Nota IS NOT NULL 
        OR m.Trabajo_Practico_Nota IS NOT NULL 
        OR m.Examen_Final_Fecha IS NOT NULL
        OR m.Evaluacion_Final_Nota IS NOT NULL
        OR m.Modulo_Nombre IS NOT NULL
        OR m.Inscripcion_Numero IS NOT NULL
      )
  ),
  todas_cursadas AS (
    SELECT insc_curso AS curso_id, insc_alumno AS alumno_id FROM inscripciones_confirmadas
    UNION
    SELECT curso_id, alumno_id FROM datos_academicos
  )
  INSERT INTO DROPDATABASE.Cursada (cursa_curso, cursa_alumno)
  SELECT DISTINCT tc.curso_id, tc.alumno_id
  FROM todas_cursadas tc
  WHERE NOT EXISTS (
    SELECT 1 FROM DROPDATABASE.Cursada c
    WHERE c.cursa_curso = tc.curso_id 
      AND c.cursa_alumno = tc.alumno_id
  );
END;
GO



/* ===========================================================
   =========================================================== */

CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_modulos
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT DISTINCT
      curso_nombre = NULLIF(LTRIM(RTRIM(CAST(m.Curso_Nombre AS nvarchar(255)))), ''),
      sede_nombre_norm = NULLIF(LTRIM(RTRIM(UPPER(CAST(m.Sede_Nombre AS nvarchar(255))))), ''),
      modulo_nombre = NULLIF(LTRIM(RTRIM(CAST(m.Modulo_Nombre AS nvarchar(255)))), ''),
      modulo_desc = NULLIF(LTRIM(RTRIM(CAST(m.Modulo_Descripcion AS nvarchar(255)))), '')
    FROM gd_esquema.Maestra m
    WHERE m.Curso_Nombre IS NOT NULL 
      AND m.Sede_Nombre IS NOT NULL
      AND m.Modulo_Nombre IS NOT NULL
  ),
  curso_lookup AS (
    SELECT c.cur_id, c.cur_nombre, s.sede_nombre
    FROM DROPDATABASE.Curso c
    INNER JOIN DROPDATABASE.Sede s ON c.cur_sede = s.sede_id
  ),
  modulos_con_curso AS (
    SELECT DISTINCT
      cl.cur_id,
      src.modulo_nombre,
      src.modulo_desc
    FROM src
    INNER JOIN curso_lookup cl
      ON UPPER(cl.cur_nombre) = UPPER(src.curso_nombre)
      AND UPPER(cl.sede_nombre) = src.sede_nombre_norm
  )
  MERGE DROPDATABASE.Modulo AS tgt
  USING modulos_con_curso AS s
     ON tgt.mod_curso = s.cur_id 
    AND UPPER(COALESCE(tgt.mod_descripcion, '')) = UPPER(COALESCE(s.modulo_nombre, ''))
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (mod_curso, mod_descripcion)
    VALUES (s.cur_id, s.modulo_nombre);
END;
GO

/* ===========================================================
   =========================================================== */

CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_evaluaciones
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT DISTINCT
      alumno_dni_str = REPLACE(REPLACE(REPLACE(CAST(COALESCE(m.Alumno_Dni, m.Alumno_dni) AS nvarchar(50)),'.',''),'-',''),' ',''),
      alumno_legajo_str = REPLACE(REPLACE(REPLACE(CAST(COALESCE(m.Alumno_Legajo, m.Alumno_legajo) AS nvarchar(50)),'.',''),'-',''),' ',''),
      curso_nombre = NULLIF(LTRIM(RTRIM(CAST(m.Curso_Nombre AS nvarchar(255)))), ''),
      sede_nombre_norm = NULLIF(LTRIM(RTRIM(UPPER(CAST(m.Sede_Nombre AS nvarchar(255))))), ''),
      modulo_nombre = NULLIF(LTRIM(RTRIM(CAST(m.Modulo_Nombre AS nvarchar(255)))), ''),
      eval_nota = TRY_CONVERT(BIGINT, m.Evaluacion_Curso_Nota),
      eval_fecha = TRY_CONVERT(DATETIME2(6), m.Evaluacion_Curso_fechaEvaluacion),
      eval_instancia = TRY_CONVERT(BIGINT, m.Evaluacion_Curso_Instancia),
      eval_presente = TRY_CONVERT(BIT, m.Evaluacion_Curso_Presente)
    FROM gd_esquema.Maestra m
    WHERE (COALESCE(m.Alumno_Dni, m.Alumno_dni) IS NOT NULL OR COALESCE(m.Alumno_Legajo, m.Alumno_legajo) IS NOT NULL)
      AND m.Curso_Nombre IS NOT NULL
      AND m.Sede_Nombre IS NOT NULL
      AND m.Modulo_Nombre IS NOT NULL
  ),
  clean_src AS (
    SELECT 
      alumno_dni = TRY_CONVERT(BIGINT, alumno_dni_str),
      alumno_legajo = TRY_CONVERT(BIGINT, alumno_legajo_str),
      curso_nombre, sede_nombre_norm, modulo_nombre,
      eval_nota, eval_fecha, eval_instancia, eval_presente
    FROM src
  ),
  alumno_lookup AS (
    SELECT a.alum_id, a.alum_dni, a.alum_legajo
    FROM DROPDATABASE.Alumno a
  ),
  modulo_lookup AS (
    SELECT m.mod_id, m.mod_descripcion, c.cur_nombre, s.sede_nombre
    FROM DROPDATABASE.Modulo m
    INNER JOIN DROPDATABASE.Curso c ON m.mod_curso = c.cur_id
    INNER JOIN DROPDATABASE.Sede s ON c.cur_sede = s.sede_id
  ),
  evaluaciones_resueltas AS (
    SELECT DISTINCT
      al.alum_id,
      ml.mod_id,
      cs.eval_nota,
      cs.eval_fecha,
      cs.eval_instancia,
      cs.eval_presente
    FROM clean_src cs
    INNER JOIN alumno_lookup al 
      ON (al.alum_dni = cs.alumno_dni AND cs.alumno_dni IS NOT NULL AND cs.alumno_dni > 0)
      OR (al.alum_legajo = cs.alumno_legajo AND cs.alumno_legajo IS NOT NULL AND cs.alumno_legajo > 0)
    INNER JOIN modulo_lookup ml
      ON UPPER(ml.cur_nombre) = UPPER(cs.curso_nombre)
      AND UPPER(ml.sede_nombre) = cs.sede_nombre_norm
      AND UPPER(COALESCE(ml.mod_descripcion, '')) = UPPER(COALESCE(cs.modulo_nombre, ''))
  )
  MERGE DROPDATABASE.Evaluacion AS tgt
  USING evaluaciones_resueltas AS s
     ON tgt.eval_alumno = s.alum_id 
    AND tgt.eval_modulo = s.mod_id
  WHEN MATCHED THEN
    UPDATE SET
      tgt.eval_nota = COALESCE(s.eval_nota, tgt.eval_nota),
      tgt.eval_fecha = COALESCE(s.eval_fecha, tgt.eval_fecha),
      tgt.eval_instancia = COALESCE(s.eval_instancia, tgt.eval_instancia),
      tgt.eval_presente = COALESCE(s.eval_presente, tgt.eval_presente)
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (eval_alumno, eval_modulo, eval_nota, eval_fecha, eval_instancia, eval_presente)
    VALUES (s.alum_id, s.mod_id, s.eval_nota, s.eval_fecha, s.eval_instancia, s.eval_presente);
END;
GO


/* ===========================================================
   =========================================================== */

CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_trabajos_practicos
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT DISTINCT
      alumno_dni_str = REPLACE(REPLACE(REPLACE(CAST(COALESCE(m.Alumno_Dni, m.Alumno_dni) AS nvarchar(50)),'.',''),'-',''),' ',''),
      alumno_legajo_str = REPLACE(REPLACE(REPLACE(CAST(COALESCE(m.Alumno_Legajo, m.Alumno_legajo) AS nvarchar(50)),'.',''),'-',''),' ',''),
      curso_nombre = NULLIF(LTRIM(RTRIM(CAST(m.Curso_Nombre AS nvarchar(255)))), ''),
      sede_nombre_norm = NULLIF(LTRIM(RTRIM(UPPER(CAST(m.Sede_Nombre AS nvarchar(255))))), ''),
      tp_nota = TRY_CONVERT(BIGINT, m.Trabajo_Practico_Nota),
      tp_fecha = TRY_CONVERT(DATETIME2(6), m.Trabajo_Practico_FechaEvaluacion)
    FROM gd_esquema.Maestra m
    WHERE (COALESCE(m.Alumno_Dni, m.Alumno_dni) IS NOT NULL OR COALESCE(m.Alumno_Legajo, m.Alumno_legajo) IS NOT NULL)
      AND m.Curso_Nombre IS NOT NULL
      AND m.Sede_Nombre IS NOT NULL
      AND (m.Trabajo_Practico_Nota IS NOT NULL OR m.Trabajo_Practico_FechaEvaluacion IS NOT NULL)
  ),
  clean_src AS (
    SELECT 
      alumno_dni = TRY_CONVERT(BIGINT, alumno_dni_str),
      alumno_legajo = TRY_CONVERT(BIGINT, alumno_legajo_str),
      curso_nombre, sede_nombre_norm, tp_nota, tp_fecha
    FROM src
  ),
  cursada_lookup AS (
    SELECT c.cursa_curso, c.cursa_alumno, a.alum_dni, a.alum_legajo, cur.cur_nombre, s.sede_nombre
    FROM DROPDATABASE.Cursada c
    INNER JOIN DROPDATABASE.Alumno a ON c.cursa_alumno = a.alum_id
    INNER JOIN DROPDATABASE.Curso cur ON c.cursa_curso = cur.cur_id
    INNER JOIN DROPDATABASE.Sede s ON cur.cur_sede = s.sede_id
  ),
  tp_resueltos AS (
    SELECT DISTINCT
      cl.cursa_curso,
      cl.cursa_alumno,
      cs.tp_nota,
      cs.tp_fecha
    FROM clean_src cs
    INNER JOIN cursada_lookup cl 
      ON ((cl.alum_dni = cs.alumno_dni AND cs.alumno_dni IS NOT NULL AND cs.alumno_dni > 0)
      OR (cl.alum_legajo = cs.alumno_legajo AND cs.alumno_legajo IS NOT NULL AND cs.alumno_legajo > 0))
      AND UPPER(cl.cur_nombre) = UPPER(cs.curso_nombre)
      AND UPPER(cl.sede_nombre) = cs.sede_nombre_norm
  )
  MERGE DROPDATABASE.Tp AS tgt
  USING tp_resueltos AS s
     ON tgt.tp_curso = s.cursa_curso 
    AND tgt.tp_alumno = s.cursa_alumno
  WHEN MATCHED THEN
    UPDATE SET
      tgt.tp_nota = COALESCE(s.tp_nota, tgt.tp_nota),
      tgt.tp_fecha_eval = COALESCE(s.tp_fecha, tgt.tp_fecha_eval)
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (tp_curso, tp_alumno, tp_nota, tp_fecha_eval)
    VALUES (s.cursa_curso, s.cursa_alumno, s.tp_nota, s.tp_fecha);
END;
GO


/* ===========================================================
   =========================================================== */

CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_finales
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT DISTINCT
      curso_nombre = NULLIF(LTRIM(RTRIM(CAST(m.Curso_Nombre AS nvarchar(255)))), ''),
      sede_nombre_norm = NULLIF(LTRIM(RTRIM(UPPER(CAST(m.Sede_Nombre AS nvarchar(255))))), ''),
      final_fecha = TRY_CONVERT(DATETIME2(6), m.Examen_Final_Fecha)
    FROM gd_esquema.Maestra m
    WHERE m.Curso_Nombre IS NOT NULL 
      AND m.Sede_Nombre IS NOT NULL
      AND m.Examen_Final_Fecha IS NOT NULL
  ),
  curso_lookup AS (
    SELECT c.cur_id, c.cur_nombre, s.sede_nombre
    FROM DROPDATABASE.Curso c
    INNER JOIN DROPDATABASE.Sede s ON c.cur_sede = s.sede_id
  ),
  finales_con_curso AS (
    SELECT DISTINCT
      cl.cur_id,
      src.final_fecha
    FROM src
    INNER JOIN curso_lookup cl
      ON UPPER(cl.cur_nombre) = UPPER(src.curso_nombre)
      AND UPPER(cl.sede_nombre) = src.sede_nombre_norm
  )
  MERGE DROPDATABASE.Final AS tgt
  USING finales_con_curso AS s
     ON tgt.final_curso = s.cur_id 
    AND tgt.final_fecha = s.final_fecha
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (final_fecha, final_curso)
    VALUES (s.final_fecha, s.cur_id);
END;
GO

/* ===========================================================
   =========================================================== */

CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_inscripciones_final
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT DISTINCT
      alumno_dni_str = REPLACE(REPLACE(REPLACE(CAST(COALESCE(m.Alumno_Dni, m.Alumno_dni) AS nvarchar(50)),'.',''),'-',''),' ',''),
      alumno_legajo_str = REPLACE(REPLACE(REPLACE(CAST(COALESCE(m.Alumno_Legajo, m.Alumno_legajo) AS nvarchar(50)),'.',''),'-',''),' ',''),
      curso_nombre = NULLIF(LTRIM(RTRIM(CAST(m.Curso_Nombre AS nvarchar(255)))), ''),
      sede_nombre_norm = NULLIF(LTRIM(RTRIM(UPPER(CAST(m.Sede_Nombre AS nvarchar(255))))), ''),
      final_fecha = TRY_CONVERT(DATETIME2(6), m.Examen_Final_Fecha),
      insc_final_fecha = TRY_CONVERT(DATETIME2(6), m.Inscripcion_Final_Fecha),
      insc_final_nro = TRY_CONVERT(BIGINT, m.Inscripcion_Final_Nro)
    FROM gd_esquema.Maestra m
    WHERE (COALESCE(m.Alumno_Dni, m.Alumno_dni) IS NOT NULL OR COALESCE(m.Alumno_Legajo, m.Alumno_legajo) IS NOT NULL)
      AND m.Curso_Nombre IS NOT NULL
      AND m.Sede_Nombre IS NOT NULL
      AND m.Examen_Final_Fecha IS NOT NULL
  ),
  clean_src AS (
    SELECT 
      alumno_dni = TRY_CONVERT(BIGINT, alumno_dni_str),
      alumno_legajo = TRY_CONVERT(BIGINT, alumno_legajo_str),
      curso_nombre, sede_nombre_norm, final_fecha, insc_final_fecha, insc_final_nro
    FROM src
  ),
  alumno_lookup AS (
    SELECT a.alum_id, a.alum_dni, a.alum_legajo
    FROM DROPDATABASE.Alumno a
  ),
  final_lookup AS (
    SELECT f.final_id, f.final_fecha, c.cur_nombre, s.sede_nombre
    FROM DROPDATABASE.Final f
    INNER JOIN DROPDATABASE.Curso c ON f.final_curso = c.cur_id
    INNER JOIN DROPDATABASE.Sede s ON c.cur_sede = s.sede_id
  ),
  inscripciones_final_resueltas AS (
    SELECT DISTINCT
      al.alum_id,
      fl.final_id,
      cs.insc_final_fecha,
      cs.insc_final_nro
    FROM clean_src cs
    INNER JOIN alumno_lookup al 
      ON (al.alum_dni = cs.alumno_dni AND cs.alumno_dni IS NOT NULL AND cs.alumno_dni > 0)
      OR (al.alum_legajo = cs.alumno_legajo AND cs.alumno_legajo IS NOT NULL AND cs.alumno_legajo > 0)
    INNER JOIN final_lookup fl
      ON UPPER(fl.cur_nombre) = UPPER(cs.curso_nombre)
      AND UPPER(fl.sede_nombre) = cs.sede_nombre_norm
      AND fl.final_fecha = cs.final_fecha
    WHERE insc_final_fecha IS NOT NULL
  )
  MERGE DROPDATABASE.Inscripcion_Final AS tgt
  USING inscripciones_final_resueltas AS s
     ON tgt.insc_alumno = s.alum_id 
    AND tgt.insc_final = s.final_id
  WHEN MATCHED THEN
    UPDATE SET
      tgt.insc_fecha = COALESCE(s.insc_final_fecha, tgt.insc_fecha)
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (insc_fecha, insc_alumno, insc_final)
    VALUES (s.insc_final_fecha, s.alum_id, s.final_id);
END;
GO

/* ===========================================================
   =========================================================== */

CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_evaluaciones_final
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT DISTINCT
      alumno_dni_str = REPLACE(REPLACE(REPLACE(CAST(COALESCE(m.Alumno_Dni, m.Alumno_dni) AS nvarchar(50)),'.',''),'-',''),' ',''),
      alumno_legajo_str = REPLACE(REPLACE(REPLACE(CAST(COALESCE(m.Alumno_Legajo, m.Alumno_legajo) AS nvarchar(50)),'.',''),'-',''),' ',''),
      curso_nombre = NULLIF(LTRIM(RTRIM(CAST(m.Curso_Nombre AS nvarchar(255)))), ''),
      sede_nombre_norm = NULLIF(LTRIM(RTRIM(UPPER(CAST(m.Sede_Nombre AS nvarchar(255))))), ''),
      final_fecha = TRY_CONVERT(DATETIME2(6), m.Examen_Final_Fecha),
      eval_final_nota = TRY_CONVERT(BIGINT, m.Evaluacion_Final_Nota),
      eval_final_presente = CASE 
        WHEN UPPER(CAST(m.Evaluacion_Final_Presente AS nvarchar(10))) IN ('SI', 'S', '1', 'TRUE') THEN 1
        WHEN UPPER(CAST(m.Evaluacion_Final_Presente AS nvarchar(10))) IN ('NO', 'N', '0', 'FALSE') THEN 0
        ELSE NULL
      END,
      prof_dni_str = REPLACE(REPLACE(REPLACE(CAST(COALESCE(m.Profesor_Dni, m.Profesor_dni) AS nvarchar(50)),'.',''),'-',''),' ','')
    FROM gd_esquema.Maestra m
    WHERE (COALESCE(m.Alumno_Dni, m.Alumno_dni) IS NOT NULL OR COALESCE(m.Alumno_Legajo, m.Alumno_legajo) IS NOT NULL)
      AND m.Curso_Nombre IS NOT NULL
      AND m.Sede_Nombre IS NOT NULL
      AND m.Examen_Final_Fecha IS NOT NULL
      AND (m.Evaluacion_Final_Nota IS NOT NULL OR m.Evaluacion_Final_Presente IS NOT NULL)
  ),
  clean_src AS (
    SELECT 
      alumno_dni = TRY_CONVERT(BIGINT, alumno_dni_str),
      alumno_legajo = TRY_CONVERT(BIGINT, alumno_legajo_str),
      curso_nombre, sede_nombre_norm, final_fecha, eval_final_nota, eval_final_presente,
      prof_dni = TRY_CONVERT(BIGINT, prof_dni_str)
    FROM src
  ),
  alumno_lookup AS (
    SELECT a.alum_id, a.alum_dni, a.alum_legajo
    FROM DROPDATABASE.Alumno a
  ),
  profesor_lookup AS (
    SELECT p.prof_id, p.prof_dni
    FROM DROPDATABASE.Profesor p
  ),
  final_lookup AS (
    SELECT f.final_id, f.final_fecha, c.cur_nombre, s.sede_nombre
    FROM DROPDATABASE.Final f
    INNER JOIN DROPDATABASE.Curso c ON f.final_curso = c.cur_id
    INNER JOIN DROPDATABASE.Sede s ON c.cur_sede = s.sede_id
  ),
  evaluaciones_final_resueltas AS (
    SELECT DISTINCT
      fl.final_id,
      al.alum_id,
      cs.eval_final_presente,
      cs.eval_final_nota,
      COALESCE(pl.prof_id, 1) as prof_id -- Default a profesor ID 1 si no se encuentra
    FROM clean_src cs
    INNER JOIN alumno_lookup al 
      ON (al.alum_dni = cs.alumno_dni AND cs.alumno_dni IS NOT NULL AND cs.alumno_dni > 0)
      OR (al.alum_legajo = cs.alumno_legajo AND cs.alumno_legajo IS NOT NULL AND cs.alumno_legajo > 0)
    INNER JOIN final_lookup fl
      ON UPPER(fl.cur_nombre) = UPPER(cs.curso_nombre)
      AND UPPER(fl.sede_nombre) = cs.sede_nombre_norm
      AND fl.final_fecha = cs.final_fecha
    LEFT JOIN profesor_lookup pl ON pl.prof_dni = cs.prof_dni
  )
  MERGE DROPDATABASE.Final_Alumno AS tgt
  USING evaluaciones_final_resueltas AS s
     ON tgt.final_id = s.final_id 
    AND tgt.final_alum = s.alum_id
  WHEN MATCHED THEN
    UPDATE SET
      tgt.presente = COALESCE(s.eval_final_presente, tgt.presente),
      tgt.final_nota = COALESCE(s.eval_final_nota, tgt.final_nota),
      tgt.final_prof = COALESCE(s.prof_id, tgt.final_prof)
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (final_id, final_alum, presente, final_nota, final_prof)
    VALUES (s.final_id, s.alum_id, s.eval_final_presente, s.eval_final_nota, s.prof_id);
END;
GO


/* ===========================================================
   =========================================================== */


CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_facturas
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT DISTINCT
      alumno_dni_str = REPLACE(REPLACE(REPLACE(CAST(COALESCE(m.Alumno_Dni, m.Alumno_dni) AS nvarchar(50)),'.',''),'-',''),' ',''),
      alumno_legajo_str = REPLACE(REPLACE(REPLACE(CAST(COALESCE(m.Alumno_Legajo, m.Alumno_legajo) AS nvarchar(50)),'.',''),'-',''),' ',''),
      fact_numero = TRY_CONVERT(BIGINT, m.Factura_Numero),
      fact_fecha = TRY_CONVERT(DATETIME2(6), m.Factura_FechaEmision),
      fact_vencimiento = TRY_CONVERT(DATETIME2(6), m.Factura_FechaVencimiento),
      fact_total = TRY_CONVERT(DECIMAL(18,2), m.Factura_Total)
    FROM gd_esquema.Maestra m
    WHERE (COALESCE(m.Alumno_Dni, m.Alumno_dni) IS NOT NULL OR COALESCE(m.Alumno_Legajo, m.Alumno_legajo) IS NOT NULL)
      AND m.Factura_Numero IS NOT NULL
  ),
  clean_src AS (
    SELECT 
      alumno_dni = TRY_CONVERT(BIGINT, alumno_dni_str),
      alumno_legajo = TRY_CONVERT(BIGINT, alumno_legajo_str),
      fact_numero, fact_fecha, fact_vencimiento, fact_total
    FROM src
  ),
  alumno_lookup AS (
    SELECT a.alum_id, a.alum_dni, a.alum_legajo
    FROM DROPDATABASE.Alumno a
  ),
  facturas_resueltas AS (
    SELECT DISTINCT
      al.alum_id,
      cs.fact_numero,
      cs.fact_fecha,
      cs.fact_vencimiento,
      cs.fact_total
    FROM clean_src cs
    INNER JOIN alumno_lookup al 
      ON (al.alum_dni = cs.alumno_dni AND cs.alumno_dni IS NOT NULL AND cs.alumno_dni > 0)
      OR (al.alum_legajo = cs.alumno_legajo AND cs.alumno_legajo IS NOT NULL AND cs.alumno_legajo > 0)
  )
  MERGE DROPDATABASE.Factura AS tgt
  USING facturas_resueltas AS s
     ON tgt.fact_alumno = s.alum_id 
    AND tgt.fact_fecha = s.fact_fecha
    AND tgt.fact_total = s.fact_total
  WHEN MATCHED THEN
    UPDATE SET
      tgt.fact_vencimiento = COALESCE(s.fact_vencimiento, tgt.fact_vencimiento)
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (fact_fecha, fact_vencimiento, fact_alumno, fact_total)
    VALUES (s.fact_fecha, s.fact_vencimiento, s.alum_id, s.fact_total);
END;
GO


/* ===========================================================
   =========================================================== */

CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_factura_detalle
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT DISTINCT
      alumno_dni_str = REPLACE(REPLACE(REPLACE(CAST(COALESCE(m.Alumno_Dni, m.Alumno_dni) AS nvarchar(50)),'.',''),'-',''),' ',''),
      alumno_legajo_str = REPLACE(REPLACE(REPLACE(CAST(COALESCE(m.Alumno_Legajo, m.Alumno_legajo) AS nvarchar(50)),'.',''),'-',''),' ',''),
      curso_nombre = NULLIF(LTRIM(RTRIM(CAST(m.Curso_Nombre AS nvarchar(255)))), ''),
      sede_nombre_norm = NULLIF(LTRIM(RTRIM(UPPER(CAST(m.Sede_Nombre AS nvarchar(255))))), ''),
      fact_fecha = TRY_CONVERT(DATETIME2(6), m.Factura_FechaEmision),
      fact_total = TRY_CONVERT(DECIMAL(18,2), m.Factura_Total),
      detalle_importe = TRY_CONVERT(DECIMAL(18,2), m.Detalle_Factura_Importe),
      periodo_anio = TRY_CONVERT(INT, m.Periodo_Anio),
      periodo_mes = TRY_CONVERT(INT, m.Periodo_Mes)
    FROM gd_esquema.Maestra m
    WHERE (COALESCE(m.Alumno_Dni, m.Alumno_dni) IS NOT NULL OR COALESCE(m.Alumno_Legajo, m.Alumno_legajo) IS NOT NULL)
      AND m.Curso_Nombre IS NOT NULL
      AND m.Sede_Nombre IS NOT NULL
      AND m.Factura_FechaEmision IS NOT NULL
      AND m.Detalle_Factura_Importe IS NOT NULL
  ),
  clean_src AS (
    SELECT 
      alumno_dni = TRY_CONVERT(BIGINT, alumno_dni_str),
      alumno_legajo = TRY_CONVERT(BIGINT, alumno_legajo_str),
      curso_nombre, sede_nombre_norm, fact_fecha, fact_total, detalle_importe,
      fact_referencia = CASE 
        WHEN periodo_anio IS NOT NULL AND periodo_mes IS NOT NULL 
        THEN DATEFROMPARTS(periodo_anio, periodo_mes, 1)
        ELSE NULL
      END
    FROM src
  ),
  factura_lookup AS (
    SELECT f.fact_nro, f.fact_fecha, f.fact_total, a.alum_dni, a.alum_legajo
    FROM DROPDATABASE.Factura f
    INNER JOIN DROPDATABASE.Alumno a ON f.fact_alumno = a.alum_id
  ),
  curso_lookup AS (
    SELECT c.cur_id, c.cur_nombre, s.sede_nombre
    FROM DROPDATABASE.Curso c
    INNER JOIN DROPDATABASE.Sede s ON c.cur_sede = s.sede_id
  ),
  detalle_resuelto AS (
    SELECT DISTINCT
      fl.fact_nro,
      cl.cur_id,
      cs.fact_referencia,
      cs.detalle_importe
    FROM clean_src cs
    INNER JOIN factura_lookup fl 
      ON ((fl.alum_dni = cs.alumno_dni AND cs.alumno_dni IS NOT NULL AND cs.alumno_dni > 0)
      OR (fl.alum_legajo = cs.alumno_legajo AND cs.alumno_legajo IS NOT NULL AND cs.alumno_legajo > 0))
      AND fl.fact_fecha = cs.fact_fecha
      AND fl.fact_total = cs.fact_total
    INNER JOIN curso_lookup cl
      ON UPPER(cl.cur_nombre) = UPPER(cs.curso_nombre)
      AND UPPER(cl.sede_nombre) = cs.sede_nombre_norm
  )
  MERGE DROPDATABASE.Factura_Detalle AS tgt
  USING detalle_resuelto AS s
     ON tgt.fact_nro = s.fact_nro 
    AND tgt.fact_curso = s.cur_id
  WHEN MATCHED THEN
    UPDATE SET
      tgt.fact_referencia = COALESCE(s.fact_referencia, tgt.fact_referencia),
      tgt.fact_total = COALESCE(s.detalle_importe, tgt.fact_total)
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (fact_nro, fact_curso, fact_referencia, fact_total)
    VALUES (s.fact_nro, s.cur_id, s.fact_referencia, s.detalle_importe);
END;
GO

/* ===========================================================
   =========================================================== */


CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_pagos
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT DISTINCT
      alumno_dni_str = REPLACE(REPLACE(REPLACE(CAST(COALESCE(m.Alumno_Dni, m.Alumno_dni) AS nvarchar(50)),'.',''),'-',''),' ',''),
      alumno_legajo_str = REPLACE(REPLACE(REPLACE(CAST(COALESCE(m.Alumno_Legajo, m.Alumno_legajo) AS nvarchar(50)),'.',''),'-',''),' ',''),
      fact_fecha = TRY_CONVERT(DATETIME2(6), m.Factura_FechaEmision),
      fact_total = TRY_CONVERT(DECIMAL(18,2), m.Factura_Total),
      pago_fecha = TRY_CONVERT(DATETIME2(6), m.Pago_Fecha),
      pago_importe = TRY_CONVERT(DECIMAL(18,2), m.Pago_Importe),
      pago_medio = NULLIF(LTRIM(RTRIM(CAST(m.Pago_MedioPago AS nvarchar(255)))), '')
    FROM gd_esquema.Maestra m
    WHERE (COALESCE(m.Alumno_Dni, m.Alumno_dni) IS NOT NULL OR COALESCE(m.Alumno_Legajo, m.Alumno_legajo) IS NOT NULL)
      AND m.Factura_FechaEmision IS NOT NULL
      AND m.Pago_Fecha IS NOT NULL
      AND m.Pago_Importe IS NOT NULL
  ),
  clean_src AS (
    SELECT 
      alumno_dni = TRY_CONVERT(BIGINT, alumno_dni_str),
      alumno_legajo = TRY_CONVERT(BIGINT, alumno_legajo_str),
      fact_fecha, fact_total, pago_fecha, pago_importe, pago_medio
    FROM src
  ),
  factura_lookup AS (
    SELECT f.fact_nro, f.fact_fecha, f.fact_total, a.alum_dni, a.alum_legajo
    FROM DROPDATABASE.Factura f
    INNER JOIN DROPDATABASE.Alumno a ON f.fact_alumno = a.alum_id
  ),
  pagos_resueltos AS (
    SELECT DISTINCT
      fl.fact_nro,
      cs.pago_fecha,
      cs.pago_importe,
      cs.pago_medio
    FROM clean_src cs
    INNER JOIN factura_lookup fl 
      ON ((fl.alum_dni = cs.alumno_dni AND cs.alumno_dni IS NOT NULL AND cs.alumno_dni > 0)
      OR (fl.alum_legajo = cs.alumno_legajo AND cs.alumno_legajo IS NOT NULL AND cs.alumno_legajo > 0))
      AND fl.fact_fecha = cs.fact_fecha
      AND fl.fact_total = cs.fact_total
  )
  MERGE DROPDATABASE.Pago AS tgt
  USING pagos_resueltos AS s
     ON tgt.pago_fact = s.fact_nro 
    AND tgt.pago_fecha = s.pago_fecha
    AND tgt.pago_importe = s.pago_importe
  WHEN MATCHED THEN
    UPDATE SET
      tgt.pago_medio_pago = COALESCE(s.pago_medio, tgt.pago_medio_pago)
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (pago_fact, pago_fecha, pago_importe, pago_medio_pago)
    VALUES (s.fact_nro, s.pago_fecha, s.pago_importe, s.pago_medio);
END;
GO

/* ===========================================================
   =========================================================== */


CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_preguntas
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT DISTINCT pregunta_texto
    FROM (
      SELECT pregunta_texto = NULLIF(LTRIM(RTRIM(CAST(m.Encuesta_Pregunta1 AS nvarchar(255)))), '')
      FROM gd_esquema.Maestra m
      WHERE m.Encuesta_Pregunta1 IS NOT NULL
      UNION
      SELECT pregunta_texto = NULLIF(LTRIM(RTRIM(CAST(m.Encuesta_Pregunta2 AS nvarchar(255)))), '')
      FROM gd_esquema.Maestra m
      WHERE m.Encuesta_Pregunta2 IS NOT NULL
      UNION
      SELECT pregunta_texto = NULLIF(LTRIM(RTRIM(CAST(m.Encuesta_Pregunta3 AS nvarchar(255)))), '')
      FROM gd_esquema.Maestra m
      WHERE m.Encuesta_Pregunta3 IS NOT NULL
      UNION
      SELECT pregunta_texto = NULLIF(LTRIM(RTRIM(CAST(m.Encuesta_Pregunta4 AS nvarchar(255)))), '')
      FROM gd_esquema.Maestra m
      WHERE m.Encuesta_Pregunta4 IS NOT NULL
    ) preguntas
    WHERE pregunta_texto IS NOT NULL
  )
  MERGE DROPDATABASE.Pregunta AS tgt
  USING src AS s
     ON UPPER(tgt.pregunta_detalle) = UPPER(s.pregunta_texto)
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (pregunta_detalle)
    VALUES (s.pregunta_texto);
END;
GO

/* ===========================================================
   =========================================================== */


CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_encuestas
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT DISTINCT
      curso_nombre = NULLIF(LTRIM(RTRIM(CAST(m.Curso_Nombre AS nvarchar(255)))), ''),
      sede_nombre_norm = NULLIF(LTRIM(RTRIM(UPPER(CAST(m.Sede_Nombre AS nvarchar(255))))), ''),
      encuesta_fecha = TRY_CONVERT(DATETIME2(6), m.Encuesta_FechaRegistro),
      encuesta_obs = NULLIF(LTRIM(RTRIM(CAST(m.Encuesta_Observacion AS nvarchar(255)))), '')
    FROM gd_esquema.Maestra m
    WHERE m.Curso_Nombre IS NOT NULL 
      AND m.Sede_Nombre IS NOT NULL
      AND m.Encuesta_FechaRegistro IS NOT NULL
  ),
  curso_lookup AS (
    SELECT c.cur_id, c.cur_nombre, s.sede_nombre
    FROM DROPDATABASE.Curso c
    INNER JOIN DROPDATABASE.Sede s ON c.cur_sede = s.sede_id
  ),
  encuestas_con_curso AS (
    SELECT DISTINCT
      cl.cur_id,
      src.encuesta_fecha,
      src.encuesta_obs
    FROM src
    INNER JOIN curso_lookup cl
      ON UPPER(cl.cur_nombre) = UPPER(src.curso_nombre)
      AND UPPER(cl.sede_nombre) = src.sede_nombre_norm
  )
  MERGE DROPDATABASE.Encuesta AS tgt
  USING encuestas_con_curso AS s
     ON tgt.encu_curso = s.cur_id 
    AND tgt.encu_fecha = s.encuesta_fecha
  WHEN MATCHED THEN
    UPDATE SET
      tgt.encu_observaciones = COALESCE(s.encuesta_obs, tgt.encu_observaciones)
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (encu_curso, encu_fecha, encu_observaciones)
    VALUES (s.cur_id, s.encuesta_fecha, s.encuesta_obs);
END;
GO

/* ===========================================================
   =========================================================== */


CREATE OR ALTER PROCEDURE DROPDATABASE.sp_migrar_pregunta_encuesta
AS
BEGIN
  SET NOCOUNT ON;

  IF OBJECT_ID('tempdb..#respuestas_temp') IS NOT NULL DROP TABLE #respuestas_temp;

  ;WITH src AS (
    SELECT 
      curso_nombre = NULLIF(LTRIM(RTRIM(CAST(m.Curso_Nombre AS nvarchar(255)))), ''),
      sede_nombre_norm = NULLIF(LTRIM(RTRIM(UPPER(CAST(m.Sede_Nombre AS nvarchar(255))))), ''),
      encuesta_fecha = TRY_CONVERT(DATETIME2(6), m.Encuesta_FechaRegistro),
      pregunta_texto = NULLIF(LTRIM(RTRIM(CAST(m.Encuesta_Pregunta1 AS nvarchar(255)))), ''),
      respuesta = TRY_CONVERT(BIGINT, m.Encuesta_Nota1)
    FROM gd_esquema.Maestra m
    WHERE m.Curso_Nombre IS NOT NULL 
      AND m.Sede_Nombre IS NOT NULL
      AND m.Encuesta_FechaRegistro IS NOT NULL
      AND m.Encuesta_Pregunta1 IS NOT NULL
    UNION ALL
    SELECT 
      curso_nombre = NULLIF(LTRIM(RTRIM(CAST(m.Curso_Nombre AS nvarchar(255)))), ''),
      sede_nombre_norm = NULLIF(LTRIM(RTRIM(UPPER(CAST(m.Sede_Nombre AS nvarchar(255))))), ''),
      encuesta_fecha = TRY_CONVERT(DATETIME2(6), m.Encuesta_FechaRegistro),
      pregunta_texto = NULLIF(LTRIM(RTRIM(CAST(m.Encuesta_Pregunta2 AS nvarchar(255)))), ''),
      respuesta = TRY_CONVERT(BIGINT, m.Encuesta_Nota2)
    FROM gd_esquema.Maestra m
    WHERE m.Curso_Nombre IS NOT NULL 
      AND m.Sede_Nombre IS NOT NULL
      AND m.Encuesta_FechaRegistro IS NOT NULL
      AND m.Encuesta_Pregunta2 IS NOT NULL
    UNION ALL
    SELECT 
      curso_nombre = NULLIF(LTRIM(RTRIM(CAST(m.Curso_Nombre AS nvarchar(255)))), ''),
      sede_nombre_norm = NULLIF(LTRIM(RTRIM(UPPER(CAST(m.Sede_Nombre AS nvarchar(255))))), ''),
      encuesta_fecha = TRY_CONVERT(DATETIME2(6), m.Encuesta_FechaRegistro),
      pregunta_texto = NULLIF(LTRIM(RTRIM(CAST(m.Encuesta_Pregunta3 AS nvarchar(255)))), ''),
      respuesta = TRY_CONVERT(BIGINT, m.Encuesta_Nota3)
    FROM gd_esquema.Maestra m
    WHERE m.Curso_Nombre IS NOT NULL 
      AND m.Sede_Nombre IS NOT NULL
      AND m.Encuesta_FechaRegistro IS NOT NULL
      AND m.Encuesta_Pregunta3 IS NOT NULL
    UNION ALL
    SELECT 
      curso_nombre = NULLIF(LTRIM(RTRIM(CAST(m.Curso_Nombre AS nvarchar(255)))), ''),
      sede_nombre_norm = NULLIF(LTRIM(RTRIM(UPPER(CAST(m.Sede_Nombre AS nvarchar(255))))), ''),
      encuesta_fecha = TRY_CONVERT(DATETIME2(6), m.Encuesta_FechaRegistro),
      pregunta_texto = NULLIF(LTRIM(RTRIM(CAST(m.Encuesta_Pregunta4 AS nvarchar(255)))), ''),
      respuesta = TRY_CONVERT(BIGINT, m.Encuesta_Nota4)
    FROM gd_esquema.Maestra m
    WHERE m.Curso_Nombre IS NOT NULL 
      AND m.Sede_Nombre IS NOT NULL
      AND m.Encuesta_FechaRegistro IS NOT NULL
      AND m.Encuesta_Pregunta4 IS NOT NULL
  ),
  encuesta_lookup AS (
    SELECT e.encu_nro, e.encu_fecha, c.cur_nombre, s.sede_nombre
    FROM DROPDATABASE.Encuesta e
    INNER JOIN DROPDATABASE.Curso c ON e.encu_curso = c.cur_id
    INNER JOIN DROPDATABASE.Sede s ON c.cur_sede = s.sede_id
  ),
  pregunta_lookup AS (
    SELECT p.pregunta_id, p.pregunta_detalle
    FROM DROPDATABASE.Pregunta p
  ),
  respuestas_raw AS (
    SELECT 
      pl.pregunta_id,
      el.encu_nro,
      src.respuesta,
      ROW_NUMBER() OVER (
        PARTITION BY pl.pregunta_id, el.encu_nro 
        ORDER BY CASE WHEN src.respuesta IS NOT NULL THEN 0 ELSE 1 END
      ) as rn
    FROM src
    INNER JOIN encuesta_lookup el
      ON UPPER(el.cur_nombre) = UPPER(src.curso_nombre)
      AND UPPER(el.sede_nombre) = src.sede_nombre_norm
      AND el.encu_fecha = src.encuesta_fecha
    INNER JOIN pregunta_lookup pl
      ON UPPER(pl.pregunta_detalle) = UPPER(src.pregunta_texto)
    WHERE src.pregunta_texto IS NOT NULL
  )
  SELECT pregunta_id, encu_nro, respuesta
  INTO #respuestas_temp
  FROM respuestas_raw
  WHERE rn = 1; 

  MERGE DROPDATABASE.Pregunta_Encuesta AS tgt
  USING #respuestas_temp AS s
     ON tgt.encuesta_pregunta = s.pregunta_id 
    AND tgt.encuesta_nro = s.encu_nro
  WHEN MATCHED THEN
    UPDATE SET
      tgt.respuesta = COALESCE(s.respuesta, tgt.respuesta)
  WHEN NOT MATCHED BY TARGET THEN
    INSERT (encuesta_pregunta, encuesta_nro, respuesta)
    VALUES (s.pregunta_id, s.encu_nro, s.respuesta);

  DROP TABLE IF EXISTS #respuestas_temp;
END;
GO



/* ===========================================================
    MIGRACIÓN
   =========================================================== */
BEGIN TRY
  BEGIN TRAN;

    EXEC DROPDATABASE.sp_migrar_profesores;
    EXEC DROPDATABASE.sp_migrar_alumnos;
    EXEC DROPDATABASE.sp_migrar_sedes;
    EXEC DROPDATABASE.sp_migrar_cursos;
    
    EXEC DROPDATABASE.sp_migrar_curso_dias;
    EXEC DROPDATABASE.sp_migrar_inscripciones_curso;
    EXEC DROPDATABASE.sp_migrar_cursadas;
    EXEC DROPDATABASE.sp_migrar_modulos;
    EXEC DROPDATABASE.sp_migrar_evaluaciones;
    EXEC DROPDATABASE.sp_migrar_trabajos_practicos;
    EXEC DROPDATABASE.sp_migrar_finales;
    EXEC DROPDATABASE.sp_migrar_inscripciones_final;
    EXEC DROPDATABASE.sp_migrar_evaluaciones_final;
    EXEC DROPDATABASE.sp_migrar_facturas;
    EXEC DROPDATABASE.sp_migrar_factura_detalle;
    EXEC DROPDATABASE.sp_migrar_pagos;
    EXEC DROPDATABASE.sp_migrar_preguntas;
    EXEC DROPDATABASE.sp_migrar_encuestas;
    EXEC DROPDATABASE.sp_migrar_pregunta_encuesta;

  COMMIT TRAN;
END TRY
BEGIN CATCH
  IF @@TRANCOUNT > 0 ROLLBACK TRAN;
  THROW;
END CATCH;
GO