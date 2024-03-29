
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

