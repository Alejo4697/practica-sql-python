-- =====================================================================
-- SESIÓN 1 · EJERCICIOS: SELECT, WHERE, ORDER BY, LIMIT, DISTINCT
-- 🚫 MODO SIN IA. Tienes la guía (1_guia.sql) abierta al lado: úsala.
--
-- Protocolo cuando te trabes:
--   1) Intenta 10 min (releer la guía cuenta como intentar).
--   2) Abre 3_pistas.md → Pista 1 de ese ejercicio. Intenta 5 min más.
--   3) Pista 2. Intenta 5 min más.
--   4) Solo entonces: soluciones.sql. Y vuelve a escribirla TÚ sin mirar.
--
-- ✔ = dato para verificar tu resultado (en DBeaver el nº de filas sale
--     abajo, en la barra de resultados).
-- Marca cada ejercicio al terminar:  [x] solo   [p] con pista   [s] con solución
-- =====================================================================
SET search_path TO tienda;


-- ============================ NIVEL 1 ================================
-- Completa los espacios ___ . La estructura ya está; tú pones las piezas.

-- [x] 1. Todos los productos (nombre y precio), del más caro al más barato.
--        ✔ 12 filas, el primero es "Kit facial completo" (95000)
select nombre, precio 
FROM productos
ORDER by precio desc, nombre;



-- [x] 2. Productos (nombre, precio) que cuestan MENOS de 20.000.
--        ✔ 4 filas
SELECT nombre, precio
FROM productos
WHERE precio < 20000;


-- [x] 3. Clientes (id_cliente, fecha_registro) de la ciudad de Pasto.
--        ✔ 111 filas
SELECT id_cliente, fecha_registro
from clientes 
WHERE ciudad = 'Pasto';


-- [p] 4. Lista de ciudades SIN repetir, en orden alfabético.
--        ✔ 6 filas
select distinct ciudad
FROM clientes
ORDER by ciudad;


-- [x] 5. Pedidos (id_pedido, fecha, canal) del canal 'Feria' en diciembre de 2025.
--        ✔ 37 filas
SELECT id_pedido, fecha, canal
FROM pedidos
WHERE canal = 'Feria'
  AND fecha BETWEEN '2025-12-01' and '2025-12-31';


-- [p] 6. Nombre, precio y precio con IVA del 19 % (llámala precio_con_iva).
--        ✔ el Kit facial completo queda en 113050
SELECT nombre, precio, precio * 1.19 AS precio_con_iva
FROM productos;


-- ============================ NIVEL 2 ================================
-- Te doy el enunciado y qué cláusulas necesitas. La consulta es tuya.

-- [x] 7. Productos cuyo nombre empieza por "Jabón".
--        Necesitas: WHERE + LIKE          ✔ 5 filas
select nombre from productos 
where nombre like 'Jabón%';



-- [x] 8. Clientes de Cali, Bogotá o Medellín registrados desde el 1 de enero de 2026.
--        Necesitas: WHERE + IN + AND      ✔ 28 filas
select id_cliente, ciudad, fecha_registro from clientes
where ciudad in ('Cali', 'Bogotá', 'Medellín') and fecha_registro >= '2026-01-01';


-- [x] 9. Los 5 pedidos más recientes. Si hay empate de fecha, el id_pedido más alto primero.
--        Necesitas: ORDER BY con 2 columnas + LIMIT
--        ✔ el primero es el pedido 1756 (2026-08-31)
select id_pedido, fecha from pedidos 
order by fecha desc, id_pedido desc 
limit 5;



-- [x] 10. Líneas de detalle_pedido con cantidad = 3 y precio_unit de 45.000 o más.
--         Necesitas: WHERE + AND          ✔ 267 filas
select id_pedido, id_producto, cantidad, precio_unit from detalle_pedido
where cantidad = 3 and precio_unit >= 45000;


-- [x] 11. Productos que NO son de la categoría 1, con precio entre 25.000 y 50.000,
--         ordenados por precio.
--         Necesitas: <> , BETWEEN, ORDER BY   ✔ 5 filas, empieza en "Mascarilla de arcilla"
select nombre, id_categoria, precio from productos
where precio between 25000 and 50000
order by precio;


-- [x] 12. Pedidos de mayo de 2026 cuyo canal NO es ni WhatsApp ni Instagram.
--         Necesitas: NOT IN + rango de fechas   ✔ 79 filas
select id_pedido, fecha, canal from pedidos 
where canal not in ('WhatsApp','Instagram') and fecha between '2026-05-01' and '2026-05-31';


-- ============================ NIVEL 3 ================================
-- Solo el enunciado, como en una prueba técnica.

-- [x] 13. Clientes registrados en el primer trimestre de 2025 (ene–mar),
--         ordenados por ciudad y, dentro de cada ciudad, por fecha de registro.
--         ✔ 57 filas
select id_cliente, ciudad, fecha_registro from clientes 
where fecha_registro between '2025-01-01' and '2025-03-31'
order by ciudad, fecha_registro;



-- [p] 14. Pedidos hechos en fin de semana (sábado o domingo).
--         ✔ 508 filas
SELECT id_pedido, fecha, EXTRACT(isodow FROM fecha) AS dia_semana 
FROM pedidos 
WHERE EXTRACT(isodow FROM fecha) IN (6, 7);



-- [s] 15. Una tienda web muestra los productos ordenados por nombre, 4 por página.
--         Trae los productos de la PÁGINA 3.
--         ✔ 4 filas: Mascarilla de arcilla, Sérum…, Tónico…, Vela de lavanda
select nombre from productos 
order by nombre 
limit 4 offset 8;


-- [x] 16. Las 10 líneas de detalle_pedido con mayor valor (cantidad × precio_unit).
--         Muestra ese valor como total_linea. Desempata por id_pedido ascendente.
--         ✔ las dos primeras valen 285000 (pedidos 23 y 62)
select id_pedido, cantidad, precio_unit, cantidad * precio_unit as total_linea 
from detalle_pedido
order by total_linea desc, id_pedido
limit 10;




-- [x] 17. Clientes que se registraron en diciembre (de cualquier año).
--         ✔ 16 filas
select id_cliente, fecha_registro,
       extract(month from fecha_registro) as mes
from clientes
where extract(month from fecha_registro) = '12';



-- [s] 18. Pregunta (responde en un comentario, sin ejecutar nada):
--         Un compañero escribe  WHERE ciudad = NULL  y la consulta no devuelve
--         nada aunque sabe que hay nulos. ¿Por qué? ¿Cómo se corrige?
--
-- Tu respuesta:
-- al poner where ... = null se le está dando como una validación, en cambio se debe poner where ... is null o is not null


