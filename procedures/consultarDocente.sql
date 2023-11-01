DROP PROCEDURE IF EXISTS consultarDocente;

-- CREATE PROCEDURE consultarDocente --

DELIMITER $$
CREATE PROCEDURE consultarDocente(
    SIIF_in INT
)
BEGIN
	declare err varchar(100);
    
    if not exists(SELECT SIIF FROM DOCENTE WHERE SIIF_in = SIIF) THEN
    set err = "El docente no existe";
    select err;
    else
    

    SELECT SIIF AS "Registro SIIF", concat(nombres, " " , apellidos) AS "Nombre Completo", fecha_nacimiento AS "Fecha Nacimiento", Correo, telefono AS "Teléfono", direccion AS "Dirección", DPI
    FROM DOCENTE
    WHERE SIIF_in = SIIF;
    END IF
    ;
    
END;
$$
DELIMITER ;

CALL consultarDocente(5);
