var socket = io('http://localhost:8080');
socket.emit('join', {role: 'mentor'});

socket.on('update_status_dojos', function(data) {
    var statusDojosElement = document.getElementById('updated_status_dojos').querySelector('h4');

    if (statusDojosElement) {
        statusDojosElement.innerHTML = data.status_dojos;  // Atualiza o conteúdo
    } else {
        console.error("Elemento 'status_dojos' não encontrado.");
    }
});

socket.on('send_updated_status_tasks', function(data) {

    const tasks = [...data.micros, ...data.macros];  // Combinar micros e macros

    tasks.forEach(task => {
        const row = document.querySelector(`tr[data-number="${task.number}"]`);
        if (row) {
            const statusCell = row.querySelector('.status');
            statusCell.textContent = task.on;  // Atualiza o texto do status
        }
    });
    location.reload();
});

function set_status_dojos(status_dojos) {
    socket.emit('send_status_dojos', {status_dojos: status_dojos});
}

function set_status_tasks(status_tasks) {
    socket.emit('send_status_tasks', {status_tasks: status_tasks});
}
