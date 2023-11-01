DROP PROCEDURE IF EXISTS consultarPensum;

-- CREATE PROCEDURE consultarPensum --

DELIMITER $$
CREATE PROCEDURE consultarPensum(
    id_carrera_in VARCHAR(9)
)
BEGIN

declare err varchar(100);
if not exists(SELECT id_carrera FROM CARRERA WHERE id_carrera_in = id_carrera) THEN
set err = "La carrera no existe";
select err;
else

SELECT codigo_curso as "Código del curso", nombre_curso AS "Nombre del curso ",
CASE 
WHEN obligatorio = 1 then "Sí"
ELSE "No"
END AS Obligatorio, creditos_necesarios as "Créditos necesarios"

FROM CARRERA
INNER JOIN CURSO 
ON id_carrera = CARRERA_id_carrera
WHERE id_carrera_in = id_carrera
or id_carrera = 0;
end if
;
END;
$$
DELIMITER ;

CALL consultarPensum(10);