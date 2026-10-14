-- =====================================================================
-- SESIÓN 3B · EJERCICIOS DE REFUERZO
-- 🚫 Sin IA. Guía 1_guia.sql abierta al lado (y la chuleta 5_chuleta.md).
-- Marca:  [x] solo   [p] con pista   [s] con solución
--
-- Tres partes:
--   A. PREDICE (sin escribir consultas): entrenar el "ojo" para saber qué
--      hará SQL antes de ejecutarlo. Es lo que más te va a servir.
--   B. ESCRIBE sobre las tablas mini: puedes comprobar todo a mano.
--   C. APLICA a la tienda: versiones nuevas de los ejercicios de la Sesión 3
--      que hiciste con solución. Ahora sin mirarla.
-- =====================================================================


-- ============================ PARTE A · PREDICE ======================
-- Para cada pregunta: escribe tu respuesta en el comentario SIN ejecutar.
-- Después ejecuta la consulta y marca si acertaste. Si fallaste, escribe
-- en una línea POR QUÉ salió distinto. Ese "por qué" es el aprendizaje.

-- [x] A1. ¿Cuántas filas devuelve? ¿Sale Bruno? ¿Sale Diego?
--         Mi predicción: devuelve 3 lineas, Diego no sale porque no tiene pedido, y Bruno 
--                        si aparece
--         ¿Acerté?: Si          Por qué:
SELECT c.nombre, p.id_pedido
FROM mini.clientes c
JOIN mini.pedidos p ON p.id_cliente = c.id_cliente
WHERE p.canal = 'WhatsApp';


-- [p] A2. La misma, pero con LEFT JOIN y el filtro en el ON. ¿Cuántas filas?
--         ¿Qué sale en id_pedido para Carla (que compró por Feria)?
--         Mi predicción: 3 filas, 104 id_pedido para Carla, Carla no aparece porque su pedido no fue 
--                        por WhatsApp
--         ¿Acerté?: No           Por qué: olvidé que left join trae todos incluso los que no cumplen 
--                                         con la condicion y les pone NULL en ese campo
SELECT c.nombre, p.id_pedido
FROM mini.clientes c
LEFT JOIN mini.pedidos p ON p.id_cliente = c.id_cliente
                        AND p.canal = 'WhatsApp';


-- [x] A3. Igual que A2 pero con el filtro en el WHERE. ¿Cuántas filas?
--         ¿Sigue saliendo Carla? ¿Y Diego?
--         Mi predicción: 3 filas, ya no sale ni Carla ni Diego
--         ¿Acerté?:  Si          Por qué:
SELECT c.nombre, p.id_pedido
FROM mini.clientes c
LEFT JOIN mini.pedidos p ON p.id_cliente = c.id_cliente
WHERE p.canal = 'WhatsApp';


-- [x] A4. ¿Qué número da cada columna?
--         Mi predicción:  a = 6   b = 5   c = 3
--         ¿Acerté?: Si      Por qué:
SELECT COUNT(*)                    AS a,
       COUNT(p.id_pedido)          AS b,
       COUNT(DISTINCT c.ciudad)    AS c
FROM mini.clientes c
LEFT JOIN mini.pedidos p ON p.id_cliente = c.id_cliente;


-- [x] A5. Para Ana, ¿cuánto da cada columna?
--         Mi predicción:  lineas = 3   pedidos = 2
--         ¿Acerté?: Si         Por qué:
SELECT c.nombre,
       COUNT(*)                    AS lineas,
       COUNT(DISTINCT p.id_pedido) AS pedidos
FROM mini.clientes c
JOIN mini.pedidos p ON p.id_cliente = c.id_cliente
JOIN mini.lineas  l ON l.id_pedido  = p.id_pedido
GROUP BY c.nombre;


-- [x] A6. ¿Qué devuelve para Diego cada columna?
--         Mi predicción:  total = NULL   total_0 = 0   pedidos = 0
--         ¿Acerté?: Si        Por qué:
--         Extra: cuando lo ejecutes, mira la columna "pedidos" de Ana y Bruno.
--         ¿Es correcta? Si no, ¿qué está pasando? 
--         tal vez se mal interpreta con el nombre de la columna, ya que Carla tiene 2 pedidos y Bruno 1 
--         pero con 3 productos en total
SELECT c.nombre,
       SUM(l.cantidad * l.precio)              AS total,
       COALESCE(SUM(l.cantidad * l.precio), 0) AS total_0,
       COUNT(p.id_pedido)                      AS pedidos
FROM mini.clientes c
LEFT JOIN mini.pedidos p ON p.id_cliente = c.id_cliente
LEFT JOIN mini.lineas  l ON l.id_pedido  = p.id_pedido
GROUP BY c.nombre;


-- [x] A7. ¿Qué número da cada columna?
--         Mi predicción:  a = 37   b = 37.5   c = 37.5
--         ¿Acerté?:            Por qué:
SELECT 100 * 3 / 8              AS a,
       100.0 * 3 / 8            AS b,
       ROUND(100.0 * 3 / 8, 1)  AS c;


-- ============================ PARTE B · ESCRIBE (mini) =================
-- Antes de escribir cada una, responde en el comentario:
--   ¿JOIN o LEFT JOIN? ¿Por qué? (usa la pregunta de la sección 4 de la guía)

-- [x] B1. Número de pedidos de CADA cliente (nombre), incluidos los que no
--         han comprado. De más a menos pedidos.
--         ¿JOIN o LEFT JOIN? LEFT JOIN porque quiere ver todos los pedidos de cada cliente sin excepcion 
--         ✔ 5 filas: Ana 2 ... Diego 0
SELECT c.nombre, COUNT(p.id_pedido) AS pedidos
FROM mini.clientes c  
LEFT JOIN mini.pedidos p  ON c.id_cliente = p.id_cliente
GROUP BY c.nombre
ORDER BY pedidos DESC; 


-- [x] B2. Clientes que NUNCA han comprado (solo el nombre).
--         ¿JOIN o LEFT JOIN? LEFT JOIN porque quiero traer los que no cumplen con esa condicion
--         ✔ 1 fila: Diego
SELECT c.nombre
FROM mini.clientes c 
LEFT JOIN mini.pedidos p ON p.id_cliente = c.id_cliente 
WHERE p.id_cliente IS NULL;


-- [x] B3. Nombre y ciudad de cada cliente; donde no hay ciudad, que diga 'Sin ciudad'.
--         ✔ 5 filas; Elena → Sin ciudad
SELECT c.nombre,
COALESCE(c.ciudad, 'Sin ciudad') AS ciudad
FROM mini.clientes c; 


-- [x] B4. Por canal: número de pedidos y unidades vendidas (suma de cantidad).
--         Cuidado: para las unidades necesitas lineas, y eso duplica los pedidos.
--         ¿JOIN o LEFT JOIN? JOIN porque necesito contar filas donde si haya valores y hay algunos clientes
--                            sin pedidos.
                      
--         ✔ WhatsApp: 3 pedidos, 9 unidades
SELECT p.canal,
COUNT(DISTINCT p.id_pedido) AS pedidos,
SUM(l.cantidad) AS unidades
FROM mini.pedidos p 
JOIN mini.lineas l ON l.id_pedido = p.id_pedido
GROUP BY p.canal
ORDER BY pedidos DESC;


-- [x] B5. Para CADA cliente: número de pedidos y total gastado (0 si no compró),
--         del que más gastó al que menos. (Es la receta de la sección 10:
--         intenta escribirla SIN mirar la guía.)
--         ✔ Bruno 1 · 105000 primero; Diego 0 · 0 último
SELECT c.nombre,
COUNT(DISTINCT p.id_pedido) AS pedidos,
COALESCE(SUM(l.cantidad * l.precio), 0) AS total_gastado
FROM mini.clientes c 
LEFT JOIN mini.pedidos p ON p.id_cliente = c.id_cliente 
LEFT JOIN mini.lineas l ON l.id_pedido = p.id_pedido 
GROUP BY c.nombre
ORDER BY total_gastado DESC;


-- [x] B6. Ticket promedio de cada cliente que SÍ compró (total gastado ÷ número
--         de pedidos), redondeado a entero.
--         ¿JOIN o LEFT JOIN? JOIN porque solo quiere los clientes que si compraron
--         ✔ 4 filas; Ana = 30000 (60000 ÷ 2)
SELECT c.nombre,
ROUND(SUM(l.cantidad * l.precio) / COUNT(DISTINCT p.id_pedido)) AS ticket_promedio
FROM mini.clientes c 
JOIN mini.pedidos p ON p.id_cliente = c.id_cliente 
JOIN mini.lineas l ON l.id_pedido = p.id_pedido 
GROUP BY c.nombre
ORDER BY ticket_promedio DESC; 


-- [s] B7. ¿Qué % de los clientes ha comprado al menos una vez? (1 decimal)
--         Pista de estructura: (clientes con pedido ÷ total de clientes) × 100.0
--         ✔ 80.0
SELECT ROUND(100.0 * COUNT(DISTINCT p.id_cliente) / COUNT(DISTINCT c.id_cliente), 1) AS pct_compraron
FROM mini.clientes c
LEFT JOIN mini.pedidos p ON p.id_cliente = c.id_cliente; 


-- ============================ PARTE C · APLICA (tienda) ================
SET search_path TO tienda;

-- [x] C1. (Repite el 12 de la Sesión 3, sin mirar tu respuesta anterior)
--         Por canal: número de pedidos y ticket promedio redondeado a entero,
--         del ticket más alto al más bajo.
--         ✔ Web = 131.086 ; Feria = 118.243
SELECT p.canal, 
ROUND(SUM(dp.cantidad * dp.precio_unit) / COUNT(DISTINCT p.id_pedido)) AS ticket_promedio
FROM pedidos p
LEFT JOIN detalle_pedido dp ON dp.id_pedido = p.id_pedido
GROUP BY p.canal
ORDER BY ticket_promedio DESC; 


-- [x] C2. (Como el 14 de la Sesión 3, otra ciudad) Para los clientes de
--         IPIALES: número de pedidos y total gastado. Los 5 que más gastaron.
--         ✔ el primero es el cliente 194: 15 pedidos, 1.664.000
SELECT c.id_cliente,
COUNT(DISTINCT p.id_pedido) AS pedidos,
SUM(dp.cantidad * dp.precio_unit) AS total_gastado
FROM clientes c  
LEFT JOIN pedidos p ON p.id_cliente = c.id_cliente
LEFT JOIN detalle_pedido dp ON dp.id_pedido = p.id_pedido 
WHERE c.ciudad = 'Ipiales'
GROUP BY c.id_cliente
ORDER BY total_gastado DESC
LIMIT 5;


-- [p] C3. (Como el 15 de la Sesión 3, con una vuelta más) Para CADA ciudad de
--         ciudades_meta: su meta, cuántos clientes se registraron EN 2026 y el
--         % de avance (1 decimal), de mayor a menor avance.
--         Tumaco y Túquerres deben aparecer con 0 y 0.0.
--         ✔ 7 filas; Ipiales 13 nuevos, 32.5 %
--         (Si te salen 5 filas, revisa dónde pusiste el filtro de fecha.)
SELECT cm.ciudad, cm.meta_clientes,
COUNT(c.id_cliente) AS clientes_2026, 
ROUND(100.0 * COUNT(c.id_cliente) / cm.meta_clientes, 1) AS pct_avance
FROM ciudades_meta cm 
LEFT JOIN clientes c ON c.ciudad = cm.ciudad 
AND c.fecha_registro >= '2026-01-01' AND c.fecha_registro < '2027-01-01'
GROUP BY cm.ciudad, cm.meta_clientes 
ORDER BY pct_avance DESC;


-- [p] C4. (Como el 13 de la Sesión 3) ¿Qué productos NUNCA se vendieron por el
--         canal 'Web' en febrero de 2026?
--         ✔ 2 filas: Jabón de caléndula y Jabón de café
SELECT pr.nombre
FROM productos pr
WHERE NOT EXISTS (
    SELECT 1
    FROM detalle_pedido d
    JOIN pedidos p ON p.id_pedido = d.id_pedido
    WHERE d.id_producto = pr.id_producto
      AND p.canal = 'Web'
      AND p.fecha >= '2026-02-01' AND p.fecha < '2026-03-01'
      );


-- [s] C5. Por categoría (nombre): número de líneas vendidas, número de pedidos
--         distintos en que aparece y unidades vendidas. Ordena por pedidos.
--         Antes de ejecutar, responde: ¿por qué "líneas" y "pedidos" darán
--         números distintos? creo que porque lineas cuenta tambien los pedidos con ID repetidos y 
--                            pedidos se agrupan 
--         ✔ Jabones: 1495 líneas, 1145 pedidos, 2931 unidades
SELECT cat.nombre AS producto,
COUNT(*) AS lineas,
COUNT(DISTINCT dp.id_pedido) AS pedidos,
SUM(dp.cantidad) AS unidades
FROM detalle_pedido dp
JOIN productos pr ON pr.id_producto = dp.id_producto 
JOIN categorias cat ON cat.id_categoria = pr.id_categoria
GROUP BY producto 
ORDER BY pedidos DESC;


-- ============================ PARTE D · EXPLICA ========================
-- Ahora sí, las preguntas del 16 de la Sesión 3. Usa tus propias palabras y
-- un ejemplo de las tablas mini en cada una (ej.: "como Diego, que...").
--
--   a) ¿Qué diferencia hay entre INNER JOIN y LEFT JOIN?
-- la diferencia es que uno me trae los valores nulos y el otro no, por ejemplo si un cliente
-- no tiene pedidos, el JOIN lo traerá como nulo.
           
--   b) En un LEFT JOIN, ¿por qué cambia el resultado si un filtro de la tabla
--      derecha va en el WHERE en vez de en el ON?  (Pista: compara A2 y A3)
-- porque cuando se hace la condicion en el where, el sistema ya ejecutó antes el comando y la condicion
-- se hará sobre el resultado, en cambio en el on, el comando se hará todo junto y el resultado irá incluido
-- con la condicion que se haya puesto 

--   c) ¿Por qué COUNT(*) da 1 para Diego en un LEFT JOIN, si no tiene pedidos?
-- porque el valor NULL lo contará como un registro, ya que COUNT(*) cuenta filas 
 
--   d) Unes pedidos con lineas y COUNT(*) te da más pedidos de los que hay.
--      ¿Qué pasó y cómo se corrige?
-- porque al unir saldran nuevas filas, COUNT las cuenta todas, se soluciona usando COUNT(DISTINCT)     
--   e) ¿Cuándo usas COALESCE y por qué COUNT no lo necesita pero SUM sí?
-- COALESCE se usa para reemplazar valores nulos, COUNT no lo necesita porque cuando encuentra un valor
-- nulo ya pone 0 por defecto 

--   f) ¿Por qué 100 * 3 / 8 no da 37.5?
-- porque de esa forma bota los decimales 

