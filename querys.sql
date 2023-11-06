show databases;
DROP DATABASE proyecto2;
CREATE DATABASE IF NOT EXISTS proyecto2;

-- CREATE TABLE DOCENTE -- 


CREATE TABLE IF NOT EXISTS proyecto2.DOCENTE(
    SIIF INT NOT NULL, 
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    correo VARCHAR(50) NOT NULL,
    telefono VARCHAR(10) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    dpi BIGINT NOT NULL,
    fecha_creacion DATE NOT NULL,

    PRIMARY KEY (SIIF)
);

-- CREATE TABLE CARRERA -- 

CREATE TABLE IF NOT EXISTS proyecto2.CARRERA(
    id_carrera INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,

    PRIMARY KEY (id_carrera)
);



-- CREATE TABLE ESTUDIANTE--

CREATE TABLE IF NOT EXISTS proyecto2.ESTUDIANTE (
	carnet INT NOT NULL,
	nombres VARCHAR(50) NOT NULL,
	apellidos VARCHAR(50) NOT NULL,
	fecha_nacimiento DATE NOT NULL,
    correo VARCHAR(100) NOT NULL,
    telefono VARCHAR(10) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    dpi BIGINT NOT NULL,
    creditos INT NOT NULL,
    fecha_creacion date NOT NULL,
    CARRERA_id_carrera INT NOT NULL,

	PRIMARY KEY (carnet),
    FOREIGN KEY (CARRERA_id_carrera) REFERENCES CARRERA(id_carrera)

);

-- CREATE TABLE CURSO --

CREATE TABLE IF NOT EXISTS proyecto2.CURSO(
    codigo_curso INT NOT NULL,
    nombre_curso VARCHAR(100) NOT NULL,
    creditos_necesarios INT NOT NULL,
    creditos_otorga INT NOT NULL,
    obligatorio BOOLEAN NOT NULL,
    CARRERA_id_carrera INT NOT NULL,

    PRIMARY KEY (codigo_curso),
    FOREIGN KEY (CARRERA_id_carrera) REFERENCES CARRERA(id_carrera)
);


-- CREATE TABLE CURSO_HABILITADO -- 

CREATE TABLE IF NOT EXISTS proyecto2.CURSO_HABILITADO(
    id_habilitado INT NOT NULL AUTO_INCREMENT,
    CURSO_codigo_curso INT NOT NULL,
    DOCENTE_SIIF INT NOT NULL,

    PRIMARY KEY (id_habilitado),
    FOREIGN KEY (CURSO_codigo_curso) REFERENCES CURSO(codigo_curso),
    FOREIGN KEY (DOCENTE_SIIF) REFERENCES DOCENTE(SIIF)
);

-- CREATE TABLE SECCION_CURSO_HABILITADO --

CREATE TABLE IF NOT EXISTS proyecto2.SECCION_CURSO_HABILITADO(
    ciclo VARCHAR(2) NOT NULL,
    cupo_maximo INT NOT NULL,
    seccion VARCHAR(1) NOT NULL,
    año DATE NOT NULL,
    asignados INT NOT NULL,
    CURSO_HABILITADO_id_habilitado INT NOT NULL,

    FOREIGN KEY (CURSO_HABILITADO_id_habilitado) REFERENCES CURSO_HABILITADO(id_habilitado)
);

-- CREATE TABLE HORARIO_CURSO --

CREATE TABLE IF NOT EXISTS proyecto2.HORARIO_CURSO(
    dia integer NOT NULL,
    horario VARCHAR(11) NOT NULL,
    CURSO_HABILITADO_id_habilitado INT NOT NULL,

    FOREIGN KEY (CURSO_HABILITADO_id_habilitado) REFERENCES CURSO_HABILITADO(id_habilitado)
);

-- CREATE TABLE ACTA --

CREATE TABLE IF NOT EXISTS proyecto2.ACTA(
    id_acta INT NOT NULL AUTO_INCREMENT,
    fecha_hora DATETIME NOT NULL,
    CURSO_HABILITADO_id_habilitado INT NOT NULL,

    PRIMARY KEY (id_acta),
    FOREIGN KEY (CURSO_HABILITADO_id_habilitado) REFERENCES CURSO_HABILITADO(id_habilitado)
);

-- CREATE TABLE CURSO_ASIGNADO --

CREATE TABLE IF NOT EXISTS proyecto2.CURSO_ASIGNADO(
    ESTUDIANTE_carnet INT NOT NULL,
    CURSO_HABILITADO_id_habilitado INT NOT NULL,

    FOREIGN KEY (ESTUDIANTE_carnet) REFERENCES ESTUDIANTE(carnet),
    FOREIGN KEY (CURSO_HABILITADO_id_habilitado) REFERENCES CURSO_HABILITADO(id_habilitado)    
);

-- CREATE TABLE CURSO_DESASIGNADO -- 

CREATE TABLE IF NOT EXISTS proyecto2.CURSO_DESASIGNADO(
    ESTUDIANTE_carnet INT NOT NULL,
    CURSO_HABILITADO_id_habilitado INT NOT NULL,

    FOREIGN KEY (ESTUDIANTE_carnet) REFERENCES ESTUDIANTE(carnet),
    FOREIGN KEY (CURSO_HABILITADO_id_habilitado) REFERENCES CURSO_HABILITADO(id_habilitado)    
);

-- CREATE TABLE NOTA --

CREATE TABLE IF NOT EXISTS proyecto2.NOTA(
    nota INT NOT NULL,
    ESTUDIANTE_carnet INT NOT NULL,
    CURSO_HABILITADO_id_habilitado INT NOT NULL,

    FOREIGN KEY (ESTUDIANTE_carnet) REFERENCES ESTUDIANTE(carnet),
    FOREIGN KEY (CURSO_HABILITADO_id_habilitado) REFERENCES CURSO_HABILITADO(id_habilitado)
);

use proyecto2;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------


-- CREATE FUNCTION crearCarrera --

DELIMITER $$

CREATE FUNCTION crearCarrera(
    nombre_in VARCHAR(100)
    )
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN

    DECLARE resultado VARCHAR(100);

    IF EXISTS(SELECT * FROM Carrera WHERE nombre_in = nombre) THEN
        SET resultado = 'La carrera ya existe';
    ELSEIF NOT (nombre_in REGEXP '^[a-zA-Záéíóúñ ]*$') THEN
        SET resultado = 'El nombre de la carrera no es valido, solo se aceptan letras';
    ELSE
        INSERT INTO Carrera(
            nombre
        )
        VALUES(
            nombre_in
        );
        SET resultado = 'Carrera creada exitosamente';
    END IF;

    RETURN resultado;

END;
$$
DELIMITER ;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- CREATE FUNCTION registrarDocente --

DELIMITER $$
CREATE FUNCTION registrarDocente(
    nombres_in VARCHAR(100),
    apellidos_in VARCHAR(100),
    fecha_nacimiento_in VARCHAR(10),
    correo_in VARCHAR(100),
    telefono_in BIGINT,
    direcccion_in VARCHAR(100),
    dpi_in BIGINT,
    SIIF_in INT
    )
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    

    IF EXISTS(SELECT * FROM Docente WHERE SIIF_in = SIIF) THEN
        RETURN 'El docente ya existe';
    ELSEIF NOT (correo_in REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$') THEN
        RETURN'El correo no es valido';
    ELSE
        INSERT INTO Docente(
            nombres,
            apellidos,
            fecha_nacimiento,
            correo,
            telefono,
            direccion,
            dpi,
            SIIF,
            fecha_creacion
        )
        VALUES(
            nombres_in,
            apellidos_in,
            STR_TO_DATE(fecha_nacimiento_in, '%d-%m-%Y'),
            correo_in,
            telefono_in,
            direcccion_in,
            dpi_in,
            SIIF_in,
            CURDATE()
        );
    END IF;

    
	RETURN 'Docente registrado exitosamente';
END;
$$
DELIMITER ;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- CREATE FUNCTION registrarEstudiante --

DELIMITER $$

CREATE FUNCTION registrarEstudiante(
    carnet_in BIGINT, 
    nombres VARCHAR(100),
    apellidos_in VARCHAR(100),
    fecha_nacimiento_in VARCHAR(10),
    correo_in VARCHAR(100),
    telefono_in BIGINT,
    direccion_in VARCHAR(100),
    dpi_in BIGINT,
    id_carrera_in INT
    )

RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN

    DECLARE resultado VARCHAR(100);

    IF EXISTS(SELECT * FROM Estudiante WHERE carnet_in = carnet) THEN
        RETURN 'El estudiante ya existe';
    ELSEIF NOT (correo_in REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$') THEN
        RETURN 'El correo no es valido';
    ELSEIF NOT EXISTS(SELECT * FROM Carrera WHERE id_carrera_in = id_carrera) THEN
        RETURN 'La carrera no existe';
    ELSE
        INSERT INTO Estudiante(
            carnet,
            nombres,
            apellidos,
            fecha_nacimiento,
            correo,
            telefono,
            direccion,
            dpi,
            creditos,
            fecha_creacion,
            CARRERA_id_carrera
        )
        VALUES(
            carnet_in,
            nombres,
            apellidos_in,
            STR_TO_DATE(fecha_nacimiento_in, '%d-%m-%Y'),
            correo_in,
            telefono_in,
            direccion_in,
            dpi_in,
            0,
            CURDATE(),
            id_carrera_in
        );
        RETURN 'Estudiante registrado exitosamente';
    END IF;
END;
$$
DELIMITER ;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- CREATE FUNCTION crearCurso --

DELIMITER $$

CREATE FUNCTION crearCurso(
    codigo_in INT,
    nombre_in VARCHAR(100),
    creditos_necesarios_in INT,
    creditos_otorga_in INT,
    carrera_in INT,
    obligatorio_in BOOLEAN
)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN

    IF EXISTS(SELECT * FROM Curso WHERE codigo_in = codigo_curso) THEN
        RETURN 'El curso ya existe';
    ELSEIF (creditos_necesarios_in < 0) THEN
        RETURN 'Los creditos necesarios no pueden ser negativos';
    ELSEIF (creditos_otorga_in < 0) THEN
        RETURN 'Los creditos otorgados no pueden ser negativos';
    ELSEIF NOT EXISTS(SELECT * FROM Carrera WHERE carrera_in = id_carrera) THEN
        RETURN 'La carrera no existe';
    ELSE
        INSERT INTO Curso(
            codigo_curso,
            nombre_curso,
            creditos_necesarios,
            creditos_otorga,
            obligatorio,
            CARRERA_id_carrera
        )
        VALUES(
            codigo_in,
            nombre_in,
            creditos_necesarios_in,
            creditos_otorga_in,
            obligatorio_in,
            carrera_in
        );
        RETURN 'Curso registrado exitosamente';
    END IF;

END;
$$
DELIMITER ;
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATE FUNCTION habilitarCurso --

DELIMITER $$

CREATE FUNCTION habilitarCurso(
    codigo_curso_in INT,
    ciclo_in VARCHAR(2),
    SIIF_in INT,
    cupo_maximo_in INT,
    seccion_in VARCHAR(1)
)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN

    IF NOT EXISTS(SELECT * FROM CURSO WHERE codigo_curso_in = codigo_curso) THEN
        RETURN 'El curso no existe';
    ELSEIF NOT (UPPER(ciclo_in) = "1S" OR UPPER(ciclo_in) = "2S" OR UPPER(ciclo_in) = "VJ" OR UPPER(ciclo_in) = "VD") THEN
        RETURN 'La seccion no es valida';
    ELSEIF NOT EXISTS(SELECT * FROM DOCENTE WHERE SIIF_in  = SIIF) THEN
        RETURN 'El docente no existe';
    ELSEIF (cupo_maximo_in < 0) THEN
        RETURN 'El cupo maximo no puede ser negativo';
    ELSEIF NOT (seccion_in REGEXP '^[A-Z]$') THEN
        RETURN 'La seccion no es valida';
    ELSEIF EXISTS(SELECT * FROM CURSO_HABILITADO LEFT JOIN SECCION_CURSO_HABILITADO ON id_habilitado = CURSO_HABILITADO_id_habilitado WHERE seccion = seccion_in AND ciclo = ciclo_in AND CURSO_codigo_curso = codigo_curso_in) THEN
        RETURN 'El curso ya esta habilitado en esa seccion';
    ELSE 
        INSERT INTO CURSO_HABILITADO(
            CURSO_codigo_curso,
            DOCENTE_SIIF
        )
        VALUES(
            codigo_curso_in,
            SIIF_in
        );
        INSERT INTO SECCION_CURSO_HABILITADO(
            ciclo,
            cupo_maximo,
            seccion,
            año,
            asignados,
            CURSO_HABILITADO_id_habilitado
        )
        VALUES(
            ciclo_in,
            cupo_maximo_in,
            UPPER(seccion_in),
            CURDATE(),
            0,
            LAST_INSERT_ID()
        );
        RETURN 'Curso habilitado con exito';    
    END IF;
    

END;
$$
DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------

-- CREATE FUNCTION agregarHorario --

DELIMITER $$
CREATE FUNCTION agregarHorario(
    id_habilitado_in INT,
    dia_in INT,
    horario_in VARCHAR(11)
)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN

    IF NOT EXISTS(SELECT * FROM CURSO_HABILITADO WHERE id_habilitado_in = id_habilitado) THEN
        RETURN 'El curso no existe';
    ELSEIF NOT (dia_in >= 1 AND dia_in <= 7) THEN
        RETURN 'El dia no es valido';
    ELSEIF NOT (horario_in REGEXP '^[0-9]{2}:[0-9]{2}-[0-9]{2}:[0-9]{2}$') THEN
        RETURN 'El horario no es valido';
    ELSEIF EXISTS(SELECT * FROM HORARIO_CURSO WHERE CURSO_HABILITADO_id_habilitado = id_habilitado_in AND dia = dia_in AND horario = horario_in) THEN
        RETURN 'El horario ya existe';
    ELSE
        INSERT INTO HORARIO_CURSO(
            dia,
            horario,
            CURSO_HABILITADO_id_habilitado
        )
        VALUES(
            dia_in,
            horario_in,
            id_habilitado_in
        );
        RETURN 'Horario agregado con exito';
    END IF;

END;
$$
DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------

-- CREATE FUNCTION asignarCurso --

DELIMITER $$
CREATE FUNCTION asignarCurso(
    codigo_curso_in INT,
    ciclo_in VARCHAR(2),
    seccion_in VARCHAR(1),
    carnet_in BIGINT
)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN

    DECLARE X INT;
    SELECT id_habilitado INTO X FROM CURSO_HABILITADO C INNER JOIN SECCION_CURSO_HABILITADO S ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado WHERE CURSO_codigo_curso = codigo_curso_in and seccion = seccion_in AND ciclo = ciclo_in;

    IF NOT EXISTS(SELECT * FROM CURSO WHERE codigo_curso = codigo_curso_in) THEN
        RETURN 'El curso no existe';
    ELSEIF NOT (UPPER(ciclo_in) = "1S" OR UPPER(ciclo_in) = "2S" OR UPPER(ciclo_in) = "VJ" OR UPPER(ciclo_in) = "VD") THEN
        RETURN 'El ciclo no es valido';
    ELSEIF NOT EXISTS(SELECT * FROM CURSO_HABILITADO C INNER JOIN SECCION_CURSO_HABILITADO S ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado WHERE C.CURSO_codigo_curso = codigo_curso_in AND S.ciclo = ciclo_in AND S.seccion = seccion_in AND YEAR(S.año) = YEAR(CURDATE()) ) THEN
        RETURN 'El curso no esta habilitado en el ciclo y seccion indicados';
    ELSEIF (SELECT asignados FROM SECCION_CURSO_HABILITADO INNER JOIN CURSO_HABILITADO ON CURSO_HABILITADO_id_habilitado = id_habilitado WHERE CURSO_codigo_curso = codigo_curso_in AND ciclo = ciclo_in AND seccion = seccion_in AND YEAR(CURDATE()) = YEAR(año) AND asignados >= cupo_maximo) THEN
        RETURN 'El curso ya no tiene cupo disponible';
    ELSEIF NOT EXISTS(SELECT * FROM ESTUDIANTE WHERE carnet = carnet_in) THEN
        RETURN 'El estudiante no existe';
    ELSEIF EXISTS(SELECT CURSO_codigo_curso, ESTUDIANTE_carnet FROM CURSO_ASIGNADO A INNER JOIN CURSO_HABILITADO H ON CURSO_HABILITADO_id_habilitado = id_habilitado WHERE CURSO_codigo_curso = codigo_curso_in AND ESTUDIANTE_carnet = carnet_in ) THEN
        RETURN 'El estudiante ya esta asignado a este curso';
    ELSE 
        INSERT INTO CURSO_ASIGNADO(
            ESTUDIANTE_carnet,
            CURSO_HABILITADO_id_habilitado
        )
        VALUES(
            carnet_in,
            (SELECT id_habilitado FROM CURSO_HABILITADO C INNER JOIN SECCION_CURSO_HABILITADO S ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado WHERE C.CURSO_codigo_curso = codigo_curso_in AND S.ciclo = ciclo_in AND S.seccion = seccion_in)
        );
        UPDATE SECCION_CURSO_HABILITADO SET asignados = asignados + 1 WHERE CURSO_HABILITADO_id_habilitado = X;
    END IF;
    return "el curso se asigno correctamente";

END;
$$
DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------

-- CREATE FUNCTION desasignarCurso --

DELIMITER $$
CREATE FUNCTION desasignarCurso(
    codigo_curso_in INT,
    ciclo_in VARCHAR(2),
    seccion_in VARCHAR(1),
    carnet_in BIGINT
)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN

    DECLARE x INT;
    SELECT id_habilitado INTO X FROM CURSO_HABILITADO C INNER JOIN SECCION_CURSO_HABILITADO S ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado WHERE C.CURSO_codigo_curso = codigo_curso_in AND S.ciclo = ciclo_in AND S.seccion = seccion_in AND YEAR(S.año) = YEAR(CURDATE());

    
    IF NOT EXISTS(SELECT * FROM CURSO WHERE codigo_curso = codigo_curso_in) THEN
        RETURN 'El curso no existe';
    ELSEIF NOT (UPPER(ciclo_in) = "1S" OR UPPER(ciclo_in) = "2S" OR UPPER(ciclo_in) = "VJ" OR UPPER(ciclo_in) = "VD") THEN
        RETURN 'El ciclo no es valido';
    ELSEIF NOT EXISTS(SELECT * FROM CURSO_HABILITADO C INNER JOIN SECCION_CURSO_HABILITADO S ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado WHERE C.CURSO_codigo_curso = codigo_curso_in AND S.ciclo = ciclo_in AND S.seccion = seccion_in AND YEAR(S.año) = YEAR(CURDATE()) ) THEN
        RETURN 'El curso no esta habilitado en el ciclo y seccion indicados';
    ELSEIF NOT EXISTS(SELECT * FROM ESTUDIANTE WHERE carnet = carnet_in) THEN
        RETURN 'El estudiante no existe';
    ELSEIF NOT EXISTS(SELECT CURSO_codigo_curso, ESTUDIANTE_carnet FROM CURSO_ASIGNADO A INNER JOIN CURSO_HABILITADO H ON CURSO_HABILITADO_id_habilitado = id_habilitado WHERE CURSO_codigo_curso = codigo_curso_in AND ESTUDIANTE_carnet = carnet_in ) THEN
        RETURN 'El estudiante no esta asignado a este curso';
    ELSE
        
        
        INSERT INTO CURSO_DESASIGNADO(
            ESTUDIANTE_carnet,
            CURSO_HABILITADO_id_habilitado
        )
        VALUES(
            carnet_in,
            (SELECT id_habilitado FROM CURSO_HABILITADO C INNER JOIN SECCION_CURSO_HABILITADO S ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado WHERE C.CURSO_codigo_curso = codigo_curso_in AND S.ciclo = ciclo_in AND S.seccion = seccion_in)
        );
        DELETE FROM CURSO_ASIGNADO WHERE CURSO_HABILITADO_id_habilitado = (SELECT id_habilitado FROM CURSO_HABILITADO C INNER JOIN SECCION_CURSO_HABILITADO S ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado WHERE C.CURSO_codigo_curso = codigo_curso_in AND S.ciclo = ciclo_in AND S.seccion = seccion_in AND YEAR(S.año) = YEAR(CURDATE())) AND ESTUDIANTE_carnet = carnet_in;
        UPDATE SECCION_CURSO_HABILITADO SET asignados = asignados - 1 WHERE CURSO_HABILITADO_id_habilitado = x;
        return "el curso se desasignó correctamente";
    END IF;
END;
$$
DELIMITER ;


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------


-- CREATE FUNCTION ingresarNota --

DELIMITER $$
CREATE FUNCTION ingresarNota(
    codigo_curso_in INT,
    ciclo_in VARCHAR(2),
    seccion_in VARCHAR(1),
    carnet_in VARCHAR(9),
    nota_in VARCHAR(6)
)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    IF NOT (carnet_in REGEXP '^[0-9]{9}$') THEN
        RETURN 'El carnet no es valido, tiene que contener solo números';
    ELSEIF NOT EXISTS(SELECT * FROM CURSO WHERE codigo_curso_in = codigo_curso) THEN
        RETURN 'El curso no existe';
    ELSEIF NOT EXISTS(SELECT * FROM ESTUDIANTE WHERE carnet_in = carnet) THEN
        RETURN 'El estudiante no existe';
    ELSEIF NOT (UPPER(ciclo_in) = "1S" OR UPPER(ciclo_in) = "2S" OR UPPER(ciclo_in) = "VJ" OR UPPER(ciclo_in) = "VD") THEN
        RETURN 'La seccion no es valida';
    ELSEIF NOT (seccion_in REGEXP '^[A-Z]$') THEN
        RETURN 'La seccion no es valida';
    ELSEIF NOT EXISTS(SELECT * FROM SECCION_CURSO_HABILITADO LEFT JOIN CURSO_HABILITADO ON id_habilitado = CURSO_HABILITADO_id_habilitado WHERE ciclo = ciclo_in AND seccion = seccion_in AND CURSO_codigo_curso = codigo_curso_in AND YEAR(año) = YEAR(CURDATE())) THEN
        RETURN 'El curso no esta habilitado en esa seccion';
    ELSEIF NOT (nota_in REGEXP '^[0-9]+(\.[0-9]+)?$') THEN
        RETURN 'La nota no es valida, tiene que contener solo números';
    ELSEIF (nota_in < 0 OR nota_in > 100) THEN
        RETURN 'La nota no es valida, no puede ser menor a 0 ni mayor a 100';
    ELSEIF NOT EXISTS(SELECT CURSO_codigo_curso, ESTUDIANTE_carnet FROM CURSO_ASIGNADO A INNER JOIN CURSO_HABILITADO H ON CURSO_HABILITADO_id_habilitado = id_habilitado INNER JOIN SECCION_CURSO_HABILITADO S ON id_habilitado = S.CURSO_HABILITADO_id_habilitado WHERE CURSO_codigo_curso = codigo_curso_in AND ESTUDIANTE_carnet = carnet_in and S.seccion = seccion_in  and S.ciclo = ciclo_in) THEN
        RETURN 'El estudiante no esta asignado a este curso';
    ELSEIF EXISTS(SELECT * FROM NOTA WHERE CURSO_HABILITADO_id_habilitado = (SELECT id_habilitado FROM CURSO_HABILITADO C INNER JOIN SECCION_CURSO_HABILITADO S ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado WHERE C.CURSO_codigo_curso = codigo_curso_in AND S.ciclo = ciclo_in AND S.seccion = seccion_in) AND ESTUDIANTE_carnet = carnet_in) THEN
        RETURN 'El estudiante ya tiene una nota ingresada para este curso';
    ELSE
        INSERT INTO NOTA(
            nota,
            CURSO_HABILITADO_id_habilitado,
            ESTUDIANTE_carnet
        )
        VALUES(
            ROUND(nota_in),
            (SELECT id_habilitado FROM CURSO_HABILITADO C INNER JOIN SECCION_CURSO_HABILITADO S ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado WHERE C.CURSO_codigo_curso = codigo_curso_in AND S.ciclo = ciclo_in AND S.seccion = seccion_in),
            carnet_in
        );
        IF nota_in >= 61 THEN
            UPDATE ESTUDIANTE SET creditos = creditos + (SELECT creditos_otorga FROM CURSO WHERE codigo_curso = codigo_curso_in) WHERE carnet = carnet_in;
        END IF;
        RETURN "Nota ingresada con exito";
    END IF;
    
END;
$$
DELIMITER ;


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------

-- CREATE FUNCTION generarActa --

DELIMITER $$
CREATE FUNCTION generarActa(
    codigo_curso_in INT,
    ciclo_in VARCHAR(2),
    seccion_in VARCHAR(1)
)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN

    IF NOT EXISTS(SELECT * FROM CURSO WHERE codigo_curso = codigo_curso_in) THEN
        RETURN 'El curso no existe';
    ELSEIF NOT (UPPER(ciclo_in) = "1S" OR UPPER(ciclo_in) = "2S" OR UPPER(ciclo_in) = "VJ" OR UPPER(ciclo_in) = "VD") THEN
        RETURN 'El ciclo no es valido';
    ELSEIF NOT EXISTS(SELECT * FROM CURSO_HABILITADO C INNER JOIN SECCION_CURSO_HABILITADO S ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado WHERE C.CURSO_codigo_curso = codigo_curso_in AND S.ciclo = ciclo_in AND S.seccion = seccion_in AND YEAR(S.año) = YEAR(CURDATE()) ) THEN
        RETURN 'El curso no esta habilitado en el ciclo y seccion indicados';
    ELSEIF EXISTS(SELECT * FROM ACTA WHERE CURSO_HABILITADO_id_habilitado = (SELECT id_habilitado FROM CURSO_HABILITADO C INNER JOIN SECCION_CURSO_HABILITADO S ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado WHERE C.CURSO_codigo_curso = codigo_curso_in AND S.ciclo = ciclo_in AND S.seccion = seccion_in)) THEN
        RETURN 'El acta ya existe';
    ELSEIF(
        (SELECT count(*) 
        FROM NOTA N
        INNER JOIN CURSO_HABILITADO C
        ON N.CURSO_HABILITADO_id_habilitado = C.id_habilitado
        INNER JOIN SECCION_CURSO_HABILITADO S
        ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado
        WHERE "006" = C.CURSO_codigo_curso
        AND "VD" = S.ciclo
        AND "B" = S.seccion
        )
        <> 
        (SELECT asignados FROM SECCION_CURSO_HABILITADO S
        INNER JOIN CURSO_HABILITADO C
        ON CURSO_HABILITADO_id_habilitado = id_habilitado
        WHERE "006" = C.CURSO_codigo_curso
        AND "VD" = S.ciclo
        AND "B" = S.seccion)
        ) THEN 
        RETURN 'No todos los estudiantes asignados tienen una nota ingresada';
    ELSE
        INSERT INTO ACTA(
            fecha_hora,
            CURSO_HABILITADO_id_habilitado
        )
        VALUES(
            CURDATE(),
            (SELECT id_habilitado FROM CURSO_HABILITADO C INNER JOIN SECCION_CURSO_HABILITADO S ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado WHERE C.CURSO_codigo_curso = codigo_curso_in AND S.ciclo = ciclo_in AND S.seccion = seccion_in)
        );
    END IF;
    RETURN "Acta generada con exito";

END;
$$
DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------


-- CREATE PROCEDURE consultarPensum --

DELIMITER $$
CREATE PROCEDURE consultarPensum(
    id_carrera_in VARCHAR(9)
)
BEGIN

declare err varchar(100);
if not exists(SELECT id_carrera FROM CARRERA WHERE id_carrera_in = id_carrera) THEN
set err = "La carrera no existe";
select err;
else

SELECT codigo_curso as "Código del curso", nombre_curso AS "Nombre del curso ",
CASE 
WHEN obligatorio = 1 then "Sí"
ELSE "No"
END AS Obligatorio, creditos_necesarios as "Créditos necesarios"

FROM CARRERA
INNER JOIN CURSO 
ON id_carrera = CARRERA_id_carrera
WHERE id_carrera_in = id_carrera
or id_carrera = 0;
end if
;
END;
$$
DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------


-- CREATE PROCEDURE consultarEstudiante --

DELIMITER $$
CREATE PROCEDURE consultarEstudiante(
    carnet_in INT
)
BEGIN
    declare err varchar(100);
    if not exists(SELECT carnet FROM ESTUDIANTE WHERE carnet_in = carnet) THEN
    set err = "El estudiante no existe";
    select err;
    else

    SELECT Carnet, concat(nombres, " " ,apellidos) as "Nombre completo", date_format(fecha_nacimiento, '%d-%m-%Y') AS "Fecha Nacimiento", Correo, Telefono AS "Teléfono" , Direccion as "Dirección", DPI, nombre AS "Carrera", Creditos AS "Créditos"
    FROM ESTUDIANTE
    INNER JOIN CARRERA 
    ON CARRERA_id_carrera = id_carrera
    WHERE carnet_in = carnet;
    end if
	;
END;
$$
DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------

-- CREATE PROCEDURE consultarDocente --

DELIMITER $$
CREATE PROCEDURE consultarDocente(
    SIIF_in INT
)
BEGIN
	declare err varchar(100);
    
    if not exists(SELECT SIIF FROM DOCENTE WHERE SIIF_in = SIIF) THEN
    set err = "El docente no existe";
    select err;
    else
    

    SELECT SIIF AS "Registro SIIF", concat(nombres, " " , apellidos) AS "Nombre Completo", fecha_nacimiento AS "Fecha Nacimiento", Correo, telefono AS "Teléfono", direccion AS "Dirección", DPI
    FROM DOCENTE
    WHERE SIIF_in = SIIF;
    END IF
    ;
    
END;
$$
DELIMITER ;




-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATE PROCEDURE consultarAsignados --

DELIMITER $$
CREATE PROCEDURE consultarAsignados(
    codigo_curso_in INT,
    ciclo_in VARCHAR(2),
    año_in INT,
    seccion_in VARCHAR(1)
)
BEGIN

	declare err varchar(100);
    
    if not exists (select codigo_curso 
    from CURSO
    WHERE codigo_curso_in = codigo_curso) then
    set err = "El curso no existe";
    select err;
    elseif (ciclo_in != "1S" and ciclo_in != "2S" and ciclo_in != "VJ" and ciclo_in != "VD") then
    set err = "El ciclo no existe";
    select err;
    else
	
    SELECT E.carnet, concat(E.nombres, " ", E.apellidos) AS "Nombre Completo", E.creditos AS "Créditos"
    FROM CURSO_ASIGNADO A
    INNER JOIN CURSO_HABILITADO C
    ON A.CURSO_HABILITADO_id_habilitado = C.id_habilitado
    INNER JOIN SECCION_CURSO_HABILITADO S
    ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado
    INNER JOIN ESTUDIANTE E
    ON A.ESTUDIANTE_carnet = E.carnet
    WHERE codigo_curso_in = C.CURSO_codigo_curso
    AND ciclo_in = S.ciclo
    AND año_in = YEAR(S.año)
    AND seccion_in = S.seccion;
    end if
    ;

END
$$
DELIMITER ;




-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATE PROCEDURE consultarAprobacion --

DELIMITER $$
CREATE PROCEDURE consultarAprobacion(
    codigo_curso_in INT,
    ciclo_in VARCHAR(2),
    año_in INT,
    seccion_in VARCHAR(1)
)
BEGIN


	declare err varchar(100);
    
    if not exists (select codigo_curso 
    from CURSO
    WHERE codigo_curso_in = codigo_curso) then
    set err = "El curso no existe";
    select err;
    elseif (ciclo_in != "1S" and ciclo_in != "2S" and ciclo_in != "VJ" and ciclo_in != "VD") then
    set err = "El ciclo no existe";
    select err;
    else

    SELECT C.CURSO_codigo_curso AS "Código curso", Carnet, concat(E.nombres, " ", E.apellidos) AS "Nombre completo",
    CASE
    WHEN N.nota >=61 THEN "Aprovado"    
    ELSE "Desaprobado"
    END AS "Aprobado/Desaprobado"

    FROM NOTA N
    INNER JOIN CURSO_HABILITADO C
    ON N.CURSO_HABILITADO_id_habilitado = C.id_habilitado
    INNER JOIN SECCION_CURSO_HABILITADO S
    ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado
    INNER JOIN ESTUDIANTE E
    ON N.ESTUDIANTE_carnet = E.carnet
    WHERE codigo_curso_in = C.CURSO_codigo_curso
    AND ciclo_in = S.ciclo 
    AND año_in = YEAR(S.año)
    AND seccion_in = S.seccion;
    
    END IF;
END;
$$
DELIMITER ;


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATE PROCEDURE consultarActas --

DELIMITER $$
CREATE PROCEDURE consultarActas(
    codigo_curso_in INT
)
BEGIN
	
    declare err varchar(100);
    
    if not exists (select codigo_curso 
    from CURSO
    WHERE codigo_curso_in = codigo_curso) then
    set err = "El curso no existe";
    select err;
    else

    SELECT C.CURSO_codigo_curso AS "Codigo Curso", S.seccion as "Sección", Ciclo, YEAR(Año) AS "Año", asignados AS "Cantidad Estudiantes", fecha_hora AS "Generada"
    FROM ACTA A
    INNER JOIN CURSO_HABILITADO C
    ON A.CURSO_HABILITADO_id_habilitado = C.id_habilitado
    INNER JOIN SECCION_CURSO_HABILITADO S
    ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado
    WHERE codigo_curso_in = C.CURSO_codigo_curso;
    
    end if
    ;
END;
$$
DELIMITER ;


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATE PROCEDURE consultarDesasignacion --

DELIMITER $$
CREATE PROCEDURE consultarDesasignacion(
    codigo_curso_in INT,
    ciclo_in VARCHAR(2),
    año_in INT,
    seccion_in VARCHAR(1)
)
BEGIN
	DECLARE X INT;

	declare err varchar(100);
    
    if not exists (select codigo_curso 
    from CURSO
    WHERE codigo_curso_in = codigo_curso) then
    set err = "El curso no existe";
    select err;
    elseif (ciclo_in != "1S" and ciclo_in != "2S" and ciclo_in != "VJ" and ciclo_in != "VD") then
    set err = "El ciclo no existe";
    select err;
    else


    SELECT count(*) into X
    FROM CURSO_DESASIGNADO D
    INNER JOIN CURSO_HABILITADO C
    ON D.CURSO_HABILITADO_id_habilitado = C.id_habilitado
    INNER JOIN SECCION_CURSO_HABILITADO S
    ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado
    WHERE codigo_curso_in = C.CURSO_codigo_curso
    AND ciclo_in = S.ciclo
    AND año_in = YEAR(S.año)
    AND seccion_in = S.seccion
    ;
    

    SELECT C.CURSO_codigo_curso AS "Código Curso", S.seccion AS "Sección",
    CASE
    WHEN S.ciclo = "1S" THEN "Primer Semestre"
    WHEN S.ciclo = "2S" THEN "Segundo Semestre" 
    WHEN S.ciclo = "VJ" THEN "Vacaciones Junio"
    When S.ciclo = "VD" THEN "Vacaciones Diciembre"
    END AS "Ciclo",
    Year(año) AS "Año", X as Desasignados, concat((X*100)/(asignados + X),"%") AS Porcentaje
    
    FROM CURSO_DESASIGNADO D
    INNER JOIN CURSO_HABILITADO C
    ON D.CURSO_HABILITADO_id_habilitado = C.id_habilitado
    INNER JOIN SECCION_CURSO_HABILITADO S
    ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado
    WHERE codigo_curso_in = C.CURSO_codigo_curso
    AND ciclo_in = S.ciclo
    AND año_in = YEAR(S.año)
    AND seccion_in = S.seccion;
    end if
    
    
    ;
END;
$$
DELIMITER ;