# Auditoría A + B: veracidad (tesina ↔ código) y cobertura (código ↔ tesina)

Alcance: solo secciones A y B del prompt de auditoría. Revisor único, sin subagentes. Solo lectura: no se ejecutó ningún test ni experimento, y no se modificó ningún archivo salvo este informe.

**Fuentes leídas**
- Tesina: `Capitulos/cap3.tex`, `cap4.tex`, `cap5.tex`, `Apendices/ap1.tex`, `ap3.tex`, `ap8.tex` (completos).
- Código (rama `main` de `linear-picking-routing`, extraída con `git archive` a un directorio temporal, sin tocar el working tree):
  - Modelos ZIMPL: `opp_model_v5_1_mono.zpl`, `opp_model_v5_2_split_stage1_routing.zpl`, `opp_model_v5_2_split_stage2_scheduling.zpl`, `cold_chain_validation.py`.
  - Heurísticas: `opp_hc_4.py` (completo), `opp_aco_4.py` (completo), validadores, evaluadores y DTOs de HC-4 y ACO-4, `route_construction.py` (funciones clave).
  - `verification/` (`mono_compliance.py` completo; `compare_v5.py`, `run_compliance.py`, DTO de compliance, cabeceras).
  - `scripts/` (README, `baseline_counts.json`), `meta.md` (hasta la línea ~560 completo, el resto por búsqueda), `conventions.md`, `README.md`, `docs/README.md`, `docs/specs/comparabilidad_v5_heuristicas.md`, `examples/README.md`, `observer/observer.py`, cabeceras de `analysis/run_*.py`, `.env.example`, `.github/workflows/`.
- No leído por indicación: `tests/`, `results/`, `zpaper/`.

**Resultado en una línea:** no encontré ningún hallazgo **Crítico** confirmado (ninguna fórmula ni parámetro de cap3/cap4/cap5 contradice el código que pude leer). Las fórmulas de los tres `.zpl` y los algoritmos de HC-4 y ACO-4 coinciden con la tesina. Hay 5 hallazgos **Mayores**, varios Menores, y una cobertura del repositorio claramente incompleta (no hay ninguna referencia al repositorio, a su arquitectura ni a cómo reproducir).

---

## 1. Hallazgos A (veracidad)

Convención: `L<n>` = línea del `.tex`. Los hallazgos que dependen de datos en `results/` o de código en `tests/` quedan marcados como **a confirmar con el bloque D/C**.

### A1 — Mayor — La justificación de λ = 1000 no se cumple con la propia cota K de la tesina

- **Tesina:** `cap4.tex:L177-181` y `ap8.tex:L127-143`. Se dice que λ = 1000 "es mayor que lo que puede aumentar f cuando un lote tarda una unidad de tiempo más" y que "el valor de λ se eligió comparándolo" con la cota `K = W^c·|B| + W^pen·max(W^e,W^t)·|N|`, exigiendo `λ > K`.
- **Código:** `opp_hc_4.py:109` y `opp_aco_4.py:176` fijan `_COLD_CHAIN_PENALTY_WEIGHT = 1000.0`. El comentario del código (`opp_hc_4.py:99-108`, `opp_aco_4.py:166-175`) lo justifica de otra forma: "W_c suele ser de uno a dos dígitos". No hay ninguna comparación con K en el código.
- **Cálculo con los valores de la propia tesina** (`cap5.tex:L229-297`, `L248-253`), con `W^pen = W^e = W^t = 1`:

  | Escenario | `W^c` | `|B|` | `|N|` | K |
  |---|---|---|---|---|
  | 01 | 9 | 30 | 750 | **1020** |
  | 19 | 27 | 24 | 624 | **1272** |
  | 18 | 27 | 18 | 468 | 954 |
  | 03 | 9 | 40 | 320 | 680 |

  Es decir, `λ = 1000 < K` en los escenarios 01 y 19.
- **Qué es correcto:** la cota K es muy holgada porque suma todos los lotes y todas las órdenes, cuando el aumento real de `f` por demorar un lote una unidad solo afecta a los lotes siguientes **del mismo picker** y a sus órdenes. Con esa cota por picker (p. ej. en 19, cada picker tiene 2 lotes de 26 órdenes: `27·2 + 52 = 106`) el argumento sí se sostiene. Pero la tesina presenta como método de elección una condición que el valor elegido no cumple y que el código no usa.
- **Sugerencia:** reemplazar K por la cota por picker (`K_p = W^c·m_p + W^pen·max(W^e,W^t)·n_p`, con `m_p` lotes y `n_p` órdenes del picker más cargado), o decir explícitamente que 1000 es una constante empírica que supera el aumento marginal en todos los escenarios medidos, y mostrar la cota por picker de cada escenario.

### A2 — Mayor — La justificación del reparto 50 % del tiempo en ACO compara presupuestos distintos

- **Tesina:** `ap8.tex:L339-344`. Con `Max_time = 600 s` en 100×100, "dejar que las hormigas usaran todo el tiempo dejaba 11 s de pulido y nada para la búsqueda local, con un objetivo de 1.403.120, contra 917.328 cuando el posprocesamiento se completaba".
- **Código:** `opp_aco_4.py:156-164` dice que 917.328 corresponde a una corrida donde el posprocesamiento corrió completo en **~1878 s**, no con el tope de 600 s. Además `dtos/aco/solve_aco_4_model_dto.py:42-46` registra que, **con la solución adoptada** (mitad del tiempo para las hormigas) y 600 s, el objetivo fue **1.061.148**, no 917.328.
- **Qué es correcto:** la comparación 1.403.120 vs 917.328 mezcla tiempos de ~600 s y ~1878 s. El dato que sostiene la decisión es 1.403.120 (sin reparto) frente a 1.061.148 (con reparto), ambos a 600 s; y aun así el reparto no alcanza el 917.328.
- **Sugerencia:** reescribir con los tres números y sus tiempos reales, y aclarar que el reparto se adoptó porque mejora el resultado a igual tope, no porque iguale a la corrida sin tope.
- **A confirmar con D:** no hay archivo de resultados citado para estas corridas.

### A3 — Mayor (a confirmar con D) — "Las corridas con suspensión se reemplazaron" no vale para la fila 01 de ACO-4

- **Tesina:** `cap5.tex:L379-382`: "las corridas en las que se registró una suspensión se reemplazaron por otras".
- **Código/registro:** `analysis/config.py:L158-163` y `meta.md:L647`: la fila 100×100 de `opp_aco_4` que usa el análisis tuvo una suspensión de la notebook de 4 min; su objetivo (988.252) queda 6,9 % por encima de la corrida descartada del 28-09 (924.536), y el propio `meta.md` dice que "vale como prueba de factibilidad, no como resultado de calidad". También `meta.md:L627`: los tiempos del Split en estrés incluyen tiempo suspendido ("son un techo"), y `meta.md:L735` documenta que en el stress 10 se sustituyó una fila inflada por suspensiones por la de otra corrida.
- **Qué es correcto:** al menos esa fila sigue en el conjunto de resultados. Si cap6 o ap7 la usan como resultado de calidad o de tiempo, la afirmación de cap5 es falsa.
- **Sugerencia:** o bien volver a correr el 01 de ACO-4 sin suspensión, o bien aclarar en cap5 y cap6 que esa fila vale solo como prueba de factibilidad, y no usarla en gaps ni en tiempos.

### A4 — Mayor (a confirmar con D) — "Etapa 1 repartida en seis procesos en la suite de estrés" generaliza una corrida de origen mixto

- **Tesina:** `cap5.tex:L353-361`: "La suite de estrés del modelo Split se ejecutó con la Etapa 1 repartida en seis procesos".
- **Código/registro:** `analysis/config.py:L165-170`: el CSV consolidado de estrés del Split mezcla corridas. Los escenarios 02, 04–07, 09–11 y 15 se volvieron a correr con 6 procesos el 29-09. Los 10 timeouts (01 y 03 de la corrida del 24-09; 08 y 12–19 de la del 26-09) se **mantienen de corridas anteriores**. `meta.md:L402` además dice que 01–03 salen de una corrida del 22-09 "en secuencia". Además, `.env.example:L18-24` deja `OPP_STAGE1_WORKERS=1` (secuencial) por defecto.
- **Qué es correcto:** solo las filas re-corridas el 29-09 usaron 6 procesos; las filas de timeout vienen de corridas con otro código y, probablemente, otra configuración.
- **Sugerencia:** agregar en cap5 o ap7 una tabla de procedencia de cada fila del CSV de estrés (fecha, código, `W_c`, procesos de Etapa 1). Ya hay una fuente de verdad en `analysis/config.py:L120-170`. Esto también cubre el cambio `W_c = 9 → 27` entre 01–03 y 04–19 (`analysis/config.py:L145-160`), que cap5 recoge en parte (`cap5.tex:L248-253`).

### A5 — Mayor (a confirmar con D) — La afirmación de reproducibilidad "entre procesos" vale para el código actual, no necesariamente para las corridas consolidadas

- **Tesina:** `cap5.tex:L425-432`: la misma instancia, parámetros y semilla "producen siempre la misma solución" y esto vale "entre procesos distintos" porque los candidatos se recorren en el mismo orden.
- **Código:** `route_construction.py` (función `stitch_route`, comentario junto a `for r in sorted(remaining)`) fecha el arreglo el 2026-10-14/19 y reporta que antes "la misma `Seed` elegía ubicaciones distintas en procesos distintos (hasta 0,5 % de dispersión en el stress 03, y el stress 11 infactible en 2 de 7 procesos)". `analysis/run_hc_budget_study.py` y `run_aco_seed_study.py` repiten "los resultados dependen solo de `Seed` desde 2026-10-19". La guía de cap4 (`cap4.tex:L735-740`) ya registra que las corridas consolidadas de HC/ACO (28–29/09) son **anteriores** a ese arreglo y deja la decisión de volver a correr o aclarar sin resolver.
- **Qué es correcto:** la propiedad vale para el código de hoy. Los resultados de cap6 de HC/ACO (semilla 1, corridas del 28–29/09) se generaron con código que no la tenía.
- **Sugerencia:** o bien re-correr las suites consolidadas de HC-4 y ACO-4 con el código actual, o bien agregar una frase que diga qué versión generó cada resultado. Esto no cambia las conclusiones (dispersión ≤ 0,5 %) pero sí la afirmación literal.

### A6 — Menor — La condición del equilibrio de τ_max (2/ρ) supone un único lote por par, y los pares se comparten entre lotes

- **Tesina:** `cap4.tex:L495-497` (los pares `(i,j)` se comparten entre lotes) y `ap8.tex:L184-189` ("cada par recibe a lo sumo dos depósitos de una unidad por lote e iteración… valor estacionario `2/ρ`").
- **Código:** `opp_aco_4.py:1146-1155` evapora una sola vez por iteración y deposita por cada `(lote, ruta)`. Un par compartido por k lotes puede recibir hasta `2k` depósitos por iteración y su estacionario sería `2k/ρ`, que se recorta a `τ_max = 2/ρ`.
- **Qué es correcto:** `2/ρ` es la cota de un solo lote. Con pares compartidos, la saturación ocurre antes y el recorte en `τ_max` actúa más seguido. No invalida el diseño (`τ_max` es solo una cota), pero la derivación no es exacta para el caso multi-lote.
- **Sugerencia:** agregar "para un único lote; si varios lotes comparten el par, el valor se recorta en `τ_max`".

### A7 — Menor — Tolerancia ε "la misma" en lineales y heurísticas

- **Tesina:** `cap3.tex:L115`, `cap4.tex:L166-168`, `ap8.tex:L259`: ε = 10⁻⁹, "la misma tolerancia numérica de los modelos lineales".
- **Código:** en Split es un filtro exacto de `PB_elig` (`stage2.zpl:L99`). En el monolítico es solo la cota `u_pb ≤ T_cold + EPS` (`mono.zpl:L88,L146`), y SCIP la respeta con su tolerancia de factibilidad (~1e-6, y más con big-M). `meta.md:L415` lo documenta: "entre 1e-9 y ~1e-6 por encima del límite mono podría aceptar un par que Split rechaza".
- **Sugerencia:** agregar una nota en cap3 (junto a la cadena de frío del monolítico) indicando que, en la práctica, la tolerancia efectiva del monolítico es la de SCIP.

### A8 — Menor — La rama "tiempo de ruta de un lote vacío" y el instante de comienzo

- **Tesina:** `cap4.tex:L102-107`: todos los pickers empiezan en el instante 0; `cap3.tex:L36-60` idem.
- **Código:** los evaluadores de HC-4 y ACO-4 acumulan desde 0 (`models/opp_hc_4/utils/route_evaluator.py:L329`), pero `_build_solution_info` usa `base_time = self.T_0` (`opp_hc_4.py:L1022`, `opp_aco_4.py:L1272`), con `T_0 = dto.start_time`, cuyo valor por defecto es `None` (`dtos/opp/model_dto.py:L12`). Con `start_time ≠ 0`, los tiempos de finalización, el adelanto y la demora **informados** diferirían del objetivo evaluado.
- **Impacto:** nulo si `start_time` es siempre 0 o `None` en los experimentos (no verificado: está en `tests/`).
- **Sugerencia:** no hace falta tocar la tesina; evaluar si conviene unificar en el código.

### A9 — Menor — El estado "optimal" de las heurísticas

- **Código:** `opp_hc_4.py:L339`, `L1010` y `opp_aco_4.py:L534`, `L1259` (líneas de `status`) devuelven `status="optimal"` en `SolveResult` y `solution_info`. La tesina insiste en que las heurísticas no prueban optimalidad (`cap4.tex:L10`, `cap5.tex:L439`). La propia guía de cap4 lo anota como pendiente (`cap4.tex:L746-747`).
- **Sugerencia:** en el texto que describa las columnas de los CSV (cap5, "Qué se registra", `L363-371`), aclarar que `optimal` en las heurísticas significa "encontró solución".

### A10 — Menor — Orden de lotes: `sorted()` de cadenas

- **Tesina:** `cap4.tex:L350-351`: "recorriendo los lotes en el orden de sus identificadores".
- **Código:** `self.B = sorted(dto.B)` (`opp_hc_4.py:L115`, `opp_aco_4.py:L182`): orden lexicográfico de cadenas (`B10 < B2`). Además, en el desempate de la asignación inicial se elige el picker de menor índice en `sorted(P)` (`opp_hc_4.py:L603`). Lo mismo para `b < k` en los modelos lineales (`verification/mono_compliance.py:L307`: "ZIMPL string order").
- **Sugerencia:** decir "en el orden alfabético de los identificadores" y mencionar el desempate por picker; en cap3 aclarar que `b < k` es solo una convención para generar cada par una vez.

### A12 — Menor — Duración del escenario 01 en el estudio de semillas de ACO

- **Tesina:** `ap8.tex:L409-410`: "unos 32 minutos por ejecución".
- **Código:** `analysis/run_aco_seed_study.py` (docstring): "~35 min per run".
- **Sugerencia:** unificar con los datos de `results/` (a confirmar con D).

### A13 — Menor — "Los rangos abarcan los valores de Alaya y Solnon y de Lesch"

- **Tesina:** `ap8.tex:L390-391`.
- **Código:** `analysis/run_aco_pheromone_study.py` (docstring): Alaya y Solnon usan `α=1, β=4–8, ρ=0,01–0,1`; Lesch et al., `α=1, β=2, ρ=0,02`. La grilla es `β ∈ {1; 2,5; 4}` y `ρ ∈ {0,05; 0,15; 0,30}`: no incluye `β > 4` ni `ρ < 0,05`.
- **Sugerencia:** decir "se acercan" o "incluyen el extremo inferior de β y el superior de ρ". (La fidelidad de los valores citados es del bloque E.)

### A14 — Menor — Brecha con módulo del denominador

- **Tesina:** `cap5.tex:L603`: `100·(z_heur − z_Split)/z_Split`.
- **Código/spec:** `docs/specs/comparabilidad_v5_heuristicas.md` (columna `gap_pct`): `100·(heur − v5)/|v5|`. Los objetivos son positivos, así que no cambia nada numéricamente.
- **Sugerencia:** ninguna obligatoria.

### A16 — Menor — `ap1.tex` es un marcador de posición

- **Tesina:** `ap1.tex:L3-4`: `% TODO: completar` y `% afuera???`. El capítulo "Diagramas" está vacío. No hay diagramas ni referencias a él en cap3–cap5 que dependan de su contenido (cap3 menciona su propia figura 3.1, `cap3.tex:L855`, en la guía).
- **Sugerencia:** eliminarlo del índice o completarlo (propuesta: diagramas de clases/arquitectura de la implementación, ver B1). Más detalle en H (otro bloque).

### Tabla de trazabilidad A: afirmaciones técnicas contrastadas con código

| Afirmación (tesina) | Código | Resultado |
|---|---|---|
| Restricciones de ruteo (1)–(12) y GG (`cap3.tex:L245-296`) | `mono.zpl:L203-285`; `stage1.zpl` idénticas | ✓ coinciden (incluye `v_start != v_end` en (3)–(4)) |
| `r_b` = traslado + servicio al salir de cada intermedia (`cap3.tex:L305-320`) | `mono.zpl:L296-302`, `stage1.zpl:L175-181` | ✓ (la nota al pie sobre los arcos excluidos también) |
| `u_pb` ∈ [0, T_cold+ε], cadena de frío como cota (`cap3.tex:L202,L348-357`) | `mono.zpl:L146` | ✓ |
| M grande: asignación, c_b, demora/adelanto (`cap3.tex:L326-343`, `L412-426`) | `mono.zpl:L307-335`, `L362-372` (con `M(2−x−B_nb)` y filtro `B_nb=1`) | ✓ (el pie de `L421-423` describe correctamente la diferencia) |
| Secuencia (`seq1`/`seq2`) con `M_seq` (`cap3.tex:L366-373`) | `mono.zpl:L343-354`; `stage2.zpl:L166-176` | ✓ |
| Etapa 2: `PB_elig`, sin `u_pb`, `c_pb ≥ T_exec·x` (`cap3.tex:L506-563`) | `stage2.zpl:L83-99`, `L154-160` | ✓ |
| Etapa 1: `min Σ r_b`; no usa pickers, pesos ni F_b (`cap3.tex:L482-496`) | `stage1.zpl:L86-87` | ✓ |
| Tabla de diferencias (`cap3.tex:L818-832`): 1+|B| MIP; tamaño 2|E||B| / 2|E|+1 | `.zpl` (z y q por arco y lote; r por lote) | ✓ |
| Validaciones previas (`cap3.tex:L598-603`) | `models/utils/input_validation.py` y `cold_chain_validation.py` existen; el orquestador del Split está en `tests/` | ✓ parcial; **no verificado** el orquestador |
| Fórmula de `M^seq` y mínimo 500 (`cap3.tex:L393-398`) | está en `tests/infra/zimpl/dat_files_builder.py::_compute_m_seq` (importada por `verification/mono_compliance.py:L25`) | **no verificado** (fuera de alcance). `meta.md:L199` dice "M_seq (500, fijo)" pero `meta.md:L413` confirma que depende de min V_p: `meta.md:L199` está desactualizado |
| HC: representación, c_{b_k}, f(s), v(s), λ (`cap4.tex:L28-181`) | `route_evaluator.py:L101-130`, `L318-337`; `constraints_validator.py:L116-160`; `opp_hc_4.py:L109,L259` | ✓ (ver A1 sobre λ) |
| Verificación previa de datos y de `F_b ≤ T_cold+ε` (`cap4.tex:L206-233`) | `opp_hc_4.py:L141-199`; `opp_aco_4.py:L209-276`; `cold_chain_validation.py:L21-79` | ✓ (la cota exacta se calcula con `route_time = 0`) |
| ACO agrega chequeo de alcanzabilidad con dos BFS en O(V+E) (`cap4.tex:L235-244`) | `opp_aco_4.py:L336-365,L665-685` | ✓; HC no lo tiene ✓ |
| Solución inicial HC: NN + inserción del más lejano (directa e invertida) + 20 aleatorias, menor distancia, pulido (`cap4.tex:L342-347`) | `opp_hc_4.py:L514-579` (`_MULTI_START_CONSTRUCTIONS = 20`, `β = 2.5`) | ✓ |
| Asignación inicial golosa por menor carga entre elegibles; si no hay, minimiza `T_exec` (`cap4.tex:L349-363`) | `opp_hc_4.py:L581-611` | ✓ (ver A10) |
| 3 movimientos de HC; elección uniforme entre aplicables (`cap4.tex:L382-408`) | `opp_hc_4.py:L771-795`, `L797-966` | ✓ (2-opt = mejor inversión por costo local, `g_b` sin ε ✓) |
| Criterios de parada y contador de "sin mejora" (`cap4.tex:L419-432`) | `opp_hc_4.py:L274-315` | ✓ |
| ACO: pares de feromona compartidos entre lotes, `τ_max` al inicio (`cap4.tex:L486-497`) | `opp_aco_4.py:L687-708` | ✓ |
| Regla de ruta `τ^α η^β`, η = 1/d, hasta 10 intentos, alternancia de dirección, respaldo cacheado (`cap4.tex:L506-535`; `ap8.tex:L219-230`) | `opp_aco_4.py:L732-754`, `L829-918`, `L1066-1105` | ✓ |
| Regla de picker `η_p = 1/(1+ℓ_p)`, pool `P^k_b`, secuencia por fecha más temprana (`cap4.tex:L542-568`) | `opp_aco_4.py:L786-827`, `L767-784` | ✓ |
| Pulido sobre récords, recombinación, búsqueda local de asignación con 3 vecindarios y `10|B|` rondas (`cap4.tex:L583-630`) | `opp_aco_4.py:L443-466`, `L920-961`, `L963-1064` | ✓ |
| MMAS para ruta: evaporación con piso, depósito 1 en `π^ib` y `π^bs`, `τ_max = 2/ρ`, `τ_min = τ_max/50` (`cap4.tex:L642-666`) | `opp_aco_4.py:L154,L332-333`, `L1121-1155` | ✓ (ver A6) |
| Feromona de asignación: piso 0,01; `Q/f'` por hormiga sobre `B^ok`; `2Q/f(s*)` elitista (`cap4.tex:L677-705`) | `opp_aco_4.py:L1157-1231`; `constraints_validator.py:L146-170` | ✓ |
| Parámetros por defecto HC (500/30/30 s) y ACO (m=15, 60 it., 1800 s, α=1, β=2.5, ρ=0,15, Q=100) (`cap5.tex:L397-423`) | `dtos/hc/solve_hc_model_dto.py:L6-8`; `dtos/aco/solve_aco_model_dto.py:L13-18`; `solve_aco_4_model_dto.py:L30` | ✓ |
| Constantes: 20 aleatorias, β=2,5, 30 retrocesos, bloque 8, 5 rondas, 2.000.000 expansiones, 10 intentos, fracción 0,5, piso 0,01, peso elitista 2 (`ap8.tex:L247-330`) | `route_construction.py:L34,L523-525,L578-603`; `opp_hc_4.py:L518-519,L715`; `opp_aco_4.py:L104,L109,L164,L1178,L1189` | ✓ |
| Control de tiempo HC y ACO (`ap8.tex:L194-216`) | `opp_hc_4.py:L281`; `opp_aco_4.py:L232,L395-399`, `L454-457` | ✓ |
| Ejemplo 490 vs 425 con NN + 2-opt; 14×14 sin ruta (`ap8.tex:L75-79`) | `opp_hc_4.py:L541-546` (docstring) | ✓ (mismos números, procedencia: medición del 2026-09-26) |
| Verificación contra el monolítico: chequeos directos + Nivel 1 + Nivel 2; tolerancia relativa 1e-6; válida solo si pasa los tres (`cap5.tex:L456-484`, `L564-566`) | `verification/mono_compliance.py:L140-468`; `compare_v5.py:L45` | ✓ |
| 64 pruebas del Split y 63 del monolítico (`cap5.tex:L63`) | `scripts/baseline_counts.json`: `opp_v5_2_split: 64`, `opp_v5_1_mono: 63` | ✓ (cuenta); contenido de los tests: bloque C |
| 70 instancias funcionales, 68 que resuelven HC/ACO (`cap5.tex:L122-125`, `L590-591`) | `docs/specs/comparabilidad_v5_heuristicas.md` (67 instancias + 2 sin instancia al 28-09, +1 el 29-09 según `baseline_counts.json`: 131 tests en hc_4/aco_4) | ✓ consistente |
| Escenarios de estrés (tamaños, lotes, pickers, pedidos) (`cap5.tex:L267-297`) | `meta.md:L469-495` (tabla de renumeración) | ✓ (valores coinciden, incluidas 26 órdenes/lote × lotes) |
| Paralelismo de Etapa 1 ×2,2 / ×1,9 con 6 procesos; 51 s vs 46 s en funcional; solo con >4 lotes (`cap5.tex:L338-351`) | `meta.md:L419`, `L663`; `docs/thesis/opp_v5_2_split_exploration.tex:L972` (">4 lotes") | ✓; el umbral ">4 lotes" **no está en el código leído** (vive en `tests/`) |
| Versiones: Python 3.13, ZIMPL 3.6.2, SCIP 9.2.3, PySCIPOpt 5.6.0, SoPlex 7.1.5 (`cap5.tex:L30-37`) | `requirements.txt`: `pyscipopt>=5.6.0`; CI con Python 3.12 y 3.13 | **no verificado** (ZIMPL, SCIP y SoPlex no aparecen en el repo) |
| Hardware: i7-1360P, 4 P + 8 E (`cap5.tex:L39-44`) | `meta.md:L420`, `L565` ("CPU híbrida") | ✓ |
| Timeouts 25 min funcional / 40 min estrés (`cap5.tex:L314-316`) | `.env.example:L8-12` (25 por defecto; 40 min "se usó para estrés ACO") | ✓ coherente; **la configuración de cada corrida no se pudo ver** (código en `tests/infra/execution`) |

---

## 2. Hallazgos B (cobertura: código ↔ tesina)

Criterio: "debería estar" = tiene efecto sobre los resultados, sobre la validez de una afirmación de la tesina, o sobre la reproducibilidad. "Omitible" = detalle de implementación o historial.

### 2.1 Debería estar

**B1. Arquitectura del repositorio y reproducibilidad.** La tesina no menciona el repositorio en ninguna parte (no hay URL ni commit; `grep` de "repositorio/github" en `Capitulos/` y `Apendices/` da vacío). Tampoco aparecen: la estructura `models/`, `dtos/`, `tests/infra`, el patrón Observer (`observer/observer.py`, `models/base/model.py`), cómo correr una suite (`python -m tests.run_suite <modelo> <functional|stress>`, `README.md:L157-158`), las variables de entorno (`.env.example`: `WRITE_RESULTS_CSV`, `WRITE_SOLUTIONS`, `TEST_TIMEOUT_MINUTES`, `STRESS_TEST_TIMEOUT_MINUTES`, `OPP_STAGE1_WORKERS=1`) ni el pipeline de análisis (`analysis/`). Solo `cap6` menciona `WRITE_SOLUTIONS`/`.env`. Un revisor no puede reproducir nada con lo que dice la tesina.
- Propuesta: una sección corta "Implementación y reproducibilidad" (en cap5 o en un anexo; `ap1` "Diagramas" podría ocupar ese lugar) con: el enlace y el commit de `main` con que se generaron los resultados, el árbol de directorios, el flujo `.dat` → ZIMPL → LP → SCIP, la tabla de variables de entorno y el comando de cada estudio.
- Atención: el orquestador del modelo Split (validación, paralelismo de la Etapa 1, elegibilidad, `M_seq`) **vive en `tests/`** (`tests/opp_v5_2_split/stage1_decomposition.py`, `tests/infra/zimpl/`), no en `models/`, y `verification/` importa de `tests.infra` (`verification/mono_compliance.py:L22-27`). Conviene decirlo, porque cap3 describe ese pipeline como parte del modelo (`cap3.tex:L594-618`).

**B3. Procedencia de cada resultado consolidado.** Los CSV que usa el análisis son archivos de nombre fijo que mezclan corridas de fechas y código distintos: Split de estrés (`analysis/config.py:L165-170`), monolítico de estrés (solo 01–04 re-corridos con `W_c = 27`, `L145-160`), HC-4 y ACO-4 (`L155-164`: ACO-4 de estrés junta 3 corridas; la fila 100×100 tiene suspensión). Hay además entradas de `meta.md` que advierten sobre tiempos inflados por suspensión (`L627`, `L735`). La tesina explica metodología general (`cap5.tex:L363-382`) pero no da la procedencia por fila. Ver A3–A5.
- Propuesta: tabla de procedencia en ap7 (modelo, escenario, fecha de corrida, `W_c`, procesos de Etapa 1, si hubo suspensión).

**B4. Evidencia empírica de que v5 se reduce a v4 (31 tests funcionales migrados).** `meta.md:L186-187` documenta que 31 de los tests funcionales de `opp_v5_1_mono` y `opp_v5_2_split` son los de `opp_v4` sin tocar ninguna aserción (`migrated_mono_case`), con `V_p = 1` y `T_cold` grande, lo que respalda empíricamente la afirmación de reducción de `cap3.tex:L27-30`. La tesina no menciona `opp_v4` en el cuerpo (solo en comentarios de las guías), ni los tests migrados (`grep "migrad"` vacío). El propio cap5 deja pendiente este control (`cap5.tex:L646-649`: "reducción a v4").
- Propuesta: una frase en cap5 §pruebas funcionales o en cap3 tras la afirmación de reducción.

**B5. Hallazgo del 4×4 y paridad con el camino simple.** `meta.md:L525-526` ("Hallazgo 2026-09-23"): en una grilla 4×4 un lote que requiere 13 de 14 ubicaciones es infactible con el `<= 1` por paridad (el depósito y el final están en esquinas opuestas, mismo color de tablero), aunque físicamente sea posible. `cap7.tex:L162-170` ya discute que "no existe un camino simple" en almacenes pequeños. Está cubierto en lo esencial; falta el argumento de paridad, que explica por qué ocurre, y la medición (estudio 07: con y sin `<= 1` los tiempos de ruta son idénticos en 7×7 y 13×13). Prioridad baja: verificar si ap5 lo incluye (no leído).

### 2.2 Omitible o ya cubierto

| Elemento del repositorio | Estado en la tesina | Veredicto |
|---|---|---|
| `models/utils/sla.py` (`sla_on_time_pct`), columna `sla_on_time_pct` | Métrica "nivel de servicio" en `cap5.tex:L609` | Cubierto |
| `verification/` (`mono_compliance`, `run_compliance`, `compare_v5`, `solution_store`) | cap5 §Validación + ap6 | Cubierto |
| `analysis/run_hc_budget_study.py`, `run_aco_ablation_study.py`, `run_aco_pheromone_study.py`, `run_aco_seed_study.py`, `run_equal_time_study.py` | ap8 (presupuesto, ablación, sensibilidad, semillas); cap5 ("A igual tiempo") | Cubierto (los números son del bloque D) |
| `analysis/run_stability_study.py` (6 modelos × 3 instancias × 30 semillas, `results/<modelo>/stability`) | No aparece (`grep "estabilidad"` vacío) | Omitible: cubre `hc_2/3/4` y `aco_2/3/4` en instancias chicas compartidas, es previo al estudio de 5 semillas sobre estrés. Si se usan sus resultados en algún lado, citarlo. |
| `analysis/comparability.py` + `docs/specs/comparabilidad_v5_heuristicas.md` | Cuadro `tab:comparabilidad` en cap5 | Cubierto. No aparece la regla "v5 fija `x_pb`" (la spec dice que hoy no hay ningún caso): omitible. |
| `experiments/opp_v5/studies/01..12` y `exploration.py`, `stress_test_design.md` | ap5 (Relevamiento), cap5 §Relevamiento | Cubierto en resumen. Los estudios 04 (kill duro) y 06 (clausura métrica) aparecen solo parcialmente (ap5/cap7 mencionan "clausura" y "pseudocosto"); detalles de implementación omitibles. La clausura métrica se **eliminó del código** (`meta.md:L457-466`), así que citar sus datos como "no reproducibles". |
| `docs/thesis/*.tex` del repo (`models.tex`, `opp_v5_models.tex`, comparaciones, `results_outline.md`) | Son borradores/fuente de la tesina | Omitible |
| `models/opp_v1..v3`, `opp_hc_1`, `opp_hc_2`, `opp_aco_1`, `opp_aco_2` | Legacy; `meta.md:L40` los deja fuera del alcance | Omitible. Un párrafo de "evolución de los modelos" en la introducción podría ayudar al lector que mire el repo. |
| `observer/observer.py`, `models/base/model.py`, `dtos/`, `OutputHandler` | No aparecen | Omitible (detalle de implementación); incluir solo en B1 como diagrama de arquitectura. |
| `examples/`, `scripts/check_repo.py`, `run_all.py`, `make_stress_smoke.py`, `new_family_tests.py`, `.github/workflows/ci.yml` y `nightly.yml` | No aparecen | Omitible. Mencionar en una línea la existencia de CI, y que `opp_v4`/`opp_v5` no corren en CI porque necesitan `zimpl` (`scripts/README.md`). |
| `models/opp_aco_4/utils/exec_time.py`, `route_evaluator.py`, evaluación incremental | ap8 §"Evaluación incremental" | Cubierto |
| `topes internos`: `reverse_pick_segments` ≤ `2·|R|+2` (el de `improve_route`, 5 rondas, ya figura en `ap8.tex`) | No aparece | Omitible |

### 2.3 Inconsistencias del repo que conviene saber (no son de la tesina)

- `README.md` está desactualizado respecto de la estructura real: menciona `utils/output_handler.py`, `models/opp_v1/opp_location_graph.py` y `models/opp_v1/opp_output_builder.py`, que ya no existen en esas rutas (el grafo está en `models/base/opp_location_graph.py`), y el comando de tests solo cubre `opp_v1`. Si la tesina va a enlazar el repositorio (B1), conviene actualizarlo.
- `meta.md:L199` ("`M_seq` (500, fijo)") contradice `meta.md:L413` (el cálculo de `M_seq` divide por la velocidad mínima).
- `docs/README.md` y `scripts/README.md` están al día.

---

## 3. Qué no pude verificar y por qué

1. **Todo lo que vive en `tests/`** (fuera de alcance por indicación): la fórmula de `M^seq` y su mínimo de 500 (`cap3.tex:L393-398`, `ap3.tex:L44`), el orquestador del Split (validación, resolución de la Etapa 1 lote por lote, paralelismo, umbral de >4 lotes, tope de procesos), los timeouts efectivos de cada suite, que HC/ACO se corran "con semilla 1", los valores de estrés de HC (200/60), la generación de escenarios (semilla 20260922, fechas 60 %–140 %, capacidad 1,5×) y el contenido de los 38 casos. La única cifra de tests que contrasté fue la cantidad (`scripts/baseline_counts.json`: 64 y 63).
2. **Todo lo que depende de `results/` o de números de resultados** (ap3 "59 soluciones", ap8 tablas de ablación, presupuesto de HC, semillas, cap5/cap6 tiempos): corresponde al bloque D. Solo marqué las inconsistencias que se ven desde el código y la documentación del repo (A2–A5, A12).
3. **Versiones de ZIMPL (3.6.2), SCIP (9.2.3) y SoPlex (7.1.5)** (`cap5.tex:L30-37`): no figuran en `requirements.txt` ni en el CI. Python 3.13 coincide con la matriz del CI (3.12 y 3.13) pero no se indica como versión de las corridas.
4. **Fidelidad con la bibliografía** (bloque E): las descripciones de Chen et al., Coruzzolo et al., Rosenkrantz et al. y Or (`cap4.tex:L267-269`, `L526-540`, `ap8.tex:L32-34`, `L96-101`) se contrastaron solo contra lo que el código y sus comentarios dicen sobre esas fuentes, no contra los PDF. Por ejemplo, "Chen et al. permiten volver a recorrer pasillos y usan una tabla precalculada" viene de `opp_aco_4.py:L858-866`.
5. **Partes de la tesina no leídas** (por indicación): cap1, cap2, cap6, cap7, resumen, abstract, `ap4`–`ap7`, `tesina.tex`. Por eso no pude confirmar qué cubre ap5 de los estudios 04/06/07 (B5).
6. **Código solo parcialmente leído:** `route_construction.py` (leí `improve_route`, `relocate_picks`, `reverse_pick_segments`, `polish_route`, `stitch_route` y las constantes; no leí `dijkstra`, `best_first_route`, `insertion_route`, `keeps_route_completable`, `simple_path_component` en detalle), `opp_v4.zpl`, `opp_v1..v3`, `opp_hc_1..3`, `opp_aco_1..3` (fuera de alcance de la tesina), `analysis/*.py` (solo cabeceras), `experiments/` (solo listado), `docs/thesis/*.tex` (solo un grep puntual).
7. **`meta.md` leído completo hasta la línea ~560; las líneas 560–903 solo por búsqueda de palabras clave** (hay entradas largas sobre estudios 08–12, comparaciones y reportes que no revisé línea por línea).
8. **No se ejecutó nada:** ni tests, ni experimentos, ni la compilación de la tesina. La numeración de ecuaciones, figuras y cuadros no se contrastó con `tesina.pdf`.
