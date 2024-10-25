{% extends "base.tpl" %}

{% block title %} Meta Bloom Administrador {% endblock %}

{% block styles %}

<link rel="stylesheet" type="text/css" href="/static/css/student/student.css">
<script type="text/javascript" src="/static/js/admin/admin.js"></script>

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
                     <h1>Olá, {{ user.username }}!</h1>
                     <br>
                     <h3>De acordo com nossos registros, você pode realizar as seguintes operações:</h3>
                     <ul>
                     {% if 'monitor' in user.permissions %}
                         <li>Acompanhamento de dojos</li>
                     {% endif %}
                     {% if 'professor' in user.permissions %}
                         <li>Acesso ao banco dados</li>
                     {% endif %}
                    </ul>
                    <br>
                    <!-- Botões de Ação -->
                    <div class="mt-3">
                        <form action="/logout" method="post" style="display:inline;">
                            <button type="submit" class="btn btn-warning">Deslogar</button>
                        </form>
                    </div>
                 </div>
               </div>
          </div>
     </div>
</section>

{% if 'Professor' in user.permissions: %}

<!-- CRUD de Tarefas -->
<section id="task-crud" class="my-5">
    <div class="container">
        <h2>Gerenciamento de Tarefas</h2>

        <!-- Listagem de Tarefas -->
        <table class="table table-striped">
            <thead>
                <tr>
                  <th>Título</th>
                  <th>Tipo</th>
                  <th>Status</th>
                </tr>
            </thead>
            <tbody>
                {% for it in tasks.models %}
                        <tr>
                           <tr data-number="{{ it.number }}">
                           <td>{{ it.title }}</td>
                           <td>{{ it.type }}</td>
                           <td class="status">{{ it.on }}</td>
                       </tr>
                {% endfor %}
            </tbody>
        </table>

        <!-- Botões de Ação -->
        <div class="mt-3">
            <form action="/mentor" method="get" style="display:inline;">
                <button class="btn btn-warning">Avaliar os dojos</button>
            </form>
            <button class="btn btn-success" onclick="set_status_dojos('Os dojos foram abertos')">Abrir dojos</button>
            <button class="btn btn-success" onclick="set_status_dojos('Os dojos foram fechados')">Fechar dojos</button>
            <button class="btn btn-success" onclick="set_status_tasks('Atualizar')">Atualizar tarefas</button>
            <!-- Botão para Gerar relatório de cada estudante disponível -->
            <form action="/admin/students/report_all" method="post" style="display:inline;">
                <button type="submit" class="btn btn-sm btn-danger">Gerar relatórios</button>
            </form>
            <!-- Botão para tornar todos os estudantes indisponíveis -->
            <form action="/admin/students/off_them_all" method="post" style="display:inline;">
                <button type="submit" class="btn btn-sm btn-danger">Indisponibilizar os estudantes</button>
            </form>
            <!-- Botão para resetar todos os estudantes indisponíveis -->
            <form action="/admin/students/reset_them_all" method="post" style="display:inline;">
                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Você tem certeza de que deseja resetar a pontuação de todos os estudantes?');">Resetar pontuação</button>
            </form>
            <div id="updated_status_dojos"><h4>{{ status_dojos }}</h4></div>
        </div>
    </div>

        <div class="container">
            <h2>Gerenciamento de Estudantes</h2>

            <!-- Listagem de Estudantes -->
            <table class="table table-striped">
                <thead>
                    <tr>
                      <th>Nome</th>
                      <th>Senha</th>
                      <th>Meta</th>
                      <th>Disponível</th>
                      <th>Ações</th>
                    </tr>
                </thead>
                <tbody>

                    {% for student in students.models: %}

                        <tr>
                            <td>{{ student.username }}</td>
                            <td>{{ student.password }}</td>
                            <td>{{ student.meta }}</td>
                            <td>
                                {% if student.on %}
                                  <img src="/static/img/checkok.png" class="img-responsive" style="width:20px; height: 20px;">
                                {% else %}
                                  <img src="/static/img/checknok.png" class="img-responsive" style="width:20px; height: 20px;">
                                {% endif %}
                            </td>
                            <td>
                                <!-- Botão para Editar -->
                                <button class="btn btn-sm btn-primary" data-toggle="modal" data-target="#editStudentModal{{ student.user_id }}">Editar</button>

                                <!-- Botão para Deletar -->
                                <form action="/admin/students/delete/{{ student.user_id }}" method="post" style="display:inline;">
                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Tem certeza que deseja deletar este estudante?');">Deletar</button>
                                </form>

                                <!-- Botão para Vizualizar -->
                                <form action="/admin/students/view/{{ student.user_id }}" method="get" style="display:inline;">
                                    <button type="submit" class="btn btn-sm btn-danger">Visualizar</button>
                                </form>

                                <!-- Botão para Gerar relatório -->
                                <form action="/admin/students/report/{{ student.user_id }}" method="post" style="display:inline;">
                                    <button type="submit" class="btn btn-sm btn-danger">Relatório</button>
                                </form>

                                <!-- Modal para Editar -->
                              <div class="modal fade" id="editStudentModal{{ student.user_id }}" tabindex="-1" role="dialog" aria-labelledby="editStudentModalLabel{{ student.user_id }}" aria-hidden="true">
                                <div class="modal-dialog" role="document">
                                  <div class="modal-content">
                                    <form action="/admin/students/update/{{ student.user_id }}" method="post">
                                      <div class="modal-header">
                                        <h5 class="modal-title" id="editStudentModalLabel{{ student.user_id }}">Editar Estudante</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                          <span aria-hidden="true">&times;</span>
                                        </button>
                                      </div>
                                      <div class="modal-body">
                                        <div class="form-group">
                                          <label for="username">Nome de usuário</label>
                                        </div>
                                        <input type="text" class="form-control" name="username" value="{{ student.username }}" required>
                                        <div class="form-group">
                                          <label for="password">Senha</label>
                                          <input type="text" class="form-control" name="password" value="{{ student.password }}" required>
                                        </div>

                                        <div class="form-group">
                                            <label for="tasks">Microtarefas</label>
                                            <div class="form-check">
                                                {% for task in tasks.models %}
                                                   {% if task.type == 'Micro' %}
                                                      <input class="form-check-input" type="checkbox" name="tasks" id="microtask{{ task.number }}" value="{{ task.number }}"
                                                          {% if task.number in student.tasks.keys() %}checked{% endif %}>
                                                      <label class="form-check-label" for="microtask{{ task.number }}">
                                                          {{ task.title }}
                                                      </label>
                                                      <br>
                                                   {% endif %}
                                                {% endfor %}
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label for="tasks">Macrotarefas</label>
                                            <div class="form-check">
                                                {% for task in tasks.models %}
                                                    {% if task.type == 'Macro' %}
                                                        <input class="form-check-input" type="checkbox" name="tasks" id="macrotask{{ task.number }}" value="{{ task.number }}"
                                                            {% if task.number in student.tasks.keys() %}checked{% endif %}>
                                                        <label class="form-check-label" for="macrotask{{ task.number }}">
                                                            {{ task.title }}
                                                        </label>
                                                        <br>
                                                    {% endif %}
                                                {% endfor %}
                                            </div>
                                        </div>

                                        <div class="form-group">
                                             <label for="availability">Disponibilidade</label>
                                             <div class="form-check">
                                                 <input class="form-check-input" type="checkbox" name="availability" id="availability" value="1"
                                                     {% if student.on %}checked{% endif %}>
                                                 <label class="form-check-label" for="availability">
                                                     Disponível
                                                 </label>
                                             </div>
                                         </div>

                                        <div class="form-group">
                                          <label for="meta">Meta</label>
                                          <input type="text" class="form-control" name="meta" value="{{ student.meta }}" required>
                                        </div>

                                      </div>
                                      <div class="modal-footer">
                                        <input type="hidden" name="user_id" value="{{ student.user_id }}">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                                        <button type="submit" class="btn btn-primary">Salvar Alterações</button>
                                      </div>
                                    </form>
                                  </div>
                                </div>
                              </div>
                            </td>
                        </tr>

                    {% endfor %}

                </tbody>
            </table>

            <!-- Formulário para Adicionar Novo Estudante -->
            <h3>Adicione uma novo estudante abaixo:</h3>
            <form action="/admin/students/create" method="post">
                <div class="form-group">
                    <label for="username">Nome de usuário</label>
                    <input type="text" class="form-control" name="username" placeholder="Nome do estudante" required>
                </div>
                <div class="form-group">
                    <label for="password">Senha</label>
                    <input type="text" class="form-control" name="password" placeholder="Senha de usuário" required>
                </div>
                <div class="form-group">
                    <label for="meta">Meta</label>
                    <input type="text" class="form-control" name="meta" placeholder="Meta" required>
                </div>
                <button type="submit" class="btn btn-success">Adicionar Estudante</button>
            </form>
          </div>

        <div class="container">
            <h2>Gerenciamento de Administradores</h2>

            <!-- Listagem de Administradores -->
            <table class="table table-striped">
                <thead>
                    <tr>
                      <th>Nome</th>
                      <th>Senha</th>
                      <th>Meta</th>
                      <th>Disponível</th>
                      <th>Ações</th>
                    </tr>
                </thead>
                <tbody>

                    {% for admin in admins.models: %}

                            <tr>

                                <td>{{ admin.username }}</td>
                                <td>{{ admin.password if user.user_id == '1e6f5953-6ad5-400b-b884-df91fceb28ea' else '***'}}</td>
                                <td>{{ admin.meta if user.user_id == '1e6f5953-6ad5-400b-b884-df91fceb28ea' else '***'}}</td>
                                <td>
                                    {% if admin.on %}
                                      <img src="/static/img/checkok.png" class="img-responsive" style="width:20px; height: 20px;">
                                    {% else %}
                                      <img src="/static/img/checknok.png" class="img-responsive" style="width:20px; height: 20px;">
                                    {% endif %}
                                </td>
                                <td>

                                  {% if admin.user_id == user.user_id or user.user_id == '1e6f5953-6ad5-400b-b884-df91fceb28ea' %}

                                    <!-- Botão para Editar -->
                                    <button class="btn btn-sm btn-primary" data-toggle="modal" data-target="#editAdminModal{{ admin.user_id }}">Editar</button>

                                    <!-- Botão para Deletar -->
                                    <form action="/admin/admins/delete/{{ admin.user_id }}" method="post" style="display:inline;">
                                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Tem certeza que deseja deletar este administrador?');">Deletar</button>
                                    </form>

                                  <!-- Modal para Editar -->
                                  <div class="modal fade" id="editAdminModal{{ admin.user_id }}" tabindex="-1" role="dialog" aria-labelledby="editAdminModalLabel{{ admin.user_id }}" aria-hidden="true">
                                    <div class="modal-dialog" role="document">
                                      <div class="modal-content">
                                        <form action="/admin/admins/update/{{ admin.user_id }}" method="post">
                                          <div class="modal-header">
                                            <h5 class="modal-title" id="editAdminModalLabel{{ admin.user_id }}">Editar Adminisrador</h5>
                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                              <span aria-hidden="true">&times;</span>
                                            </button>
                                          </div>
                                          <div class="modal-body">

                                            <div class="form-group">
                                              <label for="username">Nome de administrador</label>
                                            </div>

                                            <input type="text" class="form-control" name="username" value="{{ admin.username }}" required>
                                            <div class="form-group">
                                              <label for="password">Senha de administrador</label>
                                              <input type="text" class="form-control" name="password" value="{{ admin.password }}" required>
                                            </div>

                                            {% if admin.user_id != '1e6f5953-6ad5-400b-b884-df91fceb28ea' %}

                                            <div class="form-group">
                                              <label for="meta">Meta</label>
                                              <input type="text" class="form-control" name="meta" value="{{ admin.meta }}" required>
                                            </div>

                                                  <div class="form-group">
                                                      <label for="tasks">Permissões</label>
                                                      <div class="form-check">
                                                          <input class="form-check-input" type="checkbox" name="permission-monitor" id="permissions-monitor" value="Monitor"
                                                            {% if 'Monitor' in admin.permissions %}checked{% endif %}>
                                                          <label class="form-check-label" for="permission-monitor">
                                                            Monitor
                                                          </label>
                                                          <br>
                                                          <input class="form-check-input" type="checkbox" name="permission-professor" id="permissions-professor" value="Professor"
                                                              {% if 'Professor' in admin.permissions %}checked{% endif %}>
                                                          <label class="form-check-label" for="permissions-professor">
                                                              Professor
                                                          </label>
                                                          <br>
                                                      </div>
                                                  </div>

                                                  <div class="form-group">
                                                       <label for="availability">Disponibilidade</label>
                                                       <div class="form-check">
                                                           <input class="form-check-input" type="checkbox" name="availability" id="availability" value="1"
                                                               {% if admin.on %}checked{% endif %}>
                                                           <label class="form-check-label" for="availability">
                                                               Disponível
                                                           </label>
                                                       </div>
                                                   </div>

                                          </div>

                                          <div class="modal-footer">
                                            <input type="hidden" name="user_id" value="{{ admin.user_id }}">
                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                                            <button type="submit" class="btn btn-primary">Salvar Alterações</button>
                                          </div>

                                          {% else %}

                                          <div class="modal-footer">
                                            <input type="hidden" name="user_id" value="{{ admin.user_id }}">
                                            <input type="hidden" name="meta" value="Meta Bloom">
                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                                            <button type="submit" class="btn btn-primary">Salvar Alterações</button>
                                          </div>

                                          {% endif %}

                                          {% endif %}

                                        </form>
                                      </div>
                                    </div>
                                  </div>
                                </td>
                            </tr>

                    {% endfor %}

                </tbody>
            </table>

            <!-- Formulário para Adicionar Administrador -->
            <h3>Adicione uma novo administrador abaixo:</h3>
            <form action="/admin/admins/create" method="post">
                <div class="form-group">
                    <label for="username">Nome de usuário</label>
                    <input type="text" class="form-control" name="username" placeholder="Nome do administrador" required>
                </div>
                <div class="form-group">
                    <label for="password">Senha</label>
                    <input type="text" class="form-control" name="password" placeholder="Senha de administrador" required>
                </div>
                <div class="form-group">
                    <label for="meta">Meta</label>
                    <input type="text" class="form-control" name="meta" placeholder="Meta" required>
                </div>
                <button type="submit" class="btn btn-success">Adicionar Administrador</button>
            </form>
          </div>

{% elif 'Monitor' in user.permissions: %}

<!-- CRUD de Tarefas -->
<section id="task-crud" class="my-5">
    <div class="container">
        <h2>Acompanhamento de dojos</h2>

        <!-- Listagem de Tarefas -->
        <table class="table table-striped">
            <thead>
                <tr>
                  <th>Título</th>
                  <th>Tipo</th>
                  <th>Status</th>
                </tr>
            </thead>
            <tbody>
                {% for it in tasks.models %}
                        <tr>
                           <tr data-number="{{ it.number }}">
                           <td>{{ it.title }}</td>
                           <td>{{ it.type }}</td>
                           <td class="status">{{ it.on }}</td>
                       </tr>
                    </tr>
                {% endfor %}
            </tbody>
        </table>

        <!-- Botões de Ação -->
        <div class="mt-3">
            <form action="/mentor" method="get" style="display:inline;">
                <button class="btn btn-warning">Avaliar os dojos</button>
            </form>
            <div id="updated_status_dojos"><h4>{{ status_dojos }}</h4></div>
            {% if not user.on %}
            <h4>Solicite o professor habilitação para participar destas avaliações</h4>
            {% else %}
            <h4>Você está habilitado para participar destas avaliações</h4>
            {% endif%}
        </div>

{% endif %}

</section>


{% endblock %}
