DROP PROCEDURE IF EXISTS consultarDocente;

-- CREATE PROCEDURE consultarDocente --

DELIMITER $$
CREATE PROCEDURE consultarDocente(
    SIIF_in INT
)
BEGIN
	
    SELECT SIIF AS "Registro SIIF", concat(nombres, " " , apellidos) AS "Nombre Completo", fecha_nacimiento AS "Fecha Nacimiento", Correo, telefono AS "Teléfono", direccion AS "Dirección", DPI
    FROM DOCENTE
    WHERE SIIF_in = SIIF
    ;
    
END;
$$
DELIMITER ;

CALL consultarDocente(10);
