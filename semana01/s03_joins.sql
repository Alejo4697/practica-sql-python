-- =====================================================================
-- SESIÓN 3 · EJERCICIOS: JOINs
-- 🚫 MODO SIN IA. Guía abierta al lado. Protocolo: 10 min → Pista 1 →
-- 5 min → Pista 2 → 5 min → solución (y reescribirla sin mirar).
-- Marca:  [x] solo   [p] con pista   [s] con solución
--
-- ⚠ Requisito: haber ejecutado el PASO 0 de la guía (tabla ciudades_meta).
--
-- Estilo (lo del viernes): palabras clave en MAYÚSCULA, una cláusula por
-- línea, alias en todas las columnas (p.fecha, c.ciudad) y fechas con >= y <.
-- Y antes de dar un ejercicio por terminado: relee el enunciado contra tu consulta.
--
-- El mapa, para tenerlo a la vista:
--   clientes ─< pedidos ─< detalle_pedido >─ productos >─ categorias
--   ciudades_meta  (se une con clientes por ciudad)
-- =====================================================================
SET search_path TO tienda;


-- ============================ NIVEL 1 ================================

-- [x] 1. Cada pedido con la ciudad de su cliente: id_pedido, fecha, ciudad.
--        ✔ 1756 filas
SELECT p.id_pedido, p.fecha, c.ciudad
FROM pedidos p
JOIN clientes c ON p.id_cliente  = c.id_cliente 
ORDER BY p.id_pedido;


-- [x] 2. Cada producto con el nombre de su categoría (y su precio),
--        ordenados por categoría y luego por producto.
--        ✔ 12 filas
SELECT pr.nombre AS producto, c.nombre AS categoria, pr.precio
FROM productos pr
JOIN  categorias c ON pr.id_categoria = c.id_categoria 
ORDER BY categoria, producto;


-- [x] 3. Pedidos de clientes de Ipiales durante 2026 (id_pedido, fecha, canal).
--        ✔ 164 filas
SELECT p.id_pedido, p.fecha, p.canal
FROM pedidos p
JOIN clientes c ON c.id_cliente = p.id_cliente
WHERE p.fecha >= '2026-01-01' AND p.fecha <'2027-01-01'
  AND c.ciudad = 'Ipiales'
ORDER BY p.fecha;


-- [x] 4. Las líneas del pedido 1523, con el NOMBRE del producto, la cantidad,
--        el precio unitario y el total de la línea.
--        ✔ 3 filas; la más cara es "Kit facial completo" (285000)
SELECT d.id_pedido, d.id_producto AS producto, p.nombre, d.cantidad, d.precio_unit,
       d.cantidad * d.precio_unit AS total_linea
FROM detalle_pedido d
JOIN productos p ON p.id_producto = d.id_producto    
WHERE d.id_pedido = 1523
ORDER BY total_linea DESC;


-- [x] 5. Número de pedidos por ciudad, de mayor a menor.
--        ✔ Pasto = 669
SELECT c.ciudad, COUNT(*) AS pedidos
FROM pedidos p
JOIN clientes c ON c.id_cliente = p.id_cliente
GROUP BY c.ciudad 
ORDER BY pedidos DESC;


-- ============================ NIVEL 2 ================================

-- [s] 6. Ingresos por categoría (nombre), SIN usar v_ventas: construye tú el
--        camino detalle_pedido → productos → categorias.
--        Necesitas: 2 JOINs + SUM + GROUP BY
--        ✔ Kits = 79.819.000 (igual que en la Sesión 2 con v_ventas)
SELECT c.nombre AS categoria,
SUM(dp.cantidad * dp.precio_unit) AS ingresos
FROM detalle_pedido dp 
JOIN productos p ON p.id_producto = dp.id_producto
JOIN categorias c ON c.id_categoria = p.id_categoria 
GROUP BY c.nombre 
ORDER BY ingresos DESC;


-- [x] 7. Ingresos por ciudad del cliente.
--        Necesitas: el camino detalle_pedido → pedidos → clientes
--        ✔ 6 filas; Pasto = 82.498.000
SELECT c.ciudad, SUM(dp.cantidad * dp.precio_unit) AS ingresos
FROM detalle_pedido dp 
JOIN pedidos p ON p.id_pedido = dp.id_pedido 
JOIN clientes c ON c.id_cliente = p.id_cliente 
GROUP BY c.ciudad 
ORDER BY ingresos DESC;


-- [x] 8. Ciudades de ciudades_meta que NO tienen ningún cliente.
--        Necesitas: LEFT JOIN + IS NULL  (o NOT EXISTS)
--        ✔ 2 filas: Tumaco y Túquerres
SELECT cm.ciudad AS ciudad
FROM ciudades_meta cm 
LEFT JOIN clientes c ON c.ciudad = cm.ciudad 
WHERE c.id_cliente IS NULL;


-- [p] 9. Clientes que NO hicieron ningún pedido en 2026.
--        Necesitas: anti-join. Ojo dónde pones la condición de fecha (guía, sección F).
--        ✔ 12 filas
SELECT c.id_cliente AS clientes
FROM clientes c  
LEFT JOIN pedidos p ON p.id_cliente = c.id_cliente 
AND p.fecha >= '2026-01-01' 
WHERE p.id_pedido IS NULL;



-- [x] 10. Lo contrario del 8: ciudades donde SÍ hay clientes pero que NO están
--         en ciudades_meta (alguien olvidó ponerles meta).
--         ✔ 1 fila
SELECT DISTINCT c.ciudad AS ciudad
FROM clientes c 
LEFT JOIN ciudades_meta cm ON cm.ciudad = c.ciudad 
WHERE cm.meta_clientes IS NULL;


-- ============================ NIVEL 3 ================================

-- [p] 11. ¿Cuántos pedidos incluyen al menos un producto de la categoría Kits
--         (id_categoria = 4)?
--         ✔ 555. Si te dio 584, mira la sección H de la guía: ¿qué estás contando?
SELECT COUNT(DISTINCT dp.id_pedido) AS pedido
FROM detalle_pedido dp  
JOIN productos p ON p.id_producto = dp.id_producto 
WHERE p.id_categoria = 4;
 

-- [s] 12. Por canal: número de pedidos y ticket promedio (valor promedio de un
--         pedido), del ticket más alto al más bajo.
--         ✔ Web = 131.086 ; Feria = 118.243
SELECT p.canal AS canal, COUNT(DISTINCT dp.id_pedido),
ROUND(SUM(dp.cantidad * dp.precio_unit) / COUNT(DISTINCT p.id_pedido)) AS ticket_promedio
FROM pedidos p 
JOIN detalle_pedido dp ON dp.id_pedido = p.id_pedido
GROUP BY canal 
ORDER BY ticket_promedio DESC;


-- [s] 13. ¿Qué producto(s) NUNCA se vendieron por el canal 'Feria' en diciembre de 2025?
--         ✔ 1 fila
SELECT pr.nombre
FROM productos pr
WHERE NOT EXISTS (
    SELECT 1
    FROM detalle_pedido d
    JOIN pedidos p ON p.id_pedido = d.id_pedido
    WHERE d.id_producto = pr.id_producto
      AND p.canal = 'Feria'
      AND p.fecha >= '2025-12-01' AND p.fecha < '2026-01-01'
);


-- [s] 14. Para los clientes de Bogotá: número de pedidos y total gastado.
--         Muestra los 5 que más gastaron.
--         (Pregunta extra: ¿qué pasaría con un cliente de Bogotá sin pedidos si
--          usaras JOIN en vez de LEFT JOIN? ¿Y con SUM sin COALESCE?)
--         ✔ el primero es el cliente 128: 6 pedidos, 1.424.000
SELECT c.id_cliente,
COUNT(DISTINCT p.id_pedido) AS pedidos,
COALESCE(SUM(dp.cantidad * dp.precio_unit), 0) AS total_gastado
FROM clientes c
LEFT JOIN pedidos p ON p.id_cliente = c.id_cliente
LEFT JOIN detalle_pedido dp ON dp.id_pedido = p.id_pedido 
WHERE c.ciudad = 'Bogotá'
GROUP BY c.id_cliente
ORDER BY total_gastado DESC 
LIMIT 5;



-- [s] 15. Reporte para la gerencia: para CADA ciudad de ciudades_meta, su meta,
--         cuántos clientes tiene hoy y el % de avance (1 decimal), de mayor a
--         menor avance. Las ciudades sin clientes deben salir con 0 y 0.0 %.
--         ✔ 7 filas; Medellín e Ipiales 87.5 % ; Tumaco 0 clientes (no 1)
SELECT m.ciudad, m.meta_clientes,
COUNT(c.id_cliente) AS clientes,
ROUND(100.0 * COUNT(c.id_cliente) / m.meta_clientes, 1) AS pct_avance
FROM ciudades_meta m
LEFT JOIN clientes c ON c.ciudad = m.ciudad
GROUP BY m.ciudad, m.meta_clientes
ORDER BY pct_avance DESC;


-- [ ] 16. Preguntas (responde en comentarios, como si fuera una entrevista):
--   a) ¿Qué diferencia hay entre INNER JOIN y LEFT JOIN?
--   b) En un LEFT JOIN, ¿por qué cambia el resultado si un filtro de la tabla
--      derecha va en el WHERE en vez de en el ON?
--   c) ¿Por qué COUNT(*) da 1 para Tumaco en un LEFT JOIN, si no tiene clientes?
--   d) Unes pedidos con detalle_pedido y COUNT(*) te da más pedidos de los que
--      hay. ¿Qué pasó y cómo se corrige?
--
-- Tus respuestas:
--

