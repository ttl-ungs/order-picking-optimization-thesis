# Informe de auditoría consolidado de la tesina

**Alcance y método.** Este informe unifica los cinco informes parciales (`auditoria_AB.md`, `auditoria_C.md`, `auditoria_D.md`, `auditoria_E.md` y `auditoria_FGH.md`). Se eliminaron los duplicados y, antes de incluirlos, se verificó cada hallazgo Crítico o Mayor contra la fuente (texto actual de los `.tex` de la rama `redaccion-cap4`, repositorio `linear-picking-routing` en la rama `main` y los PDF de `zpaper`). Los hallazgos que no se sostuvieron se descartaron o se reclasificaron; el detalle está en el Anexo del final.

- **No se ejecutó ningún test ni experimento.** Todo se contrastó con lo que está guardado en el repositorio (código, CSV de `results/`, `meta.md`, documentos) y se recalcularon cifras desde esos CSV.
- Los ítems que ya estaban resueltos en la tesina (por ejemplo, el tope de cinco rondas, los ajustes del verificador en `ap6`, las guías de trabajo borradas el 16/11 o el Anexo A "Diagramas", que ya no se incluye en `tesina.tex`) se quitaron de los informes parciales antes de esta consolidación.
- Las líneas citadas son las de los `.tex` al momento de la auditoría; pueden estar corridas una o dos líneas.
- Convención de severidad del prompt: **Crítico** (falso o contradice el código o los datos), **Mayor** (omisión o explicación errónea importante), **Menor** (estilo, redundancia, precisión).


## 1. Problemas Críticos y Mayores (ordenados por severidad)

Todos verificados contra la fuente. El orden dentro de cada nivel va de mayor a menor efecto sobre las conclusiones de la tesina. Cada ítem remite a su detalle (sección 3), con la evidencia y las sugerencias completas.

### Críticos (falso o contradice el código o los datos)

1. **D-1 — El monolítico «no termina ninguno de los 19 escenarios de estrés» está medido solo en 7.** El 01 quedó sin resultado por memoria de ZIMPL, el 02 se cargó a mano y los 08–19 no se terminaron de ejecutar (no hay CSV real; `meta.md:623`). *Dónde:* `cap6.tex:345,359`, `cap7.tex:38,436`, `cap5.tex:569`, resumen y abstract. *Corrección:* decir «ninguno de los 7 que se ejecutaron (01–07); los 08–19 son más grandes que el 04, que ya no cierra a 40 min», o correr 08–19 (≈8 h).
2. **D-5 — Un párrafo contradice su propio cuadro.** `cap6.tex:314-315` dice que con 40 min el monolítico «sigue sin probar el óptimo en esos puntos», pero el cuadro (`cap6.tex:329-332`) y el estudio 11 muestran que en 6 lotes 5×5 sí lo prueba, a los 32 min (8 veces el Split). *Corrección:* reescribir como «en dos de esos tres puntos (y en el estrés 04); el tercero lo cierra a los 32 min» y quitar «no cambia este resultado».

### Mayores (omisión o explicación errónea importante)

3. **D-2 — Los resultados de HC (estrés y funcional) y de ACO funcional son de una versión anterior del código.** Son anteriores al arreglo de determinismo del 2026-10-19 (`75d553c`); ACO en estrés es posterior (10/11). Con el código final, 17 de 18 escenarios de HC cambian y la brecha máxima baja de 0,214 % a 0,18 %. La tesina afirma reproducibilidad (`cap5.tex:425-432`) y no declara la versión de cada corrida. *Corrección:* re-correr con el código final, o declarar la versión de cada corrida y limitar la afirmación al código actual.
4. **E-02 — «Se reducen al modelo de referencia» se prueba contra `opp_v4`, no contra el paper.** El modelo de referencia contra el que se testea es un modelo propio del repositorio (precedencias y tiempo de servicio), y 31 pruebas migradas de v4 verifican la reducción; la tesina no lo dice y `cap7.tex:425-429` atribuye a las pruebas funcionales más de lo que describe `cap5`. *Dónde:* `cap3.tex:26-30`, `cap5.tex`, `cap7.tex:23-27,425-429`. *Corrección:* aclarar que la reducción se verifica contra la adaptación propia y describir las pruebas migradas.
5. **D-4 — Caso 30a: tiempos de verificación presentados como de resolución.** Los 0,13 s y 600 s son del verificador con decisiones fijadas; la causa es una hipótesis (`meta.md:655`: «probable causa»), no una confirmación. *Dónde:* `cap6.tex:50-53`, `cap7.tex:505-508`. *Corrección:* «es consistente con esto» y «al verificar una solución de 30a…».
6. **F1 — «Óptimo local» como explicación de la brecha de HC, sin evidencia.** `cap4.tex:378-380` dice que un vecino rechazado no prueba un óptimo local; `cap6.tex:459-462` y `cap7.tex:83-88,533-537` lo usan para explicar la brecha de hasta 5,88 %. *Corrección:* presentarlo como hipótesis (estancamiento) o respaldarlo con corridas de más iteraciones.
7. **F6 — «Máquina compartida con otras corridas» contradice la metodología.** `cap6.tex:336-339` vs `cap5.tex:334-337` («de a una y sin procesos pesados en paralelo»); sobre esos tiempos se calculan los factores 27× y 71×. *Corrección:* declarar el carácter exploratorio de esos estudios y presentar los factores como órdenes de magnitud.
8. **E-03 — El «57 %» de Coruzzolo et al. y sus condiciones.** Es el ahorro de recorrido + preparación (no del tiempo total de picking), sale de la heurística y no de los modelos, no incluye la clasificación posterior, y el 81 % es el tiempo de preparación supuesto (180 s por lista). *Dónde:* `cap2.tex:445-446`, `cap7.tex:90-99`.
9. **C1 — «Los casos se diseñaron uno por uno» es inexacto.** 45 de las 64 pruebas del Split son los tests de `opp_v4` reutilizados por un adaptador que fuerza `V_p = 1` y desactiva la cadena de frío. *Dónde:* `cap5.tex:56-58`, `ap4.tex`.
10. **C2 — El caso 24b no prueba el chequeo de producción.** Afirma sobre `eligible_pairs`, una réplica escrita dentro del test. *Dónde:* `ap4.tex:44`, `cap5.tex:64`. *Corrección:* reformular la fila o hacer que el test llame a `batches_without_eligible_picker`.
11. **E-01 — Los rangos de la sensibilidad de ACO no «abarcan» los valores de Alaya y Lesch.** ρ = 0,01 y 0,02 quedan fuera del mínimo probado (0,05) y β = 8 fuera del máximo (4). *Dónde:* `ap8.tex:390-391`. *Corrección:* decir qué valores quedan fuera o ampliar la grilla; citar «Alaya et al.».
12. **B1 — La tesina no menciona el repositorio ni cómo reproducir los resultados.** Falta enlace y commit, estructura, variables de entorno, comandos de cada suite y estudio. *Corrección:* agregar una sección o anexo «Implementación y reproducibilidad».
13. **H-1 — Texto provisorio visible en el PDF.** Dedicatoria «Para / Dedicada a / Para mi ...» (`tesina.tex:140-145`) y Agradecimientos marcados `% TODO: cambiar esto!`.
14. **C5 — La «validación del verificador» (4 errores inyectados) no deja rastro en el repositorio.** *Dónde:* `ap6.tex:78-81`. *Corrección:* agregar un script o test que la reproduzca, o describirla como control manual.
15. **E-04 — El estado del arte no sustenta la novedad.** Solo 4 trabajos de picking; el propio paper cita literatura de pickers heterogéneos y de optimización conjunta que la tesina no revisa. *Dónde:* `cap2.tex:426-473`. Está registrado como pendiente en `Notas/pendientes_cap7.md` §6.
16. **H-2 — La «Comparación con el estado del arte» sigue pendiente.** De los 5 ítems de `Notas/pendientes_cap7.md` §1, 4 no se hicieron y 1 está parcial (ver E-04).

## 2. Problemas Menores (ordenados por severidad)

Los ordené en tres niveles: **alto** (una cifra o afirmación verificable es imprecisa o incorrecta), **medio** (precisión o rigor de una explicación, trazabilidad) y **bajo** (estilo, redundancia, terminología). Dentro de cada nivel, de mayor a menor efecto.

### Nivel alto: cifras y afirmaciones imprecisas

1. **D-3** — El Cap. 6 llama «pequeña» a la variación entre semillas y omite que HC no encontró solución en 2 de 90 ejecuciones (`cap6.tex:938-943`).
2. **D-15** — «35 de las 45» y las medianas de tiempo (0,295 / 0,061 / 0,225 s) no se reproducen con el CSV, que da 33 y 0,300 / 0,061 / 0,224 (`cap6.tex:575-581`).
3. **D-8** — «Con hasta 4 lotes resuelve cualquier grilla en menos de 10 s»: no hay medición del Split con 4 lotes en 7×7; y «1 a 6 lotes» cuando la figura muestra 2, 3, 4 y 6 (`cap6.tex:171,283-284`).
4. **D-7** — «Al menos 71 veces» debería ser «al menos 68» (569,8 s / 8,4 s); el tope de 10 min fue un límite de SCIP de 570 s (`cap6.tex:288-290`).
5. **D-11 / F7** — «Reduce la Etapa 1 como mucho a la mitad (2,2 veces)»: 2,2 veces es menos de la mitad (`cap6.tex:356-360`).
6. **D-12** — «Unas 1.500 de 10.000 ubicaciones» debería ser «unas 1.400» (1.425 en HC, 1.365 en ACO), y el recorte de subgrafo se aplica en las 19 filas de ACO, no «en pocos casos» (`cap6.tex:408-412`).
7. **D-9** — «De modo que HC es 5,1 veces más rápido» mezcla la mediana de los tiempos (4,9) con la mediana de los cocientes (5,1) (`cap6.tex:578-581`).
8. **D-10** — «De alrededor de un segundo» cuando son de 0,3 a 1,1 s (`cap6.tex:580`).
9. **D-13 / F23** — Cifras y redacciones imprecisas: «6 segundos» (es 6,19), «tres escenarios» con solución inicial óptima (son cuatro), la comparación del 09, el 5,3 y 10,5 % (respecto de ACO serían 5,6 y 11,7), «un orden de magnitud menor» en `ap8.tex:423`, «248 soluciones» vs 150 + 9, y las 9 soluciones del Split sin reporte guardado.
9b. **C12** — `ap7.tex` caso 27: objetivo «58,0», el valor es 58,05.
10. **C7 / F22** — «38 casos de prueba»: el caso 12 no tiene pruebas activas, son 37 casos con pruebas (64 pruebas) (`resumen.tex:15`, `abstract.tex`, `cap5.tex:56`, `cap7.tex:442`).
11. **C4 / F21** — «60 pares comparables, es decir, instancias»: son pruebas; 6 pruebas resuelven dos instancias y `ap7` informa el objetivo de la última (`cap6.tex:23-24`).
12. **F20** — «Se verifica lo mismo con los cuatro métodos»: en 10 de 19 escenarios ni el monolítico ni el Split obtienen solución (`cap5.tex:261`).
13. **F24** — «Cada grupo modifica un único aspecto»: los escenarios 10 y 11 cambian más de uno (`cap5.tex:210-216`).
14. **A1 / F11** — λ = 1000 no cumple la cota K de la propia tesina en los escenarios 01 y 19 (K = 1020 y 1272), aunque ahí la cadena de frío no está activa (`cap4.tex:177-181`, `ap8.tex:127-143`).
15. **A2** — El reparto 50 % de ACO compara 1.403.120 (600 s) con 917.328 (corrida de ~1878 s); el dato que sostiene la decisión es 1.061.148 (`ap8.tex:339-344`).
16. **A4** — «Etapa 1 en seis procesos» en toda la suite de estrés: solo las filas re-corridas el 29/09 (`cap5.tex:353-361`).
17. **C14** — El tope de 40 min en estrés sale de `.env`; el valor por defecto del código es 25 (`cap5.tex:314-315`).
18. **E-05** — «No pudieron resolver ninguno de sus modelos»: omite que los autores sí resolvieron problemas pequeños, sin publicar resultados (`cap7.tex:34-42`).
19. **E-10** — Roberti y Toth: GG «llegó al óptimo en todas las instancias» son 10 instancias pequeñas de TSPLIB; MTZ, DL y SD resolvieron 9 (`cap2.tex:101-105`).
20. **E-09** — Gutiérrez et al.: «8 horas» es el ciclo completo del pedido (según el tipo de pedido, de 2 a 8 h), no solo la preparación (`cap1.tex:12-16`).
21. **E-13** — Los criterios de parada de HC («máximo de iteraciones o límite de tiempo») no son de Talbi (`cap2.tex:259-262`).
22. **E-07** — «Cota primal/dual» y «gap» citados a Hillier y Lieberman, que no usa esos términos (`cap2.tex:130-139`).
23. **E-06** — «Flujo de tipo Gavish y Graves» se atribuye al paper, que no lo menciona (`cap2.tex:434-436`).
24. **F13** — «Aun con las rutas óptimas»: son las más cortas encontradas (`cap4.tex:612`).
25. **F14** — El argumento del ciclo suelto («nunca mejora el objetivo») ignora el adelanto; lo que lo hace inocuo es la espera voluntaria (`cap3.tex:298-303`).
26. **F8** — HC llega a 200 iteraciones en el 03 y el 17 en el cuadro, y en el 03 y el 18 en `ap8`; vienen de corridas distintas y no se aclara (`cap6.tex:922-924`).

### Nivel medio: precisión, rigor y trazabilidad

27. **C6** — El test del caso 28 acepta `infeasible` en la fecha ajustada, aunque la tesina dice que ambas tienen solución (`ap4.tex:57`).
28. **C8** — 36c: el rechazo de velocidades ≤ 0 lo hace el helper del test, no el pipeline de producción (`ap4.tex:75`).
29. **C3** — Las letras de los casos (06a, 19b…) no existen en el código; trazabilidad frágil (`ap4.tex:3-5`).
30. **C11** — Descripciones imprecisas en `ap4` (04, 08, 34a, «camino válido», «carga equilibrada»).
31. **C13** — Los casos 13 y 14 son la misma instancia (duplicados efectivos).
32. **C15** — Detalles del verificador (`ap6.tex`): tolerancia mixta, tope de 300 s por solve, diagnóstico lote por lote solo con ≤ 40 lotes, reloj desde `start_time`.
33. **A6** — `τ_max = 2/ρ` supone un único lote por par (`ap8.tex:184-189`).
34. **A7** — La tolerancia ε «la misma» de los lineales: en el monolítico es la de SCIP (~1e-6) (`cap3.tex:115`, `ap8.tex:259`).
35. **A9** — Las heurísticas devuelven `status = "optimal"`; aclararlo al describir las columnas de los CSV (`cap5.tex:363-371`).
36. **A10** — «Orden de sus identificadores» es orden alfabético de cadenas (B10 < B2) (`cap4.tex:350-351`).
37. **A12** — Duración del escenario 01 en el estudio de semillas: 32 min en `ap8` y ~35 min en el código.
38. **A14** — La brecha divide por |v5| en la spec; irrelevante con objetivos positivos.
39. **A8** — Los evaluadores acumulan desde 0 y `_build_solution_info` usa `start_time`; sin efecto si es siempre 0.
40. **F9** — La feromona de ruta es «inspirada en MMAS» (depósito unitario), no MMAS estricto (`cap4.tex:642-675`).
41. **F10** — Con objetivos del orden de 10⁵, el depósito `Q/f'` de la feromona de asignación es casi inerte frente a `τ = 1`; la ablación no lo aísla.
42. **F12** — TSP/ATSP usado antes de definirse y rótulo impreciso (`cap2.tex:103-104`, `cap4.tex:264`).
43. **E-08** — Falta atribuir a Coruzzolo el vecino más cercano, swap/insert y multi-start (`ap8.tex:22-30`, `cap7.tex:71-73`).
44. **E-11** — `tesina.bib`: «Sellitto, Miguel Alfonso» es «Afonso».
45. **E-14** — Remisión incorrecta a `sec:marco_hc` para ILS, que `cap2` no define (`cap7.tex:86-88`).
46. **E-12 / F17** — «Preparación» con tres sentidos; términos sin definir o con dos nombres (heredados, cuadrilla, ola, operario/picker, orden/pedido, nodo final/punto de entrega).
47. **F18** — Notación sobrecargada (`C`, `T`, `𝒩`, `a`, `q`, `u`, `R`, `m`).
48. **F15** — «Brecha» con dos sentidos (heurística–óptimo y gap de SCIP).
49. **F16** — «Heurística» y «metaheurística» como sinónimos.
50. **D-6** — `results/comparability/*.csv` está desactualizado respecto de ACO en estrés (problema del repo, no de la tesina).
51. **D-14** — `compare_v5_split_vs_mono.csv` une por nombre de método y colapsa los casos 02 y 03.
52. **B5** — Falta el argumento de paridad del 4×4 (baja prioridad).
53. **C9 / C16** — No se informan pruebas que pasan/fallan; tests y herramientas del repo no mencionados (ver sección 4.1).
54. **G6** — Referencias cruzadas: `cap6.tex:727` apunta a `sec:heur_limitaciones` en vez de `sec:aco_limitaciones`; el PDF y el log son anteriores a los últimos cambios (hay que recompilar).

### Nivel bajo: estilo, redundancia y terminología

55. **G2** — Repeticiones entre capítulos: caso 30a (`cap6.tex:51` y `cap7.tex:507`), HC 17 min / ACO 32 min, «el monolítico no termina ninguno de los 19» (3 veces), reducción al modelo de referencia (3 veces), lista de validaciones de datos (`cap3`, `cap4`, `cap5`), entre otras (R1–R13).
56. **G1** — Colores de las figuras fuera de la guía de estilo: HC en `greenline` y ACO en `redline`, uso de `darkgray`/`darkblue` en diagramas, grosores de la Fig. 3.2, `\placefigure` vs `\startplacefigure`, negritas, comillas, guía desactualizada (G1a–G1i).
57. **G3** — Resumen vs. abstract: «optimidad» → «optimalidad», «se optimiza mediante su descomposición» ambiguo, falta el segundo aporte (verificación de las 150 soluciones), sin palabras clave, retoques de inglés.
58. **G4** — Español y formato: «ya que se ve que», «un poco» (`cap6.tex:75,928`), «Los cuatro modelos» (`cap6.tex:960`), anglicismo «test» (`cap5.tex:149`), primera persona plural (`resumen.tex`, `ap5.tex`), espaciado del `%`, cita atribuida a «Lao Tse», `picker` sin cursiva.
59. **G5** — Pasajes densos o ambiguos: `cap7.tex:44-88`, `cap6.tex:460-472` y `859-877`, `cap3.tex:381-404`, `cap5.tex:56-66`.

*(Los detalles de cada ítem Menor están en la sección 3; las tablas completas de G1, G2 y G4 están en G.)*

## 3. Detalle de los hallazgos por sección

### A. Veracidad: tesina contra código

Ninguna fórmula ni parámetro de `cap3`, `cap4` ni `cap5` contradice el código leído. Las afirmaciones contrastadas están en la tabla de la sección 4.4.

#### A1 — Menor (reclasificado; el informe parcial decía Mayor) — La justificación de λ = 1000 no se cumple con la propia cota K de la tesina

**Verificación:** Confirmado el cálculo: con los valores de `cap5`, K = 1020 (escenario 01) y 1272 (19), mayores que λ = 1000 (`opp_hc_4.py:109` y `opp_aco_4.py:176`; el comentario del código lo justifica distinto, `opp_hc_4.py:99-108`). Se baja a Menor porque en esos escenarios la cadena de frío no está activa (`T^cold = 10⁹`) y λ no interviene; donde sí está activa (escenario 11) K = 318 < 1000. (Fusiona F11.)

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

#### A2 — Menor (reclasificado; el informe parcial decía Mayor) — La justificación del reparto 50 % del tiempo en ACO compara presupuestos distintos

**Verificación:** Confirmado en el código: `opp_aco_4.py:156-164` indica que 917.328 corresponde a una corrida de ~1878 s, y `dtos/aco/solve_aco_4_model_dto.py:40-47` registra 1.061.148 con el reparto adoptado a 600 s. La frase de `ap8.tex:343` es literalmente cierta ("cuando el posprocesamiento se completaba"), pero omite el tiempo de esa corrida y el dato que sí sostiene la decisión; por eso es Menor.

- **Tesina:** `ap8.tex:L339-344`. Con `Max_time = 600 s` en 100×100, "dejar que las hormigas usaran todo el tiempo dejaba 11 s de pulido y nada para la búsqueda local, con un objetivo de 1.403.120, contra 917.328 cuando el posprocesamiento se completaba".
- **Código:** `opp_aco_4.py:156-164` dice que 917.328 corresponde a una corrida donde el posprocesamiento corrió completo en **~1878 s**, no con el tope de 600 s. Además `dtos/aco/solve_aco_4_model_dto.py:42-46` registra que, **con la solución adoptada** (mitad del tiempo para las hormigas) y 600 s, el objetivo fue **1.061.148**, no 917.328.
- **Qué es correcto:** la comparación 1.403.120 vs 917.328 mezcla tiempos de ~600 s y ~1878 s. El dato que sostiene la decisión es 1.403.120 (sin reparto) frente a 1.061.148 (con reparto), ambos a 600 s; y aun así el reparto no alcanza el 917.328.
- **Sugerencia:** reescribir con los tres números y sus tiempos reales, y aclarar que el reparto se adoptó porque mejora el resultado a igual tope, no porque iguale a la corrida sin tope.
- **A confirmar con D:** no hay archivo de resultados citado para estas corridas.

#### A4 — Menor (reclasificado; el informe parcial decía Mayor) — «Etapa 1 repartida en seis procesos en la suite de estrés» generaliza una corrida de origen mixto

**Verificación:** Confirmado en `analysis/config.py:165-170`: solo 02, 04–07, 09–11 y 15 se volvieron a correr con 6 procesos (29/09); los 10 timeouts vienen de corridas del 24/09 y 26/09. Como todos esos timeouts duran 40 min, el tiempo no se ve afectado; queda solo la imprecisión de la generalización. Relacionado con D-2.

- **Tesina:** `cap5.tex:L353-361`: "La suite de estrés del modelo Split se ejecutó con la Etapa 1 repartida en seis procesos".
- **Código/registro:** `analysis/config.py:L165-170`: el CSV consolidado de estrés del Split mezcla corridas. Los escenarios 02, 04–07, 09–11 y 15 se volvieron a correr con 6 procesos el 29-09. Los 10 timeouts (01 y 03 de la corrida del 24-09; 08 y 12–19 de la del 26-09) se **mantienen de corridas anteriores**. `meta.md:L402` además dice que 01–03 salen de una corrida del 22-09 "en secuencia". Además, `.env.example:L18-24` deja `OPP_STAGE1_WORKERS=1` (secuencial) por defecto.
- **Qué es correcto:** solo las filas re-corridas el 29-09 usaron 6 procesos; las filas de timeout vienen de corridas con otro código y, probablemente, otra configuración.
- **Sugerencia:** agregar en cap5 o ap7 una tabla de procedencia de cada fila del CSV de estrés (fecha, código, `W_c`, procesos de Etapa 1). Ya hay una fuente de verdad en `analysis/config.py:L120-170`. Esto también cubre el cambio `W_c = 9 → 27` entre 01–03 y 04–19 (`analysis/config.py:L145-160`), que cap5 recoge en parte (`cap5.tex:L248-253`).

#### A6 — Menor — La condición del equilibrio de τ_max (2/ρ) supone un único lote por par

- **Tesina:** `cap4.tex:L495-497` (los pares `(i,j)` se comparten entre lotes) y `ap8.tex:L184-189` ("cada par recibe a lo sumo dos depósitos de una unidad por lote e iteración… valor estacionario `2/ρ`").
- **Código:** `opp_aco_4.py:1146-1155` evapora una sola vez por iteración y deposita por cada `(lote, ruta)`. Un par compartido por k lotes puede recibir hasta `2k` depósitos por iteración y su estacionario sería `2k/ρ`, que se recorta a `τ_max = 2/ρ`.
- **Qué es correcto:** `2/ρ` es la cota de un solo lote. Con pares compartidos, la saturación ocurre antes y el recorte en `τ_max` actúa más seguido. No invalida el diseño (`τ_max` es solo una cota), pero la derivación no es exacta para el caso multi-lote.
- **Sugerencia:** agregar "para un único lote; si varios lotes comparten el par, el valor se recorta en `τ_max`".

#### A7 — Menor — Tolerancia ε "la misma" en lineales y heurísticas

- **Tesina:** `cap3.tex:L115`, `cap4.tex:L166-168`, `ap8.tex:L259`: ε = 10⁻⁹, "la misma tolerancia numérica de los modelos lineales".
- **Código:** en Split es un filtro exacto de `PB_elig` (`stage2.zpl:L99`). En el monolítico es solo la cota `u_pb ≤ T_cold + EPS` (`mono.zpl:L88,L146`), y SCIP la respeta con su tolerancia de factibilidad (~1e-6, y más con big-M). `meta.md:L415` lo documenta: "entre 1e-9 y ~1e-6 por encima del límite mono podría aceptar un par que Split rechaza".
- **Sugerencia:** agregar una nota en cap3 (junto a la cadena de frío del monolítico) indicando que, en la práctica, la tolerancia efectiva del monolítico es la de SCIP.

#### A8 — Menor — La rama "tiempo de ruta de un lote vacío" y el instante de comienzo

- **Tesina:** `cap4.tex:L102-107`: todos los pickers empiezan en el instante 0; `cap3.tex:L36-60` idem.
- **Código:** los evaluadores de HC-4 y ACO-4 acumulan desde 0 (`models/opp_hc_4/utils/route_evaluator.py:L329`), pero `_build_solution_info` usa `base_time = self.T_0` (`opp_hc_4.py:L1022`, `opp_aco_4.py:L1272`), con `T_0 = dto.start_time`, cuyo valor por defecto es `None` (`dtos/opp/model_dto.py:L12`). Con `start_time ≠ 0`, los tiempos de finalización, el adelanto y la demora **informados** diferirían del objetivo evaluado.
- **Impacto:** nulo si `start_time` es siempre 0 o `None` en los experimentos (no verificado: está en `tests/`).
- **Sugerencia:** no hace falta tocar la tesina; evaluar si conviene unificar en el código.

#### A9 — Menor — El estado "optimal" de las heurísticas

- **Código:** `opp_hc_4.py:L339`, `L1010` y `opp_aco_4.py:L534`, `L1259` (líneas de `status`) devuelven `status="optimal"` en `SolveResult` y `solution_info`. La tesina insiste en que las heurísticas no prueban optimalidad (`cap4.tex:L10`, `cap5.tex:L439`). La propia guía de cap4 lo anota como pendiente (`cap4.tex:L746-747`).
- **Sugerencia:** en el texto que describa las columnas de los CSV (cap5, "Qué se registra", `L363-371`), aclarar que `optimal` en las heurísticas significa "encontró solución".

#### A10 — Menor — Orden de lotes: `sorted()` de cadenas

- **Tesina:** `cap4.tex:L350-351`: "recorriendo los lotes en el orden de sus identificadores".
- **Código:** `self.B = sorted(dto.B)` (`opp_hc_4.py:L115`, `opp_aco_4.py:L182`): orden lexicográfico de cadenas (`B10 < B2`). Además, en el desempate de la asignación inicial se elige el picker de menor índice en `sorted(P)` (`opp_hc_4.py:L603`). Lo mismo para `b < k` en los modelos lineales (`verification/mono_compliance.py:L307`: "ZIMPL string order").
- **Sugerencia:** decir "en el orden alfabético de los identificadores" y mencionar el desempate por picker; en cap3 aclarar que `b < k` es solo una convención para generar cada par una vez.

#### A12 — Menor — Duración del escenario 01 en el estudio de semillas de ACO

- **Tesina:** `ap8.tex:L409-410`: "unos 32 minutos por ejecución".
- **Código:** `analysis/run_aco_seed_study.py` (docstring): "~35 min per run".
- **Sugerencia:** unificar con los datos de `results/` (a confirmar con D).

#### A14 — Menor — Brecha con módulo del denominador

- **Tesina:** `cap5.tex:L603`: `100·(z_heur − z_Split)/z_Split`.
- **Código/spec:** `docs/specs/comparabilidad_v5_heuristicas.md` (columna `gap_pct`): `100·(heur − v5)/|v5|`. Los objetivos son positivos, así que no cambia nada numéricamente.
- **Sugerencia:** ninguna obligatoria.

*(Los hallazgos A3 y A5 de los informes parciales se descartaron o se fusionaron; ver D-2 y el Anexo.)*

### B. Cobertura: código contra tesina

#### B1 — Mayor — Arquitectura del repositorio y reproducibilidad

**Verificación:** confirmado: `grep` de "github", "repositorio" y `.env` en `Capitulos/` y `Apendices/` no devuelve nada.

La tesina no menciona el repositorio en ninguna parte (no hay URL ni commit; `grep` de "repositorio/github" en `Capitulos/` y `Apendices/` da vacío). Tampoco aparecen: la estructura `models/`, `dtos/`, `tests/infra`, el patrón Observer (`observer/observer.py`, `models/base/model.py`), cómo correr una suite (`python -m tests.run_suite <modelo> <functional|stress>`, `README.md:L157-158`), las variables de entorno (`.env.example`: `WRITE_RESULTS_CSV`, `WRITE_SOLUTIONS`, `TEST_TIMEOUT_MINUTES`, `STRESS_TEST_TIMEOUT_MINUTES`, `OPP_STAGE1_WORKERS=1`) ni el pipeline de análisis (`analysis/`). Solo `cap6` menciona `WRITE_SOLUTIONS`/`.env`. Un revisor no puede reproducir nada con lo que dice la tesina.
- Propuesta: una sección corta "Implementación y reproducibilidad" (en cap5 o en un anexo nuevo; `ap1.tex` "Diagramas" está vacío y ya no se incluye en `tesina.tex`) con: el enlace y el commit de `main` con que se generaron los resultados, el árbol de directorios, el flujo `.dat` → ZIMPL → LP → SCIP, la tabla de variables de entorno y el comando de cada estudio.
- Atención: el orquestador del modelo Split (validación, paralelismo de la Etapa 1, elegibilidad, `M_seq`) **vive en `tests/`** (`tests/opp_v5_2_split/stage1_decomposition.py`, `tests/infra/zimpl/`), no en `models/`, y `verification/` importa de `tests.infra` (`verification/mono_compliance.py:L22-27`). Conviene decirlo, porque cap3 describe ese pipeline como parte del modelo (`cap3.tex:L594-618`).

#### B5 — Menor — Hallazgo del 4×4 y paridad con el camino simple

`meta.md:L525-526` ("Hallazgo 2026-09-23"): en una grilla 4×4 un lote que requiere 13 de 14 ubicaciones es infactible con el `<= 1` por paridad (el depósito y el final están en esquinas opuestas, mismo color de tablero), aunque físicamente sea posible. `cap7.tex:L162-170` ya discute que "no existe un camino simple" en almacenes pequeños. Está cubierto en lo esencial; falta el argumento de paridad, que explica por qué ocurre, y la medición (estudio 07: con y sin `<= 1` los tiempos de ruta son idénticos en 7×7 y 13×13). Prioridad baja: verificar si ap5 lo incluye (no leído).

*(B3, la procedencia de cada resultado consolidado, está cubierta en D-2 y A4; B4, la evidencia de que v5 se reduce a v4, en E-02.)*

#### Lo que está en el repositorio y no en la tesina, ordenado por importancia

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

#### Inconsistencias del repositorio que conviene saber (no son de la tesina)

- `README.md` está desactualizado respecto de la estructura real: menciona `utils/output_handler.py`, `models/opp_v1/opp_location_graph.py` y `models/opp_v1/opp_output_builder.py`, que ya no existen en esas rutas (el grafo está en `models/base/opp_location_graph.py`), y el comando de tests solo cubre `opp_v1`. Si la tesina va a enlazar el repositorio (B1), conviene actualizarlo.
- `meta.md:L199` ("`M_seq` (500, fijo)") contradice `meta.md:L413` (el cálculo de `M_seq` divide por la velocidad mínima).
- `docs/README.md` y `scripts/README.md` están al día.

### C. Tests

El «nombre exacto» verificable es el archivo `tests/opp_v5_2_split/functional/test_case_NN.py` y `tests/opp_v5_1_mono/functional/test_case_NN.py`: existen los 38 en ambos. La tesina nunca cita nombres de método; usa «caso NN[letra]». Las letras no existen en el código (se infieren del orden alfabético del método).

**Verificación de los Mayores:** C1 confirmado (`tests/infra/factories/migrated_case.py:57-58` pone la cadena de frío en 10⁹ y la línea 105 fija `V_p = 1`; 30 de los 40 archivos funcionales del Split importan `migrated_case`; `tests/opp_v4/functional` tiene 46 pruebas, de las que 45 se reutilizan). C2 confirmado (`tests/opp_v5_2_split/functional/test_case_24.py:21-25` llama a `run_pipeline(solve_stage2=False)` y afirma sobre `eligible_pairs`, una réplica propia del test). C5 confirmado (búsqueda de código y documentos sin ningún rastro de la inyección de errores). Se bajan a Menor C3 (trazabilidad por letras), C4 (unidad prueba/instancia; verificado contra el fixture: las 6 pruebas de dos instancias de ap7 informan el objetivo de la última) y C6 (el test del caso 28 acepta `infeasible` en la fecha ajustada, `tests/opp_v4/functional/test_case_26.py:83-86`, aunque los datos muestran ambas óptimas).

| # | Sev. | Hallazgo | Ubicación tesina |
|---|------|----------|-----------|
| C1 | **Mayor** | «Los casos se diseñaron uno por uno» es inexacto: 45 de las 64 pruebas del Split (30 de 38 archivos) son los tests de `opp_v4` reutilizados sin tocar sus asserts mediante un adaptador (`migrated_case`/`migrated_mono_case`); varios v4 a su vez fueron «portados de opp_hc_2» (v4 25–31 → casos 27–33). El adaptador fuerza `V_p = 1,0` y `T_cold = 10⁹` (sin cadena de frío) y reemplaza `assert_no_time_overlap` (en v4/Split era una tautología hasta el 2026-09-09). Nada de esto aparece en la tesina. | `cap5.tex:56-58`, `ap4.tex` |
| C2 | **Mayor** | El caso 24b no prueba «el chequeo previo a la Etapa 2»: afirma sobre `eligible_pairs`, una **réplica escrita dentro de la clase de test**; el chequeo real (`batches_without_eligible_picker`) no se invoca porque `run_pipeline(solve_stage2=False)` retorna antes. (El 34b sí ejercita el chequeo real.) | `ap4.tex:44`, `cap5.tex:64,110` |
| C3 | Menor (era Mayor) | Las letras (06a, 19b, 25e…) **no existen en el código**. El mapeo (inferido por mí) es «orden alfabético del nombre del método» (orden en que `unittest` los corre) y se cumple en los 17 casos con varios métodos, pero no está documentado en ninguna parte → trazabilidad tesina↔repo frágil (renombrar un método cambia la letra). | `ap4.tex:3-5`, `cap5.tex:60-61` |
| C4 | Menor (era Mayor) | «Los dos modelos coinciden en los 60 pares» y las tablas de `ap7`: la unidad es la *prueba*, no la instancia (cap6 dice «instancias»). 6 pruebas resuelven 2 instancias (19b, 25e, 25f, 26b, 26d, 28) y la columna «Objetivo» de `ap7` reproduce siempre el valor de la **última** instancia (verificado contra el fixture: 19b 120→**0**, 25e 276→**0**, 25f 102→**156**, 26b 20725→**20899**, 26d 5325→**13479**, 28 20→**0**). Es decir, la igualdad de objetivo mono=Split de la primera instancia de esas 6 pruebas no está reportada ni (por lo visible) comparada. Instancias reales en pares: 66, no 60. *(Hipótesis consistente con los datos; confirmar en la sección D contra el script de comparación, que está fuera de mi alcance.)* | `cap5.tex:559-564`, `cap6.tex:23-27`, `ap7.tex` |
| C5 | **Mayor** | La «validación del verificador» (4 errores inyectados, los 4 detectados) no tiene rastro en el repo: no hay test, script ni dato en `tests/` ni `verification/` que la reproduzca. Idem el control de «248 soluciones con y sin recorte» (no verificable dentro del alcance). | `ap6.tex:64-65,78-81` |
| C6 | Menor (era Mayor) | El caso 28 afirma «ambas tienen solución, porque la demora absorbe la fecha ajustada», pero el test **acepta `infeasible`** para la fecha ajustada (`assertIn(status_tight, ("optimal","feasible","infeasible"))`). Los datos sí muestran ambas óptimas (fixture: obj. 20 y 0), de modo que la afirmación es cierta pero el test no la protege. | `ap4.tex:57` |
| C7 | Menor | «38 casos de prueba funcionales» (resumen, abstract, cap5, cap7): el caso 12 no tiene ningún método activo (comentado), así que hay **37 casos con pruebas** (64 pruebas). | `resumen.tex:16`, `abstract.tex:14`, `cap5.tex:56`, `cap7.tex:437` |
| C8 | Menor | 36c: «las velocidades nulas o negativas se rechazan antes de resolver» — lo que el test comprueba es que el *helper* `run_pipeline` del test lanza `AssertionError` (`assertFalse(invalid_speeds(...))`); no se prueba que el pipeline de producción lo rechace (solo que la utilidad `invalid_speeds` de producción detecta el valor). | `ap4.tex:75`, `cap5.tex:113` |
| C9 | Menor | Cap. 6/ap7 no informan cuántas pruebas pasan/fallan. La única no-terminada documentada es 30a (timeout; confirmado por el fixture: `v5_status = timeout`); en el runner un timeout es `status = "timeout"`, no `ok`. `cap7.tex:27` («las pruebas funcionales lo confirman») no menciona que el 30a no termina. `nightly.yml` (comentario de 2026-09-24, anterior al reemplazo del `test_case_06` del 2026-09-29) cuenta 63/62 pruebas y un «known failure» del mono 06: estaría desactualizado (el conteo actual es 64/63), pero **no verifiqué** cómo está hoy el 06 del mono. | `cap6.tex:34-46` |
| C11 | Menor | Descripciones imprecisas (detalle en la tabla §3): 04 («cubren las ubicaciones» vs igualdad exacta), 08 («instancia del 07 + una ubicación»: es otro escenario con otros pedidos), 34a («tiempo de ejecución» vs instante de finalización), «camino válido» (solo el 19c verifica un camino simple; 06a/20/25c verifican cobertura), «carga equilibrada» (es diferencia ≤ 1 en *cantidad de lotes* por picker, no en carga de trabajo; solo si hay >1 picker y >1 lote). | `ap4.tex`, `cap5.tex:89-95` |
| C12 | Menor | `ap7`: caso 27 imprime objetivo `58,0` y el valor real es `58,05` (fixture). | `ap7.tex` (fila 27) |
| C13 | Menor | Casos 13 y 14 son la misma instancia (el único cambio es el diccionario `x`, no usado): la tesina lo dice, pero conviene aclarar que son duplicados efectivos y que los nombres `two_periods`/`one_period` del código no corresponden a ninguna diferencia. | `ap4.tex:28-29` |
| C14 | Menor | Tope de 40 min en estrés: el default del código es 25 min (`STRESS_TEST_TIMEOUT_MINUTES` = `TEST_TIMEOUT_MINUTES`); los 40 min solo salen de `.env` (`.env.example` lo documenta: «40 was used for the ACO stress runs»). | `cap5.tex:314-315` |
| C15 | Menor | Verificador (ap6) vs. `verification/mono_compliance.py`: (i) tolerancia «relativa 10⁻⁶» es en realidad `|a−b| ≤ 1e-6·max(1,|a|,|b|)` (mixta); (ii) cada solve de SCIP tiene tope de 300 s y un estado ≠ `optimal` (p. ej. `timelimit`) se informa como veredicto «violations», no como error; (iii) el diagnóstico «lote por lote» solo corre si hay ≤ 40 lotes fijos; (iv) el reloj de cada picker arranca en `start_time` de la instancia (por defecto 0), no «desde el instante 0»; (v) el recorte de subgrafo solo se aplica si no hubo prechequeos de ruta fallidos. | `ap6.tex:139-149`, `ap6.tex:59-65` |
| C16 | Menor | Tests/herramientas del repo no mencionados que conviene citar (ver §4): suites propias de HC/ACO v4 (cadena de frío, velocidades, pre-chequeo, «soft cold chain»), fixture y exportador de equivalencia, `verification/compare_v5.py`, `run_compliance.py`, `solution_store.py`, y CI. No hay tests unitarios (solo funcionales/estrés) ni medición de cobertura en `.github/`/`tests/`. | — |

*(La unidad «60 pares = pruebas, no instancias» de C4 coincide con F21 y D-14; C7 con F22.)*

#### Sugerencias para C (solo texto, no aplicadas)

* `cap5.tex:56-58`: reemplazar «diseñaron uno por uno» por una frase que distinga los 19 tests propios de v5 de los 45 heredados de la suite v4 (y de heurísticas), y aclarar que los heredados corren con velocidades 1,0 y sin cadena de frío.
* `ap4.tex` (o un apéndice): agregar una columna «archivo / método» con el nombre real (p. ej. `test_case_25.py::test_grid_batch_infeasible_order_size` para el 25a) y declarar la regla de las letras; mejor aún, renombrar/etiquetar en el código para que la letra figure en el docstring.
* 24b: o bien cambiar el test para que llame a `batches_without_eligible_picker`, o bien reformular la fila de `ap4` («verifica la regla de elegibilidad replicada en el test; el chequeo de producción lo ejercitan 34b y 35c»).
* 28: endurecer el test (exigir feasible en ambos) o debilitar la frase de `ap4`.
* `cap6.tex:23` y `ap7`: aclarar que los pares son *pruebas*, qué instancia informa la columna Objetivo en las 6 pruebas de dos instancias (o reportar ambas) y corregir «instancias» → «pruebas».
* `ap7` fila 27: `58,05`.
* `ap6`: documentar el tope de 300 s por solve y qué veredicto produce; mencionar o reproducir en un script (`verification/`) la validación con errores inyectados.
* Añadir en el anexo de reproducibilidad una línea sobre `verification/compare_v5.py`, `run_compliance.py` y el fixture de equivalencia.

### D. Experimentos y resultados

#### D-1 — Crítico — El monolítico «no termina ninguno de los 19 escenarios de estrés» está medido solo en 7 de 19

**Verificación:** Confirmado. `results/opp_v5_1_mono/stress/output_opp_v5_1_mono_stress_tests.csv` tiene 19 filas: 01 `no_result` y 02–19 `timeout` con la misma etiqueta "- 40"; `meta.md:623` dice que el 02 se canceló pasados los 40 min y "la fila se cargó a mano", y que 08–19 "figuran como timeout" porque la corrida del 24/09 se cortó sin dejar CSV.

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

#### D-2 — Mayor — Los resultados de HC (estrés y funcional) y de ACO funcional vienen de una versión anterior del código; la tesina afirma reproducibilidad y no lo declara

**Verificación:** Confirmado. El commit `75d553c` (2026-10-19, "Add sorted()") hizo determinista el orden de la ruleta; los CSV de HC estrés, HC funcional y ACO funcional son del commit `45dea09` (2026-09-29), y ACO estrés del `8779dbc` (2026-11-10). Recalculado: comparando la semilla 1 con 200/60 de `results/opp_hc_4/budget` (código final) con el CSV de estrés, 17 de 18 escenarios difieren; la brecha máxima contra el Split pasa de 0,214 % (escenario 11, valor de la tesina) a 0,18 %. Incluye el hallazgo A5 (la propiedad de reproducibilidad entre procesos vale para el código actual: `route_construction.py:794-797`) y B3 (procedencia de los CSV consolidados).

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

#### D-3 — Menor (reclasificado; el informe parcial decía Mayor) — El Cap. 6 omite que HC falla con otras semillas

**Verificación:** Confirmado: `results/opp_hc_4/budget/…_20261019_201951.csv` tiene 8 filas `infeasible` (escenario 09 semilla 4; escenario 11 semilla 5), o sea 2 de 90 ejecuciones con 200/60. Se baja a Menor porque el resumen, el abstract y `cap7` ya acotan la afirmación («en la corrida principal») y `ap8` y `cap7` reconocen el fallo; falta solo en `cap6`. (Fusiona F3.)

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

#### D-4 — Mayor — El caso 30a: se presentan tiempos de *verificación* como tiempos de *resolución*, y una «probable causa» como confirmada

**Verificación:** Confirmado: `meta.md:655` dice "sin ellos se verifica en 0,13 s; con ellos libres SCIP no cerraba en 600 s. Probable causa del timeout"; `cap6.tex:50-53` dice "lo confirma" y `cap7.tex:505-508` lo presenta como resolución. El repositorio no tiene ninguna corrida de resolución de 30a sin los lotes vacíos.

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

#### D-5 — Crítico (reclasificado; el informe D decía Mayor, el F+G+H Crítico) — Un párrafo contradice su propio cuadro (40 minutos)

**Verificación:** Confirmado en los `.tex`: `cap6.tex:314-315` dice que con 40 minutos el monolítico "sigue sin probar el óptimo en esos puntos", y el Cuadro (`cap6.tex:329-332`) muestra para "6 lotes, 5×5" `32,0 min`, "¿Prueba el óptimo?" sí. `experiments/opp_v5/README.md` (estudio 11) dice "only 6 batches on 5×5 closes". Se sube a Crítico porque la oración es falsa respecto de los datos y del propio cuadro. (Fusiona F5.)

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

#### D-6 — Menor (reclasificado; el informe parcial decía Mayor) — `results/comparability/*.csv` no reproduce los números de ACO en estrés de la tesina

**Verificación:** Confirmado: `results/comparability/results_v5_vs_heuristics.csv` (commit `08bd9b5`, 2026-09-29) da ACO 01 = 988.252 y 2 óptimas en 9; el CSV de estrés actual (`8779dbc`, 2026-11-10) da 909.168 y 3 óptimas, que son los números de la tesina. Es un problema del repositorio (CSV derivado desactualizado), no de la tesina. Esto además refuta que la fila 988.252 siga usándose (ver Anexo, A3).

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

#### D-7 · Menor — "al menos 71 veces" (`cap6.tex:288-290`)


- El monolítico, 4 lotes en 6×6, se cortó a los 569,8 s (`experiments/opp_v5/studies/08_mono_frontier/frontier_20260923_201522.csv`, `total_s`, `status=timelimit`).
- El Split lo resuelve en 8,4 s, así que la cota inferior real es 569,8 / 8,4 ≈ **67,8**.
- El 71 sale de dividir el tope de 600 s, que el monolítico no llegó a consumir (SCIP tenía límite 570).
- Sugerencia: "al menos 68 veces". También conviene aclarar que el "tope de 10 minutos" fue un límite de SCIP de 570 s dentro de un corte duro de 600 s.

#### D-8 · Menor — "con hasta 4 lotes resuelve cualquier grilla en menos de 10 segundos" (`cap6.tex:283-284`)


- En el estudio 08 no hay fila del Split para 4 lotes en 7×7: el monolítico figura `skipped` y falta la del Split. La figura solo llega a 6×6 con 4 lotes (8,4 s).
- Medido hasta 3 lotes en 7×7 (9,7 s) y 4 lotes en 6×6 (8,4 s).
- `cap6.tex:171` dice "con 1 a 6 lotes", pero la figura y la leyenda muestran 2, 3, 4 y 6.
- Sugerencia: acotar a "con 3 lotes en grillas hasta 7×7 y con 4 lotes hasta 6×6" y corregir "1 a 6" por "2 a 6" o explicar por qué se omite el 1.

#### D-9 · Menor — Medianas contra mediana de cocientes (`cap6.tex:578-581`)


- La tesina dice: "en la mediana, el Split tarda 0,300 s, HC 0,061 y ACO 0,224, **de modo que** HC es 5,1 veces más rápido … y ACO, 1,4".
- Con esas tres medianas, 0,300 / 0,061 = **4,9** y 0,300 / 0,224 = **1,34**.
- Los 5,1 y 1,4 son la mediana de los cocientes por instancia (`results_v5_vs_heuristics.csv`: 5,14 y 1,44).
- Ambos números son correctos, pero el "de modo que" mezcla dos estadísticos. Aclarar: "la mediana del cociente por instancia es 5,1 y 1,4".

#### D-10 · Menor — "En las 9 restantes, de alrededor de un segundo" (`cap6.tex:581`)


- Tiempos de ACO en esas 9 instancias: 0,29 / 0,32 / 0,44 / 0,98 / 0,98 / 1,01 / 1,07 / 1,14 / 1,14 s.
- Son de 0,3 a 1,1 s, no todas "alrededor de un segundo". Cambiar por "entre 0,3 y 1,1 s".

#### D-11 · Menor — Paralelismo de la Etapa 1 (`cap6.tex:357-360`)


- La tesina dice: "reduce el tiempo de la Etapa 1 como mucho a la mitad (2,2 veces …)".
- Un factor de 2,2 deja el tiempo en ~45 %, es decir, **a menos de la mitad**. Los números (×2,2 en 13×13 y ×1,9 en 14×14) sí están bien (estudio 12: 242,8 → 110,4 s y 403,5 → 212,7 s).
- El argumento sobrevive: aunque el Split del 15×15 (904 s) tuviera todo su tiempo ×2,2, daría ~33 min, menos de 40.
- Corregir la frase por "hasta 2,2 veces" y usar 2,2 en el argumento.
- Nota: en la suite de estrés real la ganancia de la Etapa 1 fue menor, entre ×1,15 y ×1,82 según `meta.md:423`. Los 2,2 y 1,9 vienen de la medición controlada del estudio 12.

#### D-12 · Menor — Ajustes del verificador "en pocos casos" (`cap6.tex:408-412`)


- En `results/compliance/opp_aco_4/stress/…csv`, **las 19 filas** tienen la nota "SCIP levels ran on the routes' subgraph", por ejemplo "49 of 49 nodes".
- En `results/compliance/opp_hc_4/stress/…csv` solo el 100×100 tiene esa nota (1.425 de 10.000 nodos y 2.900 de 39.600 arcos).
- Las dos corridas del verificador no tienen el mismo comportamiento de nota, o el recorte se aplica siempre y solo HC no lo anota.
- `ap6.tex:59-65` dice que se aplica "cuando todas las rutas están fijas", o sea casi siempre.
- El 100×100 es el único en el que "resultó necesario".
- Para ACO el CSV actual da 1.365 de 10.000 nodos y 2.965 arcos; para HC, 1.425. "Unas 1.500" (`cap6.tex:411`) queda alto. Mejor "unas 1.400".
- La afirmación sobre el caso 30a (10 lotes vacíos quitados) está confirmada.

#### D-13 · Menor — Otros detalles de redacción o precisión


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

#### D-14 · Menor — `compare_v5_split_vs_mono.csv` deduplica por nombre de método


- El Split tiene 64 filas funcionales y el CSV de comparación tiene 63, porque une por nombre de método. Los casos 02 y 03 comparten `test_two_orders_two_aisles` y colapsan.
- Los totales del CSV (28 / 21 / 12) coinciden con la tesina (49 pares, 21 óptimos alternativos, 11 infactibles + la 36c) solo por compensación: el CSV incluye la 37a, que la tesina excluye, y pierde uno de los duplicados.
- Recalculado por caso (clave `test_case_NN.método`): 60 pares, 49 resueltos, 11 infactibles. Coincide con `ap7.tex`.
- Sugerencia: unir por `caso.método` en `verification/compare_v5.py` o documentar la colisión.

#### D-15 · Menor — Cambio reciente: "35 de las 45" y las medianas de tiempo no se reproducen con el CSV


- **Tesina:** `cap6.tex:575-581` ahora dice que los tiempos se comparan "sobre 35 de las 45 instancias comparables", con medianas de 0,295 s (Split), 0,061 s (HC) y 0,225 s (ACO), y "HC fue más rápido … en las 35 instancias".
- **Recalculado** (`results/comparability/results_v5_vs_heuristics.csv`, nivel funcional, instancias comparables en objetivo): hay 45, de las cuales 33 vienen de pruebas con una sola instancia, con medianas 0,3001 / 0,0609 / 0,2244 s, HC más rápido en 33 y ACO en 24. Los 35 salen de sumar los casos 02 y 03, que comparten el nombre de método y por eso el CSV los trata como si fueran un caso de dos instancias.
- **Qué falta:** si se incluyen 02 y 03, hay que decir cómo se obtuvo su tiempo (el CSV guarda una sola fila del Split para el nombre compartido) y recalcular las medianas; el 0,295 y el 0,225 no salen de los datos disponibles.
- **Sugerencia:** o volver a 33 (con las medianas 0,300 / 0,061 / 0,224) o regenerar el CSV por `caso.método` (ver D-14) y recalcular.

### E. Relación con la bibliografía (sobre todo logistics-07-00061)

#### Qué dice el paper (leído completo, pp. 1-18)

- **Problema** (pp. 1-5): JOBASRP/JOBSPRP, optimización conjunta de (1) batching, (2) asignación y secuenciación de lotes a pickers, (3) ruteo. Picker-to-parts, almacén manual de bajo nivel, varios pickers trabajando simultáneamente, un picker ejecuta un lote por vez. Depósito inicial y final **separados lógicamente** (pueden coincidir físicamente) (p. 4). Capacidad del carro medida en ítems (p. 6). **Sin congestión**: la declaran trabajo futuro (p. 16).
- **Tiempo de un lote** (p. 4, ec. 18 p. 7): setup + búsqueda/recolección por ítem (β^picking) + viaje (β^time · distancia). Un único β^time para todos los pickers (velocidad homogénea).
- **Modelo completo** (ecs. 1-32, pp. 6-8): variables `x_pkh` (misión h en la posición k del picker p), `y_nh` (orden n en misión h), `z_ijh` (arco), `f_ijh` (flujo). Objetivo: `w1·Σ v_pk + w2·(γ·Σ ea_n + ∂·Σ ta_n)`. Camino simple (ecs. 14-15: a lo sumo un arco de entrada y uno de salida por nodo). Completitud con desigualdades (ecs. 19-21): hay espera voluntaria implícita.
- **Modelo simplificado** (ecs. 33-48, pp. 9-10): sin ruteo; recibe **todos los lotes factibles** con su distancia calculada con **vecino más cercano** (p. 9).
- **Heurística** (pp. 10-12): constructiva por fecha de entrega más temprana (Alg. 1) + multi-start + búsqueda local (swap / insert) + ILS (perturbación swap, búsqueda local insert, aceptación solo si mejora; Alg. 2-3) + ILS con perturbación múltiple. Se aplican a la **permutación de órdenes**.
- **Experimento** (pp. 12-15): caso real de una empresa logística italiana, primera semana de julio de 2019, 5 días, 50-74 órdenes/día, ≈550 ubicaciones; β^time = 3 s/unidad, 10 s por ítem, setup 180 s, capacidad 20 ítems; comparación contra "single order" con un solo operario. Datos "disponibles a pedido" (p. 16).
- **Resultados**: tiempo de recorrido −24 % (Tabla 2), setup −84 % (Tabla 3), "tiempo total de picking" −57 % (207,97 min/día; Tabla 4). Umbral de clasificación: 20,98 min/lote o 2,54 min/orden (Tabla 5). ILS e ILS-múltiple obtienen la mejor solución 4 y 1 veces (p. 15). Los modelos MIP "resuelven problemas menores en tiempos aceptables" (p. 16), pero no se reporta ninguna corrida de los MIP.

#### E-01 — Mayor — Rangos de la sensibilidad de ACO vs. valores de Alaya et al. y Lesch et al.

**Verificación:** Confirmado con `pdftotext`: Alaya et al., Tabla 1: m-ACO3 α=1, β=8, ρ=0,01; m-ACO4 α=1, β=4, ρ=0,01; Lesch et al.: "evaporation factor ρ to 0.02". La grilla de `ap8.tex:388-392` es β ∈ {1; 2,5; 4} y ρ ∈ {0,05; 0,15; 0,30}. Fusiona A13.

- **Tesina**: `ap8.tex:390-391`: "Los rangos abarcan los valores por defecto y los que reportan Alaya y Solnon [alaya2007antcolony] y Lesch et al. [lesch2023optimizing]". Rangos probados (`ap8.tex:~384-389`): α∈{0,5; 1; 2}, β∈{1; 2,5; 4}, ρ∈{0,05; 0,15; 0,30}.
- **Fuentes**: Lesch et al., p. 18620 (PDF p. 16): α=1,0, β=2,0, **ρ=0,02**, τmin/max=1/25. Alaya et al., Tabla 1 (PDF p. 5): m-ACO1/2: α=1, β=4, ρ=0,1; m-ACO3: α=1, **β=8**, **ρ=0,01**; m-ACO4: α=1, β=4, **ρ=0,01**.
- **Qué es correcto**: α=1 y β∈{2;4} caen dentro del rango; **ρ=0,02 (Lesch) y ρ=0,01 (Alaya) quedan por debajo de 0,05, y β=8 (Alaya) por encima de 4**. Además el artículo de Alaya es de Alaya, Solnon **y Ghedira** (tres autores; `cap2.tex:456` dice "Alaya et al." bien, `ap8.tex:390` dice "Alaya y Solnon"), y sus parámetros corresponden a un problema de mochila multiobjetivo, no a ruteo.
- **Sugerencia**: "Los rangos incluyen los valores por defecto y los de Alaya et al. y Lesch et al. salvo ρ ≤ 0,02 y β = 8, que quedan fuera" o extender la grilla (ρ=0,02; β=8). Aclarar que esos valores provienen de otros problemas (mochila multiobjetivo; picking en entrepisos). Corregir "Alaya y Solnon" por "Alaya et al.".

#### E-02 — Mayor — «Se reducen al modelo de referencia»: el contraste es con `opp_v4`, no con el paper (incluye F4 y B4)

**Verificación:** Confirmado: `models/opp_v4/opp_model_v4.zpl` usa precedencias `y_bk` (b<k) y tiempo de servicio `S_i` (líneas 69 y 135); `tests/infra/factories/migrated_case.py` reutiliza los asserts de v4 con `V_p = 1` y cadena de frío desactivada, y 31 pruebas funcionales migradas verifican esa reducción (`meta.md:186-187`). El informe F+G+H planteaba que "ninguna prueba la verifica"; no es así, pero la tesina no lo dice: `cap7.tex:425-429` atribuye a las pruebas funcionales tanto el respeto de las reglas como la reducción, y `cap5.tex` no describe la prueba. El nombre `opp_v4` no aparece en la tesina. En el repo no hay una implementación de la formulación publicada.

- **Tesina**: `cap3.tex:26-30` ("si todos los operarios tienen la misma velocidad, el límite … es suficientemente grande y no hay tiempos de servicio, los dos modelos se reducen al modelo de referencia con los lotes fijos"); `cap7.tex:24-27` ("…y las pruebas funcionales lo confirman"); `cap7.tex:419-424` (Conclusión 1).
- **Evidencia**: el repo no implementa la formulación del paper (variables `x_pkh`, `y_nh`, `z_ijh`, `f_ijh`, conjunto de períodos K). El baseline es `models/opp_v4/opp_model_v4.zpl` (rama `main`), que ya usa precedencias `y_bk` (b<k), tiempo de servicio `S_i` por nodo, lotes dados y sin restricción de capacidad (`opp_model_v4.zpl:22-135`); `tests/infra/factories/migrated_case.py:1` re-ejecuta los asserts de v4 contra v5.2. Es decir, "la reducción" está probada contra un modelo propio, que a su vez es una adaptación del paper.
- **Qué es correcto**: lo que se verificó es que v5.1/v5.2 reproducen a v4 cuando se anulan velocidad, cadena de frío y servicio. La equivalencia v4 ↔ formulación publicada (posiciones vs. precedencias; flujo acotado por capacidad vs. por L_b; eq. 16 del paper) es un argumento de la tesina, no un resultado verificado. El nombre `opp_v4` no aparece en la tesina (solo en comentarios de la guía de `cap5.tex:649`).
- **Sugerencia**: decir en `cap3` (y en `cap7:24-27`) que "el modelo de referencia" contra el que se prueba es la adaptación propia (v4) y justificar brevemente por qué es equivalente al del paper con lotes fijos (la secuencia por posiciones y por precedencias representan los mismos órdenes totales por picker), o suavizar a "se reducen a la adaptación del modelo de referencia con lotes fijos".

#### E-03 — Mayor — El «57 %» y sus condiciones

**Verificación:** Confirmado en el PDF (Tabla 4, p. 15): 361,47 → 153,49 min = 207,97 (57 %); el texto (p. 14) aclara que solo se evaluó el componente de tiempo de viaje y el setup de 180 s, y que el ahorro de setup es 169,20 min; la clasificación posterior queda fuera (Tabla 5).

- **Tesina**: `cap2.tex:445-446` ("su propuesta reduce el tiempo de picking en un 57 % respecto de preparar los pedidos de a uno"); `cap7.tex:90-99` (descompone 169,20 + 38,77 = 207,97 min y dice que "no son comparables").
- **Paper**: Tablas 2-4 (pp. 14-15). Recalculado:
  - "Picking total time" de la Tabla 4 = recorrido + setup, **sin** el tiempo de recolección por ítem: 160,47 + 201,00 = 361,47 y 121,69 + 31,80 = 153,49 (el paper dice que ese tiempo es constante, p. 14). El 57 % es 207,97/361,47 = 57,5 % de *recorrido + setup*, no del tiempo total de picking.
  - 169,2 de los 207,97 min (81 %) son *setup* (3 min por lista × 50-74 listas diarias en "single order" vs. 7-14 lotes); el recorrido aporta solo el 24 % de reducción (Tabla 2).
  - El ahorro es **bruto**: no incluye la clasificación posterior (Tabla 5; el paper concluye que solo conviene si clasificar cuesta < 20,98 min/lote o < 2,54 min/orden, p. 15).
  - Se obtuvo con la **heurística** (EDD + multi-start + ILS), no con los MIP, que no se corrieron sobre el caso (pp. 10, 13, 16). Una sola semana (5 días) y un solo operario como línea base.
- **Qué dice la tesina vs. correcto**: `cap7:93-94` acierta en la descomposición y en que "proviene sobre todo de la preparación"; `cap2:445` no aclara nada de lo anterior y le atribuye el resultado a "su propuesta" (los modelos).
- **Sugerencia**: en `cap2.tex:445-446`: "…reduce el tiempo de recorrido + preparación un 57 % (heurística constructiva con ILS, una semana de datos reales, sin contar la clasificación posterior ni el tiempo de recolección, que se mantiene)". En `cap7:93`, aclarar que "preparación" es el *setup* de 180 s por lista (en `cap1.tex:13-15` "tiempo de preparación de un pedido" significa otra cosa; ver E-12).

#### E-04 — Mayor — Estado del arte insuficiente para sustentar el posicionamiento

**Verificación:** Confirmado en el paper (p. 4): cita explícitamente pickers heterogéneos [17] y múltiples pickers [29]; `cap2.tex:426-473` reseña 4 trabajos. Es un juicio de revisión más que una inexactitud; `Notas/pendientes_cap7.md` §6 registra que se decidió dejarlo pendiente.

- **Tesina**: `cap2.tex:426-473` cita solo 4 trabajos sobre picking (Coruzzolo, Chen, Lesch, Alaya); `cap2.tex:461-466` posiciona el aporte en "velocidad heterogénea y cadena de frío, presentes en la operación real", y la intro cita 2 trabajos de motivación (Urzúa, Gutiérrez).
- **Paper** (usado como índice de literatura): pp. 3-4 y Tabla 1 listan 15 trabajos de batching/asignación/secuenciación/ruteo conjuntos; cita explícitamente **pickers heterogéneos** (ref. [17], Chen, Cheng, Chen y Chan 2015; ref. [29], Matusiak et al. 2017 "individual picker skills"), **múltiples pickers** (refs. [29]-[32]), **fechas de entrega** (refs. [16], [31]) y los modelos más completos del JOBASRP (refs. [30], [33] según p. 4; ref. [18] Scholz et al. 2017; ref. [28] Valle et al. 2017). Referencia de revisión general: ref. [7] de Koster et al. 2007.
- **Qué es correcto**: sin esa revisión no se puede afirmar que la heterogeneidad de velocidad o la cadena de frío sean un aporte respecto de la literatura; solo respecto del paper de referencia. Tampoco hay literatura de cadena de frío/almacenes refrigerados en la bibliografía (ninguna entrada, ni en `zpaper/`).
- **Sugerencia**: agregar una subsección breve (1 párrafo + 4-6 citas) con: (i) revisión de picking (de Koster et al. 2007), (ii) trabajos de JOBASRP con pickers múltiples/heterogéneos (Matusiak 2017; Chen 2015; Scholz 2017), (iii) ruteo como Steiner-TSP, y (iv) algo de almacenamiento en frío si existe. Acotar la afirmación de novedad a "respecto del modelo de referencia".

#### E-05 — "No pudieron resolver ninguno de sus modelos": falta el matiz del paper — **Menor**

- **Tesina**: `cap7.tex:34-36` ("no pudieron resolver sobre su caso de estudio ninguno de sus dos modelos, ni siquiera el simplificado"); `cap2.tex:466-470`; `cap7.tex:37-42` ("resultados consistentes con esa experiencia").
- **Paper**: abstract p. 1 ("both models were too complex to test"); p. 10 ("not solvable within acceptable time limits") ✓. Pero también: p. 12-13 ("designed a simple problem that could be solved within acceptable time limits") y conclusiones p. 16 ("Both proposed models could solve minor problems with acceptable computational times"). No hay ninguna tabla de esos resultados. En p. 16 además dicen que ILS "could successfully identify the minimum solution", afirmación que el paper no puede sostener (nunca obtuvo el óptimo).
- **Qué es correcto**: la tesina acierta en el caso real (≈550 ubicaciones, 7-14 lotes/día por Tabla 3), pero omite que los autores sí resolvieron problemas pequeños y no publicaron resultados. La "consistencia" con la experiencia de esta tesina es solo cualitativa: los tamaños no son comparables (el paper no da los de su problema chico).
- **Sugerencia**: "los autores informan que ambos modelos solo resultaron resolubles en problemas pequeños, sin publicar esos resultados, y que el caso real quedó fuera de alcance". En `cap7:37-42`, aclarar que la comparación de dificultad es cualitativa.

#### E-06 — "Flujo de tipo Gavish y Graves" atribuido al paper — **Menor**

- **Tesina**: `cap2.tex:434-436` y `cap3.tex:282` / `cap2.tex:75-78`.
- **Paper**: no menciona MTZ ni Gavish-Graves; usa `f_ijh ≤ Cap·z_ijh` (ec. 12) y la ec. 16, que en el PDF (p. 7) se imprime como `Σ_g f_gih = Σ_j f_ijh ≥ a_ni·y_nh`, es decir, **conservación de flujo (igualdad)**, no una disminución de flujo por nodo. Tal como está impresa no elimina por sí sola ciclos desconectados del depósito; si lo hace, es porque debería ser `in − out ≥ a·y` (errata probable). 
- **Qué es correcto**: llamarlo "de tipo GG" es una **interpretación** de la tesina, razonable, pero no es lo que el paper dice. La tesina tampoco avisa de la ambigüedad.
- **Sugerencia**: "que interpretamos como un flujo de un único producto (ecs. 12 y 16 del paper)" y, si se quiere, mencionar la errata probable en la ec. 16 en una nota.

#### E-07 — Cota primal/dual y "gap" citados a Hillier & Lieberman — **Menor**

- **Tesina**: `cap2.tex:130-139` (cota primal, cota dual, "gap de optimalidad", "gap nulo prueba el óptimo") con `\cite[hillier2010investigacion]`.
- **Fuente**: en el PDF de Hillier & Lieberman (9.ª ed.) el cap. 11 trata ramificación y acotamiento, solución incumbente y ramificación y corte, pero no aparecen los términos "cota primal", "cota dual" ni "gap" (búsqueda de texto: 0 resultados de "cota dual", "cota primal", "gap" en sentido de brecha; no revisé página por página). Es terminología de resolvedores MIP.
- **Sugerencia**: citar un texto de MIP/documentación de SCIP para esos términos, o mantener la cita solo para B&B/incumbente.

#### E-08 — Falta atribución a Coruzzolo en el código de las metaheurísticas — **Menor**

- **Tesina**: `ap8.tex:22-30` ("Vecino más cercano") sin cita; `cap4.tex` no atribuye vecindades ni multi-start. `cap7.tex:73` dice "no se implementó la heurística de los autores".
- **Código** (`main`): `models/opp_hc_4/opp_hc_4.py:59-61` ("la ruta inicial por vecino más cercano sigue el paso de ruteo de Coruzzolo (p. 9)"; las vecindades "cumplen el papel de los movimientos swap/insert" de Coruzzolo); `opp_hc_4.py:538` (multi-start de Coruzzolo); `models/utils/route_construction.py:338, 848` (vista Steiner-TSP de Chen y Coruzzolo).
- **Qué es correcto**: la afirmación de `cap7:73` es cierta para la heurística completa (EDD + ILS), pero el NN inicial, la idea swap/insert y el multi-start sí se adaptan del paper. 
- **Sugerencia**: citar `coruzzolo2023orderpicking` en `ap8.tex:22` (NN) y en el párrafo de vecindades de HC, y precisar en `cap7:71-73` qué componentes sí se toman de los autores.

#### E-09 — Gutiérrez et al. (2019): "8 horas" — **Menor**

- **Tesina**: `cap1.tex:12-16`: "el tiempo de preparación de un pedido podía llegar a las 8 horas, y … con una mejor asignación de las ubicaciones de picking es posible reducir significativamente ese tiempo".
- **Fuente** (FP366, p. 1-2): el abstract dice "cycle time to prepare an order was high (from 2 to 8 hours depending on the order type)"; el ciclo incluye procesamiento administrativo + preparación + carga en camión (Fig. 2, p. 2), y la intervención es la reubicación de SKUs (modelo binario). Además, los pedidos son de pallets de consumo masivo en un centro con 74 SKUs.
- **Sugerencia**: "el ciclo de un pedido (procesamiento, preparación y carga) llegaba a 8 horas según el tipo de pedido". La palabra "significativamente" no está respaldada por una cifra que yo haya podido leer (solo leí pp. 1-2).

#### E-10 — Roberti y Toth (2012): generalización de "todas las instancias" — **Menor**

- **Tesina**: `cap2.tex:101-105` ("GG fue la única que llegó al óptimo en todas las instancias consideradas dentro del límite de tiempo").
- **Fuente** (pp. 125-129 del artículo, Tabla 2 y texto p. 129): son **10 instancias pequeñas de TSPLIB** (ftv33…ftv70, ft53, ft70), tope de 1800 s, CPLEX 11.2; MTZ, DL y SD resolvieron "all but one", y los autores concluyen que MTZ, GG y DL son "las mejores para usarse directamente en CPLEX". Es ATSP, no ruteo con nodos obligatorios.
- **Ok**: que la relajación de GG es más fuerte que la de MTZ (p. 117: "stronger than that of MTZ (Wong 1980; Padberg y Sung 1991)") y que las `g_ij` salen enteras (p. 117) están bien. Las ecuaciones (11)-(12) de Roberti coinciden con `cap2.tex:82-89`.
- **Sugerencia**: "en 10 instancias pequeñas de TSPLIB con un tope de 30 minutos, GG fue la única formulación que resolvió las 10; MTZ, DL y SD resolvieron 9". Citar `roberti2012atsp` en `cap2.tex:75-78` (donde se atribuyen MTZ y GG sin cita).

#### E-11 — Entrada bibliográfica de Coruzzolo — **Menor**

- `Referencias/tesina.bib:3`: autor "Sellitto, Miguel **Alfonso**"; el paper (p. 1) dice "Miguel **Afonso** Sellitto". No se ve en el PDF compilado (usa iniciales), pero es un error de datos. El resto (título, vol. 7, n.º 3, art. 61, 2023, DOI) coincide.
- Otras entradas contrastadas con PDF de `zpaper/`: Chen 2013 ✓, Urzúa 2019 ✓ (vol. 6, n.º 4, pp. 103-114, DOI), Gutiérrez 2019 ✓ (DOI y congreso), Lesch 2023 ✓, Roberti y Toth 2012 ✓ (DOI), Rosenkrantz 1977 ✓ (vol. 6, n.º 3), Babin 2007 ✓, Dorigo-Stützle 2004 ✓ (ISBN), Talbi 2009 ✓, Matoušek-Gärtner 2007 ✓ (ISBN), Hillier-Lieberman 9.ª ed., 2010 ✓. Alaya 2007: el PDF no trae sede; "ICTAI 2007" no verificable desde el PDF.

#### E-12 — Terminología "preparación" — **Menor** (solapa con F/G)

- `cap1.tex:13-15` ("tiempo de preparación de un pedido") designa el ciclo completo de picking; `cap3.tex:111` (`T^setup` = "tiempo de preparación de cada lote") y `cap7.tex:93-94` ("169,20 corresponden a la preparación") designan el *setup* por lista. El paper usa "setup time". Sugerencia: usar "armado del recorrido (*setup*)" para `T^setup` y reservar "preparación del pedido" para el picking completo.

#### E-13 — Criterio de parada de Hill Climbing atribuido a Talbi — **Menor**

- `cap2.tex:259-262`: "cuando en cada iteración se genera solo una parte de [la vecindad]… la búsqueda se detiene con criterios explícitos, como un número máximo de iteraciones o un límite de tiempo [talbi2009metaheuristics]".
- Talbi p. 122 (PDF p. 147): solo dice que el conjunto de vecinos candidatos puede ser un subconjunto de la vecindad y que la búsqueda se detiene cuando todos los candidatos son peores. En la sección de plantillas (PDF p. 194) afirma que los criterios de parada de HC "son implícitos". La parte "máximo de iteraciones o límite de tiempo" es de la tesina.
- Sugerencia: citar a Talbi solo para la vecindad restringida y presentar los criterios de parada como decisión de diseño.

#### E-14 — ILS de los autores: referencia cruzada incorrecta — **Menor**

- `cap7.tex:86-88` remite a `sec:marco_hc` para "un mecanismo para escapar de [óptimos locales], reiniciando la búsqueda local desde una perturbación de la mejor solución". `cap2.tex` §2.3 no define ILS (solo menciona "reiniciar la búsqueda"). El paper cita a Lourenço et al. (ref. [38]) para ILS; la tesina no. También `cap7.tex:533-537` propone "la búsqueda local iterada de Coruzzolo et al." como mejora de HC sin haberla descripto.
- Descripción del paper (pp. 11-12): perturbación por swap sobre la **permutación de órdenes**, búsqueda local por insert, aceptación solo si mejora, parada tras N ciclos sin mejora. La paráfrasis de la tesina es correcta pero conviene aclarar que opera sobre el orden de las órdenes (decodificado por la heurística EDD), no sobre asignación de lotes.
- Sugerencia: agregar 2-3 oraciones sobre ILS en §2.3 con la cita de Lourenço, Martin y Stützle (o Hoos-Stützle) y apuntar `cap7:88` a ellas.

#### Evaluación de las comparaciones con el paper

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

#### Afirmaciones sin cita (o con cita que no las cubre)

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

#### Citas a entradas inexistentes y entradas no citadas

- Claves usadas con `\cite[...]` en los `.tex`: 18 distintas; **todas existen** en `Referencias/tesina.bib` (18 entradas). **Ninguna entrada del .bib queda sin citar** y el `tesina.pdf` (compilado el 15-nov-2026 23:04) lista 18 referencias numeradas, sin "[?]".
- Uso de claves (resumen): coruzzolo (cap1:60,110; cap2:429; cap3:5,696; cap7:18), chen (cap2:449; cap4:269; cap7:132,604), lesch (cap2:453; ap8:391), alaya (cap2:457; ap8:391), urzua (cap1:12), gutierrez (cap1:16), hillier (cap2:18,43,63,114,128,137), matousek (cap2:39), roberti (cap2:99,105), baker (cap2:163,177), kanet (cap2:169,181; cap7:126), talbi (cap2:203,215,239,248,262,270,298,391,413,421), hoos (cap2:254,258,270,287,322), dorigo (cap2:284,293,319,327,352,366,374), stutzle (cap2:361), croes (cap2:224), rosenkrantz (ap8:34), babin (ap8:98).
- Archivos de `zpaper/` **sin entrada en el .bib**: `Flipkart Optimized Its SupplyChain.pdf` (INFORMS J. Appl. Anal. 56(1):42-57, 2026; solo leí la portada, no evalué su pertinencia), `Marco_de_TTL_monografia.pdf` (plantilla, no es fuente) y `Improvements_to_the_Or-Opt_Heuristic_for_the_Symme (1).pdf` (copia duplicada de Babin et al.).
- Citas sin PDF en `zpaper/` (no verificables): croes1958method, baker1990sequencing, kanet2000inserted.
- Citados en el paper y relevantes para la tesina pero sin entrada: de Koster et al. 2007, Matusiak 2017, Chen-Cheng-Chen-Chan 2015, Scholz et al. 2017, Valle et al. 2017, Lourenço et al. 2003 (E-04, E-14).

#### Trazabilidad cita ↔ fuente (verificadas)

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

#### Observaciones sobre el paper (no son errores de la tesina)

1. **Tabla 5 inconsistente** (p. 15): "Average Order/Batch" es N/8 en los cinco días (6,25; 8,88; 9,25; 8,88; 8,63) cuando la Tabla 3 da 8, 7, 12, 12 y 14 lotes. Recalculado con la Tabla 3: órdenes/lote = 6,25; 10,14; 6,17; 5,92; 4,93, y umbral por orden = 3,11; 3,41; 3,06; 2,72; 3,22, promedio **3,10 min/orden** (el paper dice 2,54). Los umbrales por lote (19,45; 34,62; …) sí cierran con la Tabla 3. La tesina no usa el 2,54, por lo que no hay que corregir nada.
2. El paper dice (p. 16) que ILS "identifica la solución mínima", pero nunca calculó el óptimo del caso real.
3. En el pseudocódigo de la heurística (Alg. 1, p. 11) `ṽ_p = v_p + β^time·TSP(B ∪ {n*})` suma sobre el acumulado `v_p` el tiempo del lote ampliado completo, que ya incluía el tiempo de `B`; además ignora setup y recolección. No afecta a la tesina, que no implementó esta heurística.
4. La ec. 16 (p. 7) se imprime como igualdad de flujos de entrada y salida (E-06).

### F. Conceptos

*(F2 se resolvió en la tesina; F3, F4, F5, F7, F11, F19, F21 y F22 se fusionaron con otros hallazgos o ya están resueltos: ver el Anexo.)*

#### F1 — Mayor — Explicación causal de la brecha de HC («óptimo local») sin evidencia

**Verificación:** Confirmado en los `.tex`: `cap4.tex:378-380` dice "un vecino rechazado no indica que la solución actual sea un óptimo local"; `cap6.tex:459-462` y `cap7.tex:83-85` explican la brecha de hasta 5,88 % porque "se detiene en un óptimo local".

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

#### F6 — Mayor — «Máquina compartida con otras corridas» contradice la metodología

**Verificación:** Confirmado: `cap6.tex:336-339` ("se ejecutaron con la máquina compartida con otras corridas, por lo que sus tiempos absolutos están inflados") contra `cap5.tex:334-337` ("las pruebas se ejecutan de a una y sin procesos pesados corriendo en paralelo").

- **Ubicación:** `cap6.tex:336-340`.
- **Qué dice vs. qué es correcto:**
  - Dice que «estos estudios se ejecutaron con la máquina compartida con otras corridas, por lo que sus tiempos absolutos están inflados».
  - Contradice `cap5.tex:334-337` («las pruebas se ejecutan de a una y sin procesos pesados corriendo en paralelo»), `cap6.tex:10-11` («en las condiciones descriptas en 5.4») y `ap5.tex:149`. Ahí se dice que las mediciones de calibración se tomaron «de a una».
  - Estos tiempos sustentan factores citados en el cuerpo: «hasta 27 veces» y «al menos 71 veces» (`cap6.tex:288-290`).
  - Hay discrepancias internas, no explicadas: el Split en 4 lotes 6×6 tarda 8,4 s (`cap6.tex:290`, derivable de la Fig. 6.2) y 9,5 s en el Cuadro 6.4 (`cap6.tex:330`). En 3 lotes 7×7 hay otra discrepancia análoga (D).
- **Sugerencia:** anunciar el carácter exploratorio de esos estudios antes de dar los factores. Declarar explícitamente en 5.4 que el estudio de escala no cumple las condiciones de la suite final. Si fue una corrida con otras cargas, decirlo con precisión y presentar los factores como orden de magnitud.

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

#### G6. Referencias cruzadas y citas

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

### H. ToDos

#### H-1 — Mayor — Texto provisorio visible en el PDF

**Verificación:** confirmado en `tesina.tex`: la Dedicatoria (`tesina.tex:140-145`) imprime «Para / Dedicada a / Para mi ...» y los Agradecimientos (`tesina.tex:112-118`) siguen marcados con `% TODO: cambiar esto!`. El Anexo A «Diagramas» (`ap1.tex`, vacío) **ya no se incluye** en `tesina.tex`, por lo que dejó de salir en el PDF; el archivo queda huérfano.

- **Sugerencia:** escribir la dedicatoria o quitar el bloque (ya figura en `Notas/pendientes_cap7.md` §6); revisar los agradecimientos y la forma `Licenciadas en Sistemas` (`tesina.tex:20`); borrar `ap1.tex` si no se va a usar.

#### H-2 — Mayor — «Comparación con el estado del arte» sigue pendiente

Ver E-04. De los cinco ítems de la sección 1 de `Notas/pendientes_cap7.md`, 4 siguen sin hacerse (contraste con MMAS/Dorigo, uso de Lesch et al., comparación de la descomposición con la literatura, ampliar «Trabajos relacionados») y el primero (contraste de HC con Talbi y Hoos y Stützle) está parcial. `Notas/pendientes_cap7.md` §6 dice que se decidió dejarlo pendiente.


#### Marcadores y texto provisorio en los `.tex`


Búsqueda de `TODO`, `ToDo`, `\todo`, `XXX`, `FIXME`, `??`, `pendiente`, `placeholder`, `lorem`, `completar`, `quizás`, `ojo`, etc. No hay `\todo`, `ToDo`, `XXX`, `FIXME`, `lorem` ni `??` (la única secuencia `???` está en `ap1.tex:4`). «pendiente» aparece como sustantivo técnico en `cap4` y `ap8` («ubicaciones pendientes»), no como marcador.

**Texto provisorio que sale en el PDF**

| Ubicación | Contenido | Observación |
|-----------|-----------|-------------|
| `tesina.tex:143` | Dedicatoria: `Para / Dedicada a / Para mi ...` | Placeholder visible |
| `tesina.tex:113-118` | `% TODO: cambiar esto!` sobre Agradecimientos | El texto se imprime; el TODO indica que no es definitivo |
| `tesina.tex:20` | `{Licenciadas en Sistemas} % Cambiar según corresponda (a/o/os/as)` | Verificar la forma final |

**Marcadores en comentarios (no salen en el PDF)**

| Ubicación | Marcador |
|-----------|----------|
| `ap1.tex:3-4` | `TODO: completar` / `afuera???` (archivo huérfano: ya no se incluye en `tesina.tex`) |
| `ap5.tex:12` | `TODO: Tengo que verificar ese porcentaje. No es claro.` (se refiere al 60 %–140 % de `ap5.tex:16-19` y `cap5.tex:240`) |
| `ap5.tex:118-119` | `TODO: ojo acá--no es que no miramos la demora, aclarar eso…` (el texto siguiente, `ap5.tex:120-123`, ya aclara que W^c = 9 hacía actuar adelanto y demora) |
| `ap6.tex:151-152` | `TODO: no estoy segura de esto en general, podemos ver si queda o no. quizas ya es mucho ruido` (al final de «Pseudocódigo») |
| `tesina.tex:101-103` | Comentario con una cita alternativa («me gustó jaja») |

## 4. Tablas de trazabilidad

### 4.1 Tests (tesina ↔ repositorio)

* La tesina nunca cita nombres de test; usa «caso NN[letra]». El «nombre exacto» verificable es el archivo **`tests/opp_v5_2_split/functional/test_case_NN.py`** y **`tests/opp_v5_1_mono/functional/test_case_NN.py`**: existen los 38 en ambos (✓).
* Las letras no existen en el código. Mapeo inferido: letra = posición alfabética del método `test_*` dentro del caso (se cumple en todos los casos con ≥ 2 métodos; la tabla §3 lo muestra).
* Origen de los métodos: casos 01–05, 07–22 y 25–33 son wrappers de `tests/opp_v4/functional/test_case_XX.py` (nótese el cambio de numeración: Split 25–33 ↔ v4 23–31); 06, 23, 24 y 34–38 son tests propios de v5 (reescritos para v5; el 06 reemplazó al migrado el 2026-09-29).
* El mono reutiliza el mismo esquema; sus tests propios son copia de los del Split cambiando la base (`OPPTestCaseMono`). Diferencias: mono **no tiene** el método 24b (comentario en `opp_v5_1_mono/functional/test_case_24.py:21-25`), y en 34b/38 es SCIP, no un pre-chequeo en Python, quien detecta la infactibilidad.

Veredictos: **Coincide** = lo que dice `ap4.tex` coincide con los asserts; **Impreciso/Más débil** = la tesina dice algo distinto o más fuerte que lo que el test comprueba. «Resultado informado vs. evidencia»: se compara el objetivo de `ap7.tex` (Cuadros `tab:res_pares`/`tab:res_infactibles`) con el `v5_obj`/`v5_status` del fixture del Split. No hay evidencia dentro del alcance sobre tiempos ni sobre el mono (**no verificado**); tampoco sobre si cada prueba «pasa» (**no verificado (no se ejecutó)**). El «Archivo» es el del Split; el mono usa el mismo nombre de archivo.

| Caso | Archivo (Split; el mono usa el mismo nombre) | Método real | Qué verifica realmente | Veredicto | Resultado informado vs. evidencia |
|---|---|---|---|---|---|
| 01 | `test_case_01.py` (v4:01) | `test_basic_two_orders_capacity_limit` | status ∈ {optimal, feasible}; cada lote con exactamente 1 picker; cada picker con exactamente 1 lote; arcos activos == grafo esperado (igualdad exacta); balance ≤ 1; sin solapamiento. | Coincide | ap7 obj. 30,0 = fixture 30 ✓; el Split usa espera voluntaria |
| 02 | `test_case_02.py` (v4:02) | `test_two_orders_two_aisles` | status; cada lote con 1 picker; arcos activos == grafo esperado (los dos pasillos completos); balance ≤ 1 (con 2 pickers y 2 lotes equivale a 1 lote por picker); sin solapamiento. No tiene el chequeo explícito «cada picker ejecuta exactamente 1 lote» (sí está en el 03). | Coincide | ap7 obj. 795,0 = fixture 795 ✓ |
| 03 | `test_case_03.py` (v4:03) | `test_two_orders_two_aisles` | Igual que el 02 más `picker_workload[p] == 1` para cada picker. Mismos O1={L2,L3,L4}, O2={L5,L6,L7}, cap 3.0. | Coincide | ap7 obj. 795,0 = fixture 795 ✓ |
| 04 | `test_case_04.py` (v4:04) | `test_two_orders_two_aisles_one_picking_point_per_order` | status; 1 picker por lote; 1 lote por picker; arcos activos == grafo esperado (ambos pasillos completos); balance; sin solapamiento. O1 solo requiere L3 y O2 solo L5. | Impreciso: la tesina dice «las rutas cubren las ubicaciones requeridas»; el test exige igualdad exacta con la ruta esperada | ap7 obj. 795,0 = fixture 795 ✓ |
| 05 | `test_case_05.py` (v4:05) | `test_two_orders_two_aisles_using_one_aisle` | status; 1 picker por lote; 1 lote por picker; arcos == un único pasillo L1-L2-L3-L4-L8 (O1={L2,L3}, O2={L2,L4}, comparten L2); balance; sin solapamiento. | Coincide | ap7 obj. 846,0 = fixture 846 ✓ |
| 06a | `test_case_06.py` (propio) | `test_every_route_is_optimal_when_all_arrive_in_time` | `test_every_route_is_optimal_when_all_arrive_in_time` (due 15): status; `assert_routes_cover_requirements` (1 arco sale del depósito, 1 llega al final, requeridas ⊆ visitadas; NO verifica que los arcos formen un camino); `c_b == 15` en cada lote; objetivo == 30. | Coincide | ap7 obj. 30,0 = fixture 30 ✓; el Split usa espera voluntaria |
| 06b | `test_case_06.py` (propio) | `test_shorter_route_is_chosen_when_the_longer_one_is_late` | `test_shorter_route_is_chosen_when_the_longer_one_is_late` (due 10): arcos de cada lote == {(L1,L4),(L4,L5)}; `c_b == 10`; objetivo == 20. | Coincide | ap7 obj. 20,0 = fixture 20 ✓; el Split usa espera voluntaria |
| 07 | `test_case_07.py` (v4:07) | `test_repeated_picking_locations` | `assertIn(status, ('infeasible',))`. | Coincide | ap7: figura como infactible ✓; fixture `infeasible` |
| 08 | `test_case_08.py` (v4:08) | `test_repeated_picking_locations_2` | status; 1 picker por lote; arcos == L1-L2-L4-L3-LC-L5; balance; sin solapamiento. Usa `scenario_05_v4` (docstring: 6 vértices, 3 pedidos, 2 pickers) y no el `scenario_04_v4` del 07; además suma el pedido O3 (cap 15) y asigna O2 al lote (en el 07, O2 no está en B1). La arista esperada L3→LC se carga con la distancia L3–L4 (copy-paste, línea 137). | Impreciso: la tesina dice «la instancia del caso 07 con una ubicación adicional»; el 08 usa otro escenario y cambia también los pedidos | ap7 obj. 69,0 = fixture 69 ✓ |
| 09 | `test_case_09.py` (v4:09) | `test_two_orders_two_locations` | status; 1 picker por lote; arcos == L1-L3-L2-L4; balance; sin solapamiento. | Coincide | ap7 obj. 1.833,0 = fixture 1833 ✓ |
| 10 | `test_case_10.py` (v4:10) | `test_two_orders_two_locations_two_missions` | status; 1 picker por lote; arcos == L1-L2-L4 y L1-L3-L4; balance; sin solapamiento. | Coincide | ap7 obj. 1.509,0 = fixture 1509 ✓ |
| 11 | `test_case_11.py` (v4:11) | `test_four_orders_two_locations_two_missions` | status; arcos == L1-L3-L2-L5 y L1-L3-L4-L5; balance; sin solapamiento (la tesina solo menciona «rutas esperadas»). | Coincide | ap7 obj. 3.666,0 = fixture 3666 ✓ |
| 12 | `test_case_12.py` (v4:12) | — | Ningún método activo: el único está comentado (`# def test_twelve_orders...`) con la nota «El modelo ya no evalúa que las órdenes entren en el carro, el test ya no tiene sentido». | Coincide (0 pruebas; igual cuenta como uno de los «38 casos») | n/a (sin pruebas activas) |
| 13 | `test_case_13.py` (v4:13) | `test_two_periods_two_orders_per_vehicle` | status; balance ≤ 1 (solo si \|P\|>1 y \|B\|>1); sin solapamiento. No verifica rutas ni objetivo. | Coincide | ap7 obj. 3.087,0 = fixture 3087 ✓ |
| 14 | `test_case_14.py` (v4:14) | `test_one_period_two_orders_per_vehicle` | Código idéntico al 13; la única diferencia es la función de escenario (`one_period` usa claves G1..G6 en `x` en lugar de B1..B6) y `x` no se usa. Instancia efectivamente idéntica a la del 13 (los nombres `two_periods`/`one_period` no reflejan ninguna diferencia). | Coincide (caso duplicado) | ap7 obj. 3.087,0 = fixture 3087 ✓ |
| 15 | `test_case_15.py` (v4:15) | `test_3_orders_1_mission_1_picker` | Solo `status ∈ {optimal, feasible}`. | Coincide | ap7 obj. 889,0 = fixture 889 ✓ |
| 16 | `test_case_16.py` (v4:16) | `test_6_orders_3_missions_2_pickers` | Solo `status ∈ {optimal, feasible}`. | Coincide | ap7 obj. 1.338,0 = fixture 1338 ✓ |
| 17 | `test_case_17.py` (v4:17) | `test_branched_single_mission_route` | status; 1 picker por lote; arcos == ruta esperada; balance; sin solapamiento. | Coincide | ap7 obj. 2.512,5 = fixture 2512 ✓ |
| 18 | `test_case_18.py` (v4:18) | `test_detour_single_mission_route` | Solo `status ∈ {optimal, feasible}` (5 pedidos; el «desvío» no se verifica). | Coincide | ap7 obj. 4.518,0 = fixture 4518 ✓ |
| 19a | `test_case_19.py` (v4:19) | `test_longer_single_mission_duplicate_location` | `test_longer_single_mission_duplicate_location`: solo status. | Coincide | ap7 obj. 25,0 = fixture 25 ✓; el Split usa espera voluntaria |
| 19b | `test_case_19.py` (v4:19) | `test_longer_single_mission_penalties` | `test_longer_single_mission_penalties`: con due 0 (w1=0, w2=1, γ=0, δ=1) Σ`ta_n` > 1e-6; con due 100, Σ`ta_n` ≤ 1e-6. | Coincide | 2 instancias en el test; fixture obj. 120 / 0; ap7 informa 0,0 = la **última** instancia ✓ |
| 19c | `test_case_19.py` (v4:19) | `test_longer_single_mission_route` | `test_longer_single_mission_route`: `assert_route_covers_orders`: reconstruye la ruta y exige un camino simple depósito→final (sin ramas, ciclos ni desconexión) que visita L2…L7. | Coincide (único caso que verifica «camino válido» completo) | ap7 obj. 25,0 = fixture 25 ✓; el Split usa espera voluntaria |
| 20 | `test_case_20.py` (v4:20) | `test_grid_multi_location_orders` | status; para cada lote, ubicaciones requeridas ⊆ nodos de los arcos activos (no verifica que sea un camino). El segundo método del archivo v4 (`..._bigger_than_cart_infeasible`) está comentado. | Coincide | ap7 obj. 2.620,0 = fixture 2620 ✓ |
| 21 | `test_case_21.py` (v4:21) | `test_bridge_disconnected_required_location` | `assertEqual(status, 'infeasible')`. | Coincide | ap7: figura como infactible ✓; fixture `infeasible` |
| 22a | `test_case_22.py` (v4:22) | `test_earliness_when_batch_finishes_before_due_date` | `test_earliness_...`: `ea > 0` y `ta ≈ 0` (due 10000). | Coincide (la tesina omite que exige adelanto > 0) | ap7 obj. 10.126,0 = fixture 1.013e+04 ✓ |
| 22b | `test_case_22.py` (v4:22) | `test_tardiness_when_batch_finishes_after_due_date` | `test_tardiness_...`: `ta > 0` y `ea ≈ 0` (due 0). | Coincide | ap7 obj. 154,0 = fixture 154 ✓ |
| 23a | `test_case_23.py` (propio) | `test_longer_route_is_assigned_to_the_faster_picker` | `test_longer_route_is_assigned_to_the_faster_picker`: B2→P_fast y B1→P_slow; sin solapamiento. Test propio de v5. | Coincide | ap7 obj. 16,0 = fixture 16 ✓ |
| 23b | `test_case_23.py` (propio) | `test_routes_are_exported_and_used_by_scheduling` | `test_routes_are_exported_and_used_by_scheduling`: rutas cubren requeridas; `r_B1 = 5`, `r_B2 = 14`; todos los lotes asignados; sin solapamiento (que usa los `r_b` de la Etapa 1). Test propio de v5. | Coincide (que la Etapa 2 «usa» los tiempos se infiere solo del chequeo de solapamiento) | ap7 obj. 16,0 = fixture 16 ✓ |
| 24a | `test_case_24.py` (propio) | `test_cold_chain_filters_out_the_slow_picker` | `test_cold_chain_filters_out_the_slow_picker`: asignación == {B1: P_fast}; t_ejec(P_fast) ≤ T_cold < t_ejec(P_slow). | Coincide | ap7 obj. 9,0 = fixture 9 ✓ |
| 24b | `test_case_24.py` (propio) | `test_preflight_detects_when_no_picker_is_eligible` | `test_preflight_detects_when_no_picker_is_eligible`: ejecuta solo la Etapa 1 (`run_pipeline(solve_stage2=False)`) y afirma `eligible_pairs(...) == set()`. `eligible_pairs` es un método estático del propio caso de test que **replica** PB_elig; el chequeo de producción (`batches_without_eligible_picker`) no se invoca porque `run_pipeline` retorna antes. Solo existe en Split (en mono hay un comentario que explica por qué no se porta). | Más débil: la tesina dice que verifica «el chequeo previo a la Etapa 2»; verifica una réplica dentro del test | Fixture: `infeasible` (solo Etapa 1) ✓; solo Split; no figura en ap7 ✓ |
| 25a | `test_case_25.py` (v4:23) | `test_grid_batch_infeasible_order_size` | `test_grid_batch_infeasible_order_size`: `status == 'infeasible'` (un lote con 3+2+2 = 7 > C_v = 6). | Coincide | ap7: figura como infactible ✓; fixture `infeasible` |
| 25b | `test_case_25.py` (v4:23) | `test_grid_duplicate_location_within_batch` | `test_grid_duplicate_location_within_batch`: solo status. | Coincide | ap7 obj. 2.434,0 = fixture 2434 ✓ |
| 25c | `test_case_25.py` (v4:23) | `test_grid_multi_location_orders_with_capacities` | `test_grid_multi_location_orders_with_capacities`: status; cada lote visita sus ubicaciones requeridas. | Coincide | ap7 obj. 2.620,0 = fixture 2620 ✓ |
| 25d | `test_case_25.py` (v4:23) | `test_grid_order_size_bigger_than_cart_infeasible` | `test_grid_order_size_bigger_than_cart_infeasible`: `infeasible` (cap_n = 3 → lotes de 9 > 6). | Coincide | ap7: figura como infactible ✓; fixture `infeasible` |
| 25e | `test_case_25.py` (v4:23) | `test_grid_penalties_due_date` | `test_grid_penalties_due_date`: status feasible con due 0 y con due 100 (w1=0, w2=1, γ=0, δ=1); no verifica `ta`/`ea`. | Coincide (la tesina solo afirma «tiene solución») | 2 instancias en el test; fixture obj. 276 / 0; ap7 informa 0,0 = la **última** instancia ✓ |
| 25f | `test_case_25.py` (v4:23) | `test_grid_penalties_order_size_equal_to_cart` | `test_grid_penalties_order_size_equal_to_cart`: status feasible con cap_n = 1.0 (carga 3) y con cap_n = 2.0 (3×2 = 6 = C_v). | Coincide (solo la 2.ª instancia es «igual a la capacidad») | 2 instancias en el test; fixture obj. 102 / 156; ap7 informa 156,0 = la **última** instancia ✓ |
| 25g | `test_case_25.py` (v4:23) | `test_grid_shared_locations_across_batches` | `test_grid_shared_locations_across_batches`: solo status. | Coincide | ap7 obj. 3.224,0 = fixture 3224 ✓ |
| 26a | `test_case_26.py` (v4:24) | `test_bridge_disconnected_required_location_with_capacities` | `test_bridge_disconnected_required_location_with_capacities`: `infeasible`. | Coincide | ap7: figura como infactible ✓; fixture `infeasible` |
| 26b | `test_case_26.py` (v4:24) | `test_bridge_earliness_order_size` | `test_bridge_earliness_order_size`: feasible con cap_n 1.0 y 2.0 (due 5000). | Coincide | 2 instancias en el test; fixture obj. 2.072e+04 / 2.09e+04; ap7 informa 20.899,0 = la **última** instancia ✓; el Split usa espera voluntaria |
| 26c | `test_case_26.py` (v4:24) | `test_bridge_shared_locations_across_batches` | `test_bridge_shared_locations_across_batches`: solo status. | Coincide | ap7 obj. 2.463,0 = fixture 2463 ✓ |
| 26d | `test_case_26.py` (v4:24) | `test_bridge_tardiness_beta_picking` | `test_bridge_tardiness_beta_picking`: feasible con due 10 y T_pick 0.5 y 2.0. | Coincide | 2 instancias en el test; fixture obj. 5325 / 1.348e+04; ap7 informa 13.479,0 = la **última** instancia ✓ |
| 27 | `test_case_27.py` (v4:25) | `test_basic_two_orders_with_different_weights` | `test_basic_two_orders_with_different_weights`: solo status. | Coincide | ap7 obj. 58,0 ≠ fixture 58.0500 (redondeo en ap7) |
| 28 | `test_case_28.py` (v4:26) | `test_due_dates_tight_vs_relaxed` | `test_due_dates_tight_vs_relaxed`: con due 1.0 acepta `status ∈ {optimal, feasible, infeasible}`; con due 1000 exige feasible. | Más débil: la tesina dice «ambas tienen solución»; el test tolera infactible en la ajustada (los datos sí muestran ambas óptimas) | 2 instancias en el test; fixture obj. 20 / 0; ap7 informa 0,0 = la **última** instancia ✓ |
| 29 | `test_case_29.py` (v4:27) | `test_one_empty_batch_allowed` | `test_one_empty_batch_allowed`: solo status. | Coincide | ap7 obj. 327,0 = fixture 327 ✓; el Split usa espera voluntaria |
| 30a | `test_case_30.py` (v4:28) | `test_fractional_and_zero_capacities_feasible` | `test_fractional_and_zero_capacities_feasible` (C_v = 6; 4 pedidos, 12 lotes, 10 vacíos): status feasible. | Coincide (pero en la corrida capturada el Split **no termina**: timeout) | Split: timeout (fixture `v5_status`); tesina cap6: no termina en ninguno de los dos ✓. No figura en ap7 ✓ |
| 30b | `test_case_30.py` (v4:28) | `test_fractional_and_zero_capacities_infeasible` | `test_fractional_and_zero_capacities_infeasible` (C_v = 5): `infeasible`. | Coincide | ap7: figura como infactible ✓; fixture `infeasible` |
| 31a | `test_case_31.py` (v4:29) | `test_order_assigned_to_multiple_batches_infeasible` | `test_order_assigned_to_multiple_batches_infeasible`: `infeasible`. | Coincide | ap7: figura como infactible ✓; fixture `infeasible` |
| 31b | `test_case_31.py` (v4:29) | `test_order_assigned_to_single_batch_feasible` | `test_order_assigned_to_single_batch_feasible`: solo status. | Coincide | ap7 obj. 100,0 = fixture 100 ✓; el Split usa espera voluntaria |
| 32 | `test_case_32.py` (v4:30) | `test_single_order_exceeds_vehicle` | `test_single_order_exceeds_vehicle` (cap 25 > C_v 10): `infeasible`. | Coincide | ap7: figura como infactible ✓; fixture `infeasible` |
| 33a | `test_case_33.py` (v4:31) | `test_service_time_mixed` | `test_service_time_mixed` (S_i = 0.5 + (i mod 3)·0.5): `_solve` exige feasible. | Coincide | ap7 obj. 106,5 = fixture 106.5 ✓ |
| 33b | `test_case_33.py` (v4:31) | `test_service_time_one` | `test_service_time_one` (S_i = 1): feasible. | Coincide | ap7 obj. 81,0 = fixture 81 ✓ |
| 33c | `test_case_33.py` (v4:31) | `test_service_time_zero` | `test_service_time_zero` (S_i = 0): feasible. | Coincide | ap7 obj. 30,0 = fixture 30 ✓; el Split usa espera voluntaria |
| 34a | `test_case_34.py` (propio) | `test_completion_time_matches_the_documented_formula_exactly` | `test_completion_time_matches_the_documented_formula_exactly`: `r_B1 = 5`, `r_B2 = 14`; asignación {B1: P_slow, B2: P_fast}; finalización de P_slow/B1 = F_b + 5/1 y de P_fast/B2 = F_b + 14/2 (F_b = 2); sin solapamiento. | Impreciso: la tesina habla de «tiempo de ejecución»; el test mide el instante de finalización del primer lote de cada picker | ap7 obj. 16,0 = fixture 16 ✓ |
| 34b | `test_case_34.py` (propio) | `test_no_eligible_picker_returns_infeasible_gracefully` | `test_no_eligible_picker_returns_infeasible_gracefully`: `eligible_pairs` (réplica en el test) == ∅ y, además, `run_pipeline` devuelve `status == 'infeasible'` y `values == {}` (en Split lo produce el pre-chequeo de producción; en mono, SCIP). | Coincide | ap7: figura como infactible ✓; fixture `infeasible` |
| 34c | `test_case_34.py` (propio) | `test_picker_exactly_at_the_cold_chain_limit_is_still_eligible` | `test_picker_exactly_at_the_cold_chain_limit_is_still_eligible`: (P_fast, B1) ∈ `eligible_pairs` (réplica) y asignación == {B1: P_fast} con T_cold == t_ejec exacto. | Coincide | ap7 obj. 9,0 = fixture 9 ✓ |
| 35a | `test_case_35.py` (propio) | `test_cold_limit_applies_to_each_batch_not_the_whole_shift` | `test_cold_limit_applies_to_each_batch_not_the_whole_shift`: P_fast ejecuta ambos lotes; finalizaciones 9 y 18; 18 > T_cold; objetivo 27. | Coincide | ap7 obj. 27,0 = fixture 27 ✓ |
| 35b | `test_case_35.py` (propio) | `test_cold_limit_tolerance_keeps_a_picker_within_rounding_noise` | `test_cold_limit_tolerance_keeps_a_picker_within_rounding_noise`: T_cold = 9 − 5e-10; (P_fast, B1) elegible y asignado. | Coincide | ap7 obj. 9,0 = fixture 9 ✓ |
| 35c | `test_case_35.py` (propio) | `test_fixed_time_counts_toward_the_cold_limit` | `test_fixed_time_counts_toward_the_cold_limit`: 14/2 ≤ T_cold pero 2+7 > T_cold; `status == 'infeasible'` y `values == {}`. | Coincide | ap7: figura como infactible ✓; fixture `infeasible` |
| 36a | `test_case_36.py` (propio) | `test_batches_are_split_when_fast_picker_is_only_twice_as_fast` | `test_batches_are_split_when_fast_picker_is_only_twice_as_fast` (V=2): los dos pickers se usan; finalizaciones 9 y 16; objetivo 25; sin solapamiento. | Coincide | ap7 obj. 25,0 = fixture 25 ✓ |
| 36b | `test_case_36.py` (propio) | `test_fast_picker_takes_both_batches_when_four_times_faster` | `test_fast_picker_takes_both_batches_when_four_times_faster` (V=4): ambos en P_fast; 5,5 y 11; objetivo 16,5. | Coincide | ap7 obj. 16,5 = fixture 16.5 ✓ |
| 36c | `test_case_36.py` (propio) | `test_non_positive_speed_is_rejected_before_solving` | `test_non_positive_speed_is_rejected_before_solving`: para V = 0 y V = −1, `run_pipeline` lanza `AssertionError` que nombra a P_slow. Ese `AssertionError` lo emite `assertFalse(invalid_speeds(...))` dentro del helper `run_pipeline` del propio test (usa `invalid_speeds` de producción); no es el pipeline de producción el que rechaza. | Más débil: la tesina dice «se rechazan antes de resolver» sin aclarar que el rechazo está en el helper del test | No capturado en el fixture (rechazo previo) ✓; no figura en ap7 ✓ |
| 36d | `test_case_36.py` (propio) | `test_tardiness_uses_the_speed_scaled_route_time` | `test_tardiness_uses_the_speed_scaled_route_time`: `c_B1 = 30`, `ta_O1 = 10`, `ea_O1 = 0`, objetivo 310. | Coincide | ap7 obj. 310,0 = fixture 310 ✓ |
| 37a | `test_case_37.py` (propio) | `test_batch_is_delayed_while_early_orders_outweigh_completion_weight` | `test_batch_is_delayed_while_early_orders_outweigh_completion_weight` (W_c = 1 < 3): `c_B1 = 20`, `ea = ta = 0`, objetivo 20. | Coincide | Excluido del fixture de heurísticas (`excluded`) ✓; no figura en ap7 ✓. Split obj. no disponible en el fixture |
| 37b | `test_case_37.py` (propio) | `test_batch_is_not_delayed_when_completion_weight_dominates` | `test_batch_is_not_delayed_when_completion_weight_dominates` (W_c = 5 > 3): `c_B1 = 9`, `ea = 11` por pedido, objetivo 78. | Coincide | ap7 obj. 78,0 = fixture 78 ✓ |
| 38 | `test_case_38.py` (propio) | `test_route_that_must_revisit_a_vertex_is_infeasible` | `test_route_that_must_revisit_a_vertex_is_infeasible`: en Split, la Etapa 1 (`solve_stage1_decomposed`) devuelve `infeasible`; en mono, `run_pipeline` devuelve `infeasible` y `values == {}`. | Coincide | ap7: figura como infactible ✓; fixture `infeasible` |
**Cantidades de la tabla:** 65 filas = 64 pruebas activas + caso 12 (sin pruebas). Casos con ≥ 2 pruebas: 06, 19, 22, 23, 24, 25, 26, 30, 31, 33, 34, 35, 36, 37 (14 casos).

#### Tests y herramientas del repositorio que la tesina no menciona

**Importantes (debería haber, al menos una frase o una tabla en un anexo):**

| Grupo / archivo | Qué es | Por qué importa |
|---|---|---|
| `tests/opp_v4/functional/` (31 archivos, 46 pruebas) | Suite fuente de 45 de las 64 pruebas del Split y 45 de las 63 del mono (los wrappers solo cambian el modelo). | Explica el origen de los casos y las adaptaciones (`V_p = 1`, `T_cold = 10⁹`, Etapa 1 descompuesta por lote, `assert_no_time_overlap` reescrito). Ver C1. |
| `tests/infra/factories/migrated_case.py`, `migrated_mono_case.py` | Adaptadores v4 → Split/mono. | Idem. El docstring de `migrated_case.py` documenta el bug de la tautología en el chequeo de solapamiento (hallado 2026-09-09): afecta cuánto confiar en resultados anteriores de 11 y 13. |
| `tests/opp_hc_4/functional/`, `tests/opp_aco_4/functional/` (40 y 38 archivos) | Suites funcionales de las heurísticas de la tesina: 24 wrappers de tests de `opp_hc_2`/`opp_aco_2`, **tests propios** (HC: 20 métodos; ACO: 18) y el test de equivalencia con el Split. Propios destacados: `test_case_cold_chain_{boundary,eligibility,infeasible,per_batch_not_shift,tolerance}`, `test_case_invalid_speed_rejected` (cero y negativo), `test_case_forced_revisit_is_infeasible`, `test_case_pre_check_uses_tightened_route` (el «nearest-neighbor trap» no se informa como infactible), `test_case_speed_sequencing_tradeoff`, `test_case_mixed_eligibility`, y solo ACO: `test_case_soft_cold_chain_protects_siblings`. | La tesina solo cuenta que HC/ACO resuelven las instancias capturadas del Split (`cap5.tex:117-127`); no describe las pruebas propias de las heurísticas, que son las que respaldan afirmaciones de cap4 (cadena de frío penalizada, pre-chequeo exacto, velocidades). |
| `tests/opp_hc_4/functional/test_case_v5_equivalence.py`, `tests/opp_aco_4/…` y `tests/infra/factories/v5_equivalence.py` | Genera un test por instancia del fixture (`test_v5eq__<método>[__k]`); exige coincidencia de estado; define `comparability()` y `v5_waiting_batches()` (la regla del Cuadro `tab:comparabilidad`). | Es la implementación de las reglas de comparabilidad de cap5; convendría citarla. |
| `tests/shared_scenarios/functional/export_v5_equivalence_scenarios.py` y `v5_equivalence_scenarios.json` | Exportador y fixture (68 instancias: 55 óptimas, 12 infactibles, 1 timeout; `excluded`: 37a; `not_captured`: 36c). | Es la «captura» de `cap5.tex:119-121`; los números 68/70/12/55/45 salen de aquí. |
| `tests/opp_hc_4/stress/`, `tests/opp_aco_4/stress/` (19 c/u) y `tests/shared_scenarios/stress/stress_scenarios_v5{,_designed}.py` | Estrés de las heurísticas y generadores (`migrated_stress_scenario`, `realistic_crew_scenario`). Los tests de HC fijan `Max_it = 200`, `Max_imp = 60`, `Max_time = 30 s` por defecto (coincide con `ap8.tex:275,292`). | Ya descriptos en cap5; solo falta la referencia al código. |
| `verification/compare_v5.py` | Compara Split vs mono desde CSV/JSON guardados (estado, objetivo, solución; `--verify-split-stress` verifica las soluciones de estrés del Split contra el mono). | Es el control de `cap5.tex:529-536`; la tesina no nombra el script. |
| `verification/run_compliance.py`, `solution_store.py` | CLI del verificador (`--resume`, `--time-limit 300`, veredictos `compliant/violations/skipped/error`) y formato JSON de la solución. | Reproducibilidad de `ap6`/cap6. |

**Detalle de implementación (puede omitirse):** `tests/opp_v1`, `opp_v2`, `opp_v2_zpl`, `opp_v3` (modelos históricos, 16+19+1+25 archivos funcionales y 7+34 de estrés); `tests/opp_hc_1…3` y `opp_aco_1…3`; `tests/opp_v4/stress` (8) y `tests/opp_v4/diagnostics/test_case_single_batch_infeasibility_check.py` (diagnóstico aislado de una instancia de estrés heredada); `tests/infra/execution/{config,runner}.py` (solo parcialmente descriptos en `cap5.tex:310-318`: un proceso por prueba, en serie, tope externo, árbol de procesos matado — todo ✓ con el código); `tests/run_suite.py`; `tests/README.md` (workflow para v1/v2; no menciona v5); `tests/infra/zimpl/*`; `.github/workflows/ci.yml` (collect-only de las suites exactas + HC/ACO funcionales + humo de estrés) y `nightly.yml` (estrés HC/ACO, legacy, `exact-zimpl` con las funcionales de v4/mono/Split). La tesina no menciona CI; no es necesario, pero una línea en el anexo de reproducibilidad sería útil.

#### Discrepancias en cantidades (tesina vs. evidencia)

| Cantidad | Tesina | Evidencia | Estado |
|---|---|---|---|
| Casos funcionales | 38 (`resumen`, `abstract`, `cap5:56`, `cap7:437`) | 38 archivos, pero el 12 no tiene métodos activos → 37 | Menor (C7) |
| Pruebas Split / mono | 64 / 63 (`cap5:63`, `cap7:437`) | 64 / 63 (AST) | ✓ |
| Pruebas Split/mono según `nightly.yml` | — | Comentario: 63 / 62 (y «opp_v4: 46», que sí coincide con el AST) | Comentario desactualizado (el `test_case_06` pasó de 1 a 2 pruebas el 2026-09-29); no afecta la tesina |
| Instancias del Split | 70 (`cap5:122`) | fixture 68 + 36c + 37a = 70; 64 pruebas + 6 pruebas de 2 instancias = 70 | ✓ |
| Instancias que resuelven HC/ACO | 68 | fixture 68 | ✓ |
| Infactibles / sin solución | 12 (`cap6:380-390`) | fixture 12 | ✓ (11 pares + 24b, solo Split) |
| Válidas por heurística (funcionales) | 56 | 55 óptimas + 30a (timeout en el Split) | ✓ |
| Soluciones verificadas | 150 = 56+19+56+19 | aritmética ✓; el resultado de la verificación en sí: no verificado | — |
| Comparables en estado / objetivo | 67 / 45 | 55+12 / 55−10 (espera voluntaria) | ✓ |
| Con espera voluntaria | 10 | fixture: 10 instancias con `v5_waiting_batches` | ✓ |
| Pares mono/Split | 60 = 49 + 11 (`cap5:559-564`, `cap6:23`) | 64 − {24b, 30a, 36c, 37a} = 60 **pruebas**; en instancias serían 66 | Unidad ambigua (C4) |
| Tope por prueba | 25 min funcional / 40 estrés | `config.py`: 25 / 25 por defecto; 40 solo con `.env` | Menor (C14) |
| Escenarios de estrés | 19, tamaños de `cap5` tabla | 19 archivos; (lotes, pickers, pedidos, grilla) coinciden con las llamadas | ✓ |
| «Se verificó que los datos son idénticos en los 19» (`cap5:555`) | verificación | Las 19 llamadas a los generadores son textualmente idénticas en los 4 métodos; no hay un test que compare los datos | Parcial; evidencia de la verificación efectiva: no verificado |

### 4.2 Experimentos (tesina ↔ script ↔ resultados)

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

### 4.3 Números de tablas y figuras (valor en la tesina ↔ valor recalculado)

Los subapartados 4.3.1 a 4.3.7 corresponden a los 3.1 a 3.7 del informe D parcial. Las filas marcadas ✗ o ~ remiten al hallazgo correspondiente (D-15 corrige las dos filas de tiempos funcionales después del cambio reciente de `cap6`).

#### 4.3.1 Monolítico contra Split, funcionales (`cap6` §6.1.1–6.1.2, `ap7`)

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

#### 4.3.2 Escala y 40 minutos (`cap6` §6.1.3)

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

#### 4.3.3 Estrés: Split, HC, ACO (`cap6` §6.1.4 y §6.3; `ap7`)

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

#### 4.3.4 HC y ACO frente al Split, funcionales (`cap5` §5.3, `cap6` §6.3)

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

#### 4.3.5 Verificación (`cap6` §6.2)

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

#### 4.3.6 A igual tiempo (`cap6` §6.3.6)

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

#### 4.3.7 Semillas y presupuesto (consultados en `ap8`)

| Valor | Tesina | Recalculado | OK |
|---|---|---|---|
| Variación entre semillas: mediana HC / ACO | 0,02 % / 0,005 % (`cap6.tex:942`) | 0,0155 % / 0,0046 % | ✓ |
| HC: máximos | 0,44 % (03); 0,12 % (17); resto < 0,1 % | 0,444; 0,117; 15: 0,0985 | ✓ |
| ACO: máximo y resto | 0,053 % (11); resto ≤ 0,016 % | 0,0530; 05: 0,0154 | ✓ |
| ACO: brecha contra el Split entre 0 y 0,072 % | `ap8.tex` (sección de semillas de ACO, líneas ~404-428) | 0 a 0,0722 % | ✓ |
| HC con 200/60: 82 de 88 por estancamiento | `ap8.tex` (sección de presupuesto, líneas ~266-288) | 82 `Max_imp` + 6 `Max_it` = 88 | ✓ |
| HC: mejoras con presupuestos mayores | hasta 0,59 % (03); ≤ 0,11 % | mínimo delta −0,5877 %; −0,1063 % | ✓ |
| HC: 2 escenarios sin solución con una semilla | 09 y 11 | 09 semilla 4; 11 semilla 5 | ✓ (D-3) |

### 4.4 Afirmaciones técnicas contrastadas con el código

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

### 4.5 Experimentos o resultados del repositorio no reportados

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

## 5. Estado de los ToDos

Los ítems que ya estaban resueltos se quitaron antes de esta consolidación. Las guías de trabajo de los capítulos se borraron el 16/11; lo que seguía abierto pasó a `Notas/pendientes_cap7.md` §6.

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

**Pendientes que no figuran en `Notas/pendientes_cap7.md`:** la decisión sobre la versión del código de las heurísticas (D-2), la convergencia de HC en 03/17 vs 03/18 (F8), los dos ítems de `cap7` sobre qué limita a la Etapa 1 y los depósitos con estanterías, y el rótulo `Licenciadas en Sistemas` de `tesina.tex:20`.

## 6. Qué no se pudo verificar y por qué

- **Ejecución de tests y experimentos:** por indicación, no se ejecutó nada. Los resultados de pasa/falla de cada prueba, los tiempos del monolítico en las pruebas funcionales y todo lo que dependa de re-ejecutar (por ejemplo, el funcional de HC, 40 de 45, y el de ACO con el código final) quedan como «no verificado (no se ejecutó)». D-2 se apoya en fechas de commit y en la comparación entre CSV.
- **Compilación de la tesina:** no se recompiló. `tesina.log` y `tesina.pdf` son anteriores a las últimas modificaciones; no se pudo comprobar la numeración visible ni la ausencia de `??` en el PDF.
- **Código solo parcialmente leído:** `route_construction.py` (se leyeron las funciones clave), `analysis/*.py` (cabeceras), `meta.md` líneas 560–903 por palabras clave, `docs/thesis/*.tex`, modelos legados.
- **Versiones de software y hardware** (`cap5.tex:30-44`): ZIMPL 3.6.2, SCIP 9.2.3 y SoPlex 7.1.5 no figuran en `requirements.txt` ni en CI; el hardware solo aparece en `meta.md`.
- **«248 soluciones» con y sin recorte** (`ap6.tex`) y **«9 soluciones de estrés del Split verificadas»** (`cap6.tex:395`): apoyadas solo en `meta.md:646` y `meta.md:693`; no hay artefacto en `results/`.
- **Validación del verificador con cuatro errores** (`ap6.tex:78-81`): sin rastro en el repositorio (C5).
- **Bibliografía:** Croes (1958), Baker y Scudder (1990) y Kanet y Sridharan (2000) no están en `zpaper/`; de los libros largos solo se consultaron las páginas citadas; del resto de las fuentes se contrastó una selección (ver la trazabilidad cita ↔ fuente). Flipkart y `Marco_de_TTL_monografia.pdf` no se evaluaron.
- **`entorno.tex` y `Referencias/tesina.bib`:** no se leyeron por completo; reglas globales de estilo (§1, §3, §8 de la guía) y definición de siglas quedan sin verificar.
- **Hallazgos Menores:** se verificaron por muestreo (A7, A9, A10, A12, C1, C12, D-7, D-8, D-11, D-12, F11, F12, F20, F22, G3, G4 y los de `cap6`/`ap8` citados); el resto se toma tal como lo reportó el revisor correspondiente.

## Anexo. Hallazgos descartados, reclasificados o fusionados durante la verificación

| Informe parcial | Resultado | Motivo |
|---|---|---|
| A3 (Mayor) — «las corridas con suspensión se reemplazaron» no vale para la fila 01 de ACO | **Descartado** | La fila 988.252 con suspensión de 4 min ya no está en los resultados usados: ACO estrés se volvió a correr el 2026-11-10 (`8779dbc`) y el 01 da 909.168 en 1.892 s, valor que usa la tesina. Lo que queda desactualizado es un comentario de `analysis/config.py` y el CSV de `results/comparability` (D-6). `cap6.tex:945` declara correctamente que la única suspensión en las corridas usadas es el escenario 10 del Split. |
| A5 (Mayor) y B3 | Fusionados en D-2 | Mismo problema (versión del código y procedencia de los CSV). |
| A1 (Mayor) y F11 | Fusionados; Menor | Con los valores de la tesina K supera a λ solo donde la cadena de frío no está activa. |
| A2, A4 (Mayor) | Menor | La frase de `ap8` es literalmente cierta; la generalización de `cap5` no afecta a los tiempos (todos son 40 min). |
| C3, C4, C6 (Mayor) | Menor | Trazabilidad por letras, unidad prueba/instancia y test débil, respectivamente; ninguno hace falsa una afirmación de la tesina. |
| D-3 y F3 (Mayor) | Fusionados; Menor | El resumen, el abstract y `cap7` ya acotan la afirmación; solo falta en `cap6`. |
| D-6 (Mayor) | Menor | Es un CSV derivado del repositorio, no una cifra de la tesina. |
| D-5 (Mayor) y F5 (Crítico) | Fusionados; Crítico | La oración es falsa respecto del propio cuadro. |
| F4 (Mayor) | Fusionado en E-02 | Sí hay pruebas que verifican la reducción (31 migradas de `opp_v4`); lo que falta es decirlo. |
| A13 | Fusionado en E-01 | Mismo hallazgo. |
| D-11 y F7, C4 y F21, C7 y F22, F11 y A1 | Fusionados | Duplicados. |
| A16 y el Anexo A «Diagramas» vacío | **Resuelto** | `ap1.tex` ya no se incluye en `tesina.tex`. |
| A11, A15, B2, B6, C10, F2, F19, erratas de estilo, guías de trabajo | **Ya resueltos** | Se quitaron antes de la consolidación (ver el alcance). |
