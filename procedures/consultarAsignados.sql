DROP PROCEDURE IF EXISTS consultarAsignados;
-- CREATE PROCEDURE consultarAsignados --

DELIMITER $$
CREATE PROCEDURE consultarAsignados(
    codigo_curso_in INT,
    ciclo_in VARCHAR(2),
    año_in INT,
    seccion_in VARCHAR(1)
)
BEGIN

	declare err varchar(100);
    
    if not exists (select codigo_curso 
    from CURSO
    WHERE codigo_curso_in = codigo_curso) then
    set err = "El curso no existe";
    select err;
    elseif (ciclo_in != "1S" and ciclo_in != "2S" and ciclo_in != "VJ" and ciclo_in != "VD") then
    set err = "El ciclo no existe";
    select err;
    else
	
    SELECT E.carnet, concat(E.nombres, " ", E.apellidos) AS "Nombre Completo", E.creditos AS "Créditos"
    FROM CURSO_ASIGNADO A
    INNER JOIN CURSO_HABILITADO C
    ON A.CURSO_HABILITADO_id_habilitado = C.id_habilitado
    INNER JOIN SECCION_CURSO_HABILITADO S
    ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado
    INNER JOIN ESTUDIANTE E
    ON A.ESTUDIANTE_carnet = E.carnet
    WHERE codigo_curso_in = C.CURSO_codigo_curso
    AND ciclo_in = S.ciclo
    AND año_in = YEAR(S.año)
    AND seccion_in = S.seccion;
    end if
    ;

END
$$
DELIMITER ;

CALL consultarAsignados(006, "vd", 2023, "b");