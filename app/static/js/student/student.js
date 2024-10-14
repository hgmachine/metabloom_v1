// Inicialização do WebSocket
var socket = io('http://157.230.188.180:8080');

// Verificar se userId está definido
if (typeof userId === 'undefined') {
    console.error('userId não está definido.');
} else {
    // Enviar o ID do usuário ao conectar
    socket.emit('join', {user_id: userId, role: 'user'});
}

socket.on('send_updated_status_tasks', function(data) {
    console.log(`Feedback recebido para as tarefas`);
    // atualizar as tarefas nas páginas dos usuários (students), aqui.
    alert('Recebido: novas tarefas')
});
