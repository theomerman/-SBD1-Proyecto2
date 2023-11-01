
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


