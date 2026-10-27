---
title: "COVID-19 en España"
subtitle: "Archivo de visualizaciones históricas"
show_toc: true
h_max: 2
header_img: "assets/img/header.png"
excerpt: Mapas y gráficos históricos sobre la COVID-19 en España. Proyecto sin actualizaciones.
project_links:
    - url: https://github.com/dieghernan/COVID19/
      icon: fab fa-github my-2
      label: Ver en GitHub
output: 
  md_document:
    preserve_yaml: true
---

*Datos publicados a 09 abril 2020*

El proyecto
-----------

**Proyecto obsoleto**: Debido a los cambios en el aprovisionamiento de
la información, este proyecto se considera obsoleto y no recibirá más
actualizaciones. 
{: .alert .alert-danger .p-3 .mx-2 mb-3}

Proyecto de código abierto de visualización geográfica de la evolución de la
pandemia COVID-19 en España. Se proporcionan gráficos estáticos en
formato PNG (500 × 500 píxeles) y visualizaciones de evolución en formato
GIF. La página conserva mapas históricos y ya no se actualiza. El archivo de
imágenes PNG diarias se encuentra en [este
repositorio](https://github.com/dieghernan/COVID19/tree/master/assets/png).

-   [Datos históricos](#últimos-datos)
-   [Evolución](#evolución)

[Consultar los datos históricos del repositorio](https://github.com/dieghernan/COVID19/tree/master/assets/data).

**Fuente de datos**

-   Datos oficiales proporcionados por el [Instituto de Salud Carlos III
    (ISCIII)](https://covid19.isciii.es/).
-   © EuroGeographics para los límites administrativos.
-   Datos de población extraídos mediante el paquete
    [`eurostat`](http://ropengov.github.io/eurostat) (© Leo Lahti, Janne
    Huovari, Markus Kainu, Przemyslaw Biecek. Retrieval and analysis of
    Eurostat open data with the eurostat package. [R Journal
    9(1):385-392, 2017.](https://journal.r-project.org/archive/2017/RJ-2017-019/index.html))

**Licencia de uso**

Proyecto generado bajo [**MIT License**](https://github.com/dieghernan/COVID19/blob/master/LICENSE). Se permite la
reutilización siempre y cuando se cite a este repositorio como fuente.

**Buzón de sugerencias**

Este proyecto se plantea como un proyecto colaborativo. Para sugerencias
de nuevas visualizaciones, errores en los datos o cualquier otro asunto
relacionado con este proyecto, puedes ponerte en contacto con los
administradores a través de este enlace:
[Buzón](https://github.com/dieghernan/COVID19/issues/new/choose).

Datos históricos
----------------
{: id="últimos-datos"}

### Casos por situación en España
{: id="total-casos-por-situación-en-españa"}

![Mapa histórico de casos de COVID-19 por comunidad autónoma, con recuperados, casos activos y fallecidos. La imagen muestra el 8 de abril de 2020.](./assets/CasosAct.png)

### Hospitalizaciones por 100.000 habitantes
{: id="hospitalizados-por-100000-habitantes"}

![Mapa histórico de hospitalizaciones por 100.000 habitantes en España.](./assets/RatioHospAct.png)

### Contagios en España

![Mapa histórico de contagios de COVID-19 en España.](./assets/ContagiosAct.png)

### Fallecidos en España

![Mapa histórico de fallecimientos por COVID-19 en España.](./assets/FallecidosAct.png)

Evolución
---------

Las animaciones muestran datos históricos. Para consultar imágenes fijas,
utiliza la [galería de mapas]({{ '/Galeria' | relative_url }}).

### Evolución de los casos en España
{: id="evolución-casos-en-españa"}

![Animación histórica de los casos de COVID-19 en España.](./assets/Casos.gif)

### Evolución de las hospitalizaciones por 100.000 habitantes
{: id="evolución-hospitalizados-por-100000-habitantes"}

![Animación histórica de hospitalizaciones por 100.000 habitantes en España.](./assets/RatioHosp.gif)

### Evolución de los contagios en España
{: id="evolución-contagios-en-españa"}

![Animación histórica de contagios de COVID-19 en España.](./assets/Contagios.gif)

### Evolución de los fallecimientos en España
{: id="evolución-fallecidos-en-españa"}

![Animación histórica de fallecimientos por COVID-19 en España.](./assets/Fallecidos.gif)

------------------------------------------------------------------------

*Generado {% include snippets/datetranslate.html  date="22 July 2020
17:27:34 CEST" %} con* **RStudio**.
