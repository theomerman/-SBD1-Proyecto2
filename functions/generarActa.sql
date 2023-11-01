drop function if exists generarActa;
delete from ACTA where id_acta >= 0;
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
    -- CHECK IF ALL STUDENTS ASSIGNED HAVE A GRADE --
    ELSEIF EXISTS(SELECT * FROM CURSO_ASIGNADO A INNER JOIN CURSO_HABILITADO H ON CURSO_HABILITADO_id_habilitado = id_habilitado INNER JOIN SECCION_CURSO_HABILITADO S ON id_habilitado = S.CURSO_HABILITADO_id_habilitado WHERE CURSO_codigo_curso = codigo_curso_in AND S.seccion = seccion_in AND S.ciclo = ciclo_in AND NOT EXISTS(SELECT * FROM NOTA WHERE CURSO_HABILITADO_id_habilitado = H.id_habilitado AND ESTUDIANTE_carnet = A.ESTUDIANTE_carnet)) THEN
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

SELECT generarActa(101,"vd","A");