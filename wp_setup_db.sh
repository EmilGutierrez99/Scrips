#!/bin/bash

# Verificar que se han pasado los tres argumentos necesarios
if [ "$#" -ne 4 ]; then
    echo "Uso: ./wp_setup_db.sh <nombre_db> <usuario_db> <contraseña_db> <tabla_db>"
    exit 1
fi

# Asignar los argumentos a variables
DB_NAME=$1
DB_USER=$2
DB_PASSWORD=$3
DB_TABLE=$4

#Usuario root
ROOT_USER="root"
ROOT_PASS="password"

### Verificar si la base de datos ya existe
db_exists=$(mysql -u $ROOT_USER -p"$ROOT_PASS" -e "SHOW DATABASES LIKE '$DB_NAME';" | grep "$DB_NAME")
if [ "$db_exists" ]; then
  echo "Advertencia: La base de datos $DB_NAME ya existe. Por favor, elige otro nombre."
  read -p "INTRODUCE OTRO NOMBRE A LA DB: " DB_NAME
fi

### Verificar si el usuario ya existe
user_exists=$(mysql -u $ROOT_USER -p"$ROOT_PASS" -e "SELECT User FROM mysql.user WHERE User = '$DB_USER';" | grep "$DB_USER")
if [ "$user_exists" ]; then
  echo "Advertencia: El usuario $DB_USER ya existe. Por favor, elige otro nombre."
  read -p "INTRODUCE OTRO NOMBRE AL USER: " DB_USER
fi




# Mensaje de confirmación de inicio
echo "Iniciando configuración de la base de datos de WordPress..."
echo "Nombre de la base de datos: $DB_NAME"
echo "Usuario de la base de datos: $DB_USER"
echo "Contraseña de la base de datos: $DB_PASSWORD"
echo "Nombre de la tabla $DB_TABLE en la base de datos: $DB_NAME"

# Crear la base de datos
echo "Creando la base de datos..."
mysql -u $ROOT_USER -p"$ROOT_PASS" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

# Crear el usuario y asignarle permisos
echo "Creando usuario y asignando permisos..."
mysql -u $ROOT_USER -p"$ROOT_PASS" -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
mysql -u $ROOT_USER -p"$ROOT_PASS" -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
mysql -u $ROOT_USER -p"$ROOT_PASS" -e "FLUSH PRIVILEGES;"


### Verificar si la tabla ya existe
table_exists=$(mysql -u $ROOT_USER -p"$ROOT_PASS" -e "USE $DB_NAME; SHOW TABLES LIKE '$DB_TABLE';" | grep "$DB_TABLE")
if [ "$table_exists" ]; then
  echo "Advertencia: La tabla $DB_TABLE ya existe en la base de datos $DB_NAME. Por favor, elige otro nombre."
  exit 1
fi
# Crear tabla en la base de datos
mysql -u $DB_USER -p"$DB_PASSWORD" -e "USE $DB_NAME; CREATE TABLE IF NOT EXISTS $DB_TABLE (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50));"


# Confirmación de finalización
echo "La configuración de la base de datos ha finalizado exitosamente."
echo "Puedes continuar con la instalación de WordPress."

exit 0