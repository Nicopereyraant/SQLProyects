CREATE TABLE log_Scooters (
	id_log INT AUTO_INCREMENT PRIMARY KEY,
    scooter_id int,
    accion VARCHAR(10),
    status_anterior VARCHAR(50),
    status_nuevo VARCHAR(50),
    old_value_battery INT,
    new_value_battery INT,
    user_sql_database VARCHAR(100),
    action_date DATETIME
);

#1er Trigger Log de auditoria para cambios/actualizaciones sobre la tabla de scooters

DELIMITER //
CREATE TRIGGER trg_auditoria_cambios_scooters
AFTER UPDATE ON scooters
FOR EACH ROW
BEGIN
	INSERT INTO log_scooters (
		scooter_id,
        accion,
        status_anterior,
        status_nuevo,
        old_value_battery,
        new_value_battery,
        user_sql_database,
        action_date
	)
    VALUES (
		OLD.scooter_id,
        'UPDATE',
        OLD.scooter_condition,
        NEW.scooter_condition,
        OLD.battery_level,
        NEW.battery_level,
        CURRENT_USER(),
        NOW()
	);
END //
DELIMITER  ;

SELECT * FROM scooters;

UPDATE scooters
SET scooter_condition = 'Batería Baja', battery_level = 15.80
WHERE scooter_id = 1;

SELECT * FROM log_Scooters;
    
DROP TRIGGER IF EXISTS trg_auditoria_cambios_scooters;  

#2do trigger - cambia el estado del scooter cuando inicia un viaje automaticamente.

DELIMITER //

CREATE TRIGGER trg_actualizar_condicion_scooter
AFTER INSERT ON trips       
FOR EACH ROW
BEGIN
   
    UPDATE scooters 
    SET scooter_condition = 'En Uso' 
    WHERE scooter_id = NEW.scooter_id; -- Usamos el ID del scooter del viaje que se acaba de crear
END //

DELIMITER ;

INSERT INTO trips (user_id, scooter_id, station_start_id, start_time) 
VALUES (10, 2, 1, NOW());

SELECT *
FROM scooters
WHERE scooter_id = 2;

