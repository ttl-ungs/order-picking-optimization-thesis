# Auditoría D: experimentos y resultados

Alcance: solo la sección D del prompt de auditoría. Se leyeron `Capitulos/cap5.tex`, `Capitulos/cap6.tex`,
`Apendices/ap7.tex`, `Apendices/ap6.tex` y los párrafos con números de `resumen.tex`, `abstract.tex` y
`cap7.tex`. En el repo de código (`linear-picking-routing`, rama `main`, commit `1cec940`, working tree limpio)
se leyeron `experiments/`, `scripts/` y `results/`, y otros módulos solo de forma puntual. **En `main` no existe
el directorio `analysis/`**. No se ejecutaron tests ni experimentos: todos los números se recalcularon con
`python3` a partir de los CSV guardados.

Convenciones: `tesis:` = `picking-route-optimization-thesis/`, `repo:` = `linear-picking-routing/` (main).

---

## 1. Resumen ejecutivo (los 10 problemas más graves de D)

| # | Sev. | Problema | Ubicación |
|---|---|---|---|
| 1 | Crítico | "Quedan así 60 pares": son 66 (70 − 4 excluidas). El Capítulo 6 dice 66 y los datos dan 66. | cap5.tex:562 |
| 2 | Mayor | La corrida principal de HC en estrés (19 soluciones del 2026-09-28) es anterior al commit `75d553c` (2026-10-19), que hizo determinista la construcción de rutas. Con el código actual, la semilla 1 da otro objetivo en 17 de 18 escenarios. Ni la tesis ni el repo reprodujeron los números de HC en estrés con el código vigente, y la robustez de HC se midió sobre otra versión que la corrida que se informa. | cap5.tex:386, 423-428; cap6.tex:951-956 |
| 3 | Mayor | El monolítico no corrió los escenarios de estrés 05 a 19 con los mismos datos: usó `W_c = 9` y no 27 (`repo:results/README.md:20`). La tesis afirma que los datos de los 4 métodos son idénticos en los 19 escenarios. | cap5.tex:551-554, 567-568; cap6.tex:351 |
| 4 | Mayor | "Con un tope de 40 minutos, el monolítico sigue sin probar el óptimo en esos puntos", pero el propio Cuadro tab:res_40min (y el estudio 11) muestra que con 6 lotes en 5×5 sí lo prueba, en 32 min. | cap6.tex:320-322 vs 337 |
| 5 | Mayor | "En los que no lo prueba, al menos 71 veces más": vale solo para 4 lotes en 6×6, y aun ahí es 68× con el tiempo medido (569,8 s / 8,4 s). Para 6 lotes en 5×5 la cota es 2,6× y para 3 lotes en 7×7, 59×. | cap6.tex:294-296 |
| 6 | Mayor | Tiempos funcionales sobre "35 de las 45" instancias porque "el registro del Split guarda una fila por prueba". El runner actual y el CSV vigente guardan una fila por instancia con su propio tiempo, y el Anexo (tab:res_pares) ya usa esos tiempos por variante. Con las 45 instancias, las cifras cambian: HC es más rápido en 45/45 y ACO en 28/45. | cap6.tex:585-593; ap7.tex:103-105 |
| 7 | Mayor | "Los ajustes del verificador se usaron en pocos casos [...] En el escenario de 100×100, resolvió sobre el subgrafo". En realidad, el subgrafo se usó en **las 19** soluciones de estrés de ACO y en 3 funcionales de cada heurística. | cap6.tex:413-416 |
| 8 | Menor | "ACO tarda entre lo mismo que el Split y 6 veces menos": en el escenario 04, ACO es un 15 % **más lento** que el Split (14,1 s contra 12,3 s). Se repite en resumen, abstract y cap7. | cap6.tex:731-732; resumen.tex:20-21; abstract.tex:19-20; cap7.tex:455-456 |
| 9 | Menor | "HC es 5,1 veces más rápido [...] y ACO, 1,4" se presenta como consecuencia de las medianas 0,295/0,061/0,225, cuyos cocientes dan 4,8 y 1,3. El 5,1 y el 1,4 son medianas de los cocientes por instancia. | cap6.tex:588-590 |
| 10 | Menor | Varias afirmaciones no tienen respaldo en `results/` ni en `experiments/`: "las 9 soluciones de estrés del Split resultaron válidas", "2-opt se eligió 86 veces", "las 60 iteraciones llevarían unas 5 horas", "600 s con lotes vacíos y 0,13 s sin ellos", "51 s con 6 procesos y 46 en secuencia" y "248 soluciones". | cap6.tex:400-401, 474-479, 735-736, 51-52; cap5.tex:345-347; ap6.tex:64-65 |

El resto de los números verificados (unos 400 valores) coincide con los CSV. El detalle está en las Tablas de §4.

---

## 2. Hallazgos

### D1 (Crítico): cantidad de pares monolítico–Split
- **Tesina:** `cap5.tex:557-562`: "Quedan afuera cuatro: la 24b [...], la 30a [...], la 36c [...] y la 37a [...]. Quedan así 60 pares."
- **Evidencia:** el Split tiene 70 instancias funcionales (`repo:results/opp_split/functional/output_opp_split_functional_tests.csv`, 70 filas), y 70 − 4 = 66. El cálculo sobre los CSV da 55 pares con óptimo y 11 infactibles, es decir, 66. `cap6.tex:23` y `cap7.tex:54` dicen 66.
- **Correcto:** 66 pares.
- **Sugerencia:** reemplazar "60" por "66" en cap5.tex:562.

### D2 (Mayor): la corrida principal de HC en estrés no corresponde al código actual
- **Tesina:** `cap5.tex:386` ("HC y ACO se ejecutan una vez por instancia, con semilla 1") y `cap5.tex:423-428` ("la misma instancia, los mismos parámetros y la misma semilla producen siempre la misma solución [...] también entre procesos distintos"). `cap6.tex:951-956` y `cap7.tex:470-475` presentan la robustez entre semillas como una medida de esa misma corrida.
- **Evidencia:**
  - `repo:results/opp_hc/stress/output_opp_hc_stress_tests.csv`: las 19 filas apuntan a `solutions/20260928_210210/`.
  - El commit `75d553c` (2026-10-19 20:18, "Add sorted()", `models/utils/route_construction.py`) hace determinista el sorteo de rutas. El commit `c1f3a09` lo confirma: "Since 75d553c [...] the heuristics no longer depend on PYTHONHASHSEED". Ese commit volvió a resolver solo las funcionales, no las de estrés.
  - El estudio de semillas `repo:results/opp_hc/budget/output_opp_hc_budget_20261019_201951.csv` se corrió después del fix. En él, la semilla 1 con 200/60 da otro objetivo que la corrida principal en 17 de 18 escenarios. Por ejemplo, en el escenario 11 da 182.581,9 contra 182.644,4 (brecha de 0,18 % en vez de 0,21 %), y en el 15, 98.043,9 contra 97.984,1. En ACO, en cambio, la semilla 1 del estudio reproduce exactamente la corrida principal en los 18 escenarios.
- **Correcto:** la determinación por semilla vale para el código actual, pero los números de HC en estrés (tab:res_brecha, tab:res_estres_tiempos, tab:res_sin_referencia, tab:res_convergencia, "0,21 %" del resumen) vienen de una versión anterior que dependía de `PYTHONHASHSEED`. La variación entre semillas (mediana de 0,02 %, máximo de 0,44 %, 2 de 90 sin solución) se midió sobre la versión nueva. Con la versión nueva, la brecha máxima de HC sería de 0,18 % y no de 0,21 % (recálculo con la semilla 1 del estudio).
- **Sugerencia:** volver a correr la suite de estrés de HC con el código de main (y regenerar la verificación) o aclarar en cap5/cap6 que la corrida de estrés de HC es anterior al cambio que la volvió determinista y que la robustez se midió con otra versión.

### D3 (Mayor): el monolítico en estrés no resolvió los mismos datos
- **Tesina:** `cap5.tex:551-554` ("los cuatro métodos construyen cada escenario con la misma llamada [...] se verificó que los datos resultantes son idénticos en los 19 escenarios"), `cap5.tex:567-568` y `cap6.tex:351` ("el monolítico no termina ninguno de los 19 escenarios").
- **Evidencia:** `repo:results/README.md:20`: "`opp_mono/stress/`: rows 05–19 come from runs with `W_c = 9`. The current suite uses `W_c = 27` from scenario 04 on, and OPP-Mono was run with it only up to 04 (timeout at 40 min)." El CSV del monolítico en estrés no tiene la columna `W_c`, así que no se puede comprobar fila por fila. Además, la fila 01 tiene estado `no_result`, no `timeout`.
- **Correcto:** para 05–19, el monolítico resolvió una instancia con otro peso de finalización. La conclusión cualitativa probablemente se sostiene (no terminó con un peso ni con el otro), pero la afirmación de "datos idénticos" no vale para el monolítico.
- **Sugerencia:** decirlo explícitamente en cap5 (Ejecución) o en cap6 (Pruebas de estrés), o volver a correr el monolítico en 05–19 con `W_c = 27`. Aclarar también que en el 01 el monolítico no llega a resolver (`no_result`), lo que concuerda con ap6.tex:62-64 (ZIMPL sin memoria).

### D4 (Mayor): el texto contradice al Cuadro tab:res_40min
- **Tesina:** `cap6.tex:320-322`: "Con un tope de 40 minutos, el monolítico sigue sin probar el óptimo en esos puntos". El Cuadro, en la línea 337, dice "6 lotes, 5×5 [...] 32,0 min | sí".
- **Evidencia:** `repo:experiments/exact/studies/11_mono_long_cap/points_20260923_232413.csv`: B6S5 mono `optimal`, 1.917,5 s.
- **Correcto:** con 40 min, el monolítico prueba el óptimo en 1 de los 3 puntos (6 lotes en 5×5, a los 32 min, 8,3 veces el tiempo del Split) y no lo prueba en los otros 2 ni en el escenario 04.
- **Sugerencia:** "sigue sin probar el óptimo en dos de esos tres puntos ni en la instancia del escenario 04; en el tercero (6 lotes en 5×5) lo prueba a los 32 minutos, 8 veces lo que tarda el Split".

### D5 (Mayor): "al menos 71 veces más" generalizado
- **Tesina:** `cap6.tex:293-296`: "en los que no lo prueba, al menos 71 veces más (4 lotes en 6×6, que el Split resuelve en 8,4 segundos)".
- **Evidencia:** estudio 08 (`frontier_20260923_201522.csv`). En los puntos que el monolítico no prueba, cortado a 570 s (el límite de SCIP es el tope duro de 600 s menos 30, `exploration.py:304`), los cocientes son: B4S6 569,8/8,4 = 68×, B3S7 570,2/9,7 = 59× y B6S5 570,4/217,6 = 2,6×. El 71 sale de 600/8,4.
- **Correcto:** la cota inferior va de 2,6× a 68×, según el punto.
- **Sugerencia:** "en los que no lo prueba, la diferencia es de al menos 68 veces en 4 lotes en 6×6 y 59 en 3 lotes en 7×7; con 6 lotes en 5×5 el Split también tarda (218 s), y la cota es de 2,6 veces".

### D6 (Mayor): las 35 instancias con tiempo conocido
- **Tesina:** `cap6.tex:585-593`: "solo se conoce el tiempo de las instancias cuya prueba resuelve una sola", y de ahí 35 instancias. Lo mismo en `ap7.tex:103-105`.
- **Evidencia:**
  - `repo:tests/infra/execution/runner.py:139-152`: "One row per instance the test solved [...] each row's total_time is the time of its own instance".
  - El CSV funcional del Split (commit `e809cb4`, 2026-11-17 21:21) tiene filas `__1/__2` con sus propios tiempos, y tab:res_pares las usa (19b·1 0,333 s y 19b·2 0,337 s).
  - El docstring de `repo:experiments/comparison/comparability.py:162-168` todavía describe el formato viejo, y `results/comparability/results_split_vs_heuristics.csv` (commit `c1f3a09`, 20:59) es anterior al CSV vigente.
  - Recálculo sobre las 45 instancias: medianas de 0,315 s (Split), 0,067 (HC) y 0,261 (ACO). HC es más rápido en 45/45 y ACO en 28/45. Sobre las 35: 0,295, 0,061 y 0,225, con HC más rápido en 35/35 y ACO en 24/35, como dice la tesis.
- **Correcto:** el motivo de la restricción a 35 ya no vale, y la tesis mezcla los dos criterios (cap6 restringe a 35 y ap7 da tiempos por variante).
- **Sugerencia:** regenerar `results_split_vs_heuristics.csv` con el CSV actual y reportar las 45 instancias, o eliminar la justificación y decir solo que se usan 35.

### D7 (Mayor): uso de los ajustes del verificador
- **Tesina:** `cap6.tex:413-416`: "Los ajustes del verificador se usaron en pocos casos. En el caso 30a [...] En el escenario de 100×100, resolvió sobre el subgrafo de las rutas, que tiene unas 1.500 de las 10.000 ubicaciones."
- **Evidencia:** columna `notes` de `repo:results/compliance/opp_aco/stress/compliance_output_opp_aco_stress_tests.csv`: "SCIP levels ran on the routes' subgraph" en las 19 filas. En las funcionales, el subgrafo aparece en 3 filas de ACO (06a, 06b y 29) y en 3 de HC (06a, 06b y 26b·2). En el 100×100, el subgrafo tiene 1.365 ubicaciones con ACO y 1.425 con HC.
- **Correcto:** la regla de ap6.tex:59 ("cuando todas las rutas están fijas") se aplicó en 26 verificaciones (19 + 3 + 3 + 1), no solo en el 100×100. El subgrafo del 100×100 tiene unas 1.400 ubicaciones. HC en estrés solo lo usó en el 01, lo que sugiere que las dos verificaciones se corrieron con versiones distintas del verificador (no verificado).
- **Sugerencia:** "El subgrafo de las rutas se usó en las 19 soluciones de estrés de ACO, en la del 100×100 de HC (unas 1.400 de las 10.000 ubicaciones) y en 3 funcionales de cada heurística; quitar lotes vacíos, solo en el 30a; el reemplazo de M, en ninguna."

### D8 (Menor): "ACO tarda entre lo mismo que el Split y 6 veces menos"
- **Tesina:** `cap6.tex:731-732`, `cap6.tex:994-995`, `resumen.tex:20-21`, `abstract.tex:19-20` y `cap7.tex:455-456`.
- **Evidencia:** cocientes Split/ACO en los 9 escenarios resueltos: 1,18; **0,87** (04); 1,16; 2,14; 5,51; 1,15; 5,96; 1,51; 5,55. Mediana: 1,51, como dice la tesis.
- **Sugerencia:** "entre algo más que el Split (escenario 04) y 6 veces menos".

### D9 (Menor): cocientes funcionales
- **Tesina:** `cap6.tex:588-590`: "En la mediana, el Split tarda 0,295 segundos, HC 0,061 y ACO 0,225, de modo que HC es 5,1 veces más rápido [...] y ACO, 1,4 veces."
- **Evidencia:** 0,295/0,061 = 4,8 y 0,295/0,225 = 1,3. La mediana del cociente por instancia (columna `speedup`) es 5,08 y 1,37 (`repo:experiments/exact/reports/build_heuristics_comparison.py:223`).
- **Sugerencia:** "la mediana del cociente por instancia es de 5,1 para HC y de 1,4 para ACO".

### D10 (Menor): "En las 11 restantes, de alrededor de un segundo"
- **Tesina:** `cap6.tex:591-592`.
- **Evidencia:** de las 11 instancias en que ACO es más lento que el Split, 6 están entre 0,98 y 1,14 s, pero 5 (casos 02, 03, 04, 05 y 15) tardan entre 0,29 y 0,44 s con ACO.
- **Sugerencia:** "En las 11 restantes, que el Split resuelve en menos de medio segundo, ACO tarda entre 0,3 y 1,1 s, porque ejecuta todas sus iteraciones aunque la instancia sea trivial".

### D11 (Menor): "las 60 completas llevarían unas 5 horas"
- **Tesina:** `cap6.tex:735-736`.
- **Evidencia:** ACO 01: `iterations_run = 2` y `total_time` de 1.892 s (`model_time` de 1.622 s). La extrapolación lineal da 60 × 811 s ≈ 13,5 h, y no hay ninguna medición en el repo que dé 5 h.
- **Sugerencia:** recalcular o citar de dónde sale la estimación. **No verificado.**

### D12 (Menor): conteo de casos funcionales
- **Tesina:** `cap5.tex:56` ("Se definieron 38 casos"), `resumen.tex:15`, `abstract.tex:14` y `cap7.tex:445`.
- **Evidencia:** `repo:tests/functional_cases/case_12.py:14`: "Case 12 has no active tests [...] The number is kept so that the cases stay numbered continuously". `repo:scripts/baseline_counts.json` habla de "the 37 shared cases". Ningún CSV tiene filas del Case12.
- **Sugerencia:** "38 casos numerados, uno de ellos (el 12) sin pruebas activas" o "37 casos". (Se cruza con la sección C.)

### D13 (Menor): la figura de escala (fig:res_lineales_escala)
- **Tesina:** `cap6.tex:176-177` dice "con 1 a 6 lotes", pero la figura solo grafica 2, 3, 4 y 6 lotes (el estudio 08 incluye 1 lote). El caption y el texto hablan de "una misma instancia", aunque cada punto es una instancia distinta (cambian la grilla, la cantidad de lotes y los pickers).
- `cap6.tex:289-290`: "con hasta 4 lotes resuelve cualquier grilla en menos de 10 segundos". Con 4 lotes, el Split no corrió en 7×7 (no hay fila split de B4S7 en `frontier_20260923_201522.csv`) ni corrió 6 lotes en 6×6 o 7×7.
- **Sugerencia:** "en grillas de 3×3 a 7×7 con 1 a 6 lotes (se grafican 2 a 6)", "con hasta 4 lotes resuelve todas las grillas probadas" y "un mismo perfil" en lugar de "una misma instancia".

### D14 (Menor): punto fuera del eje en fig:res_lineales_dispersion
- **Tesina:** `cap6.tex:150`: el punto en (0,972; −0,403) cm cae debajo del origen del eje (0,1 s). Es el caso 28·1, con monolítico en 0,071 s.
- **Sugerencia:** bajar el eje a 0,01 s o recortar ese punto con una marca.

### D15 (Menor): objetivo del caso 27
- **Tesina:** `ap7.tex:60` da 58,0. El CSV da 58,05 (Split 58,049999…, monolítico 58,05).
- **Sugerencia:** "58,05" o "58,1".

### D16 (Menor): referencia de "óptimo probado" y la tolerancia
- **Tesina:** `cap5.tex:602-603` ("una brecha negativa indicaría un error") y `cap5.tex:523-524`.
- **Evidencia:** en el estudio 08, B3S6, el monolítico obtiene 26.709,36 y el Split, "óptimo", 26.709,60 (diferencia relativa de 9·10⁻⁶, mayor que la tolerancia de 10⁻⁶ que se usa en la comparación). No afecta a las heurísticas (no hay brechas negativas en `results_split_vs_heuristics.csv`), pero muestra que un "óptimo probado" de SCIP lo es dentro de sus tolerancias.
- **Sugerencia:** aclarar que "negativa" significa "negativa más allá de la tolerancia del resolvedor".

### D17 (Menor): mezcla de corridas en el experimento a igual tiempo con HC
- **Tesina:** `cap6.tex:863-868`. La tesina lo reconoce, pero la frase "En el tiempo en que HC entrega una solución a lo sumo a un 0,21 %" combina el presupuesto de la corrida del 2026-09-27 (`output_equal_time_opp_hc_20260927_195040.csv`, con otros objetivos de HC, como 1.765.200 en el 03 contra 1.767.172) con la brecha de la corrida del 2026-09-28.
- **Sugerencia:** no hace falta corregir el dato; alcanza con decir "a lo sumo a un 0,21 % del óptimo en la corrida principal".

### D18 (Menor): exceso de presupuesto
- **Tesina:** `cap6.tex:886-887`: "a lo sumo 6 segundos". Evidencia: el monolítico en el 19 tardó 362,76 s con un presupuesto de 356,57, es decir, 6,2 s de exceso.
- **Sugerencia:** "a lo sumo unos 6 segundos".

### D19 (Menor): "10 instancias funcionales pueden compararse solo en estado"
- **Tesina:** `cap7.tex:330-331`. Las instancias que se comparan solo en estado son 22: las 12 infactibles y las 10 con espera (cap6.tex:426-428). La frase se refiere a las 10 con espera, pero se lee como el total.
- **Sugerencia:** "y 10 instancias funcionales factibles, en las que el Split usa espera voluntaria, solo pueden compararse en estado".

### D20 (Menor, del repo, no de la tesina): join por nombre de método
- `repo:results/comparability/compare_split_vs_mono.csv` tiene 69 filas funcionales y no 70: Case02 y Case03 comparten `test_two_orders_two_aisles`, y el join por nombre de método (`results/README.md`: "models are joined by the last segment") pierde una fila. Por eso el CSV da 65 pares y no 66. La tesina, en cambio, cuenta bien (66, y el ap7 lista 02 y 03). Conviene usar como clave `Case.método` en `verification/compare_split_vs_mono.py`.

---

## 3. Tabla de experimentos (tesina ↔ script ↔ resultados)

| Experimento (tesina) | Configuración en la tesina | Script / comando | Archivo de resultados | ¿Coincide? |
|---|---|---|---|---|
| Suite funcional, 4 métodos (cap5 §Pruebas funcionales; cap6 §Mismo óptimo, Tiempos; ap7) | Split 64 pruebas / 70 instancias; monolítico 63; tope de 25 min; Etapa 1 secuencial | `python -m tests.run_suite <modelo> functional` con `WRITE_RESULTS_CSV=1`; tope en `tests/infra/execution/config.py:7` (25) | `results/opp_{split,mono,hc,aco}/functional/output_*_functional_tests.csv` (70/69/70/70 filas) | Sí. HC/ACO tienen 70 filas = 68 instancias + 2 pruebas de rechazo de velocidad, que la tesina excluye. |
| Suite de estrés, 4 métodos (cap5 §Escenarios; cap6) | 19 escenarios, tope de 40 min, Split Etapa 1 en 6 procesos, semilla 1 | `tests.run_suite <modelo> stress`; `.env.example:15` (40); generador `tests/shared_scenarios/stress/stress_scenarios_designed.py` | `results/opp_split/stress/output_opp_split_stress_tests_parallel.csv`, `opp_mono/…`, `opp_hc/…`, `opp_aco/…` | Parcial. El monolítico 05–19 usó `W_c = 9` (D3) y HC es anterior al fix de determinismo (D2). Escenarios (lotes, pickers, pedidos, grilla, `T_cold = 280`, `C_v = 195`, velocidades 0,8/1,2, `W_c` 9/27): coinciden. |
| Perfil realista (tab:perfil_realista) | 26 pedidos/lote × 5, semilla 20260922, pesos 4/5, `F_b = 131`, fechas 60–140 %, `M = 10⁶`, `C_v` = 1,5× | `stress_scenarios_designed.py:25, 55-200` | CSV de estrés (columnas `C_v`, `V_p`, `T_cold`, `W_c`) | Sí |
| Parámetros de HC/ACO (tab:hc_parametros, tab:aco_parametros) | HC 500/30/30 s; estrés 200/60; ACO m = 15, 60 it, 1.800 s, α = 1, β = 2,5, ρ = 0,15, Q = 100 | `dtos/hc/solve_hc_model_dto.py:13-15`, `dtos/aco/solve_aco_model_dto.py:13-21`, `tests/opp_hc/stress/stress_test_case.py:21-22`, `tests/infra/factories/scenario_adapter.py:40` (Seed = 1) | Columnas `Max_it`, `Max_imp`, `A_ants`, `Alpha`, `Beta`, `Max_time` | Sí |
| Monolítico contra Split, funcional (cap6 §Mismo óptimo) | 66 pares, 55 óptimos + 11 infactibles, 25 óptimos alternativos (17 rutas / 20 asignación) | `python -m verification.compare_split_vs_mono` | `results/comparability/compare_split_vs_mono.csv` | Sí en conteos y veredictos (con la salvedad D20). cap5 dice 60 (D1). |
| Escala (fig:res_lineales_escala, tab:res_tamano_mip) | Grillas de 3×3 a 7×7, 1–6 lotes, tope de 10 min | `experiments.exact.exploration --study 08_mono_frontier --frontier … --hard-cap 600` | `experiments/exact/studies/08_mono_frontier/frontier_20260923_201522.csv` | Sí en valores (D5, D13 en redacción) |
| Tope de 40 min (tab:res_40min) | 3 puntos + instancia 04 con `W_c = 9` | `exploration --points 11_mono_long_cap/points.json` (`hard_cap_s` 2430) | `11_mono_long_cap/points_20260923_232413.csv` | Sí en valores (D4 en redacción). `W_c = 9`: no verificado (el CSV no lo registra; es coherente con la fecha, anterior al cambio a 27). |
| Paralelismo de la Etapa 1 (cap5:338-343, cap6:362) | 2,2× (13×13) y 1,9× (14×14) | `exploration --points 12_stage1_parallel/points.json` | `12_stage1_parallel/points_20260924_100156.csv` | Sí (242→110 s; 403→213 s) |
| Inflación por corridas en paralelo, 1,6–2,3× (cap5:334-337) | — | Estudios 05 (rondas en paralelo) | `docs/thesis/opp_split_exploration.tex:61` | Sí (según el reporte; no se recalculó desde los CSV) |
| Validez de las heurísticas (tab:res_validez) | 68 + 19 por heurística; 150 válidas | `python -m verification.run_compliance --model … --tier …` | `results/compliance/opp_{hc,aco}/{functional,stress}/*.csv` | Sí (56 + 19 compliant por heurística; 14 skipped = 12 infactibles + 2 de rechazo de velocidad). D7 en la redacción. |
| Verificación de las 9 soluciones de estrés del Split (cap6:400-401, cap5:530-534) | 9/9 válidas | `verification.compare_split_vs_mono --verify-split-stress` | **No hay archivo**: el CSV de comparación se generó sin esa opción (las filas de estrés no tienen "split vs mono: …") | No verificado |
| Comparabilidad Split–heurísticas (tab:comparabilidad, cap6 §Comparación) | 70 → 67 en estado, 45 en objetivo, 10 con espera, 12 infactibles | `python -m experiments.comparison.comparability` | `results/comparability/comparability_split_vs_heuristics.csv`, `results_split_vs_heuristics.csv` | Sí en conteos y brechas. Los tiempos se basan en un formato de CSV viejo (D6). |
| A igual tiempo, HC (cap6 §A igual tiempo) | 19 escenarios, presupuesto = tiempo de HC | `python -m experiments.comparison.run_equal_time_study --budget-from opp_hc` | `results/equal_time/output_equal_time_opp_hc_20260927_195040.csv` | Sí. La tesina reconoce que es una corrida anterior. |
| A igual tiempo, ACO (tab:res_igual_tiempo_aco) | 19 escenarios | `… --budget-from opp_aco` | `results/equal_time/output_equal_time_opp_aco_20261110_134358.csv` | Sí |
| Robustez entre semillas, HC (cap6:951-956, cap7:473-475) | 5 semillas, escenarios 02–19 | `experiments.heuristics.hc.run_hc_budget_study` | `results/opp_hc/budget/output_opp_hc_budget_20261019_201951.csv` (filas 200/60) | Sí en los números (mediana de 0,016 %, máximo de 0,44 %, 2/90 sin solución). Otra versión del código que la corrida principal (D2). |
| Robustez entre semillas, ACO (cap6:955, cap7:470-473) | 5 semillas, escenarios 02–19 | `experiments.heuristics.aco.run_aco_seed_study` | `results/opp_aco/seeds/output_opp_aco_seeds_20261102_193102.csv` | Sí (mediana de 0,0046 %, máximo de 0,053 %, 90/90 con solución; la semilla 1 reproduce la corrida principal) |
| Presupuesto de HC, ablación y feromona de ACO | Referidos a ap8 (sec:calib_hc_presupuesto, sec:calib_aco_ablacion, sec:calib_aco_sensibilidad) | `run_hc_budget_study`, `run_aco_ablation_study`, `run_aco_pheromone_study` | `results/opp_hc/budget/…`, `results/opp_aco/ablation/…_20260927_203910.csv`, `results/opp_aco/pheromone/…_20260927_210703.csv` | No auditado (ap8 queda fuera del alcance pedido). Ablación y feromona son del 2026-09-27, anteriores al fix de determinismo. |

---

## 4. Tablas de números (valor en tesina ↔ repo/recalculado)

### 4.1 Monolítico contra Split, funcional (cap6 §Mismo óptimo, tab:res_tiempos_lineales; ap7)

| Dato | Tesina | Recalculado | ¿Coincide? |
|---|---|---|---|
| Pares comparables | 66 (cap6:23); 60 (cap5:562) | 66 | cap6 sí; **cap5 no** |
| Pares con óptimo / infactibles | 55 / 11 | 55 / 11 | Sí |
| Mayor diferencia de objetivo | 3,83·10⁻⁶ (casos 13 y 14) | 3,8346·10⁻⁶ (13 y 14) | Sí |
| Óptimos alternativos (rutas / asignación) | 25 (17 / 20) | 25 (17 / 20) | Sí |
| Suma del tiempo total, monolítico / Split / cociente | 148,1 / 26,5 / 5,60 | 148,1 / 26,5 / 5,60 | Sí |
| Mediana del tiempo total | 0,226 / 0,315 / 0,72 | 0,226 / 0,315 / 0,72 | Sí |
| Máximo del tiempo total | 43,5 / 3,9 / 11,27 | 43,53 / 3,86 / 11,27 | Sí |
| Suma del tiempo del resolvedor | 131,9 / 7,5 / 17,66 | 131,9 / 7,5 / 17,66 | Sí |
| Mediana del tiempo del resolvedor | 0,007 / 0,003 / 1,99 | 0,007 / 0,003 / 1,99 | Sí |
| Monolítico más rápido | 42 de 55, entre 31 % y 98 % | 42; 0,31–0,98 | Sí |
| Cociente máximo | 28,9 (caso 29) | 28,90 (`test_one_empty_batch_allowed`) | Sí |
| tab:res_pares (55 filas: tiempos, cociente, objetivo, "solución del monolítico") | — | Las 55 filas coinciden en tiempos y cocientes; veredicto de solución, igual al CSV | Sí, salvo el caso 27: 58,0 contra 58,05 (D15) |
| tab:res_infactibles (11 filas) | — | Las 11 coinciden | Sí |
| fig:res_lineales_dispersion (55 puntos) | — | Coordenadas consistentes con log₁₀ de los tiempos; un punto fuera del eje (D14) | Sí |

### 4.2 Escala y tope de 40 min (estudios 08 y 11)

| Dato | Tesina | Repo | ¿Coincide? |
|---|---|---|---|
| tab:res_tamano_mip (7 filas: variables y restricciones del monolítico y de la Etapa 2) | 327/573/174/339 … 1.206/1.804/234/460 | `n_vars` / `n_conss` idénticos en las 7 filas | Sí |
| Split con 3 lotes: 3×3, 5×5, 6×6, 7×7 (fig.) | 3,2 / 3,8 / 5,1 / 9,7 s | 3,2 / 3,8 / 5,1 / 9,7 | Sí |
| Monolítico con 3 lotes: 5×5 → 6×6 | 9 → 139 s | 8,6 → 138,8 | Sí |
| Cociente máximo cuando los dos prueban | 27 (3 lotes, 6×6) | 138,8/5,1 = 27,2 | Sí |
| Cota cuando el monolítico no prueba | "al menos 71" | 68 (B4S6), 59 (B3S7), 2,6 (B6S5) | **No** (D5) |
| Split en 4 lotes, 6×6 | 8,4 s | 8,4 | Sí |
| tab:res_40min, 3 lotes 7×7 | 8,2 s; 40 min; no; 0,05 %; 11,0 % | 8,2; 2.400 s; timelimit; 0,05; 11,01 | Sí |
| tab:res_40min, 4 lotes 6×6 | 9,5; 40; no; 0,00 %; 10,4 % | 9,5; 2.399,9; timelimit; 0,0; 10,37 | Sí |
| tab:res_40min, 6 lotes 5×5 | 231,7; 32,0 min; sí | 231,7; 1.917,5 s; optimal | Sí (pero contradice el texto, D4) |
| tab:res_40min, estrés 04 | 181,4; 40; no; 0,66 %; 143,5 % | 181,4; 2.400,2; 0,66; 143,52 | Sí |
| Paralelismo de la Etapa 1 | 2,2× / 1,9× | 241,8/110,1 = 2,20; 401,4/209,5 = 1,92 | Sí |

### 4.3 Estrés: estado, tiempos, brechas (tab:res_estres_tiempos, tab:res_brecha, fig:res_brecha)

| Esc. | Split (s) tesina/CSV | HC (s) | ACO (s) | Brecha de HC tesina / recalc. | Brecha de ACO tesina / recalc. |
|---|---|---|---|---|---|
| 01 | sin terminar / timeout | 1.029,2 ✓ | 1.892,3 ✓ | — | — |
| 02 | 33 / 32,7 ✓ | 0,9 ✓ | 27,8 ✓ | 0,00 / 0,000 ✓ | 0,00 / 0,000 ✓ |
| 03 | sin terminar ✓ | 1,7 ✓ | 310,4 ✓ | — | — |
| 04 | 12 / 12,3 ✓ | 0,5 ✓ | 14,1 ✓ | 0,01 / 0,013 ✓ | 0,00 / 0,000 ✓ |
| 05 | 108 / 107,8 ✓ | 2,8 ✓ | 92,9 ✓ | 0,05 / 0,048 ✓ | 0,01 / 0,010 ✓ |
| 06 | 202 / 201,7 ✓ | 3,8 ✓ | 94,4 ✓ | 0,04 / 0,042 ✓ | 0,01 / 0,006 ✓ |
| 07 | 904 / 904,1 ✓ | 4,3 ✓ | 164,0 ✓ | 0,04 / 0,035 ✓ | 0,01 / 0,006 ✓ |
| 08 | sin terminar ✓ | 4,8 ✓ | 120,1 ✓ | — | — |
| 09 | 224 / 223,8 ✓ | 3,8 ✓ | 195,0 ✓ | 0,06 / 0,056 ✓ | 0,01 / 0,008 ✓ |
| 10 | 86 / 85,6 ✓ | 0,5 ✓ | 14,4 ✓ | 0,02 / 0,020 ✓ | 0,00 / 0,000 ✓ |
| 11 | 139 / 139,2 ✓ | 2,9 ✓ | 92,2 ✓ | 0,21 / 0,214 ✓ | 0,04 / 0,044 ✓ |
| 12–14, 16–19 | sin terminar ✓ | 0,7/0,7/0,9/2,0/3,1/3,4/4,9 ✓ | 26,4/38,8/42,5/83,8/130,6/167,1/356,6 ✓ | — | — |
| 15 | 244 / 244,2 ✓ | 1,5 ✓ | 44,0 ✓ | 0,07 / 0,071 ✓ | 0,01 / 0,008 ✓ |

| Resumen (tab:res_brecha y texto) | Tesina | Recalculado | ¿Coincide? |
|---|---|---|---|
| HC funcional: n / óptimas / media / mediana / máx. | 45 / 40 / 0,36 / 0,00 / 5,88 % | 45 / 40 / 0,363 / 0,00 / 5,882 | Sí |
| ACO funcional | 45 / 45 / 0 / 0 / 0 | Igual | Sí |
| HC estrés | 9 / 1 / 0,06 / 0,04 / 0,21 | 9 / 1 / 0,055 / 0,042 / 0,214 | Sí |
| ACO estrés | 9 / 3 / 0,01 / 0,01 / 0,04 | 9 / 3 / 0,009 / 0,006 / 0,044 | Sí |
| ACO con brecha menor que HC | 8 de 9 | 8 (empate en 02) | Sí |
| tab:res_fallos_hc (20, 25c, 25e·1, 25f·1, 25f·2) | 2,2 / 2,2 / 2,2 / 5,9 / 3,8 % | 2,21 / 2,21 / 2,17 / 5,88 / 3,85 | Sí |
| Split termina / máximo | 9; 15,1 min | 9; 904,1 s = 15,07 min | Sí |
| Mediana de Split/HC y de Split/ACO (estrés) | 53,1 / 1,5 | 53,09 / 1,51 | Sí |
| Rango de Split/ACO | "de iguales a 6 veces menores" | 0,87–5,96 | Casi (D8) |
| HC < 5 s salvo el 01; ACO entre 14 s y 6 min salvo el 01 | — | HC máx. 4,9; ACO 14,1–356,6 s | Sí |
| HC 01 = 17 min; ACO 01 = 32 min, 2 iteraciones | — | 1.029 s = 17,2 min; 1.892 s = 31,5 min; 2 it. | Sí |
| fig:res_brecha, fig:res_estres_tiempos, fig:res_calidad_tiempo | — | Alturas y coordenadas consistentes con los CSV (muestreo de 10+ barras/puntos por figura) | Sí |

### 4.4 Validez, espera, sin referencia

| Dato | Tesina | Recalculado | ¿Coincide? |
|---|---|---|---|
| tab:res_validez, HC funcional: 68 / 56 / 0 / 12 | — | 56 compliant; 12 infactibles + 2 de rechazo de velocidad, que no se cuentan | Sí |
| tab:res_validez, estrés: 19 / 19 / 0 / 0 (HC y ACO) | — | 19 compliant cada una | Sí |
| 150 soluciones válidas; nivel 2 = objetivo informado | — | 56 + 19 + 56 + 19 = 150; `level2_obj` = `heuristic_obj` en todas | Sí |
| Nivel 1 hasta un 96 % menor (26b) | 96 % | 96,5 % (HC), 96,3 % (ACO) | Sí |
| 30a: 10 lotes vacíos quitados | — | "dropped 10 empty batch(es)" en HC y ACO | Sí |
| Subgrafo del 100×100: "unas 1.500 de las 10.000" | — | 1.365 (ACO) / 1.425 (HC) | Aproximado (D7) |
| Comparables en estado / objetivo | 67 / 45 | 67 / 45 | Sí |
| Coincidencia de estado | Todas | 67/67 en las dos heurísticas | Sí |
| tab:res_espera (10 filas: Split, HC, ACO, lotes que esperan) | — | Las 10 filas coinciden (incluido ACO en el 29: 386, ya actualizado en `c1f3a09`) | Sí |
| "casi 29" en el 26b; 30 % en el 01 y el 33c | — | 597.462,5/20.725 = 28,8; 39/30 = 1,30 | Sí |
| tab:res_sin_referencia (10 filas, HC, ACO y %) | 5,39 / −0,85 / −0,05 / −0,02 / −0,02 / −0,02 / −0,05 / −0,03 / −0,07 / −0,03 | 5,392 / −0,854 / −0,052 / −0,024 / −0,019 / −0,021 / −0,050 / −0,034 / −0,066 / −0,034 | Sí |

### 4.5 A igual tiempo (tab:res_igual_tiempo_aco)

| Dato | Tesina | Recalculado | ¿Coincide? |
|---|---|---|---|
| Presupuestos con HC | 0,5–6 s; 01 ≈ 20 min | 0,452–5,714 s; 01 1.208,8 s | Sí |
| Presupuesto de HC en el 01 menos el tiempo de la corrida principal | ≈ 3 min | 1.208,8 − 1.029,2 = 179,6 s | Sí |
| Con HC: ningún modelo lineal obtiene solución | — | Split `stage1_time` en 19; monolítico sin objetivo en 19 | Sí |
| Presupuestos con ACO | 14–357 s; 01 ≈ 32 min | 14,1–356,6 s; 1.892,3 s | Sí |
| Split con solución | 15 de 19 | 15 | Sí |
| A menos de 0,1 % | 7 (04, 05, 06, 09, 10, 12, 13) | 04 −0,001; 05 −0,050; 06 −0,085; 09 +0,008; 10 −0,004; 12 −0,008; 13 −0,008 | Sí |
| 02 / 03 / 15 / 14 | −0,78 / −0,66 / −15,23 / −29,99 | −0,779 / −0,659 / −15,226 / −29,992 | Sí |
| 16–19 | −46,17 / −57,01 / −54,95 / −58,46 | −46,167 / −57,006 / −54,946 / −58,464 | Sí |
| Sin solución: 01, 07, 08 (Etapa 1), 11 (cadena de frío) | — | `stage1_time` ×3; `stage1_routes_not_cold_chain_eligible` | Sí |
| Monolítico: 04 y 12, 5,3 % y 10,5 % | — | 157.569,7 → −5,30; 222.183,9 → −10,48 | Sí |
| Monolítico en el 01: 59 min | — | 3.537,6 s = 58,96 min | Sí |
| Exceso fuera del 01: "a lo sumo 6 s" | — | Máximo de 6,19 s (monolítico, 19) | Aproximado (D18) |

### 4.6 Servicio, memoria, convergencia, semillas

| Dato | Tesina | Recalculado | ¿Coincide? |
|---|---|---|---|
| tab:res_sla (19 × 3) | 0 % en 01–03; 100 % salvo en el 11; 97,4 / 96,8 / 97,4 | Igual (97,435; 96,794; 97,435) | Sí |
| Memoria: mediana de HC / ACO | 27 / 30 MB | 26,6 / 29,7 | Sí |
| 100×100: HC / ACO | 867 / 907 MB | 867,4 / 907,1 | Sí |
| Pico de ACO en el 09 | 1.672 MB | 1.672,2 | Sí |
| Rango del Split | 76–287 MB | 75,8–287,1 | Sí |
| tab:res_convergencia (19 × 5) | — | Las 95 celdas coinciden | Sí |
| HC entre 60 y 157 iteraciones, salvo 03 y 17 (200) y 01 (0); inicial = mejor en 3 | — | 60–157; 03/17 = 200; 01 = 0; mejor = 0 en 02, 07 y 16 | Sí |
| ACO: mejor entre la iteración 1 y la 56; "en la mitad" después de la 30 | — | 1–56; 9 de 19 después de la 30 | Sí ("la mitad" ≈ 47 %) |
| Semillas de HC: mediana / máx. / sin solución | 0,02 % / < 0,5 % / 2 de 90 | 0,0155 % / 0,444 % / 2 (09 s4, 11 s5) | Sí (con la salvedad D2) |
| Semillas de ACO: mediana / máx. / sin solución | 0,005 % / ≤ 0,05 % / 0 | 0,0046 % / 0,053 % / 0 | Sí |

### 4.7 Tiempos funcionales Split–heurísticas (cap6 §Tiempos)

| Dato | Tesina | Sobre 35 | Sobre 45 |
|---|---|---|---|
| Mediana Split / HC / ACO | 0,295 / 0,061 / 0,225 | 0,295 / 0,061 / 0,225 ✓ | 0,315 / 0,067 / 0,261 |
| "HC 5,1 veces", "ACO 1,4" | 5,1 / 1,4 | Mediana de los cocientes: 5,08 / 1,37 ✓; cociente de medianas: 4,8 / 1,3 | 4,7 / 1,2 (cociente de medianas) |
| HC más rápido | 35/35 | 35/35 ✓ | 45/45 |
| ACO más rápido | 24/35 | 24/35 ✓ | 28/45 |
| Puntos de fig:res_funcional_tiempos | 35 + 35 | 35 + 35 ✓ | — |

---

## 5. Experimentos o resultados del repo que no se reportan

| Elemento | Dónde | ¿Debería estar? |
|---|---|---|
| Gaps y cotas duales de los modelos lineales en el experimento a igual tiempo (`mip_gap_pct`, `dual_bound`, por ejemplo una cota dual de 0 en el monolítico en 6 de 19 escenarios con ACO y menor que 2 en otros 2, y gap del 1.227 % en el Split 03) | `results/equal_time/*.csv` | Opcional: refuerza el argumento de que la cota dual no avanza (cap6:325). |
| Verificación de las soluciones de estrés del Split contra el monolítico | Función `verify_split_stress` en `verification/compare_split_vs_mono.py:207`; su resultado no está guardado | Sí, si la tesina lo afirma (cap6:400-401): guardar el resultado. |
| Estudios 09 (instancias del relevamiento resueltas por los dos modelos) y 10 (ejes a escala chica, 25 óptimos del monolítico iguales a los del Split) | `experiments/exact/studies/09_*`, `10_*` | Probablemente en ap5 (sec:alcance_monolitico); no auditado. Apoyan directamente la afirmación "mismo óptimo" con 25 pares adicionales. |
| Estudios 01–07 y 12 del Split (incluidos clausura métrica y `<= 1`) | `experiments/exact/studies/01_*`–`07_*` | En ap5 (fuera del alcance de esta auditoría). |
| Variantes del presupuesto de HC (200/120, 500/60, 500/120: 270 corridas) | `results/opp_hc/budget/…_20261019_201951.csv` | Referidas a ap8 (sec:calib_hc_presupuesto); no auditado. |
| Ablación (27 corridas) y feromona (81 corridas) de ACO | `results/opp_aco/ablation/`, `results/opp_aco/pheromone/` | Referidas a ap8; no auditado. Son del 2026-09-27, anteriores al fix de determinismo. |
| Reportes generados con los mismos datos | `docs/thesis/opp_*_exploration.tex`, `opp_mono_vs_opp_split_comparison.tex`, `opp_split_vs_heuristics_comparison.tex` y sus generadores `experiments/exact/reports/build_*.py` | No hace falta incluirlos; sí conviene mencionar en cap5 que los cuadros y figuras del Capítulo 6 se generan con esos scripts (trazabilidad). |
| Herramientas `scripts/run_all.py`, `check_repo.py`, `make_stress_smoke.py`, CI | `scripts/` | Detalle de implementación: puede omitirse en D. |

---

## 6. Qué no se pudo verificar y por qué

- **Que la corrida de estrés del Split en el escenario 10 sea "de una corrida anterior, por una suspensión"** (cap6:600, 960-962): el CSV consolidado solo tiene una fila (85,6 s) y no registra suspensiones.
- **Que las 9 soluciones de estrés del Split resultaran válidas** (cap6:400-401; cap5:530-534): no hay un archivo de compliance del Split en `results/` (ver §5).
- **"2-opt se eligió 86 veces y no generó ningún vecino; entre el 26 y el 48 % de las iteraciones"** (cap6:474-479): los CSV no registran conteos por movimiento.
- **"Las 60 iteraciones completas llevarían unas 5 horas"** (cap6:735-736): sin medición, y la extrapolación lineal da unas 13–16 h (D11).
- **30a: "SCIP no terminó en 600 s con los lotes vacíos y terminó en 0,13 s sin ellos"** (cap6:51-52, cap7:509-511): no hay registro de 600 s. El `check_time` de la verificación sin lotes vacíos es de 0,12 s (HC) y 0,08 s (ACO), del mismo orden.
- **"La suite funcional tardó 51 s con 6 procesos y 46 en secuencia"** (cap5:345-347): no hay corrida guardada con 6 procesos en la suite funcional.
- **"248 soluciones dieron el mismo veredicto con y sin el recorte"** (ap6.tex:64-65): no hay archivo con esa comparación.
- **"Tomar las rutas mínimas y agregarles la espera óptima reproduce exactamente el objetivo del Split"** (cap6:577-579): sin archivo.
- **`W_c = 9` en la instancia del escenario 04 del estudio 11** (cap6:322, 338): el CSV no registra `W_c`. Es coherente con la fecha (2026-09-23, anterior al cambio de `W_c` en `6c4d536`, 2026-09-28), pero no se confirmó.
- **Hardware y versiones** (cap5:30-44: i7-1360P, ZIMPL 3.6.2, SCIP 9.2.3, PySCIPOpt 5.6.0, SoPlex 7.1.5, Python 3.13): `experiments/` y `results/` no los registran. No se revisaron los archivos de dependencias, que quedan fuera del alcance de D.
- **Que la Etapa 1 se reparta "solo cuando hay más de 4 lotes"** (cap5:347-348) y que la suite funcional se ejecutara con la Etapa 1 secuencial: no se revisó el código de `tests/opp_split/stage1_decomposition.py` (fuera del alcance de D).
- **Las afirmaciones de cap5:217-219** ("con las rutas de esa instancia, ningún picker lento puede ejecutar un lote" con `T_cold = 280`): habría que recalcular las rutas; no se hizo.
- **ap5 y ap8** (relevamiento y calibración de las heurísticas): fuera del alcance pedido; solo se verificaron los números de cap6/cap7 que dependen de ellos (semillas).
- **Ejecución:** no se ejecutaron tests ni experimentos, por indicación expresa. Todo lo marcado "Sí" se recalculó a partir de archivos guardados en `main`.
