
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


SELECT crearCarrera(
    'Ingenieria en Sistemas'
)