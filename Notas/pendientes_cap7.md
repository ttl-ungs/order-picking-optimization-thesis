# Pendientes del Capítulo 7 (Discusión y conclusiones)

Armado el 15/11/2026, en la rama `cap7-limitaciones`, a partir de la revisión de qué debería tener el capítulo para llegar a una conclusión justificada: comparación con el modelo de referencia y con el estado del arte, limitaciones, beneficios y trabajo futuro.

Ya resuelto en esta rama:
- Las limitaciones de los cuatro métodos pasaron de los capítulos 3 y 4 a la Sección 7.2.
- Se escribió la subsección 7.1.1, "Comparación con el modelo de referencia", y se verificó contra el paper de Coruzzolo et al. (`zpaper/logistics-07-00061 (1).pdf`).

---

## 1. Comparación con el estado del arte (7.1.2)

Hoy la subsección 7.1.2 solo cita a Kanet y Sridharan (tiempo ocioso insertado) y a Chen et al. (rutas sobre las ubicaciones requeridas, congestión).

- [ ] **Contrastar HC con la literatura.** Que se estanque en óptimos locales y dependa de la construcción inicial, ¿es lo que anticipan Talbi y Hoos y Stützle (Sección 2.3)? Datos: falla el óptimo en 5 instancias de grilla y el 2-opt no genera vecinos en entre el 26 y el 48 % de las iteraciones (Sección 6.3.1).
- [ ] **Contrastar ACO con la literatura.** Que quede prácticamente en el óptimo y sea estable entre semillas, ¿es consistente con MMAS (Stützle y Hoos) y con Dorigo y Stützle (Sección 2.4)?
- [ ] **Usar a Lesch et al.** Muestran que optimizar varias decisiones de forma conjunta mejora el resultado global. Eso conecta con haber dejado el loteo como dato.
- [ ] **Descomposición.** Comparar el Split con otras descomposiciones de la literatura. Hoy no se puede, porque el capítulo 2 no cita ninguna.
- [ ] **(D) Ampliar "Trabajos relacionados" (2.6)**, que hoy reseña tres trabajos en un párrafo. Candidatos, que hay que verificar antes de citar:
  - de Koster, Le-Duc y Roodbergen (2007), revisión de picking (EJOR).
  - Scholz, Schubert y Wäscher (2017), varios operarios con fechas de entrega; integra loteo, asignación, secuencia y ruteo (EJOR).
  - van Gils et al. (2018), revisión de problemas de planificación combinados (EJOR).

## 2. Aportes y beneficios (sección nueva)

Hoy aparecen dispersos en las conclusiones.

- [ ] **(D) Decidir dónde va.** Puede ser una sección "Aportes y beneficios" o "Recomendaciones", entre Limitaciones y Conclusiones o dentro de Conclusiones. La guía original del capítulo preveía una 7.3 "Recomendaciones".
- [ ] **Retomar los tres aportes que anuncia la Sección 1.2:**
  1. La descomposición Split, que alcanza el mismo óptimo y resuelve instancias que el monolítico no termina.
  2. La verificación independiente de las soluciones de las heurísticas contra el monolítico (150 de 150).
  3. La comparación de los cuatro métodos sobre los mismos datos.
- [ ] **Beneficios prácticos para la operación:**
  - Replanificar en segundos con HC.
  - Calidad casi óptima con ACO.
  - Cadena de frío garantizada.
  - Aprovechar operarios con velocidades distintas.
- [ ] **Beneficios metodológicos:** el verificador, el conjunto de pruebas funcionales y de estrés, y las reglas de comparabilidad se pueden reutilizar.
- [ ] **Recomendación de uso.** Mover acá el párrafo de "En cuanto al objetivo general…" de las conclusiones: el Split hasta 6 lotes en grillas de hasta 15×15, ACO cuando importa la calidad y HC cuando importa el tiempo.

## 3. Trabajo futuro (7.4)

El 15/11 se reescribió la Sección 7.4 en cuatro subsecciones (modelos lineales, metaheurísticas, comparación entre métodos y alcance del problema). Cada línea indica de qué limitación sale y qué se espera ganar.

- [x] **Justificar cada ítem:** de qué limitación de 7.2 sale y qué se espera ganar.
- [x] **Limitaciones de 7.2 que no tienen su línea de trabajo futuro:**
  - ACO: un criterio de estancamiento.
  - ACO: una información heurística de asignación que considere la velocidad, la duración de los lotes y las fechas de entrega.
  - ACO: rutas que no se elijan solo por distancia.
  - Que el tiempo máximo de las heurísticas sea estricto.
  - Que las heurísticas no informen como infactible una instancia factible.
  - HC: una secuencia inicial por fecha de entrega, en lugar del orden de los identificadores.
- [ ] **Ideas de la guía del capítulo que no están en el texto:** (queda abierto hasta decidir lo de hc_3 y aco_3)
  - [x] Una expansión sin cruces para la clausura métrica (en "Modelos lineales", dentro de acelerar la Etapa 1).
  - [x] El branching por pseudocosto ya se probó y no generalizó (en "Modelos lineales", dentro de acelerar la Etapa 2).
  - [x] Un modelo exacto sin espera voluntaria (en "Comparación entre métodos").
  - [ ] (D) Las variantes hc_3 y aco_3 del repositorio, que modelan la congestión. No se nombran: la tesina no las describe en ningún lado. Decidir si se mencionan en el ítem de congestión de "Alcance del problema".
- [x] **A partir de la comparación con Coruzzolo et al.:**
  - Integrar el loteo, combinando la enumeración de lotes candidatos con rutas exactas o heurísticas.
  - Implementar su heurística (fecha de entrega más temprana más búsqueda local iterada) y medirla contra el óptimo del Split.

## 4. Conclusión justificada (7.3)

- [ ] **Que la conclusión general se apoye en lo anterior.** Hoy no remite a la discusión ni a las limitaciones. Por ejemplo: "dado lo discutido en 7.1, y considerando las limitaciones de 7.2, la recomendación vale para…".
- [ ] **Cerrar la comparación con Coruzzolo et al.** en la conclusión: donde ellos no pudieron medir la calidad de su heurística, acá se muestra qué tan cerca del óptimo quedan HC y ACO.
- [ ] **Párrafo de robustez** ("La robustez se evaluó con cinco semillas…"). Son resultados más que conclusión; evaluar si va a la Discusión.
- [ ] **Actualizar el resumen y escribir el abstract** con estas conclusiones (pendiente de la guía del capítulo).

## 5. Detalles menores de redacción

- [x] **7.1.1, primer párrafo:** "Cuando se cumple que las velocidades son iguales, la cadena de frío no restringe, y que no hay tiempos de servicio" → "Cuando las velocidades son iguales, la cadena de frío no restringe y no hay tiempos de servicio".
- [x] **7.1.1, tercer párrafo:** "al modelo que asigna y secuencia los mismos" → "al modelo que los asigna y secuencia".
- [x] **(D) Negritas de la Sección 7.2.** Ítems como "Camino simple." o "Lotes vacíos.": se sacaron y se reescribió el comienzo de cada párrafo (15/11).
- [x] **Conclusiones, ítem 4:** decía "38 casos de pruebas funcionales" y la guía del capítulo, 64. Los dos números son correctos: 38 casos que suman 64 pruebas (Sección 5.2; el monolítico corre 63). Ahora dice "38 casos de prueba funcionales, que suman 64 pruebas" (15/11).

---

(D) = decisión de ustedes.
