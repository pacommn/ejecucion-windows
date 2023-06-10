# Descargar las imágenes
docker pull mysql:latest
docker pull pacomn/party-web:1.0

# Ejecutar el primer contenedor
docker run -d --name db -p 3306:3306 -e MYSQL_DATABASE=prueba -e MYSQL_ROOT_PASSWORD=hola -e LANG=C.UTF-8 -v ${PWD}\sql:/var/lib mysql:latest

# Esperar a que el contenedor 'db' esté disponible
while (!(docker exec db mysqladmin ping --silent)) {
    Start-Sleep -Seconds 1
}

Write-Host "Ejecutando el comando inicial..."
docker exec -i db /bin/bash -c "mysql -u root -phola prueba < /var/lib/party1.sql"
while ($LASTEXITCODE -ne 0) {
    Write-Host "Error de acceso. Esperando 5 segundos..."
    Start-Sleep -Seconds 5
    Write-Host "Ejecutando el comando nuevamente..."
    docker exec -i db /bin/bash -c "mysql -u root -phola prueba < /var/lib/party1.sql"
}

# Ejecutar el comando dentro del contenedor 'db'
# docker exec -i db /bin/bash -c "mysql -u root -phola prueba < /var/lib/party1.sql"


# Esperar 20 segundos
Start-Sleep -Seconds 20

# Ejecutar el segundo contenedor
docker run --name party-web -p 8040:8040 --link db pacomn/party-web:1.0

