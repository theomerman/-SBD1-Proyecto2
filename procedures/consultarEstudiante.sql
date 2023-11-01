DROP PROCEDURE IF EXISTS consultarEstudiante;

-- CREATE PROCEDURE consultarEstudiante --

DELIMITER $$
CREATE PROCEDURE consultarEstudiante(
    carnet_in INT
)
BEGIN

    SELECT Carnet, concat(nombres, " " ,apellidos) as "Nombre completo", date_format(fecha_nacimiento, '%d-%m-%Y') AS "Fecha Nacimiento", Correo, Telefono AS "Teléfono" , Direccion as "Dirección", DPI, nombre AS "Carrera", Creditos AS "Créditos"
    FROM ESTUDIANTE
    INNER JOIN CARRERA 
    ON CARRERA_id_carrera = id_carrera
    WHERE carnet_in = carnet
	;
END;
$$
DELIMITER ;

CALL consultarEstudiante(201710160);