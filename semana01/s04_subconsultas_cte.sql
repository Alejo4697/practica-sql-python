-- =====================================================================
-- SESIÓN 4 · EJERCICIOS: SUBCONSULTAS y CTEs
-- 🚫 Sin IA. Guía y chuleta (5_chuleta.md) abiertas al lado.
-- Marca:  [x] solo   [p] con pista   [s] con solución
--
-- Partes: A. PREDICE · B. ESCRIBE (mini) · C. APLICA (tienda) · D. EXPLICA
--
-- Lo del refuerzo: antes de marcar [x], relee el enunciado y busca en tu
-- consulta CADA cosa que pide (columnas, filtros, orden). Y pon alias que
-- digan lo que la columna es.
-- =====================================================================


-- ============================ PARTE A · PREDICE ======================
-- Escribe tu predicción SIN ejecutar. Luego ejecuta y explica si fallaste.

-- [x] A1. ¿Qué nombres salen? ¿Cuántas veces sale Ana (que tiene 2 pedidos)?
--         Mi predicción: Ana, Bruno, Carla, Elena
--         ¿Acerté?: Si   Por qué:
SELECT nombre
FROM mini.clientes
WHERE id_cliente IN (SELECT id_cliente FROM mini.pedidos);


-- [x] A2. mini.ciudades = Pasto, Cali, Ipiales, Tumaco. ¿Cuántas filas salen?
--         ¿Sale Elena (ciudad NULL)?
--         Mi predicción: 0 filas
--         ¿Acerté?: Si      Por qué:
SELECT nombre, ciudad
FROM mini.clientes
WHERE ciudad NOT IN (SELECT ciudad FROM mini.ciudades);


-- [x] A3. ¿Qué número devuelve?
--         Mi predicción: 4
--         ¿Acerté?: Si           Por qué:
SELECT COUNT(*) AS clientes_con_pedidos
FROM (
    SELECT id_cliente
    FROM mini.pedidos
    GROUP BY id_cliente
) AS x;


-- [x] A4. Los totales por pedido son 50000, 10000, 105000, 95000, 10000.
--         ¿Qué número devuelve?
--         Mi predicción: 3
--         ¿Acerté?: Si       Por qué:
WITH totales AS (
    SELECT id_pedido, SUM(cantidad * precio) AS total
    FROM mini.lineas
    GROUP BY id_pedido
)
SELECT COUNT(*) AS pedidos_bajo_promedio
FROM totales
WHERE total < (SELECT AVG(total) FROM totales);


-- [x] A5. ¿Qué número devuelve? (pista: ¿qué pedidos son del cliente 1?)
--         Mi predicción: 30000
--         ¿Acerté?: Si      Por qué:
WITH totales AS (
    SELECT id_pedido, SUM(cantidad * precio) AS total
    FROM mini.lineas
    GROUP BY id_pedido
)
SELECT AVG(t.total) AS ticket_ana
FROM totales t
JOIN mini.pedidos p ON p.id_pedido = t.id_pedido
WHERE p.id_cliente = 1;


-- ============================ PARTE B · ESCRIBE (mini) =================

-- [x] B1. Líneas (id_pedido, producto, cantidad) cuya cantidad es MAYOR que la
--         cantidad promedio de todas las líneas.
--         ✔ 2 filas (las de cantidad 2 y 3)
SELECT id_pedido, producto, cantidad
FROM mini.lineas
WHERE cantidad > (SELECT AVG(cantidad) FROM mini.lineas);


-- [x] B2. Nombres de los clientes que han comprado por 'Web'. Usa IN.
--         ✔ 1 fila: Ana
SELECT nombre
FROM mini.clientes
WHERE id_cliente IN (SELECT id_cliente FROM mini.pedidos WHERE canal = 'Web');


-- [x] B3. Nombres de los clientes que NUNCA han comprado por 'WhatsApp'.
--         Usa NOT EXISTS (¿por qué no NOT IN? → sección 3 de la guía).
--         ✔ 2 filas: Carla y Diego
SELECT c.nombre
FROM mini.clientes c
WHERE NOT EXISTS (
SELECT 1 FROM mini.pedidos p WHERE p.id_cliente = c.id_cliente 
AND p.canal = 'WhatsApp'
);


-- [x] B4. Con una CTE de totales por pedido: el total del pedido más caro, el
--         del más barato y el ticket promedio (redondeado), en una sola fila.
--         ✔ 105000 · 10000 · 54000
WITH totales AS(
SELECT id_pedido, SUM(cantidad * precio) AS total
FROM mini.lineas
GROUP BY id_pedido 
)
SELECT MAX(total) AS pedido_mas_caro,
MIN(total) AS pedido_mas_barato,
ROUND(AVG(total)) AS ticket_promedio
FROM totales;


-- [x] B5. ¿Cuántos pedidos tiene en promedio cada cliente, contando a Diego
--         con 0? (1 decimal)
--         Pista de estructura: CTE con los pedidos de CADA cliente → AVG.
--         ✔ 1.0
WITH pedidos_cliente AS(
SELECT c.id_cliente, COUNT(p.id_pedido) AS pedidos
FROM mini.clientes c 
LEFT JOIN mini.pedidos p ON p.id_cliente = c.id_cliente 
GROUP BY c.id_cliente 
)
SELECT ROUND(AVG(pedidos), 1) AS promedio_pedidos
FROM pedidos_cliente;


-- ============================ PARTE C · APLICA (tienda) ================
SET search_path TO tienda;

-- [x] C1. Productos (nombre, precio) con precio mayor al precio promedio de
--         todos los productos, del más caro al más barato.
--         ✔ 4 filas; el más barato de ellos es "Vela de lavanda" (35000)
SELECT p.nombre, p.precio 
FROM productos p 
WHERE p.precio > (SELECT AVG(p.precio) FROM productos p)
ORDER BY p.precio DESC;


-- [x] C2. ¿Cuántos clientes han comprado por 'Feria' Y TAMBIÉN por 'Web'?
--         ✔ 107
SELECT COUNT(*) AS clientes
FROM clientes c 
WHERE c.id_cliente IN (SELECT p.id_cliente FROM pedidos p WHERE canal = 'Feria')
AND c.id_cliente IN (SELECT p.id_cliente FROM pedidos p WHERE canal = 'Web');


-- [x] C3. ¿Cuántos pedidos tienen un total MAYOR que el ticket promedio?
--         ✔ 721 (el ticket promedio es 126.195)
WITH totales AS(
SELECT dp.id_pedido, SUM(dp.cantidad * dp.precio_unit) AS total
FROM detalle_pedido dp 
GROUP BY dp.id_pedido 
)
SELECT COUNT(*) AS pedidos_mayor_promedio
FROM totales 
WHERE total > (SELECT AVG(total) FROM totales);


-- [x] C4. ¿Cuántos clientes gastaron MÁS que el promedio de gasto por cliente?
--         ✔ 137 (el promedio de gasto por cliente es 738.663)
WITH gasto_clientes AS(
SELECT p.id_cliente, SUM(dp.cantidad * dp.precio_unit) AS gasto
FROM pedidos p 
JOIN detalle_pedido dp ON dp.id_pedido = p.id_pedido 
GROUP BY p.id_cliente 
)
SELECT COUNT(*) AS clientes_mayor_promedio
FROM gasto_clientes 
WHERE gasto > (SELECT AVG(gasto) FROM gasto_clientes);


-- [x] C5. Por ciudad: número de clientes y promedio de pedidos por cliente
--         (1 decimal), del promedio más alto al más bajo. Si empatan, por
--         nombre de ciudad.
--         ✔ 6 filas; Ipiales y Popayán empatan arriba con 6.1; Bogotá último con 5.0
WITH pedidos_cliente AS(
SELECT c.id_cliente, c.ciudad, COUNT(p.id_pedido) AS pedidos
FROM clientes c 
LEFT JOIN pedidos p ON p.id_cliente = c.id_cliente 
GROUP BY c.id_cliente, c.ciudad
)
SELECT ciudad, COUNT(*) AS clientes,
ROUND(AVG(pedidos), 1) AS promedio_pedidos
FROM pedidos_cliente
GROUP BY ciudad 
ORDER BY promedio_pedidos DESC, ciudad; 


-- [x] C6. Meses de 2026 cuyas ventas superaron el promedio mensual de 2026.
--         Muestra el mes y sus ventas.
--         ✔ 4 filas: mayo a agosto (el promedio mensual es 19.365.125)
WITH venta_mes AS(
SELECT EXTRACT(MONTH FROM p.fecha) AS mes,
SUM(dp.cantidad * dp.precio_unit) AS ventas
FROM pedidos p 
JOIN detalle_pedido dp ON dp.id_pedido = p.id_pedido 
WHERE p.fecha >= '2026-01-01' AND p.fecha < '2027-01-01'
GROUP BY EXTRACT(MONTH FROM p.fecha)
)
SELECT mes, ventas
FROM venta_mes 
WHERE ventas > (SELECT AVG(ventas)FROM venta_mes)
ORDER BY mes;


-- ============================ PARTE D · EXPLICA ========================
-- Con tus palabras, como en una entrevista, y con un ejemplo de las tablas mini.
--
--   a) ¿Cuándo necesitas una subconsulta o una CTE?
-- Cuando necesito calcular algo primero para usarlo después. Ej.: productos
-- más caros que el promedio: primero calculo el promedio y luego comparo.  
--   b) ¿Por qué es peligroso usar NOT IN con una subconsulta?
-- -- Si la lista de la subconsulta tiene un NULL, NOT IN devuelve 0 filas sin
-- dar error. Ej.: ciudades sin clientes da 0 porque Elena tiene ciudad NULL;
-- con NOT EXISTS sale Tumaco. 
--   c) ¿Qué diferencia hay entre una subconsulta en el FROM y una CTE?
-- La subconsulta en el FROM se usa una vez. La CTE va antes, tiene nombre,
-- se lee de arriba abajo y se puede usar varias veces.

