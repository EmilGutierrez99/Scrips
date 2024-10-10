#!/bin/bash

# Variables
DB_NAME="DB_004"
DB_USER="USER_004"
DB_PASS="PASSWORD_004"
ROOT_USER="root"
ROOT_PASS="password"
TABLE_NAME="TABLE_003"


# Crear base de datos
mysql -u $ROOT_USER -p"$ROOT_PASS" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

# Crear usuario y asignar permisos
mysql -u $ROOT_USER -p"$ROOT_PASS" -e "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
mysql -u $ROOT_USER -p"$ROOT_PASS" -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
mysql -u $ROOT_USER -p"$ROOT_PASS" -e "FLUSH PRIVILEGES;"

# Verificar si el usuario puede crear una tabla
mysql -u $DB_USER -p"$DB_PASS" -e "USE $DB_NAME; CREATE TABLE IF NOT EXISTS $TABLE_NAME (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50));"

# Comprobación final
if [ $? -eq 0 ]; then
  echo "El usuario $DB_USER ha creado la tabla $TABLE_NAME correctamente en la base de datos $DB_NAME."
else
  echo "Hubo un error al intentar crear la tabla con el usuario $DB_USER."
fi

