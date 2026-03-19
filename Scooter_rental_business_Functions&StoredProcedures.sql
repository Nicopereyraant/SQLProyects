#FUNCTIONS

#1 
DELIMITER //

CREATE FUNCTION fn_duracion_viaje_minutos(p_trip_id INT)
RETURNS INT
NOT DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE v_minutos INT;
    
    SELECT TIMESTAMPDIFF(MINUTE, start_time, end_time) INTO v_minutos
	FROM trips
	WHERE trip_id = p_trip_id;
    
    RETURN v_minutos;
END //

DELIMITER ;

SELECT 
	trip_id, 
	distance_km, 
    fn_duracion_viaje_minutos(trip_id) AS duracion_minutos 
FROM Trips;

#2

DELIMITER //

CREATE FUNCTION fn_estacion_actual_scooter(p_scooter_id INT)
RETURNS VARCHAR(100)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE v_nombre_estacion VARCHAR(100);
    
    SELECT name INTO v_nombre_estacion
    FROM stations
    WHERE station_id = (SELECT last_station_id FROM scooters WHERE scooter_id = p_scooter_id);
    
    RETURN v_nombre_estacion;
END //

DELIMITER ;

SELECT 
	model, 
	battery_level, 
    fn_estacion_actual_scooter(scooter_id) AS estacion_actual 
FROM Scooters;

#Stored Procedures
#3 
    
DELIMITER //
-- ORDENAMIENTO POR CAMPO PREFERENTE DE LA TABLA Y LUEGO POR SENTIDO DE ORDEN ASC O DESC
 CREATE PROCEDURE sp_ordenar_tb_scooters ( 
	IN p_campo_de_orden VARCHAR(50), 
    IN p_sentido_de_orden VARCHAR(5)
)
BEGIN
	SET @intruccion_sql = CONCAT('SELECT * FROM scooters ORDER BY ', p_campo_de_orden,' ', p_sentido_de_orden);
    
    PREPARE stmt FROM @intruccion_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
END //
DELIMITER ;

CALL sp_ordenar_tb_scooters ('battery_level', 'DESC');
CALL sp_ordenar_tb_scooters ('year', 'ASC');    

#4 

DELIMITER //

CREATE PROCEDURE sp_registrar_nueva_estacion(
	IN p_nombre VARCHAR(100),
    IN p_direccion VARCHAR(200),
	IN p_capacidad INT	
)
BEGIN
	INSERT INTO stations (name, address, capacity)
    VALUES (p_nombre, p_direccion, p_capacidad);

	SELECT 'Estación registrada correctamente' AS Mensaje;
END //

DELIMITER ;    

CALL sp_registrar_nueva_estacion('Estación Puerto', 'Av. Costanera 1000', 35);

select *
from stations;


DELIMITER //

CREATE PROCEDURE sp_eliminar_estacion(
	IN p_station_id INT
)
BEGIN
	DELETE FROM stations
    WHERE station_id = p_station_id;

	SELECT 'Estación eliminada correctamente' AS Mensaje;
END //

DELIMITER ;

CALL sp_eliminar_estacion (7);

select *
from stations;