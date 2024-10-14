{% extends "base.tpl" %}

{% block title %} Meta Bloom Task {% endblock %}

{% block content %}

<!-- FEATURE -->
<section id="feature" data-stellar-background-ratio="0.5">
     <div class="container">
          <div class="row">
               <div class="col-md-12 col-sm-12">
                    <div class="section-title">
                         <h1 id="task_name">{{ task.title }}</h1>
                    </div>
               </div>
               <div class="col-md-6 col-sm-6">
                    <ul class="nav nav-tabs" role="tablist">
                         <li class="active"><a href="#tab01" aria-controls="tab01" role="tab" data-toggle="tab">Recursos teóricos</a></li>
                         <li><a href="#tab02" aria-controls="tab02" role="tab" data-toggle="tab">Recursos práticos</a></li>
                    </ul>
                    <div class="tab-content">
                         <div class="tab-pane active" id="tab01" role="tabpanel">
                              <div class="tab-pane-item">
                                  {% for it in task.explains %}
                                    <h3> {{ it["Titulo"] }}</h3>
                                    <p>  {{ it["Conteudo"] }}</p>
                                  {% endfor %}
                              </div>
                         </div>
                         <div class="tab-pane" id="tab02" role="tabpanel">
                              <div class="tab-pane-item">
                                {% for it in task.practices %}
                                  <h3> {{ it["Titulo"] }}</h3>
                                  <p>  {{ it["Conteudo"] }}</p>
                                {% endfor %}
                              </div>
                         </div>
                    </div>
               </div>
               <div class="col-md-6 col-sm-6">
                    <div class="feature-image">
                         <img src="{{'/static/img/index/feature-mockup.png'}}" class="img-responsive" alt="Thin Laptop">
                    </div>
               </div>
          </div>
     </div>
</section>

<section id="pricing" data-stellar-background-ratio="0.5">
     <div class="container">
          <div class="row">
               <div class="col-md-12 col-sm-12">
                   <!-- Botões de Ação -->
                   <div class="mt-3" style="text-align:center;">
                       <form action="/student" method="get" style="display:inline;">
                           <button type="submit" class="btn btn-warning">Estudante</button>
                       </form>
                       <form action="/logout" method="post" style="display:inline;">
                           <button type="submit" class="btn btn-warning">Deslogar</button>
                       </form>
                   </div>
                    <div class="section-title">
                         <h1>Melhore os seus níveis nesta micro tarefa</h1>
                    </div>
               </div>
               <div class="col-md-6 col-sm-6">
                    <div class="pricing-thumb">
                        <div class="pricing-title">
                             <h2>Nível 1 - Entendimento</h2>
                        </div>
                        <div class="pricing-info">
                              <p>Explicação</p>
                        </div>
                        <div class="pricing-bottom">
                              {% set stars = user.tasks[task.number][0] // 10 %}
                              {% for star in range(0, stars) %}
                                  <span class="pricing-dollar" style="display: inline-block;">
                                      <img src="/static/img/star.png" class="img-responsive" style="width:20px; height: 20px;">
                                  </span>
                              {% endfor %}
                              <a id="task-button-1" href="/task/dojo/{{ task.number }}/1" class="section-btn pricing-btn {{ "" if task.on[0] else "disabled-link"}}">Iniciar</a>
                        </div>
                    </div>
               </div>
               <div class="col-md-6 col-sm-6">
                    <div class="pricing-thumb">
                        <div class="pricing-title">
                             <h2>Nível 2 - Preparação</h2>
                        </div>
                        <div class="pricing-info">
                              <p>Explicação</p>
                        </div>
                        <div class="pricing-bottom">
                          {% set stars = user.tasks[task.number][1] // 10 %}
                          {% for star in range(0, stars) %}
                              <span class="pricing-dollar" style="display: inline-block;">
                                  <img src="/static/img/star.png" class="img-responsive" style="width:20px; height: 20px;">
                              </span>
                          {% endfor %}
                              <a id="task-button-2" href="/task/dojo/{{ task.number }}/2" class="section-btn pricing-btn {{ "" if task.on[1] else "disabled-link"}}">Iniciar</a>
                        </div>
                    </div>
               </div>
         </div>
         <div class="row">
              <div class="col-md-6 col-sm-6">
                   <div class="pricing-thumb">
                       <div class="pricing-title">
                            <h2>Nível 3 - Aplicação</h2>
                       </div>
                       <div class="pricing-info">
                             <p>Explicação</p>
                       </div>
                       <div class="pricing-bottom">
                         {% set stars = user.tasks[task.number][2] // 10 %}
                         {% for star in range(0, stars) %}
                             <span class="pricing-dollar" style="display: inline-block;">
                                 <img src="/static/img/star.png" class="img-responsive" style="width:20px; height: 20px;">
                             </span>
                         {% endfor %}
                             <a id="task-button-3" href="/task/dojo/{{ task.number }}/3" class="section-btn pricing-btn {{ "" if task.on[2] else "disabled-link"}}">Iniciar</a>
                       </div>
                   </div>
              </div>
              <div class="col-md-6 col-sm-6">
                   <div class="pricing-thumb">
                       <div class="pricing-title">
                            <h2>Nível 4 - Automação</h2>
                       </div>
                       <div class="pricing-info">
                             <p>Explicação</p>
                       </div>
                       <div class="pricing-bottom">
                         {% set stars = user.tasks[task.number][3] // 10 %}
                         {% for star in range(0, stars) %}
                             <span class="pricing-dollar" style="display: inline-block;">
                                 <img src="/static/img/star.png" class="img-responsive" style="width:20px; height: 20px;">
                             </span>
                         {% endfor %}
                             <a id="task-button-4" href="/task/dojo/{{ task.number }}/2" class="section-btn pricing-btn {{ "" if task.on[3] else "disabled-link"}}">Iniciar</a>
                       </div>
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
<script type="text/javascript" src="/static/js/task/task.js"></script>

{% endblock %}
