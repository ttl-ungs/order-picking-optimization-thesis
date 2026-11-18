# Auditoría de la tesina: secciones F, G y H

Fecha: 18/11/2026. Alcance: solo F (conceptos), G (estilo, repeticiones y redundancias) y H (ToDos) de `Notas/prompt_auditoria_tesina.md`.

**Fuentes leídas, completas:** `tesina.tex`, `Capitulos/resumen.tex`, `abstract.tex`, `cap1.tex` a `cap7.tex`, `Apendices/ap1.tex`, `ap3.tex` a `ap8.tex`, `Guias/context_style_guide.md`, `Notas/pendientes_cap7.md` y `tesina.log` (búsqueda de *undefined*, *unknown* y *warning*).

**No se leyó:** el repositorio de código, los PDF de `zpaper`, `entorno.tex` y `tesina.pdf`. Lo que depende del código figura como **"a verificar en A+B"**, y lo que depende de los archivos de resultados, como **"a verificar en D"**.

Las ubicaciones son `archivo.tex:línea` del estado actual de los archivos (modificados el 18/11). Los recálculos usan solo números que la propia tesina publica (cuadros y texto).

---

## 1. Resumen ejecutivo: los 10 problemas más graves (dentro de F, G y H)

| # | Sev. | Ubicación | Problema |
|---|------|-----------|----------|
| 1 | Crítico | `cap6.tex:1002`, `cap7.tex:457-458` | Dice que el Split queda "entre un 46 y un 58 % por encima/peor" que ACO a igual tiempo. Ese porcentaje tiene al Split como base. Si se toma ACO como base, el Split queda entre un 86 y un 141 % por encima. |
| 2 | Crítico | `cap6.tex:320-321` | Dice que con 40 minutos el monolítico "sigue sin probar el óptimo en esos puntos", pero el Cuadro `tab:res_40min` (`cap6.tex:337`) y `ap5.tex:309-311` muestran que en 6 lotes 5×5 sí lo prueba, a los 32 min. |
| 3 | Mayor | `cap5.tex:562` vs `cap6.tex:23-24`, `cap7.tex:54` | Monolítico contra Split: "Quedan así 60 pares" frente a "66 pares comparables". La unidad cambia (pruebas o instancias) sin explicarlo. |
| 4 | Mayor | `cap6.tex:885-886` | "un 5,3 y un 10,5 % peor que la de ACO": tomando ACO como base, son un 5,6 y un 11,7 %. Los valores publicados tienen al monolítico como base. |
| 5 | Mayor | `cap3.tex:602-607`, `cap5.tex:102-104`, `cap5:113-114`, `ap4.tex:61,75` | No queda claro qué es "infactible" y qué es "rechazo": las velocidades no positivas se informan como infactibles (cap. 3), pero "no son de infactibilidad" (cap. 5). El pedido en dos lotes "se rechaza como infactible". |
| 6 | Mayor | `cap5.tex:4` y caps. 5–7 | "metaheurísticas (en adelante, heurísticas)": el cambio de término no se justifica, y ninguna de las dos palabras se define ni se distingue de la otra en el cap. 2. Los caps. 6 y 7 vuelven a mezclarlas. |
| 7 | Mayor | `resumen.tex:3` | El objetivo figura como "minimizar el tiempo total de preparación", pero el modelo minimiza la suma ponderada de los instantes de finalización y las penalidades. El abstract dice "total completion time", que es otra cosa. |
| 8 | Mayor | `cap4.tex:177-181`, `ap8.tex:129-143` | La justificación de λ = 1000 exige λ > K, pero, según la fórmula de K de la propia tesina, K = 1020 en el escenario 01 y K = 1272 en el 19. |
| 9 | Mayor | `resumen.tex:12-13`, `abstract.tex:12` | Las metaheurísticas se presentan como "equivalentes a los modelos lineales en las características que contemplan", sin la salvedad de la espera voluntaria que sí hacen `cap1.tex:159-161` y `cap7.tex:441-442`. |
| 10 | Mayor (H) | `tesina.tex:140-145`, `:113` | Se compila una dedicatoria *placeholder* ("Para / Dedicada a / Para mi ..."), y sobre los Agradecimientos hay un `% TODO: cambiar esto!`. Además siguen abiertos los 5 ítems de la comparación con la literatura (7.1.2) y los colores de los gráficos (ver §7). |

---

## 2. Hallazgos por sección

### F. Conceptos, definiciones y notación

**F1. Heurística/metaheurística: no se definen y se usan de forma inconsistente. Mayor.**
- La tesina dice, en `cap1.tex:99`: "Los métodos heurísticos (y metaheurísticos)". En `cap5.tex:4`: "metaheurísticas (en adelante, heurísticas)". El cap. 2 nunca define ninguno de los dos términos. Los caps. 1–4, el resumen y el abstract usan "metaheurística". Los caps. 5–7 usan casi siempre "heurística" (conteo: cap5 40 frente a 4, cap6 33 frente a 6, cap7 23 frente a 7), pero los títulos de `cap6.tex:377,421` y varios pasajes de `cap7.tex` (`:127,:134,:616`) vuelven a "metaheurísticas". En `pendientes_cap7.md` también se alternan.
- Lo correcto: definir en 2.3/2.4 qué es una metaheurística (estrategia general que guía heurísticas subordinadas) y usar un solo término para HC y ACO en todo el texto.
- Sugerencia: definir el término en la introducción del cap. 2, quitar el "(en adelante, heurísticas)" de `cap5.tex:4` o justificarlo, y unificar los títulos de las secciones 6.2 y 6.3.

**F2. Objetivo del problema mal nombrado en el resumen. Mayor.**
- `resumen.tex:3`: "minimizar el tiempo total de preparación". La función objetivo (`cap3.tex:216-221`) es la suma ponderada de los $c_b$ de los lotes más las penalidades. "Tiempo total de preparación" sugiere el *makespan* o la suma de duraciones.
- Sugerencia: "minimizar la suma de los instantes de finalización de los lotes y las penalidades por adelanto o demora". En el abstract: "the sum of the batch completion times".

**F3. Infactibilidad y rechazo de datos. Mayor. A verificar en A+B qué estado devuelve el código.**
- `cap3.tex:602-607`: si no se cumple alguna validación (pedido en un único lote, capacidad, velocidades positivas), "la instancia se informa como infactible". `cap5.tex:102-104` cuenta los datos inválidos como una causa de infactibilidad, pero `cap5.tex:113-114` dice: "La prueba 36c no es de infactibilidad: rechaza los datos de entrada". `ap4.tex:61` (31a): "se rechaza como infactible". `ap4.tex:75` (36c): "se rechazan antes de resolver".
- Sugerencia: definir dos estados (por ejemplo, "datos inválidos" e "infactible") y aplicarlos de la misma manera en 3.3.3, 5.2 y el Anexo de pruebas. Si el código devuelve estados distintos para 31a y 36c, explicarlo.

**F4. Uso de "más corta" para rutas: ¿distancia o tiempo de ruta? Menor (Mayor si el código compara por distancia donde S_i > 0; a verificar en A+B).**
- `cap3.tex:437` ("Calcula la ruta más corta de cada lote"): la Etapa 1 minimiza $r_b$, que incluye el servicio.
- `cap4.tex:673-675`: "una ruta más corta solo puede reducir el tiempo de ejecución del lote". No vale en general, porque el servicio se cobra en toda ubicación intermedia que se atraviesa (`cap3.tex:316-317`): una ruta de menor distancia que pase por más ubicaciones con $S_i>0$ puede tener mayor $r_b$. `ap8.tex:69-73` lo reconoce, pero solo para la construcción de HC.
- Sugerencia: en la Etapa 1, decir "la ruta de menor tiempo de ruta". En `cap4.tex:673-675`, agregar "cuando las ubicaciones de paso no tienen tiempo de servicio, como en las instancias de este trabajo (Sección `sec:anexo_rutas_construcciones`)".

**F5. "Búsqueda estocástica de primera mejora" (HC). Menor.**
- En `cap4.tex:374-380`, cada iteración genera un único vecino al azar, de modo que no se recorre una vecindad buscando la primera mejora (la definición de `cap2.tex:242-253`). Además, el operador 2-opt toma la **mejor** inversión (`cap4.tex:387-389`, `ap8.tex:169`). Es un *stochastic hill climbing* (muestreo aleatorio con aceptación de mejoras), con un operador interno de mejor mejora.
- Sugerencia: llamarlo "Hill Climbing estocástico (un vecino al azar por iteración)" y aclarar que el 2-opt aplica mejor mejora dentro del movimiento.

**F6. ACO/MMAS: la variante se presenta como MMAS sin listar las diferencias. Menor.**
- `cap4.tex:642-643` ("se actualiza según MMAS"). `cap2.tex:360-366` define el depósito de MMAS como $1/C^{best}$, de una sola hormiga (de la iteración **o** la mejor histórica). La implementación deposita una cantidad constante (1), lo hacen la mejor de la iteración **y** la mejor histórica, y lo hace sobre pares de ubicaciones requeridas y no sobre arcos. `cap4.tex:668-671` explica solo la primera diferencia.
- Sugerencia: "una variante de MMAS que conserva las cotas $[\tau_{\min},\tau_{\max}]$ y la inicialización en $\tau_{\max}$, pero ...", con las tres diferencias en una lista.

**F7. TSP/ATSP y 2-opt en un grafo dirigido. Menor.**
- `cap2.tex:219-228` define 2-opt sobre "aristas", lo que corresponde al TSP simétrico. `cap2.tex:146` menciona el "problema del viajante asimétrico" sin sigla. En `cap4.tex:264`, armar la ruta es "una variante del TSP", pero el grafo es dirigido (`cap1.tex:70`, `ap8.tex:166`) y se pueden atravesar ubicaciones no requeridas: es un camino hamiltoniano de tipo Steiner sobre un grafo asimétrico.
- Sugerencia: definir ATSP en 2.1 y decir en 4.1.4 "variante asimétrica del TSP en forma de camino, con ubicaciones de paso". En 2.3, aclarar que en el caso asimétrico invertir un tramo cambia el costo del tramo invertido.

**F8. Términos usados antes de definirse, o nunca definidos. Menor.**
- "escenarios heredados" (`cap5.tex:257`, `cap6.tex:355,922`, `cap7.tex:447`, `ap5.tex:210`): no se dice de dónde provienen (una versión anterior de la suite). "Conservan sus datos originales" (`cap5.tex:248-249`) tampoco lo explica.
- "ruleta" (`cap4.tex:613`, `cap7.tex:80`): selección proporcional, que no se presenta con ese nombre en `cap4.tex:551-556`.
- "degeneraciones de los escenarios heredados" (`cap7.tex:446-447`): no se define.
- "corrida principal" (`resumen.tex:17`, `cap7.tex:451`): se entiende recién en `cap5.tex:612` ("corrida con semilla 1").
- La notación "25e·1", "26b·2", "19b·1" (`cap6.tex:490-492,567-568`; `ap7.tex`): el punto medio para distinguir instancias dentro de una prueba no se explica (`cap5.tex:61-62` explica solo las letras).
- "exploración" como sinónimo de "relevamiento" (`cap6.tex:322`, "peso de finalización de la exploración"; `ap5.tex:45,118`).
- "chequeo de completitud" (`cap4.tex:277`, `cap7.tex:290`): aquí "completitud" significa que la ruta todavía puede completarse, y no se define en 4.1.4 (recién en `ap8.tex:52-56`).
- Sugerencia: definir cada término en su primer uso o agregarlo al glosario.

**F9. Nombres distintos para los extremos de la ruta. Menor.**
- Para el final: "punto de entrega" (`cap1.tex:38,71`, `cap5.tex:237`, `cap7.tex:169`, `ap5.tex:13,220`, `ap6.tex:61`), "nodo final" (`cap3.tex:75,246-247,279,319`, `cap7.tex:192`) y "depósito final" (`cap2.tex:432`). Para el inicio: "depósito", "depósito de partida" y "depósito inicial" (`cap2.tex:431`).
- Sugerencia: fijar "depósito ($v_{\text{start}}$)" y "punto de entrega ($v_{\text{end}}$)" en `cap3.tex:75` y usarlos en todo el texto.

**F10. "Brecha" con dos significados. Menor.**
- `cap5.tex:601` define "brecha" como $100(z_{heur}-z_{Split})/z_{Split}$. `ap5.tex:135,212,281,301,308` usa "brecha" para el *gap* de optimalidad de SCIP, al que `cap2.tex:130` y `cap6.tex:326,334` llaman "*gap*".
- Sugerencia: reservar "brecha" para la métrica de 5.6 y usar "*gap* de optimalidad" en el Anexo de relevamiento.

**F11. "Modelos" en lugar de "métodos". Menor.**
- `cap6.tex:974` ("Los cuatro modelos resuelven el mismo problema") y `cap7.tex:147` ("las limitaciones de los cuatro modelos"): HC y ACO no son modelos. En `cap7.tex:6` se usa "métodos".
- Sugerencia: "métodos".

**F12. Sobrecarga de símbolos entre capítulos y anexos. Menor.**

| Símbolo | Usos |
|---|---|
| $C$ | $C_j$ instante de finalización (`cap2.tex:157`); $C^k$ longitud del recorrido (`cap2.tex:350`); $C_n$ unidades del pedido (`cap3.tex:100`) |
| $T$ | $T_j$ demora (`cap2.tex:157`); $T^{\text{due}}, T^{\text{travel}}, \dots$ (cap. 3); la demora pasa a ser $ta_n$ |
| $d$ | $d_j$ fecha de entrega (`cap2.tex:156`); $d_{ij}$ distancia (`cap2.tex:310`, `cap4.tex:520`); $d(\pi_b)$, $d_r$ (`ap8.tex:49,176`); en el cap. 3 la distancia es $D_{ij}$ |
| $a$ | $a_{bi}$ ubicación requerida (`cap3.tex:144`); $a:\mathcal{B}\to\mathcal{P}$ asignación (`cap4.tex:42`) |
| $k$ | lote (`y_{bk}`); hormiga (`cap2.tex:302`, `cap4.tex:463`); contador de iteraciones de HC (`cap4.tex:319`); posición en $\sigma_p$ (`cap4.tex:103`); *k-opt* |
| $m$ | cantidad de hormigas; longitud de $\sigma_p$ (`cap4.tex:45`); movimiento $m$ (`cap4.tex:322`) |
| $u$ | $u_{pb}$ tiempo de ejecución; contador sin mejora (`cap4.tex:319`); $u_l$ ubicaciones requeridas (`cap4.tex:649`) |
| $\beta$ | parámetro de ACO; exponente de las construcciones aleatorias de HC (`ap8.tex:50`, `tab:hc_constantes`) |
| $R$ | $R_b$ tiempo de ruta mínimo; $\mathcal{R}$ ubicaciones pendientes (`cap4.tex:510`); $R$ registro del verificador (`ap6.tex:99`) |
| $n$ | cantidad de nodos (`cap2.tex:79`); índice de pedido (cap. 3); grilla $n\times n$ (`ap5.tex:12`) |

- La notación de adelanto y demora cambia de $E_j, T_j$ (cap. 2) a $ea_n, ta_n$ (cap. 3) sin remitir al cap. 2.
- Sugerencia: renombrar el contador de HC (por ejemplo, $it$, $sm$) y el movimiento ($\mu$), usar $\beta'$ (u otro símbolo) en HC, y en `cap3.tex:205` decir que $ta_n$ y $ea_n$ corresponden a $T_j$ y $E_j$ de 2.2.

**F13. La tolerancia ε se usa de forma inconsistente. Menor. A verificar en A+B.**
- $v(s)$ resta ε (`cap4.tex:165`), pero el costo local $g_b$ del 2-opt no (`ap8.tex:173`).

**F14. La capacidad del carro no tiene símbolo. Menor.**
- Se verifica antes de resolver (`cap3.tex:37-39,603`) y figura en el Cuadro `tab:perfil_realista`, pero no aparece en la notación de 3.1.
- Sugerencia: agregar el parámetro $Q^{\text{cart}}$ (u otro símbolo) y la condición $\sum_{n\in\mathcal{N}_b} C_n \le Q^{\text{cart}}$. Ojo: $Q$ ya se usa en ACO.

**F15. Definición de $y_{bk}$ distinta entre los modelos. Menor.**
- `cap3.tex:195` dice "cuando comparten *picker*", y `cap3.tex:533` lo omite.

**F16. Origen de $r_b$ en las metaheurísticas. Menor.**
- Según `cap4.tex:100-101`, $r_b$ se obtiene "según la Ecuación `eq:texec`", pero esa ecuación da $T^{exec}$ a partir de $r_b$. $r_b$ sale de `eq:mono_ruta`.

**F17. Pseudocódigo de ACO distinto del texto. Menor.**
- En `cap4.tex:465`, $a^k(b)\in\mathcal{P}^k_b$. Según `cap4.tex:559-560`, si el conjunto está vacío se elige entre todos los *pickers*.
- En `cap4.tex:516`, el denominador suma sobre $\mathcal{R}'$, pero la regla se enuncia para $r\in\mathcal{R}$: debería decir $r\in\mathcal{R}'$.

**F18. Justificación de λ. Mayor.**
- `ap8.tex:136-140` acota el aumento de $f$ con $K = W^c|\mathcal{B}| + W^{pen}\max(W^e,W^t)|\mathcal{N}|$ y exige λ > K. `cap4.tex:178-181` afirma que λ = 1000 cumple la condición. Con los datos de `tab:escenarios_estres` y `tab:perfil_realista`: escenario 01, K = 9·30 + 750 = 1020; escenario 19, K = 27·24 + 624 = 1272. En los dos, λ < K. Solo el 11 tiene la cadena de frío activa (K = 27·6 + 156 = 318), así que el resultado no cambia, pero la afirmación general es falsa.
- Sugerencia: acotar por *picker* (los lotes que siguen en la secuencia y sus pedidos), o decir explícitamente que λ > K se cumple en las instancias con cadena de frío activa.

**F19. Cotas de la feromona: la justificación ignora que los pares se comparten. Menor.**
- `ap8.tex:184-189` dice "a lo sumo dos depósitos de una unidad por lote e iteración". Pero los pares se comparten entre lotes (`cap4.tex:495-497`), así que un par puede recibir más de dos depósitos por iteración, y el valor estacionario sin tope supera $2/\rho$.
- Sugerencia: aclarar que $2/\rho$ es el estacionario para un solo lote, y que la cota $\tau_{\max}$ recorta el caso de pares compartidos.

**F20. Or-opt. Menor.**
- `ap8.tex:97` lo escribe "*or-opt*". La forma habitual es "Or-opt" (por I. Or).

### G. Estilo, coherencia interna, repeticiones y redacción

#### G.1 Contradicciones y números mal expresados (recalculados con los datos de la tesina)

**G1. A igual tiempo, el porcentaje del Split se lee al revés. Crítico.**
- `cap6.tex:1001-1003`: "el Split obtiene una en 15 de los 19 escenarios, cerca de ACO en 7 de ellos, pero entre un 46 y un 58 % peor en los de cuadrilla grande". `cap7.tex:456-458`: "el Split queda entre un 46 y un 58 % por encima en los escenarios de cuadrilla grande".
- La columna del Cuadro `tab:res_igual_tiempo_aco` es $(z_{ACO}-z_{Split})/z_{Split}$, es decir, tiene al Split como base. Con ACO como base ("el Split queda X % por encima"), en los escenarios 16, 17, 18 y 19: 363.913,6/195.905,7 = +85,8 %; 711.264,6/305.801,8 = +132,6 %; 976.169,8/439.801,8 = +122,0 %; 1.879.853,9/780.811,1 = +140,8 %.
- `cap6.tex:874-877` ("ACO es mejor por ... entre un 46 y un 58 %") sí es correcto.
- Sugerencia: "con el de ACO, el objetivo de ACO es entre un 46 y un 58 % menor que el del Split", o "el Split queda entre un 86 y un 141 % por encima".

**G2. Contradicción sobre el tope de 40 minutos. Crítico.**
- `cap6.tex:320-321`: "Con un tope de 40 minutos, el monolítico sigue sin probar el óptimo en esos puntos". El Cuadro `tab:res_40min` (`cap6.tex:337`) muestra "6 lotes, 5×5 · 32,0 min · sí", y `ap5.tex:309-311` lo confirma ("la única instancia adicional que cerró (6 lotes en 5×5) le llevó 32 minutos").
- Sugerencia: "sigue sin probarlo en dos de los tres puntos (3 lotes en 7×7 y 4 lotes en 6×6) ni en la instancia del escenario 04; en 6 lotes en 5×5 lo prueba a los 32 minutos, unas 8 veces lo que tarda el Split".

**G3. 60 pares contra 66 pares. Mayor.**
- `cap5.tex:557-562` (64 − 24b = 63 pruebas comunes, menos 30a, 36c y 37a = 60 **pruebas**) contra `cap6.tex:23-28`, `cap7.tex:54-55` y `ap7.tex:9-10` (55 + 11 = 66 **instancias**). La diferencia se debe a que algunas pruebas resuelven varias instancias (25e·1/2, 26b·1/2, ...), pero el texto no lo dice.
- Sugerencia: en 5.6, decir "60 pruebas, que suman 66 instancias", y usar "instancias" en el cap. 6.

**G4. Porcentajes del monolítico a igual tiempo. Mayor.**
- `cap6.tex:885-886`: "un 5,3 y un 10,5 % peor que la de ACO". Con ACO como base: 157.569,7/149.217,7 − 1 = 5,6 %; 222.183,9/198.902,6 − 1 = 11,7 %. Los valores publicados (5,30 y 10,48 %) tienen al monolítico como base.
- Sugerencia: corregir a 5,6 y 11,7 %, o reformular ("ACO obtiene un objetivo un 5,3 y un 10,5 % menor").

**G5. Efecto del paralelismo. Menor.**
- `cap6.tex:361-365`: "reduce el tiempo de la Etapa 1 como mucho a la mitad (2,2 veces ...)" y "Aun si todo su tiempo fuera el doble". Una aceleración de 2,2 veces reduce el tiempo a menos de la mitad (45 %). La conclusión se mantiene: 15,1 × 2,2 = 33,2 min < 40.
- Sugerencia: "a lo sumo 2,2 veces; aun multiplicando todo su tiempo por 2,2, terminaría por debajo del tope".

**G6. Cocientes de las medianas en las pruebas funcionales. Menor. A verificar en D.**
- `cap6.tex:588-590`: "el Split tarda 0,295 s, HC 0,061 y ACO 0,225, de modo que HC es 5,1 veces más rápido que el Split y ACO, 1,4". El cociente de las medianas da 4,8 y 1,3. Probablemente 5,1 y 1,4 sean la mediana de los cocientes, pero "de modo que" los presenta como si se derivaran de las medianas.
- Sugerencia: "la mediana del cociente de tiempos es de 5,1 para HC y de 1,4 para ACO".

**G7. Extrapolación de ACO en 100×100. Menor. A verificar en D.**
- `cap6.tex:734-736`: "completa solo dos iteraciones; las 60 completas llevarían unas 5 horas". Con 2 iteraciones en unos 31,5 min, 60 iteraciones llevarían unas 15,8 h, y unas 7,5 h si las hormigas usan la mitad del tiempo. Las 5 h no salen de los datos publicados.

**G8. "Un orden de magnitud". Menor.**
- `ap8.tex:423`: "un orden de magnitud menor que la de HC". Las medianas son 0,005 % y 0,02 % (4 veces), y los máximos, 0,053 % y 0,44 % (8 veces).
- Sugerencia: "entre 4 y 8 veces menor".

**G9. "De iguales a 6 veces menores". Menor.**
- `cap6.tex:731-732` y la misma idea en `resumen.tex:20-21`, `abstract.tex:19-20`, `cap6.tex:994-995` y `cap7.tex:456`. En el escenario 04, ACO tarda 14,1 s y el Split 12 s (cociente 0,85), así que ACO es más lento.
- Sugerencia: "entre algo más que el Split y 6 veces menos".

**G10. Estudio de escala. Menor.**
- `cap6.tex:176-177` dice "una misma instancia del perfil realista ... con 1 a 6 lotes", pero la figura `fig:res_lineales_escala` muestra 2, 3, 4 y 6 lotes, y el estudio cambia también la cantidad de *pickers* (`ap5.tex:289`: 1 a 3 *pickers*, mientras que el perfil tiene 3).
- `cap6.tex:290` ("con hasta 4 lotes resuelve cualquier grilla en menos de 10 segundos"): la figura no tiene el punto de 4 lotes en 7×7.
- Sugerencia: describir la familia de instancias (lotes y *pickers* por fila) y acotar la afirmación a las grillas medidas.

**G11. Tolerancia de la comparación. Menor.**
- `cap6.tex:26-27` ("La mayor diferencia es de 3,83·10⁻⁶ ... dentro de la tolerancia de SCIP") frente a `cap5.tex:563` (tolerancia relativa de 10⁻⁶). Hay que aclarar si 3,83·10⁻⁶ es una diferencia absoluta (sobre un objetivo de 3.087, la relativa es ≈1,2·10⁻⁹).

**G12. "Solo en estado": 10 frente a 22. Menor.**
- `cap7.tex:330-331`: "10 instancias funcionales pueden compararse solo en estado". Según `cap6.tex:426-428` son 22 (12 infactibles + 10 con espera).
- Sugerencia: "10 instancias funcionales factibles se comparan solo en estado, por la espera voluntaria".

**G13. Las 59 soluciones del Split. Menor. A verificar en D.**
- `cap7.tex:187-188` y `ap3.tex:65-77`. Cómo se llega a 59 no se explica (55 funcionales factibles + 9 de estrés = 64). En `ap3.tex:70-72`, la razón dada para las "6 de estrés" ($W^c = 27$) no vale si entre ellas está el escenario 02 (heredado, $W^c = 9$, 10 pedidos por lote). En ese caso la razón es que todos los pedidos están atrasados (`cap5.tex:251-253`).
- Tampoco se explica la cifra de "248 soluciones" de `ap6.tex:64`.

**G14. Afirmaciones imprecisas. Menor.**
- `cap7.tex:436-437`: "En las instancias pequeñas, el monolítico es algo más rápido". Lo es solo en la mediana. En la suma es 5,6 veces más lento (`tab:res_tiempos_lineales`).
- `cap6.tex:752-753`: "HC resigna centésimas de punto porcentual". En el escenario 11 son 0,21 puntos (décimas).
- `ap5.tex:42-44`: "no tuvo impacto significativo: la Etapa 2 exploró 153.934 nodos con 10 pedidos por lote y 4.144 con 26". Una variación de 37 veces en nodos no es "sin impacto". Conviene decir "no impidió la resolución" o "no creció con la cantidad de pedidos".
- `cap5.tex:210-214`: "cada grupo modifica un único aspecto". El escenario 10 cambia el ruteo y la cantidad de *pickers*, y el 11 cambia la grilla, los *pickers* y la cadena de frío.
- `cap5.tex:386` ("HC y ACO se ejecutan ... con semilla 1") frente a `tab:hc_parametros` (semilla por defecto "--", semilla de estrés "1").
- `cap6.tex:477`: "se eligió 86 veces". No se sabe si es el total de los tres escenarios o 86 en cada uno.

**G15. Pasajes fuera de lugar o con saltos lógicos. Menor.**
- `cap6.tex:736-738`: la frase "En la grilla de 14×14, en cambio, una ejecución de ACO tarda unos 94 segundos (Sección `sec:heur_limitaciones`)" no se conecta con lo anterior, y la sección citada no habla de ese tiempo.
- `cap5.tex:194`: "como ya se vio con los pesos asimétricos de la grilla". En el texto principal no se vio; está en `ap5.tex:55-62`. Conviene remitir al Anexo.
- `ap8.tex:243-244`: "Se fijaron a partir de las mediciones descritas en el Capítulo 4". El cap. 4 no describe mediciones (están en `ap8.tex:75-79`).
- `cap7.tex:587`: "Es la alternativa inversa a la anterior". "La anterior" es el último ítem de otra subsección (7.5.2). Conviene nombrarla.
- `ap8.tex:55-56`: "se comprueba de forma exacta ... La condición es necesaria pero no suficiente". Se lee como una contradicción. Conviene decir "la condición necesaria se comprueba de forma exacta".

#### G.2 Repeticiones (dos o más ubicaciones)

| # | Idea repetida | Ubicaciones | Sugerencia |
|---|---|---|---|
| R1 | Los modelos se reducen al de referencia con velocidades iguales, sin cadena de frío y sin servicio | `cap3.tex:27-30`; `cap7.tex:24-27`; `cap7.tex:430-432` | Dejarla en el cap. 3 y remitir desde el cap. 7 |
| R2 | Coruzzolo et al. usan una heurística EDD + ILS "sin poder contrastar sus resultados con el óptimo" (casi literal) | `cap2.tex:466-468`; `cap7.tex:63-66` | En 7.1.1, remitir a 2.6 y quedarse con la medición |
| R3 | La dificultad del monolítico es demostrar la optimalidad, porque la cota dual no avanza | `cap5.tex:175-178`; `cap6.tex:324-325`; `cap7.tex:113-114`; `ap5.tex:307-309` | Dejarla en 6.1 (con datos) y remitir |
| R4 | 30a: lotes vacíos intercambiables; 600 s frente a 0,13 s | `cap6.tex:45-53`; `cap7.tex:190-198`; `cap7.tex:509-511` | En el cap. 7, remitir a 6.1.1 |
| R5 | "Una prueba responde si ...; un estudio, en cambio, recorre ..." (literal) | `cap5.tex:149-153`; `ap5.tex:5-10` | Quitarla del Anexo |
| R6 | Alcance: semilla 1, reloj, suspensión, referencia solo donde el Split termina | `cap5.tex:377-380`; `cap6.tex:949-965`; `cap7.tex:319-331` | Dejar 6.3.8 o 7.2.3, no las dos |
| R7 | HC 17 min y ACO 32 min en 100×100 | `cap6.tex:733-735`; `cap7.tex:257-258` | Remitir |
| R8 | La espera voluntaria hace exacta la descomposición | `cap3.tex:468-473`; `cap3.tex:704-706`; `cap7.tex:125-126`; `cap7.tex:200-203` | Dejarla en 3.3 y remitir en 3.4 y en el cap. 7 |
| R9 | El Split, único modelo lineal que termina el estrés, es la referencia | `cap5.tex:17-20`; `cap5.tex:545-546`; `cap6.tex:367-370`; `ap5.tex:314-315` | Una sola vez por capítulo |
| R10 | Validación de los datos de entrada (pedido, capacidad, velocidades) | `cap3.tex:602-607`; `cap4.tex:216-220`; `cap5.tex:102-104`; `cap5.tex:450-452` | Ver H (pendiente del cap. 3) |
| R11 | Las metaheurísticas no generan espera voluntaria | `cap1.tex:159-161`; `cap2.tex:192-193`; `cap3.tex:681-683`; `cap4.tex:9-10`; `cap4.tex:110-112`; `cap6.tex:975-977` | Aceptable por contexto, pero `cap4.tex:9-10` y `:110-112` dicen lo mismo con pocas líneas de distancia |
| R12 | Números de síntesis (0,04 %, 0,21 %, 53 veces, 6 veces) | `resumen.tex:18-21`; `abstract.tex:17-20`; `cap6.tex:989-995`; `cap7.tex:453-456` | El ítem 5 de Conclusiones repite la Síntesis casi literal: remitir a 6.4 y quedarse con la lectura respecto del objetivo |
| R13 | Los tres aportes | `cap1.tex:125-132`; `cap7.tex:348-364` | Está previsto (7.3 "retoma"), pero el aporte 2 es casi literal |
| R14 | Lotes → Etapa 2; almacén → Etapa 1 | `cap5.tex:156-160`; `cap5.tex:221-224`; `cap6.tex:355-357`; `cap7.tex:220-224`; `ap5.tex:39-42` | Reducir a una mención con remisión |
| R15 | La validez de $M^{\text{seq}}$ depende de que no haya espera (primera frase literal) | `cap3.tex:399-404`; `cap7.tex:178-185`; `ap3.tex:30-37` | En el Anexo, empezar directamente por el ejemplo |
| R16 | Chen et al.: rutas sobre las ubicaciones requeridas | `cap4.tex:267-269`; `cap4.tex:526-528`; `cap7.tex:134-136` | Aceptable; unificar la formulación |
| R17 | Variación entre semillas (0,02 %, 0,005 %, 0,44 %, 2 de 90) | `cap6.tex:951-956`; `cap7.tex:470-475`; `ap8.tex:295-301,415-425` | Aceptable (síntesis y detalle) |
| R18 | La hormiga que no arma una ruta se descarta | `cap4.tex:139-141`; `cap4.tex:532-535`; `ap8.tex:229-230` | Quitar la mención de 4.1.2 |

#### G.3 Diferencias entre el resumen y el abstract

| # | Resumen | Abstract | Comentario |
|---|---|---|---|
| A1 | "minimizar el tiempo total de preparación" (`:3`) | "minimise the total completion time" (`:2-3`) | No dicen lo mismo, y ninguno coincide exactamente con el objetivo (ver F2) |
| A2 | Voz impersonal ("se formula", "se descompone", "se concluye") | Mezcla de "we formulate", "we call", "we conclude" (`:7-8,10,20`) con pasiva ("is decomposed", "are developed") | Elegir una sola voz en el abstract |
| A3 | "En la corrida principal" (`:17`) | "In the main runs" (`:16`) | Singular frente a plural |
| A4 | "tarda entre lo mismo que el Split y 6 veces menos" (`:20-21`) | "takes between the same time as the Split and 6 times less" (`:19`) | Inglés poco natural: "between as long as the Split and one sixth of its time" (ver también G9) |
| A5 | "equivalentes a los modelos lineales en las características que contemplan" (`:13`) | "equivalent to the linear models in the features they consider" (`:12`) | Los dos omiten la salvedad de la espera voluntaria (ver §1 #9) |
| A6 | "la optimidad" (`:4`) | "optimality" | En el cuerpo se dice "optimalidad" (`cap2.tex:130`, `cap5.tex:178,437`, `cap6.tex:326`) |
| A7 | "la mayoría con un perfil realista" (`:15-16`) | "most of them with a realistic warehouse profile" | Ambiguo en los dos: parece abarcar también los casos funcionales. Mejor "16 de los 19 escenarios de estrés" |
| A8 | — | Ortografía británica ("centres", "minimise") | Coherente dentro del abstract; conviene decidirlo explícitamente (pendiente "Revisar el inglés") |
| A9 | "Este trabajo toma como punto de partida ... Tomándolo como guía" (`:8`) | "takes as its starting point ... Using it as a guide" (`:7`) | Redundancia en los dos idiomas |
| A10 | "0,04\,\%" | "0.04\,\%" | En inglés se usa "0.04%", sin espacio |

En todo lo demás (cifras, estructura, conclusión) son traducciones fieles.

#### G.4 Incumplimientos de la guía de estilo (`Guias/context_style_guide.md`)

| # | Sev. | Regla | Incumplimiento | Ubicación |
|---|---|---|---|---|
| S1 | Menor (pendiente explícito) | §2: `blueline` para HC y `greenline` exclusivo para ACO | HC en `greenline` y ACO en `redline` | `cap6.tex` (`fig:res_brecha` :525-544, `fig:res_estres_tiempos` :662-725, `fig:res_calidad_tiempo` :784-815); `ap7.tex` (`fig:res_funcional_tiempos` :134-207, `fig:res_memoria` :299-351) |
| S2 | Menor | §2: `greenline`, `blueline` y `redline` tienen usos reservados | Se usan para "2, 3, 4 y 6 lotes" | `cap6.tex:212-236,266-284` (`fig:res_lineales_escala`) |
| S3 | Menor | §2: `redline`, solo para OPP\_v3 bajo estrés o barras de Solver; `darkblue`, "uso exclusivo" para títulos y modelos exactos | `redline` en las flechas de "infactible" y en las barras de la Etapa 2 y de 4 *pickers*; `darkblue` como borde de cajas y para la Etapa 1 y los 3 *pickers* | `cap3.tex:628`, `cap4.tex:56`, `cap5.tex:488`, `ap5.tex:94-114,164-183,284` |
| S4 | Menor | §5: ejes de 1 pt, curvas de 1,5 pt, puntos de 4 pt | Ejes de 0,6 pt, curva de 1,2 pt y puntos de 1,8 mm (≈5 pt) | `cap3.tex:783-801` (`fig:espera_ejemplo`); flechas de 0,5–0,8 pt en los diagramas `cap3.tex:635`, `cap4.tex:60,84`, `cap5.tex:495` |
| S5 | Menor | §5: `\placefigure[force][fig:...]` | Se usa `\startplacefigure[...]` en figuras MetaPost | `cap3.tex:624,779`, `cap4.tex:51`, `cap5.tex:484` (los pseudocódigos `cap4.tex:310,454`, `ap6.tex:95` no son MetaPost) |
| S6 | Menor | §5: las etiquetas de los ejes deben indicar la magnitud y su unidad | "tiempo", sin unidad | `cap4.tex:85` |
| S7 | Menor | §4: `split=yes` | `split=repeat` (razonable en tablas largas) | `ap4.tex:8`, `ap7.tex:15` |
| S8 | Menor | §6: se recomienda poner en negrita el concepto clave de cada ítem | Listas sin negrita (por ejemplo, `cap1.tex:20-29`, `cap7.tex:243-312`) | En 7.2 se quitó a propósito (pendientes §5); dejar asentado que es una decisión |
| S9 | Menor | — (calidad de la figura) | Un punto se dibuja debajo del eje x (valor < 0,1 s, fuera del rango) | `cap6.tex:150` |
| S10 | Menor | Encabezados de tablas | Las 28 tablas cumplen el fondo `darkgray` y la negrita | ✔ |
| S11 | Observación | La guía nombra "OPP\_v3 / SCIP" | La tesina ya no usa esos nombres (monolítico y Split): la guía está desactualizada | `Guias/context_style_guide.md:16,18` |

Otros aspectos de estilo (Menores):
- Mezcla de idiomas: "suite", sin cursiva, en `cap5.tex:187,256,311,314,346,353,358,361,549,622`, `ap5.tex:124,213` y `ap8.tex:413`. Los demás anglicismos sí van en cursiva.
- Términos sin `{\em}`: "*pickers*" en `cap4.tex:41,44,621,623` y `ap5.tex:110,112,114,289` (texto de la figura). En `cap7.tex:395-406`, los nombres de los métodos van en cursiva ("{\em Split}", "{\em ACO}") y en el resto del texto no.
- "descripto/descriptos/descriptas" (`cap5.tex:141`, `cap6.tex:11`, `ap4.tex:4`, `ap6.tex:3`) frente a "descrito/descritas" (`cap3.tex:5`, `ap8.tex:244`). Conviene unificar.
- "seis procesos" (`cap5.tex:189,353`, `cap6.tex:359,598`) frente a "6 procesos" (`cap5.tex:339,346`, `ap5.tex:213,259`).
- "Caso" como encabezado de `tab:escenarios_estres` (`cap5.tex:271`) y de los cuadros de estrés del cap. 6, cuando el texto dice "escenario".
- Las remisiones a secciones de anexos a veces llevan "del Anexo~\in[...]" (`cap4.tex:181`, `cap5.tex:179,185`) y a veces no (`cap2.tex:457`, `cap4.tex:279,286,289,389,417`).
- "Además" dos veces seguidas en `cap7.tex:190,193`. Hay líneas en blanco dobles en `cap2.tex:100-102`, `cap3.tex:720-721,811-812` y espacios al final de línea en `cap5.tex:60`, `cap7.tex:168-170`, `ap5.tex:42,66-67` y `ap8.tex:79` (no afectan al PDF).
- `cap2.tex:54`: la fórmula termina en coma y lo que sigue empieza un párrafo nuevo ("De este modo").
- `cap4.tex:566`: "De esta forma, cada lote se ordena según la menor $T^{due}$". El conector no corresponde; conviene "Para eso".
- Cita que falta: `cap5.tex:40-42` ("8 [núcleos] de eficiencia, que funcionan a cerca de la mitad de la velocidad") no tiene fuente.
- Autoría inconsistente: "Alaya et al." (`cap2.tex:454`) frente a "Alaya y Solnon" (`ap8.tex:392`), con la misma clave `alaya2007antcolony`. A verificar en E cuántos autores tiene.
- `tesina.tex:67`: "Autor/es:". Con dos autoras corresponde "Autoras:". Tampoco se definen `\TesinaCosupervisor` ni `\TesinaGrupo` (`:26-27`), que imprimen párrafos vacíos (`:75,82`).

#### G.5 Referencias cruzadas y citas

- **Referencias `\in[...]`:** comprobación estática sobre los `.tex` compilados. Ninguna remite a una etiqueta inexistente y no hay etiquetas duplicadas.
- **Citas `\cite[...]`:** las 18 claves que se usan existen en `Referencias/tesina.bib`.
- **`tesina.log`:** no hay *undefined*, *unknown* ni *warning*. **El log es del 15/11 23:04, y los `.tex` se modificaron el 18/11 19:10**, así que no refleja el estado actual. No se recompiló (por instrucción).
- **Etiquetas definidas que no se usan** (no es un error): `eq:mip`, `eq:aco_evaporacion`, `eq:aco_deposito`, `eq:aco_cumplen`, `eq:hc_objetivo`, `eq:hc_violacion`, `eq:hc_costo_local`, `eq:split_objetivo1`, `eq:split_objetivo2`, `eq:split_demora`, `eq:split_adelanto`, `sec:software`, `sec:organizacion`, `sec:split_etapa2`, `sec:anexo_sla`, `sec:aportes_lista`, `sec:beneficios`, `sec:calib_hc_constantes`, `sec:calib_aco_constantes`, `Anexo_Diagramas`.
- **Referencias semánticamente incorrectas:** `cap6.tex:738` (ver G15) y `ap8.tex:244` (ver G15).
- `Apendices/ap1.tex` (`Anexo_Diagramas`) no se incluye desde `tesina.tex`.

### H. ToDos

#### H.1 Estado de cada ítem de `Notas/pendientes_cap7.md`

| Ítem (sección del archivo) | Estado | Evidencia |
|---|---|---|
| Limitaciones de los cuatro métodos movidas a 7.2 (preámbulo) | Resuelto | `cap7.tex:145-335`; `cap3.tex:14-16` y `cap4.tex:19-20` remiten a 7.2 |
| 7.1.1 escrita y verificada contra Coruzzolo (preámbulo) | Resuelto en el texto; la verificación contra el paper queda para E | `cap7.tex:16-108` |
| Repeticiones del cap. 7 quitadas (preámbulo) | Parcial | Siguen R1, R4, R6, R7 y R12 dentro del cap. 7 y contra el cap. 6 |
| §1 Contrastar HC con la literatura (Talbi; Hoos y Stützle) | **Parcial** | `cap7.tex:86-91` habla del óptimo local de HC y remite a `sec:marco_hc`, pero 7.1.2 (`cap7.tex:111-138`) no cita a Talbi ni a Hoos y Stützle, ni usa el dato del 26–48 % de iteraciones de 2-opt sin vecino |
| §1 Contrastar ACO con la literatura (MMAS, Dorigo y Stützle) | **Pendiente** | 7.1.2 no menciona a ACO frente a la literatura |
| §1 Usar a Lesch et al. | **Pendiente** | `lesch2023optimizing` solo se cita en `cap2.tex:451` y `ap8.tex:393`; no figura en el cap. 7 |
| §1 Comparar la descomposición con la literatura | **Pendiente** | El cap. 2 no cita ninguna otra descomposición |
| §1 (D) Ampliar "Trabajos relacionados" (2.6) | **Pendiente (decidido)** | `cap2.tex:424-473` sigue con Coruzzolo, Chen, Lesch y Alaya. En §6 dice "Se decidió dejarlo pendiente" |
| §2 (D) Dónde va la sección de aportes | Resuelto | 7.3 `sec:aportes`, `cap7.tex:338` |
| §2 Retomar los tres aportes de 1.2 | Resuelto | `cap7.tex:348-364` (el "150 de 150" está en `cap7.tex:443`, no en la lista de aportes) |
| §2 Beneficios prácticos | Resuelto | `cap7.tex:371-378` (velocidades, cadena de frío, soluciones válidas); HC y ACO en 7.3.3 |
| §2 Beneficios metodológicos | Resuelto | `cap7.tex:380-385` |
| §2 Recomendación de uso | Resuelto | `cap7.tex:390-415`; las conclusiones remiten (`cap7.tex:475-477`) |
| §3 Justificar cada ítem de trabajo futuro | Resuelto | `cap7.tex:495-621` (cada ítem dice de qué limitación sale y qué se espera ganar) |
| §3 Limitaciones sin línea de trabajo futuro (6 subítems) | Resuelto | Estancamiento `:552-558`; η de asignación `:559-562`; rutas por distancia `:562-564`; tiempo estricto `:565-568`; falso infactible `:569-572`; secuencia inicial de HC `:547-551` |
| §3 Ideas de la guía del capítulo (ítem padre `[ ]`) | Resuelto (el padre quedó sin marcar) | Los 4 subítems están en `[x]`: expansión sin cruces `cap7.tex:519-521`; pseudocosto `:526-529`; modelo sin espera `:585-592`; hc\_3/aco\_3 no se mencionan, por decisión (no aparecen en los `.tex`). **Marcar el padre como `[x]`** |
| §3 A partir de Coruzzolo et al. | Resuelto | Loteo `cap7.tex:605-611`; heurística de los autores `:593-596` |
| §4 Conclusión apoyada en lo anterior | Resuelto | `cap7.tex:466-477` |
| §4 Cerrar la comparación con Coruzzolo | Resuelto | `cap7.tex:479-488` |
| §4 Párrafo de robustez | Resuelto | `cap7.tex:470-475` |
| §4 Actualizar el resumen y escribir el abstract ("Revisar el inglés") | **Parcial** | Están escritos y son consistentes en cifras, pero quedan los puntos A1–A10 (§2, G.3) |
| §5 Frase del primer párrafo de 7.1.1 | Resuelto | `cap7.tex:24-26` |
| §5 "al modelo que los asigna y secuencia" | Resuelto | `cap7.tex:46` |
| §5 (D) Negritas de 7.2 | Resuelto | `cap7.tex:243-312` no tiene `{\bf}` en los ítems |
| §5 "38 casos ... 64 pruebas" | Resuelto | `cap7.tex:445` |
| §6 Cap. 2: unificar "locación"/"ubicación" y "completitud"/"finalización" | Resuelto en lo pedido, con observación | No hay "locación" en ningún `.tex`. "Completitud" solo aparece en `cap4.tex:277` y `cap7.tex:290` con otro sentido ("chequeo de completitud"), que conviene definir (F8) |
| §6 Cap. 3: que 4.1.3 y 5.2 remitan a 3.3.3 | **Parcial** | `cap4.tex:216-220` remite a `sec:split_resolucion`, pero vuelve a listar los chequeos. `cap5.tex:102-104` (5.2) los lista sin remitir. `cap5.tex:450-452` (5.5) tampoco remite |
| §6 Cap. 6: colores de los gráficos | **Pendiente** | Ver S1 (también en `ap7.tex`) |
| §6 Caps. 2 y 7: ampliar Trabajos relacionados | **Pendiente (decidido)** | Igual que §1 |
| §6 Dedicatoria | **Pendiente** | `tesina.tex:140-145` sigue con el *placeholder*, que se compila |

#### H.2 Marcadores y *placeholders* en los `.tex`

Se buscó `TODO`, `ToDo`, `\todo`, `XXX`, `FIXME`, `??`, `pendiente`, "placeholder", "completar", "Lorem" y similares en `tesina.tex`, resumen, abstract, cap1–cap7 y todos los anexos.

| Ubicación | Marcador | ¿Se compila? | Comentario |
|---|---|---|---|
| `tesina.tex:113` | `% TODO: cambiar esto!` (sobre Agradecimientos) | No (comentario) | El texto de `:115-117` sí se compila. Decidir si queda así |
| `tesina.tex:140-145` | Dedicatoria "Para / Dedicada a / Para mi ..." | **Sí** | *Placeholder* visible en el PDF |
| `tesina.tex:101-103` | `% Esta también me gustó jaja:` y una cita alternativa comentada | No | Comentario informal; conviene quitarlo antes de entregar |
| `tesina.tex:20` | `% Cambiar según corresponda (a/o/os/as)` | No | Ya está en "Licenciadas" |
| `tesina.tex:67` | "Autor/es:" | **Sí** | Forma genérica de la plantilla; corresponde "Autoras:" |
| `tesina.tex:26-27,75,82` | `\TesinaCosupervisor{}` y `\TesinaGrupo{}` vacíos | Sí (párrafos vacíos) | Quitar las líneas o completarlas |
| `tesina.tex:162-163` | Comentario sobre `plantilla.tex` | No | Informativo |
| `Apendices/ap1.tex:3-4` | `% TODO: completar` y `% afuera???` | No (ap1 no se incluye) | El anexo "Diagramas" está vacío; decidir si se borra el archivo |

No hay `XXX`, `FIXME`, `\todo` ni `??` en el texto. Las apariciones de "pendiente" son usos legítimos ("ubicación pendiente" en `ap8.tex`, "pendiente −2/4" como pendiente de la recta en `cap3.tex:803-804`), igual que las de "completar" (`cap7.tex:293`, `ap4.tex:22`, `ap8.tex:52`).

---

## 3. Qué no se pudo verificar y por qué

- **Todo lo que depende del código** (a verificar en A+B): el estado que devuelven 31a y 36c (F3); si ACO y HC comparan rutas por distancia o por $r_b$ (F4); el uso de ε en $g_b$ (F13); λ = 1000, el valor por defecto de la semilla y las constantes de los Cuadros `tab:hc_constantes` y `tab:aco_constantes`; las versiones de software (`cap5.tex:30-36`).
- **Todo lo que depende de los archivos de resultados** (a verificar en D): las 59 y las 248 soluciones (G13), los cocientes 5,1 y 1,4 (G6), las "5 horas" (G7), cuáles son las "6 de estrés" de `ap3.tex:71`, las 86 elecciones de 2-opt (G14) y la clasificación de 25b en `cap5.tex:72` frente a `ap4.tex:46`. Las cifras que se recalcularon se recalcularon solo contra los cuadros de la propia tesina.
- **Fidelidad bibliográfica** (Alaya et al., Or-opt, Chen et al., Coruzzolo et al.): sección E, porque no se leyeron los PDF de `zpaper`.
- **Referencias cruzadas en el PDF:** el log disponible es anterior a la última modificación de los `.tex`, y no se recompiló ni se abrió `tesina.pdf`. La comprobación de las referencias fue estática.
- **Revisión del inglés del abstract:** se señalan problemas puntuales (G.3), no se hizo una corrección de estilo completa.
- **`entorno.tex`** no se leyó (fuera del alcance indicado): no se verificó que el entorno aplique la cabecera de la guía (§8) ni la definición de las siglas.
