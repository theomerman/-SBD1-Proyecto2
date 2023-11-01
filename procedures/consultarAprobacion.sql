DROP PROCEDURE IF EXISTS consultarAprobacion;
-- CREATE PROCEDURE consultarAprobacion --

DELIMITER $$
CREATE PROCEDURE consultarAprobacion(
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

    SELECT C.CURSO_codigo_curso AS "Código curso", Carnet, concat(E.nombres, " ", E.apellidos) AS "Nombre completo",
    CASE
    WHEN N.nota >=61 THEN "Aprovado"    
    ELSE "Desaprobado"
    END AS "Aprobado/Desaprobado"

    FROM NOTA N
    INNER JOIN CURSO_HABILITADO C
    ON N.CURSO_HABILITADO_id_habilitado = C.id_habilitado
    INNER JOIN SECCION_CURSO_HABILITADO S
    ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado
    INNER JOIN ESTUDIANTE E
    ON N.ESTUDIANTE_carnet = E.carnet
    WHERE codigo_curso_in = C.CURSO_codigo_curso
    AND ciclo_in = S.ciclo 
    AND año_in = YEAR(S.año)
    AND seccion_in = S.seccion;
    
    END IF;
END;
$$
DELIMITER ;

CALL consultarAprobacion(007, "vd", 2023, "a");