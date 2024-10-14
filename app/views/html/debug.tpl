<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Debug da Aplicação</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #333; }
        pre { background-color: #f4f4f4; padding: 10px; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>Página de Debug</h1>
    {% set users= debug_data['logged_users'] %}

    <h2>Dojos</h2>
    {% set dojos = debug_data['dojos'] %}
    {# Ajuste a forma como você obtém os jobs #}
    {% if users %}
        {% set first_user = users | list | first %}
        {% set jobs = dojos.read_jobs_from_user_id(first_user.user_id) %}
        <pre>{{ jobs | tojson(indent=2) }}</pre>
    {% else %}
        <pre>Nenhum usuário logado.</pre>
    {% endif %}
    
    <h2>Students</h2>
    <pre>{{ debug_data['students'].models[0].username }}</pre>

    <h2>Admins</h2>
    <pre>{{ debug_data['admins'].models[0].username }}</pre>

    <h2>Tasks</h2>
    {% set Tasks= debug_data['tasks'] %}
    <pre>{{ Tasks.models[0].title }}</pre>

    <h2>Content</h2>
    {% set content= debug_data['content'] %}
    <pre>{% print(content.contents[0]) %}</pre>

    <h2>Users Sessions</h2>
    <pre>{{ debug_data['users_sessions'] | tojson(indent=2) }}</pre>

    <h2>Status Dojos</h2>
    <pre>{{ debug_data['status_dojos'] }}</pre>

    <h2>Usuários conectados</h2>
    <pre>{{ debug_data['logged_users'].keys() }}</pre>

</body>
</html>
