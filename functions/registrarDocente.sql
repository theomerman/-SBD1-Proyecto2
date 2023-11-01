
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






