{% extends "base.tpl" %}

{% block title %} Meta Bloom Estudante {% endblock %}

{% block styles %}

<link rel="stylesheet" type="text/css" href="/static/css/student/student.css">

{% endblock %}

{% block content %}

<!-- FEATURE -->
<section id="feature" data-stellar-background-ratio="0.5">
     <div class="container">
          <div class="row">
               <div class="col-md-12 col-sm-12">
                    <div class="section-title">
                         <h1>{{ title }}</h1>
                    </div>
               </div>
               <div class="col-md-6 col-sm-6">
                 <div class="container">
                     {% if admin %}
                     <h1>Olá, {{ admin.username }}!</h1>
                     <br>
                     <!-- Botões de Ação -->
                     <div class="mt-3">
                         <form action="/admin" method="get" style="display:inline;">
                             <button type="submit" class="btn btn-warning">Retornar à administração</button>
                         </form>
                     </div>
                     {% else %}
                     <h1>Olá, {{ user.username }}!</h1>
                     <h3>Meta: {{ user.meta }}</h3>
                     <br>
                     <!-- Botões de Ação -->
                     <div class="mt-3">
                         <form action="/logout" method="post" style="display:inline;">
                             <button type="submit" class="btn btn-warning">Deslogar</button>
                         </form>
                     </div>
                     {% endif %}
                     <br>
                     <h3>{{ welcome }}</h3>
                   </br>
                 </div>
               </div>
          </div>
     </div>

    <div class="container">
        <div class="row">
            <div class="col-md-12 col-sm-12">
                <div class="section-title">
                    <h1>Tarefas:</h1>
                </div>
            </div>
              <div class="col-md-12 col-sm-12">
                <div class="table-responsive">
                    <table class="table table-bordered">
                        <colgroup>
                             <col style="width: 5%;">
                             <col style="width: 35%;">
                             <col style="width: 15%;">
                             <col style="width: 15%;">
                             <col style="width: 15%;">
                             <col style="width: 15%;">
                         </colgroup>
                        <thead>
                             <tr>
                                 <th  class="center-text" rowspan="2" colspan="2">Micro Tarefas</th>
                                 <th  class="center-text" colspan="4">Acompanhamento dos níveis práticos/psicomotores</th>
                             </tr>
                             <tr>
                               <th class="center-text">Nível 1</th>
                               <th class="center-text">Nível 2</th>
                               <th class="center-text">Nível 3</th>
                               <th class="center-text">Nível 4</th>
                             </tr>
                        </thead>
                        <tbody>
                          {% set counter = 1 %}
                            {% for task in user_micros %}
                            <tr>
                                <td class="center-text">{{ counter }}</td>
                                  {% if task.on and not admin %}
                                    <th><a href="/task/{{ task.number }}">{{ task.title }}</a></th>
                                  {% else %}
                                    <th>{{ task.title }}</th>
                                  {% endif %}
                                <th>
                                    {% set stars = user.tasks_sum[task.number][0] // 10 if user.tasks.sum else 0 %}
                                    {% for star in range(0, stars) %}
                                        <span class="pricing-dollar" style="display: inline-block;">
                                            <img src="/static/img/star.png" class="img-responsive" style="width:20px; height: 20px;">
                                        </span>
                                    {% endfor %}
                                </th>
                                <th>
                                    {% set stars = user.tasks_sum[task.number][1] // 10 if user.tasks.sum else 0 %}
                                    {% for star in range(0, stars) %}
                                        <span class="pricing-dollar" style="display: inline-block;">
                                            <img src="/static/img/star.png" class="img-responsive" style="width:20px; height: 20px;">
                                        </span>
                                    {% endfor %}
                                </th>
                                <th>
                                    {% set stars = user.tasks_sum[task.number][2] // 10 if user.tasks.sum else 0 %}
                                    {% for star in range(0, stars) %}
                                        <span class="pricing-dollar" style="display: inline-block;">
                                            <img src="/static/img/star.png" class="img-responsive" style="width:20px; height: 20px;">
                                        </span>
                                    {% endfor %}
                                </th>
                                <th>
                                    {% set stars = user.tasks_sum[task.number][3] if user.tasks_sum else 0 %}
                                    {% for star in range(0, stars) %}
                                        <span class="pricing-dollar" style="display: inline-block;">
                                            <img src="/static/img/star.png" class="img-responsive" style="width:20px; height: 20px;">
					    <p>*</p>
                                        </span>
                                    {% endfor %}
                                </th>
                            </tr>
                            {% set counter = counter + 1 %}
                            {% endfor %}
                          </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="container">
        <div class="row">
            <div class="col-md-12 col-sm-12">
                <div class="table-responsive">
                    <table class="table table-bordered">
                       <colgroup>
                            <col style="width: 5%;">
                            <col style="width: 35%;">
                            <col style="width: 15%;">
                            <col style="width: 15%;">
                            <col style="width: 15%;">
                            <col style="width: 15%;">
                        </colgroup>
                        <thead>
                             <tr>
                                 <th class="center-text" rowspan="2" colspan="2">Macro Tarefas</th>
                                 <th class="center-text" colspan="4">Acompanhamento dos níveis práticos/psicomotores</th>
                             </tr>
                             <tr>
                                 <th class="center-text">Nível 1</th>
                                 <th class="center-text">Nível 2</th>
                                 <th class="center-text">Nível 3</th>
                                 <th class="center-text">Nível 4</th>
                             </tr>
                        </thead>
                        <tbody>
                          {% set counter = 1 %}
                            {% for task in user_macros %}
                            <tr>
                                <td class="center-text">{{ counter }}</td>
                                  {% if task.on and not admin %}
                                    <th><a href="/task/{{ task.number }}">{{ task.title }}</a></th>
                                  {% else %}
                                    <th>{{ task.title }}</th>
                                  {% endif %}
                                <th>
                                    {% set stars = user.tasks_sum[task.number][0] // 10 if user.tasks.sum else 0 %}
                                    {% for star in range(0, stars) %}
                                        <span class="pricing-dollar" style="display: inline-block;">
                                            <img src="/static/img/star.png" class="img-responsive" style="width:20px; height: 20px;">
                                        </span>
                                    {% endfor %}
                                </th>
                                <th>
                                    {% set stars = user.tasks_sum[task.number][1] // 10 if user.tasks.sum else 0 %}
                                    {% for star in range(0, stars) %}
                                        <span class="pricing-dollar" style="display: inline-block;">
                                            <img src="/static/img/star.png" class="img-responsive" style="width:20px; height: 20px;">
                                        </span>
                                    {% endfor %}
                                </th>
                                <th>
                                    {% set stars = user.tasks_sum[task.number][2] // 10 if user.tasks.sum else 0 %}
                                    {% for star in range(0, stars) %}
                                        <span class="pricing-dollar" style="display: inline-block;">
                                            <img src="/static/img/star.png" class="img-responsive" style="width:20px; height: 20px;">
                                        </span>
                                    {% endfor %}
                                </th>
                                <th>
                                    {% set stars = user.tasks_sum[task.number][3] if user.tasks_sum else 0 %}
                                    {% for star in range(0, stars) %}
                                        <span class="pricing-dollar" style="display: inline-block;">
                                            <img src="/static/img/star.png" class="img-responsive" style="width:20px; height: 20px;">
                                        </span>
                                    {% endfor %}
                                </th>
                            </tr>
                            {% set counter = counter + 1 %}
                            {% endfor %}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
    <div class="row">
        <div class="col-md-12 col-sm-12">
            <div class="section-title">
                <h1>Informações do último dojo realizado:</h1>
            </div>
            <div class="info-content">
                <pre>{{ user.last }}</pre>
            </div>
        </div>
    </div>
    </div>

</section>

<!-- Definição da variável userId utilizando Jinja2 -->
<script type="text/javascript">
    var userId = {{ user_id | tojson }};
</script>

<!-- Carregar o arquivo dojo.js depois de definir userId -->
<script type="text/javascript" src="/static/js/student/student.js"></script>

{% endblock %}
