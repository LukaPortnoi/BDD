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
        SELECT insc_fecha AS fecha FROM DROPDATABASE.Inscripcion_Curso
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

CREATE OR ALTER PROCEDURE BI_DROPDATABASE.Migrar_Fact_Factura
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO BI_DROPDATABASE.BI_MET_Factura (factura_nro, factura_vencimiento, factura_sede, factura_categoria, fact_total)
    SELECT 
        f.fact_nro,
        t.tiempo_id,
        c.cur_sede,
        cat.categoria_id,
        f.fact_total
    FROM DROPDATABASE.Factura f
    JOIN BI_DROPDATABASE.BI_Tiempo t ON t.anio = YEAR(f.fact_vencimiento) AND t.mes = MONTH(f.fact_vencimiento)
    JOIN DROPDATABASE.Factura_Detalle fd ON fd.fact_nro = f.fact_nro
    JOIN DROPDATABASE.Curso c ON c.cur_id = fd.fact_curso 
    JOIN BI_DROPDATABASE.BI_Categorias cat ON cat.categoria_detalle = c.cur_categoria
    WHERE f.fact_nro NOT IN (SELECT factura_nro FROM BI_DROPDATABASE.BI_MET_Factura)
    GROUP BY f.fact_nro, t.tiempo_id, c.cur_sede, cat.categoria_id, f.fact_total;
END
GO

CREATE OR ALTER PROCEDURE BI_DROPDATABASE.Migrar_Fact_Inscripciones
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO BI_DROPDATABASE.BI_MET_Inscripciones (inscr_nro, inscr_tiempo, inscr_sede, inscr_categoria, inscr_turno, cantidad_inscriptos, cantidad_rechazados)
    SELECT 
        c.cur_id,
        t.tiempo_id,
        c.cur_sede,
        cat.categoria_id,
        tur.turno_id,
        COUNT(DISTINCT CASE WHEN ic.insc_estado = 'CONFIRMADA' THEN ic.insc_nro END), 
        COUNT(DISTINCT CASE WHEN ic.insc_estado = 'Pendiente' THEN ic.insc_nro END)
    FROM DROPDATABASE.Curso c
    JOIN BI_DROPDATABASE.BI_Tiempo t ON t.anio = YEAR(c.cur_fecha_inicio) AND t.mes = MONTH(c.cur_fecha_inicio)
    JOIN BI_DROPDATABASE.BI_Categorias cat ON cat.categoria_detalle = c.cur_categoria
    JOIN BI_DROPDATABASE.BI_Turno tur ON tur.turno_detalle = c.cur_turno
    LEFT JOIN DROPDATABASE.Inscripcion_Curso ic ON ic.insc_curso = c.cur_id
    WHERE c.cur_id NOT IN (SELECT inscr_nro FROM BI_DROPDATABASE.BI_MET_Inscripciones)
    GROUP BY c.cur_id, t.tiempo_id, c.cur_sede, cat.categoria_id, tur.turno_id;
END
GO

CREATE OR ALTER PROCEDURE BI_DROPDATABASE.Migrar_Fact_Cursadas
AS
BEGIN
    SET NOCOUNT ON;

    -- Limpiamos la tabla por si se corre varias veces (opcional, según tu flujo)
    -- DELETE FROM BI_DROPDATABASE.BI_MET_Cursadas; 

    INSERT INTO BI_DROPDATABASE.BI_MET_Cursadas (
        curs_id, 
        curs_tiempo, 
        curs_sede, 
        curs_categoria, 
        cantidad_aprobados, 
        cantidad_desaprobados, 
        cantidad_rechazados
    )
    SELECT 
        c.cur_id,
        t.tiempo_id,
        c.cur_sede, -- Asumiendo que el ID de sede coincide, si no, hacer JOIN con BI_SEDE
        cat.categoria_id,
        
        -- Cálculo de Aprobados
        SUM(CASE WHEN EstadoAlumno.EsAprobado = 1 THEN 1 ELSE 0 END) as cant_aprobados,
        
        -- Cálculo de Desaprobados (Estuvieron en la cursada pero no aprobaron)
        SUM(CASE WHEN EstadoAlumno.EsAprobado = 0 THEN 1 ELSE 0 END) as cant_desaprobados,
        
        -- Cálculo de Rechazados (Desde Inscripciones)
        ISNULL((
            SELECT COUNT(*) 
            FROM DROPDATABASE.Inscripcion_Curso ic_rech
            WHERE ic_rech.insc_curso = c.cur_id AND ic_rech.insc_estado = 'Rechazada' -- Ajustar string según tus datos
        ), 0) as cant_rechazados

    FROM DROPDATABASE.Curso c
    JOIN BI_DROPDATABASE.BI_Tiempo t ON t.anio = YEAR(c.cur_fecha_inicio) AND t.mes = MONTH(c.cur_fecha_inicio)
    JOIN BI_DROPDATABASE.BI_Categorias cat ON cat.categoria_detalle = c.cur_categoria
    -- Hacemos un JOIN con una subquery que calcula el estado de cada alumno PARA ESE CURSO
    LEFT JOIN (
        SELECT 
            cur.cursa_curso,
            cur.cursa_alumno,
            CASE 
                WHEN 
                    -- Condición 1: TP Aprobado
                    EXISTS (
                        SELECT 1 FROM DROPDATABASE.Tp tp 
                        WHERE tp.tp_curso = cur.cursa_curso 
                          AND tp.tp_alumno = cur.cursa_alumno 
                          AND tp.tp_nota >= 4
                    )
                    AND 
                    -- Condición 2: Todos los módulos aprobados
                    (
                        SELECT COUNT(*) FROM DROPDATABASE.Modulo m WHERE m.mod_curso = cur.cursa_curso
                    ) = (
                        SELECT COUNT(DISTINCT e.eval_modulo)
                        FROM DROPDATABASE.Evaluacion e
                        JOIN DROPDATABASE.Modulo m ON m.mod_id = e.eval_modulo
                        WHERE m.mod_curso = cur.cursa_curso 
                          AND e.eval_alumno = cur.cursa_alumno 
                          AND e.eval_nota >= 4
                    )
                THEN 1 
                ELSE 0 
            END as EsAprobado
        FROM DROPDATABASE.Cursada cur
    ) AS EstadoAlumno ON EstadoAlumno.cursa_curso = c.cur_id

    WHERE c.cur_id NOT IN (SELECT curs_id FROM BI_DROPDATABASE.BI_MET_Cursadas)
    GROUP BY c.cur_id, t.tiempo_id, c.cur_sede, cat.categoria_id;
END
GO

-- 2. Migración de Finales (CORREGIDO)
-- Se asegura de no perder registros por nulos y cruza correctamente las dimensiones.
CREATE OR ALTER PROCEDURE BI_DROPDATABASE.Migrar_Fact_Final
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO BI_DROPDATABASE.BI_MET_Final (
        tiempo_inicio_curso, 
        tiempo_final, 
        final_categoria, 
        final_sede, 
        final_rango_etario, 
        final_nota, 
        final_presente
    )
    SELECT 
        t_ini.tiempo_id,
        t_fin.tiempo_id,
        cat.categoria_id,
        sed.sede_id,
        re.rango_alum_id,
        ISNULL(fa.final_nota, 0), -- Manejo de nulos en nota
        ISNULL(fa.presente, 0)    -- Manejo de nulos en presente
    FROM DROPDATABASE.Final_Alumno fa
    JOIN DROPDATABASE.Final f ON f.final_id = fa.final_id
    JOIN DROPDATABASE.Curso c ON c.cur_id = f.final_curso
    JOIN DROPDATABASE.Alumno a ON a.alum_id = fa.final_alum
    
    -- Dimensiones
    JOIN BI_DROPDATABASE.BI_Tiempo t_fin ON t_fin.anio = YEAR(f.final_fecha) AND t_fin.mes = MONTH(f.final_fecha)
    JOIN BI_DROPDATABASE.BI_Tiempo t_ini ON t_ini.anio = YEAR(c.cur_fecha_inicio) AND t_ini.mes = MONTH(c.cur_fecha_inicio)
    JOIN BI_DROPDATABASE.BI_Categorias cat ON cat.categoria_detalle = c.cur_categoria
    JOIN BI_DROPDATABASE.BI_Sede sed ON sed.sede_id = c.cur_sede -- Join explícito con tabla de sedes BI
    
    -- Join con función de rango etario (Asegurarse que la función devuelva exactamente el texto de la tabla dimensión)
    LEFT JOIN BI_DROPDATABASE.BI_Rango_Etario_Alum re ON re.rango_detalle = BI_DROPDATABASE.ObtenerRangoEtarioAlum(a.alum_fecha_nacimiento)

    -- Evitar duplicados si se corre varias veces (basado en un criterio de existencia lógico, aunque la tabla final tiene ID autoincremental)
    -- NOTA: Al ser una tabla de hechos transaccional sin ID de negocio natural, 
    -- es difícil validar "NOT IN" eficientemente sin un ID de staging. 
    -- Si la tabla está vacía al inicio del script maestro, este WHERE no es crítico.
    WHERE NOT EXISTS (
        SELECT 1 FROM BI_DROPDATABASE.BI_MET_Final f_exist
        WHERE f_exist.tiempo_final = t_fin.tiempo_id 
          AND f_exist.final_sede = sed.sede_id
          AND f_exist.final_categoria = cat.categoria_id
          -- Esta validación es aproximada, idealmente usarías un ID de staging
    );
END
GO

-- 5. Migración de Pagos (Depende de Facturas)
CREATE OR ALTER PROCEDURE BI_DROPDATABASE.Migrar_Fact_Pagos
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO BI_DROPDATABASE.BI_MET_Pagos (pago_id, pago_tiempo, pago_medio, pago_factura, pago_monto)
    SELECT 
        p.pago_id,
        t.tiempo_id,
        mp.medio_id,
        p.pago_fact,
        p.pago_importe
    FROM DROPDATABASE.Pago p
    JOIN BI_DROPDATABASE.BI_Tiempo t ON t.anio = YEAR(p.pago_fecha) AND t.mes = MONTH(p.pago_fecha)
    JOIN BI_DROPDATABASE.BI_Medio_Pago mp ON mp.medio_detalle = p.pago_medio_pago
    WHERE p.pago_id NOT IN (SELECT pago_id FROM BI_DROPDATABASE.BI_MET_Pagos)
    AND EXISTS (SELECT 1 FROM BI_DROPDATABASE.BI_MET_Factura f WHERE f.factura_nro = p.pago_fact);
END
GO

-- 6. Migración de Encuestas
CREATE OR ALTER PROCEDURE BI_DROPDATABASE.Migrar_Fact_Encuestas
AS
BEGIN
    SET NOCOUNT ON;

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

CREATE OR ALTER PROCEDURE BI_DROPDATABASE.Migrar_Hechos
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
            
            EXEC BI_DROPDATABASE.Migrar_Fact_Factura;
            EXEC BI_DROPDATABASE.Migrar_Fact_Inscripciones;
            EXEC BI_DROPDATABASE.Migrar_Fact_Cursadas;
            EXEC BI_DROPDATABASE.Migrar_Fact_Final;
            EXEC BI_DROPDATABASE.Migrar_Fact_Pagos;
            EXEC BI_DROPDATABASE.Migrar_Fact_Encuestas;
            
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- Ejecutar Migracion
EXEC BI_DROPDATABASE.Migrar_Dimensiones;
EXEC BI_DROPDATABASE.Migrar_Hechos;
GO

USE [GD2C2025]
GO

/* ===========================================================
   VISTAS DE BUSINESS INTELLIGENCE (BI)
   =========================================================== 
*/

-----------------------------------------------------------------------------------------
-- VISTA 1: Categorías y turnos más solicitados
-----------------------------------------------------------------------------------------
CREATE OR ALTER VIEW BI_DROPDATABASE.VW_Categorias_Turnos_Mas_Solicitados AS
SELECT
    t.anio,
    s.sede_nombre,
    cat.categoria_detalle,
    tur.turno_detalle,
    SUM(i.cantidad_inscriptos) AS total_inscriptos,
    ROW_NUMBER() OVER (
        PARTITION BY t.anio, s.sede_nombre 
        ORDER BY SUM(i.cantidad_inscriptos) DESC
    ) AS Ranking
FROM BI_DROPDATABASE.BI_MET_Inscripciones i
JOIN BI_DROPDATABASE.BI_Tiempo t ON i.inscr_tiempo = t.tiempo_id
JOIN BI_DROPDATABASE.BI_Sede s ON i.inscr_sede = s.sede_id
JOIN BI_DROPDATABASE.BI_Categorias cat ON i.inscr_categoria = cat.categoria_id
JOIN BI_DROPDATABASE.BI_Turno tur ON i.inscr_turno = tur.turno_id
GROUP BY t.anio, s.sede_nombre, cat.categoria_detalle, tur.turno_detalle;
GO

-----------------------------------------------------------------------------------------
-- VISTA 2: Tasa de rechazo de inscripciones
-----------------------------------------------------------------------------------------
CREATE OR ALTER VIEW BI_DROPDATABASE.VW_Tasa_Rechazo_Inscripciones AS
SELECT
    t.anio,
    t.mes,
    s.sede_nombre,
    SUM(i.cantidad_rechazados) AS total_rechazados,
    SUM(i.cantidad_inscriptos + i.cantidad_rechazados) AS total_intentos,
    CAST(
        (SUM(i.cantidad_rechazados) * 100.0) / 
        NULLIF(SUM(i.cantidad_inscriptos + i.cantidad_rechazados), 0) 
    AS DECIMAL(10,2)) AS tasa_rechazo_porcentaje
FROM BI_DROPDATABASE.BI_MET_Inscripciones i
JOIN BI_DROPDATABASE.BI_Tiempo t ON i.inscr_tiempo = t.tiempo_id
JOIN BI_DROPDATABASE.BI_Sede s ON i.inscr_sede = s.sede_id
GROUP BY t.anio, t.mes, s.sede_nombre;
GO

-----------------------------------------------------------------------------------------
-- VISTA 3: Comparación de desempeño de cursada por sede
-----------------------------------------------------------------------------------------
CREATE OR ALTER VIEW BI_DROPDATABASE.VW_Desempenio_Cursada_Sede AS
SELECT
    t.anio,
    s.sede_nombre,
    SUM(c.cantidad_aprobados) AS total_aprobados,
    SUM(c.cantidad_aprobados + c.cantidad_desaprobados) AS total_cursantes,
    CAST(
        (SUM(c.cantidad_aprobados) * 100.0) / 
        NULLIF(SUM(c.cantidad_aprobados + c.cantidad_desaprobados), 0) 
    AS DECIMAL(10,2)) AS porcentaje_aprobacion
FROM BI_DROPDATABASE.BI_MET_Cursadas c
JOIN BI_DROPDATABASE.BI_Tiempo t ON c.curs_tiempo = t.tiempo_id
JOIN BI_DROPDATABASE.BI_Sede s ON c.curs_sede = s.sede_id
GROUP BY t.anio, s.sede_nombre;
GO

-----------------------------------------------------------------------------------------
-- VISTA 4: Tiempo promedio de finalización de curso
-----------------------------------------------------------------------------------------
CREATE OR ALTER VIEW BI_DROPDATABASE.VW_Tiempo_Promedio_Finalizacion AS
SELECT
    t_ini.anio AS anio_inicio,
    cat.categoria_detalle,
    AVG(
        ((t_fin.anio - t_ini.anio) * 12) + (t_fin.mes - t_ini.mes)
    ) AS promedio_meses_hasta_final
FROM BI_DROPDATABASE.BI_MET_Final f
JOIN BI_DROPDATABASE.BI_Tiempo t_ini ON f.tiempo_inicio_curso = t_ini.tiempo_id
JOIN BI_DROPDATABASE.BI_Tiempo t_fin ON f.tiempo_final = t_fin.tiempo_id
JOIN BI_DROPDATABASE.BI_Categorias cat ON f.final_categoria = cat.categoria_id
WHERE f.final_nota >= 4 -- Solo consideramos finales aprobados según enunciado implícito
GROUP BY t_ini.anio, cat.categoria_detalle;
GO

-----------------------------------------------------------------------------------------
-- VISTA 5: Nota promedio de finales
-----------------------------------------------------------------------------------------
CREATE OR ALTER VIEW BI_DROPDATABASE.VW_Nota_Promedio_Finales AS
SELECT
    t.anio,
    t.cuatrimestre,
    cat.categoria_detalle,
    re.rango_detalle AS rango_etario_alumno,
    CAST(AVG(f.final_nota) AS DECIMAL(10,2)) AS nota_promedio
FROM BI_DROPDATABASE.BI_MET_Final f
JOIN BI_DROPDATABASE.BI_Tiempo t ON f.tiempo_final = t.tiempo_id
JOIN BI_DROPDATABASE.BI_Categorias cat ON f.final_categoria = cat.categoria_id
JOIN BI_DROPDATABASE.BI_Rango_Etario_Alum re ON f.final_rango_etario = re.rango_alum_id
GROUP BY t.anio, t.cuatrimestre, cat.categoria_detalle, re.rango_detalle;
GO

-----------------------------------------------------------------------------------------
-- VISTA 6: Tasa de ausentismo finales
-----------------------------------------------------------------------------------------
CREATE OR ALTER VIEW BI_DROPDATABASE.VW_Tasa_Ausentismo_Finales AS
SELECT
    t.anio,
    t.cuatrimestre,
    s.sede_nombre,
    COUNT(*) AS total_finales,
    SUM(CASE WHEN f.final_presente = 0 THEN 1 ELSE 0 END) AS total_ausentes,
    CAST(
        (SUM(CASE WHEN f.final_presente = 0 THEN 1 ELSE 0 END) * 100.0) / 
        COUNT(*) 
    AS DECIMAL(10,2)) AS tasa_ausentismo
FROM BI_DROPDATABASE.BI_MET_Final f
JOIN BI_DROPDATABASE.BI_Tiempo t ON f.tiempo_final = t.tiempo_id
JOIN BI_DROPDATABASE.BI_Sede s ON f.final_sede = s.sede_id
GROUP BY t.anio, t.cuatrimestre, s.sede_nombre;
GO

-----------------------------------------------------------------------------------------
-- VISTA 7: Desvío de pagos
-----------------------------------------------------------------------------------------
CREATE OR ALTER VIEW BI_DROPDATABASE.VW_Desvio_Pagos AS
SELECT
    t_pago.anio,
    t_pago.cuatrimestre,
    COUNT(*) AS total_pagos,
    SUM(CASE 
        -- Si año pago > año vencimiento O (año igual Y mes pago > mes vencimiento)
        WHEN (t_pago.anio > t_venc.anio) OR (t_pago.anio = t_venc.anio AND t_pago.mes > t_venc.mes) 
        THEN 1 ELSE 0 
    END) AS pagos_fuera_termino,
    CAST(
        (SUM(CASE 
            WHEN (t_pago.anio > t_venc.anio) OR (t_pago.anio = t_venc.anio AND t_pago.mes > t_venc.mes) 
            THEN 1 ELSE 0 
         END) * 100.0) / COUNT(*)
    AS DECIMAL(10,2)) AS porcentaje_desvio
FROM BI_DROPDATABASE.BI_MET_Pagos p
JOIN BI_DROPDATABASE.BI_MET_Factura f ON p.pago_factura = f.factura_nro
JOIN BI_DROPDATABASE.BI_Tiempo t_pago ON p.pago_tiempo = t_pago.tiempo_id
JOIN BI_DROPDATABASE.BI_Tiempo t_venc ON f.factura_vencimiento = t_venc.tiempo_id
GROUP BY t_pago.anio, t_pago.cuatrimestre;
GO

-----------------------------------------------------------------------------------------
-- VISTA 8: Tasa de Morosidad Financiera mensual
-----------------------------------------------------------------------------------------
CREATE OR ALTER VIEW BI_DROPDATABASE.VW_Tasa_Morosidad_Mensual AS
SELECT
    t.anio,
    t.mes,
    SUM(f.fact_total) AS facturacion_esperada,
    
    -- Corrección: Usamos LEFT JOIN para detectar facturas sin pago (p.pago_factura IS NULL)
    -- en lugar de una subquery dentro del SUM.
    SUM(CASE WHEN p.pago_factura IS NULL THEN f.fact_total ELSE 0 END) AS monto_adeudado,

    CAST(
        (SUM(CASE WHEN p.pago_factura IS NULL THEN f.fact_total ELSE 0 END) * 100.0) / 
        NULLIF(SUM(f.fact_total), 0)
    AS DECIMAL(10,2)) AS tasa_morosidad

FROM BI_DROPDATABASE.BI_MET_Factura f
JOIN BI_DROPDATABASE.BI_Tiempo t ON f.factura_vencimiento = t.tiempo_id
-- Hacemos LEFT JOIN con los IDs de pagos distintos.
-- Si no hay coincidencia (NULL), significa que esa factura no se pagó.
-- Usamos DISTINCT para que si una factura tiene 2 pagos parciales, no duplique el monto de la factura en el conteo.
LEFT JOIN (
    SELECT DISTINCT pago_factura 
    FROM BI_DROPDATABASE.BI_MET_Pagos
) p ON f.factura_nro = p.pago_factura
GROUP BY t.anio, t.mes;
GO

-----------------------------------------------------------------------------------------
-- VISTA 9: Ingresos por categoría de cursos
-----------------------------------------------------------------------------------------
CREATE OR ALTER VIEW BI_DROPDATABASE.VW_Ingresos_Por_Categoria AS
SELECT
    t.anio,
    s.sede_nombre,
    cat.categoria_detalle,
    SUM(p.pago_monto) AS total_ingresos,
    ROW_NUMBER() OVER (
        PARTITION BY t.anio, s.sede_nombre 
        ORDER BY SUM(p.pago_monto) DESC
    ) AS Ranking
FROM BI_DROPDATABASE.BI_MET_Pagos p
JOIN BI_DROPDATABASE.BI_Tiempo t ON p.pago_tiempo = t.tiempo_id
JOIN BI_DROPDATABASE.BI_MET_Factura f ON p.pago_factura = f.factura_nro
JOIN BI_DROPDATABASE.BI_Sede s ON f.factura_sede = s.sede_id
JOIN BI_DROPDATABASE.BI_Categorias cat ON f.factura_categoria = cat.categoria_id
GROUP BY t.anio, s.sede_nombre, cat.categoria_detalle;
GO

-----------------------------------------------------------------------------------------
-- VISTA 10: Índice de satisfacción
-----------------------------------------------------------------------------------------
CREATE OR ALTER VIEW BI_DROPDATABASE.VW_Indice_Satisfaccion AS
SELECT
    t.anio,
    s.sede_nombre,
    rp.rango_detalle AS rango_etario_profesor,
    COUNT(*) AS total_encuestas,
    
    -- Porcentaje Satisfechos
    CAST(SUM(CASE WHEN sat.satisfaccion_detalle = 'Satisfechos' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS pct_satisfechos,
    
    -- Porcentaje Insatisfechos
    CAST(SUM(CASE WHEN sat.satisfaccion_detalle = 'Insatisfechos' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS pct_insatisfechos,

    -- Índice final
    CAST(
        (
            (SUM(CASE WHEN sat.satisfaccion_detalle = 'Satisfechos' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) 
            - 
            (SUM(CASE WHEN sat.satisfaccion_detalle = 'Insatisfechos' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) 
            + 100
        ) / 2 
    AS DECIMAL(10,2)) AS indice_satisfaccion

FROM BI_DROPDATABASE.BI_MET_Encuestas e
JOIN BI_DROPDATABASE.BI_Tiempo t ON e.encuesta_fecha = t.tiempo_id
JOIN BI_DROPDATABASE.BI_Sede s ON e.encuesta_sede = s.sede_id
JOIN BI_DROPDATABASE.BI_Rango_Etario_Prof rp ON e.encuesta_rango_etario = rp.rango_prof_id
JOIN BI_DROPDATABASE.BI_Satisfaccion sat ON e.encuesta_satisfaccion = sat.satisfaccion_id
GROUP BY t.anio, s.sede_nombre, rp.rango_detalle;
GO