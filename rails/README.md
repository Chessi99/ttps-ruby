# README

### Trabajo Final TTPS Ruby 2020
# Requisitos
* Ruby (>=2.5)
* Bundler installado. En caso de no tenerlo ejecutar gem install bundler
* mysql

# Gemas
* Ejecutar el comando bundle install para cargar las gemas correspondientes
* Se utiliza la gema Devise para el CRUD de usuarios y manejo de sesiones
* Se utilizo la gema Redcarpet para el exportación de notas.

# Base de Datos
* Se utiliza el motor mysql
* Configurar el archivo datan¿base.yml con las credenciales del propio mysql

# Modelo
* La clase User representa a los usuarios de la aplicacion
* La clase Note representa las notas del cuaderno global o de los cuadernos pertenecientes a la aplicacion
* La clase Book representa los cuadernos de los usuarios registrados

# Migraciones
* Luego creamos la base de datos ejecutando rails db:create
* Finalmente realizar las migraciones con rails db:migrate

# Aplicacion
* Para la ejecución del servidor, ejecutar el comando rails s
