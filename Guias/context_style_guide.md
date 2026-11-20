# Guía de Estilos ConTeXt para la Tesis (Linear Picking Routing)

> **Copia de `docs/guides/context_style_guide.md` del repositorio de código (`ttl-ungs/linear-picking-routing`).** Si la guía cambia allá, hay que actualizar esta copia a mano.
>
> En la tesina, la cabecera de la sección 8 ya la aplica `entorno.tex`, que carga `tesina.tex` con `\environment entorno`. Los capítulos y anexos (`Capitulos/`, `Apendices/`) se incluyen con `\input` y **no** llevan esa cabecera ni `\starttext`/`\stoptext`: empiezan directamente con `\startchapter`.

Este documento especifica los lineamientos estéticos, de diseño y estructuración para la generación de todos los documentos `.tex` (en formato **ConTeXt**) de la tesis. Todo nuevo código generado deberá apegarse estrictamente a estas definiciones para mantener coherencia visual y tipográfica.

## 1. Configuración de Página y Tipografía General
* **Tamaño de papel:** A4 (`\setuppapersize[A4][A4]`)
* **Márgenes y Layout:** Centrado con márgenes superior e inferior de 2cm (`\setuplayout[width=middle, height=middle, topspace=2cm, bottomspace=2cm]`)
* **Fuente principal:** 11pt (`\setupbodyfont[11pt]`)

## 2. Paleta de Colores
Se debe inicializar el uso de colores al principio del documento (`\setupcolors[state=start]` y `\setupcolor[hex]`). Los colores oficiales son:
* **`darkblue` (`#003366`):** Uso exclusivo para títulos de secciones (`\startsection`), curvas y puntos de los modelos exactos (monolítico y Split) en los gráficos.
* **`darkgray` (`#e6e6e6`):** Uso exclusivo para el fondo de la primera fila (encabezados) en las tablas.
* **`redline` (`#d9534f`):** Uso para curvas de tendencia o gráficos relacionados con el modelo monolítico bajo estrés, y barras/áreas de "Solver" en gráficos de perfilado.
* **`blueline` (`#5bc0de`):** Uso para curvas de regresión lineal genéricas o desempeño de Hill Climbing (HC).
* **`greenline` (`#5cb85c`):** Uso exclusivo para curvas de desempeño de la metaheurística Ant Colony Optimization (ACO).

## 3. Jerarquía de Títulos
* **Título Principal del Documento:** Utilizar el comando `\title{\bf Título...}` seguido de un `\blank[big]`.
* **Secciones (`\startsection`):** Estilo bold y tamaño aumentado (`\bfa`), color `darkblue`. Con espacios antes y después (`before=\blank, after=\blank`).
* **Subsecciones (`\startsubsection`):** Estilo bold normal (`\bf`), color `black`. Con espacios antes y después (`before=\blank, after=\blank`).
* **Sub-subsecciones (`\startsubsubsection`):** Misma regla que las subsecciones (si son necesarias), manteniendo consistencia.

## 4. Estilo de Tablas (`\bTABLE ... \eTABLE`)
* **Configuración global de la tabla:** `split=yes, align=middle, frame=on, width=fit` (o `width=broad` si debe ocupar más ancho).
* **Encabezado (Fila 1):** Obligatorio usar fondo gris oscuro y texto en negrita: `\setupTABLE[row][1][background=color, backgroundcolor=darkgray, style=bold]`.
* **Estructura:** Uso estándar de `\bTR`, `\bTH` (para encabezados), `\bTD` (para celdas) y `\eTR`.

## 5. Gráficos Vectoriales (MetaPost)
Todos los gráficos de desempeño o perfiles de ejecución deben ser generados programáticamente usando MetaPost dentro de bloques `\startMPcode ... \stopMPcode` envueltos en `\placefigure[force][fig:identificador]{Título}`.

**Lineamientos de dibujo en MetaPost:**
* **Ejes:** Flechas con grosor de 1pt (`drawarrow ... withpen pencircle scaled 1pt`).
* **Líneas / Curvas:** Grosor de 1.5pt (`withpen pencircle scaled 1.5pt`), usando colores de la paleta mediante `\MPcolor{...}` (ej. `withcolor \MPcolor{redline}`). Las líneas continuas se hacen con interacciones spline (`..`) o rectas (`--`). Las líneas de tendencia pueden ir punteadas (`dashed evenly`).
* **Puntos de datos:** Círculos rellenos de 4pt (`fill fullcircle scaled 4pt shifted (x,y) withcolor \MPcolor{darkblue}`).
* **Texto y Etiquetas:** Uso de `textext("...")` para inyectar texto tipográfico. Las etiquetas de los ejes se colocan con `label.bot`, `label.lft`, `label.rt`, etc., y deben indicar claramente la magnitud y su unidad.

## 6. Listas e Ítems
* Las enumeraciones u viñetas se realizan con `\startitemize[n]` (para numeradas) o sin `[n]` (para viñetas).
* Se recomienda destacar el concepto clave al inicio de cada ítem en negrita: `\item {\bf Concepto Clave:} Explicación...`

## 7. Espaciado y Formato de Bloque
* Usar `\blank` para separaciones de párrafo estándar.
* Usar `\blank[medium]` o `\blank[big]` para transiciones más notables (e.g., antes de una tabla o tras el título principal).
* Para fórmulas matemáticas aisladas, usar siempre el entorno `\startformula ... \stopformula`.

## 8. Plantilla Base (Boilerplate Header)
Todo nuevo archivo `.tex` debe comenzar exactamente con la siguiente cabecera de configuración:

```tex
\setupcolors[state=start]
\setupcolor[hex]
\definecolor[darkblue][h=003366]
\definecolor[darkgray][h=e6e6e6]
\definecolor[redline][h=d9534f]
\definecolor[blueline][h=5bc0de]
\definecolor[greenline][h=5cb85c]

\setuphead[section][style=\bfa, color=darkblue, before=\blank, after=\blank]
\setuphead[subsection][style=\bf, color=black, before=\blank, after=\blank]
\setuppapersize[A4][A4]
\setupbodyfont[11pt]
\setuplayout[width=middle, height=middle, topspace=2cm, bottomspace=2cm]

\starttext
\title{\bf Título}
\blank[big]

% ... introducción ... 

\blank

% ... contenido ...
\stoptext