Prueba para crear galería 

	{% assign image_files = site.static_files | where: "image", true | sort: 'basename' | reverse | where_exp:"item",
"item.extname contains 'png'"  %}
	{% for myimage in image_files %}
	 	 <img class="item" src="{{ myimage.path | prepend: site.microsite }}">
	{% endfor %}	
