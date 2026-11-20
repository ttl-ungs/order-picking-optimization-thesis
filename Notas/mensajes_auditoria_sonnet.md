# Mensajes para correr la auditoría por bloques (Sonnet)

Cómo usarlos:
1. Abrí una sesión nueva de Claude Code en la carpeta de la tesina (o hacé `/clear` entre un bloque y otro).
2. Poné `/model sonnet`.
3. Pegá UN mensaje. Esperá a que termine y revisá el archivo que genera antes de pasar al siguiente.

Orden sugerido por impacto: D → A+B → C → E → F+G+H.
Todos los mensajes se apoyan en `Notas/prompt_auditoria_tesina.md`, que tiene las fuentes, las secciones A–H y el formato de los hallazgos.

---

## 1. Bloque D: experimentos y resultados

```
Ejecutá SOLO la sección D de @Notas/prompt_auditoria_tesina.md, vos mismo, sin subagentes ni workflows. Ignorá la sección "Ejecución en paralelo".

Reglas:
- Solo lectura. El único archivo que podés crear es Notas/auditoria_D.md.
- NO ejecutes tests ni experimentos. Basate en lo que ya está guardado en el repo. Podés leer y procesar archivos de resultados existentes (python -c, awk, jq) para recalcular números.
- Código: rama main de /Users/lsoria/Desktop/tesina/linear-picking-routing. Si el repo no está en main y limpio, leé con "git -C <repo> show main:<ruta>".

Leé SOLO esto:
- Tesina: Capitulos/cap5.tex (metodología), Capitulos/cap6.tex (resultados), Apendices/ap7.tex (resultados detallados), Apendices/ap6.tex (verificación de soluciones). De resumen.tex, abstract.tex y cap7.tex, solo los párrafos que citan números o resultados (buscalos con grep).
- Repo: experiments/, scripts/, results/, analysis/. Los demás módulos (models/, etc.) consultalos solo puntualmente, para confirmar parámetros o valores por defecto.
- No leas los PDFs de zpaper.

Entregá en Notas/auditoria_D.md: hallazgos con el formato del prompt (severidad, archivo.tex:línea, evidencia, qué dice vs. qué es correcto, sugerencia), tabla experimento (tesina ↔ script ↔ archivo de resultados), tabla de números (valor en tesina ↔ valor en repo/recalculado ↔ coincide), experimentos o resultados no reportados, y qué no pudiste verificar.
```

---

## 2. Bloque A+B: veracidad y cobertura (tesina ↔ código)

```
Ejecutá SOLO las secciones A y B de @Notas/prompt_auditoria_tesina.md, vos mismo, sin subagentes ni workflows. Ignorá la sección "Ejecución en paralelo".

Reglas:
- Solo lectura. El único archivo que podés crear es Notas/auditoria_AB.md.
- NO ejecutes tests ni experimentos.
- Código: rama main de /Users/lsoria/Desktop/tesina/linear-picking-routing. Si el repo no está en main y limpio, leé con "git -C <repo> show main:<ruta>".

Leé SOLO esto:
- Tesina: Capitulos/cap3.tex (modelos lineales), Capitulos/cap4.tex (metaheurísticas), Capitulos/cap5.tex (metodología), Apendices/ap1.tex (diagramas), Apendices/ap3.tex (detalle de modelos lineales), Apendices/ap8.tex (detalle de metaheurísticas).
- Repo: README.md, conventions.md, meta.md, docs/, models/, dtos/, observer/, scripts/, examples/, verification/. Para B, empezá con "git ls-tree -r --name-only main" y leé en detalle solo lo que parezca relevante.
- No leas tests/, results/ ni los PDFs de zpaper: los cubren otros bloques.

Entregá en Notas/auditoria_AB.md: hallazgos con el formato del prompt (severidad, archivo.tex:línea, evidencia archivo:línea del código, qué dice vs. qué es correcto, sugerencia), lista de lo importante del repo que falta en la tesina (separando "debería estar" de "omitible", con justificación), y qué no pudiste verificar.
```

---

## 3. Bloque C: tests

```
Ejecutá SOLO la sección C de @Notas/prompt_auditoria_tesina.md, vos mismo, sin subagentes ni workflows. Ignorá la sección "Ejecución en paralelo".

Reglas:
- Solo lectura. El único archivo que podés crear es Notas/auditoria_C.md.
- NO ejecutes los tests. Los resultados se contrastan solo con evidencia guardada en el repo (logs, docs, README, CI). Si no hay, marcalo "no verificado (no se ejecutó)".
- Código: rama main de /Users/lsoria/Desktop/tesina/linear-picking-routing. Si el repo no está en main y limpio, leé con "git -C <repo> show main:<ruta>".

Leé SOLO esto:
- Tesina: Apendices/ap4.tex (pruebas funcionales), Apendices/ap6.tex (verificación de soluciones), y los fragmentos del resto de los .tex que mencionen tests (buscá con grep: test, prueba, pytest, unittest, verificación).
- Repo: tests/ completo, verification/ y .github/.
- No leas los PDFs de zpaper.

Entregá en Notas/auditoria_C.md: tabla test mencionado en la tesina → existe con ese nombre exacto (sí/no, nombre real más parecido) → qué dice la tesina que testea vs. qué verifican realmente los asserts → resultado informado vs. evidencia en el repo; tests del repo no mencionados (agrupados por archivo, marcando los importantes); discrepancias en cantidades; y qué no pudiste verificar.
```

---

## 4. Bloque E: bibliografía (sobre todo logistics-07-00061)

```
Ejecutá SOLO la sección E de @Notas/prompt_auditoria_tesina.md, vos mismo, sin subagentes ni workflows. Ignorá la sección "Ejecución en paralelo".

Reglas:
- Solo lectura. El único archivo que podés crear es Notas/auditoria_E.md.
- NO ejecutes tests ni experimentos.
- Los PDF se leen con Read y el parámetro pages (máximo 20 páginas por llamada).

Leé SOLO esto:
- logistics-07-00061 (1).pdf completo.
- Tesina: Capitulos/cap1.tex, Capitulos/cap2.tex (marco teórico y estado del arte), Capitulos/cap7.tex, y la bibliografía en Referencias/. Del resto de los .tex, solo los fragmentos que citan ese paper (buscá su clave de cita con grep).
- Resto de zpaper: NO los leas completos. Para cada cita de la tesina, abrí solo las páginas pertinentes del PDF correspondiente. Los libros largos (aco-book, hillier_lieberman, sls_handbook, Metaheuristics, etc.) consultalos solo en la sección relevante.
- Código del repo: solo si la tesina dice que implementa o adapta algo del paper, para confirmar que coincide.

Entregá en Notas/auditoria_E.md: hallazgos con el formato del prompt (severidad, archivo.tex:línea, evidencia con página del paper, qué dice vs. qué es correcto, sugerencia); evaluación de las comparaciones con el paper (¿mismas instancias, métricas y supuestos?); afirmaciones sin cita; citas a entradas inexistentes o entradas no citadas; y qué no pudiste verificar (indicando qué PDFs consultaste y en qué páginas).
```

---

## 5. Bloque F+G+H: conceptos, estilo, redundancias y ToDos

```
Ejecutá SOLO las secciones F, G y H de @Notas/prompt_auditoria_tesina.md, vos mismo, sin subagentes ni workflows. Ignorá la sección "Ejecución en paralelo".

Reglas:
- Solo lectura. El único archivo que podés crear es Notas/auditoria_FGH.md.
- No recompiles la tesina.

Leé SOLO esto:
- Tesina: tesina.tex, Capitulos/resumen.tex, Capitulos/abstract.tex, Capitulos/cap1.tex a cap7.tex, Apendices/*.tex. Ignorá Capitulos/plantilla.tex (no está incluido desde tesina.tex).
- Guias/context_style_guide.md y Notas/pendientes_cap7.md.
- tesina.log, solo para buscar referencias o citas indefinidas (grep: undefined, unknown, warning).
- No leas el repo de código ni los PDFs de zpaper. Si un concepto depende del código, anotalo como "a verificar en A+B".

Entregá en Notas/auditoria_FGH.md: hallazgos con el formato del prompt (severidad, archivo.tex:línea, qué dice vs. qué es correcto, sugerencia); repeticiones con las dos ubicaciones; diferencias entre resumen y abstract; incumplimientos de la guía de estilo; referencias cruzadas rotas; estado de cada ítem de pendientes_cap7.md (resuelto / parcial / pendiente, con evidencia); lista de marcadores TODO/ToDo/\todo/XXX/FIXME/??/pendiente/placeholder con ubicación.
```
