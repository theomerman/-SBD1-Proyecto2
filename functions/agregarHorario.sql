
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


