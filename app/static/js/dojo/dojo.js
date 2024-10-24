var socket;

// Verifica se está no servidor ou em desenvolvimento
if (window.location.hostname === '157.230.188.180') {
    socket = io('http://157.230.188.180:8080', {
        transports: ['websocket']
    });
} else {
    socket = io('http://localhost:8080', {
        transports: ['websocket']
    });
}

// Verificar se userId está definido
if (typeof userId === 'undefined') {
    console.error('userId não está definido.');
} else {
    // Enviar o ID do usuário ao conectar
    socket.emit('join', {user_id: userId, role: 'user'});
}

// Selecionar todos os textareas com a classe 'response-textarea'
const textareas = document.querySelectorAll('.response-textarea');

textareas.forEach(textarea => {
    const questionNumber = textarea.getAttribute('data-question-number');

    textarea.addEventListener('keydown', function(event) {
        if ((event.ctrlKey || event.metaKey) && event.key === 'v') {
            event.preventDefault();  // Bloqueia o comando de colar
            alert("Colar está desativado para estas questões!");  // Mensagem opcional para o usuário
        }
    });

    // Bloquear o menu de contexto (botão direito do mouse)
    textarea.addEventListener('contextmenu', function(event) {
        event.preventDefault();  // Bloqueia o menu de contexto
        alert("Colar está desativado para estas questões!");  // Mensagem opcional para o usuário
    });

});

// Função para limpar todos os textareas
function clearTextareas() {
    const textareas = document.querySelectorAll('.response-textarea');
    textareas.forEach(textarea => {
        textarea.value = ''; // Limpa o conteúdo
    });
}

function submitAnswer(questionId) {
    var questionElement = document.getElementById('question_' + questionId);
    var responseElement = document.getElementById('response_' + questionId);
    var question = questionElement.innerText;
    var response = responseElement.value; // Mudando de innerText para value para input
    socket.emit('submit_response', { user_id: userId, question_id: questionId, question: question, response: response });
}

socket.on('close_order', function(data) {
    alert('Os dojos foram fechados. Retorne à sala da tarefa ou do estudante.')
});

// Receber feedback e exibir na interface
socket.on('receive_feedback', function(data) {
    console.log(`Feedback recebido para a questão ${data.question_id}: ${data.feedback}`);
    var feedbackElement = document.getElementById('feedback_' + data.question_id);
    if (feedbackElement) {
        feedbackElement.innerHTML = "Resposta: " + data.feedback;
    } else {
        console.error(`Elemento de feedback com ID 'feedback_${data.question_id}' não encontrado.`);
    }

   if (data.feedback == 'Correta' || data.feedback == 'Errada') {
       var submitButton = document.querySelector(`button[onclick="submitAnswer('${data.question_id}')"]`);
       if (submitButton) {
           submitButton.disabled = true;
           submitButton.innerHTML = "Questão avaliada"; // Atualiza o texto do botão
       } else {
           console.error(`Botão de envio para a questão ${data.question_id} não encontrado.`);
       }
   }
});

// Limpa os textareas ao carregar a página
clearTextareas();
