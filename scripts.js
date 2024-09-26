const modoAlumnoBtn = document.getElementById('modo-alumno');
const modoProfesorBtn = document.getElementById('modo-profesor');

const passwordField = document.getElementById('password');

const sidebar = document.querySelector('.sidebar');

const errorMessage1 = document.getElementById('error-message-1');
const aciertoMessage1 = document.getElementById('acierto-message-1');

const storedPasswordHash = '445464a3b35aac900401439dddaf7a186b236027a917e2b5b13e5f00a6c5a1d0';
const encoder = new TextEncoder();

// Manejar eventos al hacer clic en los botones de modo
modoAlumnoBtn.addEventListener('click', () => {
    // Realizar acciones para el modo alumno
    // Por ejemplo, podrías establecer una variable de estado para el modo
    // y habilitar el acceso a la barra lateral aquí
    alert("Usted ha elegido el modo estudiante, ahora ya puede elegir el curso deseado");
    localStorage.setItem('esEstudiante', 'true');
    sidebar.classList.add('modo-alumno-activo');
});

modoProfesorBtn.addEventListener('click', async () => {

    const enteredPassword = passwordField.value.trim().toLowerCase();;

    try {
        const hashedPassword = await sha256(enteredPassword);
        //alert(hashedPassword);

        if (hashedPassword === storedPasswordHash) {
            errorMessage1.style.display = 'none';
            errorMessage1.classList.remove('error-animation');

            aciertoMessage1.style.display = 'block';
            aciertoMessage1.classList.add('acierto-animation');

            localStorage.setItem('esEstudiante', 'false');
            sidebar.classList.add('modo-profesor-activo');
        } else {
            errorMessage1.style.display = 'block';
            errorMessage1.classList.add('error-animation');

            aciertoMessage1.style.display = 'none';
            aciertoMessage1.classList.remove('acierto-animation');
        }
    } catch (err) {
        console.error('Error al encriptar la contraseña:', err);
        alert('Error al encriptar la contraseña');
    }
});

// Verificar el modo antes de permitir el acceso a los elementos de la barra lateral
const linksBarraLateral = sidebar.querySelectorAll('a');

linksBarraLateral.forEach(link => {
    link.addEventListener('click', (event) => {
        if (!sidebar.classList.contains('modo-alumno-activo') && !sidebar.classList.contains('modo-profesor-activo')) {
            event.preventDefault();
            alert('Primero debe elegir el modo [Alumno] - [Profesor]');
        }
    });
});

// Función para generar un hash SHA-256 de una cadena
async function sha256(plainText) {
    const encoder = new TextEncoder();
    const data = encoder.encode(plainText);
    const hashBuffer = await crypto.subtle.digest('SHA-256', data);
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    const hashHex = hashArray.map(byte => byte.toString(16).padStart(2, '0')).join('');
    return hashHex;
}

