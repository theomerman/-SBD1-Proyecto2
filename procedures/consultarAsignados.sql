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
    AND seccion_in = S.seccion
    ;

END
$$
DELIMITER ;

CALL consultarAsignados(006, "vd", 2023, "b");