# Empiezo llamando las librarías a utilizar
library(dplyr)
library(ggplot2)
library(tidyverse)
library(lubridate)


# Se cargan los datos
netflixdata <- read.csv('netflix_titles.csv')

# Revisamos estructura del set de datos
str(netflixdata)

# Quitamos la "s" del ID
netflixdata$show_id <- gsub("s","",netflixdata$show_id)

# Lo hacemos numerico
netflixdata$show_id <- as.numeric(netflixdata$show_id)

# Revisamos variable Rating
unique(netflixdata$rating)

# Error en datos digitados en la columna de rating en lugar de duración
# Revisamos clase de la columna
class(netflixdata$duration)

# Hacemos el cambio
netflixdata[netflixdata$director == "Louis C.K.","rating"]
netflixdata[netflixdata$director == "Louis C.K.","duration"] <- c("74 min","84 min","66 min")
netflixdata[netflixdata$director == "Louis C.K.","rating"] <- c("","","")

# Convertimos en factor la variable Rating
netflixdata$rating <- as.factor(netflixdata$rating)

# Número de titulos por clasificación
n_title_rating <- netflixdata %>% group_by(rating) %>% 
  summarise(total = n())

# Grafico de barras de clasificación
ggplot(n_title_rating, mapping = aes(x = rating, y = total, fill = rating)) +
  geom_col()

# Convertimos en fecha la variable date_added
netflixdata$date_added <- mdy(netflixdata$date_added)

# Visualizaciones
# grafico de barras de titulos por tipo: Movie o TV Show
ggplot(netflixdata, mapping = aes(x = type, fill = type)) +
  geom_bar()

# grafico fecha de estreno
ggplot(netflixdata, mapping = aes(x = release_year, fill = type)) +
  geom_bar() +
  scale_x_continuous(n.breaks = 25)




# Se piden al menos 3 tablas.
# Se creará 1 tabla del título de la película con el resto de su información, 
# otra sobre los directores, otra sobre los actores que participaron en dicho título.
# Adicionalmente se crearan tablas de los géneros, como también del país perteneciente


# Se empezará creando una lista de todos los directores para asignarles un ID único

# Se calcula la cantidad de directores por película contando las separaciones en la columna 'Director'
# y se le suma un 1 para compensar el director restante.
netflixdata$n_directores <- str_count(netflixdata$director, ',') + 1

# Se calcula la mayor cantidad de directores en un titulo
max(netflixdata$n_directores)
# Número máximo de directores es 13

# Cantidad de titulos con n directores
n_directores <- netflixdata %>% 
  group_by(n_directores) %>% 
  summarise(total = n())

# Histograma de distribución de la cantidad de directores por título
ggplot(n_directores, mapping = aes(x = n_directores, y = total)) +
  geom_col()
  
# Separamos la columna de directores en diferentes filas
pelicula_director <- netflixdata %>% separate_rows(director, sep = ',')

# Ordenar lista por orden alfabético
pelicula_director <- pelicula_director %>% arrange(director)

# Director que más aparece
directorfreq<- pelicula_director %>% group_by(director) %>% 
  summarise(total = n())

# Creamos dataframe de directores únicos
directores <- as.data.frame(unique(pelicula_director$director))

# Añadimos ID a cada Director
directores$ID <- seq.int(nrow(directores))

# Cambiamos nombre de columna 
colnames(directores) <- c('director','directorId')

# Ordenamos columnas
directores <- directores %>% select(directorId,director)




# Ahora comenzaré con la lista de los actores para asignarles un ID único
netflixdata$n_actores <- str_count(netflixdata$cast, ',') + 1

# Se calcula el la mayor cantidad de actores en un titulo
max(netflixdata$n_actores)
# Numero máximo es 50

# Cantidad de títulos con n actores
n_actores <- netflixdata %>% 
  group_by(n_actores) %>% 
  summarise(total = n())

# Histograma distribución de la cantidad de actores por título
ggplot(n_actores, mapping = aes(x = n_actores, y = total)) +
  geom_col()

# Separamos la columna de actores en diferentes filas
pelicula_actor <- netflixdata %>% separate_rows(cast, sep = ',')

# Ordenar lista por orden alfabético
pelicula_actor <- pelicula_actor %>% arrange(cast)

# Actor que más aparece
actorfreq <- pelicula_actor %>% 
  group_by(cast) %>% 
  summarise(total = n())

# Creamos dataframe de actores únicos
actores <- as.data.frame(unique(pelicula_actor$cast))

# Añadimos ID. a cada Actor
actores$ID <- seq.int(nrow(actores))

# Cambiamos nombre de columna
colnames(actores) <- c('cast','actorId')

# Ordenamos columnas
actores <- actores %>% select(actorId,cast)




# Seguimos con el género 
netflixdata$n_generos <- str_count(netflixdata$listed_in,',') + 1
max(netflixdata$n_generos)
# El máximo número de géneros por título es de 3

n_generos <- netflixdata %>% 
  group_by(n_generos) %>% 
  summarise(total = n())

# Histograma distribución de la cantidad de género por título
ggplot(n_generos, mapping = aes(x = n_generos, y = total)) +
  geom_col()

# Separamos géneros en diferente filas
pelicula_genero <- netflixdata %>% separate_rows(listed_in, sep = ',')

# Ordenar lista por orden alfabético
pelicula_genero <- pelicula_genero %>% arrange(listed_in)

# Género que más aparece 
generofreq <- pelicula_genero %>% 
  group_by(listed_in) %>%
  summarise(total = n())

# Creamos dataframe de géneros únicos
generos <- as.data.frame(unique(pelicula_genero$listed_in))

# Añadimos ID. a cada género
generos$ID <- seq.int(nrow(generos))

# Cambiamos nombre de columna
colnames(generos) <- c('listed_in','genreId')

# Ordenamos columnas
generos <- generos %>% select(genreId,listed_in)





# Terminamos con el país
netflixdata$n_pais <- str_count(netflixdata$country,',') + 1
max(netflixdata$n_pais)
# El máximo número de paises por título es de 12

n_paises <- netflixdata %>% 
  group_by(n_pais) %>% 
  summarise(total = n())

# Histograma distribución de la cantidad de países por título
ggplot(n_paises, mapping = aes(x=n_pais, y = total)) +
  geom_col()

# Separamos países en diferentes filas
pelicula_pais <- netflixdata %>% separate_rows(country, sep = ',')

# Ordenar lista por orden alfabetico
pelicula_pais <- pelicula_pais %>% arrange(country)

# País que más aparece
paisfreq <- pelicula_pais %>% 
  group_by(country) %>% 
  summarise(total = n())

# Creamos dataframe de países únicos
paises <- as.data.frame(unique(pelicula_pais$country))

# Añadimos ID. a cada país
paises$ID <- seq.int(nrow(paises))

# Cambiamos nombre de columna
colnames(paises) <- c('country', 'countryId')

# Ordenamos columnas
paises <- paises %>% select(countryId, country)







# Datos para tabla intermedia: pelicula_director
p_d <- pelicula_director[,c(1,4)]
titulo_director <- merge(p_d,directores,by = 'director', all.x = TRUE)
titulo_director <- titulo_director[,c(2,3)]

# Datos para tabla intermedia: pelicula_actor
p_a <- pelicula_actor[,c(1,5)]
titulo_actor <- merge(p_a, actores, by = 'cast', all.x = TRUE)
titulo_actor <- titulo_actor[,c(2,3)]


# Datos para tabla intermedia: pelicula_actor
p_g <- pelicula_genero[,c(1,11)]
titulo_genero <- merge(p_g, generos, by = 'listed_in', all.x = TRUE)
titulo_genero <- titulo_genero[,c(2,3)]

# Datos para tabla intermedia: pelicula_pais
p_p <- pelicula_pais[,c(1,6)]
titulo_pais <- merge(p_p, paises, by = 'country', all.x = TRUE)
titulo_pais <- titulo_pais[,c(2,3)]



# Crear tabla de títulos
titulo <- netflixdata[,c(1:3,7:10,12)]


str(titulo)
# Existen valores inexistentes (NA) en dia de ingreso
no_date <- which(is.na(titulo$date_added))

# Agregar el valor del promedio a dichos titulos
titulo[no_date, 'date_added'] <- mean.Date(titulo$date_added, na.rm =TRUE)


# Importar archivos a base de datos mediante archivos csv.
write.csv(titulo,file = 'titulo.csv', row.names = FALSE)
write.csv(directores, file = 'directores.csv',row.names = FALSE)
write.csv(titulo_director, file = 'titulo_director.csv', row.names = FALSE)
write.csv(actores, file = 'actores.csv', row.names = FALSE)
write.csv(titulo_actor, file='titulo_actor.csv', row.names = FALSE)
write.csv(generos, file = 'generos.csv', row.names = FALSE)
write.csv(titulo_genero, file = 'titulo_genero.csv',row.names = FALSE)
write.csv(paises, file = 'paises.csv', row.names = FALSE)
write.csv(titulo_pais, file = 'titulo_pais.csv',row.names = FALSE)












