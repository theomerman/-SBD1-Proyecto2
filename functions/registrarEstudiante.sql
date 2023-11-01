
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

