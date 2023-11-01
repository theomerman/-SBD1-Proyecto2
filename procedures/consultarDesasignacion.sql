DROP PROCEDURE IF EXISTS consultarDesasignacion;
-- CREATE PROCEDURE consultarDesasignacion --

DELIMITER $$
CREATE PROCEDURE consultarDesasignacion(
    codigo_curso_in INT,
    ciclo_in VARCHAR(2),
    año_in INT,
    seccion_in VARCHAR(1)
)
BEGIN

	DECLARE X INT;
    SELECT count(*) into X
    FROM CURSO_DESASIGNADO D
    INNER JOIN CURSO_HABILITADO C
    ON D.CURSO_HABILITADO_id_habilitado = C.id_habilitado
    INNER JOIN SECCION_CURSO_HABILITADO S
    ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado
    WHERE codigo_curso_in = C.CURSO_codigo_curso
    AND ciclo_in = S.ciclo
    AND año_in = YEAR(S.año)
    AND seccion_in = S.seccion
    ;
    

    SELECT C.CURSO_codigo_curso AS "Código Curso", S.seccion AS "Sección",
    CASE
    WHEN S.ciclo = "1S" THEN "Primer Semestre"
    WHEN S.ciclo = "2S" THEN "Segundo Semestre" 
    WHEN S.ciclo = "VJ" THEN "Vacaciones Junio"
    When S.ciclo = "VD" THEN "Vacaciones Diciembre"
    END AS "Ciclo",
    Year(año) AS "Año", X as Desasignados, concat((X*100)/(asignados + X),"%") AS Porcentaje
    
    FROM CURSO_DESASIGNADO D
    INNER JOIN CURSO_HABILITADO C
    ON D.CURSO_HABILITADO_id_habilitado = C.id_habilitado
    INNER JOIN SECCION_CURSO_HABILITADO S
    ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado
    WHERE codigo_curso_in = C.CURSO_codigo_curso
    AND ciclo_in = S.ciclo
    AND año_in = YEAR(S.año)
    AND seccion_in = S.seccion
    
    
    ;
END;
$$
DELIMITER ;

-- SELECT desasignarCurso(0007,"VD","a",202100001);

CALL consultarDesasignacion(0007, "vd", "2023", "a") 






