---
title: "COVID19 en España"
subtitle: "Visualización de datos"
show_toc: true
h_max: 2
header_img: "assets/img/header.png"
excerpt: Projecto Open Source de visualización geográfica de la evolución de la pandemia COVID19 en España
project_links:
    - url: https://github.com/dieghernan/COVID19/
      icon: fab fa-github
      label: Ver en Github
output: 
  md_document:
    preserve_yaml: true
---

**Proyecto obsoleto**: Debido a los cambios en el aprovisionamiento de
la información, este proyecto se considera obsoleto y no recibirá mas
actualizaciones. 
{: .alert .alert-danger .p-3 .mx-2 mb-3}

*Datos publicados a {% include snippets/datetranslate.html date='09
April' %}*

El proyecto
-----------

Projecto Open Source de visualización geográfica de la evolución de la
pandemia COVID19 en España. Se proporcionan gráficos estáticos en
formato `png` (500x500 pixels) y visualizaciones de evolución en formato
`gif`. La página se actualiza una vez al día y muestra los mapas más
recientes, el histórico de `png` diarios se encuentran en [este
repositorio](https://github.com/dieghernan/COVID19/tree/master/pngs).

-   [Últimos datos](#últimos-datos)
-   [Evolución](#evolución)

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

Projecto generado bajo [**MIT License**](./LICENSE). Se permite la
reutilización siempre y cuando se cite a este repositorio como fuente.

**Buzón de sugerencias**

Este proyecto se plantea como un proyecto colaborativo. Para sugerencias
de nuevas visualizaciones, errores en los datos o cualquier otro asunto
relacionado con este proyecto, puedes ponerte en contacto con los
administradores a través de este enlace:
[Buzón](https://github.com/dieghernan/COVID19/issues/new/choose).

Últimos datos
-------------

##### Total Casos por situación en España

![](./assets/CasosAct.png)

##### Hospitalizados por 100.000 habitantes

![](./assets/RatioHospAct.png)

##### Contagios en España

![](./assets/ContagiosAct.png)

##### Fallecidos en España

![](./assets/FallecidosAct.png)

Evolución
---------

##### Evolución Casos en España

![](./assets/Casos.gif)

##### Evolución Hospitalizados por 100.000 habitantes

![](./assets/RatioHosp.gif)

##### Evolución Contagios en España

![](./assets/Contagios.gif)

##### Evolución Fallecidos en España

![](./assets/Fallecidos.gif)

------------------------------------------------------------------------

*Generado {% include snippets/datetranslate.html date='22 July 2020
17:27:34 CEST' %} con* **R-Studio**.
