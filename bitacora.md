# Bitácora

## S1 · vie 25 sept · SELECT y WHERE
- Ejercicios: resuelto solo (1-3,5,7-13,16,17), con pista (4,6,14) y con solucion (15,18)
- Lo que más me costó: hay algunas palabras que se me olvidaban, por ejemplo el distinct, por eso no pude hacer solo el ejercicio 4. Tal vez se me dificulta un poco la configuracion de algunas herramientas pero solo es cuestion de revisarlas un tiempo, pero en general me sentí bastante comodo haciendo las consultas y todo lo relacionado a esta sesión.   
- HackerRank: ~9 problemas de Basic Select (85 puntos)
- Horas reales: 2 en la mañana y 2 en la tarde. 

## S2 · lun 28 sept · Agregaciones (GROUP BY, HAVING, CASE)
- Ejercicios: resueltos solo (1-14) · con pista (…) · con solución (15)
- Adaptados de la guía: Algunos ejercicios tenia que revisar la guia pero solo para recordar las palabras o el orden de las sentencias.
- Lo que más me costó: el nivel 3 me costaba mas realizar los ejercicios pero hice la mayoria sin ver pistas aunque me tomara mas tiempo. El ejercicio 11 no recordaba como poner el valor redondeado pero si estaba correcto el resultado. En el ejercicio 12 me costó un poco de tiempo porque me confundí de tabla, despues logré corregir y el 15 fue el que mas me costó, no sabia que MIN y MAX podia usarlo para fechas y confundí los COUNT para esta consulta 
- Lo que aprendí hoy:  usar el conteo para columnas, valores unicos, minimo, maximo y promedio de valores, extraer dia, mes o año de las fechas, aplicar condiciones con HAVING, me parece interesante el uso del CASE para clasificacion.
- HackerRank: Weather Observation Station 4 (1 problema)
- Horas reales: 4 horas
- Nota: sesión del sábado hecha el lunes. Martes en la mañana haremos la sesión del lunes y en la noche la que corresponde a martes para empezar miercoles con su respectiva sesión. 

## S3 · JOINs (INNER, LEFT, anti-join)
- Ejercicios: solos (1-5, 7, 8, 10) · con pista (9, 11) · con solución (6, 12-15) · sin responder (16)
- Lo que más me costó: elegir entre JOIN y LEFT JOIN, qué COUNT usar después de un JOIN, COALESCE y ROUND (no los conocía)
- Decisión: hacer una sesión de refuerzo (3B) antes de seguir
- HackerRank: no hice esta sesion
- Horas reales: 4

## S3B · Refuerzo JOINs y agregados (tablas mini)
- Predicciones (parte A): 6/7 · fallé A2: olvidé que LEFT JOIN conserva a todos con NULL
- Ejercicios: solos (B1-B6, C1, C2) · con pista (C3, C4) · con solución (B7, C5)
- Lo que aprendí: regla JOIN vs LEFT JOIN ("¿necesito ver a los que no tienen pareja?"), COUNT(*) vs COUNT(col) vs COUNT(DISTINCT), COALESCE, ROUND, división entera
- A mejorar: revisar que la consulta tenga todo lo que pide el enunciado; alias que digan lo que la columna es
- HackerRank: no hice esta sesion
- Horas reales: 4

## S4 · Subconsultas y CTEs
- Predicciones: 5/5
- Ejercicios: todos solos (B1-B5, C1-C6)
- Aprendí: subconsulta escalar (comparar con el promedio), IN, NOT EXISTS, CTEs, trampa de NOT IN con NULL
- A mejorar: precisión al explicar (NOT IN), AS en todos los alias
- Horas reales: 4