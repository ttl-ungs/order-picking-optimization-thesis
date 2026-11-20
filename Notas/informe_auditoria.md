# Informe de auditoría de la tesina

Informe único que junta las cinco auditorías de `Notas/`: `auditoria_AB.md`, `auditoria_C.md`,
`auditoria_D.md`, `auditoria_E.md` y `auditoria_FGH.md`. Se eliminaron los duplicados y cada hallazgo
Crítico o Mayor se volvió a verificar contra la fuente:

- la tesina, en el estado actual de los `.tex`;
- el código, en la rama `main` de `linear-picking-routing` (commit `1cec940`), leído con `git show`;
- los PDF de `zpaper`.

**Veredicto de la verificación.** Cada hallazgo grave lleva uno de dos veredictos:

- **Confirmado:** se reprodujo la evidencia.
- **Plausible:** la evidencia del código o del paper está, pero el efecto práctico no se pudo medir sin
  ejecutar.

En la verificación se cambió la severidad de tres hallazgos y no se descartó ninguno (ver §6). No se
ejecutaron tests ni experimentos. Los recálculos se hicieron con `python3` sobre los CSV de `main`.

**Convenciones.**

- `T:` indica una ruta de la tesina (`picking-route-optimization-thesis/`).
- `R:` indica una ruta del repositorio de código en `main`.
- "p. N" es una página del PDF.
- Entre corchetes va el origen de cada hallazgo en las auditorías parciales (por ejemplo, [C-1], [D4 = G2]).

---

## 1. Resumen ejecutivo: los 10 problemas más graves

| # | Sev. | Problema | Ubicación | Origen |
|---|---|---|---|---|
| 1 | Crítico | La tesina describe pruebas funcionales de HC y ACO (repetir las instancias capturadas del Split y exigir solo el estado) que ya no existen en `main`. Desde `03b501c`, HC y ACO corren los 62 tests compartidos con las mismas aserciones que los modelos lineales. Los CSV guardados son de la versión anterior. | `T:Capitulos/cap5.tex:116-128`, `:549-551` | [C-1] |
| 2 | Crítico | "Con un tope de 40 minutos, el monolítico sigue sin probar el óptimo en esos puntos". Pero el propio Cuadro `tab:res_40min` muestra que con 6 lotes en 5×5 lo prueba a los 32 min. | `T:Capitulos/cap6.tex:320-322` contra `:337` | [D4 = G2] |
| 3 | Crítico | "El Split queda entre un 46 y un 58 % por encima" de ACO a igual tiempo. Ese porcentaje toma como base al Split. Con ACO como base, el Split queda entre un 86 y un 141 % por encima. | `T:Capitulos/cap7.tex:456-458`, `T:Capitulos/cap6.tex:1002` | [G1] |
| 4 | Crítico | "Los rangos abarcan [...] los que reportan Alaya y Solnon y Lesch et al.". Es falso para ρ: Alaya usa 0,01 y Lesch 0,02, y el mínimo probado es 0,05. También es falso para β = 8 de Alaya, porque el máximo probado es 4. | `T:Apendices/ap8.tex:392-394` | [E-1] |
| 5 | Mayor | La corrida principal de HC en estrés (`20260928_210210`) es anterior al commit `75d553c` (2026-10-19), que volvió determinista el sorteo de rutas. Con el código actual, la semilla 1 da otro objetivo en 17 de 18 escenarios. La robustez entre semillas se midió con otra versión del código. | `T:Capitulos/cap5.tex:386`, `:423-428`; `T:Capitulos/cap6.tex:951-956` | [D2] |
| 6 | Mayor | El monolítico en estrés no resolvió los mismos datos en 05–19: usó `W_c = 9` en lugar de 27. La tesina afirma que los datos son idénticos en los 19 escenarios. | `T:Capitulos/cap5.tex:551-554` | [D3] |
| 7 | Mayor | No hay ningún test, script ni salida que respalde tres afirmaciones: la validación del verificador con 4 errores introducidos, el control de 248 soluciones con y sin recorte, y la verificación de las 9 soluciones de estrés del Split. | `T:Apendices/ap6.tex:64-65`, `:76-81`; `T:Capitulos/cap5.tex:529-531`; `T:Capitulos/cap6.tex:400-401` | [C-5, D-10, G13] |
| 8 | Mayor | "Los ajustes del verificador se usaron en pocos casos". En realidad, el subgrafo se usó en las 19 verificaciones de estrés de ACO y en 3 funcionales de cada heurística. | `T:Capitulos/cap6.tex:413-416` | [D7] |
| 9 | Mayor | "En los que no lo prueba, al menos 71 veces más". Los cocientes medidos son 68× (B4S6), 59× (B3S7) y 2,6× (B6S5). | `T:Capitulos/cap6.tex:294-296` | [D5] |
| 10 | Mayor | Los tiempos funcionales se comparan sobre "35 de las 45" instancias porque el registro tendría "una fila por prueba". Pero el runner y el CSV vigente guardan una fila por instancia. Con las 45, HC es más rápido en 45/45 y ACO en 28/45. | `T:Capitulos/cap6.tex:585-593`; `T:Apendices/ap7.tex:103-105` | [D6] |

Otros hallazgos Mayores confirmados (detalle en §2):

- reproducibilidad entre procesos [A1];
- λ = 1000 frente a la cota $K$ [A2 = F18];
- lotes vacíos en $f(s)$ [A3];
- la tesina no referencia el repositorio [B1];
- 24b, 28 y "rutas esperadas" en los tests [C-2, C-3, C-4];
- 60 frente a 66 pares [D1 = G3];
- heurística frente a metaheurística [F1];
- el objetivo del resumen [F2];
- infactible frente a rechazo [A9 = F3];
- la "equivalencia" en el resumen y el abstract;
- el camino simple "heredado" [E-2];
- el flujo "de tipo GG" [E-3];
- el "minimum solution" de Coruzzolo [E-4];
- la dedicatoria *placeholder* [H].

---

## 2. Hallazgos por sección

### A. Veracidad: tesina contra código

**A1. La reproducibilidad entre procesos no está garantizada para HC. Mayor. Plausible.** [A1, B3]
- **Tesina:** `T:Capitulos/cap5.tex:423-428`: "la misma semilla producen siempre la misma solución [...] Para que esto valga también entre procesos distintos, los candidatos de cada sorteo se recorren siempre en el mismo orden". `T:Apendices/ap8.tex:30` dice que el vecino más cercano "es determinística".
- **Evidencia:**
  - `R:models/utils/route_construction.py:688-693` ordena los candidatos del sorteo (`sorted(remaining)`). En eso coincide con la tesina.
  - El vecino más cercano de HC (`R:models/opp_hc/opp_hc.py:540-547`) hace `reachable = [loc for loc in remaining ...]` sobre un `set` de cadenas y después `min(reachable, key=dist)`. Ante distancias empatadas, que son comunes en una grilla, el resultado depende del orden de iteración del `set`, y ese orden depende de `PYTHONHASHSEED`. Esa ruta compite con las demás candidatas (`opp_hc.py:446-475`).
  - El repositorio se contradice. `R:experiments/heuristics/README.md:22` y `R:experiments/heuristics/aco/aco_study_common.py:108-114` dicen que hace falta `PYTHONHASHSEED=0`. El commit `c1f3a09` dice que "the heuristics no longer depend on PYTHONHASHSEED".
- **Qué es lo correcto:** el sorteo es determinista, pero el desempate del vecino más cercano no lo es. No se midió si cambia algún resultado.
- **Sugerencia:** ordenar el desempate en `_generate_feasible_route` (por ejemplo, con `key=lambda l: (dist[l], l)`) y unificar los comentarios del repositorio. Si no, escribir "con la misma semilla y el mismo `PYTHONHASHSEED`". En `ap8.tex:30`, cambiar "es determinística" por "no usa sorteos".

**A2. λ = 1000 no supera la cota $K$ que da la propia tesina. Mayor. Confirmado.** [A2 = F18]
- **Tesina:** `T:Apendices/ap8.tex:129-143` define $K = W^c|\mathcal{B}| + W^{pen}\max(W^e,W^t)|\mathcal{N}|$ y pide "λ > K". `T:Capitulos/cap4.tex:178-181` dice que λ es mayor que el aumento posible de $f$.
- **Evidencia:** `R:models/opp_hc/opp_hc.py:56` y `R:models/opp_aco/opp_aco.py:101` fijan 1000 para cualquier instancia. Con los datos de `tab:escenarios_estres` (`T:Capitulos/cap5.tex:273-293`) y los pesos que figuran en los CSV:
  - escenario 01: $9\cdot 30 + 750 = 1020$;
  - escenario 19: $27\cdot 24 + 624 = 1272$.
- **Qué es lo correcto:** el propio texto de ap8 razona sobre los lotes que siguen en la secuencia del picker del lote demorado. Esa cota ajustada sí queda por debajo de 1000 en todos los escenarios, así que la afirmación de cap4 es cierta. Lo que falla es la fórmula de $K$, que suma todos los lotes y todos los pedidos. En la práctica no cambia nada, porque solo el 11 activa la cadena de frío y ahí $K = 318$.
- **Sugerencia:** reemplazar $K$ por la cota por picker, $W^c m_p + W^{pen}\max(W^e,W^t)\,n_p$, donde $m_p$ son los lotes desde la posición del lote demorado hasta el final y $n_p$ sus pedidos. También se puede aclarar que λ es fijo y que supera $K$ en todas las instancias salvo en 01 y 19.

**A3. Las heurísticas no cobran los lotes vacíos, y los modelos lineales sí. Mayor. Confirmado.** [A3, B4]
- **Tesina:** `T:Capitulos/cap4.tex:7-9` ("con la misma función objetivo y las mismas restricciones") y `:129-133` ($f(s)$ suma $c_b$ sobre todo $\mathcal{B}$). Recién `T:Apendices/ap6.tex:55-58` y `T:Capitulos/cap7.tex:190-198` aclaran la diferencia.
- **Evidencia:** `R:models/opp_hc/opp_hc.py:491` asigna solo `[b for b in self.B if batch_assignments[b]]`. `R:verification/mono_compliance.py:43-52` dice: "Mono routes, assigns and charges every batch of B, even one without orders; the heuristics skip empty batches".
- **Sugerencia:** escribir la suma sobre los lotes con pedidos y agregar en `sec:heur_evaluacion` una oración que remita al Anexo de verificación.

**A4–A12. Imprecisiones de detalle. Menor.** [A4–A12, C-10, F13]
- **A4.** `improve_route` tiene un máximo de 5 rondas (`R:models/utils/route_construction.py:328`), que no se menciona en `T:Capitulos/cap4.tex:281-282` ni en `T:Apendices/ap8.tex:61-66`. Agregar "con un máximo de cinco rondas".
- **A5.** Solo las 20 construcciones aleatorias de HC pasan por la búsqueda local (`opp_hc.py:465-467`). El vecino más cercano y la inserción compiten sin mejorar, contra lo que dice `T:Capitulos/cap4.tex:281`.
- **A6.** La búsqueda *best-first* hace dos pasadas de hasta 2.000.000 de expansiones cada una (`route_construction.py:119-125`), no una (`T:Apendices/ap8.tex:111-117`, `:258`, `:330`).
- **A7.** La prueba de completitud con componentes biconexas corre sobre el grafo no dirigido subyacente (`route_construction.py:570-573`), así que en un grafo dirigido es una condición necesaria más débil (`T:Apendices/ap8.tex:52-57`). Además, la frase de `ap8.tex:55-56` ("de forma exacta [...] necesaria pero no suficiente") se lee como una contradicción [G15].
- **A8.** HC recorre los lotes en orden lexicográfico (`B10` antes que `B2`) y desempata por el índice del picker (`opp_hc.py:62`, `:496`). `T:Capitulos/cap4.tex:350-351` dice "en el orden de sus identificadores".
- **A10.** El 2-opt descarta la inversión si falta *alguno* de los dos arcos de unión (`opp_hc.py:692-698`). Corregir la redacción de `T:Apendices/ap8.tex:166-168`.
- **A11.** La verificación previa de capacidad usa tolerancias distintas en las heurísticas (`R:dtos/opp/solve_model_dto.py:159-165`) y en `R:models/utils/input_validation.py:34`. Es irrelevante para el texto, pero conviene unificar el código.
- **A12.** Si ninguna hormiga es válida, `continue` saltea la recombinación, la búsqueda local y la actualización de feromona, incluida la evaporación (`opp_aco.py:343-344`). Agregar la condición en la línea 13 del pseudocódigo (`T:Capitulos/cap4.tex:461-472`) y en `:637-640`.
- **F13.** $v(s)$ resta ε (`T:Capitulos/cap4.tex:165`) y $g_b$ no (`T:Apendices/ap8.tex:173`). La auditoría AB confirma que el código hace lo mismo (`opp_hc.py:675-678`): es coherente con el código, pero conviene decir por qué.

**Coincidencias verificadas.** Las restricciones, variables y objetivos de cap3 coinciden con los `.zpl` término a término. También coinciden la representación $(\pi,a,\sigma)$, los mecanismos de HC y ACO, MMAS, los valores por defecto (`R:dtos/hc/solve_hc_model_dto.py:13-15`, `R:dtos/aco/solve_aco_model_dto.py:13-21`), las constantes de ap8 y la verificación en tres pasos. El detalle está en `auditoria_AB.md`, "Afirmaciones verificadas sin diferencias".

### B. Cobertura: código contra tesina

**B1. La tesina no referencia el repositorio ni la versión del código. Mayor. Confirmado.**
- `grep -i "github\|repositorio"` sobre `Capitulos/` y `Apendices/` no da resultados.
- Sin la URL y el commit o tag, nada de cap5 y cap6 se puede reproducir.
- **Sugerencia:** una nota en `sec:software` (cap5) con la URL y el commit. Conviene agregar que los cuadros y figuras del cap. 6 se generan con `R:experiments/exact/reports/build_*.py` [D §5].

**Debería estar (Menor):**
- La dependencia de `PYTHONHASHSEED`, si se mantiene (ver A1).
- Que $M^{seq}$ se calcula en Python al escribir los `.dat` (`R:tests/infra/zimpl/dat_files_builder.py`, `_compute_m_seq`).
- Qué exige un test de estrés para darse por aprobado: estado con solución, todos los lotes asignados, rutas que cubren las ubicaciones y sin superposición (`R:tests/opp_*/stress/stress_test_case.py`) [C-11].
- Los tests propios de las heurísticas: velocidad inválida en HC y ACO, y ubicación inalcanzable en ACO. Explican por qué HC tiene 64 tests y ACO 65 (`R:scripts/baseline_counts.json`) [C-8, C §5].

**Corregido en la verificación (antes Mayor, ahora Menor).** La auditoría AB decía que el anexo "Diagramas" vacío (`T:Apendices/ap1.tex:3-4`, `% TODO: completar`) "figura en la tesina sin contenido". No es así: `T:tesina.tex:174-179` no incluye `ap1.tex`, así que no se compila. Queda como limpieza: borrar el archivo o completarlo con un diagrama de componentes (`Model` y Observer, DTOs, `route_construction` compartido, verificador).

**Puede omitirse:**
- la integración continua (`ci.yml`, `nightly.yml`), `check_repo`, `run_all` y `baseline_counts.json`;
- los supuestos de PL de la cabecera de `opp_mono.zpl`;
- `insertion_route(rng=...)`, que es código muerto;
- `multi_source_distances` y el 2-opt en $O(1)$;
- los `print()` dentro de los solvers;
- el estado `"optimal"` que registran las heurísticas;
- los informes ConTeXt generados;
- `OPP_STAGE1_WORKERS`.

La justificación de cada uno está en `auditoria_AB.md` §3, B.2. Los estudios exactos 01–12 están cubiertos en ap5, pero no se confirmó que estén los 12.

### C. Tests

**C1. La descripción de las pruebas funcionales de HC y ACO no corresponde a `main`. Crítico. Confirmado.** [C-1]
- **Tesina:** `T:Capitulos/cap5.tex:116-128`: se capturan las 70 instancias del Split, HC y ACO resuelven 68 y "solo se exige que el estado [...] coincida con el del Split". También `:549-551`.
- **Evidencia:**
  - `R:tests/infra/cases/heuristic_model_case.py:1-11`: "the cases run unchanged on the heuristics: the scenario and the assertions are the same".
  - `R:tests/opp_hc/functional/test_functional_cases.py` llama a `bind_cases(OPPTestCaseHC, ...)`.
  - `R:tests/infra/factories/functional_instances.py:9-10`: "The heuristics do not read it: they run the functional cases themselves".
  - El cambio entró con el commit `03b501c` (2026-11-17). Con el código actual, HC y ACO corren la 37a, sin la parte de la espera, y no corren la 24b ni la 38.
  - Los CSV de `R:results/opp_{hc,aco}/functional/` (70 filas: 68 instancias y 2 tests de velocidad) son de la versión anterior. Para la versión actual no hay ninguna corrida guardada.
- **Sugerencia:** hay dos opciones:
  - **(a)** describir el adaptador (mismas aserciones, salvo la espera en 06a, 06b y 37a), volver a correr las suites de HC y ACO, regenerar la verificación y las comparaciones y ajustar los conteos;
  - **(b)** aclarar que los resultados de las heurísticas vienen de la versión de las pruebas anterior a `03b501c`.

**C2. La 24b no ejercita el chequeo previo a la Etapa 2. Mayor. Confirmado.** [C-2]
- **Tesina:** `T:Capitulos/cap5.tex:63-65` y `T:Apendices/ap4.tex:44`.
- **Evidencia:** `R:tests/opp_split/functional/test_case_24b.py:15-17` llama a `run_pipeline(..., solve_stage2=False)`. Esa llamada vuelve en `R:tests/opp_split/opp_split_test_case.py:132-133`, antes de `batches_without_eligible_picker` (`:138-157`). El assert usa `eligible_pairs`, un helper del propio test. El chequeo real se ejercita en 34b y 35c.
- **Sugerencia:** describir la 24b como "con los tiempos de ruta de la Etapa 1, ningún par picker–lote cumple el límite de frío" y atribuir la prueba del chequeo previo a 34b y 35c. La otra opción es hacer que el test llame a `run_pipeline` completo.

**C3. El caso 28 acepta `infeasible` para la fecha ajustada. Mayor. Confirmado.** [C-3]
- **Tesina:** `T:Apendices/ap4.tex:57` dice que "ambas tienen solución".
- **Evidencia:** `R:tests/functional_cases/case_28.py:82` hace `assertIn(status_tight, ("optimal", "feasible", "infeasible"))`. En la corrida guardada sí dio `optimal`, pero el test no lo exige.
- **Sugerencia:** sacar `"infeasible"` del assert o escribir "se exige solución solo para la fecha holgada".

**C4. Cap5 dice "rutas esperadas" para casos que no las verifican. Mayor. Confirmado.** [C-4]
- **Tesina:** `T:Capitulos/cap5.tex:70-71` ("rutas esperadas [...] (01 a 05, 09 a 11 y 15 a 20)").
- **Evidencia:** 15, 16 y 18 solo afirman el estado. Arman `output_graph` pero no lo comparan (`R:tests/functional_cases/case_15.py:138-151`, `case_16.py:150-164`, `case_18.py:94-108`). 19c y 20 solo verifican la cobertura. ap4 lo describe bien, así que cap5 contradice a ap4.
- **Sugerencia:** "rutas esperadas (01 a 05, 08 a 11 y 17); cobertura (19c, 20, 25c); factibilidad (15, 16, 18, 19a)".

**C5. Hay afirmaciones sobre el verificador sin evidencia en el repo. Mayor. Confirmado.** [C-5, D-10, G13]
- **Tesina:**
  - `T:Apendices/ap6.tex:76-81`: cuatro errores introducidos, "detectó los cuatro".
  - `T:Apendices/ap6.tex:64-65`: "248 soluciones".
  - `T:Capitulos/cap5.tex:529-531` y `T:Capitulos/cap6.tex:400-401`: las 9 soluciones de estrés del Split, "las 9 resultaron válidas".
- **Evidencia:**
  - `git grep` en `main` no encuentra ningún test que importe `mono_compliance` ni `run_compliance`, ni nada con "inject" o "mutat".
  - `R:results/compliance/` solo tiene archivos de HC y ACO.
  - `verify_split_stress` (`R:verification/compare_split_vs_mono.py:207-222`) solo imprime y no guarda nada.
- **Sugerencia:** guardar esas salidas (o agregar un test de `verification/` con una solución correcta y cuatro mutaciones) y citarlas. Si no, aclarar que fueron controles manuales y no quedaron registrados.

**Menores:** [C-6 a C-12, D12, D20]
- **C-6.** En 09 y 17, el control de "carga equilibrada" no se ejecuta (guarda `len(B) > 1`) y "sin superposición" se cumple trivialmente (`case_09.py:137-138`, `case_17.py:128-129`). Sacarlos de `T:Apendices/ap4.tex:24`, `:32` y de `T:Capitulos/cap5.tex:77`.
- **C-7.** "Cada ruta es la esperada": el test compara la unión de los arcos de todos los lotes (`case_01.py:147-157`). Escribir "el conjunto de arcos usados es el esperado".
- **C-8 = D12.** "38 casos" (`T:Capitulos/resumen.tex:15`, `T:Capitulos/abstract.tex:14`, `T:Capitulos/cap5.tex:56`, `T:Capitulos/cap7.tex:445`): el 12 no tiene pruebas (`case_12.py:12-14`). Las "70 instancias" (`cap5.tex:122`, `:588`) son 70 filas del CSV, porque la 36c no genera instancia. No se informan los conteos de HC (64) ni de ACO (65).
- **C-9.** Descripciones parciales en ap4:
  - 04 verifica más de lo que se dice;
  - en 25f falta la variante con carga 3 < 6;
  - 13 y 14 son el mismo test;
  - el 38 tiene dos implementaciones distintas, aunque `cap5.tex:65` dice que "las demás pruebas son las mismas".
- **C-10.** El verificador hace tres cosas que ap6 no dice: el reloj arranca en `start_time` (`mono_compliance.py:215`), el recorte exige que no haya fallado ningún chequeo previo (`:379`) y el diagnóstico por lote tiene un tope de 40 lotes (`:36`, `:354`).
- **C-12 = D20 (repo).** `R:results/comparability/compare_split_vs_mono.csv` tiene dos problemas:
  - etiqueta la 36c como `both_infeasible`;
  - el join por nombre de método pierde una fila, porque Case02 y Case03 comparten `test_two_orders_two_aisles`.
  
  Conviene usar `Case.método` como clave.

### D. Experimentos y resultados

**D1. "Quedan así 60 pares" frente a "66 pares comparables". Mayor (era Crítico en [D1]). Confirmado.** [D1 = G3]
- **Tesina:** `T:Capitulos/cap5.tex:556-562` dice que se compara "prueba a prueba" y que quedan 60 pares. `T:Capitulos/cap6.tex:23-24` y `T:Capitulos/cap7.tex:54` dicen 66.
- **Verificación:** las dos cifras son correctas en su unidad. Son 64 pruebas del Split menos 4 = 60 **pruebas**, y 70 filas menos 4 = 66 **instancias** (55 con óptimo y 11 infactibles). No es un número falso sino un cambio de unidad sin explicar. Por eso se bajó de Crítico a Mayor.
- **Sugerencia:** en cap5, escribir "Quedan así 60 pruebas, que suman 66 instancias (pares)", y usar "instancias" en el cap. 6.

**D2. La corrida principal de HC en estrés es anterior al código actual. Mayor. Confirmado.** [D2]
- **Evidencia:**
  - Las 19 filas de `R:results/opp_hc/stress/output_opp_hc_stress_tests.csv` apuntan a `solutions/20260928_210210/`.
  - El commit `75d553c` es del 2026-10-19 20:18.
  - Recalculado: en `R:results/opp_hc/budget/output_opp_hc_budget_20261019_201951.csv`, la semilla 1 con 200/60 da otro objetivo en 17 de los 18 escenarios. En ACO, la semilla 1 del estudio reproduce la corrida principal.
- **Consecuencia:**
  - Los números de HC en estrés vienen de la versión anterior: `tab:res_brecha`, `tab:res_estres_tiempos`, `tab:res_sin_referencia`, `tab:res_convergencia` y el 0,21 % del resumen. Con el código actual, la brecha máxima sería de 0,18 %.
  - La robustez entre semillas (`T:Capitulos/cap6.tex:951-956`, `T:Capitulos/cap7.tex:470-475`) se midió con la versión nueva.
- **Sugerencia:** volver a correr el estrés de HC con `main` y regenerar la verificación, o aclarar en cap5 y cap6 que las dos mediciones usan versiones distintas del código.

**D3. El monolítico en estrés 05–19 usó `W_c = 9`. Mayor. Confirmado.** [D3]
- **Evidencia:** `R:results/README.md:20`: "`opp_mono/stress/`: rows 05–19 come from runs with `W_c = 9` [...] OPP-Mono was run with it only up to 04". El CSV del monolítico no tiene la columna `W_c`.
- **Contradice a:** `T:Capitulos/cap5.tex:551-554` ("los datos resultantes son idénticos en los 19 escenarios").
- **Sugerencia:** aclararlo en cap5 o cap6, o volver a correr el monolítico en 05–19 con `W_c = 27`. La conclusión de que no termina probablemente se mantiene.

**D4. El texto contradice al Cuadro `tab:res_40min`. Crítico. Confirmado.** [D4 = G2]
- **Tesina:** `T:Capitulos/cap6.tex:320-322` ("sigue sin probar el óptimo en esos puntos"), contra la fila de `:337` ("6 lotes, 5×5 · 32,0 min · sí").
- **Evidencia:** `R:experiments/exact/studies/11_mono_long_cap/points_20260923_232413.csv` da B6S5 `optimal` en 1.917,5 s. `T:Apendices/ap5.tex:309-311` también lo dice.
- **Sugerencia:** "sigue sin probarlo en dos de los tres puntos (3 lotes en 7×7 y 4 lotes en 6×6) ni en la instancia del escenario 04; con 6 lotes en 5×5 lo prueba a los 32 minutos, unas 8 veces lo que tarda el Split".

**D5. "Al menos 71 veces más". Mayor. Confirmado.** [D5]
- **Evidencia:** `R:experiments/exact/studies/08_mono_frontier/frontier_20260923_201522.csv`. En los puntos que el monolítico no prueba, los cocientes son:
  - B4S6: 569,8 / 8,4 = 68×;
  - B3S7: 570,2 / 9,7 = 59×;
  - B6S5: 570,4 / 217,6 = 2,6×.
  
  El 71 sale de 600 / 8,4, es decir, del tope y no del tiempo medido.
- **Sugerencia:** "al menos 68 veces en 4 lotes en 6×6 y 59 en 3 lotes en 7×7; con 6 lotes en 5×5 el Split también tarda (218 s) y la cota es de 2,6".

**D6. La restricción a 35 instancias ya no tiene motivo. Mayor. Confirmado.** [D6]
- **Evidencia:**
  - `R:tests/infra/execution/runner.py:136-152` guarda una fila por instancia (`__k`) con su propio tiempo.
  - El CSV funcional del Split (`e809cb4`, 2026-11-17 21:21) tiene esas filas, y `tab:res_pares` ya las usa.
  - `R:results/comparability/results_split_vs_heuristics.csv` (`c1f3a09`, 20:59) es anterior.
- **Recálculo sobre las 45 instancias:** medianas de 0,315 s (Split), 0,067 s (HC) y 0,261 s (ACO). HC es más rápido en 45/45 y ACO en 28/45. Sobre las 35, los números coinciden con la tesina.
- **Sugerencia:** regenerar la comparación e informar las 45, o quitar la justificación de `T:Capitulos/cap6.tex:585-587` y `T:Apendices/ap7.tex:103-105`.

**D7. Los ajustes del verificador no se usaron "en pocos casos". Mayor. Confirmado.** [D7]
- **Evidencia:** la nota del subgrafo aparece en:
  - las 19 filas de `R:results/compliance/opp_aco/stress/compliance_output_opp_aco_stress_tests.csv`;
  - 1 fila de HC en estrés;
  - 3 filas funcionales de cada heurística.
  
  El subgrafo del 100×100 tiene 1.365 ubicaciones con ACO y 1.425 con HC, no "unas 1.500". Que HC en estrés use el subgrafo solo en el 01 sugiere que las dos verificaciones se corrieron con versiones distintas del verificador (no verificado).
- **Sugerencia:** "el subgrafo de las rutas se usó en las 19 verificaciones de estrés de ACO, en la del 100×100 de HC (unas 1.400 de las 10.000 ubicaciones) y en 3 funcionales de cada heurística".

**Menores:**
- **D8 = G9.** "ACO tarda entre lo mismo que el Split y 6 veces menos" (`T:Capitulos/cap6.tex:731-732`, `:994-995`, `T:Capitulos/resumen.tex:20-21`, `T:Capitulos/abstract.tex:19-20`, `T:Capitulos/cap7.tex:455-456`). En el escenario 04, ACO es un 15 % más lento (14,1 s contra 12,3 s). Escribir "entre algo más que el Split y 6 veces menos".
- **D9 = G6.** "0,295 / 0,061 / 0,225, de modo que HC es 5,1 veces [...] y ACO, 1,4" (`T:Capitulos/cap6.tex:588-590`). El cociente de las medianas da 4,8 y 1,3. El 5,1 y el 1,4 son medianas de los cocientes por instancia. Redactarlo así.
- **D10.** "En las 11 restantes, de alrededor de un segundo" (`T:Capitulos/cap6.tex:591-592`): 5 de esas 11 tardan entre 0,29 y 0,44 s con ACO.
- **D11 = G7.** "Las 60 iteraciones llevarían unas 5 horas" (`T:Capitulos/cap6.tex:735-736`). La extrapolación lineal a partir de 2 iteraciones en 31,5 min da entre 13 y 16 h. Recalcular o citar la fuente.
- **D13 = G10.** La figura de escala (`T:Capitulos/cap6.tex:176-177`, `:289-290`) dice "1 a 6 lotes", pero grafica 2, 3, 4 y 6. Habla de "una misma instancia" cuando cambian la grilla, los lotes y los pickers. "Cualquier grilla con 4 lotes" no incluye 7×7.
- **D14 = S9.** En `fig:res_lineales_dispersion` (`T:Capitulos/cap6.tex:150`), el caso 28·1 (0,071 s) cae debajo del eje, que empieza en 0,1 s.
- **D15.** El caso 27 da 58,05, no 58,0 (`T:Apendices/ap7.tex:60`).
- **D16.** En el estudio 08, B3S6, el monolítico obtiene un objetivo 9·10⁻⁶ menor que el "óptimo" del Split. Aclarar que "brecha negativa" significa negativa más allá de la tolerancia del resolvedor (`T:Capitulos/cap5.tex:602-603`).
- **D17.** "En el tiempo en que HC entrega una solución a lo sumo a un 0,21 %" (`T:Capitulos/cap6.tex:863-868`) combina el presupuesto de la corrida del 27/09 con la brecha de la del 28/09. Agregar "en la corrida principal".
- **D18.** "A lo sumo 6 segundos" (`T:Capitulos/cap6.tex:886-887`): el exceso máximo es de 6,2 s. Escribir "unos 6".
- **D19 = G12.** "10 instancias funcionales pueden compararse solo en estado" (`T:Capitulos/cap7.tex:330-331`): son 22 (12 infactibles y 10 con espera). Escribir "10 instancias factibles, por la espera voluntaria".
- **G4 (baja de Mayor a Menor).** "Un 5,3 y un 10,5 % peor que la de ACO" (`T:Capitulos/cap6.tex:885-886`) toma como base al monolítico. Con ACO como base, son 5,6 y 11,7 %. Es el mismo problema de base que G1 (§G), pero la diferencia numérica es chica.
- **Afirmaciones sin archivo en `results/` ni en `experiments/`.** "2-opt se eligió 86 veces" (`cap6.tex:474-479`, y no se aclara si es por escenario o en total). "600 s con lotes vacíos y 0,13 s sin ellos" (`cap6.tex:51-52`). "51 s con 6 procesos y 46 en secuencia" (`cap5.tex:345-347`). "Rutas mínimas más espera óptima reproduce el Split" (`cap6.tex:577-579`). Las "59 soluciones del Split" (`cap7.tex:187-188`, `ap3.tex:65-77`). Ver §5.

**Experimentos del repo que no se informan** (opcional salvo donde se indica):
- los *gaps* y las cotas duales de los modelos lineales a igual tiempo (`R:results/equal_time/*.csv`), que refuerzan `cap6.tex:325`;
- los estudios 09 y 10 (25 pares adicionales con el mismo óptimo);
- la salida de `verify_split_stress`, que **debería** guardarse (C5).

La ablación y el estudio de feromona de ACO (27/09) son anteriores al fix de determinismo.

### E. Bibliografía

**E1. Los rangos de α, β y ρ no cubren los valores de la literatura. Crítico. Confirmado.** [E-1]
- **Tesina:** `T:Apendices/ap8.tex:392-394` dice que los rangos ρ ∈ {0,05; 0,15; 0,30} y β ∈ {1; 2,5; 4} "abarcan" los de Alaya y Lesch. `T:Capitulos/cap2.tex:455-457` remite ahí.
- **Evidencia:**
  - Alaya, Solnon y Ghédira, p. 5, Tabla 1: α = 1, β ∈ {4, 8}, ρ ∈ {0,1; 0,01}.
  - Lesch et al., p. 16 (18620): α = 1,0, β = 2,0, ρ = 0,02.
  
  Solo α queda cubierto.
- **Sugerencia:** escribir "se acercan a", aclarar que los ρ de la literatura (0,01–0,02) son más bajos que los probados, o agregar ρ = 0,02 al barrido. Aclarar también que Alaya et al. calibran para la mochila multiobjetivo, así que sus valores sirven solo como orden de magnitud [E-12].

**E2. El camino simple no es una limitación "heredada" del modelo de referencia. Mayor. Confirmado.** [E-2]
- **Tesina:** `T:Capitulos/cap7.tex:162-166` ("una característica que se hereda del modelo de referencia") y `T:Capitulos/cap2.tex:430-432`.
- **Evidencia:** Coruzzolo et al. calculan la matriz de distancias entre todas las ubicaciones (p. 13: "calculate the distance matrix automatically"). En p. 3 dicen que el Steiner TSP "can also be formulated as a classic TSP if the minimum distance between each pair of storage locations is previously calculated". Sobre una matriz completa de caminos mínimos, pasar una vez por cada ubicación no impide volver por un pasillo. En la tesina el grafo es de adyacencias, y ahí la misma restricción sí excluye rutas.
- **Sugerencia:** "En Coruzzolo et al. las distancias forman una matriz completa de caminos mínimos (p. 13), sobre la que esta restricción no limita; aquí el grafo es de adyacencias, y por eso la restricción excluye rutas físicamente posibles".

**E3. "Flujo de tipo Gavish y Graves": el paper no lo dice, y su ecuación (16) impresa no elimina subtours. Mayor. Plausible.** [E-3]
- **Tesina:** `T:Capitulos/cap2.tex:432-434` y `T:Capitulos/cap3.tex:24-26`.
- **Evidencia:** en Coruzzolo et al., p. 7, la ecuación (16) está impresa como $\sum_g f_{gih} = \sum_j f_{ijh} \ge a_{ni} y_{nh}$, que es solo conservación de flujo. Probablemente falta un signo menos. En GG, cada nodo agrega una unidad de flujo (Roberti y Toth, p. 6, ec. 11). El paper no nombra a Gavish y Graves. Llamarlo así es una interpretación razonable de la intención de los autores, pero no lo que está escrito.
- **Sugerencia:** "con restricciones de flujo acotadas por la capacidad del carro (ec. 12 y 16 del original), con la intención de eliminar subtours". Agregar una nota al pie sobre la ecuación (16) tal como está impresa, y matizar la afirmación de que los modelos "se reducen al de referencia" [E-6].

**E4. Se omite que el paper resolvió un problema chico y que afirma encontrar "the minimum solution". Mayor. Confirmado.** [E-4]
- **Tesina:** `T:Capitulos/cap2.tex:464-468`, `T:Capitulos/cap7.tex:34-36`, `:63-66` y `:479-480`.
- **Evidencia:** Coruzzolo et al., p. 12, §5.1: "This study designed a simple problem that could be solved within acceptable time limits". En el resumen (p. 1) y las conclusiones dicen: "could successfully identify the minimum solution". Ese "minimum" es el mejor valor entre sus variantes heurísticas.
- **Sugerencia:** "Los modelos solo se resolvieron sobre un problema pequeño de prueba (§5.1); sobre el caso real, la mejor solución que informan (“minimum solution”) es la mejor entre sus variantes heurísticas, sin un óptimo con que contrastarla". La distinción importa porque es la base del aporte central de la tesina.

**Menores:** [E-5 a E-15]
- **E-5.** El 57 % (`T:Capitulos/cap2.tex:443-444`) es la reducción de recorrido más *setup*, con un solo operario y sin el clasificado posterior, del que depende el ahorro (Coruzzolo et al., pp. 13–15). Agregar la salvedad.
- **E-6.** Para que los modelos se reduzcan al de referencia (`T:Capitulos/cap7.tex:24-27`, `:429-432`; `T:Capitulos/cap3.tex:26-29`) faltan dos condiciones: suficientes posiciones $|K|$ por picker y la correspondencia de pesos ($w_1$, $w_2\gamma$ y $w_2\partial$).
- **E-7.** "Tiempo de preparación" tiene dos sentidos (`T:Capitulos/cap7.tex:96-97` frente a `T:Capitulos/cap1.tex:13`). Escribir "preparación del recorrido (*setup*)".
- **E-8.** En Gutiérrez et al. (`T:Capitulos/cap1.tex:12-16`), "reducir significativamente" exagera: es una estimación de entre 7 y 10 % (Tabla III).
- **E-9.** El dato de 50–75 % (`T:Capitulos/cap1.tex:11-12`) es una cita secundaria de Urzúa et al.
- **E-10.** Hillier y Lieberman no usan "cota primal", "cota dual" ni "gap" (`T:Capitulos/cap2.tex:126-133`). `:133-141` (gap por una cota dual débil, menor M válido) no tiene cita.
- **E-11.** Roberti y Toth (`T:Capitulos/cap2.tex:143-148`) no atribuyen el desempeño de GG a lo ajustado de su relajación: sus cotas de PL son peores que las de CLAUS, SSB y GP (p. 18).
- **E-12 = G.4.** Se escribe "Alaya y Solnon" (`T:Apendices/ap8.tex:392`) y "Alaya et al." (`T:Capitulos/cap2.tex:454`). Son tres autores, así que va "Alaya et al.".
- **E-13.** No se dice que el caso de Coruzzolo usa $w_1 = 1$, es decir, que prioriza la finalización (p. 14).
- **E-14.** Afirmaciones sin cita:
  - exactos frente a heurísticos (`T:Capitulos/cap1.tex:96-104`);
  - el almacén de congelados como "operación real" (`T:Capitulos/cap1.tex:31-32`, `T:Capitulos/cap2.tex:460-462`);
  - MTZ y GG sin las referencias originales (`T:Capitulos/cap2.tex:75-78`);
  - los núcleos de eficiencia "a la mitad de la velocidad" (`T:Capitulos/cap5.tex:40-42`) [G.4].
- **E-15 (código).** `R:models/opp_aco/opp_aco.py:699-700` y `R:models/utils/route_construction.py:287` citan "pp.6-9" para los caminos mínimos precalculados. Corresponde a la p. 3.

**Verificado sin diferencias:** las 18 claves `\cite` existen en `T:Referencias/tesina.bib` y todas se citan. La descripción del modelo de Coruzzolo et al. es correcta: cuatro decisiones, capacidad, depósitos, posiciones, objetivo, EDD + ILS, sin velocidad heterogénea ni cadena de frío, y el desglose 207,97. También son fieles Talbi, Hoos y Stützle, Dorigo y Stützle, Stützle y Hoos (MMAS), Rosenkrantz, Babin, Chen y Matoušek. La tabla completa está en `auditoria_E.md` §2 y §4.

### F. Conceptos

**F1. "Heurística" y "metaheurística" no se definen y se usan de forma inconsistente. Mayor. Confirmado.** [F1]
- `T:Capitulos/cap5.tex:4` introduce "metaheurísticas (en adelante, heurísticas)" sin justificarlo.
- `T:Capitulos/cap2.tex` usa "metaheurística" desde la línea 192, pero nunca define el término ni lo distingue de "heurística".
- Los caps. 5–7 vuelven a mezclar los dos términos (títulos de `T:Capitulos/cap6.tex:377`, `:421`; `T:Capitulos/cap7.tex:127`, `:134`, `:616`).
- **Sugerencia:** definir "metaheurística" en la introducción del cap. 2 y usar un solo término para HC y ACO.

**F2. El resumen nombra mal el objetivo. Mayor. Confirmado.** [F2, G.3 A1]
- `T:Capitulos/resumen.tex:3`: "minimizar el tiempo total de preparación".
- `T:Capitulos/abstract.tex:2-3`: "total completion time".
- El objetivo (`T:Capitulos/cap3.tex:216-221`) es la suma ponderada de los $c_b$ más las penalidades.
- **Sugerencia:** "minimizar la suma de los instantes de finalización de los lotes y las penalidades por adelanto o demora", y "the sum of the batch completion times" en el abstract.

**F3. "Infactible" y "rechazo de datos" se usan para lo mismo. Mayor. Confirmado.** [A9 = F3, R10]
- `T:Capitulos/cap3.tex:602-607` dice que, con un pedido en dos lotes, un lote sobre la capacidad o una velocidad no positiva, "la instancia se informa como infactible".
- `T:Capitulos/cap5.tex:100-114` cuenta los datos inválidos como causa de infactibilidad y, a la vez, dice que la 36c "no es de infactibilidad".
- `T:Apendices/ap4.tex:61` dice "se rechaza como infactible".
- En el código, la 36c espera una excepción (`R:tests/functional_cases/case_36.py:62-71`), la 31a devuelve `infeasible` y las heurísticas devuelven `"infeasible"` en las tres condiciones (`R:models/opp_hc/opp_hc.py:86-113`).
- **Sugerencia:** definir dos estados ("datos inválidos" e "infactible") y aplicarlos de la misma manera en 3.3.3, 5.2 y ap4.

**Menores:** [F4–F20]
- **F4.** "Ruta más corta" se usa por "menor tiempo de ruta" (`T:Capitulos/cap3.tex:437`). `T:Capitulos/cap4.tex:673-675` no vale con $S_i > 0$ en las ubicaciones de paso.
- **F5.** HC es un *stochastic hill climbing* (un vecino al azar por iteración), no una "primera mejora" (`T:Capitulos/cap4.tex:374-380`). El 2-opt interno usa mejor mejora.
- **F6.** La variante de MMAS (`T:Capitulos/cap4.tex:642-671`) tiene tres diferencias con el MMAS de `T:Capitulos/cap2.tex:360-366`: el depósito constante, que depositan la mejor de la iteración y la mejor histórica, y los pares en lugar de los arcos. Solo se explica una. Listarlas.
- **F7.** El 2-opt se define sobre "aristas" (TSP simétrico), pero el grafo es dirigido. La sigla ATSP no se define. Lo de `T:Capitulos/cap4.tex:264` es un camino de tipo Steiner asimétrico.
- **F8.** Términos sin definir o definidos tarde: "escenarios heredados", "ruleta", "corrida principal", la notación "25e·1", "exploración" por "relevamiento" y "chequeo de completitud" (ubicaciones en `auditoria_FGH.md` F8).
- **F9.** Hay varios nombres para los extremos de la ruta: punto de entrega, nodo final y depósito final; depósito, depósito de partida y depósito inicial. Fijar uno en `T:Capitulos/cap3.tex:75`.
- **F10.** "Brecha" es la métrica de 5.6 y también el *gap* de SCIP en ap5. Reservar "brecha" para la métrica.
- **F11.** "Los cuatro modelos" (`T:Capitulos/cap6.tex:974`, `T:Capitulos/cap7.tex:147`): debería decir "métodos".
- **F12.** Varios símbolos se usan con más de un sentido: $C$, $T$, $d$, $a$, $k$, $m$, $u$, $\beta$, $R$ y $n$ (tabla en `auditoria_FGH.md` F12). No se relaciona $ea_n, ta_n$ con $E_j, T_j$ del cap. 2.
- **F14.** La capacidad del carro no tiene símbolo en 3.1.
- **F15.** $y_{bk}$ se define distinto en `T:Capitulos/cap3.tex:195` y en `:533`.
- **F16.** $r_b$ sale de `eq:mono_ruta`, no de `eq:texec` (`T:Capitulos/cap4.tex:100-101`).
- **F17.** El pseudocódigo de ACO no considera el caso $\mathcal{P}^k_b = \emptyset$ (`T:Capitulos/cap4.tex:465`). En `:516`, $r \in \mathcal{R}$ debería ser $\mathcal{R}'$.
- **F19.** $\tau_{max} = 2/\rho$ ignora que los pares se comparten entre lotes (`T:Apendices/ap8.tex:184-189`).
- **F20.** Escribir "Or-opt", no "*or-opt*" (`T:Apendices/ap8.tex:97`).

### G. Estilo, repeticiones y redundancias

**G1. Porcentajes a igual tiempo con la base invertida. Crítico. Confirmado.** [G1]
- **Tesina:** `T:Capitulos/cap7.tex:456-458` ("el Split queda entre un 46 y un 58 % por encima") y `T:Capitulos/cap6.tex:1001-1003` ("entre un 46 y un 58 % peor").
- **Evidencia:** las filas 16–19 de `tab:res_igual_tiempo_aco` (`T:Capitulos/cap6.tex:911-914`) dan −46,17 a −58,46 %, con el Split como base. Con ACO como base, el Split queda por encima en:
  - 363.913,6 / 195.905,7 → +85,8 %;
  - 711.264,6 / 305.801,8 → +132,6 %;
  - 976.169,8 / 439.801,8 → +122,0 %;
  - 1.879.853,9 / 780.811,1 → +140,8 %.
  
  `T:Capitulos/cap6.tex:874-877` ("ACO es mejor por [...] entre un 46 y un 58 %") sí es correcto.
- **Sugerencia:** "el objetivo de ACO es entre un 46 y un 58 % menor que el del Split" o "el Split queda entre un 86 y un 141 % por encima".

**G2. El resumen y el abstract omiten la salvedad de la espera voluntaria. Mayor. Confirmado.** [FGH §1 #9, G.3 A5]
- `T:Capitulos/resumen.tex:12-13` y `T:Capitulos/abstract.tex:12` dicen "equivalentes a los modelos lineales en las características que contemplan". Ninguno de los dos menciona la espera voluntaria, que `T:Capitulos/cap1.tex:159-161` y `T:Capitulos/cap7.tex:441-442` sí aclaran.
- **Sugerencia:** agregar "salvo la espera voluntaria".

**Menores: contradicciones e imprecisiones.** [G5, G8, G11, G13, G14, G15]
- **G5.** "Como mucho a la mitad (2,2 veces)" (`T:Capitulos/cap6.tex:361-365`): 2,2 veces es menos de la mitad.
- **G8.** "Un orden de magnitud" (`T:Apendices/ap8.tex:423`): en realidad, entre 4 y 8 veces.
- **G11.** Aclarar si 3,83·10⁻⁶ es una diferencia absoluta o relativa (`T:Capitulos/cap6.tex:26-27` frente a `T:Capitulos/cap5.tex:563`).
- **G13.** No se explica cómo se llega a 59 ni a 248. La razón de las "6 de estrés" de `T:Apendices/ap3.tex:70-72` no vale para el escenario 02.
- **G14:**
  - "El monolítico es algo más rápido" (`T:Capitulos/cap7.tex:436-437`) vale solo en la mediana.
  - "Centésimas de punto" (`T:Capitulos/cap6.tex:752-753`): en el 11 son 0,21 puntos.
  - "Sin impacto significativo" (`T:Apendices/ap5.tex:42-44`) con nodos que varían 37 veces.
  - "Cada grupo modifica un único aspecto" (`T:Capitulos/cap5.tex:210-214`) no vale para el 10 ni el 11.
  - La semilla figura como "--" o "1" (`T:Capitulos/cap5.tex:386`).
- **G15.** Remisiones incorrectas o saltos lógicos:
  - `T:Capitulos/cap6.tex:736-738`: la sección citada no habla de ese tiempo;
  - `T:Capitulos/cap5.tex:194` remite al texto principal, pero está en ap5;
  - `T:Apendices/ap8.tex:243-244` dice "Capítulo 4", pero las mediciones están en ap8;
  - `T:Capitulos/cap7.tex:587` dice "la anterior".

**Repeticiones** (ubicaciones en `auditoria_FGH.md` G.2):
- **R1.** La reducción al modelo de referencia está en cap3 y dos veces en cap7.
- **R2.** "Sin poder contrastar con el óptimo" está casi literal en `cap2.tex:466-468` y `cap7.tex:63-66`.
- **R3.** La cota dual que no avanza aparece 4 veces.
- **R4.** El 30a está en cap6 y dos veces en cap7.
- **R5.** "Una prueba responde si..." es literal en `cap5.tex:149-153` y `ap5.tex:5-10`.
- **R6.** El alcance (semilla, reloj, suspensión) está en cap5, cap6 y cap7.
- **R7.** HC 17 min y ACO 32 min están en cap6 y cap7.
- **R8.** La espera voluntaria hace exacta la descomposición: 4 veces.
- **R9.** El Split como referencia: 4 veces.
- **R10.** La validación de datos: 4 veces.
- **R11.** "No generan espera": 6 veces, dos de ellas a pocas líneas (`cap4.tex:9-10`, `:110-112`).
- **R12.** El ítem 5 de las Conclusiones repite la Síntesis.
- **R13.** El aporte 2 está casi literal en `cap1.tex` y `cap7.tex`.
- **R14.** Lotes → Etapa 2 y almacén → Etapa 1: 5 veces.
- **R15.** La validez de $M^{seq}$: 3 veces.
- **R16.** Chen et al.: 3 veces.
- **R17.** La variación entre semillas: aceptable, porque una es síntesis y otra detalle.
- **R18.** La hormiga descartada: 3 veces.

**Resumen frente a abstract** (G.3):
- A1: el objetivo (ver F2).
- A2: el abstract mezcla "we" con la pasiva.
- A3: "corrida principal" frente a "main runs".
- A4: el inglés de "between the same time [...] and 6 times less" suena poco natural (ver D8).
- A5: la espera voluntaria (ver G2).
- A6: "optimidad" frente a "optimalidad".
- A7: "la mayoría con un perfil realista" es ambiguo.
- A8: decidir si se usa ortografía británica.
- A9: "tomar como punto de partida / guía" es redundante.
- A10: "0.04\,\%".

En las cifras, el resumen y el abstract coinciden.

**Guía de estilo** (G.4):
- **S1.** HC y ACO usan `greenline` y `redline`; según la guía corresponden `blueline` y `greenline`. Es un pendiente explícito.
- **S2–S3.** Colores reservados que se usan para otros fines.
- **S4.** Los grosores de ejes, curvas y puntos no siguen la guía.
- **S5.** Se usa `\startplacefigure` en lugar de `\placefigure[force]`.
- **S6.** Un eje sin unidad (`cap4.tex:85`).
- **S7.** `split=repeat`.
- **S8.** Listas sin negrita.
- **S11.** La guía nombra OPP_v3, que está desactualizado.

**Otros detalles de estilo:**
- "suite" sin cursiva y "*pickers*" sin `{\em}`;
- "descripto" frente a "descrito";
- "seis procesos" frente a "6 procesos";
- "Caso" frente a "escenario";
- `tesina.tex:67` dice "Autor/es:" y corresponde "Autoras:";
- `\TesinaCosupervisor` y `\TesinaGrupo` están vacíos.

**Referencias cruzadas:**
- No hay `\in[...]` rotos ni etiquetas duplicadas (comprobación estática).
- Las 18 citas existen.
- `tesina.log` es del 15/11 y los `.tex` son del 18/11, así que hay que recompilar para confirmar.

### H. ToDos

**H1. La dedicatoria *placeholder* se compila. Mayor. Confirmado.** [H]
- `T:tesina.tex:140-145` imprime "Para / Dedicada a / Para mi ...". Sobre los Agradecimientos (`T:tesina.tex:113`) queda un `% TODO: cambiar esto!`.
- **Sugerencia:** escribir la dedicatoria o quitar el bloque, y resolver el TODO.

El estado completo de los pendientes está en §4.

---

## 3. Tablas de trazabilidad

### 3.1 Tests (tesina ↔ repo)

Los 64 casos de `tab:pruebas_funcionales` (ap4) existen en `R:tests/functional_cases/case_NN.py` con la etiqueta del docstring ("Case 24a.") y se ligan a cada modelo con `bind_cases`. Hay dos excepciones de forma:

- 24b y 38 llevan la etiqueta en la clase, no en el docstring;
- ap4 dice "01" donde el docstring dice "Case 1a".

No falta en el repo ninguna prueba de la tesina. La tabla caso por caso está en `auditoria_C.md` §2. Esta es la síntesis:

| Casos | Coincide con la tesina | Evidencia (S = CSV del Split, M = CSV del Mono) | Nota |
|---|---|---|---|
| 01–05, 08, 10 | Sí | S ok, M ok | La ruta se compara como unión de arcos (C-7). 04 verifica más de lo que dice ap4 |
| 06a, 06b, 37a | Sí | S ok, M ok | En las heurísticas no se verifica la parte de la espera (`waits_voluntarily = False`) |
| 07, 21, 25a, 25d, 26a, 30b, 31a, 32, 35c, 38 | Sí | S ok, M ok | Infactibles o rechazados antes de resolver |
| 09, 17 | Parcial | S ok, M ok | El balance no se ejecuta y la no superposición es trivial (C-6) |
| 11 | Parcial | S ok, M ok | Unión de arcos con un arco común (C-7) |
| 12 | Sí (sin tests) | — | El caso está vacío (C-8) |
| 13, 14 | Sí | S ok, M ok | Son el mismo test (C-9) |
| 15, 16, 18, 19a | Sí con ap4; **no con cap5** | S ok, M ok | Solo el estado (C4) |
| 19b, 19c, 20, 22a–23b, 24a, 25b–25g, 26b–26d, 27, 29, 31b, 33a–36d, 37b | Sí | S ok, M ok | 25f omite una variante; 27 es débil (solo el estado) |
| **24b** | **No** | S ok (no existe en M) | No ejercita el chequeo previo (C2) |
| **28** | **No** | S ok, M ok | Acepta `infeasible` (C3) |
| 30a | Sí | **S timeout, M timeout** | Como dice la tesina |
| HC y ACO (las 62 compartidas) | **No** con cap5:116-128 | CSV de la versión anterior | C1 |

**Conteos.**

| Cantidad | Tesina | Repo | Estado |
|---|---|---|---|
| Pruebas del Split / Mono | 64 / 63 | 64 / 63 (`baseline_counts.json`, `nightly.yml`) | Coincide |
| Pruebas de HC / ACO | No se informan | 64 / 65 | Falta (C-8) |
| Casos | 38 | 38 numerados, 37 con tests | Precisar |
| Instancias del Split | 70 | 70 filas, 69 instancias (la 36c no genera instancia) | Precisar |

**Tests del repo que la tesina no menciona:**
- `R:tests/opp_hc/functional/test_case_invalid_speed_rejected.py` (2);
- `R:tests/opp_aco/functional/test_case_invalid_speed_rejected.py` (2);
- `R:tests/opp_aco/functional/test_case_unreachable_required_location.py` (1, sin semilla fija y sin fila en el CSV de ACO);
- los 19 de estrés por modelo y qué exigen (C-11);
- los jobs de CI.

No hay tests de `verification/`, `models/utils/` ni `experiments/`.

### 3.2 Experimentos (tesina ↔ scripts ↔ resultados)

| Experimento | Script | Resultados | ¿Coincide? |
|---|---|---|---|
| Suite funcional, 4 métodos | `python -m tests.run_suite <modelo> functional` (tope de 25 min, `R:tests/infra/execution/config.py:7`) | `R:results/opp_*/functional/output_*_functional_tests.csv` | Split y Mono: sí. HC y ACO: datos de la versión anterior de los tests (C1) |
| Suite de estrés, 4 métodos | `tests.run_suite <modelo> stress`; generador `R:tests/shared_scenarios/stress/stress_scenarios_designed.py` | `R:results/opp_*/stress/*.csv` | Parcial: el Mono usó `W_c = 9` en 05–19 (D3) y HC es anterior a `75d553c` (D2) |
| Perfil realista y parámetros de HC y ACO | `stress_scenarios_designed.py`, DTOs, `stress_test_case.py`, `scenario_adapter.py:40` | Columnas de los CSV | Sí |
| Monolítico contra Split (funcional) | `python -m verification.compare_split_vs_mono` | `R:results/comparability/compare_split_vs_mono.csv` | Sí en conteos (66). cap5 dice 60 pruebas (D1). El CSV pierde una fila (D20) |
| Escala (estudio 08) | `experiments.exact.exploration --study 08_mono_frontier` | `R:experiments/exact/studies/08_mono_frontier/frontier_20260923_201522.csv` | Valores sí; redacción no (D5, D13) |
| Tope de 40 min (estudio 11) | `exploration --points 11_mono_long_cap/points.json` | `points_20260923_232413.csv` | Valores sí; el texto contradice al cuadro (D4) |
| Paralelismo de la Etapa 1 (estudio 12) | `exploration --points 12_stage1_parallel/points.json` | `points_20260924_100156.csv` | Sí (2,20× y 1,92×) |
| Validez de las heurísticas | `python -m verification.run_compliance` | `R:results/compliance/opp_{hc,aco}/*` | Sí (150 válidas); redacción no (D7) |
| Verificación del estrés del Split | `compare_split_vs_mono --verify-split-stress` | **No hay archivo** | No verificado (C5) |
| Comparabilidad Split–heurísticas | `python -m experiments.comparison.comparability` | `comparability_split_vs_heuristics.csv`, `results_split_vs_heuristics.csv` | Conteos sí; tiempos con el formato viejo (D6) |
| A igual tiempo, HC y ACO | `run_equal_time_study --budget-from opp_hc` / `opp_aco` | `output_equal_time_opp_hc_20260927_195040.csv`, `..._opp_aco_20261110_134358.csv` | Sí |
| Semillas de HC y ACO | `run_hc_budget_study`, `run_aco_seed_study` | `R:results/opp_hc/budget/..._20261019_201951.csv`, `R:results/opp_aco/seeds/..._20261102_193102.csv` | Números sí; HC usa otra versión del código que la corrida principal (D2) |
| Presupuesto de HC, ablación y feromona de ACO (ap8) | `run_hc_budget_study`, `run_aco_ablation_study`, `run_aco_pheromone_study` | `R:results/opp_hc/budget/`, `R:results/opp_aco/{ablation,pheromone}/` | Configuración sí (AB). Valores no auditados. Ablación y feromona son anteriores a `75d553c` |

### 3.3 Números de tablas y figuras (tesina ↔ recalculado)

Unos 400 valores coinciden con los CSV: `tab:res_tiempos_lineales`, `tab:res_pares` (55 filas), `tab:res_infactibles`, `tab:res_tamano_mip`, `tab:res_40min`, `tab:res_estres_tiempos`, `tab:res_brecha`, `tab:res_fallos_hc`, `tab:res_validez`, `tab:res_espera`, `tab:res_sin_referencia`, `tab:res_igual_tiempo_aco`, `tab:res_sla`, `tab:res_convergencia` (95 celdas), la memoria y las semillas. El detalle está en `auditoria_D.md` §4. Estas son las diferencias:

| Dato | Ubicación | Tesina | Recalculado |
|---|---|---|---|
| Pares Mono–Split | `cap5.tex:562` | 60 | 60 pruebas = 66 instancias (D1) |
| Cota cuando el Mono no prueba el óptimo | `cap6.tex:295` | ≥ 71× | 68× / 59× / 2,6× (D5) |
| Mono con 40 min "sin probar el óptimo" | `cap6.tex:320-322` | Ningún punto | Lo prueba en 6 lotes 5×5 (32 min) (D4) |
| Split frente a ACO, cuadrilla grande | `cap7.tex:457` | +46 a +58 % | +86 a +141 % con ACO como base (G1) |
| Mono frente a ACO, 04 y 12 | `cap6.tex:885` | 5,3 / 10,5 % | 5,6 / 11,7 % con ACO como base (G4) |
| Rango Split/ACO en estrés | `cap6.tex:731` | 1 a 6× | 0,87 a 5,96× (D8) |
| Cocientes funcionales | `cap6.tex:588-590` | 5,1 / 1,4 | Medianas de los cocientes 5,08 / 1,37; cociente de las medianas 4,8 / 1,3 (D9) |
| Tiempos funcionales sobre 45 | `cap6.tex:585-593` | (35) 0,295 / 0,061 / 0,225 | (45) 0,315 / 0,067 / 0,261; HC 45/45, ACO 28/45 (D6) |
| Subgrafo del 100×100 | `cap6.tex:416` | ~1.500 | 1.365 (ACO) / 1.425 (HC) (D7) |
| 60 iteraciones de ACO en el 01 | `cap6.tex:736` | ~5 h | ~13–16 h (extrapolación lineal) (D11) |
| Objetivo del caso 27 | `ap7.tex:60` | 58,0 | 58,05 (D15) |
| Exceso máximo a igual tiempo | `cap6.tex:886` | ≤ 6 s | 6,19 s (D18) |
| Brecha máxima de HC en estrés con el código actual | `resumen.tex`, cap6 | 0,21 % | 0,18 % con la semilla 1 del estudio posterior a `75d553c` (D2) |
| Parámetros de la literatura para ACO | `ap8.tex:392-394` | Cubiertos | ρ y β de Alaya y Lesch fuera de rango (E1) |
| $K$ en los escenarios 01 y 19 | `ap8.tex:136` | λ = 1000 > K | K = 1020 y 1272 (A2) |

---

## 4. Estado de los ToDos

### 4.1 `Notas/pendientes_cap7.md`

| Ítem | Estado | Evidencia |
|---|---|---|
| Limitaciones movidas a 7.2 | Resuelto | `T:Capitulos/cap7.tex:145-335` |
| 7.1.1 escrita y verificada contra Coruzzolo | Resuelto, con salvedades | Faltan E2, E4, E-5 y E-6 |
| Quitar repeticiones del cap. 7 | Parcial | Siguen R1, R4, R6, R7 y R12 |
| §1 Contrastar HC con la literatura | Parcial | `T:Capitulos/cap7.tex:86-91` lo hace, pero 7.1.2 no cita a Talbi ni a Hoos y Stützle |
| §1 Contrastar ACO con la literatura (MMAS) | **Pendiente** | 7.1.2 no lo hace |
| §1 Usar a Lesch et al. | **Pendiente** | Solo se cita en `T:Capitulos/cap2.tex:451` y `T:Apendices/ap8.tex:393` |
| §1 Comparar la descomposición con la literatura | **Pendiente** | — |
| §1 y §6 Ampliar Trabajos relacionados (2.6) | **Pendiente (decidido)** | "Se decidió dejarlo pendiente" |
| §2 Ubicación de los aportes, retomar los tres aportes, beneficios prácticos y metodológicos, recomendación de uso | Resuelto | `T:Capitulos/cap7.tex:338-415` |
| §3 Justificar el trabajo futuro y las limitaciones sin línea futura | Resuelto | `T:Capitulos/cap7.tex:495-621` |
| §3 Ideas de la guía (ítem padre) | Resuelto, pero el padre quedó sin marcar | Los 4 subítems están en `[x]`; marcar el padre |
| §3 A partir de Coruzzolo et al. | Resuelto | `T:Capitulos/cap7.tex:593-611` |
| §4 Conclusión, comparación con Coruzzolo, robustez | Resuelto | `T:Capitulos/cap7.tex:466-488` (la robustez de HC depende de D2) |
| §4 Resumen y abstract ("Revisar el inglés") | Parcial | Quedan F2, G2 y A1–A10 |
| §5 Frases de 7.1.1, negritas de 7.2, "38 casos… 64 pruebas" | Resuelto | `T:Capitulos/cap7.tex:24-26`, `:46`, `:243-312`, `:445` (ver C-8 sobre los 38) |
| §6 Cap. 2: "locación" y "completitud" | Resuelto | Falta definir "chequeo de completitud" (F8) |
| §6 Cap. 3: que 4.1.3 y 5.2 remitan a 3.3.3 | Parcial | `T:Capitulos/cap4.tex:216-220` remite pero repite la lista; `T:Capitulos/cap5.tex:102-104` y `:450-452` no remiten |
| §6 Colores de los gráficos | **Pendiente** | S1 en cap6 y ap7 |
| §6 Dedicatoria | **Pendiente** | H1 |

### 4.2 Marcadores en los `.tex`

| Ubicación | Marcador | ¿Se compila? |
|---|---|---|
| `T:tesina.tex:113` | `% TODO: cambiar esto!` (Agradecimientos) | No |
| `T:tesina.tex:140-145` | Dedicatoria "Para / Dedicada a / Para mi ..." | **Sí** |
| `T:tesina.tex:101-103` | Comentario informal ("Esta también me gustó jaja") | No |
| `T:tesina.tex:67` | "Autor/es:" | **Sí** |
| `T:tesina.tex:26-27`, `:75`, `:82` | `\TesinaCosupervisor{}` y `\TesinaGrupo{}` vacíos | Sí (párrafos vacíos) |
| `T:Apendices/ap1.tex:3-4` | `% TODO: completar`, `% afuera???` | No (ap1 no se incluye) |

No hay `XXX`, `FIXME`, `\todo` ni `??`. Las apariciones de "pendiente" y "completar" en el texto son usos legítimos.

---

## 5. Qué no se pudo verificar y por qué

- **Ejecución.** No se corrió ningún test ni experimento. Por eso no se sabe:
  - si las suites actuales de HC y ACO (con el adaptador de C1) pasan completas;
  - si el desempate del vecino más cercano (A1) cambia algún resultado entre procesos;
  - si el CI pasa (no hay logs en el repo).
- **Afirmaciones sin archivo en `results/` ni en `experiments/`:**
  - las 9 soluciones de estrés del Split válidas;
  - los 4 errores introducidos en el verificador;
  - las 248 soluciones con y sin recorte;
  - "2-opt se eligió 86 veces" (26–48 % de las iteraciones);
  - las "5 horas";
  - "600 s con lotes vacíos y 0,13 s sin ellos";
  - "51 s con 6 procesos y 46 en secuencia";
  - "rutas mínimas + espera óptima reproducen el Split";
  - las 59 soluciones del Split;
  - el escenario 10 "de una corrida anterior, por una suspensión";
  - `W_c = 9` en el 04 del estudio 11 (el CSV no registra `W_c`).
- **Qué tope de estrés (25 o 40 min) se usó en cada modelo.** `.env` no está versionado y `.env.example` solo menciona el de ACO.
- **Versiones de software y hardware** (`T:Capitulos/cap5.tex:30-44`). El repo no registra versiones exactas: `requirements.txt` dice `pyscipopt>=5.6.0`, el README dice "Python 3.12+" y la CI prueba 3.12 y 3.13.
- **Generadores y orquestación.** Los parámetros del perfil realista, $M^{seq}$ y la validación previa de los modelos exactos se confirmaron en las auditorías C y D, que leyeron `tests/`, pero no en A+B.
- **ap5 y los números de ap8** (relevamiento y calibración). No se auditaron valor por valor; solo se verificó su configuración (AB) y las semillas (D).
- **Bibliografía sin PDF en `zpaper`:** Croes (1958), Baker y Scudder (1990) y Kanet y Sridharan (2000), incluida la afirmación de `T:Capitulos/cap7.tex:128-130`. Las páginas de Hoos y Stützle y de MMAS son de versiones preprint. Varios libros se consultaron con `pdftotext` y `grep`, no leyéndolos completos.
- **Ecuación (16) de Coruzzolo et al.** No se puede saber si la versión impresa es una errata o la formulación que usaron los autores (E3).
- **Referencias cruzadas en el PDF.** `tesina.log` es anterior a la última modificación de los `.tex` y no se recompiló. La comprobación de los `\in[...]` fue estática.
- **`entorno.tex`.** No se leyó: no se verificó la cabecera de la guía (§8) ni las siglas.

---

## 6. Cambios de la verificación respecto de las auditorías parciales

| Hallazgo | Antes | Ahora | Motivo |
|---|---|---|---|
| 60 frente a 66 pares [D1 = G3] | Crítico (D) / Mayor (G) | Mayor | Las dos cifras son correctas en su unidad: 60 pruebas = 66 instancias (`T:Capitulos/cap5.tex:556-557`, "prueba a prueba"). El problema es de unidad, no de dato |
| Anexo "Diagramas" vacío [B2] | Mayor | Menor | `ap1.tex` no se incluye en `T:tesina.tex`, así que no aparece en la tesina |
| Mono frente a ACO, 5,3 y 10,5 % [G4] | Mayor | Menor | Es el mismo error de base que G1, con una diferencia numérica chica (0,3 y 1,2 puntos) |
| Infactible frente a rechazo [A9 = F3] | Menor (A) / Mayor (F) | Mayor | La tesina contradice al código en la 36c, que lanza una excepción en lugar de informar infactible |
| 40 minutos [D4 = G2] | Mayor (D) / Crítico (G) | Crítico | El texto contradice al cuadro y a los datos |

No se descartó ningún hallazgo Crítico ni Mayor: todos tuvieron respaldo en la fuente. Dos quedaron como **plausibles** y no como confirmados:

- **A1:** el código depende del orden del `set`, pero no se midió el efecto.
- **E3:** la ecuación (16) impresa es solo de conservación, pero probablemente sea una errata del paper.
