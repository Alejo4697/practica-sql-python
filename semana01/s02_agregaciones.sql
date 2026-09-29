-- =====================================================================
-- SESIÓN 2 · EJERCICIOS: COUNT, SUM, AVG, GROUP BY, HAVING, CASE
-- 🚫 MODO SIN IA. Guía abierta al lado. Protocolo: 10 min → Pista 1 →
-- 5 min → Pista 2 → 5 min → solución (y reescribirla sin mirar).
-- Marca:  [x] solo   [p] con pista   [s] con solución
-- =====================================================================
SET search_path TO tienda;


-- ============================ NIVEL 1 ================================

-- [x] 1. ¿Cuántos pedidos hay en total?
--        ✔ 1756
SELECT COUNT(*) AS total_pedidos
FROM pedidos; 


-- [x] 2. Número de pedidos por canal, del canal con más pedidos al que menos.
--        ✔ 4 filas; WhatsApp = 743
SELECT canal, COUNT(*) AS pedidos
FROM pedidos
GROUP BY canal
ORDER BY pedidos DESC;


-- [x] 3. Número de clientes por ciudad, de mayor a menor.
--        ✔ Pasto = 111, Bogotá = 30
SELECT ciudad, COUNT(*) AS clientes
FROM clientes
GROUP BY ciudad
ORDER BY clientes DESC;


-- [x] 4. Precio mínimo, máximo y promedio (redondeado) de los productos.
--        ✔ 16000 · 95000 · 32667
SELECT MIN(precio) AS minimo,
       MAX(precio) AS maximo,
       ROUND(AVG(precio)) AS promedio
FROM productos;


-- [x] 5. Unidades vendidas por producto (id_producto), de más a menos.
--        Tabla: detalle_pedido.   ✔ 12 filas; el primero es el producto 10 con 630
SELECT id_producto, SUM(cantidad) AS unidades
FROM detalle_pedido
GROUP BY id_producto 
ORDER BY unidades DESC;


-- ============================ NIVEL 2 ================================

-- [x] 6. Pedidos por mes durante 2026 (número de mes y cantidad), en orden de mes.
--        Necesitas: WHERE (rango del año) + EXTRACT + GROUP BY
--        ✔ 8 filas; mayo (5) = 276
SELECT EXTRACT(MONTH FROM fecha) AS mes, COUNT(*) AS pedidos_mes
FROM pedidos
WHERE fecha >= '2026-01-01' AND fecha < '2027-01-01'
GROUP BY EXTRACT(MONTH FROM fecha)
ORDER BY mes;


-- [x] 7. Ciudades con MÁS de 30 clientes.
--        Necesitas: GROUP BY + HAVING
--        ✔ 5 filas (¿por qué no sale Bogotá? mira el ejercicio 3)
SELECT ciudad, COUNT(*) AS total_clientes
FROM clientes 
GROUP BY ciudad
HAVING COUNT(*) > 30
ORDER BY total_clientes DESC;


-- [x] 8. Por canal: número de pedidos y número de clientes DISTINTOS que compraron.
--        Necesitas: COUNT(*) y COUNT(DISTINCT ...)
--        ✔ WhatsApp: 743 pedidos de 274 clientes distintos
SELECT canal, COUNT(DISTINCT id_cliente) AS clientes, COUNT(*) AS pedido
FROM pedidos 
GROUP BY canal
ORDER BY pedido DESC;


-- [x] 9. Clasifica los productos en 'Económico' (< 20.000), 'Medio' (20.000 a 49.999)
--        y 'Premium' (50.000 o más). ¿Cuántos productos hay en cada segmento?
--        Necesitas: CASE + GROUP BY
--        ✔ Medio 7 · Económico 4 · Premium 1
SELECT CASE 
	WHEN precio < 20000 THEN 'Economico'
	WHEN precio < 50000 THEN 'Medio'
	ELSE 'Premium'
END AS segmento,
COUNT(*) AS cant_productos
FROM productos 
GROUP BY segmento 
ORDER BY cant_productos DESC;


-- [x] 10. Valor total de cada pedido (suma de cantidad × precio_unit de sus líneas).
--         Muestra los 5 pedidos de mayor valor.
--         Necesitas: SUM de una expresión + GROUP BY id_pedido + LIMIT
--         ✔ el primero es el pedido 62 con 471000
SELECT id_pedido, SUM(cantidad * precio_unit) AS valor_total
FROM detalle_pedido 
GROUP BY id_pedido
ORDER BY valor_total DESC
LIMIT 5;


-- ============================ NIVEL 3 ================================

-- [x] 11. ¿Cuál es el ticket promedio de la tienda? (valor promedio de un pedido)
--         Pista de negocio: ticket promedio = ingresos totales ÷ número de pedidos.
--         Resuélvelo en UNA sola consulta sobre detalle_pedido.
--         ✔ 126195 (redondeado)
SELECT ROUND (SUM(cantidad * precio_unit) / COUNT(DISTINCT id_pedido)) AS ticket_promedio
FROM detalle_pedido;


-- [x] 12. Usando v_ventas: ingresos por categoría y canal, ordenados por
--         categoría y, dentro de cada una, de mayor a menor ingreso.
--         ✔ 16 filas; Kits por WhatsApp = 33.326.000
SELECT categoria, canal, SUM(total_linea) AS ingresos
FROM v_ventas
GROUP BY categoria, canal 
ORDER BY categoria, ingresos DESC;



-- [x] 13. Clientes con 10 o más pedidos, del que más tiene al que menos.
--         ✔ 20 filas; el primero es el cliente 194 con 15
SELECT id_cliente, COUNT(id_pedido) AS total_pedidos
FROM pedidos
GROUP BY id_cliente
HAVING COUNT(id_pedido) >= 10
ORDER BY total_pedidos DESC;


-- [x] 14. Para cada mes de 2026: pedidos por WhatsApp y pedidos por los demás
--         canales, en DOS columnas separadas (whatsapp | otros).
--         ✔ mayo: 123 | 153
SELECT EXTRACT (MONTH FROM fecha) AS mes, 
COUNT(*) FILTER (WHERE canal = 'WhatsApp') AS whatsapp,
COUNT(*) FILTER (WHERE canal <> 'WhatsApp') AS otros
FROM pedidos
WHERE fecha >= '2026-01-01' AND fecha < '2027-01-01'
GROUP BY EXTRACT (MONTH FROM fecha)
ORDER BY mes;


-- [s] 15. Solo para clientes registrados desde el 1 de julio de 2025: por ciudad,
--         cuántos clientes, la primera y la última fecha de registro.
--         Muestra solo las ciudades con 25 clientes o más.
--         ✔ 4 filas; Pasto = 74
SELECT ciudad, 
COUNT(*) AS clientes, 
MIN(fecha_registro) AS primer_registro,
MAX(fecha_registro) AS ultimo_registro
FROM clientes 
WHERE fecha_registro >= '2025-07-01'
GROUP BY ciudad 
HAVING COUNT(*) >= 25
ORDER BY clientes DESC;



-- [ ] 16. Preguntas (responde en comentarios):
--   a) ¿Cuál es la diferencia entre WHERE y HAVING? ¿Cuándo DEBES usar HAVING?
-- WHERE se usa para dar una condicion sobre columnas, HAVING se debe usar cuando se pone una condicion sobre un conteo
--   b) ¿Qué diferencia hay entre COUNT(*), COUNT(columna) y COUNT(DISTINCT columna)?
-- COUNT(*) es para contar todo de una tabla, COUNT(columna) solo para contar los valores de una unica columna y COUNT(DISTINCT columna) para ignorar valores repetidos        
--   c) ¿Por qué falla  SELECT canal, fecha, COUNT(*) FROM pedidos GROUP BY canal ?
-- Porque fecha no aparece dentro del GROUP BY

