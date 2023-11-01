drop procedure if exists consultarActas;
-- CREATE PROCEDURE consultarActas --

DELIMITER $$
CREATE PROCEDURE consultarActas(
    codigo_curso_in INT
)
BEGIN
	
    declare err varchar(100);
    
    if not exists (select codigo_curso 
    from CURSO
    WHERE codigo_curso_in = codigo_curso) then
    set err = "El curso no existe";
    select err;
    else

    SELECT C.CURSO_codigo_curso AS "Codigo Curso", S.seccion as "Sección", Ciclo, YEAR(Año) AS "Año", asignados AS "Cantidad Estudiantes", fecha_hora AS "Generada"
    FROM ACTA A
    INNER JOIN CURSO_HABILITADO C
    ON A.CURSO_HABILITADO_id_habilitado = C.id_habilitado
    INNER JOIN SECCION_CURSO_HABILITADO S
    ON C.id_habilitado = S.CURSO_HABILITADO_id_habilitado
    WHERE codigo_curso_in = C.CURSO_codigo_curso;
    
    end if
    ;
END;
$$
DELIMITER ;


CALL consultarActas(101);