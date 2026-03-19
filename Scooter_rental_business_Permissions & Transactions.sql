#1

-- 1. Crearmos user
CREATE USER 'usuario_auditor1'@'localhost' IDENTIFIED BY 'Auditor_1'; #aca indicamos el user y la contraseña

-- Otorgamos permiso solo lectura (SELECT) sobre todas las tablas de la base de datos
GRANT SELECT ON scooter_rental_business_db.* TO 'usuario_auditor1'@'localhost';


-- 2. Creamos el segundo user
CREATE USER 'usuario_operador1'@'localhost' IDENTIFIED BY 'Operador_1';

-- Otorgamos permisos de lectura (SELECT), inserción (INSERT) y modificación (UPDATE) sobre todas las tablas. No se incluye DELETE.
GRANT SELECT, INSERT, UPDATE ON scooter_rental_business_db.* TO 'usuario_operador1'@'localhost';



#2 transacciones

-- insertamos 2 scooters a modo de ejemplo para darlos de baja
INSERT INTO scooters (scooter_id, last_station_id, model, year, battery_level, scooter_condition) VALUES (11, 2, 'Xiaomi M365', 2021, 0, 'Baja');
INSERT INTO scooters (scooter_id, last_station_id, model, year, battery_level, scooter_condition) VALUES (12, 3, 'Inokim Light 2', 2020, 0, 'Baja');

SELECT *
FROM scooters;

-- Iniciamos la transacción
START TRANSACTION;

-- Eliminamos los monopatines con ID 11 y 12 que son dados de baja
DELETE FROM scooters WHERE scooter_id IN (11, 12);

-- Por si necesitamos deshacer los cambios
#ROLLBACK;

-- Para guardar los cambios de forma permanente en la base de datos
COMMIT;

-- podemos comprobar la eliminación, o en caso de hacer rollback la permanencia de los datos.
SELECT *
FROM scooters;

INSERT INTO scooters (scooter_id, last_station_id, model, year, battery_level, scooter_condition) VALUES (11, 2, 'Xiaomi M365', 2021, 0, 'Baja');
INSERT INTO scooters (scooter_id, last_station_id, model, year, battery_level, scooter_condition) VALUES (12, 3, 'Inokim Light 2', 2020, 0, 'Baja');


-- Iniciamos la 2da transacción

select *
from stations;
-- insertamos nuevas estaciones en lote dentro de nuestra tabla stations
START TRANSACTION;

-- Insertamos el primer lote de 4 registros (Estaciones)
INSERT INTO stations (name, address, capacity) VALUES ('Estación Norte 1', 'Av. Libertador 100', 15);
INSERT INTO stations (name, address, capacity) VALUES ('Estación Norte 2', 'Av. Libertador 200', 10);
INSERT INTO stations (name, address, capacity) VALUES ('Estación Centro 1', 'Calle Florida 50', 20);
INSERT INTO stations (name, address, capacity) VALUES ('Estación Centro 2', 'Calle Florida 150', 25);

-- Creamos un punto de guardado después del registro #4
SAVEPOINT lote_primeros_4;

-- Insertamos el segundo lote de 4 registros
INSERT INTO stations (name, address, capacity) VALUES ('Estación Sur 1', 'Av. Mitre 300', 10);
INSERT INTO stations (name, address, capacity) VALUES ('Estación Sur 2', 'Av. Mitre 400', 12);
INSERT INTO stations (name, address, capacity) VALUES ('Estación Este 1', 'Calle San Martín 80', 15);
INSERT INTO stations (name, address, capacity) VALUES ('Estación Este 2', 'Calle San Martín 180', 10);

-- Creamos un punto de guardado después del registro #8
SAVEPOINT lote_ultimos_4;

-- Sentencia comentada para eliminar/liberar el primer punto de guardado
-- RELEASE SAVEPOINT lote_primeros_4;

COMMIT;