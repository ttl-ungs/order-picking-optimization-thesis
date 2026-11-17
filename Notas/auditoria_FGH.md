# Auditoría F + G + H (conceptos, estilo y ToDos)

Solo lectura. No se recompiló la tesina. Se leyeron `tesina.tex`, `resumen.tex`, `abstract.tex`, `cap1`–`cap7`, `ap1`, `ap3`–`ap8`, `Guias/context_style_guide.md` y `Notas/pendientes_cap7.md`. De `tesina.log` solo se buscaron referencias o citas indefinidas. No se leyó el repo de código, `zpaper`, `entorno.tex` ni `Referencias/tesina.bib`. De la `.bib` solo se listaron las claves, para contrastarlas con los `\cite`.

Convenciones:
- Las ubicaciones son `archivo.tex:línea`, tomadas de los archivos al momento de la auditoría.
- Severidad: **Crítico** (falso o contradice datos), **Mayor** (omisión o explicación errónea importante), **Menor** (estilo, redundancia, precisión).
- «A+B» marca lo que depende del código y debe contrastarlo el revisor de veracidad y cobertura.
- «E» marca lo que depende de la bibliografía.
- «D» marca lo que depende de los resultados y experimentos.

---

## 1. Resumen ejecutivo: los 10 problemas más graves

| # | Sev. | Problema | Ubicación |
|---|------|----------|-----------|
| 1 | Crítico | El texto dice que con 40 min el monolítico «sigue sin probar el óptimo en esos puntos». Su propio Cuadro 6.4 y el Anexo E muestran que en 6 lotes 5×5 sí lo prueba, a los 32 min. | `cap6.tex:314-317` vs `cap6.tex:331`, `ap5.tex:312-314` (F5) |
| 3 | Mayor | El Cap. 6 dice que la variación entre semillas «es pequeña» y omite que HC se quedó sin solución factible en 2 de 18 escenarios con una de las 5 semillas. Ese dato solo aparece en el Cap. 7 y en el Anexo F. | `cap6.tex:938-943` (F3) |
| 4 | Mayor | La conclusión 1 atribuye a las pruebas funcionales la reducción de los modelos lineales al modelo de referencia; ninguna prueba del Anexo D ni del Cap. 5 la verifica. | `cap7.tex:425-429` (F4) |
| 5 | Mayor | Se explica la brecha de HC (hasta 5,88 %) como «óptimo local» sin evidencia. Contradice el Cap. 4, que dice que un vecino rechazado no indica óptimo local. El estudio de presupuesto muestra que más iteraciones mejoran en algunos escenarios. | `cap6.tex:459-462`, `cap7.tex:83-88, 533-537` vs `cap4.tex:378-380`, `ap8.tex:273-283` (F1) |
| 6 | Mayor | El Cap. 6 dice que los estudios de escala corrieron «con la máquina compartida con otras corridas». Eso contradice el Cap. 5 («de a una, sin procesos pesados en paralelo»), y sobre esos tiempos se calculan los factores 27× y 71×. | `cap6.tex:337-340` vs `cap5.tex:334-337`, `cap6.tex:10-11` (F6) |
| 7 | Mayor | Hay texto provisorio visible en el PDF: Dedicatoria con placeholder, Agradecimientos marcados `TODO: cambiar esto!` y el Anexo A «Diagramas» vacío, con `TODO: completar` / `afuera???`. | `tesina.tex:113, 143, 174`, `ap1.tex` (H) |
| 8 | Mayor | De los 5 ítems de «Comparación con el estado del arte» (`pendientes_cap7.md` §1), 4 siguen sin hacerse y el primero solo está parcial. No hay contraste con MMAS/Dorigo, no se usa a Lesch en la discusión, y el Cap. 2 sigue reseñando solo 4 trabajos. | `cap7.tex:108-135`, `cap2.tex:426-473` (H) |
| 9 | Menor (sistemático) | Las figuras de desempeño usan `greenline` para HC y `redline` para ACO, y `greenline`/`blueline` para «cantidad de lotes». La guía reserva `greenline` solo para ACO y `blueline` para HC. Además, `darkgray` y `darkblue` se usan en diagramas fuera de su uso exclusivo. | 5 figuras de resultados, más los diagramas de `cap3`, `cap4`, `cap5` y `ap5` (G1) |
| 10 | Menor | Terminología inestable: heurística/metaheurística, orden/pedido, «brecha» con dos sentidos, `heredados`/`cuadrilla`/`ola` sin definir. «38 casos» incluye el caso 12, que no tiene pruebas activas. | ver G y H |

---

## 2. Hallazgos por sección

### F. Conceptos

#### F1. Explicación causal de la brecha de HC («óptimo local») sin evidencia: **Mayor**

- **Ubicación:**
  - `cap6.tex:459-462`: «una búsqueda que solo acepta mejoras se detiene en un óptimo local».
  - `cap7.tex:83-88`: «puede quedar hasta un 5,88 % por encima del óptimo … porque se detiene en un óptimo local».
  - `cap7.tex:533-537`: «Son esos óptimos locales los que explican que HC no alcance el óptimo».
- **Qué dice vs. qué es correcto:**
  - El propio Cap. 4 aclara que, como HC genera un único vecino por iteración, «un vecino rechazado no indica que la solución actual sea un óptimo local» (`cap4.tex:378-380`). El Cap. 2 dice lo mismo: confirmar un óptimo local exige inspeccionar toda la vecindad (`cap2.tex:256-262`).
  - HC se detiene por `Max_imp = 30` iteraciones sin mejora, valor por defecto en las pruebas funcionales (`cap5.tex:403`).
  - Parar tras 30 rechazos no demuestra un óptimo local. Puede ser exploración insuficiente. El estudio de presupuesto de HC muestra que más iteraciones mejoran hasta un 0,59 % en el 03 (`ap8.tex:277-281`).
  - La tesina no muestra que los 5 casos fallidos (20, 25c, 25e·1, 25f·1, 25f·2) sean óptimos locales de la vecindad completa.
- **Sugerencia:** presentar la explicación como hipótesis («probablemente por estancamiento…») o respaldarla. Por ejemplo, re-ejecutar esos 5 casos con `Max_imp` mayor o con exploración exhaustiva de la vecindad, y reportar el resultado (D). Alinear la redacción con `cap4.tex:378-380`.

#### F3. El Cap. 6 omite los fallos de HC con otras semillas: **Mayor**

- **Ubicación:** `cap6.tex:938-943`.
- **Qué dice vs. qué es correcto:**
  - Dice que la variación entre semillas «es pequeña» y solo da medianas (0,02 % HC y 0,005 % ACO).
  - Omite que en 2 de 18 escenarios HC no encontró solución factible con una semilla (`ap8.tex:296-299`). También omite el máximo de 0,44 % (`ap8.tex:293-295`).
  - Esa información solo aparece en el Cap. 7 (`cap7.tex:461-466`). Ahí es donde se evalúa la robustez, que es parte del objetivo general.
- **Sugerencia:** agregar en `cap6.tex:938-943` el máximo de cada heurística y la cantidad de ejecuciones sin solución (HC: 2 de 90; ACO: 0 de 90). Remitir a `ap8`.

#### F4. La reducción al modelo de referencia se atribuye a las pruebas funcionales: **Mayor** (parcial)

(Ya resuelto: `cap7` 7.1.1 ya no dice «las pruebas funcionales lo confirman» y la conclusión 1 enumera las tres condiciones.)

- **Ubicación:** `cap7.tex:425-429` (conclusión 1).
- **Qué dice vs. qué es correcto:**
  - Dice «Las pruebas funcionales verifican que respeta las reglas del problema y, cuando todos los *pickers* tienen la misma velocidad, la cadena de frío no restringe y no hay tiempos de servicio, el modelo se reduce al de referencia con los lotes fijos». Gramaticalmente, las pruebas verificarían también la reducción.
  - Ni `cap5.tex` §5.2 ni el Anexo D describen una prueba que compare contra el modelo de referencia. Ver también E-02 y B4.
- **Sugerencia:** separar las dos ideas («la reducción se sigue de la construcción del modelo») o describir la prueba, si existe (C). Precisar «modelo de referencia con lotes fijos».

#### F5. Contradicción texto–cuadro sobre el monolítico a 40 minutos: **Crítico** (falso respecto del propio cuadro; alcance: una oración)

- **Ubicación:** `cap6.tex:314-317` vs `cap6.tex:329-332` (Cuadro 6.4).
- **Qué dice vs. qué es correcto:**
  - El texto dice: «Con un tope de 40 minutos, el monolítico sigue sin probar el óptimo en esos puntos, ni en la instancia del escenario de estrés 04».
  - «Esos puntos» son los tres del párrafo anterior (`cap6.tex:285-287`): 3 lotes 7×7, 4 lotes 6×6 y 6 lotes 5×5.
  - El Cuadro 6.4 informa para 6 lotes 5×5: `32,0 min`, «¿Prueba el óptimo?» **sí**, `0,00 %`. `ap5.tex:312-314` lo confirma («la única instancia adicional que cerró (6 lotes en 5×5) le llevó 32 minutos, 8 veces lo que tardó el Split»).
- **Sugerencia:** «Con 40 minutos el monolítico sigue sin probar el óptimo en 3 lotes 7×7, en 4 lotes 6×6 ni en el estrés 04; solo cierra 6 lotes 5×5, en 32 minutos, unas 8 veces lo que tarda el Split».

#### F6. «Máquina compartida con otras corridas» contradice la metodología: **Mayor**

- **Ubicación:** `cap6.tex:336-340`.
- **Qué dice vs. qué es correcto:**
  - Dice que «estos estudios se ejecutaron con la máquina compartida con otras corridas, por lo que sus tiempos absolutos están inflados».
  - Contradice `cap5.tex:334-337` («las pruebas se ejecutan de a una y sin procesos pesados corriendo en paralelo»), `cap6.tex:10-11` («en las condiciones descriptas en 5.4») y `ap5.tex:149`. Ahí se dice que las mediciones de calibración se tomaron «de a una».
  - Estos tiempos sustentan factores citados en el cuerpo: «hasta 27 veces» y «al menos 71 veces» (`cap6.tex:288-290`).
  - Hay discrepancias internas, no explicadas: el Split en 4 lotes 6×6 tarda 8,4 s (`cap6.tex:290`, derivable de la Fig. 6.2) y 9,5 s en el Cuadro 6.4 (`cap6.tex:330`). En 3 lotes 7×7 hay otra discrepancia análoga (D).
- **Sugerencia:** anunciar el carácter exploratorio de esos estudios antes de dar los factores. Declarar explícitamente en 5.4 que el estudio de escala no cumple las condiciones de la suite final. Si fue una corrida con otras cargas, decirlo con precisión y presentar los factores como orden de magnitud.

#### F7. «Como mucho a la mitad» vs 2,2 veces: **Menor**

- **Ubicación:** `cap6.tex:356-360`.
- **Qué dice vs. qué es correcto:**
  - Dice que el paralelismo reduce el tiempo de la Etapa 1 «como mucho a la mitad (2,2 veces…)». Pero 2,2 veces es una reducción a ~45 %, más que la mitad.
  - Luego razona con «si todo su tiempo fuera el doble». Con 2,2 veces, 15,1 min × 2,2 = 33,2 min, que sigue por debajo de 40, así que la conclusión se sostiene.
- **Sugerencia:** usar «hasta 2,2 veces» y multiplicar por 2,2 (33 min).

#### F8. Convergencia de HC: 03 y 17 vs 03 y 18: **Menor** (marcado `[ ]` en `cap4.tex:741-743`)

- **Ubicación:** `cap6.tex:922-924` y `ap7.tex` (Cuadro de convergencia): HC llega a 200 iteraciones en el 03 y el 17. `ap8.tex:275-277`: en el 03 (todas las semillas) y en el 18 (una).
- **Observación:** vienen de corridas distintas, pero el texto no lo aclara. Con las semillas 1–5 en `ap8`, el 17 no alcanza el tope, mientras que en la corrida consolidada con semilla 1 sí.
- **Sugerencia:** aclarar en una frase que son corridas distintas (código y semillas), o unificar. Relacionado con el (D) de «versión del código» (H).

#### F9. Depósito de feromona de ruta: «MMAS» con depósito unitario: **Menor** (A+B para el código)

- **Ubicación:** `cap4.tex:642-675` vs `cap2.tex:360-366`.
- **Qué dice vs. qué es correcto:**
  - El Cap. 2 define MMAS con `Δτ = 1/C^best`. El Cap. 4 dice «se actualiza según MMAS» pero con depósito constante de una unidad (`cap4.tex:668-671`) y `τ_max = 2/ρ` (`cap4.tex:660`, `ap8.tex`: «Cotas de la feromona de ruta»).
  - Ya no es MMAS estricto: la longitud solo interviene al elegir qué rutas depositan. La diferencia se menciona pero no se llama desviación respecto de la definición del Cap. 2.
- **Sugerencia:** escribir «inspirada en MMAS (cotas `τ_min`/`τ_max` y depósito de la mejor ruta de la iteración y de la histórica), con depósito unitario».

#### F10. Escala del depósito de la feromona de asignación: **Menor** (A+B y D)

- **Ubicación:** `cap4.tex:692-693`, `cap5.tex:420` (`Q = 100`), `ap8.tex` (constantes: `τ^P` inicial 1, mínima 0,01).
- **Observación:**
  - Con objetivos del orden de 10⁵ (`cap6.tex:820-829`, `cap6.tex:883-901`), el depósito `Q/f'` es del orden de 10⁻³ a 10⁻⁴, frente a `τ^P = 1` y evaporación `ρ = 0,15`. La feromona de asignación decae hacia su piso de 0,01 sin que los depósitos pesen.
  - La tesina no aísla el efecto de esta feromona: la ablación de `ap8.tex:358-375` separa colonia, búsqueda local sobre rutas y búsqueda local sobre asignación, no la feromona de asignación.
- **Sugerencia:** verificar con el código y el estudio de feromonas. O bien reportar que la feromona de asignación es casi inerte a esta escala, o bien normalizar `Q`.

#### F11. `λ = 1000` «mayor que lo que puede aumentar f»: **Menor** (A+B)

- **Ubicación:** `cap4.tex:177-181` y `ap8.tex` («Peso de la penalización»).
- **Qué dice vs. qué es correcto:**
  - El anexo define `K = W^c|B| + W^pen·max(W^e,W^t)|N|` y exige `λ > K`. El Cap. 4 afirma, en general, que 1000 es mayor que ese aumento.
  - Con los datos de la tesina: escenario 19 (24 lotes, 624 pedidos, `W^c = 27`) da `K = 27·24 + 624 = 1272`. Escenario 01 (`W^c = 9`, 30 lotes, 750 pedidos): `K = 1020`.
  - Es cierto donde la cadena de frío está activa (escenario 11: `K = 27·6 + 156 = 318`). En 01 y 19 no tiene efecto práctico, porque `T^cold = 10⁹`.
- **Sugerencia:** acotar la afirmación («para las instancias con cadena de frío activa de este trabajo») o escalar `λ` con `K`.

#### F12. TSP/ATSP: uso previo a la definición y rótulo impreciso: **Menor**

- **Ubicación:** `cap2.tex:103-104` (menciona «TSP asimétrico» antes de definir TSP en `cap2.tex:217-218`) y `cap4.tex:264` («variante del TSP»).
- **Qué dice vs. qué es correcto:**
  - El grafo es dirigido y el problema es un camino simple por ubicaciones requeridas con paso por otras. Es una variante asimétrica sobre grafo no completo. Rotularlo «TSP» sin más es impreciso.
  - El Cap. 2 trae la sigla TSP después de su primer uso.
- **Sugerencia:** definir TSP y ATSP en 2.1 (primer uso) y en 4.1.4 decir «variante asimétrica del TSP sobre un grafo no completo, con camino simple».

#### F13. «Aun con las rutas óptimas»: **Menor**

- **Ubicación:** `cap4.tex:612`.
- **Observación:** las rutas son las más cortas encontradas, pulidas heurísticamente, no probadas óptimas. Falta distinción óptimo/mejor encontrada.
- **Sugerencia:** «aun con las rutas más cortas encontradas».

#### F14. Razonamiento del ciclo suelto: **Menor**

- **Ubicación:** `cap3.tex:298-303`.
- **Observación:** dice que un ciclo por ubicaciones no requeridas «solo agrega tiempo de ruta, nunca mejora el objetivo». Con penalización por adelanto, más tiempo puede reducir el objetivo (Sección 2.2, y el propio 3.4). Lo que lo hace inocuo es que la espera voluntaria ya permite retrasar el lote sin gastar cadena de frío. La justificación debería remitir a eso.
- **Sugerencia:** reformular: «agregar un ciclo no ofrece nada que la espera voluntaria no logre ya, y consume cadena de frío».

#### F15. «Brecha» con dos sentidos: **Menor**

- **Ubicación:** `cap5.tex:603-605` (brecha heurística–Split) vs `ap5.tex:138-140` y el pie de la figura `ap5.tex:284` («brecha al momento del corte»: gap informado por SCIP). `cap6.tex:328` ya distingue «Distancia al óptimo» y «*Gap* informado».
- **Sugerencia:** reservar «brecha» para heurística–óptimo y usar «gap informado» para el de SCIP. Aplicarlo también en `ap5.tex`.

#### F16. Heurística vs. metaheurística usadas como sinónimos: **Menor**

- **Ubicación:** resumen, Cap. 1, 2 y 4 hablan de «metaheurísticas». Cap. 5–7 casi siempre dicen «heurísticas» (≈42, 51 y 37 usos). `cap7.tex:75` y `cap7.tex:584` usan «la heurística de los autores» (Coruzzolo) para otra cosa.
- **Sugerencia:** definir una vez («en adelante, heurísticas = HC y ACO») o unificar. Evitar «la heurística de los autores» sin calificar.

#### F17. Términos sin definir o con dos nombres: **Menor**

- `heredados` (`cap5.tex:248, 257`, `cap6.tex:349, 909`, `cap7.tex:439`): nunca se explica de dónde provienen.
- `cuadrilla` (`cap5.tex:214`, `cap6.tex:867`, `cap7`): equivale a «conjunto de pickers».
- `ola` (`cap5.tex:292`, caso 16).
- `pasillo` no se define respecto del grafo (`cap1.tex:32`, `ap4.tex`).
- `nodo final` (`cap3.tex:75, 231`) vs `punto de entrega` (`cap1.tex:36`, `cap3.tex:54`): son lo mismo.
- `operario` (`cap1`, `cap7`) vs `picker` (`cap3` en adelante).
- `órdenes` (`cap3`, `cap4`) vs `pedidos` (`cap5`, `cap6`); `cap1.tex:34` los equipara, pero `cap3.tex:72` no.
- **Sugerencia:** una oración de definición por término en su primer uso y mantener un nombre.

#### F18. Notación sobrecargada: **Menor**

| Símbolo | Significados | Ubicaciones |
|---|---|---|
| `C` | instante de finalización `C_j`; longitud del recorrido `C^k`; unidades `C_n` | `cap2.tex:154`, `cap2.tex:345-350`, `cap3.tex:100` |
| `T_j`, `E_j` | demora y adelanto en el Cap. 2 | `cap2.tex:154-155` |
| `ta_n`, `ea_n` | lo mismo en el Cap. 3 | `cap3.tex:205` |
| `𝒩` | órdenes; nodos candidatos `𝒩_i^k`; vecindad `N(s)` | `cap3.tex:72`, `cap2.tex:311`, `cap2.tex:206` |
| `a` | `a_{bi}` binario (parámetro) y `a(b)` asignación | `cap3.tex:144`, `cap4.tex:42, 94, 262` (mismo capítulo) |
| `q` | flujo `q_{ijb}`; índice de picker; cantidad `q` | `cap3.tex:186`, `cap4.tex:553`, `cap4.tex:649` |
| `u` | `u_{pb}` variable; `u_l` ubicaciones; `u` contador en el pseudocódigo de HC | `cap3.tex:202`, `cap4.tex:649`, `cap4.tex:319` |
| `R` | `R_b`; `R^max`; conjunto `𝓡`; registro `R` (`ap6.tex:99`) | `cap3.tex:499, 396`, `cap4.tex:510` |
| `m` | hormigas; número de restricciones; movimiento | `cap2.tex:341`, `cap2.tex:24`, `cap4.tex:322` |

- **Sugerencia:** agregar una tabla de símbolos al inicio de 3.1 y renombrar las colisiones más fuertes (`a_{bi}` vs `a(b)` en `cap4`).

#### F20. Verificación «en todos los escenarios con los cuatro métodos»: **Menor**

- **Ubicación:** `cap5.tex:261-265`: «se verifica lo mismo, con los cuatro métodos: que se obtenga una solución…».
- **Observación:** en 10 de 19 escenarios ni el monolítico ni el Split obtienen solución, así que ese chequeo no aplica.
- **Sugerencia:** «cuando el método obtiene una solución, se verifica …».

#### F21. Pares/pruebas/instancias mezclados: **Menor**

- **Ubicación:** `cap6.tex:23-24` («60 pares comparables, es decir, instancias»). Pero 60 = 64 pruebas − 4 (`cap5.tex:558-564`), mientras que las instancias son 70/67.
- **Sugerencia:** «60 pares de pruebas, que corresponden a N instancias».

#### F22. Cantidad de casos funcionales: **Menor**

- **Ubicación:** `resumen.tex:16`, `abstract.tex:14`, `cap5.tex:56`, `cap7.tex:437`: «38 casos».
- **Observación:** el caso 12 figura como «Sin pruebas activas» (`ap4.tex:27`), así que los casos con pruebas son 37. Las 64 pruebas sí cuadran: 41 pruebas lettered en 14 casos + 23 casos activos sin letra.
- **Sugerencia:** «38 casos (37 con pruebas activas) que suman 64 pruebas», o eliminar el 12 de la lista.

#### F23. Cifras con redacción imprecisa en Cap. 6 y Anexo F: **Menor** (D)

- `cap6.tex:872`: el monolítico queda «un 5,3 y un 10,5 % peor que ACO». Los valores 5,3 y 10,5 salen de dividir por el objetivo del monolítico (`157.569,7` y `222.183,9`). Respecto de ACO serían 5,6 % y 11,7 %. La columna del Cuadro 6.12 mide `ACO contra Split`, y el monolítico no tiene columna de brecha.
- `cap6.tex:578-581`: «de modo que HC es 5,1 veces más rápido … y ACO 1,4». Las medianas citadas dan `0,300/0,061 = 4,9` y `0,300/0,224 = 1,3`. Probablemente 5,1 y 1,4 son medianas de cocientes.
- `cap6.tex:35-37`: «otras rutas (13), otra asignación (16) o ambas» suma 29 para 21 pares. Hay 8 con ambas, solo implícito.
- `cap6.tex:861-863`: «en el 09 la mejora por menos de un 0,01 %» vs `0,01 %` en el Cuadro 6.12. La diferencia real es 0,0085 %.
- `cap6.tex:169-171`: «1 a 6 lotes», pero la Fig. 6.2 grafica 2, 3, 4 y 6.
- `ap8.tex:421-424`: la variación de ACO sería «un orden de magnitud menor» que la de HC. Las medianas son 0,005 vs 0,02 (4×) y los máximos 0,053 vs 0,44 (8×).
- `ap6.tex:64`: «248 soluciones» en el control del subgrafo, mientras el texto verifica 150 + 9.
- **Sugerencia:** corregir o aclarar cada una.

#### F24. Descripción de las condiciones de los escenarios: **Menor**

- **Ubicación:** `cap5.tex:210-216`: «cada grupo modifica un único aspecto». El 10 cambia ruteo y 4 pickers (`cap5.tex:285`). El 11 cambia grilla 13×13, 4 pickers y cadena de frío (`cap5.tex:286`).
- **Sugerencia:** matizar («parten del perfil base y cambian el aspecto indicado, y en 10 y 11 también…»).

---

### G. Estilo, repeticiones y redundancias

#### G1. Incumplimientos de `Guias/context_style_guide.md`

| Id | Sev. | Regla de la guía | Incumplimiento | Ubicación |
|----|------|------------------|----------------|-----------|
| G1a | Menor | §2: `greenline` uso exclusivo ACO; `blueline` HC; `redline` OPP_v3 bajo estrés y barras «Solver» | HC se dibuja en `greenline` y ACO en `redline` en 5 figuras: Fig. «Brecha» (`cap6.tex:515-534`), «Tiempos de estrés» (`cap6.tex:651-715`), «Calidad contra tiempo» (`cap6.tex:773-805`), `ap7.tex:128-199` y `ap7.tex:289-341`. En los gráficos de memoria y de tiempos funcionales la leyenda confirma HC = `greenline` (`ap7.tex:194, 338`). El comentario `cap6.tex:1126-1129` ya lo señala. | `cap6.tex`, `ap7.tex` |
| G1b | Menor | Ídem | En la Fig. 6.2 las curvas «4 lotes» (`blueline`) y «6 lotes» (`greenline`) usan colores reservados a HC/ACO. También `redline` para «3 lotes». | `cap6.tex:211-230, 265-276` |
| G1c | Menor | §2: `darkgray` solo para la fila de encabezado de tablas | Se usa como relleno en figuras: `cap3.tex:624`, `cap4.tex:56`, `cap5.tex:490`, `ap5.tex:155` (franja) y `ap5.tex:287` (celdas). | ver ubicaciones |
| G1d | Menor | §2: `darkblue` solo para títulos y modelos exactos | Se usa como borde de diagramas de flujo (`cap3.tex:624`, `cap4.tex:56`, `cap5.tex:490`), en el ejemplo de espera (`cap3.tex:778`) y para «Etapa 1» y «3 pickers» (`ap5.tex:95-97, 110-115, 167-186`). `redline` marca las salidas de infactibilidad (`cap3.tex:634`, `cap5.tex:500`) y «Etapa 2»/«4 pickers» en `ap5`. `ap5.tex:287` mezcla tintes de la paleta (`0.25[white,darkblue]`). | ver ubicaciones |
| G1e | Menor | §5: ejes 1 pt, curvas 1,5 pt, puntos de 4 pt, ejes con magnitud y unidad | La Fig. 3.2 (curva del ejemplo) usa ejes de 0,6 pt, curva de 1,2 pt y puntos de 1,8 mm (≈5 pt). Sus ejes son «aporte al objetivo» y `t` sin unidad (`cap3.tex:779-800`). Los diagramas de flujo usan 0,7–0,8 pt. | `cap3.tex:779-797` |
| G1f | Menor | §5: gráficos con `\placefigure[force][fig:id]{Título}` | Solo `cap6`, `ap5` y `ap7` usan esa forma. `cap3.tex:620, 775`, `cap4.tex:51, 310, 454`, `cap5.tex:486` y `ap6.tex:95` usan `\startplacefigure[title=, reference=]`, equivalente pero inconsistente. | ver ubicaciones |
| G1g | Menor | §6: destacar el concepto clave en negrita al inicio de cada ítem (recomendado) | Ítems sin negrita: `cap1.tex:21-29, 151-167`; `cap7.tex:343-357, 389-403, 419-454, 495-524, 533-567, 576-611`. En 7.2 (`cap7.tex:239-308`) las negritas se quitaron a propósito (`pendientes_cap7.md:75`). | ver ubicaciones |
| G1h | Menor | Citas | Comillas tipográficas “acciones de demonio” (`cap2.tex:370`) en lugar de `\quotation{}` (usado en `cap5.tex:204`). | `cap2.tex:370` |
| G1i | Menor | La guía misma | Está desactualizada: nombra «OPP_v3 / SCIP» (guía:16, 18) y no asigna color a Split, Monolítico, HC y ACO como se usan. Se copió a mano del repo de código. | `Guias/context_style_guide.md:3, 16, 18` |
| — | — | §4 tablas | **Cumple**: las 28 tablas (`\bTABLE`) usan `split`, `align=middle`, `frame=on`, `width=fit/broad`, encabezado `darkgray` en negrita y `\bTR`/`\bTD`. | — |
| — | — | Estructura de archivos | **Cumple**: todos los capítulos y anexos empiezan con `\startchapter` sin cabecera ni `\starttext`, como indica la guía (§Copia, línea 5). | — |
| — | — | §1, §3, §8 (papel, márgenes, fuente, estilo de secciones) | **No verificado**: esas reglas viven en `entorno.tex`, que no estaba en la lista de lectura. | — |

#### G2. Repeticiones entre capítulos (dos ubicaciones por cada una)

| # | Contenido repetido | Ubicación 1 | Ubicación 2 | Sugerencia |
|---|--------------------|-------------|-------------|------------|
| R1 | Caso 30a: «SCIP no terminó en 600 s con los lotes vacíos y terminó en 0,13 s sin ellos» (además se menciona 30a en `cap7.tex:191-194`) | `cap6.tex:51-52` | `cap7.tex:500-502` | Dejar la cifra en 6.1.1 y que 7.5 remita a ella |
| R2 | HC 17 min y ACO 32 min en el 100×100 | `cap6.tex:723-725` | `cap7.tex:253-254` | Dejarlo en 7.2.2 con remisión a `sec:res_tiempos` |
| R3 | Tiempos de ACO (14 s a 6 min) y HC (< 5 s) | `cap6.tex:720-722` | `cap7.tex:395, 399` | Aceptable por diseño (recomendaciones), con remisión |
| R4 | «Test responde si una instancia se resuelve; un estudio recorre una familia», casi textual | `cap5.tex:149-152` | `ap5.tex:5-8` | Dejar en `ap5` o en 5.3.1, no en ambos |
| R5 | Fechas de entrega entre 60 % y 140 % de una estimación | `cap5.tex:240` | `ap5.tex:16-19` | Remitir |
| R6 | Cómo y por qué `W^c = 27` (y 9 en 01–03) | `cap5.tex:166-169, 251-253` | `ap5.tex:127-131`, `cap7.tex:128-129`, `ap3.tex:71`, `cap6.tex:316` | Explicar en 5.3.1 y remitir en el resto |
| R7 | Etapa 1 paralela: factor 2,2 / 1,9 | `cap5.tex:339-340, 355-361` | `cap6.tex:354-358`, `ap5.tex:216, 262-267` | Un solo lugar con la medición (Anexo E) |
| R8 | Reducción al modelo de referencia con lotes fijos (condiciones) | `cap3.tex:26-30` | `cap7.tex:24-27, 421-424` | Mantener una versión y remitir (hoy son tres, con condiciones distintas, ver F4) |
| R9 | Lista de verificaciones de datos de entrada (capacidad, un solo lote, velocidades > 0) | `cap3.tex:598-603` | `cap4.tex:216-220`, `cap5.tex:98-104` | Ya señalado en `cap3.tex:861-862`: dejar en 3.3.3 y remitir |
| R10 | «Cómo cumplen las heurísticas las restricciones» | `cap4.tex:135-157` (Cuadro 4.1) | `cap5.tex:447-454` | 5.5 ya remite al cuadro; acortar el resumen |
| R11 | «El monolítico no termina ninguno de los 19 escenarios en 40 min» | `cap6.tex:346` | `cap7.tex:38-39`, `cap7.tex:430-431` | Dejar el dato en 6.1.3 |
| R12 | Rango «46 a 58 %» del Split a igual tiempo | `cap6.tex:867-868, 989` | `cap7.tex:448-449` | Aceptable (síntesis y conclusión) |
| R13 | Recomendación de uso (Split hasta 6 lotes en 15×15; ACO; HC) | `resumen.tex:21-23`, `abstract.tex:19-21` | `cap6.tex:968-982`, `cap7.tex:389-403` | Por diseño, pero cuatro versiones; unificar la formulación (ver F19) |

El pendiente «se sacaron las repeticiones del capítulo (15/11)» (`pendientes_cap7.md:9`) está **parcial**: quedan R1, R2, R3 y R8 dentro de Cap. 6–7.

#### G3. Resumen vs. abstract

No hay diferencias de contenido ni de cifras. Coinciden 38 casos, 19 escenarios, 9 de 19, 0,04 %, 0,21 %, 1,5 y 53 veces, 6 lotes y 15×15. Diferencias y observaciones:

1. «Optimidad» (`resumen.tex:4`) frente a «optimality» (`abstract.tex:4`). El resto de la tesina usa «optimalidad» (`cap2.tex:134`, `cap4`, `cap5`, `cap6`). Corregir.
2. `resumen.tex:10`: «este modelo se optimiza mediante su descomposición» frente a «this model is decomposed» (`abstract.tex:9`). «Se optimiza» es ambiguo (¿se mejora el modelo o su resolución?). Cambiar a «se descompone».
3. Se saltea el segundo aporte de `cap1.tex:128-130` (verificación independiente de las 150 soluciones) en ambos. Es uno de los tres aportes, y no aparece en resumen ni en abstract.
4. Ninguno de los dos incluye palabras clave / *keywords*. Puede ser requisito institucional (no verificado).
5. Revisión del inglés (pendiente `[ ]` oculto en `pendientes_cap7.md:69`):
   - «in practical times» → «within practical time frames» (`abstract.tex:11`).
   - «with median times 1.5 and 53 times shorter» → «with median running times 1.5 and 53 times shorter» (`abstract.tex:17-18`).
   - Se usa ortografía británica (*centres*, *minimise*). Es consistente con los nombres propios; mantenerla.
   - Falta un «respectively» claro en la oración de los 0,04 % y 0,21 % (el orden ACO/HC está implícito).
6. Mismo problema de salvedad en ambos (F2): «en todas las instancias factibles».

#### G4. Español, idioma y formato

| Sev. | Ubicación | Problema | Sugerencia |
|------|-----------|----------|------------|
| Menor | `resumen.tex:4` | «optimidad» no es la forma usada en la tesina | «optimalidad» |
| Menor | `tesina.tex:96-98` | Cita atribuida a «Lao Tse». Atribución y grafía vulnerables, sin fuente en la bibliografía. | Citar fuente o grafiar «Lao Tsé/Laozi» |
| Menor | `cap5.tex:149, 619`, `ap5.tex:5` | «test» como anglicismo («el test 01»), mientras el resto dice caso, prueba o escenario | «prueba»/«escenario» |
| Menor | `resumen.tex:9, 12`, `ap5.tex:68, 144, 12` | Primera persona plural («llamamos», «consideramos», «podemos») frente al impersonal del resto | Pasar a «se denomina», «se considera». Reescribir el título de sección `ap5.tex:144` sin pregunta ni «podemos» |
| Menor | `cap6.tex:75, 928` | Registro coloquial: «ya que se ve que», «mejorarla un poco» | Reformular |
| Menor | `cap6.tex:961` | «Los cuatro modelos» para lineales y heurísticas | «Los cuatro métodos» |
| Menor | `cap7.tex:437-440` | «calibrado para exigir a los modelos sin las degeneraciones de los escenarios heredados»: poco claro | Reescribir y definir «heredados» (F17) |
| Menor | `resumen.tex:19`, resto (`~\%`), `cap1.tex:12`, `cap5.tex:240`, `ap5.tex:17` | Tres formas de espaciar el porcentaje: `5\,\%`, `5~\%` y `5\%` | Unificar con `~\%` |
| Menor | `ap5.tex:67-69` | Alternancia de sujeto («Por este motivo, consideramos que…») y espacios finales | Revisar |

Tiempos verbales: el Cap. 5 usa pasado para lo ya hecho («se verificó», «se exploró») y presente para el método. El Cap. 6 alterna presente y pasado en la misma sección («el Split termina 9» y «se ejecutaron»). Es tolerable pero conviene fijar una regla (presente para resultados, pasado para procedimiento). No hay mezcla de idiomas más allá de anglicismos técnicos en cursiva (*picker*, *gap*, *branching*, *best-first*, *timeout*). `picker` sin cursiva en `cap3.tex:40`, `cap4.tex:41, 621, 623` y `cap6.tex:870` rompe la convención de `{\em picker}` del resto.

#### G5. Pasajes densos, ambiguos o con saltos lógicos

| Sev. | Ubicación | Observación |
|------|-----------|-------------|
| Menor | `cap7.tex:63-88` (26 líneas), `cap7.tex:44-61` (18 líneas) | Dos párrafos que mezclan la comparación con la heurística de Coruzzolo, resultados propios, límites de HC y ILS. Conviene partirlos (comparación de enfoque / calidad / ILS) |
| Menor | `cap6.tex:460-472` | Un párrafo con 5 ideas (óptimo local, 2-opt sin vecinos, 3 escenarios, Fig. 6.5, comparación con óptimo) |
| Menor | `cap5.tex:187-194`, `cap5.tex:372-382` | Explicaciones largas de por qué los tiempos de la calibración no son los de la suite y de qué tiempo se compara |
| Menor | `cap6.tex:859-877` | Un solo párrafo con todo el experimento de igual tiempo con ACO (15 de 19, 7 escenarios, 4 sin solución, monolítico, excesos). Un cuadro ya existe; pasar los casos a viñetas |
| Menor | `cap3.tex:381-404` | Párrafo de 24 líneas con la construcción de `M^seq`; la fórmula omite el redondeo y el `+1` aclarado en el texto (`cap3.tex:389-390`) |
| Menor | `cap5.tex:56-66` | «Se definieron 38 casos… 64 pruebas… 63»: la jerarquía caso/prueba/instancia (38/64/70) se entiende recién en `cap5.tex:119-125`; presentarla en una tabla |

---

### G6. Referencias cruzadas y citas

**Resultado de la comprobación mecánica (sobre todos los `.tex` incluidos; `plantilla.tex` excluido):**

- `\in[...]`: 442 usos, 192 etiquetas definidas, **0 referencias rotas**. Hay 10 figuras que parecen indefinidas con un análisis ingenuo (`fig:res_lineales_dispersion`, `fig:res_lineales_escala`, `fig:res_brecha`, `fig:res_estres_tiempos`, `fig:res_calidad_tiempo`, `fig:relev_velocidades`, `fig:relev_calibracion`, `fig:relev_frontera`, `fig:res_funcional_tiempos`, `fig:res_memoria`). Están definidas con `\placefigure[force][fig:id]` y resuelven. No hay etiquetas duplicadas.
- `\cite[...]`: 18 claves distintas usadas, las 18 de `Referencias/tesina.bib` (sin claves huérfanas ni sin definir). Contraste de contenido contra las fuentes: pendiente (E).
- `\ac{mip}`, `\ac{hc}`, `\ac{aco}`: 19, 43 y 46 usos. Que las tres siglas estén definidas en `entorno.tex`: **no verificado** (no se leyó).
- `tesina.log`: no contiene ninguna línea con `undefined`, `unknown`, `warning`, `missing` ni `not found`. Pero ese log es del 15/11 23:04 y `resumen.tex`, `abstract.tex`, `cap3.tex`, `cap4.tex` y `cap7.tex` se modificaron el 16/11 20:51, **después** del log. El log no sirve para validar esos cinco archivos, y el PDF podría no reflejarlos. Hay que recompilar para cerrar este punto.
- Números de sección o figura escritos a mano dentro del texto (fuera de comentarios): **ninguno**. Cuadro/Figura/Sección/Capítulo/Anexo siempre salen por `\in`.
- Etiquetas definidas y no usadas (inocuas): `Anexo_Diagramas`, `sec:software`, `sec:organizacion`, `sec:beneficios`, `sec:aportes_lista`, `sec:split_etapa2`, `sec:anexo_sla`, `sec:anexo_mseq`, `sec:calib_hc_constantes`, `sec:calib_aco_constantes` y varias `eq:`.
- Nombres de etiqueta desactualizados: `sec:caracteristicas_formulacion` ahora es «7.2.1 De los modelos lineales», aunque `cap3.tex:15-16` aún la presenta correctamente.
- Precisión del destino (muestra, no exhaustiva): `cap6.tex:728` remite a `sec:heur_limitaciones` para la lentitud de ACO en 14×14. El destino exacto es `sec:aco_limitaciones` (Menor). El resto de los destinos revisados es correcto.
- Forma «Ecuación~\in[...]» vs «(\in[...])»: ambas aparecen; es estilo, no error.

---

### H. ToDos

#### H1. Estado de `Notas/pendientes_cap7.md`

Estados: Resuelto / Parcial / Pendiente / No verificado. «Evidencia» son líneas de los `.tex`.

**Cabecera «Ya resuelto en esta rama»**

| Ítem | Estado | Evidencia |
|------|--------|-----------|
| 7.1.1 escrita y verificada contra Coruzzolo et al. | Escrita: sí (`cap7.tex:16-105`). Verificación contra el paper: **no verificado** | Depende de E |
| Se sacaron las repeticiones del capítulo (15/11) | **Parcial** | Quedan R1, R2, R3 y R8 (ver G2) |

**§1 Comparación con el estado del arte (7.1.2)**

| Ítem | Estado | Evidencia |
|------|--------|-----------|
| Contrastar HC con la literatura (Talbi, Hoos y Stützle) | **Parcial** | `cap7.tex:83-88` relaciona HC con óptimos locales e ILS y remite a `sec:marco_hc`; `cap7.tex:533-537` lo usa en trabajo futuro. No hay `\cite` de `talbi2009metaheuristics` ni `hoos2015sls` en `cap7.tex`. El dato de 2-opt sin vecinos (26–48 %) está en `cap6.tex:463-469`, no en la discusión. Además, la explicación causal tiene el problema F1 |
| Contrastar ACO con la literatura (MMAS, Dorigo y Stützle) | **Pendiente** | `cap7.tex` no cita `stutzle2000mmas` ni `dorigo2004aco`; los resultados de ACO se discuten sin contraste (`cap7.tex:394-397, 457-460`) |
| Usar a Lesch et al. (decisiones conjuntas ↔ loteo como dato) | **Pendiente** | `lesch2023optimizing` solo aparece en `cap2.tex:452-456` y `ap8.tex:390-391` |
| Descomposición: comparar el Split con otras de la literatura | **Pendiente** | `cap2.tex` no cita descomposiciones; `cap7.tex:44-61` compara solo con el modelo simplificado de Coruzzolo |
| (D) Ampliar «Trabajos relacionados» con de Koster et al., Scholz et al., van Gils et al. | **Pendiente** | `cap2.tex:426-473` sigue con 4 trabajos (Coruzzolo, Chen, Lesch, Alaya); ninguno de los tres candidatos está en las 18 claves de la `.bib` |

**§4 Conclusión justificada (7.4)**

| Ítem | Estado | Evidencia |
|------|--------|-----------|
| Actualizar resumen y escribir abstract; «Revisar el inglés» | **Parcial** | Resumen y abstract existen y coinciden (G3). El inglés aún no se revisó: ver G3 §5 |

Inconsistencias dentro del propio pendientes: `pendientes_cap7.md:45` dice «Sección 7.4» para el trabajo futuro, pero la línea 28 y el encabezado de §3 dicen 7.5. El texto real tiene 7.4 Conclusiones y 7.5 Trabajo futuro.

#### H2. Estado de los pendientes que estaban embebidos en comentarios `.tex` (solo los abiertos)

Las guías de trabajo de los capítulos se borraron el 16/11. Lo que seguía abierto pasó a `Notas/pendientes_cap7.md` §6, salvo la versión de las heurísticas (D), la convergencia de HC 03/17 vs 03/18 y los dos ítems de `cap7` (qué limita a la Etapa 1; estanterías), que quedaron sin registrar. Las referencias de línea de esta tabla corresponden a las guías borradas.

| Archivo | Pendiente | Estado | Evidencia |
|---------|-----------|--------|-----------|
| `cap1.tex:206-209` | `[ ]` 1.4: sumar el Anexo A si se completa | Pendiente | `ap1.tex` vacío; `cap1.tex:186-188` lista 6 anexos y omite el A |
| `cap2.tex:503-504` | `[ ]` unificar `resolvedor`/`solver`, `locación`/`ubicación`, `completitud`/`finalización` | Parcial | «locación» no aparece; «completitud» solo en «chequeo de completitud» (`cap4.tex:277`, `cap7.tex:286`, sentido distinto). «solver» queda dos veces (`cap5.tex:34, 37`) frente a ≈20 «resolvedor» |
| `cap3.tex:861-862` | `[ ]` validación de datos: que remitan a 3.3.3 | Pendiente | `cap4.tex:216-220` y `cap5.tex:98-104` la vuelven a listar (R9) |
| `cap3.tex:863-864` | `[ ]` paralelismo de la Etapa 1 en 3.3.1 y cuadro | Parcial | `cap3.tex:490-491` lo menciona; el Cuadro 3.2 solo dice «independientes entre sí» |
| `cap4.tex:736-740` | (D) versión del código de las heurísticas | **No verificado** (requiere repo) | Ni `cap5.tex:425-432` ni el Cap. 6 declaran la versión del código. Ver F8 |
| `cap4.tex:741-743` | `[ ]` convergencia HC 03/17 vs 03/18 | Pendiente | F8 |
| `cap5.tex:647-649` | `[ ]` controles de modelos exactos (Split vs mono, 9 soluciones, reducción a v4) | **Parcial** | `cap5.tex:528-536` y `cap6.tex:395-396` cubren los dos primeros. La reducción a v4 no está (ver F4) |
| `cap6.tex:1011-1022` | (D) versión de las heurísticas | **No verificado** | Igual que arriba |
| `cap6.tex:1024-1027` | `[ ]` no usar `analysis/output/report.md` | No verificado (repo) | — |
| `cap6.tex:1126-1129` | `[ ]` unificar colores de figuras | **Pendiente** | G1a, G1b |
| `cap7.tex:671-680` | trabajo futuro: «qué limita a la Etapa 1» | Parcial | `cap7.tex:503-512` propone clausura métrica sin decir que el mecanismo no se identificó (`ap5.tex:245-249`) |
| `cap7.tex:678-680` | «depósitos con estanterías y datos reales» | Parcial | Datos reales sí (`cap7.tex:609-611`); estanterías no |

#### H3. Marcadores encontrados en los `.tex`

Búsqueda de `TODO`, `ToDo`, `\todo`, `XXX`, `FIXME`, `??`, `pendiente`, `placeholder`, `lorem`, `completar`, `quizás`, `ojo`, etc. No hay `\todo`, `ToDo`, `XXX`, `FIXME`, `lorem` ni `??` (la única secuencia `???` está en `ap1.tex:4`). «pendiente» aparece como sustantivo técnico en `cap4` y `ap8` («ubicaciones pendientes»), no como marcador.

**Texto provisorio que sale en el PDF**

| Ubicación | Contenido | Observación |
|-----------|-----------|-------------|
| `tesina.tex:143` | Dedicatoria: `Para / Dedicada a / Para mi ...` | Placeholder visible |
| `tesina.tex:113-118` | `% TODO: cambiar esto!` sobre Agradecimientos | El texto se imprime; el TODO indica que no es definitivo |
| `ap1.tex:1-6` | Anexo A «Diagramas» sin contenido, con `% TODO: completar` y `% afuera???` | Capítulo vacío incluido en `tesina.tex:174`; `Anexo_Diagramas` no se referencia; `cap1.tex:186-188` lo omite |
| `tesina.tex:20` | `{Licenciadas en Sistemas} % Cambiar según corresponda (a/o/os/as)` | Verificar la forma final |

**Marcadores en comentarios (no salen en el PDF)**

| Ubicación | Marcador |
|-----------|----------|
| `ap1.tex:3-4` | `TODO: completar` / `afuera???` |
| `ap5.tex:12` | `TODO: Tengo que verificar ese porcentaje. No es claro.` (se refiere al 60 %–140 % de `ap5.tex:16-19` y `cap5.tex:240`) |
| `ap5.tex:118-119` | `TODO: ojo acá--no es que no miramos la demora, aclarar eso…` (el texto siguiente, `ap5.tex:120-123`, ya aclara que W^c = 9 hacía actuar adelanto y demora) |
| `ap6.tex:151-152` | `TODO: no estoy segura de esto en general, podemos ver si queda o no. quizas ya es mucho ruido` (al final de «Pseudocódigo») |
| `tesina.tex:101-103` | Comentario con una cita alternativa («me gustó jaja») |

---

## 3. Para los demás revisores (no resuelto aquí)

- **A+B:** `λ = 1000` (F11); depósito unitario tipo MMAS y `τ_max = 2/ρ` (F9); magnitud de `Q` frente a `f'` (F10); 20 construcciones aleatorias, 10 intentos, 30 retrocesos y 2.000.000 de expansiones (`cap4.tex:345`, `cap4.tex:532`, `ap8.tex`); `M^seq` mínimo 500 y la nota de implementación del subgrafo (`cap3.tex:317-320, 421-423`); «248 soluciones» (`ap6.tex:64`); que el verificador se corra sobre 150 + 9 soluciones.
- **C:** existe una prueba de reducción al modelo de referencia (F4); nombres de las pruebas 24b, 30a, 36c, 37a; el caso 12 sin pruebas; 64 y 63 pruebas.
- **D:** F1 (los 5 casos de HC), F6, F8, F23 y todos los números de tablas del Cap. 6 (aquí solo se recalcularon los internamente consistentes: medianas de los 9 escenarios y estadísticos de brecha, que cuadran).
- **E:** los 207,97 / 169,20 / 38,77 minutos y el 57 % de Coruzzolo (`cap7.tex:90-99`); «Alaya y Solnon» frente a «Alaya et al.» (`ap8.tex:390` vs `cap2.tex:456`: el trabajo tiene tres autores, a confirmar); la fórmula de flujo de Gavish–Graves (`cap2.tex:83-100`), cuyo sentido es el opuesto al de `cap3.tex:288-296` (la tesina lo presenta como «variante»); «50–75 % del costo operativo» (`cap1.tex:11-12`); la atribución de or-opt a Or 1976 vía `babin2007oropt` (`ap8.tex:123-127`).

## 4. Qué no se pudo verificar

- Todo lo que depende del código o de `results/` (marcado A+B / C / D).
- Todo lo que depende de los PDFs de `zpaper` (E).
- `entorno.tex`: estilo global de la guía (§1, §3, §8), definición de siglas `mip`/`hc`/`aco`, glosario y estilo de bibliografía.
- `Referencias/tesina.bib`: contenido; solo se listaron las claves.
- `tesina.pdf`: no se inspeccionó (ni la presencia de `??` ni la numeración visible), por la regla de no recompilar y por estar desactualizado respecto de cinco `.tex`.
- Compilación: no se recompiló. `tesina.log` es anterior a las últimas modificaciones de `resumen`, `abstract`, `cap3`, `cap4` y `cap7`, así que no certifica la ausencia de advertencias en esos archivos.
- Los cálculos aritméticos reportados (medianas, brechas, factores, `K` de F11) se hicieron a mano sobre los datos impresos en la tesina. No se contrastaron contra los CSV.
