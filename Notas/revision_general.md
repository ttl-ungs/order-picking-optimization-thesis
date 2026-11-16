# Revisión general de la tesina (sobre el PR 8, `cap7-limitaciones`)

Armada el 16/11/2026 sobre el commit `67ee851` de la rama `cap7-limitaciones`, contrastando el texto con la rama `integration/four-models` (commit `ddc51fe`) del repositorio de implementación, `linear-picking-routing`.

## Cómo leer este documento

Hay una sección por capítulo, más una para las páginas preliminares, una para los anexos y una para lo que atraviesa todo el documento. Cada hallazgo tiene un identificador (por ejemplo `C6-2`), un tipo y cinco partes: dónde está, qué dice el texto, qué muestran los datos o el código, por qué importa y qué se propone.

Los tipos son tres:

- **Fondo**: afecta lo que la tesina afirma.
- **Coherencia**: el texto no coincide con otra parte de la tesina o con el estado actual del repositorio.
- **Forma**: redacción, terminología o presentación.

Los casos funcionales se nombran como en la tesina (por ejemplo, 36c) y los escenarios de estrés por su número (01 a 19).

## Alcance de la revisión

- Leídos completos: `tesina.tex`, resumen, abstract y capítulos 1 a 7.
- Anexos: solo las partes a las que remiten los capítulos (validez de `M_seq`, presupuesto de HC, variación entre semillas). No se revisaron completos.
- Recalculado con los CSV de `results/` de `integration/four-models`: conteos de instancias, brechas, cocientes de tiempo, pares monolítico/Split, verificación de soluciones, iteraciones de HC y estudios de semillas.
- No verificado: las versiones de software de la Sección 5.1, las cifras tomadas del artículo de Coruzzolo et al. y las cifras de los estudios de escala de 6.1.3.

## Temas descartados

Por decisión de las autoras (16/11/2026) quedan fuera de esta revisión, porque ya se analizaron y no tienen un impacto significativo:

- Que los estudios de escala de 6.1.3 se ejecutaron con la máquina compartida con otras corridas.
- Que los resultados provienen de corridas de fechas y versiones del código distintas.

## Estado al 16/11/2026

Los cambios directos se aplicaron en la rama `revision-fixes` (PR #10). Las decisiones tomadas ese día:

| ID | Estado |
|---|---|
| P-1, P-2, P-6, P-7 | Aplicados. La carrera es "Licenciatura en Sistemas". |
| P-3 | Pendiente: la dedicatoria queda para el final. Hay un solo bloque de dedicatoria. |
| P-4, C7-5, C7-6, A-2 | Aplicados. El estudio de semillas se mantiene como evidencia de la robustez; el resumen se acota a la corrida principal, sin mencionar los 2 de 90. |
| P-5, C6-5 | Aplicados con otra redacción: "entre lo mismo que el Split y 6 veces menos, según el escenario". La propuesta original ("chicos" y "grandes") no era exacta: el escenario 10 es de 7×7 y tiene el cociente más alto. |
| C1-1, C2-2, C2-3, C3-1, C3-2, C4-1, C4-2, A-3 | Aplicados. En C2-2 hay que revisar la cita a Talbi. |
| C1-2, A-1 | Aplicado: se quitó el anexo de diagramas. |
| C1-3, G-2 | Aplicados: 1.1 avisa que "picker" se usa desde el Capítulo 3, el Capítulo 7 quedó unificado y 5 introduce "heurísticas". |
| C2-1, C7-2 | Pendientes. Se decidió no ampliar "Trabajos relacionados" por ahora. |
| C4-3 | Cerrado, sin cambios. |
| C5-1 | Retirado: el código confirma que las heurísticas corren las instancias capturadas del Split, como dice 5.2. |
| C5-2, C6-3 | Descartados: los números del texto (68 y 12) son correctos. |
| C5-3, C6-4, C6-6, C7-3, C7-4, C7-9 | Aplicados. |
| C6-1 | Descartado: el `no_result` del monolítico en el 01 no es relevante. |
| C6-2 | Aplicado: 35 instancias y 11 restantes; las medianas pasan a 0,295 y 0,225 s. Las dos de más son los casos 02 y 03, que comparten nombre de prueba. |
| C7-1 | Aplicado: se quitó "y las pruebas funcionales lo confirman". Las pruebas ejercitan el caso reducido, pero no se comparan con el modelo de referencia, que no está implementado. |
| C7-7 | Resuelto con C2-2. |
| C7-8 | Cerrado: no se mencionan `hc_3` ni `aco_3`. |
| C3-3, C5-4, G-1 | Aplicados: se borraron las guías y los comentarios; lo abierto pasó a `Notas/pendientes_cap7.md`, sección 6. |

## Lo que se verificó y coincide

Estas cifras del texto coinciden con los CSV actuales:

| Cifra | Dónde aparece | Fuente |
|---|---|---|
| 70 instancias funcionales; 67 comparables en estado y 45 en objetivo; 12 infactibles y 10 con espera voluntaria | 5.2, 5.5, 6.3 | `comparability/comparability_split_vs_heuristics.csv` |
| El Split termina 9 de los 19 escenarios de estrés | resumen, 6.1.4, 7.4 | `opp_split/stress/` |
| Estado: 67 de 67 funcionales y 9 de 9 de estrés | 6.3.1 | `comparability/results_split_vs_heuristics.csv` |
| HC funcional: 40 de 45 óptimas, media 0,36 %, máxima 5,88 %, en los casos 20, 25c, 25e·1, 25f·1 y 25f·2 | 6.3.2 | ídem |
| ACO funcional: 45 de 45 óptimas | 6.3.2 | ídem |
| HC estrés: 1 de 9 óptimas, media 0,06 %, mediana 0,04 %, máxima 0,21 % (escenario 11) | 6.3.2 | ídem |
| ACO estrés: 3 de 9 óptimas, media y mediana 0,01 %, máxima 0,04 % | 6.3.2 | ídem |
| Mediana del cociente de tiempos en estrés: 53,1 (HC) y 1,5 (ACO) | 6.3.4 | ídem |
| Cuadro de tiempos y brechas de estrés, fila por fila | 6.3.4 | ídem |
| 28 pares con la misma solución, 21 óptimos alternativos, 11 infactibles en los dos modelos | 6.1.1 | `comparability/compare_split_vs_mono.csv` |
| 150 soluciones válidas (56 funcionales y 19 de estrés por heurística) | 6.2 | `compliance/` |
| HC ejecuta entre 60 y 157 iteraciones, llega a 200 en el 03 y el 17, y su solución inicial es la mejor en tres escenarios (02, 07 y 16) | 6.3.7 | `opp_hc/stress/` |
| Variación entre semillas: mediana de 0,02 % (HC) y 0,005 % (ACO); máxima de 0,44 % (HC) y 0,05 % (ACO) | 6.3.8, 7.4, anexo | `opp_hc/budget/`, `opp_aco/seeds/` |
| Topes de 25 y 40 minutos | 5.4 | `tests/infra/execution/config.py`, `.env.example` |

Además, no hay referencias cruzadas sin definir ni citas que falten en la bibliografía, y las 18 entradas de `tesina.bib` están citadas. Las dos cuentas de la Sección 1.1 son correctas: 20! ≈ 2,4 × 10^18, y 10 lotes se reparten y ordenan entre 3 operarios de 239.500.800 formas.

---

## Páginas preliminares (`tesina.tex`, resumen y abstract)

### P-1. Al título le falta una preposición (Forma)

- **Dónde:** `tesina.tex`, línea 19 (`\TesinaTitulo`).
- **Qué dice:** "Optimización picking y ruteo de pedidos en un centro de distribución".
- **Por qué importa:** es lo primero que lee el jurado, y la frase no es gramatical.
- **Propuesta:** "Optimización del picking y del ruteo de pedidos en un centro de distribución", o la variante que prefieran.

### P-2. Nombre de la carrera en la portada (Forma)

- **Dónde:** `tesina.tex`, línea 54.
- **Qué dice:** "Tesina de la Licenciatura de Sistemas".
- **Propuesta:** confirmar el nombre oficial de la carrera; dos líneas más abajo, `\TesinaGrado` dice "Licenciadas en Sistemas".

### P-3. Agradecimientos y dedicatoria sin cerrar (Forma)

- **Dónde:** `tesina.tex`, líneas 113 y 143.
- **Qué dice:** los agradecimientos tienen el comentario `% TODO: cambiar esto!`, y la dedicatoria conserva el texto de la plantilla: "Para / Dedicada a / Para mi ...".
- **Por qué importa:** la dedicatoria sale impresa tal cual en el PDF.
- **Propuesta:** escribirla o quitar el bloque `\startpreliminar[title=, list={Dedicatoria}]`.

### P-4. El resumen afirma más que lo medido sobre HC (Fondo)

- **Dónde:** `resumen.tex` y `abstract.tex`, último párrafo.
- **Qué dice:** "Las metaheurísticas encuentran una solución válida en todas las instancias factibles."
- **Qué muestran los datos:** es cierto en la corrida principal, con semilla 1. En el estudio de semillas, HC queda sin solución en 2 de 90 ejecuciones sobre escenarios factibles. El detalle está en C7-5.
- **Por qué importa:** la robustez es parte del objetivo general, y la propia Sección 7.4 informa esos dos casos. Leída sola, la frase del resumen dice que HC nunca falla.
- **Propuesta:** acotar la frase a la corrida principal y, si se quiere, agregar media oración: "al variar la semilla, Hill Climbing quedó sin solución en 2 de 90 ejecuciones de estrés".

### P-5. "1,5 veces menores" para ACO (Fondo)

- **Dónde:** `resumen.tex` y `abstract.tex`, último párrafo.
- **Qué dice:** "con tiempos que en la mediana son 1,5 y 53 veces menores que los del Split".
- **Por qué importa y propuesta:** ver C6-5. El 53 de HC es sólido; el 1,5 de ACO está dentro de la variación de la medición.

### P-6. La recomendación del Split pierde su condición (Coherencia)

- **Dónde:** `resumen.tex` y `abstract.tex`, última oración.
- **Qué dice:** "el Split conviene cuando se necesita el óptimo probado, en instancias de hasta 6 lotes en grillas de hasta 15×15".
- **Por qué importa y propuesta:** ver C7-4. La Sección 6.4 aclara "en el perfil realista"; el resumen no.

### P-7. Dos oraciones del resumen para pulir (Forma)

- **Dónde:** `resumen.tex`, segundo párrafo.
- **Qué dice:** "este modelo se optimiza mediante su descomposición en dos etapas". En una tesina de optimización, "se optimiza" se confunde con resolver el modelo; lo que se quiere decir es que se reformula.
- **Qué dice:** "sigue resultando demasiado costoso y no se logra resolver en tiempos prácticos". Las dos mitades dicen lo mismo.
- **Propuesta:** "este modelo se descompone en dos etapas" y "sigue sin resolverse en tiempos prácticos para instancias moderadamente grandes". El abstract ya está escrito así ("this model is decomposed").

---

## Capítulo 1. Introducción

### C1-1. La Sección 1.4 no describe el Capítulo 7 actual (Coherencia)

- **Dónde:** Sección 1.4, "Organización del documento".
- **Qué dice:** el Capítulo 7 presenta "la discusión, las conclusiones, las limitaciones y las líneas de trabajo futuro".
- **Qué hay hoy:** el capítulo tiene cinco secciones, en este orden: Discusión, Limitaciones, Aportes y recomendaciones, Conclusiones, Trabajo futuro. La sección de aportes y recomendaciones es nueva de este PR y no se menciona.
- **Propuesta:** "…la discusión, las limitaciones, los aportes y las recomendaciones de uso, las conclusiones y las líneas de trabajo futuro".

### C1-2. La oración de los anexos omite el Anexo de diagramas (Coherencia)

- **Dónde:** Sección 1.4, última oración.
- **Qué dice:** enumera seis anexos (modelos lineales, metaheurísticas, pruebas funcionales, relevamiento, verificación y resultados).
- **Qué hay hoy:** `tesina.tex` incluye siete; el primero, "Diagramas" (`ap1.tex`), está vacío. Ver A-1.
- **Propuesta:** resolver A-1 y dejar las dos listas iguales.

### C1-3. "Operario" y "picker" (Forma)

- **Dónde:** todo el capítulo, y su relación con los capítulos 3 a 7.
- **Qué pasa:** el Capítulo 1 usa "operario" (15 veces) y presenta "picker" una sola vez, entre paréntesis. Los capítulos 3 a 6 usan casi solo "picker". El 7 alterna los dos (8 y 12 veces).
- **Propuesta:** decir en 1.1 que de ahí en adelante se usa "picker", o elegir uno y unificar. En el Capítulo 7 conviene uno solo.

---

## Capítulo 2. Marco teórico y estado del arte

### C2-1. "Trabajos relacionados" es corto para lo que el Capítulo 7 necesita (Fondo)

- **Dónde:** Sección 2.6.
- **Qué dice:** describe el modelo de referencia (Coruzzolo et al.) y reseña tres trabajos en un párrafo: Chen et al., Lesch et al. y Alaya et al.
- **Por qué importa:** la Sección 7.1.2 debe comparar los resultados con la literatura, y hoy solo puede citar a Kanet y Sridharan y a Chen et al. No hay ninguna descomposición con la cual comparar el Split, ni trabajos que integren loteo, asignación, secuencia y ruteo. Es el hueco de contenido más grande que queda, y ya figura en `Notas/pendientes_cap7.md` (sección 1).
- **Propuesta:** decidir si se amplía. Los candidatos anotados en los pendientes son de Koster, Le-Duc y Roodbergen (2007), Scholz, Schubert y Wäscher (2017) y van Gils et al. (2018); hay que verificarlos antes de citarlos.

### C2-2. La búsqueda local iterada se usa en el Capítulo 7 y no se define acá (Coherencia)

- **Dónde:** Sección 2.3, último párrafo; la usan 7.1.1 y 7.5.
- **Qué dice 7.1.1:** "La búsqueda local iterada de los autores incluye, justamente, un mecanismo para escapar de ellos, reiniciando la búsqueda local desde una perturbación de la mejor solución encontrada (Sección 2.3)".
- **Qué dice 2.3:** lista cuatro familias para escapar de los óptimos locales (reiniciar desde distintas soluciones iniciales, cambiar la vecindad, modificar el objetivo o aceptar movimientos que no mejoran), y nombra el recocido simulado y la búsqueda tabú. No nombra la búsqueda local iterada.
- **Propuesta:** agregar en 2.3 una oración que la presente como caso de la primera familia: reinicia la búsqueda desde una perturbación de la mejor solución, en lugar de una solución nueva.

### C2-3. Erratas y términos (Forma)

- Sección 2.5: "aún cuando las soluciones óptimas suelen encontrarse…" → "aun cuando" (sin tilde, con el sentido de "incluso").
- La guía al final del capítulo deja pendiente unificar "resolvedor"/"solver", "locación"/"ubicación" y "completitud"/"finalización" con los capítulos 3 a 6. Sigue abierto; ver G-2.

---

## Capítulo 3. Modelos lineales

No hay hallazgos de fondo. La limitación de `M_seq` con espera voluntaria está bien tratada: 3.2 la anuncia, 7.2.1 la explica y el anexo de los modelos lineales da el ejemplo, la cota válida y la revisión de las 59 soluciones del Split.

### C3-1. El cuadro de diferencias cuenta distinto las variables de ruteo (Forma)

- **Dónde:** Sección 3.5, cuadro de diferencias, fila "Tamaño".
- **Qué dice:** el monolítico tiene "2|E||B| variables de ruteo", y cada MIP de la Etapa 1, "2|E| + 1".
- **Qué pasa:** las variables de ruteo de un lote son `z` y `q` por arco, más `r_b`. El "+ 1" de la Etapa 1 es `r_b`; en el monolítico no se cuenta.
- **Propuesta:** "(2|E| + 1)|B|" en el monolítico, o quitar el "+ 1" de la Etapa 1.

### C3-2. "Ese modelo" queda lejos de su antecedente (Forma)

- **Dónde:** introducción del capítulo, segundo párrafo.
- **Qué dice:** "Respecto de ese modelo, la formulación agrega la velocidad heterogénea…".
- **Qué pasa:** el modelo de referencia se nombra al comienzo del párrafo anterior, y en el medio se describen cinco secciones.
- **Propuesta:** "Respecto del modelo de referencia, la formulación agrega…".

### C3-3. Comentario suelto al final del archivo (Forma)

- **Dónde:** `cap3.tex`, últimas dos líneas: "NOTA: Añadí todo, pero con comentarios para revisar…".
- **Propuesta:** borrarlo junto con la guía de trabajo. Ver G-1.

---

## Capítulo 4. Metaheurísticas

### C4-1. Los pseudocódigos comparan con `s*` cuando todavía no existe (Forma)

- **Dónde:** Figura del pseudocódigo de HC, paso 11, y de ACO, pasos 10 y 11.
- **Qué dice:** "si v(s) = 0 y f(s) < f(s\*) entonces s\* ← s".
- **Qué pasa:** el paso 3 de HC admite "s\* ← ninguna" cuando la solución inicial viola la cadena de frío, y ACO empieza con "s\* ← ninguna". En ese estado, f(s\*) no está definida y la primera solución factible no entraría según lo escrito.
- **Propuesta:** "si v(s) = 0 y (s\* es ninguna o f(s) < f(s\*))", o aclarar en el epígrafe que f(ninguna) = ∞.

### C4-2. El tope de 200 iteraciones de HC: 17 en un lugar y 18 en otro (Coherencia)

- **Dónde:** Sección 6.3.7 y anexo de las metaheurísticas, "Presupuesto de búsqueda".
- **Qué dice:** 6.3.7 dice que HC llega al máximo de 200 iteraciones en el 03 y el 17; el anexo, en el 03 con todas las semillas y en el 18 con una.
- **Qué muestran los datos:** los dos son correctos. En la corrida principal (`opp_hc/stress/`), 03 y 17. En el estudio de presupuesto (`opp_hc/budget/`), 03 y 18.
- **Por qué importa:** quien compare los dos pasajes ve una contradicción. La guía del Capítulo 4 ya lo tiene como pendiente.
- **Propuesta:** agregar en el anexo "(en la corrida principal, con semilla 1, fueron el 03 y el 17; Sección 6.3.7)".

### C4-3. Pendiente de la guía: el estado "optimal" (Forma)

- **Dónde:** guía al final de `cap4.tex`.
- **Qué dice:** el código marca como "optimal" el estado de una solución heurística, y el texto debe decir "encontró solución".
- **Qué se vio:** en los capítulos leídos el texto ya dice "encuentra una solución". Se puede cerrar el pendiente.

---

## Capítulo 5. Metodología

### C5-1. Cómo reciben las instancias las heurísticas (Coherencia)

- **Dónde:** Sección 5.2, párrafo "Aplicación a las heurísticas".
- **Qué dice:** "se capturan las que resuelve el modelo Split en sus pruebas funcionales, en el momento en que escribe sus archivos de datos".
- **Qué hay en el repositorio:** `tests/README.md` de `integration/four-models` dice que los cuatro modelos corren los mismos casos, escritos una sola vez en `tests/functional_cases/` y vinculados a cada modelo con `bind_cases`. Sigue existiendo `tests/shared_scenarios/functional/export_functional_instances.py`.
- **Por qué importa:** si el mecanismo cambió con la unificación de las pruebas, el párrafo describe una versión anterior.
- **Propuesta:** releer el párrafo contra la estructura actual y ajustarlo si hace falta. No se pudo determinar con certeza cuál de las dos descripciones vale hoy.

### C5-2. El caso 36c: "queda afuera" contra lo que corren hoy HC y ACO (Coherencia)

- **Dónde:** Sección 5.2 (mismo párrafo), Cuadro de 6.2 y Sección 5.5.
- **Qué dice:** "HC y ACO resuelven 68 de ellas: la 36c queda afuera porque sus datos se rechazan antes de resolver". El cuadro de 6.2 informa 68 instancias, 56 válidas y 12 sin solución.
- **Qué muestran los datos:** los CSV funcionales de HC y de ACO tienen 70 filas, y la verificación (`compliance/`) lista 56 válidas y 14 sin solución guardada. Las dos de más son `negative_speed_is_rejected` y `zero_speed_is_rejected`, es decir, las dos variantes del 36c, que hoy las heurísticas sí ejecutan y rechazan.
- **Por qué importa:** los números del texto (68 y 12) siguen siendo los del cruce con el Split, así que no hay un error en los resultados. Lo que cambió es la descripción: el 36c ya no "queda afuera", se ejecuta y se rechaza, igual que en los modelos lineales.
- **Propuesta:** decidir si el texto describe las 68 del cruce (y aclara que el 36c se ejecuta aparte) o las 70 que corren.

### C5-3. Erratas y términos (Forma)

- Sección 5.1: "un solver de MIP" y "sin depender de un solver externo". El resto de la tesina dice "resolvedor".
- Sección 5.3.1: "a partir de qué tamaño y porqué un modelo deja de resolver" → "por qué".
- Sección 5.5, ítem "Robustez": "Se decidió no considerar el test 01" → "el escenario 01".
- Los capítulos 5 y 6 escriben "HC" y "ACO" en texto plano; el 4 y el 7 usan `\ac{hc}` y `\ac{aco}`. No cambia el PDF salvo en la primera aparición, pero conviene una sola forma.

### C5-4. Comentarios personales al final del archivo (Forma)

- **Dónde:** `cap5.tex`, bloque final ("Estoy casi segura que falta una sección de experimentos…").
- **Propuesta:** borrarlo. El único pendiente real del bloque es el de los controles de los modelos exactos, que incluye "reducción a v4 (cap. 3)"; ver C7-1.

---

## Capítulo 6. Resultados

### C6-1. El monolítico en el escenario 01 no es un timeout (Coherencia)

- **Dónde:** Sección 6.1.4, primera oración.
- **Qué dice:** "el monolítico no termina ninguno de los 19 escenarios dentro del tope de 40 minutos".
- **Qué muestran los datos:** en `opp_mono/stress/output_opp_mono_stress_tests.csv`, 18 escenarios figuran como `timeout` y el 01 (100×100) como `no_result`.
- **Por qué importa:** la afirmación sigue siendo cierta, pero el 01 no llegó al tope: no produjo resultado. Es un dato distinto, y más fuerte, sobre el límite del monolítico.
- **Propuesta:** averiguar qué pasó en el 01 (por ejemplo, si no llegó a compilar el modelo) y decirlo en una oración.

### C6-2. Tiempos funcionales: 33 instancias en el texto, 35 en los datos (Coherencia)

- **Dónde:** Sección 6.3.4, primer párrafo.
- **Qué dice:** "los tiempos se comparan sobre 33 de las 45 instancias comparables en objetivo… HC fue más rápido que el Split en las 33 instancias; ACO, en 24. En las 9 restantes…".
- **Qué muestran los datos:** en `results_split_vs_heuristics.csv`, 35 de las 45 tienen tiempo del Split. HC es más rápido en las 35 y ACO en 24, así que las restantes son 11. El documento generado en el repositorio (`docs/thesis/opp_split_vs_heuristics_comparison.tex`, línea 247) también dice 35. Las medianas no cambian: 5,1 y 1,4.
- **Por qué pasa:** 33 es la cantidad de instancias que vienen de pruebas con una sola instancia, que es la regla que explica el texto. El CSV actual tiene tiempo para dos más.
- **Propuesta:** actualizar a 35 y a 11, o revisar por qué el CSV asigna tiempo a esas dos.

### C6-3. Conteo de la verificación: 68 y 12 contra 70 y 14 (Coherencia)

- **Dónde:** Cuadro de la Sección 6.2.
- **Detalle y propuesta:** es el mismo caso que C5-2. Las 150 soluciones válidas no cambian.

### C6-4. "ACO tarda entre 14 segundos y 6 minutos" excluye el 01 sin decirlo (Forma)

- **Dónde:** Sección 6.3.4, párrafo posterior a la figura, y Sección 7.3.3.
- **Qué dice:** "HC resuelve todos los escenarios en menos de 5 segundos, salvo el 01, mientras que ACO tarda entre 14 segundos y 6 minutos".
- **Qué muestran los datos:** ACO tarda 1.892 segundos (32 minutos) en el 01. El rango de 14 segundos a 6 minutos vale para los otros 18.
- **Propuesta:** "…mientras que ACO, también salvo el 01, tarda entre 14 segundos y 6 minutos". En 7.3.3 la salvedad está para HC y falta para ACO.

### C6-5. El "1,5 veces" de ACO está dentro del ruido de la medición (Fondo)

- **Dónde:** Sección 6.3.4, Sección 6.4 (ítem "HC es el método más rápido"), Sección 7.4 (ítem 5), resumen y abstract.
- **Qué dice:** en estrés, el tiempo de ACO es 1,5 veces menor que el del Split en la mediana.
- **Qué muestran los datos:** el cociente entre el tiempo del Split y el de ACO, en los 9 escenarios que el Split resuelve:

  | Escenario | 04 | 09 | 05 | 02 | 11 | 06 | 07 | 15 | 10 |
  |---|---|---|---|---|---|---|---|---|---|
  | Split / ACO | 0,87 | 1,15 | 1,16 | 1,18 | 1,51 | 2,14 | 5,51 | 5,55 | 5,96 |

  En el 04, ACO es más lento que el Split. En otros tres, la ventaja es menor al 20 %.
- **Por qué importa:** la Sección 5.4 dice que el tiempo de reloj de una misma instancia varía hasta el doble entre corridas, y que en estrés el Split corrió la Etapa 1 en seis procesos y ACO en uno. Con una corrida por escenario, un cociente de 1,5 no distingue a los dos métodos. Lo que los datos sí muestran es otra cosa: ACO tarda lo mismo que el Split en los escenarios chicos y bastante menos en los grandes (entre 5 y 6 veces en el 07, el 10 y el 15), y además resuelve los 10 que el Split no termina. La Sección 6.3.4 ya lo dice así en su segundo párrafo.
- **Propuesta:** en el resumen, 6.4 y 7.4, reemplazar "1,5 veces menores" por esa descripción: "tiempos del mismo orden que los del Split en los escenarios chicos y hasta 6 veces menores en los grandes". El 53 de HC se mantiene: su cociente mínimo es 23 (escenario 04).

### C6-6. Comentario suelto en 6.1.3 (Forma)

- **Dónde:** `cap6.tex`, línea 336 (`% mmmm.....`).
- **Propuesta:** borrarlo. El tema del párrafo que sigue está descartado (ver "Temas descartados").

---

## Capítulo 7. Discusión y conclusiones

### C7-1. "Las pruebas funcionales lo confirman" no tiene respaldo en los capítulos 5 y 6 (Fondo)

- **Dónde:** Sección 7.1.1, primer párrafo, y Sección 7.4, ítem 1.
- **Qué dice 7.1.1:** "Cuando las velocidades son iguales, la cadena de frío no restringe y no hay tiempos de servicio, los dos modelos lineales se reducen al de referencia con los lotes fijos, y las pruebas funcionales lo confirman."
- **Qué dice 7.4:** "cuando todos los operarios tienen la misma velocidad y la cadena de frío no restringe, el modelo se reduce al problema original".
- **Qué se encontró:** el Capítulo 3 lo argumenta desde la formulación, y eso alcanza como argumento. Pero ni 5.2 ni 6.1 presentan una prueba que compare contra el modelo de referencia, y el pendiente al final de `cap5.tex` sigue listando "reducción a v4 (cap. 3)" como control sin escribir. No se encontró en `integration/four-models` una prueba que resuelva el modelo de referencia.
- **Por qué importa:** "lo confirman" promete una evidencia experimental que el lector no puede encontrar.
- **Propuesta:** si existe ese control, describirlo en 5.4 o 6.1 y citarlo. Si no, quitar "y las pruebas funcionales lo confirman" y remitir al argumento del Capítulo 3. En 7.4, además, completar las condiciones ("no hay tiempos de servicio") y reemplazar "problema original" por "modelo de referencia con los lotes fijos".

### C7-2. La comparación con la literatura todavía no contrasta HC ni ACO (Fondo)

- **Dónde:** Sección 7.1.2.
- **Qué dice:** discute la cota dual del monolítico, la espera voluntaria (con Kanet y Sridharan) y las rutas sobre ubicaciones requeridas (con Chen et al.).
- **Qué falta:** contrastar con la Sección 2.3 que HC se estanque en óptimos locales y dependa de la construcción inicial, y con la 2.4 que ACO sea estable entre semillas y quede casi en el óptimo. Tampoco se usa a Lesch et al., que conecta con haber dejado el loteo como dato. Son los primeros tres ítems de `Notas/pendientes_cap7.md`, y dependen en parte de C2-1.
- **Propuesta:** un párrafo para HC y otro para ACO, con los datos que ya están en 6.3.2 (5 instancias de grilla; el 2-opt sin vecinos en entre el 26 % y el 48 % de las iteraciones) y en los estudios de semillas.

### C7-3. Falta una limitación: cada escenario es una sola instancia (Fondo)

- **Dónde:** Sección 7.2, "De la experimentación".
- **Qué dice:** "Las instancias son generadas y no provienen de una operación real", y sigue con los tiempos y las semillas de las heurísticas.
- **Qué falta:** el cuadro del perfil realista (Sección 5.3.2) indica que las ubicaciones de los pedidos se sortean con una única semilla (20260922). Cada escenario es, entonces, una instancia, no una muestra de instancias de ese tamaño. La guía al final de `cap7.tex` lo listaba ("con una sola semilla de generación") y no pasó al texto.
- **Por qué importa:** las brechas y los límites del Split ("hasta 15×15") salen de un punto por tamaño. La propia Sección 5.3.1 advierte que las conclusiones del relevamiento "no se transfieren de una instancia a otra, ni siquiera a instancias vecinas".
- **Propuesta:** agregar una oración: "Cada escenario corresponde a una única instancia, generada con una misma semilla, de modo que los resultados no miden la variación entre instancias del mismo tamaño". Encaja también como línea de trabajo futuro en "Alcance del problema".

### C7-4. La recomendación del Split omite "en el perfil realista" (Coherencia)

- **Dónde:** Sección 7.3.3, primer ítem; también resumen y abstract (P-6).
- **Qué dice:** "Hasta 6 lotes en grillas de hasta 15×15, lo prueba en minutos".
- **Qué muestran los datos:** el límite de 6 lotes es del perfil realista. El Split también termina el escenario 02, con 10 lotes en 10×10 y un lote por picker, y en el perfil realista con 6 lotes y 9 pickers (escenario 15) tarda 244 segundos. La Sección 6.4 lo dice bien: "en el perfil realista, hasta 6 lotes en grillas de hasta 15×15".
- **Propuesta:** copiar esa condición a 7.3.3 y al resumen.

### C7-5. Los dos casos sin solución de HC: son dos semillas, no una (Fondo)

- **Dónde:** Sección 7.4, párrafo del objetivo general, y anexo de las metaheurísticas, "Variación entre semillas".
- **Qué dice 7.4:** "con una de las semillas dos escenarios terminaron sin solución factible".
- **Qué dice el anexo:** "con una de las cinco semillas, dos escenarios terminaron sin solución factible".
- **Qué muestran los datos** (`opp_hc/budget/output_opp_hc_budget_20261019_201951.csv`, configuración de 200 y 60 iteraciones):

  | Escenario | Semilla | Resultado | Causa según el anexo |
  |---|---|---|---|
  | 09 (grilla de 8×21) | 4 | sin solución | no se construyó la ruta inicial de un lote |
  | 11 (cadena de frío) | 5 | sin solución | la búsqueda no cumplió la cadena de frío |

  Las otras 88 ejecuciones encuentran solución. El resultado se repite con los cuatro presupuestos de búsqueda, como dice el anexo. ACO encuentra solución en sus 90.
- **Por qué importa:** es un error de dato, y cambia la lectura: no es una semilla desafortunada, sino dos fallos independientes, cada uno por una de las dos causas que 7.2 describe como limitación.
- **Propuesta:** "en dos de las 90 ejecuciones, cada una con una semilla distinta (el escenario 09 y el 11)", en los dos lugares. Este hallazgo es el que respalda P-4.

### C7-6. Tres precisiones en el ítem 5 de las conclusiones (Forma)

- **Dónde:** Sección 7.4, ítem 5.
- **"Las heurísticas encuentran una solución en todas las instancias factibles"**: acotar a la corrida principal, por C7-5.
- **"HC, a menos de un 0,21 % en estrés"**: 0,21 % es el máximo que se alcanza, en el escenario 11. Debe decir "a lo sumo", como en 6.3.2 y en el resumen.
- **"con tiempos que en la mediana son entre 1,5 y 53 veces menores"**: se lee como un rango, y son dos valores, uno por heurística. Además, el 1,5 está observado en C6-5.

### C7-7. La remisión a 2.3 por la búsqueda local iterada (Coherencia)

- **Dónde:** Sección 7.1.1, cuarto párrafo, y Sección 7.5, "Metaheurísticas", primer ítem.
- **Detalle y propuesta:** ver C2-2. Se resuelve agregando la definición en 2.3.

### C7-8. Las variantes `hc_3` y `aco_3` ya no existen en el repositorio (Coherencia)

- **Dónde:** `Notas/pendientes_cap7.md`, sección 3, ítem abierto: decidir si se mencionan en el ítem de congestión de "Alcance del problema".
- **Qué hay en el repositorio:** `models/` de `integration/four-models` contiene solo `opp_mono`, `opp_split`, `opp_hc` y `opp_aco`.
- **Propuesta:** cerrar la decisión sin mencionarlas. El ítem de congestión de 7.5 queda como está.

### C7-9. `M_seq`: se puede citar la revisión que ya hizo el anexo (Forma)

- **Dónde:** Sección 7.2, "De los modelos lineales", párrafo de `M_seq`.
- **Qué dice:** "Cuando la espera no conviene, la cota original alcanza, y el caso no afecta a las soluciones de este trabajo."
- **Qué pasa:** 10 instancias funcionales sí usan espera, así que la oración sola deja la duda. El anexo de los modelos lineales la responde: se revisaron las 59 soluciones del Split y en ninguna la cota excluye el óptimo.
- **Propuesta:** "…y el caso no afecta a las soluciones de este trabajo, como se comprobó sobre las 59 soluciones del Split (Anexo de los modelos lineales)".

---

## Anexos

Revisados solo en los puntos que citan los capítulos.

### A-1. El Anexo "Diagramas" está vacío (Forma)

- **Dónde:** `Apendices/ap1.tex` (6 líneas) e `\input` en `tesina.tex`, línea 174.
- **Por qué importa:** sale en el PDF como un anexo con título y sin contenido, y es el primero.
- **Propuesta:** completarlo o quitar el `\input`. Si se quita, las letras de los demás anexos cambian solas, porque el texto los cita por referencia.

### A-2. Variación entre semillas de HC (Fondo)

- **Dónde:** anexo de las metaheurísticas, "Variación entre semillas".
- **Detalle y propuesta:** ver C7-5.

### A-3. Presupuesto de búsqueda de HC (Coherencia)

- **Dónde:** anexo de las metaheurísticas, "Presupuesto de búsqueda".
- **Detalle y propuesta:** ver C4-2. Los demás datos del párrafo coinciden con el CSV: 88 ejecuciones con solución, 6 que llegan al tope de 200 (las cinco del 03 y una del 18).

---

## Transversal

### G-1. Guías de trabajo y comentarios al final de cada capítulo (Forma)

- **Dónde:** el bloque `GUÍA DE TRABAJO` al final de `cap1.tex` a `cap7.tex`, más los comentarios sueltos de C3-3, C5-4 y C6-6.
- **Qué pasa:** no se compilan, pero quedan en el repositorio que se entrega. Además citan rutas que ya no existen en `integration/four-models`: `models/opp_v5_1_mono/`, `models/opp_hc_4/`, `analysis/`, `docs/thesis/models.tex` y `experiments/opp_v5/reports/`. Hoy son `models/opp_mono/`, `models/opp_hc/`, `experiments/` y los cuatro documentos de `docs/thesis/`.
- **Propuesta:** pasar a `Notas/` lo que siga pendiente y borrar los bloques antes de la entrega.

### G-2. Términos que alternan (Forma)

| Par | Dónde se ve | Sugerencia |
|---|---|---|
| heurística / metaheurística | los capítulos 1, 2 y 4 dicen "metaheurísticas"; el 5, el 6 y el 7 dicen casi siempre "heurísticas" | definir una vez que "heurísticas" abrevia "metaheurísticas", o unificar |
| operario / picker | ver C1-3 | uno solo a partir del Capítulo 3 |
| resolvedor / solver | "solver" en 5.1 | "resolvedor" |
| escenario / test / caso | "test 01" en 5.5; los cuadros de estrés titulan la columna "Caso" | "escenario" para estrés y "caso" para funcionales |

### G-3. Pendientes de `Notas/pendientes_cap7.md` que siguen abiertos

- Sección 1 completa (comparación con el estado del arte): ver C2-1 y C7-2.
- Sección 3, ítem de `hc_3` y `aco_3`: se puede cerrar, ver C7-8.
- Sección 4, "Revisar el inglés" del abstract: se leyó y no tiene errores; solo arrastra las tres observaciones del resumen (P-4, P-5 y P-6).

---

## Orden sugerido

1. C7-5 y P-4, porque es un error de dato y toca el resumen.
2. C6-5 y P-5, porque el "1,5" aparece en cinco lugares.
3. C7-1, C7-3 y C7-4, que ajustan lo que afirman las conclusiones.
4. C2-1 y C7-2, que requieren leer y escribir más.
5. Las de coherencia con el repositorio: C5-1, C5-2, C6-1, C6-2 y C7-8.
6. Las de forma, y al final G-1.
