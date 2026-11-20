# Auditoría — Sección C: tests

Alcance: solo la sección C del prompt de auditoría. Solo lectura; **no se ejecutó ningún test**.

- **Tesina:** `Apendices/ap4.tex` y `Apendices/ap6.tex` completos, y los fragmentos de los demás `.tex` que mencionan pruebas (grep de `test|prueba|pytest|unittest|verificaci|suite`). Sobre todo `Capitulos/cap5.tex:49-131`, `304-380` y `435-594`, `cap6.tex:384-391`, `cap7.tex:445`, `resumen.tex:15` y `abstract.tex:14`.
- **Repo:** `linear-picking-routing`, rama `main` (working tree en `main` y limpio al momento de leer). Se leyeron `tests/` completo, `verification/` y `.github/workflows/`.
- **Evidencia de resultados:** solo lo que está guardado en el repo:
  - los CSV de `results/<modelo>/functional/`, `results/compliance/` y `results/comparability/compare_split_vs_mono.csv`;
  - `tests/shared_scenarios/functional/functional_instances.json`;
  - `scripts/baseline_counts.json` (lo usa el CI);
  - `.env.example`;
  - los mensajes de commit de `git log`.

  Lo demás de `scripts/`, `experiments/` y `docs/` no se leyó.

Notación: `T:` indica una ruta de la tesina; las rutas sin prefijo son del repo.

---

## 1. Resumen de hallazgos

| # | Sev. | Hallazgo | Tesina | Evidencia |
|---|---|---|---|---|
| C-1 | **Crítico** | La tesina describe las pruebas funcionales de HC/ACO como una repetición de las instancias capturadas del Split que solo exige que coincida el estado. En `main` eso ya no es así: HC y ACO corren los 62 tests compartidos con las mismas aserciones que los modelos lineales. Los resultados guardados son de la versión anterior. | `T:cap5.tex:116-128`, `549-551` | `tests/infra/cases/heuristic_model_case.py:1-11`; `tests/opp_hc/functional/test_functional_cases.py:6`; `tests/infra/factories/functional_instances.py:9-10`; commit `03b501c` (2026-11-17) |
| C-2 | Mayor | La prueba 24b no ejercita el chequeo de elegibilidad previo a la Etapa 2 del Split. Corta antes de ese chequeo y verifica un helper del propio test. | `T:cap5.tex:63-65`, `T:ap4.tex:44` | `tests/opp_split/functional/test_case_24b.py:13-17`; `tests/opp_split/opp_split_test_case.py:132-157`; `tests/infra/cases/exact_model_case.py:144-157` |
| C-3 | Mayor | En el caso 28 el test acepta `infeasible` para la fecha ajustada. La tesina dice que ambas variantes tienen solución. | `T:ap4.tex:57` | `tests/functional_cases/case_28.py:82` |
| C-4 | Mayor | cap5 dice que los casos 15 a 20 verifican "rutas esperadas". Pero 15, 16 y 18 solo verifican el estado, y 19c y 20 solo que la ruta cubra las ubicaciones. ap4 lo describe bien, así que cap5 contradice a ap4 y al código. | `T:cap5.tex:70-71` | `case_15.py:138-151`, `case_16.py:150-164`, `case_18.py:94-108`, `case_19.py:137-160`, `case_20.py:140-151` |
| C-5 | Mayor | No hay en el repo ningún test, script ni salida que respalde la "validación del verificador" (4 errores introducidos), el control "248 soluciones con y sin recorte" ni la verificación de las soluciones de estrés del Split. | `T:ap6.tex:64-65`, `76-81`; `T:cap5.tex:529-531` | No hay tests de `verification/` en `tests/`; `verification/compare_split_vs_mono.py:207-222` solo imprime |
| C-6 | Menor | En 09 y 17 (un solo lote) los controles de "carga equilibrada" y "sin superposición" no se ejecutan o se cumplen trivialmente. | `T:ap4.tex:24`, `32`; `T:cap5.tex:77` | `case_09.py:137-140`, `case_17.py:128-131` |
| C-7 | Menor | "Cada ruta es la esperada": el test compara la **unión** de los arcos de todos los lotes, no la ruta de cada lote. | `T:ap4.tex:15-26` | `case_01.py:147-157`, `case_11.py:162-175` |
| C-8 | Menor | Cantidades imprecisas: "38 casos" (el 12 no tiene pruebas) y "70 instancias" (son 69 más el 36c, que no genera instancia). Tampoco se informan los conteos de HC (64) y ACO (65). | `T:resumen.tex:15`, `T:abstract.tex:14`, `T:cap5.tex:56`, `122`, `588`, `T:cap7.tex:445` | `case_12.py:12-14`; `functional_instances.json` (`not_captured`); `scripts/baseline_counts.json` |
| C-9 | Menor | Varias descripciones de ap4 se quedan cortas o son parciales: 04, 25f, 13/14 y 38. | `T:ap4.tex:18`, `29`, `50`, `79` | Ver tabla 2 |
| C-10 | Menor | Detalles del verificador que ap6 omite: el reloj arranca en `start_time`, el recorte a subgrafo tiene una condición extra y el diagnóstico por lote tiene un tope de 40 lotes. | `T:ap6.tex:115-121`, `143-145` | `verification/mono_compliance.py:36`, `215`, `354`, `379` |
| C-11 | Menor | La tesina no dice qué afirma una prueba de estrés para darse por aprobada. | `T:cap5.tex:135-300` | `tests/opp_*/stress/stress_test_case.py` |
| C-12 | Menor | `compare_split_vs_mono.csv` clasifica el 36c como `both_infeasible`, aunque la tesina aclara que el 36c "no es de infactibilidad". | `T:cap5.tex:113-114` | `results/comparability/compare_split_vs_mono.csv` |

---

## 2. Tabla de trazabilidad: test de la tesina → repo

La tesina no nombra los tests por su nombre Python sino por número y letra de caso (Cuadro `tab:pruebas_funcionales` de ap4). En el repo, cada método lleva esa etiqueta en el docstring (`"""Case 24a."""`): las letras siguen el orden alfabético de los métodos (`tests/functional_cases/__init__.py:16-18`). La columna "Existe" responde si el caso existe con esa etiqueta exacta.

- **Archivos.** Salvo indicación, los tests están en `tests/functional_cases/case_NN.py`. Cada modelo los liga con `bind_cases` en `tests/<modelo>/functional/test_functional_cases.py`.
- **Columna "Evidencia".** Indica el estado en `results/opp_split/functional/output_opp_split_functional_tests.csv` (S) y en `results/opp_mono/functional/output_opp_mono_functional_tests.csv` (M).
- **HC/ACO.** En los CSV de HC/ACO todas las filas están `ok`, pero corresponden a la versión anterior de las pruebas (ver C-1).

| Caso | Existe | Nombre real (método) | Qué dice la tesina (ap4) | Qué verifican los asserts | Coincide | Evidencia |
|---|---|---|---|---|---|---|
| 01 | sí ("Case 1a") | `Case01.test_basic_two_orders_capacity_limit` | 2 pedidos, 2 lotes, 2 pickers; cada picker un lote; cada ruta la esperada | estado; cada lote con 1 picker; cada picker con 1 lote; grafo unión de arcos == esperado; balance; sin solape (`case_01.py:95-161`) | sí (la ruta se compara como unión, C-7) | S ok, M ok |
| 02 | sí | `Case02.test_two_orders_two_aisles` | cada lote sigue su pasillo; cada picker un lote | estado; 1 picker por lote; grafo unión == esperado; balance; sin solape. "Cada picker ejecuta un lote" no tiene un assert propio, pero con 2 pickers y 2 lotes el balance ≤1 lo exige (`case_02.py:120-177`) | sí | S ok, M ok |
| 03 | sí | `Case03.test_two_orders_two_aisles` | instancia del 02 + cada picker un lote, balance, sin solape | igual que 02, más el assert de 1 lote por picker (`case_03.py:143-147`) | sí | S ok, M ok |
| 04 | sí | `Case04.test_two_orders_two_aisles_one_picking_point_per_order` | las rutas cubren las ubicaciones requeridas | grafo exacto == esperado, 1 lote por picker, balance y sin solape (`case_04.py:131-182`): más que lo que dice la tesina | sí (la tesina se queda corta) | S ok, M ok |
| 05 | sí | `Case05.test_two_orders_two_aisles_using_one_aisle` | comparten ubicación; rutas esperadas; balance; sin solape | sí; L2 compartida (`case_05.py:27-30`) | sí | S ok, M ok |
| 06a | sí | `Case06ShortestRoute.test_every_route_is_optimal_when_all_arrive_in_time` | cada lote con ruta, termina en su fecha | estado; cobertura; `c_b=15` y objetivo 30 **solo en los modelos lineales** (`case_06.py:42-58`) | sí (en HC/ACO solo se verifica la cobertura) | S ok, M ok |
| 06b | sí | `Case06ShortestRoute.test_shorter_route_is_chosen_when_the_longer_one_is_late` | se elige la ruta corta | arcos == ruta corta; `c_b=10` y objetivo 20 solo en los modelos lineales (`case_06.py:24-40`) | sí | S ok, M ok |
| 07 | sí | `Case07.test_repeated_picking_locations` | infactible por repetición | `status == infeasible` (`case_07.py:95`) | sí | S ok, M ok |
| 08 | sí | `Case08.test_repeated_picking_locations_2` | tiene solución, ruta esperada | estado; grafo == esperado; sin solape (`case_08.py:96-144`) | sí | S ok, M ok |
| 09 | sí | `Case09.test_two_orders_two_locations` | ruta esperada, balance, sin solape | ruta esperada sí; balance **no se ejecuta** (`B={B1}`, guarda `len(B)>1`, `case_09.py:137-138`); sin solape trivial | parcial (C-6) | S ok, M ok |
| 10 | sí | `Case10.test_two_orders_two_locations_two_missions` | ruta esperada por lote, balance, sin solape | sí | sí | S ok, M ok |
| 11 | sí | `Case11.test_four_orders_two_locations_two_missions` | rutas esperadas | unión de arcos == esperado (el arco L1→L3 es común a los dos lotes, `case_11.py:162-167`); balance; sin solape | parcial (C-7) | S ok, M ok |
| 12 | sí, sin tests | `Case12` (sin métodos) | sin pruebas activas | sin métodos (`case_12.py:12-14`) | sí | — |
| 13 | sí | `Case13.test_two_periods_two_orders_per_vehicle` | 12 pedidos, 6 lotes, 3 pickers, 4×4: balance y sin solape | estado; balance; sin solape (`case_13.py:169-178`) | sí | S ok, M ok |
| 14 | sí | `Case14.test_one_period_two_orders_per_vehicle` | misma instancia y controles que 13 | igual que 13. Las fábricas solo difieren en el dict `x`, que el test descarta (`shared_scenarios/common/six_missions_three_pickers_grid_graph.py:3-34`) | sí (el test duplica al 13) | S ok, M ok |
| 15 | sí | `Case15.test_3_orders_1_mission_1_picker` | tiene solución | solo el estado. Construye `output_graph` pero no lo compara (`case_15.py:138-151`) | sí | S ok, M ok |
| 16 | sí | `Case16.test_6_orders_3_missions_2_pickers` | tiene solución | solo el estado (`case_16.py:150-164`) | sí | S ok, M ok |
| 17 | sí | `Case17.test_branched_single_mission_route` | ruta esperada, balance, sin solape | ruta esperada sí; `P={P1}`, `B={B1}`: no hay balance y el solape es trivial (`case_17.py:128-131`) | parcial (C-6) | S ok, M ok |
| 18 | sí | `Case18.test_detour_single_mission_route` | tiene solución | solo el estado (`case_18.py:104-108`) | sí | S ok, M ok |
| 19a | sí | `Case19.test_longer_single_mission_duplicate_location` | tiene solución | estado (`case_19.py:186-193`) | sí | S ok, M ok |
| 19b | sí | `Case19.test_longer_single_mission_penalties` | fecha 0 → demora; fecha 100 → sin demora | Σta>0 con fecha 0; Σta≤1e-6 con fecha 100 (`case_19.py:162-184`) | sí | S ok, M ok |
| 19c | sí | `Case19.test_longer_single_mission_route` | camino válido que cubre lo requerido | `assert_route_covers_orders` (camino simple, sin ciclos, cobertura; `route_assertions.py:1-73`) | sí | S ok, M ok |
| 20 | sí | `Case20.test_grid_multi_location_orders` | cada lote visita todas sus ubicaciones | estado; cobertura por lote (`case_20.py:133-151`) | sí | S ok, M ok |
| 21 | sí | `Case21.test_bridge_disconnected_required_location` | infactible (ubicación inalcanzable) | `status == infeasible` (`case_21.py:89`) | sí | S ok, M ok |
| 22a | sí | `Case22.test_earliness_when_batch_finishes_before_due_date` | termina antes: no hay demora | `ea>0` y `ta≈0` (`case_22.py:90-94`) | sí | S ok, M ok |
| 22b | sí | `Case22.test_tardiness_when_batch_finishes_after_due_date` | termina después: no hay adelanto | `ta>0` y `ea≈0` (`case_22.py:159-167`) | sí | S ok, M ok |
| 23a | sí | `Case23RoutingAndScheduling.test_longer_route_is_assigned_to_the_faster_picker` | la ruta larga va al picker rápido | B2→P_fast, B1→P_slow; sin solape (`case_23.py:27-36`) | sí | S ok, M ok |
| 23b | sí | `Case23RoutingAndScheduling.test_routes_are_exported_and_used_by_scheduling` | tiempos de ruta usados por la asignación; sin solape | `r_B1=5`, `r_B2=14`; cobertura; todos asignados; `c_pb ≥ F_b + r_b/V_p` y sin solape (`case_23.py:13-25`, `exact_model_case.py:88-108`) | sí | S ok, M ok |
| 24a | sí | `Case24ColdChain.test_cold_chain_filters_out_the_slow_picker` | el frío excluye al lento | asignación == {B1: P_fast}; F + r/2 ≤ T_cold < F + r (`case_24.py:13-22`) | sí | S ok, M ok |
| 24b | sí, solo en el Split (sin etiqueta "Case 24b" en el docstring del método) | `tests/opp_split/functional/test_case_24b.py: Case24bPreflightEligibility.test_preflight_detects_when_no_picker_is_eligible` | el chequeo previo no encuentra pares elegibles | `run_pipeline(..., solve_stage2=False)` vuelve en `opp_split_test_case.py:132-133`, antes de `batches_without_eligible_picker` (`:138-157`). El assert usa `ExactModelTestCase.eligible_pairs`, un helper del test | **no** (C-2) | S ok (no existe en M) |
| 25a | sí | `Case25.test_grid_batch_infeasible_order_size` | un lote supera la capacidad → infactible | B1 = 3+2+2 = 7 > 6 → `infeasible` (`case_25.py:294-331`) | sí | S ok, M ok |
| 25b | sí | `Case25.test_grid_duplicate_location_within_batch` | dos pedidos en la misma ubicación → solución | estado (`case_25.py:371-407`) | sí | S ok, M ok |
| 25c | sí | `Case25.test_grid_multi_location_orders_with_capacities` | cada lote visita sus ubicaciones | estado y cobertura (`case_25.py:96-159`) | sí | S ok, M ok |
| 25d | sí | `Case25.test_grid_order_size_bigger_than_cart_infeasible` | todos los lotes por encima → infactible | 9 > 6 en los 4 lotes → `infeasible` (`case_25.py:264-292`) | sí | S ok, M ok |
| 25e | sí | `Case25.test_grid_penalties_due_date` | fechas 0 y 100 → solución en ambos | estado en ambas (`case_25.py:161-209`) | sí | S ok, M ok |
| 25f | sí | `Case25.test_grid_penalties_order_size_equal_to_cart` | carga igual a la capacidad → solución | dos variantes: `C_n=1` (carga 3 < 6) y `C_n=2` (carga 6 = 6), las dos factibles (`case_25.py:211-262`) | parcial: ap4 omite la variante con carga menor | S ok, M ok |
| 25g | sí | `Case25.test_grid_shared_locations_across_batches` | ubicaciones compartidas → solución | estado (`case_25.py:333-369`) | sí | S ok, M ok |
| 26a | sí | `Case26.test_bridge_disconnected_required_location_with_capacities` | inalcanzable → infactible | `infeasible` (`case_26.py:87-97`) | sí | S ok, M ok |
| 26b | sí | `Case26.test_bridge_earliness_order_size` | fechas muy holgadas, dos tamaños → solución | fecha 5000; `C_n=1` y `C_n=2`; estado (`case_26.py:181-224`) | sí | S ok, M ok |
| 26c | sí | `Case26.test_bridge_shared_locations_across_batches` | compartidas → solución | estado (`case_26.py:99-134`) | sí | S ok, M ok |
| 26d | sí | `Case26.test_bridge_tardiness_beta_picking` | fecha ajustada, `T_pick` bajo y alto → solución | fecha 10; `T_pick` 0,5 y 2,0; estado (`case_26.py:136-179`) | sí | S ok, M ok |
| 27 | sí | `Case27.test_basic_two_orders_with_different_weights` | instancia del 01 con otros pesos | solo el estado (`case_27.py:77`); ap4 no dice qué se verifica | sí, pero el test es débil | S ok, M ok |
| 28 | sí | `Case28.test_due_dates_tight_vs_relaxed` | las dos variantes tienen solución | ajustada: `assertIn(status, ("optimal","feasible","infeasible"))` (`case_28.py:82`); holgada: factible | **no** (C-3) | S ok, M ok |
| 29 | sí | `Case29.test_one_empty_batch_allowed` | un lote vacío → solución | estado (`case_29.py:83`) | sí | S ok, M ok |
| 30a | sí | `Case30.test_fractional_and_zero_capacities_feasible` | capacidades nulas y fraccionarias dentro de la capacidad → solución | `C_v=6` → factible (`case_30.py:91-97`) | sí | **S timeout, M timeout** |
| 30b | sí | `Case30.test_fractional_and_zero_capacities_infeasible` | superan la capacidad → infactible | `C_v=5` → `infeasible` (`case_30.py:86-89`) | sí | S ok, M ok |
| 31a | sí | `Case31.test_order_assigned_to_multiple_batches_infeasible` | pedido en más de un lote → infactible | `infeasible` (`case_31.py:76-85`); rechazado antes de resolver (`tests/infra/zimpl/zpl_utils.py:9`, `32-59`) | sí | S ok, M ok |
| 31b | sí | `Case31.test_order_assigned_to_single_batch_feasible` | un único lote → solución | estado (`case_31.py:87-97`) | sí | S ok, M ok |
| 32 | sí | `Case32.test_single_order_exceeds_vehicle` | un pedido supera el carro → infactible | `infeasible` (`case_32.py:77`) | sí | S ok, M ok |
| 33a | sí | `Case33.test_service_time_mixed` | servicios distintos → solución | estado (`case_33.py:76`, `89-90`) | sí | S ok, M ok |
| 33b | sí | `Case33.test_service_time_one` | servicio 1 → solución | estado | sí | S ok, M ok |
| 33c | sí | `Case33.test_service_time_zero` | servicio nulo → solución | estado | sí | S ok, M ok |
| 34a | sí | `Case34SpeedFormula.test_completion_time_matches_the_documented_formula_exactly` | ejecución = F + r/V | `r_B1=5`, `r_B2=14`; asignación; `c_pb = F_b + r_b/V_p` exactos; sin solape (`case_34.py:22-46`) | sí (verifica `c_pb`, que coincide con `T_exec` por ser el primer lote) | S ok, M ok |
| 34b | sí | `Case34ColdChainEdgeCases.test_no_eligible_picker_returns_infeasible_gracefully` | ningún picker elegible → infactible sin fallar | `eligible_pairs == ∅`; `status == infeasible`; `values == {}` (`case_34.py:71-80`) | sí. Este test sí ejercita el chequeo previo del Split | S ok, M ok |
| 34c | sí | `Case34ColdChainEdgeCases.test_picker_exactly_at_the_cold_chain_limit_is_still_eligible` | justo en el límite sigue elegible | par elegible y asignación a P_fast (`case_34.py:56-69`) | sí | S ok, M ok |
| 35a | sí | `Case35ColdChainCoverage.test_cold_limit_applies_to_each_batch_not_the_whole_shift` | el límite es por lote, no por turno | ambos lotes en P_fast; fines en 9 y 18; 18 > T_cold; objetivo 27 (`case_35.py:31-47`) | sí | S ok, M ok |
| 35b | sí | `Case35ColdChainCoverage.test_cold_limit_tolerance_keeps_a_picker_within_rounding_noise` | dentro de la tolerancia sigue elegible | par elegible y asignación (`case_35.py:49-57`) | sí | S ok, M ok |
| 35c | sí | `Case35ColdChainCoverage.test_fixed_time_counts_toward_the_cold_limit` | la parte fija cuenta → infactible | `infeasible`; `values == {}` (`case_35.py:21-29`) | sí | S ok, M ok |
| 36a | sí | `Case36SpeedCoverage.test_batches_are_split_when_fast_picker_is_only_twice_as_fast` | con V=2 se reparten | un lote por picker; fines en 9 y 16; objetivo 25 (`case_36.py:34-48`) | sí | S ok, M ok |
| 36b | sí | `Case36SpeedCoverage.test_fast_picker_takes_both_batches_when_four_times_faster` | con V=4 el rápido hace los dos | ambos en P_fast; fines en 5,5 y 11; objetivo 16,5 (`case_36.py:18-32`) | sí | S ok, M ok |
| 36c | sí | `Case36SpeedCoverage.test_non_positive_speed_is_rejected_before_solving` | velocidades ≤ 0 rechazadas antes de resolver | para 0 y −1: `run_pipeline` lanza `AssertionError` que nombra al picker (`case_36.py:62-71`) | sí | S ok, M ok |
| 36d | sí | `Case36SpeedCoverage.test_tardiness_uses_the_speed_scaled_route_time` | demora con tiempo escalado | `c_b=30`, `ta=10`, `ea=0`, objetivo 310 (`case_36.py:50-60`) | sí | S ok, M ok |
| 37a | sí | `Case37JustInTime.test_batch_is_delayed_while_early_orders_outweigh_completion_weight` | con W_c < pedidos, el lote espera | `ta=0`; `c_b=20`, `ea=0` y objetivo 20 solo en los modelos lineales (`case_37.py:20-37`) | sí | S ok, M ok |
| 37b | sí | `Case37JustInTime.test_batch_is_not_delayed_when_completion_weight_dominates` | con W_c mayor termina lo antes posible | `c_b=9`, `ea=11`, `ta=0`, objetivo 78 (`case_37.py:39-50`) | sí | S ok, M ok |
| 38 | sí, dos implementaciones distintas (sin etiqueta "Case 38" en el docstring) | `tests/opp_split/functional/test_case_38.py` y `tests/opp_mono/functional/test_case_38.py`, ambos `Case38SimplePathLimit.test_route_that_must_revisit_a_vertex_is_infeasible` | dos pasillos sin salida → infactible | Split: solo resuelve la Etapa 1 y exige `infeasible` (`opp_split/.../test_case_38.py:23-28`). Mono: pipeline completo, `infeasible` y `values=={}` (`opp_mono/.../test_case_38.py:20-25`) | sí, pero el código no es compartido (C-9) | S ok, M ok |

**Etiquetas.** Las 64 pruebas de ap4 existen con la etiqueta exacta del docstring, salvo dos detalles: 24b y 38 llevan la etiqueta en el nombre de la clase y no en el docstring del método (lo contrario de lo que dice `tests/README.md`), y ap4 numera "01" donde el docstring dice "Case 1a". No hay pruebas de la tesina que falten en el repo.

---

## 3. Hallazgos en detalle

### C-1 (Crítico): la tesina describe una versión de las pruebas de HC/ACO que ya no está en `main`

- **Qué dice la tesina.**
  - `T:cap5.tex:116-128`: para las heurísticas "se capturan las [instancias] que resuelve el modelo Split en sus pruebas funcionales [...] Las pruebas del Split definen 70 instancias [...] y HC y ACO resuelven 68 de ellas: la 36c queda afuera [...] y la 37a [...]. En estas pruebas solo se exige que el estado, con o sin solución, coincida con el del Split".
  - `T:cap5.tex:549-551`: "En la suite funcional, las heurísticas resuelven las instancias capturadas del Split".
- **Qué hay en `main`.**
  - El commit `03b501c` (2026-11-17, "Run the shared functional cases on the heuristics through an adapter") eliminó esa repetición. Su mensaje dice: *"the heuristics ran a status-only replay of the Split's instances instead [...] the four models now run the same 62 shared tests with the same scenarios and assertions [...] bind_instances() is gone"*.
  - El adaptador `HeuristicModelTestCase` (`tests/infra/cases/heuristic_model_case.py:1-11`, `40-127`) resuelve la instancia de cada caso con la heurística y devuelve la solución con los nombres de las variables del modelo exacto. Así, las aserciones de ruta esperada, objetivo exacto, tiempos, etc. se aplican también a HC y ACO.
  - Las únicas excepciones son los valores que dependen de la espera voluntaria en 06a, 06b y 37a (`exact_model_case.py:24-28`, `waits_voluntarily = False` en `heuristic_model_case.py:47`; commit `ab93e32`).
  - `tests/infra/factories/functional_instances.py:9-10` lo dice explícitamente: *"The heuristics do not read it: they run the functional cases themselves"*. El JSON queda solo como referencia del Split para el registro de comparabilidad (`tests/README.md`).
- **Cambia también el conjunto de instancias.** Con el código actual, HC y ACO:
  - **sí** corren 37a, con la parte de la espera desactivada;
  - **no** corren 24b ni 38, porque son tests propios del Split y del Mono (`tests/opp_hc/functional/` y `tests/opp_aco/functional/` solo tienen `test_functional_cases.py`, `test_case_invalid_speed_rejected.py` y, en ACO, `test_case_unreachable_required_location.py`);
  - corren tests propios que la tesina no menciona (ver la sección 5).
- **Los resultados guardados son de la versión anterior.**
  - `results/opp_hc/functional/output_opp_hc_functional_tests.csv` y el equivalente de ACO tienen 70 filas: 68 instancias (incluidas 24b y 38, sin 37a ni el 36c compartido) más los 2 tests de velocidad inválida.
  - El commit `c1f3a09`, posterior a `03b501c`, dice que solo se re-resolvieron las "68 functional instances" y que el resto de las filas siguen siendo "of the 2026-09-29 runs".
  - El CSV de ACO tampoco tiene una fila para `test_case_unreachable_required_location`.
  - Consecuencia: la tesina es coherente con los **datos guardados**, pero no con el **código de tests de `main`**. Para la versión actual de los tests de HC/ACO no hay ninguna corrida guardada (ver la sección 6).
- **Sugerencia.** Elegir una de dos opciones:
  - **(a)** Reescribir `T:cap5.tex:116-128` para describir el adaptador: mismas 62 pruebas y mismas aserciones, salvo la espera en 06a/06b/37a. Volver a correr las suites funcionales de HC y ACO y regenerar los CSV, la verificación y las comparaciones. Ajustar la cantidad de instancias (incluye 37a y deja afuera 24b y 38).
  - **(b)** Si se quiere conservar lo reportado, aclarar que los resultados de las heurísticas vienen de la repetición de las instancias del Split, anterior a `03b501c`, y que el repo hoy prueba otra cosa.

### C-2 (Mayor): la 24b no prueba el chequeo previo del Split

- **Qué dice la tesina.** `T:cap5.tex:63-65`: "la prueba 24b, que verifica el chequeo de elegibilidad previo a la Etapa 2, un paso que solo existe en el Split". En el mismo sentido, `T:ap4.tex:44`.
- **Qué hace el código.**
  - `test_case_24b.py:15` llama a `run_pipeline(scenario, solve_stage2=False)`, que vuelve en `opp_split_test_case.py:132-133`. Eso ocurre **antes** de llamar a `batches_without_eligible_picker` (`:138-157`), que es el chequeo previo real.
  - El assert (`test_case_24b.py:17`) compara con `∅` el resultado de `ExactModelTestCase.eligible_pairs` (`exact_model_case.py:144-157`), un recálculo del propio test sobre los tiempos de ruta de la Etapa 1.
  - En la práctica, el chequeo previo del Split se ejercita en 34b y 35c, que llaman a `run_pipeline` completo y obtienen `infeasible` por `stuck_batches`.
- **Sugerencia.** Elegir una de dos opciones:
  - describir la 24b como "verifica que, con los tiempos de ruta de la Etapa 1, ningún par picker–lote cumple el límite de frío", y atribuir la prueba del chequeo previo a 34b y 35c;
  - o cambiar el test para que llame a `batches_without_eligible_picker`, o a `run_pipeline` completo, y verifique que devuelve `infeasible` sin compilar la Etapa 2.

### C-3 (Mayor): el caso 28 no exige lo que dice la tesina

- **Qué dice la tesina.** `T:ap4.tex:57`: "Fechas de entrega ajustadas y holgadas: ambas tienen solución, porque la demora absorbe la fecha ajustada". El docstring del test dice lo mismo (`case_28.py:14-15`).
- **Qué hace el test.** Para la fecha ajustada, `case_28.py:82` acepta `("optimal", "feasible", "infeasible")`, así que pasa aunque el modelo devuelva infactible.
- **Evidencia indirecta.** En `functional_instances.json`, las dos instancias de `Case28` quedaron `optimal` en el Split. La afirmación es cierta para esa corrida, pero el test no la garantiza.
- **Sugerencia.** Decir "se verifica que la fecha holgada tiene solución; la ajustada no se exige" o, mejor, sacar `"infeasible"` del assert. Las aserciones nunca deben relajarse para que un test pase (convención de `tests/README.md`).

### C-4 (Mayor): cap5 dice "rutas esperadas" para casos que no las verifican

- **Qué dice la tesina.** `T:cap5.tex:70-71`: "**Ruteo**: rutas esperadas en pasillos, grillas y grafos ramificados (01 a 05, 09 a 11 y 15 a 20)".
- **Qué hace el código.**
  - Solo comparan una ruta esperada: 01–05, 08–11 y 17.
  - 15, 16 y 18 solo afirman el estado. Construyen `output_graph` pero nunca lo comparan (`case_15.py:138-151`, `case_16.py:150-164`, `case_18.py:94-108`).
  - 19a afirma el estado; 19b, la demora; 19c y 20, solo que la ruta cubra las ubicaciones.
  - ap4 lo describe correctamente ("tiene solución"), así que cap5 y ap4 se contradicen.
- **Sugerencia.** "Rutas esperadas (01 a 05, 08 a 11 y 17), cobertura de las ubicaciones requeridas (19c, 20, 25c) y factibilidad en grillas y grafos con desvíos (15, 16, 18, 19a)". Opcionalmente, agregar a 15, 16 y 18 el assert que falta.

### C-5 (Mayor): afirmaciones sobre el verificador sin evidencia en el repo

- **`T:ap6.tex:76-81`.** "se introdujeron cuatro [errores] a propósito [...] El verificador detectó los cuatro". En `tests/` no hay ningún test de `verification/`. `git grep` no encuentra en `main` ningún script ni salida que inyecte errores (búsqueda: `inject|deliberate|on purpose|a propósito|mutat|cuatro errores`). No se puede reproducir.
- **`T:ap6.tex:64-65`.** "Como control, 248 soluciones dieron el mismo veredicto [...] con y sin este recorte". El parámetro `restrict` existe (`verification/mono_compliance.py:400`, `429-430`), pero no hay ninguna salida guardada de la comparación con y sin recorte, y `git grep '248'` no encuentra nada relacionado.
- **`T:cap5.tex:529-531`.** "las soluciones de estrés del Split se verificaron contra el modelo monolítico". `verify_split_stress` (`verification/compare_split_vs_mono.py:207-222`) solo imprime y no guarda nada. En `results/compliance/` hay archivos de HC y ACO, pero ninguno del Split.
- **Sugerencia.**
  - Agregar un test en `tests/` para `verification/`: una solución chica correcta que da `compliant` y cuatro mutaciones que dan `violations`.
  - Guardar las salidas del control con y sin recorte y de la verificación del Split en estrés, y citarlas.
  - Si no, marcar en la tesina que esas verificaciones fueron manuales y no quedaron registradas.

### C-6 a C-12 (Menores)

- **C-6.** En 09 (`B={B1}`) y 17 (`P={P1}`, `B={B1}`) la guarda `if len(P) > 1 and len(B) > 1` saltea `assert_workload_balance` (`case_09.py:137-138`, `case_17.py:128-129`), y `assert_no_time_overlap` se cumple siempre con un solo lote. ap4 (líneas 24 y 32) y `T:cap5.tex:77`, que pone a 09 y 17 en "Asignación y secuencia", dicen otra cosa. **Sugerencia:** sacar "carga equilibrada y sin superposición" de 09 y 17, y sacarlos de la lista de `T:cap5.tex:77`.
- **C-7.** En 01–05 y 08–11 la comparación es `output_graph == expected_graph`, donde `output_graph` es la unión de los arcos activos de todos los lotes (`case_01.py:147-157`). No verifica qué ruta corresponde a cada lote: en 11 el arco L1→L3 es común a los dos (`case_11.py:162-167`). **Sugerencia:** "el conjunto de arcos usados es el esperado", o cambiar a una comparación por lote.
- **C-8. Cantidades.**
  - "38 casos de prueba" (`T:resumen.tex:15`, `T:abstract.tex:14`, `T:cap5.tex:56`, `T:cap7.tex:445`): el caso 12 no tiene tests (`case_12.py:12-14`), así que son 37 casos con pruebas. ap4:27 lo aclara, pero el resumen no.
  - "Las pruebas del Split definen 70 instancias" (`T:cap5.tex:122`) y "De las 70 instancias funcionales" (`T:cap5.tex:588`): llegan al resolvedor 69 instancias (68 capturadas + 37a, que se excluye). El 36c no genera ninguna (`functional_instances.json` lo lista en `not_captured`). Las 70 son filas del CSV del Split, no instancias.
  - La tesina da solo 64 (Split) y 63 (Mono). En el repo hay además 64 (HC) y 65 (ACO), según `scripts/baseline_counts.json`, que el CI verifica en `.github/workflows/ci.yml` (`run_all --collect-only`).
- **C-9. Descripciones parciales de ap4.**
  - 04: el test verifica más de lo que dice ap4 (grafo exacto, un lote por picker, balance y sin superposición).
  - 25f: omite la variante con carga 3 < 6 (`case_25.py:244-252`).
  - 13/14: son la misma instancia y el mismo test, y lo único que cambia es un dict `x` que no se usa (`six_missions_three_pickers_grid_graph.py:3-34`). Convendría decir "duplicado del 13" o unificarlos.
  - 38: `T:cap5.tex:65` dice que "las demás pruebas son las mismas en los dos modelos", pero el 38 está implementado dos veces y la versión del Split solo resuelve la Etapa 1 (`tests/opp_split/functional/test_case_38.py:26-28`).
- **C-10. Detalles del verificador que ap6 omite.**
  - En el paso 11, el reloj arranca en `instance["start_time"] or 0.0` (`mono_compliance.py:215`), no siempre en 0.
  - El recorte a subgrafo (paso 15) exige además que ningún chequeo previo sobre rutas haya fallado (`:379`).
  - El diagnóstico lote por lote (paso 20) solo se hace con hasta 40 lotes (`:36`, `:354`).
  - Todo lo demás de ap6 coincide con el código (ver la sección 4).
- **C-11.** La tesina no explica qué significa que una prueba de estrés pase. En el código, las cuatro variantes de `assert_stress_pipeline` exigen estado `optimal` o `feasible`, que todos los lotes estén asignados, que las rutas cubran las ubicaciones requeridas y que no haya superposición por picker (`tests/opp_split/stress/stress_test_case.py:5-10`, `opp_mono/.../stress_test_case.py:5-10`, `opp_hc/.../stress_test_case.py:18-51`, `opp_aco/.../stress_test_case.py:18-48`). **Sugerencia:** una oración en `T:cap5.tex`, sección de pruebas de estrés o de ejecución.
- **C-12.** En `results/comparability/compare_split_vs_mono.csv`, las 12 filas `both_infeasible` del bloque funcional incluyen `test_non_positive_speed_is_rejected_before_solving` (36c). Eso contradice `T:cap5.tex:113-114`. No cambia los 60 pares, porque el 36c se excluye, pero conviene que el script lo etiquete aparte. Este punto toca la sección D; queda anotado.

---

## 4. Coincidencias verificadas (sin hallazgo)

- **64 pruebas en el Split y 63 en el Mono** (`T:cap5.tex:63`, `T:cap7.tex:445`). Son 62 compartidas más 24b y 38 en el Split, y más 38 en el Mono. Coincide con el conteo de métodos en `tests/functional_cases/`, con `scripts/baseline_counts.json` y con el comentario de `.github/workflows/nightly.yml` ("opp_split (64 tests) and opp_mono (63 tests)").
- **Rechazo antes de resolver.** El rechazo previo de capacidad (25a, 25d, 30b, 32) y de pedido en más de un lote (31a) está en `tests/infra/zimpl/zpl_utils.py:9`, `32-59` (`overloaded_batches`, `orders_without_exactly_one_batch`). Coincide con `T:cap5.tex:102-104`. Las velocidades no positivas se rechazan antes de resolver en los cuatro adaptadores (`opp_split_test_case.py:114-118`, `opp_mono_test_case.py:33-38`, `heuristic_model_case.py:69-73`). Coincide con `T:cap5.tex:113-114`.
- **Ejecución.**
  - Hay un proceso por prueba, en serie, y al vencer el tope se termina todo el árbol de procesos (`tests/infra/execution/runner.py:68-85`, `217-263`).
  - Los topes son de 25 min (funcional) y 40 min (estrés): `config.py:7-10` y `.env.example`. Ese archivo aclara que el 40 "was used for the ACO stress runs"; no se pudo confirmar qué tope se usó en cada modelo.
  - La Etapa 1 se reparte solo con más de 4 lotes (`tests/opp_split/stage1_decomposition.py:120`).
  - La semilla de las heurísticas es 1 (`tests/infra/factories/scenario_adapter.py:11`, `40`).
  - HC en estrés usa 200/60/30 s (`tests/opp_hc/stress/stress_test_case.py:18`), igual que el Cuadro `tab:hc_parametros` (`T:cap5.tex:400-402`).
- **ap6 contra `verification/mono_compliance.py`.** Coinciden:
  - los chequeos directos: un picker por lote y que exista, nodos y arcos del grafo, que no haya repeticiones, la cobertura, el frío con ε = 1e-9, los tiempos y finalizaciones, y el objetivo (`:143-237`);
  - la quita de lotes vacíos que no se usan (`:43-64`);
  - el subgrafo (`:363-397`);
  - el reemplazo de M y M^seq (`:240-256`);
  - la fijación por nombre en el LP (`:287-339`);
  - el nivel 1 con z, x e y, y el nivel 2 con c_pb y c_b informados (`:435-440`);
  - el diagnóstico primero por tipo y después por lote (`:342-360`);
  - la tolerancia relativa de 1e-6 (`:34`, `39-40`);
  - que da `error` cuando la verificación no corre (`:458-460`);
  - que da `skipped` cuando no hay solución (`run_compliance.py:144-148`);
  - el criterio de validez (`:442-457`).
- **Cuadro `tab:res_validez`** (`T:cap6.tex:388-391`). Funcional HC y ACO: 68 instancias, 56 válidas y 12 sin solución. `results/compliance/opp_{hc,aco}/functional/*.csv` tienen 70 filas: 56 `compliant` y 14 `skipped`, que son 12 sin solución más los 2 tests de velocidad inválida, que no tienen instancia. Estrés: 19/19 `compliant` en los dos. **Coincide**, aunque corresponde a la versión anterior de las pruebas (C-1).

---

## 5. Tests del repo que la tesina no menciona

Están agrupados por archivo. ★ marca los que convendría citar.

| Archivo | Tests | Qué verifican | Importancia |
|---|---|---|---|
| `tests/opp_hc/functional/test_case_invalid_speed_rejected.py` | `TestOPPHillClimbingInvalidSpeedRejected.test_zero_speed_is_rejected`, `test_negative_speed_is_rejected` | Llamando a la API de HC directamente (sin el adaptador), V=0 y V=−1 devuelven `("infeasible", None)` (`:74-82`) | ★ Es el 36c a nivel de la API de la heurística. Explica por qué HC tiene 64 tests |
| `tests/opp_aco/functional/test_case_invalid_speed_rejected.py` | `TestOPPAntColonyOptimizationInvalidSpeedRejected.test_zero_speed_is_rejected`, `test_negative_speed_is_rejected` | Lo mismo para ACO (`:71-79`) | ★ Igual que el anterior |
| `tests/opp_aco/functional/test_case_unreachable_required_location.py` | `TestOPPAntColonyOptimizationUnreachableRequiredLocation.test_disconnected_required_location_is_infeasible` | ACO devuelve `infeasible` en el grafo con el puente cortado (la instancia de 21/26a) (`:19-61`). No fija `Seed`, así que es estocástico (el comentario del job `functional` de `ci.yml` lo menciona) | ★ Explica los 65 tests de ACO. No está en el CSV guardado de ACO |
| `tests/opp_{split,mono,hc,aco}/stress/test_stress_cases.py` y `tests/stress_cases/case_01..19.py` | 19 por modelo (`Stress01..19`) | Ver C-11: estado, asignación completa, cobertura y sin superposición | ★ La tesina menciona los 19 escenarios, pero no qué exige cada test |
| `tests/functional_cases/*` corridos sobre HC y ACO (`tests/opp_{hc,aco}/functional/test_functional_cases.py`) | 62 por heurística | Las mismas aserciones que en los modelos lineales (C-1) | ★ Es la versión actual de las pruebas de las heurísticas |
| `.github/workflows/ci.yml` | `check_repo` y `run_all --collect-only` (conteos contra `baseline_counts.json`); suites funcionales de HC y ACO con `--retries 1`; humo de estrés con un tope de 60 s | Que el repo se mantenga bien formado y que las suites rápidas pasen en cada PR | Detalle de infraestructura; se puede omitir o mencionar en una línea |
| `.github/workflows/nightly.yml` | Todas las pruebas de estrés de HC y ACO con tope de 1 min; suites funcionales de Mono y Split con zimpl | Corrida nocturna | Detalle de infraestructura; su tope de 1 min no es el de la tesina |
| `tests/shared_scenarios/functional/export_functional_instances.py` | (herramienta, no es un test) | Captura las instancias y los estados del Split en el JSON | La tesina la describe sin nombrarla (`T:cap5.tex:119-121`). Bien |

No hay tests para `verification/`, `models/utils/*` ni `experiments/` dentro de `tests/` (ver C-5).

---

## 6. Resultados informados contra la evidencia del repo

| Afirmación de la tesina | Evidencia | Estado |
|---|---|---|
| El Split corre 64 pruebas y todas pasan salvo 30a, que no termina (`T:cap5.tex:63`, `558-559`) | `output_opp_split_functional_tests.csv`: 64 tests, 70 filas; 63 `ok` y 1 `timeout` (30a) | coincide |
| El Mono corre 63 pruebas y 30a no termina | `output_opp_mono_functional_tests.csv`: 63 tests, 69 filas; 62 `ok` y 1 `timeout` (30a); también el comentario de `nightly.yml` | coincide |
| HC y ACO resuelven 68 instancias, con el estado igual al del Split (`T:cap5.tex:122-127`) | CSV de HC y ACO: 70 filas `ok` (68 instancias + 2 tests de velocidad). Generados con la versión anterior a `03b501c` | coincide con los datos, **no con el código** (C-1) |
| HC y ACO con las pruebas actuales (adaptador, 62 tests compartidos más los propios) | No hay ninguna corrida guardada. El commit `03b501c` dice que 06a, 06b y 37a fallaban antes de la guarda de `ab93e32` | **no verificado (no se ejecutó)** |
| Verificación: 56 válidas y 12 sin solución en las funcionales; 19/19 en estrés (`T:cap6.tex:388-391`) | `results/compliance/...`: 56 `compliant` + 14 `skipped` (12 + 2 tests de velocidad); 19/19 | coincide |
| El verificador detectó los 4 errores introducidos (`T:ap6.tex:78-81`) | Sin evidencia en el repo | **no verificado** (C-5) |
| 248 soluciones con el mismo veredicto con y sin recorte (`T:ap6.tex:64-65`) | Sin evidencia en el repo | **no verificado** (C-5) |
| Las soluciones de estrés del Split se verificaron contra el Mono (`T:cap5.tex:529-531`) | `verify_split_stress` solo imprime; no hay archivo en `results/` | **no verificado** (C-5) |
| El CI pasa | No hay logs de GitHub Actions en el repo | **no verificado** |

---

## 7. Discrepancias en cantidades

| Cantidad | Tesina | Repo | Comentario |
|---|---|---|---|
| Casos funcionales | 38 | 38 identificadores (01–38), 37 con tests (el 12 está vacío) | Precisar en el resumen y el abstract (C-8) |
| Pruebas del Split / Mono | 64 / 63 | 64 / 63 | Coincide |
| Pruebas de HC / ACO | no se informan | 64 / 65 (`baseline_counts.json`) | Agregar (C-8) |
| Instancias funcionales del Split | 70 | 69 que llegan al resolvedor (68 capturadas + 37a); el 36c no genera instancia; el CSV tiene 70 filas | Precisión (C-8) |
| Instancias que resuelven HC/ACO | 68 | Datos guardados: 68. Código actual: 66 compartidas que generan instancia + 37a = 67; no incluye 24b ni 38 | Ver C-1 |
| Escenarios de estrés | 19 | 19 por modelo | Coincide |
| Pares Split–Mono (funcional) | 60 | No se recalculó (sección D). `compare_split_vs_mono.csv` tiene 69 filas funcionales: 30 `same_solution`, 25 `alternative_optimum`, 12 `both_infeasible` (incluye el 36c), 1 `same_status` (30a) y 1 `no_mono_result` (24b) | Ver C-12 |

---

## 8. Qué no pude verificar y por qué

- **Ejecución de las suites.** Por regla de esta tarea no se corrió ningún test. No sé si las suites actuales de HC y ACO, con el adaptador, pasan completas, ni si las aserciones exactas de los casos 34a, 35a, 36a, 36b, 36d y 37b se cumplen con las heurísticas.
- **Si los CSV de Split y Mono salieron del código actual de los tests.** Su último cambio es `e809cb4` (una fila por instancia), pero no consta con qué versión de las aserciones se generaron las corridas originales.
- **Estado del CI.** No hay logs en el repo.
- **Validación del verificador con 4 errores, control de las 248 soluciones y verificación de estrés del Split.** No hay salidas guardadas (C-5).
- **Qué tope de estrés se usó en cada modelo** (25 o 40 min). `.env` no está versionado y `.env.example` solo menciona el de ACO.
- **Fuera del alcance pedido:** no se leyeron `models/`, `scripts/` (salvo `baseline_counts.json`), `experiments/` ni `docs/`. Por eso no se verificó, por ejemplo, la implementación de `models/utils/input_validation.py` ni de `cold_chain_validation.py`: solo cómo las usan los tests.
