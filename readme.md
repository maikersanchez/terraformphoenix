# AWS PHOENIX
Proyecto terraform phoenix automatizado con despliegue aws ec2

## Requerimientos 📌
* instalacion de terraform
* instalacion aws-cli 
* tener acceso a cuenta aws


## Instalacion 🚀
* bajo terraform utilizando el comando **terraform init** (este comando permite inicializar los datos de los archivos terraform).
* ejecuta el comando **terraform plan** (permite visualizar la configuracion que nos arroja la los archivos(tf) ya configurad).
* ejecuta **terraform apply** (para lanzar la configuración a nuestro proeedor este caso (aws)).

Gran parte de los procesos de configuracion de la instancia ec2 fueron automatizados en el xxxxx.tf pero requiere ejecutar desde linea de comandos adicionales:

1. mix local.hex --force
2. wget http://github.com/phoenixframework/archives/raw/master/phoenix_new.ez
3. mix archive.install ./phoenix_new.ez --force
4. mkdir app && cd app
5. mix phoenix.new phxserver --no-ecto

## Despliegue 📦
* Terminada es configuracion es necesario ejecutar el siguiente comando para lanzar el servidor.
* cd web && mix phoenix.server

* Una vez realizado los pasos anteriores puedes ingresar mediante la ippublica de la instancia ec2 y al puerto 4000, **ejemplo: http://3.16.206.214:4000/** debes dirigete a la consola de amazon ec2 y obtener los datos necesarios.
