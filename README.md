# TFM

@author David Álvarez Muñiz

Este trabajo ha sido realizado por David Álvarez Muñiz como TFM del Máster en Ingeniería de Redes y Servicios Telemáticos (MUIRST) de la Universidad Politécnica de Madrid (UPM) en el curso 2023/24.

El proyecto consiste en un laboratorio simulado para el aprendizaje y la explotación de vulnerabilidades en redes Wi-Fi, el proyecto consiste en 2 partes principales:

1. ## Virtualización de los puntos de acceso

En esta primera parte se virtualizan los puntos de acceso mediante Docker

2. ## Interfaz gráfica

En esta parte se despliega una interfaz gráfica desarrollada en Node.js que permitirá a los usuarios aprender y explotar las vulnerabilidades de los puntos de acceso virtuales desplegados previamente.

Uso:

1. Clonar el repositorio

2. Instalar gnome terminal

3. Dirigirse a la carpeta TFM/Docker/TFM-1-main

4. Ejecutar ```sudo docker compose up -d```

5. Dirigirse a la carpeta TFM

6. Ejecutar ```node app.js```

7. Abrir un navegador y acceder a la página ```localhost:3000```


Si se desean eliminar las interfaces virtuales se proporciona un script dentro de la carpeta Docker/TFM-1-main, llamado clean-ifaces.sh. ejecutarlo con permisos de administrador para borrar todas las interfaces virtuales y evitar posbiles problemas una vez se desee dejar de usar el entrono.
