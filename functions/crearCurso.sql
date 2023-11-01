
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

