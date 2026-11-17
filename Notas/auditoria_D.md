# Auditoría D — Experimentos y resultados

Alcance: solo la sección D de `Notas/prompt_auditoria_tesina.md`. Solo lectura. No se ejecutó ningún test ni experimento.

- **Tesina leída completa**: `cap5.tex`, `cap6.tex`, `ap6.tex`, `ap7.tex`. De `resumen.tex`, `abstract.tex` y `cap7.tex` solo los pasajes con números o resultados.
- **Consulta puntual de `ap8.tex`**: secciones de variación entre semillas y presupuesto de HC (líneas 266–305 y 404–428). Las necesité para contrastar con `cap6.tex`. El resto de `ap8.tex` y `ap5.tex` no se auditó.
- **Código/resultados**: `/Users/lsoria/Desktop/tesina/linear-picking-routing`, rama `main` (HEAD `1545392`, 2026-11-10), árbol limpio. Leí directamente porque ya estaba en `main`. Los números se recalcularon con `python` sobre los CSV de `results/`, `experiments/` y `analysis/`. Para parámetros y valores por defecto consulté `dtos/`, `models/`, `tests/infra/` y `meta.md`.
- **Scripts auxiliares**: están en el scratchpad de la sesión, fuera del repo.

Convención de severidad del prompt: **Crítico** (falso o contradice código/datos), **Mayor** (omisión o explicación errónea importante), **Menor** (precisión, redacción).

---

## 1. Hallazgos

### D-1 · Crítico — El monolítico "no termina ninguno de los 19 escenarios de estrés" está medido solo en 7 de 19

**Dónde en la tesina**
- `cap6.tex:346` y `:360`: "el monolítico no termina ninguno de los 19 escenarios dentro del tope de 40 minutos".
- `cap6.tex:968-971`: la síntesis dice que el Split prueba el óptimo en 9 de 19 y que el monolítico "no logra" probarlo.
- `cap5.tex:15-16`: los escenarios se "ejecutaron con los dos modelos lineales".
- `cap5.tex:569-570`: "en estrés, los dos modelos resuelven los mismos 19 escenarios, y se compara cuáles terminan dentro del tope".
- `cap7.tex:38-40` y `:430-432`: "9 de los 19 … frente a ninguno del monolítico".
- Resumen y abstract: "es el único de los dos que lo prueba … en 9 de los 19".

**Evidencia en el repo**
- `results/opp_v5_1_mono/stress/output_opp_v5_1_mono_stress_tests.csv` tiene 19 filas: 01 `no_result`, y 02–19 `timeout` con la misma etiqueta "Ejecución detenida por timeout - 40".
- `meta.md:623` explica qué hay detrás:
  - Medidos de verdad: 01 (sin resultado) y 03–07 (timeout).
  - El 02 se canceló pasados los 40 min y **"la fila se cargó a mano"**.
  - **08–19 "figuran como timeout"**: la corrida se lanzó el 24-09, el usuario la cortó "por el tiempo que llevaba: ningún test terminó. No dejó CSV".
- `meta.md:403` confirma que 02, 03 y 08–19 de mono "no se corrieron" en esa fecha.
- Último commit del CSV: `fb864e3` (2026-09-29), "Unify opp_v5_1_mono stress results in one CSV". Esto unificó las etiquetas a "- 40".
- El 01 no es un timeout de 40 min: `meta.md:645` dice que compilar el monolítico del 100×100 llevó a ZIMPL a ~5 GB sin terminar. La tesina lo cuenta como "no termina dentro del tope".

**Qué dice vs. qué es correcto**
- La tesina presenta "0 de 19" como resultado medido.
- Medido: 0 de 7 (01–07), con el 01 sin resultado por memoria y el 02 cargado a mano.
- Los otros 12 (08–19) son una inferencia razonable, no una medición. Se apoya en:
  - estudios 08 y 11: con 6 lotes en 7×7 (estrés 04), a 40 min el monolítico tiene un gap de 143,5 %;
  - esos escenarios son más grandes que el 04.
- La conclusión es muy probablemente cierta, pero la forma de afirmarla no lo es.

**Sugerencia**
- Reformular en `cap6.tex:346` y `cap5.tex:569`: "el monolítico no termina ninguno de los 7 escenarios que se ejecutaron (01–07; el 01 sin resultado por memoria de ZIMPL). Los 08–19 no se ejecutaron: son más grandes que el 04, que ya no cierra a 40 min (Cuadro `tab:res_40min`)".
- Ajustar `cap7.tex:38-40` y `:430` a "de los 19, 9 resueltos por el Split; el monolítico, ninguno de los 7 que se ejecutaron".
- Alternativa: correr 08–19 del monolítico (12 × 40 min ≈ 8 h) y reemplazar las filas a mano por filas reales.

### D-2 · Mayor — Los resultados de HC (estrés y funcional) y de ACO funcional vienen de una versión anterior del código; la tesina afirma reproducibilidad y no lo declara

**Dónde en la tesina**
- `cap5.tex:425-432`: "la misma instancia, los mismos parámetros y la misma semilla producen siempre la misma solución" y los candidatos "se recorren siempre en el mismo orden".
- `cap5.tex:388`: una corrida por instancia con semilla 1.
- Cuadros afectados:
  - `cap6.tex:450-453` (brecha);
  - `cap6.tex:593-613` (tiempos y brechas de estrés);
  - `cap6.tex:820-829` (sin referencia);
  - `ap7.tex` (convergencia).
- Cifras repetidas en `resumen.tex:19`, `abstract.tex:16`, `cap7.tex:70` y `cap7.tex:445`: HC "a lo sumo a un 0,21 %".

**Evidencia en el repo**
- El commit `75d553c` ("Add sorted()", 2026-10-19) hizo determinista el orden de la ruleta en `models/utils/route_construction.py`.
- Fechas de los archivos de resultados:

  | Archivo | Última modificación | Código |
  |---|---|---|
  | `results/opp_hc_4/stress/output_opp_hc_4_stress_tests.csv` (soluciones `20260928_210210`) | 2026-09-29 | anterior al fix |
  | `results/opp_hc_4/functional/…` y `results/opp_aco_4/functional/…` (soluciones `20260929_*`) | 2026-09-29 | anterior al fix |
  | `results/equal_time/output_equal_time_opp_hc_4_20260927_195040.csv` | 2026-09-27 | anterior al fix |
  | `results/opp_aco_4/stress/output_opp_aco_4_stress_tests.csv` (commit `8779dbc`) | 2026-11-10 | posterior |
  | `results/opp_aco_4/seeds/…_20261102_193102.csv` | 2026-11-02 | posterior |
  | `results/opp_hc_4/budget/…_20261019_201951.csv` | 2026-10-19 | posterior |

- Contraste con HC (parámetros 200/60, semilla 1, código final, `results/opp_hc_4/budget`) frente al Cuadro de estrés (`results/opp_hc_4/stress`):
  - **17 de 18 escenarios difieren**, hasta 0,11 % entre sí (el 17).
  - Ejemplos: 03 da 1.765.744 en el estudio de presupuesto contra 1.767.172 en el cuadro; 15 da 98.043,9 contra 97.984,1.
  - Brecha de HC contra el Split en los 9 escenarios resueltos, con el código final: media 0,059 %, mediana 0,045 %, **máxima 0,18 % (el 11)**, 1 óptima. La tesina informa 0,055 / 0,042 / **0,21** / 1.
- Con ACO sí hay consistencia: la semilla 1 del estudio de semillas coincide exactamente con el CSV de estrés actual (18 de 18).
- Es la decisión "(D) Versión de las heurísticas" que estaba abierta en la guía de trabajo de `cap6` (borrada el 16/11) y que no pasó a `Notas/pendientes_cap7.md`.

**Qué dice vs. qué es correcto**
- Los números de HC que reporta la tesina no se obtienen con el código de `main`: son de la versión del 28–29/09.
- En la tesina se mezclan versiones: ACO estrés es del 10/11, HC estrés y ACO funcional del 29/09, el equal-time de HC del 27/09.
- Eso contradice `cap5.tex:425-432` y no se menciona en ningún lado.
- Con el código final, el máximo de HC baja de 0,21 % a 0,18 %. La conclusión cualitativa no cambia, pero las cifras del resumen y del abstract, sí.
- No pude recalcular el funcional de HC (40 de 45 óptimas) ni el de ACO con el código final sin ejecutar.

**Sugerencia**
- Opción (a): volver a correr HC (funcional y estrés), ACO funcional y el equal-time de HC con el código final. Después verificar con `run_compliance` y regenerar `results/comparability` y las tablas.
- Opción (b), si no se re-ejecuta: declarar en `cap5.tex` (cerca de `:388`) la versión de cada corrida, y reformular `:425-432` para limitar la reproducibilidad al código actual.

### D-3 · Mayor — El Cap. 6 omite que HC falla con otras semillas

(Ya resuelto: resumen, abstract y `cap7` acotan la afirmación con "en la corrida principal".)

**Dónde en la tesina**
- `cap6.tex:938-943` (alcance): reporta la variación entre semillas (medianas 0,02 % y 0,005 %) sin mencionar los fallos.

**Evidencia**
- `results/opp_hc_4/budget/output_opp_hc_4_budget_20261019_201951.csv`: **8 filas `infeasible`**.
  - Escenario 09, semilla 4: 4 filas, una por presupuesto.
  - Escenario 11, semilla 5: 4 filas.
  - Es decir, con el presupuesto 200/60, **2 de 90 ejecuciones** de HC no encuentran solución.
- `ap8.tex` y `cap7.tex` sí lo reconocen.
- ACO: 90 de 90 con solución (`results/opp_aco_4/seeds`).

**Qué dice vs. qué es correcto**
- El Cap. 6 llama "pequeña" a la variación entre semillas y no menciona los fallos de HC. Sí lo hace `cap6.tex:435` con "en este conjunto de instancias".

**Sugerencia**
- Mencionar el fallo en `cap6.tex:938-943` (HC: 2 de 90 ejecuciones sin solución; ACO: 0 de 90) y el máximo de cada heurística.

### D-4 · Mayor — El caso 30a: se presentan tiempos de *verificación* como tiempos de *resolución*, y una "probable causa" como confirmada

**Dónde en la tesina**
- `cap6.tex:45-54`: "La verificación … lo confirma. SCIP no terminó en 600 segundos con los lotes vacíos y terminó en 0,13 segundos sin ellos. El caso muestra por qué conviene eliminar los lotes vacíos antes de resolver."
- `cap7.tex:500-502`: "En el caso 30a, SCIP no terminó en 600 segundos con los lotes vacíos y terminó en 0,13 segundos sin ellos" (propuesta de trabajo futuro).

**Evidencia**
- `meta.md:655`: "sin ellos **se verifica** en 0,13 s; con ellos libres SCIP no cerraba en 600 s. **Probable causa** del timeout de los modelos lineales".
- Los 0,13 s y los 600 s son tiempos del verificador sobre una solución de la heurística (decisiones fijadas), no de resolver la instancia por optimización. Fijar rutas, asignación y secuencia es mucho más fácil que optimizar.
- El repo no tiene ninguna corrida de Split o monolítico sobre 30a sin los lotes vacíos.

**Qué dice vs. qué es correcto**
- `cap6` aclara "La verificación…", pero "lo confirma" y la conclusión sobre resolver exceden el dato.
- `cap7` lo presenta como si fuera la resolución.
- La causa es una hipótesis razonable (lotes vacíos intercambiables, ya argumentado en `cap3`), no una confirmación experimental.

**Sugerencia**
- `cap6.tex:50`: cambiar "lo confirma" por "es consistente con esto".
- Aclarar que los tiempos son los del verificador con las decisiones fijadas.
- `cap7.tex:500-502`: decir "al verificar una solución de 30a…".
- Idealmente, correr Split y monolítico sobre 30a con los 10 lotes vacíos quitados.

### D-5 · Mayor — Un párrafo contradice su propio cuadro (40 minutos)

**Dónde**
- `cap6.tex:314-317`: "Con un tope de 40 minutos, el monolítico sigue sin probar el óptimo **en esos puntos**".
- La tabla `tab:res_40min` (`cap6.tex:325-333`) tiene el punto "6 lotes, 5×5" con "¿Prueba el óptimo? sí" (32,0 min).

**Evidencia**
- `experiments/opp_v5/studies/11_mono_long_cap/points_20260923_232413.csv`: B6S5 mono `optimal`, `total_s` = 1917,5 s (≈ 8,3 veces los 231,7 s del Split).
- Los puntos que a 10 min no cerraban eran tres: 3 lotes 7×7, 4 lotes 6×6 y 6 lotes 5×5. De esos, a 40 min cierra uno.
- `experiments/opp_v5/README.md` lo dice así: "only 6 batches on 5×5 closes (32 min, 8× the split)".

**Sugerencia**
- Reescribir: "con 40 minutos el monolítico sigue sin probar el óptimo en dos de esos tres puntos (y en el escenario 04); el tercero (6 lotes, 5×5) lo cierra a los 32 minutos, 8 veces el tiempo del Split".
- Corregir también "Aumentar el tiempo disponible no cambia este resultado" (`:314`).

### D-6 · Mayor (trazabilidad) — `results/comparability/*.csv` no reproduce los números de ACO en estrés de la tesina

**Evidencia**
- `results/comparability/results_v5_vs_heuristics.csv`: último commit `08bd9b5`, 2026-09-29.
- Los resultados de ACO en estrés se re-corrieron el 10/11 (`8779dbc`).
- Diferencias:
  - Ese CSV da ACO óptima en 2 de 9 escenarios, con media 0,012 % y máxima 0,059 %.
  - La tesina y mi recálculo desde `results/opp_aco_4/stress` dan 3 de 9, 0,009 % y 0,044 %.
  - ACO 01: 988.252 en el CSV de `comparability` contra 909.168 en el actual; 2.094,8 s contra 1.892,3 s.
- `experiments/opp_v5/README.md` declara estos CSV como fuente de los informes generados (`docs/thesis/*_comparison.tex`).

**Qué es correcto**
- Los números de la tesina coinciden con el CSV de estrés actual, no con el de `comparability`.
- Quien regenere `build_heuristics_comparison.py` obtendrá cifras distintas de las de la tesina.

**Sugerencia**
- Regenerar `results/comparability` (`python -m analysis.comparability`) tras decidir D-2.
- Documentar de qué archivo sale cada cuadro de `cap6`.

### D-7 · Menor — "al menos 71 veces" (`cap6.tex:288-290`)

- El monolítico, 4 lotes en 6×6, se cortó a los 569,8 s (`experiments/opp_v5/studies/08_mono_frontier/frontier_20260923_201522.csv`, `total_s`, `status=timelimit`).
- El Split lo resuelve en 8,4 s, así que la cota inferior real es 569,8 / 8,4 ≈ **67,8**.
- El 71 sale de dividir el tope de 600 s, que el monolítico no llegó a consumir (SCIP tenía límite 570).
- Sugerencia: "al menos 68 veces". También conviene aclarar que el "tope de 10 minutos" fue un límite de SCIP de 570 s dentro de un corte duro de 600 s.

### D-8 · Menor — "con hasta 4 lotes resuelve cualquier grilla en menos de 10 segundos" (`cap6.tex:283-284`)

- En el estudio 08 no hay fila del Split para 4 lotes en 7×7: el monolítico figura `skipped` y falta la del Split. La figura solo llega a 6×6 con 4 lotes (8,4 s).
- Medido hasta 3 lotes en 7×7 (9,7 s) y 4 lotes en 6×6 (8,4 s).
- `cap6.tex:171` dice "con 1 a 6 lotes", pero la figura y la leyenda muestran 2, 3, 4 y 6.
- Sugerencia: acotar a "con 3 lotes en grillas hasta 7×7 y con 4 lotes hasta 6×6" y corregir "1 a 6" por "2 a 6" o explicar por qué se omite el 1.

### D-9 · Menor — Medianas contra mediana de cocientes (`cap6.tex:578-581`)

- La tesina dice: "en la mediana, el Split tarda 0,300 s, HC 0,061 y ACO 0,224, **de modo que** HC es 5,1 veces más rápido … y ACO, 1,4".
- Con esas tres medianas, 0,300 / 0,061 = **4,9** y 0,300 / 0,224 = **1,34**.
- Los 5,1 y 1,4 son la mediana de los cocientes por instancia (`results_v5_vs_heuristics.csv`: 5,14 y 1,44).
- Ambos números son correctos, pero el "de modo que" mezcla dos estadísticos. Aclarar: "la mediana del cociente por instancia es 5,1 y 1,4".

### D-10 · Menor — "En las 9 restantes, de alrededor de un segundo" (`cap6.tex:581`)

- Tiempos de ACO en esas 9 instancias: 0,29 / 0,32 / 0,44 / 0,98 / 0,98 / 1,01 / 1,07 / 1,14 / 1,14 s.
- Son de 0,3 a 1,1 s, no todas "alrededor de un segundo". Cambiar por "entre 0,3 y 1,1 s".

### D-11 · Menor — Paralelismo de la Etapa 1 (`cap6.tex:357-360`)

- La tesina dice: "reduce el tiempo de la Etapa 1 como mucho a la mitad (2,2 veces …)".
- Un factor de 2,2 deja el tiempo en ~45 %, es decir, **a menos de la mitad**. Los números (×2,2 en 13×13 y ×1,9 en 14×14) sí están bien (estudio 12: 242,8 → 110,4 s y 403,5 → 212,7 s).
- El argumento sobrevive: aunque el Split del 15×15 (904 s) tuviera todo su tiempo ×2,2, daría ~33 min, menos de 40.
- Corregir la frase por "hasta 2,2 veces" y usar 2,2 en el argumento.
- Nota: en la suite de estrés real la ganancia de la Etapa 1 fue menor, entre ×1,15 y ×1,82 según `meta.md:423`. Los 2,2 y 1,9 vienen de la medición controlada del estudio 12.

### D-12 · Menor — Ajustes del verificador "en pocos casos" (`cap6.tex:408-412`)

- En `results/compliance/opp_aco_4/stress/…csv`, **las 19 filas** tienen la nota "SCIP levels ran on the routes' subgraph", por ejemplo "49 of 49 nodes".
- En `results/compliance/opp_hc_4/stress/…csv` solo el 100×100 tiene esa nota (1.425 de 10.000 nodos y 2.900 de 39.600 arcos).
- Las dos corridas del verificador no tienen el mismo comportamiento de nota, o el recorte se aplica siempre y solo HC no lo anota.
- `ap6.tex:59-65` dice que se aplica "cuando todas las rutas están fijas", o sea casi siempre.
- El 100×100 es el único en el que "resultó necesario".
- Para ACO el CSV actual da 1.365 de 10.000 nodos y 2.965 arcos; para HC, 1.425. "Unas 1.500" (`cap6.tex:411`) queda alto. Mejor "unas 1.400".
- La afirmación sobre el caso 30a (10 lotes vacíos quitados) está confirmada.

### D-13 · Menor — Otros detalles de redacción o precisión

- `cap6.tex:925-926`: "en tres escenarios su solución inicial ya es la mejor". `ap7.tex` y `results/opp_hc_4/stress` muestran `best_found_at_iteration = 0` en cuatro: 01, 02, 07 y 16. El 01 no llega a iterar, así que son tres más el 01. Aclararlo.
- `cap6.tex:873-874`: "excedieron su presupuesto en a lo sumo 6 segundos". El máximo es **6,19 s** (monolítico, escenario 19). Poner "6,2 s".
- `cap6.tex:863`: "en el 09 la mejora por menos de un 0,01 %" es ambiguo. ACO (275.042,6) es 0,0085 % **peor** que el Split (275.019,3). Reescribir: "en el 09 el Split mejora a ACO por 0,01 %".
- `cap6.tex:62-71`: en la fila "Tiempo total: máximo", el cociente 11,27 es el cociente de los máximos (43,5 / 3,9). El máximo de los cocientes por par es 28,9 (caso 29), que el texto cita aparte. Agregar una nota.
- `ap7.tex:55` (caso 27): el objetivo figura "58,0", pero el CSV tiene 58,05. Poner "58,05" o "58,1".
- `cap6.tex:395-396`: "las 9 soluciones de estrés del Split se verificaron … y las 9 resultaron válidas". No hay CSV de compliance del Split en `results/compliance/`: solo existen las 9 soluciones JSON (`results/opp_v5_2_split/stress/solutions/20260929_155759/`) y la afirmación está en `meta.md:693`. Guardar el reporte de `python -m verification.compare_v5 --verify-split-stress` o citar el comando.
- `ap6.tex:64-65` ("248 soluciones … mismo veredicto") se apoya solo en `meta.md:646`; no hay artefacto en `results/`.
- `cap5.tex:355-357`: "la suite de estrés del Split se ejecutó con la Etapa 1 repartida en seis procesos". Por `meta.md:670`, el CSV combina corridas de distintas fechas:
  - los 9 resueltos se re-corrieron con 6 procesos (29/09);
  - 01 y 03 son de la corrida del 24/09;
  - 08 y 12–19 son del 26/09.
  - Solo está confirmado el paralelo para 16–19. Para los timeouts no importa el tiempo (todos son 40 min), pero la afirmación general no está verificada.

### D-14 · Menor — `compare_v5_split_vs_mono.csv` deduplica por nombre de método

- El Split tiene 64 filas funcionales y el CSV de comparación tiene 63, porque une por nombre de método. Los casos 02 y 03 comparten `test_two_orders_two_aisles` y colapsan.
- Los totales del CSV (28 / 21 / 12) coinciden con la tesina (49 pares, 21 óptimos alternativos, 11 infactibles + la 36c) solo por compensación: el CSV incluye la 37a, que la tesina excluye, y pierde uno de los duplicados.
- Recalculado por caso (clave `test_case_NN.método`): 60 pares, 49 resueltos, 11 infactibles. Coincide con `ap7.tex`.
- Sugerencia: unir por `caso.método` en `verification/compare_v5.py` o documentar la colisión.

### D-15 · Menor — Cambio reciente: "35 de las 45" y las medianas de tiempo no se reproducen con el CSV

- **Tesina:** `cap6.tex:575-581` ahora dice que los tiempos se comparan "sobre 35 de las 45 instancias comparables", con medianas de 0,295 s (Split), 0,061 s (HC) y 0,225 s (ACO), y "HC fue más rápido … en las 35 instancias".
- **Recalculado** (`results/comparability/results_v5_vs_heuristics.csv`, nivel funcional, instancias comparables en objetivo): hay 45, de las cuales 33 vienen de pruebas con una sola instancia, con medianas 0,3001 / 0,0609 / 0,2244 s, HC más rápido en 33 y ACO en 24. Los 35 salen de sumar los casos 02 y 03, que comparten el nombre de método y por eso el CSV los trata como si fueran un caso de dos instancias.
- **Qué falta:** si se incluyen 02 y 03, hay que decir cómo se obtuvo su tiempo (el CSV guarda una sola fila del Split para el nombre compartido) y recalcular las medianas; el 0,295 y el 0,225 no salen de los datos disponibles.
- **Sugerencia:** o volver a 33 (con las medianas 0,300 / 0,061 / 0,224) o regenerar el CSV por `caso.método` (ver D-14) y recalcular.

---

## 2. Tabla de trazabilidad: experimento ↔ script ↔ resultado

| # | Experimento (tesina) | Dónde | Script / comando | Archivo de resultados | Estado |
|---|---|---|---|---|---|
| E1 | Pruebas funcionales de Split y monolítico: 38 casos, 64 y 63 pruebas, tope 25 min | `cap5` §5.3 | `python -m tests.run_suite opp_v5_2_split functional` y `opp_v5_1_mono functional` (`tests/run_suite.py`; `TEST_TIMEOUT_MINUTES=25` en `tests/infra/execution/config.py:8`) | `results/opp_v5_2_split/functional/…_tests.csv` (64 filas), `results/opp_v5_1_mono/functional/…_tests.csv` (63 filas) | ✓ 64 / 63 y diferencia 24b confirmadas |
| E2 | Monolítico contra Split: 60 pares, 49 resueltos, 11 infactibles, óptimos alternativos | `cap5` §5.5, `cap6` §6.1.1, `ap7` | `python -m verification.compare_v5` | `results/comparability/compare_v5_split_vs_mono.csv` más los dos CSV funcionales | ✓ (ver D-14) |
| E3 | HC y ACO sobre 68 de 70 instancias capturadas del Split (semilla 1, parámetros por defecto) | `cap5` §5.3 y §5.6 | `tests/opp_hc_4|opp_aco_4/functional/test_case_v5_equivalence.py` (`tests/infra/factories/v5_equivalence.py`, seed 1) | `results/opp_hc_4/functional/…tests.csv`, `results/opp_aco_4/functional/…tests.csv`; `results/comparability/*.csv` | ✓ 70 / 68 / 67 / 45 / 10 / 12 recalculados. Código anterior al fix (D-2) |
| E4 | Estrés, 19 escenarios, tope 40 min, 4 métodos | `cap5` §5.4, `cap6` | `python -m tests.run_suite <modelo> stress`. `STRESS_TEST_TIMEOUT_MINUTES` es 25 por defecto; 40 viene de `.env.example:12`. Mismos generadores en los 4 métodos (`realistic_crew_scenario`, `migrated_stress_scenario`) | Split: `…v5_2_split_stress_tests_parallel.csv`; monolítico: `…v5_1_mono_stress_tests.csv`; HC: `results/opp_hc_4/stress/…csv` (29/09); ACO: `results/opp_aco_4/stress/…csv` (10/11) | Split ✓ (9 resueltos). **Monolítico: solo 01–07 medidos (D-1)**. **HC y ACO de versiones distintas (D-2)** |
| E5 | Verificación contra el monolítico: 150 soluciones | `cap5` §5.5, `cap6` §6.2, `ap6` | `python -m verification.run_compliance` | `results/compliance/opp_{hc,aco}_4/{functional,stress}/…csv` | ✓ 56 + 19 por heurística, 0 violaciones, nivel 2 = objetivo informado. Las 9 del Split sin CSV (D-13) |
| E6 | A igual tiempo (HC y ACO como presupuesto) | `cap5` §5.5, `cap6` §6.3.6 | `python -m analysis.run_equal_time_study --budget-from opp_hc_4 | opp_aco_4` | `results/equal_time/output_equal_time_opp_hc_4_20260927_195040.csv`, `…opp_aco_4_20261110_134358.csv` | ✓ todos los números del Cuadro de ACO. HC: presupuestos de la corrida anterior, declarado en `cap6.tex:855` |
| E7 | Escala: misma instancia en grillas 3×3 a 7×7, tope 10 min (figura y Cuadro `tab:res_tamano_mip`) | `cap6` §6.1.3 | `python -m experiments.opp_v5.exploration --study 08_mono_frontier --frontier …` (comando en `experiments/opp_v5/README.md`) | `experiments/opp_v5/studies/08_mono_frontier/frontier_20260923_201522.csv` | ✓ figura y tamaños de MIP coinciden; "71" es 68 (D-7); gaps en D-8 |
| E8 | Monolítico con 40 min (`tab:res_40min`) | `cap6` §6.1.3 | `exploration --points points.json` (study 11, `hard_cap_s` 2430) | `…/11_mono_long_cap/points_20260923_232413.csv` | ✓ valores del cuadro; el texto lo contradice (D-5) |
| E9 | Paralelismo de la Etapa 1: ×2,2 (13×13) y ×1,9 (14×14), rutas idénticas | `cap5` §5.4, `cap6` §6.1.4 | `exploration --points points.json` (study 12) | `…/12_stage1_parallel/points_20260924_100156.csv` | ✓ 242,8→110,4 (×2,20) y 403,5→212,7 (×1,90). "Como mucho a la mitad" (D-11) |
| E10 | Variación entre semillas, 5 semillas, estrés 02–19 | `cap5` §5.6 (cita), `cap6` alcance | HC: `analysis/run_hc_budget_study.py` (filas 200/60). ACO: `analysis/run_aco_seed_study.py` | `results/opp_hc_4/budget/…_20261019_201951.csv`, `results/opp_aco_4/seeds/…_20261102_193102.csv` | ✓ medianas 0,0155 % (HC) y 0,0046 % (ACO); `ap8` coincide. Omite fallos de HC (D-3) |
| E11 | Presupuesto de iteraciones de HC; sensibilidad α, β, ρ; ablación de ACO | `cap5` §5.6 remite a `ap8` | `analysis/run_hc_budget_study.py`, `run_aco_pheromone_study.py`, `run_aco_ablation_study.py` | `results/opp_hc_4/budget`, `results/opp_aco_4/{pheromone,ablation}` | Solo verifiqué el presupuesto de HC (82 de 88 por estancamiento; mejoras ≤ 0,59 %). Pheromone y ablación **no auditados** (`ap8`, fuera de alcance) |
| E12 | Relevamiento (estudios 01–07), cap5 §5.4.1 y `ap5` | `cap5` §5.4.1 | `experiments/opp_v5/studies/01…07` | CSV de `studies/01…07` | **No verificado** (`ap5` fuera de alcance) |

---

## 3. Tabla de números: valor en tesina ↔ repo/recalculado ↔ coincide

### 3.1 Monolítico contra Split, funcionales (`cap6` §6.1.1–6.1.2, `ap7`)

| Valor | Tesina | Recalculado | OK |
|---|---|---|---|
| Pares comparables | 60 | 60 (63 − 30a − 36c − 37a) | ✓ |
| Pares resueltos / infactibles | 49 / 11 | 49 / 11 | ✓ |
| Máxima diferencia de objetivo | 3,83·10⁻⁶ (casos 13 y 14) | 3,8346·10⁻⁶ (rel. 1,2·10⁻⁹) | ✓ |
| Óptimos alternativos: rutas / asignación | 21: 13 / 16 | 21: 13 / 16 (5 solo rutas, 8 solo asignación, 8 ambas) | ✓ |
| Tiempo total, suma mono / Split / cociente | 140,3 / 24,4 / 5,75 | 140,33 / 24,41 / 5,750 | ✓ |
| Tiempo total, mediana | 0,225 / 0,309 / 0,73 | 0,2248 / 0,3092 / 0,727 | ✓ |
| Tiempo total, máximo | 43,5 / 3,9 / 11,27 | 43,53 / 3,86 / 11,27 (cociente de máximos; el máximo de cocientes es 28,9) | ✓ (ver D-13) |
| Tiempo del resolvedor, suma | 124,8 / 7,2 / 17,35 | 124,76 / 7,19 / 17,35 | ✓ |
| Tiempo del resolvedor, mediana | 0,007 / 0,003 / 2,33 | 0,0066 / 0,0028 / 2,33 | ✓ |
| Monolítico más rápido en 38 de 49 | 38; 37 %–98 % | 38; 36,6 %–98,1 % | ✓ |
| Mayor cociente por par | 28,9× (caso 29) | 28,895 | ✓ |
| `ap7` Cuadro de pares (49 filas) y de infactibles (11): tiempos, cocientes y objetivos | — | las 60 filas coinciden con los CSV (tiempos a 3 decimales, cocientes, objetivos); única diferencia: caso 27, objetivo 58,0 contra 58,05 | ✓ (salvo redondeo del 27) |
| Figura de dispersión: 49 puntos | 49 | 49, desvío máximo 0,05 % respecto de los CSV | ✓ |

### 3.2 Escala y 40 minutos (`cap6` §6.1.3)

| Valor | Tesina | Repo | OK |
|---|---|---|---|
| 3 lotes: 5×5 → 6×6 (monolítico) | 9 s → 139 s | 8,6 → 138,8 s | ✓ |
| Cociente máximo donde ambos prueban | 27× (3 lotes, 6×6) | 138,8 / 5,1 = 27,2 | ✓ |
| Cociente mínimo donde el monolítico no prueba | "al menos 71×" (4 lotes, 6×6; Split 8,4 s) | 569,8 / 8,4 = 67,8 | ✗ (D-7) |
| No prueba: 3 lotes 7×7, 4 lotes 6×6, 6 lotes 5×5 | sí | `timelimit` en las tres | ✓ |
| 4×4 infactible | sí | `infeasible` / `stage1:infeasible` en todas | ✓ |
| Cuadro `tab:res_tamano_mip` (variables y restricciones, 7 filas) | 327/573 … 1.206/1.804; Etapa 2 174/339 y 234/460 | idénticos (`n_vars`, `n_conss`) | ✓ |
| Cuadro `tab:res_40min`: Split (s) | 8,2 / 9,5 / 231,7 / 181,4 | 8,2 / 9,5 / 231,7 / 181,4 | ✓ |
| `tab:res_40min`: tiempo monolítico | 40,0 / 40,0 / 32,0 / 40,0 min | 2.399,7 / 2.399,6 / 1.917 / 2.399,5 s | ✓ |
| `tab:res_40min`: distancia al óptimo | 0,05 / 0,00 / 0,00 / 0,66 % | 0,0547 / 0,00 / 0,00 / 0,6604 | ✓ |
| `tab:res_40min`: gap informado | 11,0 / 10,4 / – / 143,5 % | 11,01 / 10,37 / – / 143,52 | ✓ |
| Texto: "no prueba el óptimo en esos puntos" | las tres | solo dos; el 6 lotes 5×5 cierra a 32 min | ✗ (D-5) |

### 3.3 Estrés: Split, HC, ACO (`cap6` §6.1.4 y §6.3; `ap7`)

| Valor | Tesina | Recalculado | OK |
|---|---|---|---|
| Split termina | 9 de 19; máximo 15,1 min | 9; 904,1 s = 15,07 min | ✓ |
| Monolítico termina | 0 de 19 | 0 de 7 medidos; 12 no ejecutados | ✗ (D-1) |
| Tiempos Split / HC / ACO, 19 filas del Cuadro `tab:res_estres_tiempos` | ver cuadro | coinciden con los CSV de estrés (redondeos; Split 10 reemplazado, declarado) | ✓ |
| Brechas HC y ACO por escenario (9 resueltos) | 0,00–0,21 / 0,00–0,04 % | iguales (HC 11: 0,214; ACO 11: 0,044) | ✓ contra el CSV (HC pre-fix, D-2) |
| Estrés: HC óptimas / media / mediana / máx. | 1 / 0,06 / 0,04 / 0,21 % | 1 / 0,0554 / 0,0416 / 0,2144 | ✓ |
| Estrés: ACO óptimas / media / mediana / máx. | 3 / 0,01 / 0,01 / 0,04 % | 3 / 0,0092 / 0,0062 / 0,0444 | ✓ |
| ACO mejor que HC | 8 de 9 | 8 de 9 (02 empata) | ✓ |
| Mediana del cociente de tiempos | 53,1 (HC) / 1,5 (ACO) | 53,09 / 1,51 | ✓ |
| Escenarios sin referencia: 10; ACO mejor en 9; 01 +5,39 % | sí | 10; 9; +5,39 % | ✓ |
| Cuadro `tab:res_sin_referencia` (10 filas) | ver cuadro | coinciden | ✓ |
| HC 01: 17 min, 0 iteraciones; ACO 01: 32 min, 2 iteraciones | sí | 1.029,2 s; 0 it.; 1.892,3 s; 2 it. | ✓ |
| ACO 14×14 | ~94 s | 94,4 s | ✓ |
| Memoria: mediana HC / ACO | 27 / 30 MB | 26,6 / 29,7 | ✓ |
| Memoria 100×100 y pico de ACO 09 | 867 y 907 / 1.672 MB | 867,4 / 907,1 / 1.672,2 | ✓ |
| Memoria Split | 76–287 MB | 75,8–287,1 | ✓ |
| Nivel de servicio (11): Split / HC / ACO | 97,4 / 96,8 / 97,4 % | idénticos | ✓ |
| Nivel de servicio del resto (04–19; 01–03 en 0 %) | 100 % | idénticos (`ap7` `tab:res_sla`, 19 filas) | ✓ |
| HC: iteraciones 60–157, 200 en 03 y 17 | sí | sí | ✓ |
| HC: "mejor en la inicial" en tres escenarios | 3 | 4 (01, 02, 07, 16) | ~ (D-13) |
| ACO mejor solución entre iteración 1 y 56; la mitad después de la 30 | sí | 1–56; 9 de 18 > 30 | ✓ |
| `ap7` `tab:res_convergencia` (19 filas × 5 columnas) | ver cuadro | coincide fila por fila | ✓ |
| Figuras de brecha, tiempo y brecha-vs-tiempo | — | verificadas punto a punto (57 barras de tiempo, 9 de brecha, 9+9+9 puntos) | ✓ |
| Parámetros del perfil realista (semilla 20260922, 4/5, 0,8 y 1,2, fechas 60–140 %, M = 10⁶, C_v = 1,5 × carga, T_cold = 10⁹, W_c = 27) | `tab:perfil_realista` | `stress_scenarios_v5_designed.py` y CSV de estrés | ✓ |
| Escenarios: lotes, pickers, pedidos y grilla de los 19 | `tab:escenarios_estres` | coinciden con N, B, P, V de los CSV de HC y ACO | ✓ |
| Parámetros de HC y ACO | `tab:hc_parametros`, `tab:aco_parametros` | 500/30/30 s (`dtos/hc/solve_hc_model_dto.py`); estrés 200/60 (CSV); ACO m=15, 60 it., 1.800 s, α=1, β=2,5, ρ=0,15, Q=100 (`dtos/aco/…`, `models/opp_aco_4/opp_aco_4.py:225-236`); semilla 1 (`v5_scenario_adapter.py`) | ✓ |

### 3.4 HC y ACO frente al Split, funcionales (`cap5` §5.3, `cap6` §6.3)

| Valor | Tesina | Recalculado | OK |
|---|---|---|---|
| Instancias: Split 70, HC/ACO 68 | sí | 70 (`results_v5_vs_heuristics.csv`) / 68 | ✓ |
| Comparables en estado / objetivo | 67 / 45 | 67 / 45 | ✓ |
| Solo estado: 12 infactibles + 10 con espera | 22 | 12 + 10 | ✓ |
| No comparadas | 30a, 36c, 37a | las tres | ✓ |
| HC: óptimas / media / mediana / máx. | 40 / 0,36 / 0,00 / 5,88 % | 40 / 0,363 / 0 / 5,88 | ✓ |
| ACO: óptimas / media | 45 / 0,00 % | 45 / 0 | ✓ |
| `tab:res_fallos_hc` (5 filas, valores y brechas) | ver cuadro | coinciden | ✓ |
| `tab:res_espera` (10 filas, objetivos Split/HC/ACO y lotes que esperan) | ver cuadro | coinciden | ✓ |
| Factor "casi 29" (26b) y "30 %" (01, 33c) | sí | 28,8× y 1,30× | ✓ |
| Tiempos: instancias; medianas | 35 de las 45; 0,295 / 0,061 / 0,225 s (texto actual de `cap6.tex`) | 33 (pruebas de una instancia); 0,3001 / 0,0609 / 0,2244 | ✗ (D-15) |
| HC más rápido; ACO más rápido | 35 y 24 (texto actual) | 33 y 24 | ✗ (D-15) |
| Cociente "5,1" y "1,4" | "de modo que" las medianas | mediana de cocientes 5,14 y 1,44; cociente de medianas 4,93 y 1,34 | ~ (D-9) |

### 3.5 Verificación (`cap6` §6.2)

| Valor | Tesina | Recalculado | OK |
|---|---|---|---|
| Funcionales: 68 instancias, 56 válidas, 12 sin solución (HC y ACO) | sí | 68; 56 `compliant`; 12 `skipped` | ✓ |
| Estrés: 19 de 19 válidas | sí | 19 `compliant` | ✓ |
| Total verificadas | 150 | 56+19 por heurística, 2 heurísticas | ✓ |
| Nivel 2 = objetivo informado | todas | desvío 0 en las 107 funcionales y las 19 de estrés (HC y ACO) | ✓ |
| Nivel 1 hasta 96 % menor (26b) | sí | −96,5 % (HC) y −96,3 % (ACO) | ✓ |
| 30a: se quitan 10 lotes vacíos | sí | nota "dropped 10 empty batch(es)" | ✓ |
| Subgrafo 100×100 "unas 1.500 de 10.000" | sí | HC 1.425, ACO 1.365 | ~ (D-12) |
| 9 soluciones de estrés del Split válidas | sí | sin CSV; solo `meta.md:693` | No reproducible |

### 3.6 A igual tiempo (`cap6` §6.3.6)

| Valor | Tesina | Recalculado | OK |
|---|---|---|---|
| Presupuestos de HC | 0,5–6 s; 01 ≈ 20 min | 0,452–5,714 s; 1.208,8 s (20,1 min) | ✓ |
| Ningún modelo obtiene solución con el tiempo de HC | sí | 38 de 38 filas sin `obj_val` | ✓ |
| Presupuestos HC difieren de los tiempos del cuadro en menos de 1 s; 01 en ~3 min | sí | máx. 0,84 s; 01: +179,6 s | ✓ |
| Presupuestos de ACO | 14–357 s; 01 ≈ 32 min | 14,1–356,6 s; 1.892,3 s | ✓ |
| Split con solución en 15 de 19 | sí | 15 | ✓ |
| 7 escenarios a menos de 0,1 % (04, 05, 06, 09, 10, 12, 13) | sí | sí (máx. 0,085 % en el 06) | ✓ |
| Brechas del Cuadro `tab:res_igual_tiempo_aco` (15 valores) | ver cuadro | coinciden (02 −0,78; 03 −0,66; 14 −29,99; 15 −15,23; 16–19: −46,17 / −57,01 / −54,95 / −58,46) | ✓ |
| Objetivos del monolítico en 04 y 12 | 157.569,7 y 222.183,9 (+5,3 y +10,5 %) | 157.569,7 y 222.183,9 | ✓ |
| 01, 07, 08: Etapa 1 sin rutear todo; 11: rutas no elegibles por frío | sí | `stage1_timelimit` (×3), `stage1_routes_not_cold_chain_eligible` | ✓ |
| Exceso de presupuesto "a lo sumo 6 s" (salvo 01) | 6 s | 6,19 s | ~ (D-13) |
| Monolítico 01: 59 min, casi el doble del presupuesto | sí | 3.537,6 s = 58,96 min; 1,87× | ✓ |

### 3.7 Semillas y presupuesto (consultados en `ap8`)

| Valor | Tesina | Recalculado | OK |
|---|---|---|---|
| Variación entre semillas: mediana HC / ACO | 0,02 % / 0,005 % (`cap6.tex:942`) | 0,0155 % / 0,0046 % | ✓ |
| HC: máximos | 0,44 % (03); 0,12 % (17); resto < 0,1 % | 0,444; 0,117; 15: 0,0985 | ✓ |
| ACO: máximo y resto | 0,053 % (11); resto ≤ 0,016 % | 0,0530; 05: 0,0154 | ✓ |
| ACO: brecha contra el Split entre 0 y 0,072 % | `ap8.tex` (sección de semillas de ACO, líneas ~404-428) | 0 a 0,0722 % | ✓ |
| HC con 200/60: 82 de 88 por estancamiento | `ap8.tex` (sección de presupuesto, líneas ~266-288) | 82 `Max_imp` + 6 `Max_it` = 88 | ✓ |
| HC: mejoras con presupuestos mayores | hasta 0,59 % (03); ≤ 0,11 % | mínimo delta −0,5877 %; −0,1063 % | ✓ |
| HC: 2 escenarios sin solución con una semilla | 09 y 11 | 09 semilla 4; 11 semilla 5 | ✓ (D-3) |

---

## 4. Experimentos o resultados del repo no reportados (o no reportados donde corresponde)

**Debería estar**
- La **procedencia de cada CSV** (qué corrida, qué fecha y qué versión del código) y la mezcla de versiones (D-2). Hoy solo se declara para el Split del escenario 10 y los presupuestos de HC.
- Los **8 `infeasible` de HC** en el estudio de presupuesto: están en `ap8`, pero no en `cap6` ni en el abstract (D-3).
- Las **corridas reales del monolítico en estrés**: solo 01–07 (D-1).
- El reporte de **verificación de las 9 soluciones del Split** (D-13).

**Detalle que puede omitirse (con justificación)**
- Resultados de los modelos heredados `opp_v3`, `opp_v4`, `opp_hc_1…3` y `opp_aco_1…3`, incluidos los de congestión (`results/opp_v3`, `opp_v4`, `opp_hc_1…3`, `opp_aco_1…3`). Quedan fuera del problema de la tesina (sin congestión, `cap7`).
- `results/opp_*/stability/*_20260911_*.csv` (30 semillas × 3 instancias × 6 modelos, versiones anteriores) y `analysis/run_stability_study.py`. Los reemplaza el estudio de semillas sobre los escenarios de estrés.
- `analysis/output/report.md` y las figuras de `analysis/output/`. El propio comentario de la guía de `cap6.tex` (líneas 1025-1027) dice que `report.md` mezcla tests no equivalentes (brechas de hasta 1.180 %) y no debe usarse.
- `experiments/opp_v5/reports/*` y `docs/thesis/*.tex` generados: son otra presentación de los mismos datos.
- Estudios 01–07 de `experiments/opp_v5/studies/`: probablemente están en `ap5`, no auditado.
- Estudios 09 y 10 del monolítico (`09_shared_with_split`, `10_mono_scale_axes`: el monolítico no prueba ninguna de las 15 instancias de los estudios del Split en 300 s, y en 7 de 15 no encuentra solución factible; los 25 óptimos coinciden con el Split). No aparecen en `cap5`, `cap6` ni `ap7`, aunque refuerzan "el monolítico no escala". Pueden estar en `ap5`; no lo verifiqué.
- Funcionales: la agrupación `migrated` (44) / `own` (19) de `compare_v5_split_vs_mono.csv`.

---

## 5. Qué no pude verificar y por qué

- **Ejecución de tests y experimentos**: por instrucción, no corrí nada. Todo lo "no reproducible con `main`" (D-2) está inferido de fechas de commit y de la comparación entre CSV, no de una re-ejecución. En particular, no recalculé el funcional de HC (40 de 45) ni el de ACO con el código final.
- **Versiones de software** de `cap5.tex:30-37` (Python 3.13, ZIMPL 3.6.2, SCIP 9.2.3, SoPlex 7.1.5, PySCIPOpt 5.6.0):
  - `requirements.txt` solo pide `pyscipopt>=5.6.0`.
  - CI usa Python 3.12 y 3.13.
  - Las versiones de SCIP, ZIMPL y SoPlex no están registradas en el repo.
- **Hardware** (i7-1360P, 4 P + 8 E): no está en el repo.
- **`cap5.tex:331-337`**: el "tiempo de reloj varía hasta el doble" y los factores "1,6 y 2,3" de resoluciones en paralelo vienen de `ap5` (fuera de alcance). `experiments/opp_v5/README.md` habla de "2–3x" para el estudio 05; no encontré los 1,6–2,3 en `meta.md`.
- **Cuadro de escenarios y perfil realista** (`cap5.tex`): verifiqué lotes, pickers, pedidos, grilla, W_c, T_cold, C_v, M, semilla y fechas contra el generador y los CSV. No revisé la columna "Etapa" (criterio de diseño, no un dato).
- **"Datos idénticos en los 19 escenarios"** (`cap5.tex:553-556`): confirmé que los cuatro tests de estrés usan las mismas llamadas a `realistic_crew_scenario` y `migrated_stress_scenario` y que N, B, P y V de HC y ACO coinciden. El CSV del Split no guarda esas columnas, así que no pude comparar ese lado a nivel de datos.
- **Estudios 01–07 (relevamiento)** y los resultados de `pheromone` y `ablation` de ACO: fuera de alcance (`ap5` y `ap8`).
- **Figuras de memoria y de dispersión funcional de `ap7`**: verifiqué la de dispersión de `cap6` punto a punto, y las de brecha, tiempos y brecha contra tiempo. La de memoria (`ap7`) y la de tiempos funcionales (`ap7`) las contrasté solo en cantidad de puntos y en los valores del texto (33 puntos por heurística; medianas y conteos). No re-derivé cada barra.
- **Documentación generada** (`docs/thesis/*.tex` y PDF): no la leí.
