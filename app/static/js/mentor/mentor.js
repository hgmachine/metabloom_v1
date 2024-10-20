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

socket.emit('join', {role: 'mentor'});

socket.on('close_order', function(data) {
    alert('Os dojos foram fechados. Retorne à sala de administração.')
});

socket.on('app_update_handle_button', function(data) {

    // Monta o ID do botão
    var buttonId = 'resendButton_' + data.question_id;

    // Tenta obter o botão
    var button = document.getElementById(buttonId);
    if (button) {
        // Desabilita o botão e muda o texto
        button.disabled = true;
        button.innerText = 'Enviado';  // Muda o texto do botão para indicar que foi enviado
        console.log('Botão desabilitado e texto alterado:', button); // Log para verificar a alteração
    } else {
        console.error('Botão não encontrado:', buttonId); // Log de erro se o botão não for encontrado
    }
});

socket.on('new_response', function(data) {
    var responseDiv = document.createElement('div');
    var questionDiv = document.createElement('div');

    var responseTextarea = document.createElement('textarea');
    responseTextarea.rows = 4; // Número de linhas visíveis
    responseTextarea.cols = 50; // Número de colunas visíveis
    responseTextarea.value = data.response; // Definindo o valor da resposta

    questionDiv.innerHTML = "<br>" +  "Pergunta:" + data.question + "<br>";
    responseDiv.appendChild(questionDiv);
    responseDiv.appendChild(responseTextarea); // Adicionando a textarea

    // Criação dos radio buttons
    var correctFeedback = document.createElement('input');
    correctFeedback.type = 'radio';
    correctFeedback.name = 'feedback_' + data.question_id; // Agrupando os radio buttons
    correctFeedback.value = 'Correta';
    correctFeedback.id = 'correct_' + data.user_id;

    var incorrectFeedback = document.createElement('input');
    incorrectFeedback.type = 'radio';
    incorrectFeedback.name = 'feedback_' + data.question_id;
    incorrectFeedback.value = 'Errada';
    incorrectFeedback.id = 'incorrect_' + data.user_id;

    responseDiv.appendChild(document.createElement('br'));
    responseDiv.appendChild(correctFeedback);
    responseDiv.appendChild(document.createTextNode('Correta'));
    responseDiv.appendChild(document.createElement('br'));
    responseDiv.appendChild(incorrectFeedback);
    responseDiv.appendChild(document.createTextNode('Errada'));
    responseDiv.appendChild(document.createElement('br'));

    // Adicionando um botão para enviar o feedback
    var submitButton = document.createElement('button');
    submitButton.innerText = 'Enviar Feedback';
    submitButton.id = 'resendButton_' + data.question_id; // Definindo o ID do botão
    // Função chamada ao clicar no botão
    submitButton.onclick = function() {
        var feedbackValue;
        if (correctFeedback.checked) {
            feedbackValue = 'Correta';
        } else if (incorrectFeedback.checked) {
            feedbackValue = 'Errada';
        }
        if (feedbackValue) {
            sendFeedback(data.user_id, data.question_id, data.question, data.response, feedbackValue);
            // Desabilita o botão e altera o texto após o envio
            submitButton.disabled = true;
            submitButton.innerText = 'Enviado';
        } else {
            alert('Por favor, selecione uma opção antes de enviar.');
        }
    };

    responseDiv.appendChild(submitButton);
    document.getElementById('responses').appendChild(responseDiv);
});

function sendFeedback(userId, questionId, question, response, feedback) {
    socket.emit('mentor_feedback', {user_id: userId, question_id: questionId, question:question, response:response, feedback: feedback});
}
