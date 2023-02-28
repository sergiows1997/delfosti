--eliminar tablas por si se encuentran errores--
DROP TABLE public.titulo;
DROP TABLE public.directores;
DROP TABLE public.actores;
DROP TABLE public.generos;
DROP TABLE public.pais;
DROP TABLE public.titulo_directores;
DROP TABLE public.titulo_actores;
DROP TABLE public.titulo_generos;
DROP TABLE public.titulo_pais;


--creación de tablas--
CREATE TABLE IF NOT EXISTS public.titulo
(
    titulo_id integer NOT NULL,
    tipo varchar(10) NOT NULL,
    titulo varchar(255) NOT NULL,
    fecha_ingreso date,
    fecha_estreno integer NOT NULL,
    clasificacion varchar(10),
    duracion varchar(50) NOT NULL,
    descripcion varchar(1000) NOT NULL,
    CONSTRAINT llave_titulo PRIMARY KEY (titulo_id),
	CONSTRAINT check_tipo CHECK (tipo IN('Movie','TV Show'))
);


CREATE TABLE IF NOT EXISTS public.directores
(
    director_id integer NOT NULL,
    nombre varchar(255),
    PRIMARY KEY (director_id)
);


CREATE TABLE IF NOT EXISTS public.titulo_directores
(
    titulo_id integer REFERENCES public.titulo (titulo_id) ON DELETE CASCADE,
    director_id integer REFERENCES public.directores (director_id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS public.actores
(
	actor_id integer NOT NULL,
	nombre varchar(255),
	PRIMARY KEY (actor_id)
);


CREATE TABLE IF NOT EXISTS public.titulo_actores
(
	titulo_id integer REFERENCES public.titulo (titulo_id) ON DELETE CASCADE,
	actor_id integer REFERENCES public.actores (actor_id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS public.generos
(
	genero_id integer NOT NULL,
	nombre varchar(255),
	PRIMARY KEY (genero_id)
);


CREATE TABLE IF NOT EXISTS public.titulo_generos
(
	titulo_id integer REFERENCES public.titulo (titulo_id) ON DELETE CASCADE,
	genero_id integer REFERENCES public.generos (genero_id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS public.pais
(
	pais_id integer NOT NULL,
	nombre varchar(255),
	PRIMARY KEY (pais_id)
);


CREATE TABLE IF NOT EXISTS public.titulo_pais
(
	titulo_id integer REFERENCES public.titulo (titulo_id) ON DELETE CASCADE,
	pais_id integer REFERENCES public.pais (pais_id) ON DELETE CASCADE
);

--carga de información a tablas--
COPY public.titulo(titulo_id, tipo, titulo, fecha_ingreso, fecha_estreno, clasificacion, duracion, descripcion)
FROM '/Users/sergiowong/Desktop/R Programming/delfosti/titulo.csv'
WITH (FORMAT CSV, HEADER);

COPY public.directores(director_id, nombre)
FROM '/Users/sergiowong/Desktop/R Programming/delfosti/directores.csv'
WITH (FORMAT CSV, HEADER);

COPY public.titulo_directores(titulo_id, director_id)
FROM '/Users/sergiowong/Desktop/R Programming/delfosti/titulo_director.csv'
WITH (FORMAT CSV, HEADER);

COPY public.actores(actor_id, nombre)
FROM '/Users/sergiowong/Desktop/R Programming/delfosti/actores.csv'
WITH (FORMAT CSV, HEADER);

COPY public.titulo_actores(titulo_id, actor_id)
FROM '/Users/sergiowong/Desktop/R Programming/delfosti/titulo_actor.csv'
WITH (FORMAT CSV, HEADER);

COPY public.generos(genero_id, nombre)
FROM '/Users/sergiowong/Desktop/R Programming/delfosti/generos.csv'
WITH (FORMAT CSV, HEADER);

COPY public.titulo_generos(titulo_id, genero_id)
FROM '/Users/sergiowong/Desktop/R Programming/delfosti/titulo_genero.csv'
WITH (FORMAT CSV, HEADER);

COPY public.pais(pais_id, nombre)
FROM '/Users/sergiowong/Desktop/R Programming/delfosti/paises.csv'
WITH (FORMAT CSV, HEADER);

COPY public.titulo_pais (titulo_id, pais_id)
FROM '/Users/sergiowong/Desktop/R Programming/delfosti/titulo_pais.csv'
WITH (FORMAT CSV, HEADER);
