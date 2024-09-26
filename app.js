const http = require('http');
const fs = require('fs');
const path = require('path');


const { exec } = require('child_process');
const { Console } = require('console');

const server = http.createServer((req, res) => {
    let filePath = '.' + req.url;

    if (filePath === './') {
        filePath = './index.html';
    }

    const extname = path.extname(filePath);
    let contentType = 'text/html; charset=utf-8'; // Agregamos la codificación UTF-8

    switch (extname) {
        case '.css':
            contentType = 'text/css; charset=utf-8'; // También para los archivos CSS
            break;
        default:
            break;
    }

    if (req.url.startsWith('/ejecutarScript/')) {
        // Manejar la solicitud para ejecutar el script
        const script = req.url.slice('/ejecutarScript/'.length); // Obtener el parámetro después de '/ejecutarScript/'
        ejecutarScript(script, res);
    } else {
        // Servir archivos estáticos
        fs.readFile(filePath, (err, content) => {
            if (err) {
                if (err.code === 'ENOENT') {
                    res.writeHead(404);
                    res.end('Archivo no encontrado');
                } else {
                    res.writeHead(500);
                    res.end('Error interno del servidor');
                }
            } else {
                res.writeHead(200, { 'Content-Type': contentType });
                res.end(content, 'utf-8');
            }
        });
    }
});



function ejecutarScript(script, res) {

    let scriptPath = '';
    const scripts_common_path = "Docker/TFM-1-main/Scripts"

    // Obtén la ruta completa del script
    scriptPath = path.join(__dirname, scripts_common_path, `${script}.sh`);

    console.log(scriptPath);
    // Ejecuta el script shell
    exec(`sh ${scriptPath}`, (error, stdout, stderr) => {
        if (error) {
            res.writeHead(500);
            res.end('Error al ejecutar el script');
            return;
        }
        res.writeHead(200);
        res.end('Script ejecutado correctamente');
    });

    res.writeHead(404);
    res.end('Script no encontrado');
}

const PORT = 3000;
server.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
