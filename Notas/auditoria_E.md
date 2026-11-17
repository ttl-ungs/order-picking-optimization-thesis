# Auditoría E — Relación con la bibliografía (informe parcial, solo lectura)

Alcance: sección E de `Notas/prompt_auditoria_tesina.md`, ejecutada sin subagentes. No se modificó ningún archivo salvo este informe. No se ejecutaron tests ni experimentos.

Convenciones: `cap2.tex:445` = línea del `.tex` actual (no del `tesina.pdf`; ver "No verificado"). "p. N" del paper = página del PDF de la revista (1–18). Severidad: Crítico (falso o contradice la fuente), Mayor (omisión o explicación errónea importante), Menor (precisión, estilo).

---

## 0. Resumen

No encontré ningún hallazgo **Crítico** en la sección E: lo que la tesina dice de Coruzzolo et al. (2023) es, en lo esencial, fiel al paper. Hay **4 Mayores** y **10 Menores**. Los más relevantes:

| # | Sev. | Resumen |
|---|---|---|
| E-01 | Mayor | `ap8.tex:390-391` afirma que los rangos de α, β, ρ "abarcan" los valores de Alaya et al. y de Lesch et al. Es falso para ρ (Lesch: 0,02; Alaya: 0,01, rango probado: 0,05–0,30) y para β (Alaya: 8; rango probado: 1–4). |
| E-02 | Mayor | La reducción "al modelo de referencia con los lotes fijos" (`cap3.tex:26-30`, `cap7.tex:24-27`) se verifica contra `opp_v4`, un modelo propio del repo, no contra la formulación publicada. La tesina no lo dice y `opp_v4` ya difiere del paper (precedencias en vez de posiciones, tiempo de servicio por nodo). |
| E-03 | Mayor | El "57 %" (`cap2.tex:445-446`, `cap7.tex:90-99`) se presenta sin decir que viene de la heurística (no de los MIP), que no incluye el tiempo de recolección por ítem ni el de clasificación posterior, y que el 81 % del ahorro es tiempo de *setup* supuesto (180 s por lista). |
| E-04 | Mayor | El estado del arte (`cap2.tex:426-473`) no revisa la literatura de optimización conjunta de lotes/asignación/secuenciación/ruteo ni la de pickers heterogéneos, aunque el propio paper (pp. 3-4, refs. 17, 29, 30-32) las cita. El argumento de novedad (velocidad heterogénea, cadena de frío) queda sin respaldo bibliográfico. |

El resto (E-05 a E-14) son atribuciones imprecisas, afirmaciones sin cita y un error en la entrada bibliográfica (Sellitto "Alfonso" vs. "Afonso").

---

## 1. Qué dice el paper (logistics-07-00061, leído completo, pp. 1-18)

- **Problema** (pp. 1-5): JOBASRP/JOBSPRP, optimización conjunta de (1) batching, (2) asignación y secuenciación de lotes a pickers, (3) ruteo. Picker-to-parts, almacén manual de bajo nivel, varios pickers trabajando simultáneamente, un picker ejecuta un lote por vez. Depósito inicial y final **separados lógicamente** (pueden coincidir físicamente) (p. 4). Capacidad del carro medida en ítems (p. 6). **Sin congestión**: la declaran trabajo futuro (p. 16).
- **Tiempo de un lote** (p. 4, ec. 18 p. 7): setup + búsqueda/recolección por ítem (β^picking) + viaje (β^time · distancia). Un único β^time para todos los pickers (velocidad homogénea).
- **Modelo completo** (ecs. 1-32, pp. 6-8): variables `x_pkh` (misión h en la posición k del picker p), `y_nh` (orden n en misión h), `z_ijh` (arco), `f_ijh` (flujo). Objetivo: `w1·Σ v_pk + w2·(γ·Σ ea_n + ∂·Σ ta_n)`. Camino simple (ecs. 14-15: a lo sumo un arco de entrada y uno de salida por nodo). Completitud con desigualdades (ecs. 19-21): hay espera voluntaria implícita.
- **Modelo simplificado** (ecs. 33-48, pp. 9-10): sin ruteo; recibe **todos los lotes factibles** con su distancia calculada con **vecino más cercano** (p. 9).
- **Heurística** (pp. 10-12): constructiva por fecha de entrega más temprana (Alg. 1) + multi-start + búsqueda local (swap / insert) + ILS (perturbación swap, búsqueda local insert, aceptación solo si mejora; Alg. 2-3) + ILS con perturbación múltiple. Se aplican a la **permutación de órdenes**.
- **Experimento** (pp. 12-15): caso real de una empresa logística italiana, primera semana de julio de 2019, 5 días, 50-74 órdenes/día, ≈550 ubicaciones; β^time = 3 s/unidad, 10 s por ítem, setup 180 s, capacidad 20 ítems; comparación contra "single order" con un solo operario. Datos "disponibles a pedido" (p. 16).
- **Resultados**: tiempo de recorrido −24 % (Tabla 2), setup −84 % (Tabla 3), "tiempo total de picking" −57 % (207,97 min/día; Tabla 4). Umbral de clasificación: 20,98 min/lote o 2,54 min/orden (Tabla 5). ILS e ILS-múltiple obtienen la mejor solución 4 y 1 veces (p. 15). Los modelos MIP "resuelven problemas menores en tiempos aceptables" (p. 16), pero no se reporta ninguna corrida de los MIP.

---

## 2. Hallazgos

### E-01 — Rangos de la sensibilidad de ACO vs. valores de Alaya y Lesch — **Mayor**
- **Tesina**: `ap8.tex:390-391`: "Los rangos abarcan los valores por defecto y los que reportan Alaya y Solnon [alaya2007antcolony] y Lesch et al. [lesch2023optimizing]". Rangos probados (`ap8.tex:~384-389`): α∈{0,5; 1; 2}, β∈{1; 2,5; 4}, ρ∈{0,05; 0,15; 0,30}.
- **Fuentes**: Lesch et al., p. 18620 (PDF p. 16): α=1,0, β=2,0, **ρ=0,02**, τmin/max=1/25. Alaya et al., Tabla 1 (PDF p. 5): m-ACO1/2: α=1, β=4, ρ=0,1; m-ACO3: α=1, **β=8**, **ρ=0,01**; m-ACO4: α=1, β=4, **ρ=0,01**.
- **Qué es correcto**: α=1 y β∈{2;4} caen dentro del rango; **ρ=0,02 (Lesch) y ρ=0,01 (Alaya) quedan por debajo de 0,05, y β=8 (Alaya) por encima de 4**. Además el artículo de Alaya es de Alaya, Solnon **y Ghedira** (tres autores; `cap2.tex:456` dice "Alaya et al." bien, `ap8.tex:390` dice "Alaya y Solnon"), y sus parámetros corresponden a un problema de mochila multiobjetivo, no a ruteo.
- **Sugerencia**: "Los rangos incluyen los valores por defecto y los de Alaya et al. y Lesch et al. salvo ρ ≤ 0,02 y β = 8, que quedan fuera" o extender la grilla (ρ=0,02; β=8). Aclarar que esos valores provienen de otros problemas (mochila multiobjetivo; picking en entrepisos). Corregir "Alaya y Solnon" por "Alaya et al.".

### E-02 — "Se reducen al modelo de referencia": el contraste es con `opp_v4`, no con el paper — **Mayor**
- **Tesina**: `cap3.tex:26-30` ("si todos los operarios tienen la misma velocidad, el límite … es suficientemente grande y no hay tiempos de servicio, los dos modelos se reducen al modelo de referencia con los lotes fijos"); `cap7.tex:24-27` ("…y las pruebas funcionales lo confirman"); `cap7.tex:419-424` (Conclusión 1).
- **Evidencia**: el repo no implementa la formulación del paper (variables `x_pkh`, `y_nh`, `z_ijh`, `f_ijh`, conjunto de períodos K). El baseline es `models/opp_v4/opp_model_v4.zpl` (rama `main`), que ya usa precedencias `y_bk` (b<k), tiempo de servicio `S_i` por nodo, lotes dados y sin restricción de capacidad (`opp_model_v4.zpl:22-135`); `tests/infra/factories/migrated_case.py:1` re-ejecuta los asserts de v4 contra v5.2. Es decir, "la reducción" está probada contra un modelo propio, que a su vez es una adaptación del paper.
- **Qué es correcto**: lo que se verificó es que v5.1/v5.2 reproducen a v4 cuando se anulan velocidad, cadena de frío y servicio. La equivalencia v4 ↔ formulación publicada (posiciones vs. precedencias; flujo acotado por capacidad vs. por L_b; eq. 16 del paper) es un argumento de la tesina, no un resultado verificado. El nombre `opp_v4` no aparece en la tesina (solo en comentarios de la guía de `cap5.tex:649`).
- **Sugerencia**: decir en `cap3` (y en `cap7:24-27`) que "el modelo de referencia" contra el que se prueba es la adaptación propia (v4) y justificar brevemente por qué es equivalente al del paper con lotes fijos (la secuencia por posiciones y por precedencias representan los mismos órdenes totales por picker), o suavizar a "se reducen a la adaptación del modelo de referencia con lotes fijos".

### E-03 — El "57 %" y sus condiciones — **Mayor**
- **Tesina**: `cap2.tex:445-446` ("su propuesta reduce el tiempo de picking en un 57 % respecto de preparar los pedidos de a uno"); `cap7.tex:90-99` (descompone 169,20 + 38,77 = 207,97 min y dice que "no son comparables").
- **Paper**: Tablas 2-4 (pp. 14-15). Recalculado:
  - "Picking total time" de la Tabla 4 = recorrido + setup, **sin** el tiempo de recolección por ítem: 160,47 + 201,00 = 361,47 y 121,69 + 31,80 = 153,49 (el paper dice que ese tiempo es constante, p. 14). El 57 % es 207,97/361,47 = 57,5 % de *recorrido + setup*, no del tiempo total de picking.
  - 169,2 de los 207,97 min (81 %) son *setup* (3 min por lista × 50-74 listas diarias en "single order" vs. 7-14 lotes); el recorrido aporta solo el 24 % de reducción (Tabla 2).
  - El ahorro es **bruto**: no incluye la clasificación posterior (Tabla 5; el paper concluye que solo conviene si clasificar cuesta < 20,98 min/lote o < 2,54 min/orden, p. 15).
  - Se obtuvo con la **heurística** (EDD + multi-start + ILS), no con los MIP, que no se corrieron sobre el caso (pp. 10, 13, 16). Una sola semana (5 días) y un solo operario como línea base.
- **Qué dice la tesina vs. correcto**: `cap7:93-94` acierta en la descomposición y en que "proviene sobre todo de la preparación"; `cap2:445` no aclara nada de lo anterior y le atribuye el resultado a "su propuesta" (los modelos).
- **Sugerencia**: en `cap2.tex:445-446`: "…reduce el tiempo de recorrido + preparación un 57 % (heurística constructiva con ILS, una semana de datos reales, sin contar la clasificación posterior ni el tiempo de recolección, que se mantiene)". En `cap7:93`, aclarar que "preparación" es el *setup* de 180 s por lista (en `cap1.tex:13-15` "tiempo de preparación de un pedido" significa otra cosa; ver E-12).

### E-04 — Estado del arte insuficiente para sustentar el posicionamiento — **Mayor**
- **Tesina**: `cap2.tex:426-473` cita solo 4 trabajos sobre picking (Coruzzolo, Chen, Lesch, Alaya); `cap2.tex:461-466` posiciona el aporte en "velocidad heterogénea y cadena de frío, presentes en la operación real", y la intro cita 2 trabajos de motivación (Urzúa, Gutiérrez).
- **Paper** (usado como índice de literatura): pp. 3-4 y Tabla 1 listan 15 trabajos de batching/asignación/secuenciación/ruteo conjuntos; cita explícitamente **pickers heterogéneos** (ref. [17], Chen, Cheng, Chen y Chan 2015; ref. [29], Matusiak et al. 2017 "individual picker skills"), **múltiples pickers** (refs. [29]-[32]), **fechas de entrega** (refs. [16], [31]) y los modelos más completos del JOBASRP (refs. [30], [33] según p. 4; ref. [18] Scholz et al. 2017; ref. [28] Valle et al. 2017). Referencia de revisión general: ref. [7] de Koster et al. 2007.
- **Qué es correcto**: sin esa revisión no se puede afirmar que la heterogeneidad de velocidad o la cadena de frío sean un aporte respecto de la literatura; solo respecto del paper de referencia. Tampoco hay literatura de cadena de frío/almacenes refrigerados en la bibliografía (ninguna entrada, ni en `zpaper/`).
- **Sugerencia**: agregar una subsección breve (1 párrafo + 4-6 citas) con: (i) revisión de picking (de Koster et al. 2007), (ii) trabajos de JOBASRP con pickers múltiples/heterogéneos (Matusiak 2017; Chen 2015; Scholz 2017), (iii) ruteo como Steiner-TSP, y (iv) algo de almacenamiento en frío si existe. Acotar la afirmación de novedad a "respecto del modelo de referencia".

### E-05 — "No pudieron resolver ninguno de sus modelos": falta el matiz del paper — **Menor**
- **Tesina**: `cap7.tex:34-36` ("no pudieron resolver sobre su caso de estudio ninguno de sus dos modelos, ni siquiera el simplificado"); `cap2.tex:466-470`; `cap7.tex:37-42` ("resultados consistentes con esa experiencia").
- **Paper**: abstract p. 1 ("both models were too complex to test"); p. 10 ("not solvable within acceptable time limits") ✓. Pero también: p. 12-13 ("designed a simple problem that could be solved within acceptable time limits") y conclusiones p. 16 ("Both proposed models could solve minor problems with acceptable computational times"). No hay ninguna tabla de esos resultados. En p. 16 además dicen que ILS "could successfully identify the minimum solution", afirmación que el paper no puede sostener (nunca obtuvo el óptimo).
- **Qué es correcto**: la tesina acierta en el caso real (≈550 ubicaciones, 7-14 lotes/día por Tabla 3), pero omite que los autores sí resolvieron problemas pequeños y no publicaron resultados. La "consistencia" con la experiencia de esta tesina es solo cualitativa: los tamaños no son comparables (el paper no da los de su problema chico).
- **Sugerencia**: "los autores informan que ambos modelos solo resultaron resolubles en problemas pequeños, sin publicar esos resultados, y que el caso real quedó fuera de alcance". En `cap7:37-42`, aclarar que la comparación de dificultad es cualitativa.

### E-06 — "Flujo de tipo Gavish y Graves" atribuido al paper — **Menor**
- **Tesina**: `cap2.tex:434-436` y `cap3.tex:282` / `cap2.tex:75-78`.
- **Paper**: no menciona MTZ ni Gavish-Graves; usa `f_ijh ≤ Cap·z_ijh` (ec. 12) y la ec. 16, que en el PDF (p. 7) se imprime como `Σ_g f_gih = Σ_j f_ijh ≥ a_ni·y_nh`, es decir, **conservación de flujo (igualdad)**, no una disminución de flujo por nodo. Tal como está impresa no elimina por sí sola ciclos desconectados del depósito; si lo hace, es porque debería ser `in − out ≥ a·y` (errata probable). 
- **Qué es correcto**: llamarlo "de tipo GG" es una **interpretación** de la tesina, razonable, pero no es lo que el paper dice. La tesina tampoco avisa de la ambigüedad.
- **Sugerencia**: "que interpretamos como un flujo de un único producto (ecs. 12 y 16 del paper)" y, si se quiere, mencionar la errata probable en la ec. 16 en una nota.

### E-07 — Cota primal/dual y "gap" citados a Hillier & Lieberman — **Menor**
- **Tesina**: `cap2.tex:130-139` (cota primal, cota dual, "gap de optimalidad", "gap nulo prueba el óptimo") con `\cite[hillier2010investigacion]`.
- **Fuente**: en el PDF de Hillier & Lieberman (9.ª ed.) el cap. 11 trata ramificación y acotamiento, solución incumbente y ramificación y corte, pero no aparecen los términos "cota primal", "cota dual" ni "gap" (búsqueda de texto: 0 resultados de "cota dual", "cota primal", "gap" en sentido de brecha; no revisé página por página). Es terminología de resolvedores MIP.
- **Sugerencia**: citar un texto de MIP/documentación de SCIP para esos términos, o mantener la cita solo para B&B/incumbente.

### E-08 — Falta atribución a Coruzzolo en el código de las metaheurísticas — **Menor**
- **Tesina**: `ap8.tex:22-30` ("Vecino más cercano") sin cita; `cap4.tex` no atribuye vecindades ni multi-start. `cap7.tex:73` dice "no se implementó la heurística de los autores".
- **Código** (`main`): `models/opp_hc_4/opp_hc_4.py:59-61` ("la ruta inicial por vecino más cercano sigue el paso de ruteo de Coruzzolo (p. 9)"; las vecindades "cumplen el papel de los movimientos swap/insert" de Coruzzolo); `opp_hc_4.py:538` (multi-start de Coruzzolo); `models/utils/route_construction.py:338, 848` (vista Steiner-TSP de Chen y Coruzzolo).
- **Qué es correcto**: la afirmación de `cap7:73` es cierta para la heurística completa (EDD + ILS), pero el NN inicial, la idea swap/insert y el multi-start sí se adaptan del paper. 
- **Sugerencia**: citar `coruzzolo2023orderpicking` en `ap8.tex:22` (NN) y en el párrafo de vecindades de HC, y precisar en `cap7:71-73` qué componentes sí se toman de los autores.

### E-09 — Gutiérrez et al. (2019): "8 horas" — **Menor**
- **Tesina**: `cap1.tex:12-16`: "el tiempo de preparación de un pedido podía llegar a las 8 horas, y … con una mejor asignación de las ubicaciones de picking es posible reducir significativamente ese tiempo".
- **Fuente** (FP366, p. 1-2): el abstract dice "cycle time to prepare an order was high (from 2 to 8 hours depending on the order type)"; el ciclo incluye procesamiento administrativo + preparación + carga en camión (Fig. 2, p. 2), y la intervención es la reubicación de SKUs (modelo binario). Además, los pedidos son de pallets de consumo masivo en un centro con 74 SKUs.
- **Sugerencia**: "el ciclo de un pedido (procesamiento, preparación y carga) llegaba a 8 horas según el tipo de pedido". La palabra "significativamente" no está respaldada por una cifra que yo haya podido leer (solo leí pp. 1-2).

### E-10 — Roberti y Toth (2012): generalización de "todas las instancias" — **Menor**
- **Tesina**: `cap2.tex:101-105` ("GG fue la única que llegó al óptimo en todas las instancias consideradas dentro del límite de tiempo").
- **Fuente** (pp. 125-129 del artículo, Tabla 2 y texto p. 129): son **10 instancias pequeñas de TSPLIB** (ftv33…ftv70, ft53, ft70), tope de 1800 s, CPLEX 11.2; MTZ, DL y SD resolvieron "all but one", y los autores concluyen que MTZ, GG y DL son "las mejores para usarse directamente en CPLEX". Es ATSP, no ruteo con nodos obligatorios.
- **Ok**: que la relajación de GG es más fuerte que la de MTZ (p. 117: "stronger than that of MTZ (Wong 1980; Padberg y Sung 1991)") y que las `g_ij` salen enteras (p. 117) están bien. Las ecuaciones (11)-(12) de Roberti coinciden con `cap2.tex:82-89`.
- **Sugerencia**: "en 10 instancias pequeñas de TSPLIB con un tope de 30 minutos, GG fue la única formulación que resolvió las 10; MTZ, DL y SD resolvieron 9". Citar `roberti2012atsp` en `cap2.tex:75-78` (donde se atribuyen MTZ y GG sin cita).

### E-11 — Entrada bibliográfica de Coruzzolo — **Menor**
- `Referencias/tesina.bib:3`: autor "Sellitto, Miguel **Alfonso**"; el paper (p. 1) dice "Miguel **Afonso** Sellitto". No se ve en el PDF compilado (usa iniciales), pero es un error de datos. El resto (título, vol. 7, n.º 3, art. 61, 2023, DOI) coincide.
- Otras entradas contrastadas con PDF de `zpaper/`: Chen 2013 ✓, Urzúa 2019 ✓ (vol. 6, n.º 4, pp. 103-114, DOI), Gutiérrez 2019 ✓ (DOI y congreso), Lesch 2023 ✓, Roberti y Toth 2012 ✓ (DOI), Rosenkrantz 1977 ✓ (vol. 6, n.º 3), Babin 2007 ✓, Dorigo-Stützle 2004 ✓ (ISBN), Talbi 2009 ✓, Matoušek-Gärtner 2007 ✓ (ISBN), Hillier-Lieberman 9.ª ed., 2010 ✓. Alaya 2007: el PDF no trae sede; "ICTAI 2007" no verificable desde el PDF.

### E-12 — Terminología "preparación" — **Menor** (solapa con F/G)
- `cap1.tex:13-15` ("tiempo de preparación de un pedido") designa el ciclo completo de picking; `cap3.tex:111` (`T^setup` = "tiempo de preparación de cada lote") y `cap7.tex:93-94` ("169,20 corresponden a la preparación") designan el *setup* por lista. El paper usa "setup time". Sugerencia: usar "armado del recorrido (*setup*)" para `T^setup` y reservar "preparación del pedido" para el picking completo.

### E-13 — Criterio de parada de Hill Climbing atribuido a Talbi — **Menor**
- `cap2.tex:259-262`: "cuando en cada iteración se genera solo una parte de [la vecindad]… la búsqueda se detiene con criterios explícitos, como un número máximo de iteraciones o un límite de tiempo [talbi2009metaheuristics]".
- Talbi p. 122 (PDF p. 147): solo dice que el conjunto de vecinos candidatos puede ser un subconjunto de la vecindad y que la búsqueda se detiene cuando todos los candidatos son peores. En la sección de plantillas (PDF p. 194) afirma que los criterios de parada de HC "son implícitos". La parte "máximo de iteraciones o límite de tiempo" es de la tesina.
- Sugerencia: citar a Talbi solo para la vecindad restringida y presentar los criterios de parada como decisión de diseño.

### E-14 — ILS de los autores: referencia cruzada incorrecta — **Menor**
- `cap7.tex:86-88` remite a `sec:marco_hc` para "un mecanismo para escapar de [óptimos locales], reiniciando la búsqueda local desde una perturbación de la mejor solución". `cap2.tex` §2.3 no define ILS (solo menciona "reiniciar la búsqueda"). El paper cita a Lourenço et al. (ref. [38]) para ILS; la tesina no. También `cap7.tex:533-537` propone "la búsqueda local iterada de Coruzzolo et al." como mejora de HC sin haberla descripto.
- Descripción del paper (pp. 11-12): perturbación por swap sobre la **permutación de órdenes**, búsqueda local por insert, aceptación solo si mejora, parada tras N ciclos sin mejora. La paráfrasis de la tesina es correcta pero conviene aclarar que opera sobre el orden de las órdenes (decodificado por la heurística EDD), no sobre asignación de lotes.
- Sugerencia: agregar 2-3 oraciones sobre ILS en §2.3 con la cita de Lourenço, Martin y Stützle (o Hoos-Stützle) y apuntar `cap7:88` a ellas.

---

## 3. Evaluación de las comparaciones con el paper

**Lo que la tesina compara y si es justo**

| Comparación en la tesina | ¿Mismas instancias? | ¿Mismas métricas? | ¿Mismos supuestos? | Veredicto |
|---|---|---|---|---|
| Alcance de los modelos (`cap7:18-32`, `cap3:18-30`) | n/a | n/a | La tesina agrega velocidad heterogénea, cadena de frío, servicio por nodo; quita el batching y la capacidad | **Correcto** salvo E-02 |
| Dificultad de los MIP (`cap7:34-42`) | No (paper: caso real de ≈550 ubicaciones y 50-74 órdenes/día; tesina: instancias generadas hasta grillas de 100×100) | No (paper no reporta tiempos ni gap) | Distintos | **Solo cualitativa**; falta el matiz de E-05 |
| Simplificado de Coruzzolo vs. Split (`cap7:44-61`, `cap3:442-446`) | n/a | n/a | El paper enumera todos los lotes factibles y rutea con NN; el Split recibe los lotes y rutea exacto | **Correcto** y bien razonado. Falta decir que el simplificado además decide el loteo (ec. 35) |
| Calidad contra el óptimo (`cap7:63-88`) | No hay datos del paper | El paper compara variantes de ILS entre sí y con EDD, sin óptimo | La tesina aclara que no implementó la heurística de los autores | **Justa**: no pretende comparar números |
| 57 % (`cap7:90-99`) | No | Distinta (recorrido+setup vs. objetivo de la tesina) | Distintos | La tesina concluye bien que no es comparable; ver E-03 por las condiciones del dato |

**Instancias**: el paper no publica sus datos ("available on request", p. 16) y la tesina trabaja con instancias generadas, por lo que **ninguna comparación numérica directa es posible**. La tesina lo reconoce en `cap7:96-98`.

**Diferencias y similitudes: ¿completas?**
- Correctas y presentes: velocidad heterogénea (el paper usa un solo β^time), cadena de frío (ausente en el paper), servicio por ubicación (el paper solo tiene servicio por ítem y setup por lote), loteo dado, capacidad fuera del modelo, precedencias vs. posiciones, flujo acotado por L_b vs. capacidad, camino simple heredado (ecs. 14-15), depósitos distintos (p. 4), sin congestión (p. 16), completitud con desigualdades (ecs. 19-21; `cap3:693-696` lo señala correctamente).
- No mencionadas: (i) la heurística y el ILS del paper operan sobre permutaciones de órdenes y no sobre lotes ya formados; (ii) los pesos del objetivo: en el caso real el paper usa peso 1 en el tiempo de finalización (p. 14) por usar EDD; (iii) el paper dice que el modelo completo crece polinomialmente con las órdenes (p. 4) y el simplificado exponencialmente con los lotes factibles, lo cual respalda el argumento de `cap7:58-61`; (iv) el paper usa unidades de s y m (p. 13).

---

## 4. Afirmaciones sin cita (o con cita que no las cubre)

| Ubicación | Afirmación | Observación |
|---|---|---|
| `cap2.tex:75-78` | Miller-Tucker-Zemlin "la más antigua"; Gavish-Graves "flujo de un único producto" | Sin `\cite` ni entradas en el .bib. Roberti y Toth (pp. 114-117 del artículo) cubre la atribución; citarlo acá. Idealmente agregar MTZ (1960) y GG (1978). |
| `cap2.tex:156-159` | Definición de objetivo "regular" | Sin cita en la definición; `baker1990sequencing` solo aparece al final del párrafo. |
| `cap2.tex:130-139` | Cota primal/dual, gap | Cita no respalda la terminología (E-07). |
| `cap2.tex:259-262` | Criterios de parada de HC con vecindad parcial | E-13. |
| `cap1.tex:96-101` | "Exactos garantizan óptimo… heurísticos renuncian…" | Afirmación general sin cita (Talbi lo cubre). |
| `cap1.tex:11-12` | 50-75 % del costo operativo | Verificado por texto en Urzúa (§1, PDF p. 1: "about 50-75 % of the total operating cost for a typical warehouse"), que a su vez cita a Coyle, Bardi y Langley (fuente secundaria). Coruzzolo (p. 2) da otra cifra ("hasta 55 %"); conviene citar un rango con ambas o la fuente original. |
| `ap8.tex:22-30` | Vecino más cercano | Sin cita (E-08). `rosenkrantz1977analysis` lo cubre (se cita solo la inserción del más lejano). |
| `cap5.tex:33-36` | SCIP, PySCIPOpt, SoPlex, ZIMPL | Software sin entrada bibliográfica (no hay `@software`/`@techreport`). |
| `cap4.tex:273`, `ap8.tex:26` | Algoritmo de Dijkstra | Sin cita (estándar; opcional). |
| `cap7.tex:125-126` | "Como anticipa la literatura [kanet]" | OK, pero Kanet-Sridharan no está en `zpaper/` (no verificado). |
| Toda la tesina | Cadena de frío, picker heterogéneo | Sin literatura (E-04). |

---

## 5. Citas a entradas inexistentes y entradas no citadas

- Claves usadas con `\cite[...]` en los `.tex`: 18 distintas; **todas existen** en `Referencias/tesina.bib` (18 entradas). **Ninguna entrada del .bib queda sin citar** y el `tesina.pdf` (compilado el 15-nov-2026 23:04) lista 18 referencias numeradas, sin "[?]".
- Uso de claves (resumen): coruzzolo (cap1:60,110; cap2:429; cap3:5,696; cap7:18), chen (cap2:449; cap4:269; cap7:132,604), lesch (cap2:453; ap8:391), alaya (cap2:457; ap8:391), urzua (cap1:12), gutierrez (cap1:16), hillier (cap2:18,43,63,114,128,137), matousek (cap2:39), roberti (cap2:99,105), baker (cap2:163,177), kanet (cap2:169,181; cap7:126), talbi (cap2:203,215,239,248,262,270,298,391,413,421), hoos (cap2:254,258,270,287,322), dorigo (cap2:284,293,319,327,352,366,374), stutzle (cap2:361), croes (cap2:224), rosenkrantz (ap8:34), babin (ap8:98).
- Archivos de `zpaper/` **sin entrada en el .bib**: `Flipkart Optimized Its SupplyChain.pdf` (INFORMS J. Appl. Anal. 56(1):42-57, 2026; solo leí la portada, no evalué su pertinencia), `Marco_de_TTL_monografia.pdf` (plantilla, no es fuente) y `Improvements_to_the_Or-Opt_Heuristic_for_the_Symme (1).pdf` (copia duplicada de Babin et al.).
- Citas sin PDF en `zpaper/` (no verificables): croes1958method, baker1990sequencing, kanet2000inserted.
- Citados en el paper y relevantes para la tesina pero sin entrada: de Koster et al. 2007, Matusiak 2017, Chen-Cheng-Chen-Chan 2015, Scholz et al. 2017, Valle et al. 2017, Lourenço et al. 2003 (E-04, E-14).

---

## 6. Trazabilidad cita ↔ fuente (verificadas)

| Cita en la tesina | Qué afirma la tesina | Fuente consultada | Resultado |
|---|---|---|---|
| coruzzolo `cap1:60`, `cap2:438-440` | Adelanto penalizado por ocupar espacio; objetivo = Σ finalización + ponderación adelanto/demora | Paper p. 5 y ec. 1 (p. 6) | ✓ |
| coruzzolo `cap2:429-437` | Cuatro decisiones; capacidad del carro; depósitos inicial/final; a lo sumo una visita; posiciones numeradas | Paper pp. 4-8 (ecs. 2-21) | ✓ (salvo E-06 sobre "tipo GG") |
| coruzzolo `cap2:442-446` | Modelo simplificado sin ruteo; todos los lotes factibles; NN; 57 % | Paper pp. 9-10, 14-15 | ✓ con las reservas de E-03 |
| coruzzolo `cap2:466-470` | Modelos "demasiado complejos", EDD + ILS, sin contraste con el óptimo | Paper pp. 1, 10-12, 16 | ✓ con el matiz de E-05 |
| coruzzolo `cap3:693-696` | Completitud con desigualdades en el modelo de referencia | Paper ecs. 19-21 (p. 7) | ✓ |
| coruzzolo `cap7:73-83` | Heurística: recorre órdenes por fecha, agrega al lote en curso del operario con el que termina antes, o abre uno nuevo | Paper Alg. 1 (p. 11) | ✓ |
| coruzzolo `cap7:93-94` | 207,97 = 169,20 (setup) + 38,77 (recorrido) | Tablas 2-4 (pp. 14-15) | ✓ (recalculado: 38,77 + 169,20 = 207,97) |
| chen `cap2:449-452` | ACO para dos pickers con congestión | Chen et al., resumen y §4 (pp. 77-79) | ✓ |
| chen `cap4:265-269` | Ruteo como TSP sobre ubicaciones requeridas unidas por camino más corto | Chen §4.1.1 (p. 79): distancia Manhattan / la más corta de dos rutas posibles; Steiner-TSP | ✓ |
| chen `cap4:526-529` | "toman las distancias de una tabla calculada de antemano y permiten volver a recorrer pasillos" | Chen §4.1.1 (p. 79) y §4.2.1 (pp. 79-80) | **Parcial**: la matriz inicial se precalcula, pero la distancia lógica (con espera por congestión) se recalcula en cada paso con una tabu list (p. 79, 80); el paper no dice explícitamente que se permitan revisitas (solo "Steiner-TSP"). El contraste con la tesina ("en cambio se recalculan en cada paso") es engañoso: la diferencia es el motivo (visitados vs. congestión). **Menor** |
| chen `cap4:538` | Chen no aplica búsqueda local | Chen §4.2-4.3 (pp. 80-81): solo actualización local/global de feromona y operación "cataclysm" | ✓ |
| chen `cap7:603-608` | Chen modela la congestión | Chen pp. 78-80 | ✓ |
| lesch `cap2:453-456` | GA para storage + ACO para ruteo en entrepisos; interrelación | Lesch, resumen (p. 18605) | ✓ (es NSGA-II y multiobjetivo con criterios ergonómicos; no se menciona) |
| alaya `cap2:456-459` | ACO multiobjetivo; valores de parámetros | Alaya, resumen y Tabla 1 | ✓ salvo E-01 |
| urzua `cap1:11-12` | 50-75 % | Urzúa p. 103 (§1, PDF p. 1; verificado solo por texto) | ✓ |
| gutierrez `cap1:12-16` | 8 horas | FP366 resumen, p. 1 | Con la precisión de E-09 |
| hillier `cap2:18,43,63,114,128` | Definición MIP; 2^n; validez de M; relajación; B&B y corte | Hillier cap. 11 (búsqueda por texto) | ✓ (excepto 137: E-07) |
| matousek `cap2:39` | Programación entera general es NP-hard | Matoušek-Gärtner p. 30 | ✓ |
| roberti `cap2:99,105` | Integralidad de g_ij; GG resuelve todas | Roberti p. 117, 129 | ✓ / E-10 |
| talbi `cap2:203-215,239,248,391-421` | HC más antiguo; vecindad; tamaño de 2-opt n(n−1)/2−n; selección; rechazo/penalización/preservación | Talbi pp. 49-50, 91, 121-123, 125 del libro | ✓ (2-opt: "[(n(n−1)/2)−n]" en p. 91 del libro) / E-13 |
| talbi `cap2:264-270` | Cuatro familias para escapar de óptimos locales | Talbi p. 125, Fig. 2.24 | ✓ |
| hoos `cap2:248-254` | Primera mejora aplica pasos antes, pasos más chicos, más pasos; orden aleatorio da óptimos distintos; inspección completa | Hoos-Stützle p. 6 (preprint) | ✓ |
| hoos `cap2:322` | Evaporación y depósito | Hoos-Stützle (preprint, PDF p. 13) | ✓ (verificado por texto) |
| dorigo `cap2:300-327` | AS: regla proporcional; α=0, β=0 y estancamiento; (1−ρ)τ; depósito 1/C^k | Dorigo-Stützle pp. 71-72 (libro) | ✓ |
| dorigo `cap2:354-366` | EAS (e/C^bs) y MMAS (límites, init en τmax) | Dorigo-Stützle pp. 73-75 | ✓ |
| stutzle `cap2:360-362` | MMAS: solo la mejor deposita | Cubierto por Dorigo-Stützle p. 74 (no abrí el paper MMAS) | ✓ |
| rosenkrantz `ap8:34` | Inserción del más lejano | Rosenkrantz et al. §5, "farthest insertion" (PDF p. 14) | ✓ |
| babin `ap8:98` | Or-opt: Or 1976, cadenas de 3, 2 y 1 vértices | Babin et al., introducción | ✓ |

---

## 7. Observaciones sobre el paper (no son errores de la tesina; conviene no reutilizarlas)

1. **Tabla 5 inconsistente** (p. 15): "Average Order/Batch" es N/8 en los cinco días (6,25; 8,88; 9,25; 8,88; 8,63) cuando la Tabla 3 da 8, 7, 12, 12 y 14 lotes. Recalculado con la Tabla 3: órdenes/lote = 6,25; 10,14; 6,17; 5,92; 4,93, y umbral por orden = 3,11; 3,41; 3,06; 2,72; 3,22, promedio **3,10 min/orden** (el paper dice 2,54). Los umbrales por lote (19,45; 34,62; …) sí cierran con la Tabla 3. La tesina no usa el 2,54, por lo que no hay que corregir nada.
2. El paper dice (p. 16) que ILS "identifica la solución mínima", pero nunca calculó el óptimo del caso real.
3. En el pseudocódigo de la heurística (Alg. 1, p. 11) `ṽ_p = v_p + β^time·TSP(B ∪ {n*})` suma sobre el acumulado `v_p` el tiempo del lote ampliado completo, que ya incluía el tiempo de `B`; además ignora setup y recolección. No afecta a la tesina, que no implementó esta heurística.
4. La ec. 16 (p. 7) se imprime como igualdad de flujos de entrada y salida (E-06).

---

## 8. Qué no pude verificar, y qué consulté

**PDFs leídos con `Read` (imágenes de página):**
- `logistics-07-00061 (1).pdf`: pp. 1-18 completas.
- Chen et al. 2013 (`5. An ant colony…`): pp. 1-6 (no leí pp. 7-9: resultados y conclusiones).
- Urzúa et al.: PDF pp. 2-3 (journal pp. 104-105; la cifra del 50-75 % está en la p. 1, verificada solo por texto); Gutiérrez et al. (FP366): pp. 1-2.
- Talbi (`Metaheuristics.pdf`): PDF pp. 73-75 (libro pp. 48-50), 146-148 (libro pp. 121-123), 150 (libro p. 125).
- Dorigo-Stützle (`aco-book.pdf`): PDF pp. 86-90 (libro pp. 71-75).
- Hoos-Stützle (`sls_handbook.pdf`): PDF p. 6. Matoušek-Gärtner: PDF p. 37 (libro p. 30). Lesch et al.: PDF p. 16 (revista p. 18620).

**Verificado solo con extracción de texto (`pdftotext`, en el directorio temporal de la sesión), sin ver la imagen de la página:** Alaya et al. (Tabla 1 y resumen), Roberti y Toth (pp. 117, 125-129), Hillier y Lieberman (búsqueda de términos; PDF de 1010 págs.), Rosenkrantz (§5), Babin (introducción), Hoos-Stützle (evaporación/depósito, PDF p. 13), resto de Lesch (resumen), números de página de Talbi/Dorigo/Matoušek obtenidos por búsqueda de texto. Usé `pdftotext` para *localizar* páginas y para estas verificaciones puntuales, lo que se aparta de la regla "solo `Read`"; los resultados centrales (paper, Chen, Talbi, Dorigo, Matoušek, Hoos, Lesch) están confirmados visualmente.

**No verificado:**
- Croes (1958), Baker y Scudder (1990), Kanet y Sridharan (2000): no hay PDF en `zpaper/`. No pude confirmar `cap2.tex:156-181` (objetivos regulares, tiempo ocioso insertado), `cap2.tex:224` ni `cap7.tex:126`.
- Hillier-Lieberman: no abrí las páginas; la afirmación 2^n (`cap2:41-43`) y la técnica de M grande (`cap2:46-63`) se apoyan en la presencia de la sección 11.3 ("Usos innovadores de variables binarias") y en búsqueda de texto, no en lectura.
- Dorigo-Stützle "acciones de demonio" y búsqueda local (`cap2:368-374`): ubiqué las páginas 52 y 178 del libro por texto, no las abrí. Stützle y Hoos 2000 (paper MMAS) no abierto.
- Talbi: `cap2:296-298` (información heurística) y `cap2:391-421` solo parcialmente (verifiqué rechazo, penalización lineal, estática; no abrí preservación ni penalización dinámica).
- Gutiérrez: no leí resultados cuantitativos (pp. 3-7), por lo que no puedo confirmar "significativamente" (E-09).
- Flipkart (no evaluado), Marco de TTL (plantilla).
- Referencias del paper original no incluidas en `zpaper/` ([7], [17], [18], [28], [29], etc.): solo se las usó como índice, no se leyeron.
- **Código**: solo consulté `main` para E-02 y E-08 (`models/opp_v4/opp_model_v4.zpl`, `tests/infra/factories/migrated_case.py`, comentarios de `opp_hc_4.py`, `opp_aco_4.py`, `route_construction.py`, `models/opp_aco_3/README.md`). No verifiqué que los tests de reducción v5 ↔ v4 pasen (no ejecuté nada).
- **Desfase `.tex` ↔ `tesina.pdf`**: `Capitulos/cap7.tex` se modificó el 16-nov 20:51 y `tesina.pdf` se compiló el 15-nov 23:04, así que el PDF puede no reflejar el texto actual de `cap7.tex`. Todas las líneas citadas son de los `.tex`. El listado de bibliografía y la ausencia de "[?]" sí se comprobaron en el PDF compilado.
- El texto de `Guias/context_style_guide.md` no tiene reglas de citación (búsqueda de "cita", "bibliogr", "fuente"), por lo que no evalué estilo de citas contra la guía.
