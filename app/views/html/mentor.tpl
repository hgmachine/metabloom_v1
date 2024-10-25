{% extends "base.tpl" %}

{% block title %} Meta Bloom Mentoria {% endblock %}

{% block styles %}
<link rel="stylesheet" type="text/css" href="/static/css/mentor/mentor.css">
<script type="text/javascript" src="/static/js/mentor/mentor.js"></script>
{% endblock %}

{% block content %}
<!-- Painel de Mentoria -->
<section id="mentoring-panel" data-stellar-background-ratio="0.5">
    <div class="container">
        <div class="row">
            <div class="col-md-12 col-sm-12">
                <div class="section-title">
                    <h1>Painel de Mentoria</h1>
                </div>
            </div>
            <div class="col-md-12 col-sm-12">
                <div id="responses" class="responses-area">
                    <div class="response-item">
                        <h3>Nome do Mentor: <span> {{ user.username }} </span></h3>
                        <p>Tema da Mentoria: <span> {{ user.meta }} </span></p>
                        <hr>
                    </div>
                    <!-- Botões de Ação -->
                    <div class="mt-3">
                        <form action="/admin" method="get" style="display:inline;">
                            <button type="submit" class="btn btn-warning">Retornar à administração</button>
                        </form>
                    </div>
                    <hr>
                    {% for message in content %}
                      {% if not message.feedback %}
                      <div class="response-item">
                          <div><strong>Pergunta:</strong> {{ message.question }}<br></div>
                          <div>
                              <textarea rows="4" cols="50">{{ message.response }}</textarea>
                          </div>
                          <div>
                              <!-- Criação dos radio buttons -->
                              <input type="radio" name="feedback_{{ message.question_id }}" value="Correta" id="correct_{{ message.user_id }}">
                              <label for="correct_{{ message.user_id }}">Correta</label></br>
                              <input type="radio" name="feedback_{{ message.question_id }}" value="Errada" id="incorrect_{{ message.user_id }}">
                              <label for="incorrect_{{ message.user_id }}">Errada</label>
                          </div>
                          <div>
                              <button id="resendButton_{{ message.question_id }}" class="btn btn-primary" onclick="handleResend(
                                  '{{ message.user_id }}',
                                  '{{ message.question_id }}',
                                  '{{ message.question }}',
                                  '{{ message.response }}')">
                                  Enviar Feedback
                              </button>
                          </div>
                        </div>
                        <hr>
                      {% endif %}
                    {% endfor %}
                </div>
            </div>
        </div>
    </div>
</section>

{% endblock %}
