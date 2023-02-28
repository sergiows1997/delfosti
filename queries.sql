--query 1: titulos con mayor duración de tiempo--
SELECT titulo,
	fecha_estreno,
	clasificacion,
	cast(SPLIT_PART(duracion,' ',1) AS integer) as minutos
FROM public.titulo
WHERE tipo = 'Movie'
ORDER BY minutos DESC
LIMIT 10;

--query 2: titulos con temporadas más largas--
SELECT titulo,
	fecha_estreno,
	clasificacion,
	cast(SPLIT_PART(duracion,' ',1) AS integer) as temporadas
FROM public.titulo
WHERE tipo = 'TV Show'
ORDER BY temporadas DESC
LIMIT 10;

--query 3: titulo, fecha de estreno, clasificacion, directores y actores de los 50 títulos mas recientes
SELECT a.titulo,
	a.fecha_estreno,
	a.clasificacion,
	d.directores,
	a.actores
FROM (SELECT t.titulo,
	t.fecha_estreno,
	t.clasificacion,
	string_agg(a.nombre, ',') as actores
	FROM public.titulo t 
	JOIN public.titulo_actores ta
	ON t.titulo_id = ta.titulo_id
	JOIN public.actores a
	ON ta.actor_id = a.actor_id
	GROUP BY 1,2,3
	ORDER BY t.titulo) a
INNER JOIN (SELECT t.titulo,
	t.fecha_estreno,
	t.clasificacion,
	string_agg(d.nombre, ',') as directores
	FROM public.titulo t
	JOIN public.titulo_directores td
	ON t.titulo_id = td.titulo_id
	JOIN public.directores d
	ON td.director_id = d.director_id
	GROUP BY 1,2,3
	ORDER BY t.titulo) d
ON a.titulo = d.titulo
ORDER BY 2 DESC
LIMIT 50;