
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
