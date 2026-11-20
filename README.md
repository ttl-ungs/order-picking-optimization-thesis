# Optimización del picking y del ruteo de pedidos en un centro de distribución

Tesina de la Licenciatura en Sistemas, Instituto de Industria (IDEI), Universidad Nacional de General Sarmiento (UNGS).

- **Autoras:** Ximena Ebertz y Lucía Soria
- **Supervisor:** Enrique Fernández
- **PDF:** [ebertz-soria-2026-optimizacion-picking-ruteo.pdf](ebertz-soria-2026-optimizacion-picking-ruteo.pdf)
- **Código de los modelos y de las pruebas:** [ttl-ungs/order-picking-optimization](https://github.com/ttl-ungs/order-picking-optimization)

> *English:* ConTeXt source of our undergraduate thesis on the order picking problem: assigning batches of orders to pickers with heterogeneous speeds, sequencing them and routing each batch through the warehouse, under a cold-chain limit. Two mixed-integer models (monolithic and a two-stage Split) are compared with Hill Climbing and Ant Colony Optimization. The thesis is written in Spanish.

## Resumen

El trabajo aborda el problema de preparación de pedidos (OPP): asignar lotes de pedidos a operarios, decidir en qué orden los ejecuta cada uno y armar la ruta de recolección en el almacén, minimizando los instantes de finalización y las penalidades por adelanto o demora. Se formula un modelo de programación lineal entera mixta (el *monolítico*), con velocidades distintas entre operarios y restricciones de cadena de frío, y se lo descompone en dos etapas (el modelo *Split*). Para instancias más grandes se desarrollan dos metaheurísticas, *Hill Climbing* y *Ant Colony Optimization*, y los cuatro métodos se comparan sobre 38 casos funcionales y 19 escenarios de estrés.

## Compilar

La tesina está escrita en [ConTeXt](https://wiki.contextgarden.net/) (LMTX). Desde la raíz del repositorio:

```bash
context --result=ebertz-soria-2026-optimizacion-picking-ruteo tesina.tex
```

## Estructura

| Ruta | Contenido |
|---|---|
| `tesina.tex` | Archivo principal: portada, páginas preliminares y orden de los capítulos |
| `entorno.tex` | Diseño, siglas, glosario, cuadros y estilo de la bibliografía |
| `Capitulos/` | Resumen, abstract y capítulos 1 a 7 |
| `Apendices/` | Anexos A a F |
| `Referencias/tesina.bib` | Bibliografía |
| `Figuras/` | Imágenes (logo de la portada) |
| `Guias/` | Guía de estilo de ConTeXt |
| `ebertz-soria-2026-optimizacion-picking-ruteo.pdf` | PDF compilado |
