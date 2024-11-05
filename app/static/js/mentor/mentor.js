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
    alert('Os dojos foram fechados. Você será redirecionado à sala da administração.')
    window.location.href = '/admin';
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
    responseTextarea.value = data.response.replace(/\n/g, '\r\n'); // Definindo o valor da resposta
    responseTextarea.className = 'form-control'; // Classe Bootstrap para textarea
    responseDiv.appendChild(responseTextarea); // Adicionando a textarea

    // **NOVO: Campo para comentários do monitor**
    var commentTextarea = document.createElement('textarea');
    commentTextarea.rows = 2; // Número de linhas visíveis para o comentário
    commentTextarea.cols = 50; // Número de colunas visíveis
    commentTextarea.placeholder = 'Comentários do monitor'; // Placeholder para o campo
    commentTextarea.className = 'form-control mt-2'; // Classe Bootstrap e margem superior
    responseDiv.appendChild(commentTextarea); // Adicionando a textarea de comentários

    // Criação dos radio buttons
    var correctFeedback = document.createElement('input');
    correctFeedback.type = 'radio';
    correctFeedback.name = 'feedback_' + data.question_id; // Agrupando os radio buttons
    correctFeedback.value = 'Correta';
    correctFeedback.id = 'correct_' + data.question_id + '_' + data.user_id;

    var incorrectFeedback = document.createElement('input');
    incorrectFeedback.type = 'radio';
    incorrectFeedback.name = 'feedback_' + data.question_id;
    incorrectFeedback.value = 'Errada';
    incorrectFeedback.id = 'incorrect_' + data.question_id + '_' + data.user_id;

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
        setTimeout(function() {
            var feedbackValue;

            // **Alterado**: Usando os novos IDs combinados
            var correctFeedback = document.getElementById('correct_' + data.question_id + '_' + data.user_id);
            var incorrectFeedback = document.getElementById('incorrect_' + data.question_id + '_' + data.user_id);

            if (correctFeedback.checked) {
                feedbackValue = 'Correta';
            } else if (incorrectFeedback.checked) {
                feedbackValue = 'Errada';
            }
            // Log os valores
            console.log('Feedback Value:', feedbackValue);
            console.log('User ID:', data.user_id);
            console.log('Question ID:', data.question_id);
            console.log('Question:', data.question);
            console.log('Response:', data.response.replace(/\n/g, '\\n'));

            if (feedbackValue) {
                // **Concatenando resposta do estudante com comentários do monitor**
                var monitorComments = commentTextarea.value.trim().replace(/\n/g, '\\n') || "nenhum comentário"; // Captura os comentários e trata quebras de linha
                var combinedResponse = data.response + ' # Feedback do Monitor: "' + monitorComments + '"';

                sendFeedback(data.user_id, data.question_id, data.question, combinedResponse.replace(/\n/g, '\\n'), feedbackValue);
                submitButton.disabled = true;
                submitButton.innerText = 'Enviando..';
                setTimeout(function() {
                    document.getElementById('responses').removeChild(responseDiv);
                }, 1000);
            } else {
                alert('Por favor, selecione uma opção antes de enviar.');
            }
        }, 500); // Ajuste o tempo conforme necessário
    };
    responseDiv.appendChild(submitButton);
    document.getElementById('responses').appendChild(responseDiv);
});

function sendFeedback(userId, questionId, question, response, feedback) {
    socket.emit('mentor_feedback', {user_id: userId, question_id: questionId, question: question, response: response, feedback: feedback});
}

function handleResend(userId, questionId, question, response) {
    var feedbackValue;

    // Obtenha os elementos de feedback
    var correctFeedback = document.getElementById('correct_' + questionId + '_' + userId);
    var incorrectFeedback = document.getElementById('incorrect_' + questionId + '_' + userId);

    // Obtenha o campo de comentários do monitor
    var commentTextarea = document.getElementById('monitorComments_' + questionId + '_' + userId); // Usando o ID definido

    // Verifique qual feedback foi selecionado
    if (correctFeedback.checked) {
        feedbackValue = 'Correta';
    } else if (incorrectFeedback.checked) {
        feedbackValue = 'Errada';
    }

    if (feedbackValue) {
        setTimeout(function() {
            var monitorComments = commentTextarea.value.trim().replace(/\n/g, '\\n') || "nenhum comentário";
            var combinedResponse = response + ' # Feedback do Monitor: "' + monitorComments + '"';

            sendFeedback(userId, questionId, question, combinedResponse, feedbackValue);

            var submitButton = document.getElementById('resendButton_' + questionId);
            submitButton.disabled = true;
            submitButton.innerText = 'Enviando..';

            setTimeout(function() {
                var responseItem = submitButton.closest('.response-item');
                if (responseItem) {
                    responseItem.remove();
                }
            }, 1000);
        }, 500);
    } else {
        alert('Por favor, selecione uma opção antes de enviar.');
    }
}
