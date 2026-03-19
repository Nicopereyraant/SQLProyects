#VIEWS
#1 Ver la solo la flota optima disponible.

CREATE VIEW vw_flota_optima AS
SELECT 
	sc.scooter_id,
    st.name as current_station,
    sc.battery_level,
    sc.scooter_condition
FROM scooters sc
INNER JOIN stations st
	ON sc.last_station_id = st.station_id
WHERE sc.scooter_condition = 'Óptimo'
ORDER BY 
	sc.battery_level DESC;
    
SELECT *
FROM vw_flota_optima;

#2 Ver detalle de descriptivo de usuario que realiza un viaje.

CREATE VIEW vw_detalle_viajes AS
SELECT
	t.trip_id,
	u.first_name as nombre,
    u.last_name as apellido,
    s.model as modelo_scooter,
    s2.name as estacion_partida,
    s3.name as estacion_llegada,
    CAST(t.end_time AS DATE) as trip_date,
    t.distance_km as kilometros_recorridos
FROM trips t
INNER JOIN users u
	ON t.user_id = u.user_id
INNER JOIN scooters s
	ON t.scooter_id = s.scooter_id
INNER JOIN stations s2
	ON t.station_start_id = s2.station_id
INNER JOIN stations s3
	ON t.station_end_id = s3.station_id

ORDER BY
	trip_date, trip_id ASC
;

SELECT *
FROM vw_detalle_viajes;

#3 Ver el flujo de ingresos de la empresa de forma historica estilo KPIs

CREATE VIEW vw_ingresos_ft_metododepago AS
SELECT
	p.method_type as Metodo_pago,
    sum(c.total_amount) as Monto_total
FROM payment_methods p
INNER JOIN charges c
	ON p.pay_method_id = c.pay_method_id
WHERE c.charge_status = 'Pagado'
GROUP BY    
	p.method_type
;

SELECT *
FROM vw_ingresos_ft_metododepago;

#4 Esta view nos ayuda a identificar los clientes que estan morosos de pago.

CREATE VIEW vw_control_morosos AS
SELECT
	u.first_name as nombre,
    u.last_name as apellido,
    u.email,
    u.document as documento,
    sum(c.total_amount) as total_adeudado,
    c.currency as moneda
FROM users u
INNER JOIN trips t
	ON u.user_id = t.user_id
INNER JOIN charges c
	ON t.trip_id = c.trip_id
WHERE c.charge_status IN ('Pendiente','Fallido')
GROUP BY
	u.user_id, 
    u.first_name, 
    u.last_name,
    u.email,
    u.document,
    c.currency
;    

SELECT *
FROM vw_control_morosos;

#5 Ranking de heavy users, check de usabilidad y frecuencia.

CREATE VIEW vw_ranking_usuarios AS
SELECT 
	u.first_name as nombre,
    u.last_name as apellido,
    count(t.trip_id) as cant_viajes,
    sum(t.distance_km) as distancia_total_recorrida,
	DENSE_RANK() OVER (
		ORDER BY count(t.trip_id) DESC, sum(t.distance_km) DESC
	) as puesto_ranking
FROM users u
INNER JOIN trips t
	ON u.user_id = t.user_id
GROUP BY
	u.user_id,
    u.first_name,
    u.last_name
;

SELECT *
FROM vw_ranking_usuarios;

#6

CREATE VIEW vw_gastos_mantenimiento_staff AS
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS empleado,
    s.role AS rol,
    COUNT(m.maintenance_id) AS cantidad_reparaciones,
    SUM(m.cost) AS costo_total_reparaciones
FROM Staff s
INNER JOIN Maintenance m 
    ON s.staff_id = m.staff_id
GROUP BY 
    s.staff_id, s.first_name, s.last_name, s.role
ORDER BY 
    costo_total_reparaciones DESC;
    
SELECT *
FROM vw_gastos_mantenimiento_staff;

#7

CREATE VIEW vw_satisfaccion_por_modelo AS
SELECT 
    sc.model AS modelo_scooter,
    COUNT(ur.review_id) AS total_viajes_calificados,
    ROUND(AVG(ur.rating), 2) AS promedio_estrellas
FROM Scooters sc
INNER JOIN Trips t 
    ON sc.scooter_id = t.scooter_id
INNER JOIN User_Reviews ur 
    ON t.trip_id = ur.trip_id
GROUP BY 
    sc.model
ORDER BY 
    promedio_estrellas DESC;
    
SELECT *
FROM vw_satisfaccion_por_modelo; 


