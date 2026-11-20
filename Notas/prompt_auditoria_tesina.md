# Tarea: auditoría integral de la tesina (solo lectura, NO editar nada)

Sos revisor/a técnico/a y académico/a de una tesina sobre optimización de rutas de picking.
Tu trabajo es VALIDAR, no corregir: no modifiques ningún archivo, no hagas commits ni cambies de rama.
El resultado es un informe de hallazgos.

## Ejecución en paralelo

Usá un workflow (o subagentes en paralelo) con estos 5 revisores independientes, cada uno con
todas las secciones de "Fuentes" pero enfocado solo en su parte (las letras corresponden a las
secciones de "Qué validar"):

1. **A + B**: veracidad y cobertura (tesina ↔ código)
2. **C**: tests
3. **D**: experimentos y resultados
4. **E**: bibliografía (sobre todo logistics-07-00061)
5. **F + G + H**: conceptos, estilo, redundancias y ToDos

Después, un agente final junta los cinco informes de auditoría de Notas (auditoría_D.md, auditoría_AB.md, auditoría_C.md,
auditoría_D.md, auditoría_FGH.md), elimina duplicados, verifica cada hallazgo
Crítico o Mayor contra la fuente (y descarta los que no se sostienen) y arma el informe único con
el formato de "Formato del informe" de Notas/prompt_auditoria_tesina.md. Guardá el informe en `Notas/informe_auditoria.md`; es el
único archivo que se puede escribir.

## Fuentes (leer en profundidad, completas, no por muestreo)

1. **Tesina (LaTeX)**: `/Users/lsoria/Desktop/tesina/picking-route-optimization-thesis`
   - `tesina.tex`, `Capitulos/` (resumen, abstract, cap1–cap7), `Apendices/` (ap1, ap3–ap8)
   - `Guias/context_style_guide.md` → guía de estilo que la tesina debe respetar
   - `Notas/pendientes_cap7.md` → lista de ToDos/pendientes
   - Podés usar `tesina.pdf` para verificar figuras, tablas y numeración.
2. **Código**: `/Users/lsoria/Desktop/tesina/linear-picking-routing`, **rama `main`**.
   Leé desde main sin hacer checkout que altere el working tree (usá `git -C ... show main:<ruta>`,
   `git ls-tree -r main`, o un `git worktree add` en un directorio temporal).
   Revisá todo: `README.md`, `conventions.md`, `meta.md`, `docs/`, `models/`, `dtos/`, `observer/`,
   `scripts/`, `examples/`, `experiments/`, `results/`, `analysis/`, `verification/`, `tests/`, `.github/`.
3. **Bibliografía**: `/Users/lsoria/Desktop/tesina/zpaper`. Prestá **especial atención** a
   `logistics-07-00061 (1).pdf`: leelo completo y entendé su modelo, supuestos, notación, algoritmos,
   instancias y resultados.

## Qué validar

### A. Veracidad: tesina contra código
Para cada afirmación técnica de la tesina (modelos, formulaciones, restricciones, parámetros,
heurísticas/metaheurísticas, complejidad, decisiones de diseño, arquitectura, valores por defecto,
métricas), verificá que coincida con lo implementado en main. Citá `archivo:línea` del código y
la sección/línea del `.tex`. Señalá fórmulas cuya notación o lógica difiera del código.

### B. Cobertura: código contra tesina
Listá todo lo **importante** del repositorio que no aparece en la tesina (módulos, algoritmos,
variantes, experimentos, scripts de análisis, herramientas de verificación, resultados relevantes).
Distinguí entre "debería estar" y "detalle de implementación que puede omitirse", y justificá.

### C. Tests
- Armá una tabla: cada test mencionado en la tesina → ¿existe con **ese nombre exacto** en `tests/`?
- ¿Lo que la tesina dice que testea coincide con lo que realmente verifica el código del test?
- ¿Los resultados informados (pasa/falla, cantidades, coberturas) son consistentes?
  Si es seguro y barato, ejecutá la suite en un entorno aislado (venv o worktree) para confirmarlo;
  si no la ejecutás, decilo explícitamente.
- Listá los tests del repo que la tesina no menciona.

### D. Experimentos y resultados
- Para cada experimento de la tesina: el nombre, la configuración (instancias, parámetros, semillas,
  repeticiones, hardware/tiempos) y el script que lo genera, ¿coinciden con `experiments/` y `scripts/`?
- Cada número de tablas y figuras, ¿coincide con los archivos de `results/` y `analysis/`?
  Recalculá promedios, desvíos, gaps y porcentajes cuando sea posible.
- ¿Las conclusiones que saca la tesina se sostienen con esos datos?
- Listá los experimentos o resultados del repo que no están reportados.

### E. Relación con la bibliografía (sobre todo logistics-07-00061)
- ¿La tesina describe correctamente ese paper (modelo, supuestos, aportes, resultados)?
- ¿Las diferencias y similitudes que plantea entre el paper y este trabajo son correctas y completas?
- ¿Las comparaciones de resultados son justas (mismas instancias, métricas y supuestos)?
- Para el resto de `zpaper`: ¿las citas, definiciones y atribuciones de la tesina son fieles a las
  fuentes? Marcá afirmaciones que necesitan una cita y no la tienen.

### F. Conceptos
- Definiciones incorrectas, imprecisas o usadas de forma inconsistente (por ejemplo TSP/ATSP,
  heurística vs. metaheurística, óptimo vs. cota, ACO/MMAS, Or-opt, picker, pasillo, congestión).
- Términos o símbolos que se usan antes de definirse, o con dos nombres distintos.
- Notación matemática inconsistente entre capítulos y apéndices.

### G. Estilo, repeticiones y redundancias
- Revisá el cumplimiento de `Guias/context_style_guide.md`.
- Ideas o párrafos repetidos entre capítulos (en especial resumen/abstract vs. cap1 vs. cap7),
  frases redundantes y explicaciones que se dan dos veces.
- Pasajes mal explicados, saltos lógicos, ambigüedades y párrafos demasiado densos.
- Consistencia entre resumen y abstract (que digan lo mismo).
- Errores de español, mezcla de idiomas, uso de tiempos verbales y referencias cruzadas
  (`\ref`, `\cite`) rotas o incorrectas.

### H. ToDos
- Revisá cada ítem de `Notas/pendientes_cap7.md`: ¿está resuelto en la tesina, parcialmente
  resuelto o pendiente? Dá la evidencia.
- Buscá en todos los `.tex` marcadores como `TODO`, `ToDo`, `\todo`, `XXX`, `FIXME`, `??`,
  `pendiente` y texto placeholder, y listalos con su ubicación.

## Formato del informe

1. **Resumen ejecutivo**: los 10 problemas más graves.
2. **Hallazgos por sección (A–H)**, cada uno con:
   - Severidad: Crítico (falso o contradice el código o los datos) / Mayor (omisión o explicación
     errónea importante) / Menor (estilo, redundancia, precisión)
   - Ubicación en la tesina (`archivo.tex:línea`) y evidencia (`archivo:línea` del código, archivo de
     resultados, o página del paper)
   - Qué dice la tesina vs. qué es lo correcto
   - Sugerencia concreta de corrección (solo como texto, sin aplicarla)
3. **Tablas de trazabilidad**: tests (tesina ↔ repo), experimentos (tesina ↔ scripts ↔ resultados)
   y números de tablas y figuras (valor en tesina ↔ valor recalculado).
4. **Estado de los ToDos.**
5. **Qué no pudiste verificar y por qué.**

Reglas: no inventes. Si algo no se puede confirmar, marcalo como "no verificado". Priorizá la
exhaustividad sobre la velocidad. Antes de concluir que algo falta, buscá en todo el repo.
