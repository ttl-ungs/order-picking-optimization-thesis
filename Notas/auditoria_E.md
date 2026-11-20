# Auditoría — Sección E: relación con la bibliografía

Alcance: solo la sección E de `Notas/prompt_auditoria_tesina.md`. Solo lectura: no se modificó ningún
archivo salvo este informe y no se ejecutaron tests ni experimentos.

Leído: `logistics-07-00061 (1).pdf` completo (18 páginas); `Capitulos/cap1.tex`, `cap2.tex` y `cap7.tex`
completos; `Referencias/tesina.bib`; los fragmentos de `cap3.tex` (líneas 1–40, 430–460 y 680–720), de
`cap4.tex` (255–280) y de `Apendices/ap8.tex` (20–45, 90–110 y 385–400) que citan bibliografía o
describen el modelo de referencia. Del código (rama `main`, leída con `git show`/`git grep`), solo los
comentarios que citan a Coruzzolo et al.

Convención de páginas: "p. N" es la página del PDF. Entre paréntesis va la página de la revista o del
libro cuando difiere.

---

## 1. Hallazgos

### Crítico

**E-1. El barrido de sensibilidad de ACO no cubre los valores de la literatura que dice cubrir**
- Ubicación: `Apendices/ap8.tex:392-394` (y `Capitulos/cap2.tex:455-457`, que remite a esa sección).
- Evidencia:
  - Alaya, Solnon y Ghédira, p. 5, Tabla 1: α = 1, β ∈ {4, 8}, ρ ∈ {0,1; 0,01}.
  - Lesch et al., p. 16 (p. 18620): α = 1,0, β = 2,0, ρ = 0,02.
- Qué dice la tesina: "Los rangos abarcan los valores por defecto y los que reportan Alaya y Solnon y
  Lesch et al.", con α ∈ {0,5; 1; 2}, β ∈ {1; 2,5; 4} y ρ ∈ {0,05; 0,15; 0,30}.
- Qué es lo correcto: ρ = 0,01 (Alaya) y ρ = 0,02 (Lesch) quedan por debajo del mínimo probado (0,05).
  β = 8 (Alaya, variante m-ACO₂) queda por encima del máximo (4). Solo α queda cubierto. La afirmación
  es falsa para ρ, y para β en el caso de Alaya.
- Sugerencia: escribir "los rangos abarcan los valores por defecto y se acercan a los que reportan…",
  e indicar que los valores de evaporación de la literatura (0,01–0,02) son más bajos que los
  probados. Otra opción es agregar ρ = 0,02 al barrido. Como Alaya et al. calibran para la mochila
  multiobjetivo, que no usa una heurística de distancia, conviene aclarar también por qué esos valores
  sirven como referencia (ver E-12).

### Mayor

**E-2. La restricción de "camino simple" se presenta como heredada del modelo de referencia, pero allí no restringe**
- Ubicación: `Capitulos/cap7.tex:165-166`; también `cap2.tex:431-432` ("pasa a lo sumo una vez por cada
  ubicación").
- Evidencia:
  - Coruzzolo et al., p. 5: d_ij es la distancia entre dos ubicaciones cualesquiera i, j ∈ V.
  - p. 13: se construyó una matriz con las distancias entre todas las ubicaciones del almacén.
  - p. 3: el ruteo "can also be formulated as a classic TSP if the minimum distance between each pair
    of storage locations is previously calculated".
  - p. 7, ecuaciones (14)–(15): cada ubicación tiene a lo sumo un arco de entrada y uno de salida.
- Qué dice la tesina: que el camino simple "es una característica que se hereda del modelo de
  referencia", y a continuación describe instancias físicamente posibles que la formulación declara
  infactibles (pasillos sin salida).
- Qué es lo correcto: formalmente la restricción es la misma, pero en el paper se aplica sobre una
  matriz completa de distancias mínimas. Cada arco ya representa un camino mínimo por el almacén, así
  que pasar una sola vez por cada ubicación no impide volver por un pasillo. En la tesina el grafo es
  de adyacencias (`cap1.tex:70-74`). Ahí la misma restricción sí limita, y produce las
  infactibilidades descritas. La limitación no viene del modelo de referencia sino de combinar su
  restricción con un grafo disperso.
- Sugerencia: agregar en `cap7.tex:165` una oración como: "En Coruzzolo et al. las distancias forman
  una matriz completa de caminos mínimos (p. 13), sobre la que esta restricción no limita. En esta
  tesina el grafo es de adyacencias, y por eso la restricción excluye rutas posibles". Conviene
  mencionar la misma diferencia en `cap2.tex:430-432` y en la lista de supuestos de `cap3.tex`.

**E-3. "Flujo de tipo Gavish y Graves": el paper no lo dice, y su ecuación (16) tal como está impresa no elimina subtours**
- Ubicación: `Capitulos/cap2.tex:432-434`; `cap3.tex:24-26`.
- Evidencia:
  - Coruzzolo et al., p. 7, ecuación (12): f_ijh ≤ Cap_Vehicle · z_ijh.
  - Ecuación (16): Σ_g f_gih = Σ_j f_ijh ≥ a_ni · y_nh.
  - p. 8: "Equations (16) and (17) prevent the formation of cycles". El paper no nombra a Gavish y
    Graves.
  - Roberti y Toth, p. 6 (p. 117), ecuación (11): en GG cada nodo distinto del origen agrega una unidad
    de flujo (Σ_j g_ij − Σ_j g_ji = 1).
- Qué dice la tesina: que el paper elimina los subtours "con un flujo de tipo Gavish y Graves acotado
  por la capacidad del carro".
- Qué es lo correcto: la cota por capacidad (12) sí está en el paper. Pero la ecuación (16) impresa
  iguala el flujo que entra y el que sale de cada nodo. No obliga a que el flujo crezca o se consuma en
  cada ubicación, que es lo que impide los ciclos en GG. Un subtour con flujo circulante constante
  cumple (16). Llamarlo "de tipo GG" es una interpretación razonable de la intención de los autores,
  pero no describe lo que está escrito. Esto pesa además sobre la afirmación de que los modelos de la
  tesina "se reducen al de referencia" (E-6): en rigor, se reducen a una versión corregida.
- Sugerencia: escribir "con restricciones de flujo acotadas por la capacidad del carro, cuya intención
  es eliminar los subtours (ec. 12 y 16 del original)". Agregar una nota al pie: "tal como está impresa,
  la ecuación (16) solo conserva el flujo; en esta tesina se usa el balance de GG
  (Sección~\in[sec:marco_mip])".

**E-4. Posicionamiento: el paper sí resolvió sus modelos en un problema chico y afirma que su ILS encuentra "the minimum solution"**
- Ubicación: `Capitulos/cap2.tex:464-468`; `cap7.tex:34-36`, `cap7.tex:63-66` y `cap7.tex:479-480`.
- Evidencia:
  - Coruzzolo et al., p. 1 (resumen): "As both models were too complex to test, the earliest due date
    constructive heuristic was developed"; "the iterated local search multiple perturbation algorithms
    could successfully identify the minimum solution".
  - p. 10: "were not solvable within acceptable time limits".
  - p. 12, §5.1: "This study designed a simple problem that could be solved within acceptable time
    limits".
  - p. 16: "Both proposed models could solve minor problems with acceptable computational times".
  - p. 15: el "best" de la ILS es el mejor entre sus propias heurísticas ("generated the best solution
    by four and one times").
- Qué dice la tesina: "sus dos modelos lineales resultaron demasiado complejos para resolverse sobre el
  caso de estudio", "no pudieron resolver sobre su caso de estudio ninguno de sus dos modelos" y que
  resuelven "sin poder contrastar sus resultados con el óptimo".
- Qué es lo correcto: lo dicho sobre el caso de estudio es fiel. Pero la tesina omite que los autores
  resolvieron un problema chico con los modelos, y que su resumen y sus conclusiones dicen que la ILS
  encuentra "the minimum solution". Un lector del paper puede tomar esa frase como una afirmación de
  optimalidad que contradice a la tesina. En el paper, "minimum" significa el mejor valor entre las
  variantes heurísticas, no un óptimo probado. El aporte central de la tesina (medir contra un óptimo
  probado) depende de esta distinción, así que conviene hacerla explícita.
- Sugerencia: en `cap2.tex:466-468`, agregar: "Los modelos solo se resolvieron sobre un problema
  pequeño de prueba (§5.1). Sobre el caso real, la mejor solución que informan (“minimum solution”) es
  la mejor entre sus variantes heurísticas, sin una cota ni un óptimo con que contrastarla".

### Menor

**E-5. Los 57 % se presentan sin las salvedades del propio paper**
- Ubicación: `Capitulos/cap2.tex:443-444`; `cap7.tex:93-99`.
- Evidencia: Coruzzolo et al.:
  - p. 14–15, Tablas 2–4: el "Picking Total Time" es la suma del recorrido y del setup
    (160,47 + 201,00 = 361,47; 121,69 + 31,80 = 153,49). El tiempo de búsqueda y recolección se excluye
    por ser constante (p. 14).
  - p. 13: la comparación supone "only one operator".
  - p. 14–15, Tabla 5 y §5.3: el ahorro existe solo si el clasificado posterior tarda menos de
    20,98 min por lote o 2,54 min por pedido.
- Qué dice la tesina: "reduce el tiempo de picking en un 57 % respecto de preparar los pedidos de a
  uno". El desglose de `cap7.tex:96-97` (169,20 + 38,77 = 207,97) es correcto, y verifiqué que suma.
- Qué es lo correcto: el 57 % es la reducción de recorrido más setup, con un solo operario, antes de
  descontar el tiempo de clasificado, que lo condiciona.
- Sugerencia: en `cap2.tex:444`, agregar "(recorrido y preparación del recorrido, sin contar el
  clasificado posterior de los lotes, del que depende que el ahorro se mantenga)".

**E-6. Las condiciones para que los modelos "se reduzcan al de referencia" están incompletas**
- Ubicación: `Capitulos/cap7.tex:24-27`, `cap7.tex:429-432` y `cap3.tex:26-29`.
- Evidencia: Coruzzolo et al.:
  - p. 5: el conjunto K de posiciones por operario es finito (1..num_period).
  - p. 6, ecuación (1): el objetivo es w₁·Σv + w₂·(γ·Σea + ∂·Σta).
  - p. 7, ecuación (18): el tiempo de ejecución es β^setup + β^picking·Σcap_n·y_nh + β^time·Σd·z.
- Qué dice la tesina: que con velocidades iguales, cadena de frío no restrictiva y sin tiempos de
  servicio, los modelos se reducen al de referencia con los lotes fijos.
- Qué es lo correcto: hacen falta además dos condiciones. La primera es que |K| sea al menos la
  cantidad de lotes, porque la tesina usa precedencias y no tiene un tope de posiciones. La segunda es
  una correspondencia de pesos (w₁, w₂γ y w₂∂). A esto se suma la salvedad de E-3 sobre la
  ecuación (16). El tiempo fijo F_b de la tesina (`cap3.tex:151`) coincide con β^setup + β^picking·Σcap
  del paper, lo que verifiqué, y el resto de la afirmación se sostiene.
- Sugerencia: agregar "y con suficientes posiciones por *picker*" e indicar la correspondencia de los
  pesos, en una nota o en el Anexo de modelos.

**E-7. "Tiempo de preparación" se usa con dos sentidos**
- Ubicación: `Capitulos/cap7.tex:96-97` ("sobre todo de la reducción del tiempo de preparación"), frente
  a `cap1.tex:13` ("tiempo de preparación de un pedido") y al nombre del problema ("problema de
  preparación de pedidos", `cap1.tex:64`).
- Evidencia: Coruzzolo et al., p. 14: "setup time" (180 s por lista de picking). La tesina define
  T^setup como "tiempo de preparación de cada lote" (`cap3.tex:111`).
- Sugerencia: en cap7, escribir "tiempo de preparación del recorrido (*setup*)", para no confundirlo con
  la preparación del pedido completo.

**E-8. Gutiérrez et al.: se exagera el resultado**
- Ubicación: `Capitulos/cap1.tex:12-16`.
- Evidencia: Gutiérrez López et al.:
  - p. 1: "from 2 to 8 hours depending on the order type", lo que respalda el dato de 8 horas.
  - p. 6, Tabla III ("Expected improvements"): reducciones estimadas de 10,33 %, 8,81 % y 6,69 % según
    el tipo de pedido. Son proyecciones de un modelo de reubicación (*slotting*), no mejoras
    implementadas.
- Qué dice la tesina: que con una mejor asignación de ubicaciones "es posible reducir
  significativamente ese tiempo".
- Sugerencia: "…y estima que una reubicación de los productos reduciría ese tiempo entre un 7 y un
  10 %".

**E-9. El dato de 50–75 % es una cita secundaria**
- Ubicación: `Capitulos/cap1.tex:11-12`.
- Evidencia: Urzúa et al., p. 1 (p. 103): "accounts for about 50-75% of the total operating cost for a
  typical warehouse [5]". El dato es de la referencia [5] de Urzúa. Coruzzolo et al., p. 2, dan "up to
  55 %" del costo y "approximately 60 %" del trabajo.
- Sugerencia: escribir "según Urzúa et al., que citan a …", o citar la fuente primaria. Es fiel a la
  fuente citada.

**E-10. El gap, la cota primal y la cota dual se atribuyen a Hillier y Lieberman, que no usan esos términos**
- Ubicación: `Capitulos/cap2.tex:126-133`.
- Evidencia: Hillier y Lieberman, p. 490 (p. 463 del libro): solo describen detener la ramificación y
  acotamiento cuando la incumbente está "suficientemente cerca" del óptimo (Z** − K ≤ Z* o
  (1 − α)Z** ≤ Z*). No usan "cota primal", "cota dual" ni "gap de optimalidad". Las oraciones de
  `cap2.tex:133-135` (un gap grande puede deberse a una cota dual débil) y de `cap2.tex:137-141` (elegir
  el menor M válido) no tienen cita.
- Sugerencia: reformular "la idea de detenerse cerca del óptimo aparece en [Hillier]", o citar la
  documentación de SCIP o un texto de programación entera para estos términos y para la recomendación
  sobre M.

**E-11. La comparación de Roberti y Toth se presenta con una relación causal que el paper no afirma**
- Ubicación: `Capitulos/cap2.tex:143-148`.
- Evidencia: Roberti y Toth:
  - p. 5 (p. 116): la relajación de GG es más ajustada que la de MTZ, lo que es correcto.
  - p. 18 (p. 129-130): "GG was the only formulation able to solve, to optimality, all of the ten
    instances", lo que también es correcto. Pero las cotas de PL de GG "are, on average, worse" que las
    de CLAUS, SSB y GP. Los autores atribuyen el buen desempeño de MTZ, GG y DL a que tienen pocas
    restricciones y a los cortes de CPLEX, no a lo ajustado de la relajación. MTZ resolvió 9 de las 10
    instancias.
- Qué dice la tesina: el párrafo abre con "Lo mismo vale…" (relajación más ajustada implica mejor
  resolución), lo que sugiere que GG resuelve todo porque su relajación es más ajustada.
- Sugerencia: separar las dos afirmaciones y precisar "en 10 instancias, con CPLEX 11.2 y un límite de
  tiempo". Las ecuaciones (11)–(12) de la tesina (`cap2.tex:85-86`) y la integralidad de g_ij
  (`cap2.tex:97-99`) coinciden con Roberti y Toth, p. 6 (p. 117).

**E-12. Atribución inconsistente de Alaya et al. y transferibilidad de sus parámetros**
- Ubicación: `Apendices/ap8.tex:392-393` ("Alaya y Solnon"), frente a `Capitulos/cap2.tex:454-455`
  ("Alaya et al.").
- Evidencia: el paper tiene tres autores (Alaya, Solnon y Ghédira, p. 1), igual que la entrada
  `alaya2007antcolony`. Sus parámetros están calibrados para la mochila multiobjetivo, con heurística
  η = beneficio/peso (p. 5), no para ruteo.
- Sugerencia: escribir "Alaya et al." en los dos lugares y aclarar en una frase que se usan solo como
  orden de magnitud.

**E-13. No se dice con qué pesos se obtuvieron los resultados del caso**
- Ubicación: `Capitulos/cap2.tex:435-438` y `cap7.tex:93-102`.
- Evidencia: Coruzzolo et al., p. 14: "we chose to assign the maximum weight (1) to the completion
  time". El caso real no explora el compromiso entre adelanto y demora que el modelo permite.
- Sugerencia: agregar en cap7 (en "Lo que no es comparable") que el resultado del paper prioriza la
  finalización, mientras que la tesina evalúa también el adelanto y la demora.

**E-14. Afirmaciones sin cita o sin fuente**
- `Capitulos/cap1.tex:96-104`: la caracterización de los métodos exactos frente a los heurísticos. Se
  puede citar a Talbi, cap. 1.
- `Capitulos/cap1.tex:31-32` y `cap2.tex:460-462`: el almacén de congelados y la afirmación de que la
  velocidad heterogénea y la cadena de frío están "presentes en la operación real". No se indica de qué
  operación salen. Si viene del relevamiento (Anexo), conviene remitir a él.
- `Capitulos/cap2.tex:75-78`: MTZ y GG se presentan sin las referencias originales (Miller, Tucker y
  Zemlin, 1960; Gavish y Graves, 1978). Roberti y Toth las cubren como fuente secundaria. Es
  aceptable, pero mejora con las originales.
- `Capitulos/cap2.tex:133-135` y `cap2.tex:137-141`: ver E-10.
- `Capitulos/cap1.tex:86-89`: no necesita cita. Recalculé las cifras: 20! ≈ 2,43·10¹⁸, y repartir y
  ordenar 10 lotes distintos entre 3 operarios da 10!·C(12,2) = 239.500.800, más de 200 millones.

**E-15. Los comentarios del código citan páginas del paper de forma imprecisa (no es la tesina, pero está relacionado)**
- `models/opp_aco/opp_aco.py:699-700` (main): "Coruzzolo et al. (2023) … (pp.6-9), route over
  precomputed shortest paths in the same way". En las pp. 6-9 el paper rutea con variables de arco
  z_ijh sobre la matriz d_ij. La idea de un TSP sobre distancias mínimas precalculadas está en la
  p. 3. `models/utils/route_construction.py:287` repite "pp.6-9".
- Los demás comentarios del código coinciden con el paper: el vecino más cercano está en la p. 9
  (`opp_hc.py:529`), los movimientos de intercambio e inserción en la p. 11 (`opp_hc.py:25`) y el
  multi-start en las pp. 11-12 (`opp_hc.py:444`).
- Sugerencia: cambiar a "p. 3" o "p. 3, 13".

---

## 2. Descripción del paper de Coruzzolo et al.: qué está bien

Afirmaciones de la tesina que coinciden con el paper:

| Afirmación de la tesina | Ubicación | Paper |
|---|---|---|
| MIP conjunto de cuatro decisiones (loteo, asignación, secuencia y ruta) | cap2:426-430 | p. 2, p. 6 |
| Capacidad del carro en el loteo | cap2:430-431 | p. 7, ec. (5) |
| Depósito inicial y final distintos | cap2:431-432 | p. 4, ec. (6)–(9) |
| A lo sumo una entrada y una salida por ubicación | cap2:432 | ec. (14)–(15) (ver E-2) |
| Secuencia con posiciones numeradas | cap2:434-435, cap3:22-23 | variables x_pkh, ec. (2), (19)–(21) |
| Objetivo: finalizaciones + suma ponderada de adelanto y demora | cap2:435-437 | ec. (1) |
| Adelanto indeseable porque ocupa espacio | cap1:57-60, cap2:437-438 | p. 5 |
| Modelo simplificado sin ruteo, con todos los lotes factibles y vecino más cercano | cap2:440-443, cap7:48-51 | p. 9, ec. (33)–(48) |
| Desigualdades que permiten espera voluntaria | cap3:700-703 | ec. (20)–(21), p. 7 |
| Heurística EDD que forma lotes y asigna al operario que termina antes | cap7:76-79 | p. 10-11, Algoritmo 1 |
| ILS que perturba la mejor solución con aceptación markoviana | cap7:89-91 | p. 12, Algoritmos 2–3 |
| No modela velocidad heterogénea ni cadena de frío | cap2:460-462 | β^time único, sin límite de duración (p. 5-7) |
| Desglose 207,97 = 169,20 + 38,77 | cap7:96-97 | p. 14, Tablas 2–4 |
| Caso real | cap7:99 | p. 13: primera semana de julio de 2019, 5 días, unas 550 ubicaciones |

---

## 3. ¿Son justas las comparaciones con el paper?

| Aspecto | Coruzzolo et al. | Tesina | ¿Comparable? |
|---|---|---|---|
| Instancias | Caso real: 5 días, 50–74 pedidos por día y unas 550 ubicaciones (p. 13-14) | Instancias generadas en grilla (funcionales y de estrés), con los lotes dados | No |
| Grafo | Matriz completa de distancias entre ubicaciones (p. 13) | Grafo de adyacencias | No (ver E-2) |
| Decisiones | Loteo, asignación, secuencia y ruta | Asignación, secuencia y ruta | Parcial |
| Supuestos | Velocidad homogénea, sin cadena de frío, capacidad en ítems, w₁ = 1 en el caso | Velocidad heterogénea, cadena de frío, tiempo de servicio por ubicación | Parcial (E-6) |
| Métrica | Tiempo de recorrido + setup frente a la estrategia de un pedido por vez (sin clasificado) | Brecha al óptimo probado, tiempo de cómputo y estado | No |
| Resolvedor y límites | No se informan límites de tiempo. Se menciona "IVE Xpress" para la matriz de distancias (p. 13) | SCIP, con tope de 40 min en estrés | No |

Evaluación:
- **Lo que no es comparable (`cap7.tex:93-102`)**: la comparación es justa. La tesina declara
  explícitamente que el 57 % no puede reproducirse, porque los lotes son un dato y las instancias son
  distintas. Solo le faltan las salvedades de E-5.
- **Dificultad de los modelos lineales (`cap7.tex:34-42`)**: la comparación es cualitativa ("son
  consistentes con esa experiencia"), y así es razonable. Pero las instancias, el resolvedor y los
  límites son distintos, y el paper no informa tiempos. Conviene decir que la coincidencia es
  cualitativa.
- **Descomposición (`cap7.tex:44-61`)**: es correcta y justa. El paper calcula una ruta heurística por
  cada lote factible (p. 9) y el Split rutea de forma exacta los lotes dados. La inferencia de que el
  modelo simplificado "ya no es exacto" se deduce bien del uso del vecino más cercano.
- **Medición contra el óptimo (`cap7.tex:63-91`)**: la tesina aclara que no implementó la heurística
  de los autores ("estos resultados no miden su calidad"). Es honesto. Falta la precisión de E-4 sobre
  lo que el paper llama "minimum solution".
- **Reducción al modelo de referencia (`cap3.tex:26-29` y `cap7.tex:24-27`)**: se sostiene con las
  salvedades de E-3 y E-6.

---

## 4. Otras fuentes de zpaper: fidelidad de las citas

| Cita | Ubicación | Verificado en | Resultado |
|---|---|---|---|
| urzua2019evaluating | cap1:11-12 | p. 1 | Fiel, pero es cita secundaria (E-9) |
| gutierrez2019reduction | cap1:12-16 | p. 1, 5-6 | Las 8 h son correctas; "significativamente" exagera (E-8) |
| chen2013antcolony | cap2:446-450, cap4:266-269, cap7:135-138, cap7:612-613 | p. 1, 3 (§4.1.1, distancias mínimas entre picks), 5 | Fiel: ACO para dos pickers con congestión, rutas sobre las ubicaciones requeridas unidas por caminos mínimos |
| lesch2023optimizing | cap2:450-454, ap8:393 | p. 1-2, 14-16 | La descripción es fiel (NSGA-II y ACO, interacción). Los parámetros no quedan cubiertos (E-1) |
| alaya2007antcolony | cap2:454-457, ap8:393 | p. 1, 3-5 | La descripción es fiel. Atribución inconsistente y parámetros no cubiertos (E-1, E-12) |
| roberti2012atsp | cap2:85-99, 143-148 | p. 5-6, 14, 18 | Las fórmulas y la integralidad son correctas; matiz causal (E-11) |
| matousek2007understanding | cap2:38-39 | p. 36 del PDF | Fiel: la programación entera general es NP-hard |
| hillier2010investigacion | cap2:18, 43, 63, 110, 124, 133 | p. 464-467 (M grande), 476 (2ⁿ), 478-480 (redondeo), 481-494 (B&B, incumbente), 497-502 (ramificación y corte), 490 (cerca del óptimo) | Fiel, salvo el gap y las cotas primal y dual (E-10) |
| talbi2009metaheuristics | cap2:204-261, 269, 298, 389-419 | p. 73-78 (rechazo, penalización y preservación), 115-116 (swap n(n−1)/2; 2-opt y su vecindad n(n−1)/2 − n), 146 ("oldest and simplest"), 150-151 (cuatro familias; ILS en "iterating from different initial solutions"), 265-266 (memoria de feromona e información heurística) | Fiel. La fórmula de 2-opt (`cap2:231-235`) es idéntica a Talbi p. 116 |
| hoos2015sls | cap2:253, 257, 269, 288, 322 | p. 6 (primera mejora, orden aleatorio, inspección completa), 12-13 (construcción probabilística, "two counteracting mechanisms") | Fiel |
| dorigo2004aco | cap2:286-372 | p. 49-50 (acciones de demonio), 82-86 (regla proporcional aleatoria, α = 0 o β = 0, estancamiento, decaimiento exponencial, EAS, MMAS con [τmin, τmax] e inicialización en τmax) | Fiel |
| stutzle2000mmas | cap2:360-363 | p. 14 | Fiel: deposita solo la mejor de la iteración o la mejor global |
| rosenkrantz1977analysis | ap8:34 | p. 14-15 | Fiel: inserción del más lejano |
| babin2007oropt | ap8:97-99 | p. 2 y referencia de Or (1976), tesis doctoral en Northwestern | Fiel. La copia de zpaper es el preprint GERAD G-2005-02, no la versión de JORS 2007, así que las páginas no coinciden |
| croes1958method | cap2:225 | — | No verificado: no hay PDF |
| baker1990sequencing | cap2:166, 180 | — | No verificado: no hay PDF |
| kanet2000inserted | cap2:172, 184; cap7:129 | — | No verificado: no hay PDF |

---

## 5. Citas a entradas inexistentes y entradas no citadas

- **Claves citadas que no existen en `tesina.bib`**: ninguna. Las 18 claves usadas con `\cite[...]` en
  `Capitulos/` y `Apendices/` existen.
- **Entradas de `tesina.bib` sin citar**: ninguna. Las 18 entradas se citan al menos una vez.
- **Metadatos**: coinciden con los PDF en autores, título, revista, volumen y páginas para Coruzzolo,
  Chen, Urzúa, Lesch, Alaya, Roberti, Rosenkrantz y Stützle y Hoos.
- **PDF de zpaper que no corresponden a ninguna entrada**: `Flipkart Optimized Its SupplyChain.pdf` y
  `Marco_de_TTL_monografia.pdf`. Además, `Improvements_to_the_Or-Opt_Heuristic_for_the_Symme (1).pdf` es
  un duplicado.
- **Entradas sin PDF en zpaper**: `croes1958method`, `baker1990sequencing` y `kanet2000inserted`.

---

## 6. Qué no pude verificar y qué consulté

No verificado:
- Las citas a Croes (1958), Baker y Scudder (1990) y Kanet y Sridharan (2000), porque no están en
  zpaper. Esto incluye la definición de objetivo regular, el tiempo ocioso insertado y la afirmación de
  `cap7.tex:128-130` de que restringirse a programaciones sin tiempo ocioso "puede excluir el óptimo".
- La correspondencia de páginas del libro de Hoos y Stützle (2015, pp. 1085–1105) y de MMAS (FGCS 16),
  porque los PDF de zpaper parecen ser versiones preprint.
- Que las pruebas funcionales "verifican que el modelo se reduce al de referencia" (`cap7.tex:429-432`).
  Corresponde a las secciones A y C.
- Si el código implementa exactamente las condiciones de reducción de E-6. No revisé el código de los
  modelos, solo los comentarios que citan el paper.

Método: la consigna pedía leer los PDF con Read y el parámetro `pages`. Lo hice con el paper de
Coruzzolo et al. (pp. 1–18, completo), con Alaya et al. (p. 5) y con Roberti y Toth (pp. 5–6). Para
**ubicar** los pasajes en las demás fuentes, y en los libros largos, extraje el texto con `pdftotext`
a un directorio temporal y busqué con `grep`. Así consulté solo las páginas listadas en la tabla de la
sección 4 y no leí los libros completos. Es un desvío respecto de la consigna literal, y lo dejo
registrado.
