DROP PROCEDURE IF EXISTS consultarEstudiante;

-- CREATE PROCEDURE consultarEstudiante --

DELIMITER $$
CREATE PROCEDURE consultarEstudiante(
    carnet_in INT
)
BEGIN
    declare err varchar(100);
    if not exists(SELECT carnet FROM ESTUDIANTE WHERE carnet_in = carnet) THEN
    set err = "El estudiante no existe";
    select err;
    else

    SELECT Carnet, concat(nombres, " " ,apellidos) as "Nombre completo", date_format(fecha_nacimiento, '%d-%m-%Y') AS "Fecha Nacimiento", Correo, Telefono AS "Teléfono" , Direccion as "Dirección", DPI, nombre AS "Carrera", Creditos AS "Créditos"
    FROM ESTUDIANTE
    INNER JOIN CARRERA 
    ON CARRERA_id_carrera = id_carrera
    WHERE carnet_in = carnet;
    end if
	;
END;
$$
DELIMITER ;

CALL consultarEstudiante(2017101360);