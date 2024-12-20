{% extends "base.tpl" %}

{% block title %} Meta Bloom Dojo {% endblock %}

{% block content %}

<!-- EVALUATION SECTION -->
<section id="evaluation" data-stellar-background-ratio="0.5">
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-12">
                <div class="section-title text-center">
                    <h1>Avaliação de Conhecimentos</h1>
                    <br>
                </div>
                <!-- Botões de Ação -->
                <div class="mt-3">
                    <form action="/student" method="get" style="display:inline;">
                        <button type="submit" class="btn btn-warning">Estudante</button>
                    </form>
                    <form action="/task/{{ task.number }}" method="get" style="display:inline;">
                        <button type="submit" class="btn btn-warning">Tarefa</button>
                    </form>
                    <form action="/logout" method="post" style="display:inline;">
                        <button type="submit" class="btn btn-warning">Deslogar</button>
                    </form>
                </div>
                {% if questions %}
                  <h1>{{ username }}, dê o seu melhor nas perguntas abaixo :)</h1>
                  {% for question in questions %}
                      <div class="question mb-4">
                          <h4 id="question_{{ question['number'] }}">{{ question['text'] }}</h4>
                          <textarea id="response_{{ question['number'] }}" class="response-textarea form-control mb-2" rows="4" placeholder="Digite sua resposta aqui..."></textarea>
                          <button class="btn btn-primary" onclick="submitAnswer('{{ question['number'] }}', this)">Submeter</button>
                      </div>
                      <h4 id="feedback_{{ question['number'] }}">Resposta: não corrigida.</h4>
                  {% endfor %}
                {% else %}
                  <h2 style="text-align: center;">Limite de perguntas atingido para esta tarefa :)</h2>
                  <h3>Recicle esta tarefa para poder utilizada na próxima abertura de dojo.</h3>
                  <form action="/student/reciclar/{{ user_id }}/{{ task.number }}/{{ level }}" method="post" style="display:inline;">
                      <button type="submit" class="btn btn-warning">Reciclar</button>
                  </form>
                {% endif %}
            </div>
        </div>
    </div>
</section>

<!-- Definição da variável userId utilizando Jinja2 -->
<script type="text/javascript">
    var userId = {{ user_id | tojson }};
</script>

<!-- Carregar o arquivo dojo.js depois de definir userId -->
<script type="text/javascript" src="/static/js/dojo/dojo.js?v=1.0.2"></script>

{% endblock %}
