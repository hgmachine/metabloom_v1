var socket = io('http://157.230.188.180:8080', {
//var socket = io('http://localhost:8080/', {
  transports: ['websocket']
});

// Verificar se userId está definido
if (typeof userId === 'undefined') {
    console.error('userId não está definido.');
} else {
    // Enviar o ID do usuário ao conectar
    socket.emit('join', {user_id: userId, role: 'user'});
}

socket.on('send_updated_status_tasks', function(data) {

    const tasks = [...data.micros, ...data.macros];  // Combinar micros e macros
    tasks.forEach(task => {

        // Atualiza o nome da tarefa (título) dinamicamente
        const taskTitleElement = document.querySelector('#task_name');

        // Verifica se o elemento existe e se o número da tarefa corresponde
        if (taskTitleElement && task.number === taskTitleElement.getAttribute('data-number')) {
           taskTitleElement.textContent = task.title;  // Atualiza o texto do título
        }

        // Para cada tarefa, atualizamos os 4 botões correspondentes
        for (let i = 1; i < 5; i++) {
            // Seleciona o botão correspondente (task-button-0, task-button-1, etc.)
            const button = document.querySelector(`#task-button-${i}`);

            // Verifica se o botão corresponde ao número da tarefa
            if (button && task.number === button.getAttribute('href').split('/')[3]) {
                // Atualiza o estado do botão com base no índice `task.on[i]`
                if (task.on[i-1]) {
                    // Habilitar o botão
                    button.classList.remove('disabled-link');
                } else {
                    // Desabilitar o botão
                    button.classList.add('disabled-link');
                }
            }
        }
    });
    location.reload();
});
