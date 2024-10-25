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
    var buttonId = 'resendButton_' + data.question_id;
    var button = document.getElementById(buttonId);

    if (button) {
        button.disabled = true;
        button.innerText = 'Enviado';
        console.log('Botão desabilitado e texto alterado:', button);

        // Remove o item da resposta correspondente após 1 segundo
        setTimeout(function() {
            var responseItem = button.closest('.response-item'); // Encontra o item da resposta
            if (responseItem) {
                responseItem.remove(); // Remove o item da resposta da página
            }
        }, 1000); // 1000 milissegundos = 1 segundo
    } else {
        console.error('Botão não encontrado:', buttonId);
    }
});

socket.on('new_response', function(data) {
    var responseDiv = document.createElement('div');
    responseDiv.className = 'response-item'; // Adiciona a classe Bootstrap

    var questionDiv = document.createElement('div');
    questionDiv.innerHTML = "<strong>Pergunta:</strong> " + data.question + "<br>";
    responseDiv.appendChild(questionDiv);

    var responseTextarea = document.createElement('textarea');
    responseTextarea.rows = 4; // Número de linhas visíveis
    responseTextarea.cols = 50; // Número de colunas visíveis
    responseTextarea.value = data.response; // Definindo o valor da resposta
    responseTextarea.className = 'form-control'; // Classe Bootstrap para textarea
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

    var feedbackDiv = document.createElement('div');
    feedbackDiv.className = 'mt-2'; // Margem superior para espaçamento

    // Usar innerHTML para permitir negrito
    var correctLabel = document.createElement('label');
    correctLabel.setAttribute('for', correctFeedback.id);
    correctLabel.innerHTML = '<strong>Correta</strong>';

    var incorrectLabel = document.createElement('label');
    incorrectLabel.setAttribute('for', incorrectFeedback.id);
    incorrectLabel.innerHTML = '<strong>Errada</strong>';

    feedbackDiv.appendChild(correctFeedback);
    feedbackDiv.appendChild(correctLabel);
    feedbackDiv.appendChild(document.createElement('br'));
    feedbackDiv.appendChild(incorrectFeedback);
    feedbackDiv.appendChild(incorrectLabel);

    responseDiv.appendChild(feedbackDiv);

    // Adicionando um botão para enviar o feedback
    var submitButton = document.createElement('button');
    submitButton.innerText = 'Enviar Feedback';
    submitButton.className = 'btn btn-primary'; // Classe Bootstrap para botão
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
            // Após 1 segundo, remove o responseDiv
            setTimeout(function() {
            document.getElementById('responses').removeChild(responseDiv);
            }, 1000); // 1000 milissegundos = 1 segundo
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

function handleResend(userId, questionId, question, response) {
    var feedbackValue;
    var correctFeedback = document.getElementById('correct_' + userId);
    var incorrectFeedback = document.getElementById('incorrect_' + userId);

    if (correctFeedback.checked) {
        feedbackValue = 'Correta';
    } else if (incorrectFeedback.checked) {
        feedbackValue = 'Errada';
    }

    if (feedbackValue) {
        sendFeedback(userId, questionId, question, response, feedbackValue);
        var submitButton = document.getElementById('resendButton_' + questionId);
        submitButton.disabled = true;
        submitButton.innerText = 'Enviado';

        // Após 1 segundo, remove o conteúdo da pergunta
        setTimeout(function() {
            var responseItem = submitButton.closest('.response-item'); // Encontra o item da resposta
            if (responseItem) {
                responseItem.remove(); // Remove o item da resposta da página
            }
        }, 1000); // 1000 milissegundos = 1 segundo
    } else {
        alert('Por favor, selecione uma opção antes de enviar.');
    }
}
