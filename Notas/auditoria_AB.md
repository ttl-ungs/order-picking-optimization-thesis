# Auditoría de la tesina: secciones A (veracidad) y B (cobertura)

**Alcance.** Solo lectura. La tesina se leyó en `Capitulos/cap3.tex`, `cap4.tex` y `cap5.tex`, y en
`Apendices/ap1.tex`, `ap3.tex` y `ap8.tex`. Del código se leyó la rama `main` de
`linear-picking-routing` (commit `1cec940`) con `git show main:<ruta>`: `README.md`, `conventions.md`,
`docs/`, `models/`, `dtos/`, `observer/`, `scripts/`, `verification/`, `experiments/` (los README y
los scripts relevantes) y `.github/`. **No se leyeron `tests/`, `results/` ni los PDF de `zpaper`**,
como pedía la consigna. Tampoco se ejecutó nada.

**Archivos pedidos que no existen en `main`:** `meta.md` y `examples/` (`git ls-tree -r --name-only
main` no los lista).

**Convención.** Las rutas del código son relativas a la raíz del repositorio y los números de línea
corresponden a `main`. Las rutas de la tesina son relativas a `picking-route-optimization-thesis/`.

---

## 1. Resumen

El capítulo 3 coincide con los `.zpl` casi término a término. No encontré ninguna restricción, variable
ni objetivo que difiera, y las dos notas al pie que advierten diferencias de escritura (cap3:317-320 y
cap3:421-423) son correctas. Los capítulos 4 y ap8 también describen bien la mayoría de los mecanismos
de HC y ACO, con sus valores por defecto y constantes.

Los problemas que encontré son estos, de mayor a menor importancia:

1. **Mayor.** La tesina dice que la misma semilla da la misma solución en procesos distintos
   (cap5:423-428). El repositorio dice lo contrario para ACO (hace falta `PYTHONHASHSEED=0`), y la
   construcción del vecino más cercano de HC desempata según el orden de un `set`.
2. **Mayor.** La justificación de λ = 1000 (cap4:178-181, ap8:129-143) no vale para la cota $K$ que
   da la propia tesina en los escenarios de estrés 01 y 19 ($K$ = 1020 y 1272).
3. **Mayor.** El cap. 4 dice que las metaheurísticas usan "la misma función objetivo" y suma $c_b$
   sobre todo $\mathcal{B}$ (cap4:7-9 y 129-133). El código no cuenta los lotes vacíos, que los
   modelos lineales sí cobran. Esto solo se aclara en ap6.
4. **Mayor (cobertura).** El anexo de diagramas está vacío (ap1:3-4, con "TODO: completar"), y la
   tesina no describe ni referencia el repositorio de código.
5. **Menor.** Hay imprecisiones de detalle: el tope de 5 rondas de `improve_route`, la búsqueda
   *best-first* en dos pasadas, la prueba de completitud sobre el grafo no dirigido, el orden
   lexicográfico de los lotes, la inconsistencia "infactible" vs. "datos rechazados" y la redacción
   del filtro de 2-opt.

---

## 2. Hallazgos de la sección A (tesina contra código)

### A1. La reproducibilidad entre procesos no está garantizada como dice la tesina. Severidad: Mayor

- **Tesina:** `Capitulos/cap5.tex:423-428`. "La semilla determina todos los sorteos [...] Para que esto
  valga también entre procesos distintos, los candidatos de cada sorteo se recorren siempre en el
  mismo orden." También `Apendices/ap8.tex:30`, que dice que el vecino más cercano "es determinística".
- **Evidencia:**
  - `models/utils/route_construction.py:688-693`: `stitch_route` ordena los candidatos (`sorted(remaining)`)
    para no depender de `PYTHONHASHSEED`. Esa parte coincide con la tesina.
  - `models/opp_hc/opp_hc.py:545-549`: el vecino más cercano de HC arma
    `reachable = [loc for loc in remaining ...]` a partir de un `set` y toma `min(..., key=dist)`. En
    una grilla hay muchos empates de distancia, y el empate se resuelve según el orden de iteración
    del `set`, que depende del hash de cada proceso.
  - `experiments/heuristics/aco/aco_study_common.py:108-114`: "The iteration order of sets of str
    varies per process unless PYTHONHASHSEED is fixed, so two runs with the same Seed can differ
    slightly (149,217.67 vs 149,219.75 on 7x7)".
  - `experiments/heuristics/README.md:22`: "The ACO studies need `PYTHONHASHSEED=0` for a
    reproducible run."
  - `experiments/heuristics/hc/run_hc_budget_study.py:17-18` dice lo contrario ("Results depend on
    Seed alone"). La documentación del repositorio se contradice.
- **Qué dice vs. qué es correcto:** la tesina afirma una reproducibilidad completa entre procesos.
  El código la asegura en `stitch_route`, pero no en el vecino más cercano de HC. El propio
  repositorio documenta una diferencia real entre corridas de ACO con la misma semilla, aunque ese
  comentario puede haber quedado desactualizado después del `sorted()`. **No lo verifiqué ejecutando.**
- **Sugerencia:** hay dos opciones:
  - Ordenar `remaining` en `_generate_feasible_route` (por ejemplo, desempatar con `(dist, loc)`),
    volver a medir y unificar los comentarios del repositorio.
  - Dejar el código como está y matizar el texto: "con la misma semilla y el mismo `PYTHONHASHSEED`".
    En ese caso, indicar con qué valor de `PYTHONHASHSEED` se corrieron las suites. En ap8:30,
    cambiar "Es determinística" por "No usa sorteos".

### A2. λ = 1000 no supera la cota $K$ de la tesina en todas las instancias. Severidad: Mayor

- **Tesina:** `Capitulos/cap4.tex:178-181` ("Su valor es mayor que lo que puede aumentar $f$ cuando
  un lote tarda una unidad de tiempo más") y `Apendices/ap8.tex:129-143`
  ($K = W^c|\mathcal{B}| + W^{pen}\max(W^e,W^t)|\mathcal{N}|$, "Con λ > K [...]").
- **Evidencia:** `models/opp_hc/opp_hc.py:56` y `models/opp_aco/opp_aco.py:101` fijan
  `_COLD_CHAIN_PENALTY_WEIGHT = 1000.0` para cualquier instancia. El comentario del código lo justifica
  de forma más débil: "Large enough to dominate the objective's marginal cost per unit of time (W_c)".
  Con los tamaños de `experiments/comparison/run_equal_time_study.py:52-72` y los pesos de cap5:241
  y 253 (asumo $W^{pen}=W^e=W^t=1$ también en 01-03), el valor de $K$ es:
  - escenario 01: $9 \cdot 30 + 750 = 1020 > 1000$;
  - escenario 19: $27 \cdot 24 + 624 = 1272 > 1000$;
  - escenario 18: $27 \cdot 18 + 468 = 954$, apenas por debajo de 1000.
- **Qué dice vs. qué es correcto:** $K$ es una cota de peor caso muy holgada, porque supone que todos
  los lotes van detrás del que se demora. La cota ajustada es el aumento sobre el picker del lote:
  $W^c m_p + W^{pen}\max(W^e,W^t)\,n_p$, donde $m_p$ es la cantidad de lotes desde la posición del
  lote hasta el final de la secuencia y $n_p$ la cantidad de sus pedidos. Con esa cota, λ = 1000
  alcanza en todos los escenarios de estrés (en el 19 da $2 \cdot 27 + 52 = 106$). Pero la afirmación
  tal como está escrita, con λ > K, es falsa en 01 y 19, y λ no se elige por instancia.
- **Sugerencia:** reemplazar $K$ por la cota por picker, que sigue siendo válida y es la que
  efectivamente se cumple, o bien decir que λ es fijo y que supera $K$ salvo en 01 y 19, donde supera
  la cota ajustada. Conviene aclarar que es una elección fija, no derivada de cada instancia.

### A3. Las metaheurísticas no cobran los lotes vacíos y los modelos lineales sí. Severidad: Mayor

- **Tesina:** `Capitulos/cap4.tex:7-9` ("con la misma función objetivo y las mismas restricciones") y
  `Capitulos/cap4.tex:129-133` ($f(s) = W^c\sum_{b\in\mathcal{B}} c_b + \dots$). Cap4:35 y 350 hablan
  de "lote con pedidos", pero sin sacar la consecuencia para el objetivo.
- **Evidencia:**
  - `models/opp_hc/opp_hc.py:491-492` y `models/opp_aco/opp_aco.py:584-586` solo asignan y secuencian
    los lotes con pedidos.
  - `models/opp_hc/utils/route_evaluator.py:281-288` y el evaluador de ACO calculan $c_b$ solo sobre
    los lotes que están en alguna secuencia.
  - En cambio, `models/opp_mono/opp_mono.zpl:285-288` y `models/opp_split/opp_split_stage2_scheduling.zpl:124-127`
    asignan todo `B`, y el objetivo suma `c_b` de todos los lotes (`opp_mono.zpl:170-174`).
  - `verification/mono_compliance.py:43-52` lo confirma: "Mono routes, assigns and charges every
    batch of B, even one without orders; the heuristics skip empty batches."
- **Qué dice vs. qué es correcto:** si hay lotes vacíos, el objetivo de las heurísticas es menor que
  el de los modelos lineales para el mismo plan. La tesina lo reconoce, pero recién en
  `Apendices/ap6.tex:55-58` y `Capitulos/cap7.tex:190-198`. El capítulo que define $f(s)$ no lo dice.
  El impacto en los resultados parece acotado: el caso 29 queda fuera de la comparación de objetivos
  por espera voluntaria (según `docs/specs/comparabilidad_split_heuristicas.md`) y el 30a no termina.
  No lo verifiqué contra `results/`.
- **Sugerencia:** agregar una oración en `sec:heur_evaluacion`. Por ejemplo: "Los lotes sin pedidos no
  se asignan ni se secuencian, de modo que, a diferencia de los modelos lineales, $f(s)$ no incluye su
  finalización (Anexo de verificación)". Además, escribir la suma sobre los lotes con pedidos.

### A4. `improve_route` tiene un tope de rondas que la tesina no menciona. Severidad: Menor

- **Tesina:** `Capitulos/cap4.tex:281-282` y `Apendices/ap8.tex:61-66` ("alternando dos búsquedas
  locales hasta que deja de acortarse").
- **Evidencia:** `models/utils/route_construction.py:328` (`for _ in range(5)`). `two_opt_tighten_route`
  tiene además un máximo de `len(route)` barridos (línea 237).
- **Sugerencia:** agregar "con un máximo de cinco rondas", como ya se hace para el pulido (ap8:88), o
  sumarlo a los Cuadros `tab:hc_constantes` y `tab:aco_constantes`.

### A5. No todas las rutas candidatas de HC pasan por la búsqueda local. Severidad: Menor

- **Tesina:** `Capitulos/cap4.tex:281` ("Cada ruta construida se mejora alternando dos búsquedas
  locales"), en la sección de elementos comunes.
- **Evidencia:** `models/opp_hc/opp_hc.py:446-475`. Solo las 20 construcciones aleatorias pasan por
  `improve_route` (líneas 465-467). El vecino más cercano y las dos inserciones compiten sin mejorar.
  Después se pule solo la ganadora (línea 475), y el pulido incluye `improve_route`.
- **Sugerencia:** "Cada ruta construida por sorteo (las aleatorias de HC y las de las hormigas) se
  mejora [...]". También se puede aclarar en ap8:23-46 que el vecino más cercano y la inserción se
  comparan sin mejorar.

### A6. La búsqueda *best-first* puede hacer hasta el doble de expansiones. Severidad: Menor

- **Tesina:** `Apendices/ap8.tex:111-117` y `Apendices/ap8.tex:258` y 330 ("tope de 2.000.000 de
  expansiones").
- **Evidencia:** `models/utils/route_construction.py:119-125`. Si la búsqueda con memoización no
  encuentra ruta, se repite sin memoización con el mismo tope, así que el total puede llegar a
  4.000.000.
- **Sugerencia:** "dos pasadas, con y sin memoización de estados, cada una con un tope de 2.000.000
  de expansiones".

### A7. La prueba de completitud es necesaria pero no exacta en grafos dirigidos. Severidad: Menor

- **Tesina:** `Apendices/ap8.tex:52-57` ("cada ubicación pendiente debe estar en algún camino simple
  entre la ubicación elegida y $v_{end}$ [...] Esto se comprueba de forma exacta con las componentes
  biconexas").
- **Evidencia:** `models/utils/route_construction.py:556-580`, en particular 570-573: "On a directed
  graph it runs on the underlying undirected graph".
- **Qué dice vs. qué es correcto:** la condición se comprueba de forma exacta, pero sobre el grafo no
  dirigido subyacente. En los grafos dirigidos que usan las pruebas, eso la vuelve una relajación de
  la condición dirigida: sigue siendo necesaria, pero es más débil.
- **Sugerencia:** "[...] se comprueba con las componentes biconexas del grafo no dirigido subyacente,
  lo que en un grafo dirigido da una condición necesaria más débil".

### A8. Orden en que HC asigna los lotes al principio. Severidad: Menor

- **Tesina:** `Capitulos/cap4.tex:350-351` ("recorriendo los lotes en el orden de sus identificadores").
- **Evidencia:** `models/opp_hc/opp_hc.py:62` (`self.B = sorted(dto.B)`) y 491. Es un orden
  lexicográfico de cadenas, en el que `B10` va antes que `B2`. Los empates de carga se resuelven por
  el índice del picker (línea 496).
- **Sugerencia:** "en orden lexicográfico de sus identificadores; ante igual carga, el primer
  picker". Importa en los escenarios con más de 9 lotes.

### A9. Las mismas condiciones se informan como "infactible" en un lugar y como "rechazo" en otro. Severidad: Menor

- **Tesina:** `Capitulos/cap3.tex:602-607` dice que, si los datos son inválidos (incluidas las
  velocidades no positivas), "la instancia se informa como infactible". `Capitulos/cap5.tex:113-114`
  dice: "La prueba 36c no es de infactibilidad: rechaza los datos de entrada". `Capitulos/cap5.tex:102-104`,
  en cambio, lista la capacidad y la pertenencia a más de un lote como "pruebas de infactibilidad".
- **Evidencia:** en las heurísticas, las tres condiciones devuelven `"infeasible"`
  (`models/opp_hc/opp_hc.py:86-113` y `models/opp_aco/opp_aco.py:133-166`). En el Split, según
  `experiments/comparison/comparability.py:76-83`, 36c "no llega al solver (rechaza la entrada
  antes)". La orquestación de los modelos exactos está en `tests/`, que no leí.
- **Sugerencia:** unificar el criterio y el vocabulario en cap3 y cap5. Por ejemplo: "datos inválidos
  (se rechazan antes de resolver)" frente a "infactible (no existe solución)", y aplicarlo a 25a, 31a
  y 36c por igual.

### A10. Redacción del filtro de inversiones del 2-opt de HC. Severidad: Menor

- **Tesina:** `Apendices/ap8.tex:166-168` ("[...] o cuyos dos nuevos arcos de unión no existen").
- **Evidencia:** `models/opp_hc/opp_hc.py:692-698`. La inversión se descarta si falta **alguno** de
  los dos arcos de unión.
- **Sugerencia:** "o si alguno de los dos nuevos arcos de unión no existe".

### A11. La verificación previa de capacidad usa tolerancias distintas. Severidad: Menor

- **Tesina:** `Capitulos/cap4.tex:216-219` ("son los mismos que en los modelos lineales").
- **Evidencia:** las heurísticas usan `SolveModelDTO.is_capacity_valid`, que compara
  `total > self._C_v` sin tolerancia (`dtos/opp/solve_model_dto.py:159-165`). `models/utils/input_validation.py:34`
  usa `C_v + tolerance` con $10^{-9}$, y `base_constraints_validator.py:76` tampoco usa tolerancia.
- **Sugerencia:** no requiere cambio de texto si se considera irrelevante. Si se quiere precisión,
  unificar el código.

### A12. Cuando ninguna hormiga es válida, la feromona no se actualiza. Severidad: Menor

- **Tesina:** `Capitulos/cap4.tex:461-472` (pseudocódigo, línea 13: "actualizar τ [...]") y
  cap4:637-640 ("Al terminar cada iteración [...] se actualizan las dos matrices").
- **Evidencia:** `models/opp_aco/opp_aco.py:343-344`. Si ninguna hormiga supera la validación,
  `continue` saltea la recombinación, la búsqueda local y las dos actualizaciones de feromona,
  incluida la evaporación. El pulido de récords sí se ejecuta antes.
- **Sugerencia:** agregar "si al menos una hormiga superó la validación" en la línea 13 del
  pseudocódigo y en el texto.

### Afirmaciones verificadas sin diferencias

| Tesina | Código | Resultado |
| --- | --- | --- |
| Conjuntos, parámetros, $a_{bi}$, $L_b$, $F_b$ (cap3:70-153) | `opp_mono.zpl:32-113` | Coinciden |
| $T^{exec}_{pb} = F_b + r_b/V_p$ (cap3:159-163) | `opp_mono.zpl:293-300`, `opp_split_stage2_scheduling.zpl:73-74`, `models/opp_aco/utils/exec_time.py:58-76` | Coinciden |
| Variables y dominio $u_{pb}\le T^{cold}+\varepsilon$, $\varepsilon=10^{-9}$ (cap3:115 y 202) | `opp_mono.zpl:82` y 139, `cold_chain_validation.py:14` | Coinciden |
| Objetivo (cap3:218-222) | `opp_mono.zpl:170-174` | Coincide |
| Restricciones de ruteo (1)-(9) (cap3:248-275) | `opp_mono.zpl:183-245` | Coinciden |
| Flujo Gavish-Graves (cap3:288-296) | `opp_mono.zpl:249-267` | Coincide |
| Tiempo de ruta y nota al pie (cap3:309-320) | `opp_mono.zpl:275-281` | Coinciden |
| Asignación, $u_{pb}$, piso, $c_b$ (cap3:336-346) | `opp_mono.zpl:285-310` | Coinciden |
| Secuencia, con los factores 3 − … y 2 − … (cap3:366-373) | `opp_mono.zpl:316-327` | Coinciden |
| Adelanto y demora, y nota al pie con $M(2-x_{pb}-B_{nb})$ (cap3:412-423) | `opp_mono.zpl:335-342` | Coinciden |
| Etapa 1: objetivo $\sum r_b$ y mismas restricciones (cap3:486-500) | `opp_split_stage1_routing.zpl:86-182` | Coinciden |
| Etapa 2: $\mathcal{PB}^{elig}$, piso sin M grande, secuencia y adelanto/demora sobre pares elegibles (cap3:509-594) | `opp_split_stage2_scheduling.zpl:73-167` | Coinciden |
| Etapa 1 resuelta lote por lote y en paralelo con más de 4 lotes (cap3:492-495, cap5:338-348) | `models/opp_split/README.md` (implementación en `tests/opp_split/stage1_decomposition.py`, no leída) | Coincide con la documentación |
| Detección de lotes sin picker elegible antes de la Etapa 2 (cap3:609-617) | `models/utils/cold_chain_validation.py:27-61`, `stage2.zpl:79-83` | Coincide |
| Tamaño $(2|\mathcal{E}|+1)|\mathcal{B}|$ (cap3:833) | variables `z`, `q` y `r` de `opp_mono.zpl:128-150` | Coincide |
| Representación $(\pi,a,\sigma)$ (cap4:32-47) | `models/utils/route_solution.py` | Coincide |
| $c_b$ sin espera (cap4:104-108) | `route_evaluator.py:273-290` | Coincide |
| Violación $v(s)$ con ε (cap4:163-167) | `opp_hc/utils/constraints_validator.py:67-90`, `opp_aco/utils/constraints_validator.py:59-83` | Coincide |
| $s^*$ solo con $v=0$ (cap4:196-201) | `opp_hc.py:234-239` y 248-252, `opp_aco.py:346-357` | Coincide |
| Verificación previa: capacidad, pertenencia a un lote, velocidades, $V_p=1$ por defecto, cota $F_b$ (cap4:216-233) | `opp_hc.py:86-132` y 327-328, `opp_aco.py:133-185` | Coincide |
| Alcanzabilidad de ACO con dos búsquedas en anchura (cap4:235-244) | `opp_aco.py:240-261` y 523-540 | Coincide |
| HC: candidatas, asignación golosa por menor carga, caso $\mathcal{P}_b=\emptyset$ (cap4:342-363) | `opp_hc.py:427-504` | Coincide (ver A5 y A8) |
| HC: movimientos, aplicabilidad, aceptación, criterios de parada y tiempo al inicio de la iteración (cap4:382-432 y pseudocódigo 310-333) | `opp_hc.py:200-241` y 607-777 | Coinciden |
| Costo local $g_b$ sin ε (ap8:171-175) | `opp_hc.py:675-678` | Coincide |
| Evaluación incremental (ap8:148-159) | `opp_hc/utils/route_evaluator.py:148-271`, `constraints_validator.py:116-164` | Coincide |
| ACO: pares de feromona compartidos entre lotes (cap4:486-497) | `opp_aco.py:542-560` | Coincide |
| Regla de ruta con $\eta=1/d$ y lectura invertida $\tau_{ri}$ (cap4:514-531) | `opp_aco.py:726-731` | Coincide |
| 10 intentos, alternancia de sentido, respaldo determinístico en caché (cap4:532-535, ap8:221-230) | `opp_aco.py:52`, 590-604 y 875-908 | Coincide |
| Regla del picker con $\eta_p=1/(1+\ell_p)$; todos los pickers si $\mathcal{P}^k_b=\emptyset$ (cap4:542-562) | `opp_aco.py:637-676` | Coincide |
| Secuencia por fecha de entrega más temprana (cap4:564-568) | `opp_aco.py:618-635` | Coincide |
| Orden de las tres mejoras (cap4:578-630) | `opp_aco.py:317-371` | Coincide |
| Búsqueda local de asignación con $10|\mathcal{B}|$ rondas, incluido el propio picker (cap4:612-630) | `opp_aco.py:782-873` | Coincide |
| MMAS: evaporación con piso $\tau_{min}$, depósito +1 con tope, $\tau_{max}=2/\rho$, $\tau_{min}=\tau_{max}/50$, inicio en $\tau_{max}$ (cap4:642-666, ap8:182-189) | `opp_aco.py:91`, 236-238 y 924-954 | Coinciden |
| Feromona de asignación: piso 0,01, $Q/f'$ sobre $\mathcal{B}^{ok}$, $2Q/f(s^*)$ (cap4:677-698) | `opp_aco.py:956-1005`, `constraints_validator.py:85-106` | Coinciden |
| Reparto del tiempo: hormigas hasta el 50 % si ya hay solución factible, partes iguales para el pulido (ap8:194-214) | `opp_aco.py:96`, 279-289 y 326-332 | Coincide |
| Construcciones: vecino más cercano, inserción del más lejano en los dos sentidos, 20 aleatorias con β = 2,5 y 30 retrocesos (ap8:23-66) | `opp_hc.py:424-475`, `route_construction.py:23` y 652-791 | Coinciden (ver A4, A5 y A7) |
| Pulido: 5 rondas, bloque de 8, reubicación de una ubicación (ap8:84-104) | `route_construction.py:457-526` | Coincide |
| Valores por defecto de HC (500 / 30 / 30 s) y de ACO (15 / 60 / 1800 s / 1 / 2,5 / 0,15 / 100) (cap5:395-421) | `dtos/hc/solve_hc_model_dto.py:13-15`, `dtos/aco/solve_aco_model_dto.py:13-21` | Coinciden |
| Constantes de ap8 (tab:hc_constantes y tab:aco_constantes) | `opp_hc.py:56`, 424-425 y 578; `opp_aco.py:52`, 56, 91 y 96; `route_construction.py:23` | Coinciden (salvo A6) |
| Valores de estrés de HC 200 / 60 / 30 s (cap5:400-402) | `run_hc_budget_study.py:2-4` y 13 (cita `tests/opp_hc/stress/stress_test_case.py`) | Coinciden, de forma indirecta |
| Topes de 25 min (funcional) y 40 min (estrés) (cap5:314-315) | `.env.example` | Coinciden |
| Verificación en tres pasos, con niveles 1 y 2 (cap5:454-482) | `verification/mono_compliance.py:143-237`, 287-319 y 400-465 | Coincide |
| Verificación de las soluciones de estrés del Split contra el monolítico (cap5:530-534) | `verification/compare_split_vs_mono.py:17-19` y 207-222 | Coincide (es opcional, con `--verify-split-stress`) |
| Comparación monolítico vs. Split: estado, objetivo con tolerancia $10^{-6}$, rutas, asignación y orden (cap5:562-567) | `compare_split_vs_mono.py:41` y 107-157 | Coincide. La exclusión de 37a está en `experiments/exact/reports/build_functional_comparison.py:226` |
| Experimento a igual tiempo: reparto entre las etapas del Split y el presupuesto excedido por la compilación (cap5:625-638) | `experiments/comparison/run_equal_time_study.py:1-25` y 115-140 | Coincide |
| Escenarios de estrés (lotes, pickers, pedidos, grilla y $T^{cold}=280$ en el 11) (cap5:267-297) | `run_equal_time_study.py:52-72` | Coinciden en tamaños. Los parámetros del perfil realista no los verifiqué |
| Variantes de la ablación de ACO y grilla de α, β y ρ (ap8:351-401) | `run_aco_ablation_study.py:44-56`, `run_aco_pheromone_study.py:51-55` | Coinciden |
| Presupuestos del estudio de HC (200/120, 500/60 y 500/120, 5 semillas, sin el 01) (ap8:268-272) | `run_hc_budget_study.py:48` y 98-99 | Coinciden |
| Semillas de ACO: 5, en 3 procesos (ap8:408-413) | `run_aco_seed_study.py:70-72` | Coincide |
| Hardware i7-1360P (cap5:39-44) | `docs/thesis/opp_split_exploration.tex:48` | Coincide |

---

## 3. Sección B: lo que está en el repositorio y no en la tesina

Antes de marcar algo como faltante busqué el término en todos los `.tex` (`grep` sobre `Capitulos/` y
`Apendices/`). Lo que aparece en capítulos que no leí en detalle (cap6, cap7, ap4-ap7) lo indico como
"cubierto en …".

### B.1 Debería estar

| # | Qué hay en el repositorio | Evidencia | Por qué debería estar |
| --- | --- | --- | --- |
| B1 | El repositorio mismo: URL, commit o versión del código con que se generaron los resultados | `README.md`. `grep` de "repositorio", "github" y "http" en la tesina no da resultados relevantes | Sin una referencia al código y a su versión, nada de lo descrito en cap5 se puede reproducir. Basta una nota en cap5 (`sec:software`) con la URL y el commit o tag. |
| B2 | La arquitectura del software: `Model` abstracto con patrón Observer, DTOs, `route_construction` compartido entre HC y ACO, `solve_registry`, el verificador y el lugar donde está la parte Python de los modelos exactos (`tests/infra/zimpl/`) | `models/README.md`, `conventions.md` §6, `observer/README.md` | `Apendices/ap1.tex:1-6` es un anexo "Diagramas" vacío con `% TODO: completar` y `% afuera???`. O se completa con un diagrama de componentes y el flujo de una corrida, o se elimina el anexo. Hoy figura en la tesina sin contenido. |
| B3 | La dependencia de `PYTHONHASHSEED` para reproducir las corridas | `experiments/heuristics/README.md:22`, `aco_study_common.py:108-114` | Tiene relación directa con la afirmación de cap5:423-428 (ver A1). Si se mantiene esa afirmación, hay que indicar la condición. |
| B4 | La diferencia entre las heurísticas y los modelos lineales con los lotes vacíos | `mono_compliance.py:43-52` | Aparece en ap6 y cap7, pero falta en el cap. 4, que es donde se define $f(s)$ (ver A3). |
| B5 | Dónde y cómo se calcula $M^{seq}$, y que el verificador lo reemplaza cuando no alcanza | `verification/mono_compliance.py:240-256` (importa `_compute_m_seq` de `tests/infra/zimpl/dat_files_builder.py`) | cap3:381-398 da la fórmula, pero no dice que se calcula en Python al escribir los `.dat`. Que el verificador la reemplace probablemente está en ap6, que no leí en detalle. Basta una frase. |

### B.2 Omitible

| # | Qué hay en el repositorio | Evidencia | Por qué se puede omitir |
| --- | --- | --- | --- |
| O1 | Integración continua (`ci.yml` por PR, `nightly.yml`), `scripts/check_repo`, `run_all`, `baseline_counts.json`, `make_stress_smoke` y `stress_smoke.json` | `scripts/README.md`, `.github/workflows/` | Son herramientas de ingeniería del repositorio, no del método. A lo sumo, una frase en cap5 diciendo que la cantidad de pruebas se controla automáticamente. |
| O2 | Supuestos de programación lineal (proporcionalidad, aditividad, divisibilidad, certeza) en la cabecera del monolítico | `opp_mono.zpl:17-24` | Son generales de cualquier MIP. Solo vale la pena incluirlos si el marco teórico (cap2) ya los enumera. |
| O3 | `insertion_route(rng=...)`, la inserción en orden aleatorio | `route_construction.py:735-791`. Ninguna llamada pasa `rng` (`opp_hc.py:452`, `opp_aco.py:893-895`) | Es código muerto, no se usa en ningún resultado. |
| O4 | `multi_source_distances`, el desempate de la búsqueda *best-first* | `route_construction.py:78-101` | Detalle de implementación. ap8:114-115 ya describe el criterio. |
| O5 | El cálculo incremental de 2-opt con arreglos de prefijos en $O(1)$ por candidato, para grafos asimétricos | `route_construction.py:185-270`, `opp_hc.py:644-707` | Es una optimización de eficiencia. ap8:166-168 ya explica qué inversiones son válidas. |
| O6 | `print()` dentro de los solvers, contra lo que pide `conventions.md` §6 | `opp_hc.py` (9 llamadas), `opp_aco.py:390-392` | Es una cuestión de calidad del código, no afecta a la tesina. |
| O7 | Las heurísticas registran su estado como `"optimal"` en `SolveResult` | `opp_hc.py:261-262`, `opp_aco.py:405-406` | Es una etiqueta interna del CSV. Solo importa si alguna tabla de cap6 usa la palabra "óptimo" para una heurística (eso corresponde al bloque D). |
| O8 | Los informes ConTeXt generados (`docs/thesis/*.tex` y sus plantillas en `experiments/exact/reports/`) | `docs/README.md`, `experiments/exact/README.md` | Son la fuente de los anexos de relevamiento y comparación, no contenido nuevo. Que sus números coincidan con la tesina corresponde al bloque D. |
| O9 | Los estudios exactos 01-12 (`experiments/exact/studies/`) y `exploration.py` | `experiments/exact/README.md` | **Cubiertos, en apariencia**, en el Anexo de Relevamiento (ap5 menciona la clausura métrica en la línea 210, que corresponde al estudio 06). No leí ap5 completo, así que no confirmo que estén los 12 estudios. Hay que revisar sobre todo el 07 (efecto de la restricción $\le 1$ por vértice) y el 04 (que el corte del proceso funciona). |
| O10 | Tests propios de las heurísticas (velocidad inválida y ubicación inalcanzable en ACO) | `docs/specs/comparabilidad_split_heuristicas.md` | Corresponden al bloque C. |
| O11 | El estudio de feromonas con `--with-local-search` | `run_aco_pheromone_study.py:25`, 56 y 62 | ap8:388 informa solo la versión sin búsqueda local. No sé si existe una corrida con búsqueda local porque no leí `results/`. Si existe y no se informa, corresponde al bloque D. |
| O12 | La opción `OPP_STAGE1_WORKERS` y la advertencia del `.env.example` de que el paralelismo deja los tiempos sin comparación justa con el monolítico | `.env.example` | La idea ya está en cap5:351-359. El nombre de la variable no hace falta. |

---

## 4. Qué no pude verificar y por qué

| Afirmación de la tesina | Motivo |
| --- | --- |
| Fórmula de $M^{seq}$, el mínimo de 500, el redondeo y $R^{max}$ (cap3:381-398, ap3:30-63) | Se calcula en `tests/infra/zimpl/dat_files_builder.py` (`_compute_m_seq`), que queda fuera del alcance. Lo único que vi es que el modelo la lee de `params.dat`, fila 9 (`opp_mono.zpl:113`). |
| Orden y contenido de la validación previa en los modelos exactos, y que 36c se rechaza en vez de informarse como infactible (cap3:602-622) | La orquestación de los modelos exactos está en `tests/infra/zimpl/` y `tests/opp_split/`. |
| Descomposición y paralelismo de la Etapa 1 (con más de 4 lotes y 6 procesos) | Solo lo confirmé en `models/opp_split/README.md`. El código está en `tests/opp_split/stage1_decomposition.py`. |
| A SCIP no se le fija un límite de tiempo, el corte se hace desde afuera, y las columnas del CSV (cap5:313-319 y 361-368) | Están en el runner de `tests/infra/execution/`. Lo único que pude confirmar es el corte en `experiments/exact/exploration.py:17-24`, para los estudios. |
| Parámetros del perfil realista: semilla 20260922, pesos 4 y 5, velocidades 0,8 y 1,2, fechas de entrega entre el 60 % y el 140 %, $M=10^6$, capacidad de 1,5 veces la carga y $F_b=131$ (cap5:229-246) | Los generadores están en `tests/shared_scenarios/stress/`. Solo verifiqué los tamaños (ver la tabla de la sección 2). |
| Semilla 1 en las suites, y valores por defecto en las pruebas funcionales de las heurísticas (cap5:385-390) | Se fijan en `tests/`. |
| Versiones de software: Python 3.13, ZIMPL 3.6.2, SCIP 9.2.3, PySCIPOpt 5.6.0 y SoPlex 7.1.5 (cap5:30-36) | El repositorio no registra versiones exactas. `requirements.txt` dice `pyscipopt>=5.6.0`, `README.md` dice "Python 3.12+" y la CI prueba 3.12 y 3.13. |
| Que la reproducibilidad entre procesos falle en la práctica (A1) | No ejecuté nada. Me baso en la lectura del código y en los comentarios del repositorio, que se contradicen entre sí. |
| Las diferencias con el modelo de referencia de Coruzzolo et al. (cap3:18-30 y 442-446) | No leí el paper (corresponde al bloque E). |
| Que las rutas más cortas sean también las de menor $r_b$ en las instancias funcionales con $S_i>0$ (ap8:69-73) | Requiere las instancias funcionales (`tests/`) o los resultados (`results/`). |
| Todos los números de ap3:65-77 y ap8 (brechas, tiempos, conteos de ejecuciones) | Corresponden al bloque D (`results/`). |
