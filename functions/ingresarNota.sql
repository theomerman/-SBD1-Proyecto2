
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
    ELSEIF NOT EXISTS(SELECT CURSO_codigo_curso, ESTUDIANTE_carnet FROM CURSO_ASIGNADO A INNER JOIN CURSO_HABILITADO H ON CURSO_HABILITADO_id_habilitado = id_habilitado INNER JOIN SECCION_CURSO_HABILITADO S ON id_habilitado = S.CURSO_HABILITADO_id_habilitado WHERE CURSO_codigo_curso = codigo_curso_in AND ESTUDIANTE_carnet = carnet_in and S.seccion = seccion_in and S.ciclo = ciclo_in) THEN
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

