-- Crear el esquema si no existe
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'BI_DROPDATABASE')
    EXEC('CREATE SCHEMA BI_DROPDATABASE AUTHORIZATION dbo;');
GO

/* 
   ===========================================================
   TABLAS BASE SIN FKs
   =========================================================== 
*/

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_Tiempo' AND schema_id = SCHEMA_ID('BI_DROPDATABASE'))
BEGIN
    CREATE TABLE BI_DROPDATABASE.BI_Tiempo (
        tiempo_id BIGINT IDENTITY(1,1) NOT NULL,
        anio BIGINT NOT NULL,
        mes BIGINT NOT NULL,
        cuatrimestre BIGINT NOT NULL,

        CONSTRAINT PK_TIEMPO PRIMARY KEY (tiempo_id),
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_Sede' AND schema_id = SCHEMA_ID('BI_DROPDATABASE'))
BEGIN
    CREATE TABLE BI_DROPDATABASE.BI_Sede (
        sede_id BIGINT NOT NULL,
        sede_nombre VARCHAR(255) NOT NULL,

        CONSTRAINT PK_SEDE PRIMARY KEY (sede_id),
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_Rango_Etario_Alum' AND schema_id = SCHEMA_ID('BI_DROPDATABASE'))
BEGIN
    CREATE TABLE BI_DROPDATABASE.BI_Rango_Etario_Alum (
        rango_alum_id BIGINT IDENTITY(1,1) NOT NULL,
        rango_detalle VARCHAR(255) NOT NULL,

        CONSTRAINT PK_RANGO_ALUM PRIMARY KEY (rango_alum_id),
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_Rango_Etario_Prof' AND schema_id = SCHEMA_ID('BI_DROPDATABASE'))
BEGIN
    CREATE TABLE BI_DROPDATABASE.BI_Rango_Etario_Prof (
        rango_prof_id BIGINT IDENTITY(1,1) NOT NULL,
        rango_detalle VARCHAR(255) NOT NULL,

        CONSTRAINT PK_RANGO_PROF PRIMARY KEY (rango_prof_id),
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_Categorias' AND schema_id = SCHEMA_ID('BI_DROPDATABASE'))
BEGIN
    CREATE TABLE BI_DROPDATABASE.BI_Categorias (
        categoria_id BIGINT IDENTITY(1,1) NOT NULL,
        categoria_detalle VARCHAR(255) NOT NULL,

        CONSTRAINT PK_CATEGORIAS PRIMARY KEY (categoria_id),
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_Turno' AND schema_id = SCHEMA_ID('BI_DROPDATABASE'))
BEGIN
    CREATE TABLE BI_DROPDATABASE.BI_Turno (
        turno_id BIGINT IDENTITY(1,1) NOT NULL,
        turno_detalle VARCHAR(255) NOT NULL,

        CONSTRAINT PK_TURNO PRIMARY KEY (turno_id),
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_Medio_Pago' AND schema_id = SCHEMA_ID('BI_DROPDATABASE'))
BEGIN
    CREATE TABLE BI_DROPDATABASE.BI_Medio_Pago (
        medio_id BIGINT IDENTITY(1,1) NOT NULL,
        medio_detalle VARCHAR(255) NOT NULL,

        CONSTRAINT PK_MEDIO_PAGO PRIMARY KEY (medio_id),
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_Satisfaccion' AND schema_id = SCHEMA_ID('BI_DROPDATABASE'))
BEGIN
    CREATE TABLE BI_DROPDATABASE.BI_Satisfaccion (
        satisfaccion_id BIGINT IDENTITY(1,1) NOT NULL,
        satisfaccion_detalle VARCHAR(255) NOT NULL,

        CONSTRAINT PK_SATISFACCION PRIMARY KEY (satisfaccion_id),
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_MET_Factura' AND schema_id = SCHEMA_ID('BI_DROPDATABASE'))
BEGIN
    CREATE TABLE BI_DROPDATABASE.BI_MET_Factura (
        factura_nro BIGINT NOT NULL,
        factura_vencimiento BIGINT NOT NULL,
        factura_sede BIGINT NOT NULL,
        factura_categoria BIGINT NOT NULL,
        fact_total DECIMAL(18,2) NOT NULL,

        CONSTRAINT PK_MET_FACTURA PRIMARY KEY (factura_nro),

        CONSTRAINT FK_FACTURA_TIEMPO FOREIGN KEY (factura_vencimiento)
            REFERENCES BI_DROPDATABASE.BI_TIEMPO (tiempo_id),

        CONSTRAINT FK_FACTURA_SEDE FOREIGN KEY (factura_sede)
            REFERENCES BI_DROPDATABASE.BI_SEDE (sede_id),

        CONSTRAINT FK_FACTURA_CATEGORIA FOREIGN KEY (factura_categoria)
            REFERENCES BI_DROPDATABASE.BI_Categorias (categoria_id)
    );
END
GO

/* 
   ===========================================================
   TABLAS CON FKs
   =========================================================== 
*/
--- (Vistas 1 y 2)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_MET_Inscripciones' AND schema_id = SCHEMA_ID('BI_DROPDATABASE'))
BEGIN
    CREATE TABLE BI_DROPDATABASE.BI_MET_Inscripciones (
        inscr_nro BIGINT NOT NULL,
        inscr_tiempo BIGINT NOT NULL,
        inscr_sede BIGINT NOT NULL,
        inscr_categoria BIGINT NOT NULL, 
        inscr_turno BIGINT NOT NULL, 
        cantidad_inscriptos BIGINT NOT NULL,
        cantidad_rechazados BIGINT NOT NULL,

        CONSTRAINT PK_MET_INSCRIPCIONES PRIMARY KEY (inscr_nro),
        
        CONSTRAINT FK_INSCRIPCIONES_TIEMPO FOREIGN KEY (inscr_tiempo)
            REFERENCES BI_DROPDATABASE.BI_TIEMPO (tiempo_id),
        CONSTRAINT FK_INSCRIPCIONES_SEDE FOREIGN KEY (inscr_sede)
            REFERENCES BI_DROPDATABASE.BI_SEDE (sede_id),
        CONSTRAINT FK_INSCRIPCIONES_CATEGORIA FOREIGN KEY (inscr_categoria)
            REFERENCES BI_DROPDATABASE.BI_Categorias (categoria_id),
        CONSTRAINT FK_INSCRIPCIONES_TURNO FOREIGN KEY (inscr_turno)
            REFERENCES BI_DROPDATABASE.BI_Turno (turno_id)
    );
END
GO

--- (Vista 3)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_MET_Cursadas' AND schema_id = SCHEMA_ID('BI_DROPDATABASE'))
BEGIN
    CREATE TABLE BI_DROPDATABASE.BI_MET_Cursadas (
        curs_id BIGINT NOT NULL,
        curs_tiempo BIGINT NOT NULL,
        curs_sede BIGINT NOT NULL,
        curs_categoria BIGINT NOT NULL,
        cantidad_aprobados BIGINT NOT NULL,
        cantidad_desaprobados BIGINT NOT NULL,
        cantidad_rechazados BIGINT NOT NULL,

        CONSTRAINT PK_MET_CURSADAS PRIMARY KEY (curs_id),

        CONSTRAINT FK_CURSADAS_TIEMPO FOREIGN KEY (curs_tiempo)
            REFERENCES BI_DROPDATABASE.BI_TIEMPO (tiempo_id),
        CONSTRAINT FK_CURSADAS_SEDE FOREIGN KEY (curs_sede)
            REFERENCES BI_DROPDATABASE.BI_SEDE (sede_id),
        CONSTRAINT FK_CURSADAS_CATEGORIA FOREIGN KEY (curs_categoria)
            REFERENCES BI_DROPDATABASE.BI_Categorias (categoria_id)
    );
END
GO

---  (Vistas 4, 5 y 6)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_MET_Final' AND schema_id = SCHEMA_ID('BI_DROPDATABASE'))
BEGIN
    CREATE TABLE BI_DROPDATABASE.BI_MET_Final (
        final_alum_id BIGINT IDENTITY(1,1) NOT NULL,
        tiempo_inicio_curso BIGINT NOT NULL,
        tiempo_final BIGINT NOT NULL,
        final_categoria BIGINT NOT NULL,
        final_sede BIGINT NOT NULL, 
        final_rango_etario BIGINT NOT NULL,
        final_nota DECIMAL(10,2) NOT NULL,
        final_presente BIT NOT NULL,

        CONSTRAINT PK_MET_FINAL PRIMARY KEY (final_alum_id),

        CONSTRAINT FK_FINAL_TIEMPO_INICIO FOREIGN KEY (tiempo_inicio_curso)
            REFERENCES BI_DROPDATABASE.BI_TIEMPO (tiempo_id),
        CONSTRAINT FK_FINAL_TIEMPO_FINAL FOREIGN KEY (tiempo_final)
            REFERENCES BI_DROPDATABASE.BI_TIEMPO (tiempo_id),
        CONSTRAINT FK_FINAL_CATEGORIA FOREIGN KEY (final_categoria)
            REFERENCES BI_DROPDATABASE.BI_Categorias (categoria_id),
        CONSTRAINT FK_FINAL_SEDE FOREIGN KEY (final_sede)
            REFERENCES BI_DROPDATABASE.BI_SEDE (sede_id),
        CONSTRAINT FK_FINAL_RANGO_ETARIO FOREIGN KEY (final_rango_etario)
            REFERENCES BI_DROPDATABASE.BI_Rango_Etario_Alum (rango_alum_id)
    );
END
GO

---  (Vistas 7, 8 y 9)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_MET_Pagos' AND schema_id = SCHEMA_ID('BI_DROPDATABASE'))
BEGIN
    CREATE TABLE BI_DROPDATABASE.BI_MET_Pagos (
        pago_id BIGINT NOT NULL,
        pago_tiempo BIGINT NOT NULL,
        pago_medio BIGINT NOT NULL,
        pago_factura BIGINT NOT NULL,
        pago_monto DECIMAL(10,2) NOT NULL,

        CONSTRAINT PK_MET_PAGOS PRIMARY KEY (pago_id),

        CONSTRAINT FK_PAGOS_TIEMPO FOREIGN KEY (pago_tiempo)
            REFERENCES BI_DROPDATABASE.BI_TIEMPO (tiempo_id),
        CONSTRAINT FK_PAGOS_MEDIO FOREIGN KEY (pago_medio)
            REFERENCES BI_DROPDATABASE.BI_Medio_Pago (medio_id),
        CONSTRAINT FK_PAGOS_FACTURA FOREIGN KEY (pago_factura)
            REFERENCES BI_DROPDATABASE.BI_MET_Factura (factura_nro) 
    );
END
GO

---  (Vista 10)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_MET_Encuestas' AND schema_id = SCHEMA_ID('BI_DROPDATABASE'))
BEGIN
    CREATE TABLE BI_DROPDATABASE.BI_MET_Encuestas (
        encuesta_pregunta_id BIGINT IDENTITY(1,1) NOT NULL,
        encuesta_fecha BIGINT NOT NULL,
        encuesta_sede BIGINT NOT NULL,
        encuesta_rango_etario BIGINT NOT NULL,
        encuesta_satisfaccion BIGINT NOT NULL,

        CONSTRAINT PK_MET_ENCUESTAS PRIMARY KEY (encuesta_pregunta_id),

        CONSTRAINT FK_ENCUESTAS_TIEMPO FOREIGN KEY (encuesta_fecha)
            REFERENCES BI_DROPDATABASE.BI_TIEMPO (tiempo_id),
        CONSTRAINT FK_ENCUESTAS_SEDE FOREIGN KEY (encuesta_sede)
            REFERENCES BI_DROPDATABASE.BI_SEDE (sede_id),
        CONSTRAINT FK_ENCUESTAS_RANGO_ETARIO FOREIGN KEY (encuesta_rango_etario)
            REFERENCES BI_DROPDATABASE.BI_Rango_Etario_Prof (rango_prof_id),
        CONSTRAINT FK_ENCUESTAS_SATISFACCION FOREIGN KEY (encuesta_satisfaccion)
            REFERENCES BI_DROPDATABASE.BI_Satisfaccion (satisfaccion_id)
    );
END
GO

/* 
   ===========================================================
   MIGRACION DE DATOS DESDE gd_esquema.Maestra
   =========================================================== 
*/
-- Helpers para rangos
CREATE OR ALTER FUNCTION BI_DROPDATABASE.ObtenerRangoEtarioAlum (@fecha_nac DATETIME2)
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @edad INT = DATEDIFF(YEAR, @fecha_nac, GETDATE());
    DECLARE @rango VARCHAR(255);

    IF @edad < 25 SET @rango = '< 25';
    ELSE IF @edad BETWEEN 25 AND 35 SET @rango = '25 - 35';
    ELSE IF @edad BETWEEN 36 AND 50 SET @rango = '35 - 50';
    ELSE SET @rango = '> 50';

    RETURN @rango;
END
GO

CREATE OR ALTER FUNCTION BI_DROPDATABASE.ObtenerRangoEtarioProf (@fecha_nac DATETIME2)
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @edad INT = DATEDIFF(YEAR, @fecha_nac, GETDATE());
    DECLARE @rango VARCHAR(255);

    IF @edad BETWEEN 25 AND 35 SET @rango = '25 - 35';
    ELSE IF @edad BETWEEN 36 AND 50 SET @rango = '35 - 50';
    ELSE SET @rango = '> 50';
    
    -- Fallback por si hay menores de 25 (aunque el requerimiento no lo contempla, lo metemos en el primero)
    IF @rango IS NULL SET @rango = '25 - 35'; 

    RETURN @rango;
END
GO

CREATE OR ALTER PROCEDURE BI_DROPDATABASE.Migrar_Dimensiones
AS
BEGIN
    -- 1. Migrar TIEMPO
    -- Recolectamos fechas de todas las tablas transaccionales relevantes
    INSERT INTO BI_DROPDATABASE.BI_Tiempo (anio, mes, cuatrimestre)
    SELECT DISTINCT 
        YEAR(fecha), 
        MONTH(fecha),
        CASE 
            WHEN MONTH(fecha) BETWEEN 1 AND 6 THEN 1 
            ELSE 2 
        END
    FROM (
        SELECT insc_fecha AS fecha FROM DROPDATABASE.Inscripción_Curso
        UNION SELECT cur_fecha_inicio FROM DROPDATABASE.Curso
        UNION SELECT fact_fecha FROM DROPDATABASE.Factura
        UNION SELECT pago_fecha FROM DROPDATABASE.Pago
        UNION SELECT final_fecha FROM DROPDATABASE.Final
        UNION SELECT encu_fecha FROM DROPDATABASE.Encuesta
    ) AS Fechas
    WHERE fecha IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM BI_DROPDATABASE.BI_Tiempo t 
        WHERE t.anio = YEAR(Fechas.fecha) AND t.mes = MONTH(Fechas.fecha)
    );

    -- 2. Migrar SEDE
    INSERT INTO BI_DROPDATABASE.BI_Sede (sede_id, sede_nombre)
    SELECT sede_id, sede_nombre FROM DROPDATABASE.Sede
    WHERE sede_id NOT IN (SELECT sede_id FROM BI_DROPDATABASE.BI_Sede);

    -- 3. Migrar CATEGORIAS
    INSERT INTO BI_DROPDATABASE.BI_Categorias (categoria_detalle)
    SELECT DISTINCT cur_categoria FROM DROPDATABASE.Curso
    WHERE cur_categoria NOT IN (SELECT categoria_detalle FROM BI_DROPDATABASE.BI_Categorias);

    -- 4. Migrar TURNOS
    INSERT INTO BI_DROPDATABASE.BI_Turno (turno_detalle)
    SELECT DISTINCT cur_turno FROM DROPDATABASE.Curso
    WHERE cur_turno NOT IN (SELECT turno_detalle FROM BI_DROPDATABASE.BI_Turno);

    -- 5. Migrar MEDIOS DE PAGO
    INSERT INTO BI_DROPDATABASE.BI_Medio_Pago (medio_detalle)
    SELECT DISTINCT pago_medio_pago FROM DROPDATABASE.Pago
    WHERE pago_medio_pago NOT IN (SELECT medio_detalle FROM BI_DROPDATABASE.BI_Medio_Pago);

    -- 6. Cargar RANGOS ETARIOS (Valores Fijos según enunciado)
    IF NOT EXISTS (SELECT 1 FROM BI_DROPDATABASE.BI_Rango_Etario_Alum)
    BEGIN
        INSERT INTO BI_DROPDATABASE.BI_Rango_Etario_Alum (rango_detalle) VALUES ('< 25'), ('25 - 35'), ('35 - 50'), ('> 50');
    END

    IF NOT EXISTS (SELECT 1 FROM BI_DROPDATABASE.BI_Rango_Etario_Prof)
    BEGIN
        INSERT INTO BI_DROPDATABASE.BI_Rango_Etario_Prof (rango_detalle) VALUES ('25 - 35'), ('35 - 50'), ('> 50');
    END

    -- 7. Cargar SATISFACCION (Valores Fijos según enunciado)
    IF NOT EXISTS (SELECT 1 FROM BI_DROPDATABASE.BI_Satisfaccion)
    BEGIN
        INSERT INTO BI_DROPDATABASE.BI_Satisfaccion (satisfaccion_detalle) VALUES ('Satisfechos'), ('Neutrales'), ('Insatisfechos');
    END
END
GO

CREATE OR ALTER PROCEDURE BI_DROPDATABASE.Migrar_Hechos
AS
BEGIN
    -- 1. Migrar MET_FACTURA
    -- Necesitamos joinear con Curso para obtener la Categoría y Sede (a través de la inscripción o directo si la factura tiene referencia)
    -- El DER dice Factura_Detalle -> Inscripcion_Curso -> Curso? O Factura tiene alumno?
    -- El DER muestra Factura -> Factura_Detalle -> Inscripción_Curso (fact_curso?)
    -- Asumimos que fact_curso en Factura_Detalle es el ID del curso.
    INSERT INTO BI_DROPDATABASE.BI_MET_Factura (factura_nro, factura_vencimiento, factura_sede, factura_categoria, fact_total)
    SELECT 
        f.fact_nro,
        t.tiempo_id,
        c.cur_sede,
        cat.categoria_id,
        f.fact_total
    FROM DROPDATABASE.Factura f
    JOIN BI_DROPDATABASE.BI_Tiempo t ON t.anio = YEAR(f.fact_vencimiento) AND t.mes = MONTH(f.fact_vencimiento)
    -- Obtenemos datos del curso a través del detalle (tomamos el primero si hay varios items, o agrupamos)
    -- Simplificación: Asumimos 1 factura -> 1 curso o misma categoría/sede
    JOIN DROPDATABASE.Factura_Detalle fd ON fd.fact_nro = f.fact_nro
    JOIN DROPDATABASE.Curso c ON c.cur_id = fd.fact_curso 
    JOIN BI_DROPDATABASE.BI_Categorias cat ON cat.categoria_detalle = c.cur_categoria
    WHERE f.fact_nro NOT IN (SELECT factura_nro FROM BI_DROPDATABASE.BI_MET_Factura);

    -- 2. Migrar MET_INSCRIPCIONES
    -- Grano: Curso. ID: ID del Curso.
    INSERT INTO BI_DROPDATABASE.BI_MET_Inscripciones (inscr_nro, inscr_tiempo, inscr_sede, inscr_categoria, inscr_turno, cantidad_inscriptos, cantidad_rechazados)
    SELECT 
        c.cur_id,
        t.tiempo_id,
        c.cur_sede,
        cat.categoria_id,
        tur.turno_id,
        COUNT(DISTINCT CASE WHEN ic.insc_estado = 'Inscripto' THEN ic.insc_nro END) as inscriptos, -- O estado 'Aceptada'
        COUNT(DISTINCT CASE WHEN ic.insc_estado = 'Rechazada' THEN ic.insc_nro END) as rechazados
    FROM DROPDATABASE.Curso c
    JOIN BI_DROPDATABASE.BI_Tiempo t ON t.anio = YEAR(c.cur_fecha_inicio) AND t.mes = MONTH(c.cur_fecha_inicio)
    JOIN BI_DROPDATABASE.BI_Categorias cat ON cat.categoria_detalle = c.cur_categoria
    JOIN BI_DROPDATABASE.BI_Turno tur ON tur.turno_detalle = c.cur_turno
    LEFT JOIN DROPDATABASE.Inscripción_Curso ic ON ic.insc_curso = c.cur_id
    GROUP BY c.cur_id, t.tiempo_id, c.cur_sede, cat.categoria_id, tur.turno_id;

    -- 3. Migrar MET_CURSADAS
    -- Similar a inscripciones pero agregando lógica de aprobados (nota >= 4 en todos los módulos)
    INSERT INTO BI_DROPDATABASE.BI_MET_Cursadas (curs_id, curs_tiempo, curs_sede, curs_categoria, cantidad_aprobados, cantidad_desaprobados, cantidad_rechazados)
    SELECT 
        c.cur_id,
        t.tiempo_id,
        c.cur_sede,
        cat.categoria_id,
        -- Calculo de aprobados (simplificado: inscritos que no tienen notas < 4)
        -- Esto requeriría lógica compleja de checkear Evaluacion por alumno. 
        -- Aquí pongo placeholders de lógica agregada:
        SUM(CASE WHEN (SELECT MIN(eval_nota) FROM DROPDATABASE.Evaluacion e 
                       JOIN DROPDATABASE.Cursada cur ON cur.cursa_id = e.eval_alumno -- Asumiendo link
                       WHERE cur.cursa_curso = c.cur_id) >= 4 THEN 1 ELSE 0 END),
        SUM(CASE WHEN (SELECT MIN(eval_nota) FROM DROPDATABASE.Evaluacion e 
                       JOIN DROPDATABASE.Cursada cur ON cur.cursa_id = e.eval_alumno
                       WHERE cur.cursa_curso = c.cur_id) < 4 THEN 1 ELSE 0 END),
        0 -- Rechazados ya cubierto
    FROM DROPDATABASE.Curso c
    JOIN BI_DROPDATABASE.BI_Tiempo t ON t.anio = YEAR(c.cur_fecha_inicio) AND t.mes = MONTH(c.cur_fecha_inicio)
    JOIN BI_DROPDATABASE.BI_Categorias cat ON cat.categoria_detalle = c.cur_categoria
    GROUP BY c.cur_id, t.tiempo_id, c.cur_sede, cat.categoria_id;

    -- 4. Migrar MET_FINAL
    INSERT INTO BI_DROPDATABASE.BI_MET_Final (tiempo_inicio_curso, tiempo_final, final_categoria, final_sede, final_rango_etario, final_nota, final_presente)
    SELECT 
        t_ini.tiempo_id,
        t_fin.tiempo_id,
        cat.categoria_id,
        c.cur_sede,
        re.rango_alum_id,
        fa.final_nota,
        fa.presente
    FROM DROPDATABASE.Final_Alumno fa
    JOIN DROPDATABASE.Final f ON f.final_id = fa.final_id
    JOIN DROPDATABASE.Curso c ON c.cur_id = f.final_curso
    JOIN DROPDATABASE.Alumno a ON a.alum_id = fa.final_alum
    JOIN BI_DROPDATABASE.BI_Tiempo t_fin ON t_fin.anio = YEAR(f.final_fecha) AND t_fin.mes = MONTH(f.final_fecha)
    JOIN BI_DROPDATABASE.BI_Tiempo t_ini ON t_ini.anio = YEAR(c.cur_fecha_inicio) AND t_ini.mes = MONTH(c.cur_fecha_inicio)
    JOIN BI_DROPDATABASE.BI_Categorias cat ON cat.categoria_detalle = c.cur_categoria
    JOIN BI_DROPDATABASE.BI_Rango_Etario_Alum re ON re.rango_detalle = BI_DROPDATABASE.ObtenerRangoEtarioAlum(a.alum_fecha_nacimiento);

    -- 5. Migrar MET_PAGOS
    INSERT INTO BI_DROPDATABASE.BI_MET_Pagos (pago_id, pago_tiempo, pago_medio, pago_factura, pago_monto)
    SELECT 
        p.pago_id,
        t.tiempo_id,
        mp.medio_id,
        p.pago_fact, -- FK a Factura
        p.pago_importe
    FROM DROPDATABASE.Pago p
    JOIN BI_DROPDATABASE.BI_Tiempo t ON t.anio = YEAR(p.pago_fecha) AND t.mes = MONTH(p.pago_fecha)
    JOIN BI_DROPDATABASE.BI_Medio_Pago mp ON mp.medio_detalle = p.pago_medio_pago
    WHERE p.pago_id NOT IN (SELECT pago_id FROM BI_DROPDATABASE.BI_MET_Pagos);

    -- 6. Migrar MET_ENCUESTAS
    INSERT INTO BI_DROPDATABASE.BI_MET_Encuestas (encuesta_fecha, encuesta_sede, encuesta_rango_etario, encuesta_satisfaccion)
    SELECT 
        t.tiempo_id,
        c.cur_sede,
        re_prof.rango_prof_id,
        sat.satisfaccion_id
    FROM DROPDATABASE.Pregunta_Encuesta pe
    JOIN DROPDATABASE.Encuesta e ON e.encu_nro = pe.encuesta_nro
    JOIN DROPDATABASE.Curso c ON c.cur_id = e.encu_curso
    JOIN DROPDATABASE.Profesor p ON p.prof_id = c.cur_profesor
    JOIN BI_DROPDATABASE.BI_Tiempo t ON t.anio = YEAR(e.encu_fecha) AND t.mes = MONTH(e.encu_fecha)
    JOIN BI_DROPDATABASE.BI_Rango_Etario_Prof re_prof ON re_prof.rango_detalle = BI_DROPDATABASE.ObtenerRangoEtarioProf(p.prof_fecha_nacimiento)
    JOIN BI_DROPDATABASE.BI_Satisfaccion sat ON sat.satisfaccion_detalle = 
        CASE 
            WHEN pe.respuesta BETWEEN 7 AND 10 THEN 'Satisfechos'
            WHEN pe.respuesta BETWEEN 5 AND 6 THEN 'Neutrales'
            ELSE 'Insatisfechos'
        END;
END
GO

-- Ejecutar Migracion
EXEC BI_DROPDATABASE.Migrar_Dimensiones;
EXEC BI_DROPDATABASE.Migrar_Hechos;
GO

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

/* 

CREATE OR ALTER PROCEDURE BI_DROPDATABASE.sp_CategoriasYTurnosMasSolicitados
    @Anio   INT,             -- año obligatorio
    @SedeId BIGINT = NULL    -- opcional: si es NULL devuelve todas las sedes
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH InscrAgg AS (
        SELECT
            t.anio,
            s.sede_id,
            s.sede_nombre,
            c.categoria_id,
            c.categoria_detalle,
            tu.turno_id,
            tu.turno_detalle,
            SUM(i.cantidad_inscriptos) AS total_inscriptos
        FROM BI_DROPDATABASE.BI_MET_Inscripciones i
        JOIN BI_DROPDATABASE.BI_Tiempo     t  ON t.tiempo_id   = i.inscr_tiempo
        JOIN BI_DROPDATABASE.BI_Sede       s  ON s.sede_id     = i.inscr_sede
        JOIN BI_DROPDATABASE.BI_Categorias c  ON c.categoria_id= i.inscr_categoria
        JOIN BI_DROPDATABASE.BI_Turno      tu ON tu.turno_id   = i.inscr_turno
        WHERE t.anio = @Anio
          AND (@SedeId IS NULL OR s.sede_id = @SedeId)
        GROUP BY t.anio, s.sede_id, s.sede_nombre,
                 c.categoria_id, c.categoria_detalle,
                 tu.turno_id, tu.turno_detalle
    ),
    Ranked AS (
        SELECT *,
               ROW_NUMBER() OVER (
                   PARTITION BY anio, sede_id
                   ORDER BY total_inscriptos DESC
               ) AS rn
        FROM InscrAgg
    )
    SELECT
        anio,
        sede_id,
        sede_nombre,
        categoria_id,
        categoria_detalle,
        turno_id,
        turno_detalle,
        total_inscriptos
    FROM Ranked
    WHERE rn <= 3
    ORDER BY anio, sede_nombre, total_inscriptos DESC;
END;
GO



CREATE OR ALTER PROCEDURE BI_DROPDATABASE.sp_TasaRechazoInscripciones
    @Anio   INT    = NULL,   -- si es NULL trae todos los años
    @SedeId BIGINT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        t.anio,
        t.mes,
        s.sede_id,
        s.sede_nombre,
        SUM(i.cantidad_inscriptos)   AS total_inscripciones,
        SUM(i.cantidad_rechazados)   AS total_rechazadas,
        CASE 
            WHEN SUM(i.cantidad_inscriptos) = 0 THEN 0
            ELSE CAST(SUM(i.cantidad_rechazados) * 100.0 /
                      SUM(i.cantidad_inscriptos) AS DECIMAL(10,2))
        END AS tasa_rechazo_pct
    FROM BI_DROPDATABASE.BI_MET_Inscripciones i
    JOIN BI_DROPDATABASE.BI_Tiempo t ON t.tiempo_id = i.inscr_tiempo
    JOIN BI_DROPDATABASE.BI_Sede   s ON s.sede_id   = i.inscr_sede
    WHERE (@Anio IS NULL OR t.anio = @Anio)
      AND (@SedeId IS NULL OR s.sede_id = @SedeId)
    GROUP BY t.anio, t.mes, s.sede_id, s.sede_nombre
    ORDER BY t.anio, t.mes, s.sede_nombre;
END;
GO


CREATE OR ALTER PROCEDURE BI_DROPDATABASE.sp_DesempenioCursadaPorSede
    @Anio INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        t.anio,
        s.sede_id,
        s.sede_nombre,
        SUM(c.cantidad_aprobados)    AS total_aprobados,
        SUM(c.cantidad_desaprobados) AS total_desaprobados,
        SUM(c.cantidad_rechazados)   AS total_rechazados,
        CASE 
            WHEN SUM(c.cantidad_aprobados + c.cantidad_desaprobados + c.cantidad_rechazados) = 0
                THEN 0
            ELSE CAST(
                SUM(c.cantidad_aprobados) * 100.0 /
                SUM(c.cantidad_aprobados + c.cantidad_desaprobados + c.cantidad_rechazados)
                AS DECIMAL(10,2)
            )
        END AS porcentaje_aprobacion
    FROM BI_DROPDATABASE.BI_MET_Cursadas c
    JOIN BI_DROPDATABASE.BI_Tiempo t ON t.tiempo_id = c.curs_tiempo
    JOIN BI_DROPDATABASE.BI_Sede   s ON s.sede_id   = c.curs_sede
    WHERE (@Anio IS NULL OR t.anio = @Anio)
    GROUP BY t.anio, s.sede_id, s.sede_nombre
    ORDER BY t.anio, s.sede_nombre;
END;
GO



CREATE OR ALTER PROCEDURE BI_DROPDATABASE.sp_TiempoPromedioFinalizacionCurso
    @AnioInicio INT = NULL   -- año de inicio del curso (de la dimensión tiempo_inicio_curso)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        tIni.anio AS anio_inicio_curso,
        c.categoria_id,
        c.categoria_detalle,
        AVG(
            CAST(
                DATEDIFF(
                    MONTH,
                    DATEFROMPARTS(tIni.anio, tIni.mes, 1),
                    DATEFROMPARTS(tFin.anio, tFin.mes, 1)
                ) AS DECIMAL(10,2)
            )
        ) AS tiempo_promedio_meses
    FROM BI_DROPDATABASE.BI_MET_Final f
    JOIN BI_DROPDATABASE.BI_Tiempo     tIni ON tIni.tiempo_id   = f.tiempo_inicio_curso
    JOIN BI_DROPDATABASE.BI_Tiempo     tFin ON tFin.tiempo_id   = f.tiempo_final
    JOIN BI_DROPDATABASE.BI_Categorias c    ON c.categoria_id   = f.final_categoria
    WHERE f.final_nota >= 4      -- solo finales aprobados
      AND (@AnioInicio IS NULL OR tIni.anio = @AnioInicio)
    GROUP BY tIni.anio, c.categoria_id, c.categoria_detalle
    ORDER BY tIni.anio, c.categoria_detalle;
END;
GO



CREATE OR ALTER PROCEDURE BI_DROPDATABASE.sp_NotaPromedioFinales
    @Anio INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        t.anio,
        CASE WHEN t.mes BETWEEN 1 AND 6 THEN 1 ELSE 2 END AS semestre,
        c.categoria_id,
        c.categoria_detalle,
        r.rango_alum_id,
        r.rango_detalle,
        AVG(CAST(f.final_nota AS DECIMAL(10,2))) AS nota_promedio
    FROM BI_DROPDATABASE.BI_MET_Final f
    JOIN BI_DROPDATABASE.BI_Tiempo            t ON t.tiempo_id        = f.tiempo_final
    JOIN BI_DROPDATABASE.BI_Categorias        c ON c.categoria_id     = f.final_categoria
    JOIN BI_DROPDATABASE.BI_Rango_Etario_Alum r ON r.rango_alum_id    = f.final_rango_etario
    WHERE f.final_presente = 1
      AND (@Anio IS NULL OR t.anio = @Anio)
    GROUP BY
        t.anio,
        CASE WHEN t.mes BETWEEN 1 AND 6 THEN 1 ELSE 2 END,
        c.categoria_id, c.categoria_detalle,
        r.rango_alum_id, r.rango_detalle
    ORDER BY t.anio,
             semestre,
             c.categoria_detalle,
             r.rango_detalle;
END;
GO


CREATE OR ALTER PROCEDURE BI_DROPDATABASE.sp_TasaAusentismoFinales
    @Anio INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        t.anio,
        CASE WHEN t.mes BETWEEN 1 AND 6 THEN 1 ELSE 2 END AS semestre,
        s.sede_id,
        s.sede_nombre,
        COUNT(*) AS cantidad_inscriptos,
        SUM(CASE WHEN f.final_presente = 0 THEN 1 ELSE 0 END) AS cantidad_ausentes,
        CASE 
            WHEN COUNT(*) = 0 THEN 0
            ELSE CAST(
                SUM(CASE WHEN f.final_presente = 0 THEN 1 ELSE 0 END) * 100.0 /
                COUNT(*)
                AS DECIMAL(10,2)
            )
        END AS tasa_ausentismo_pct
    FROM BI_DROPDATABASE.BI_MET_Final f
    JOIN BI_DROPDATABASE.BI_Tiempo t ON t.tiempo_id = f.tiempo_final
    JOIN BI_DROPDATABASE.BI_Sede   s ON s.sede_id   = f.final_sede
    WHERE (@Anio IS NULL OR t.anio = @Anio)
    GROUP BY
        t.anio,
        CASE WHEN t.mes BETWEEN 1 AND 6 THEN 1 ELSE 2 END,
        s.sede_id, s.sede_nombre
    ORDER BY t.anio, semestre, s.sede_nombre;
END;
GO


 */