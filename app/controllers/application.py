from app.controllers.user_record import UserRecord
from app.controllers.task_record import TaskRecord
from app.controllers.content_record import ContentRecord
from app.models.user_model import UserAccount, SuperAccount
from bottle import jinja2_template, redirect, request, response, Bottle, static_file
from jinja2 import Environment, FileSystemLoader
import socketio
import uuid
import copy

# PDF

from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.platypus import SimpleDocTemplate, Paragraph, Table, TableStyle, Spacer
import os
from datetime import datetime
import pytz


class Application:

    def __init__(self):

        self.pages = {
            'student': self.student,
            'mentor': self.mentor,
            'index': self.index,
            'admin': self.admin,
            'task': self.task,
            'dojo': self.dojo
        }

        # modelos
        self.students= UserRecord('student', UserAccount)
        self.admins= UserRecord('admin', SuperAccount)
        self.tasks= TaskRecord('task')

        self.dojo_is_open= False
        self.dojo_status= ''

        self.content= ContentRecord()
        self.users_sessions = {}

        # Initialize Bottle app
        self.app = Bottle()
        self.setup_static_files()
        self.setup_get_routes()
        self.setup_post_routes()

        # Initialize Socket.IO server
        self.sio = socketio.Server(async_mode='eventlet')
        self.setup_websocket_events()

        # Create WSGI app
        self.wsgi_app = socketio.WSGIApp(self.sio, self.app)


    ############################################################################
    # rotas estáticas

    def setup_static_files(self):

        @self.app.route('/static/<filepath:path>')
        def serve_static(filepath):
            return static_file(filepath, root='./app/static')

    # estabelecimento das rotas GET
    def setup_get_routes(self):

        @self.app.route('/', method='GET')
        @self.app.route('/index', method='GET')
        def index_get():
            return self.render('index')

        @self.app.route('/student', method='GET')
        def student_get():
            return self.render('student')

        @self.app.route('/mentor', method='GET')
        def mentor_get():
            return self.render('mentor')

        @self.app.route('/task/<number>', method='GET')
        def task_get(number):
            return self.render('task',number)

        @self.app.route('/task/dojo/<number>/<level>', method='GET')
        def task_get(number,level):
            return self.render('dojo',{'number':number, 'level':level})

        @self.app.route('/admin', method='GET')
        def admin_get():
            return self.render('admin')

        @self.app.route('/admin/students/view/<user_id>', method='GET')
        def admin_view_get(user_id):
            return self.render('student', user_id)

        @self.app.route('/logout', method='POST')
        def logout():
            self.logout_user()
            redirect('/index')

    # estabelecimento das rotas POST
    def setup_post_routes(self):

        @self.app.route('/admin/students/report/<user_id>', method='POST')
        def student_report_post(user_id):
            student= self.students.get_user_by_id(user_id)
            if student.on:
                self.generate_user_report(user_id)
            redirect('/admin')

        @self.app.route('/admin/students/off_them_all', method='POST')
        def students_report_off_post():
            students= self.students
            for student in students.models:
                student.on= False
            self.students.save()
            self.check_availability()
            redirect('/admin')

        @self.app.route('/admin/students/light_them_all', method='POST')
        def students_report_light_post():
            students= self.students
            for student in students.models:
                student.on= True
            self.students.save()
            redirect('/admin')


        @self.app.route('/admin/mentors/off_them_all', method='POST')
        def admins_report_off_post():
            admins= self.admins
            for admin in admins.models:
                if admin.user_id != '1e6f5953-6ad5-400b-b884-df91fceb28ea':
                    admin.on= False
            self.admins.save()
            redirect('/admin')

        @self.app.route('/admin/mentors/light_them_all', method='POST')
        def admins_report_light_post():
            admins= self.admins
            for admin in admins.models:
                admin.on= True
            self.admins.save()
            redirect('/admin')

        @self.app.route('/admin/students/evaluate_all', method='POST')
        def students_evaluate_post():
            self.evaluate_dojos()
            redirect('/admin')

        @self.app.route('/admin/students/report_all', method='POST')
        def students_report_post():
            students= self.students
            for student in students.models:
                self.generate_user_report(student.user_id)
            redirect('/admin')

        @self.app.route('/admin/students/reciclar', method='POST')
        def admins_students_reciclar_post():
            self.reciclar()
            redirect('/admin')

        @self.app.route('/student/reciclar/<user_id>/<task_number>/<task_level>', method='POST')
        def admins_student_reciclar_post(user_id,task_number,task_level):
            self.reciclar(user_id,task_number,task_level)
            redirect('/student')

        @self.app.route('/index', method='POST')
        def index_post():
            username = request.forms.get('username').strip()
            password = request.forms.get('password').strip()
            # Remove o sobrenome
            partes = username.split()
            # Mantém apenas o primeiro nome
            username = partes[0]  # Apenas o primeiro nome
            self.authenticate_user(username, password)

        @self.app.route('/admin/tasks/delete/<number>', method='POST')
        def task_delete_post(number):
            self.delete_task(number)

        @self.app.route('/admin/students/delete/<number>', method='POST')
        @self.app.route('/admin/admins/delete/<number>', method='POST')
        def student_delete_post(number):
            self.delete_user(number)

        @self.app.route('/admin/tasks/update/<number>', method='POST')
        def task_update_post(number):
            title = request.forms.get('title').encode('latin-1').decode('utf-8')
            type = request.forms.get('type')
            explains = request.forms.get('explains').encode('latin-1').decode('utf-8')
            content = request.forms.get('content').encode('latin-1').decode('utf-8')
            practices = request.forms.get('practices').encode('latin-1').decode('utf-8')
            on_1 = request.forms.get('on_1')
            on_1= True if on_1 == "on" else False
            on_2 = request.forms.get('on_2')
            on_2= True if on_2 == "on" else False
            on_3 = request.forms.get('on_3')
            on_3= True if on_3 == "on" else False
            on= [on_1,on_2,on_3]
            self.update_task(title,type,explains,practices,content,number,on)

        @self.app.route('/admin/tasks/create', method='POST')
        def task_create_post():
            title = request.forms.get('title').encode('latin-1').decode('utf-8')
            type = request.forms.get('type')
            explains= request.forms.get('explains').encode('latin-1').decode('utf-8')
            content= request.forms.get('content').encode('latin-1').decode('utf-8')
            practices= request.forms.get('practices').encode('latin-1').decode('utf-8')
            self.insert_task(title,type,explains,practices,content)

        @self.app.route('/admin/students/update/<number>', method='POST')
        def student_update_post(number):
            username = request.forms.get('username').encode('latin-1').decode('utf-8')
            password = request.forms.get('password')
            selected_tasks = request.forms.getall('tasks')
            meta = request.forms.get('meta').encode('latin-1').decode('utf-8')
            user_id = request.forms.get('user_id')
            # Verifica se o checkbox de disponibilidade foi marcado
            availability = 'availability' in request.forms  # True se marcado, False se não
            self.update_student(username, password, meta, selected_tasks, \
            availability, {}, user_id)


        @self.app.route('/admin/admins/update/<number>', method='POST')
        def admin_update_post(number):
            username = request.forms.get('username').encode('latin-1').decode('utf-8')
            password = request.forms.get('password')
            meta = request.forms.get('meta').encode('latin-1').decode('utf-8')
            user_id = request.forms.get('user_id')
            if user_id == '1e6f5953-6ad5-400b-b884-df91fceb28ea':
                selected_permissions= ['Monitor','Professor']
                availability= True
            else:
                selected_permissions= []
                permission_monitor = request.forms.get('permission-monitor')
                permission_professor = request.forms.get('permission-professor')
                # Verifica se o checkbox de disponibilidade foi marcado
                availability = 'availability' in request.forms  # True se marcado, False se não
                if permission_monitor:
                    selected_permissions.append(permission_monitor)
                if permission_professor:
                    selected_permissions.append(permission_professor)
            self.update_admin(username, password, meta, {}, availability, selected_permissions, user_id)

        @self.app.route('/admin/students/create', method='POST')
        def student_create_post():
            username = request.forms.get('username').encode('latin-1').decode('utf-8')
            password = request.forms.get('password')
            meta = request.forms.get('meta').encode('latin-1').decode('utf-8')
            self.insert_student(username, password, meta)

        @self.app.route('/admin/admins/create', method='POST')
        def admin_create_post():
            username = request.forms.get('username').encode('latin-1').decode('utf-8')
            password = request.forms.get('password')
            meta = request.forms.get('meta').encode('latin-1').decode('utf-8')
            self.insert_admin(username, password, meta, {})

        @self.app.route('/admin/students/reset_them_all', method='POST')
        def admim_reset_post():
            self.reset_them_all()

        @self.app.route('/mentor/send_feedback', method='POST')
        def send_feedback_post():
            user_id= request.forms.get('user_id')
            question= request.forms.get('question').encode('latin-1').decode('utf-8')
            response= request.forms.get('response').encode('latin-1').decode('utf-8')
            feedback= request.forms.get('feedback').encode('latin-1').decode('utf-8')
            print('***********************************************************')
            print(f'User_id emitido pelo python: {user_id}')
            print(f'Question emitido pelo python: {question}')
            print(f'Response emitido pelo python: {response}')
            print(f'Feedback emitido pelo python: {feedback}')
            print('***********************************************************')
            task_number, level = self.tasks.get_task_data_by_text(question)
            question_id = self.tasks.get_number_by_question(question)
            self.sio.emit('mentor_feedback', {
                'user_id': user_id,
                'question': question,
                'response': response,
                'feedback': feedback
            })
            redirect('/mentor')

    ############################################################################
    # métodos controladores de páginas, usuários e tarefas

    def render(self, page, parameter=None):
        content = self.pages.get(page, self.index)
        if not parameter:
            return content()
        return content(parameter)

    def getAuthenticatedUsers(self):
        return UserRecord.Authenticated_users

    def getCurrentUserBySessionId(self):
        session_id = request.get_cookie('session_id')
        return UserRecord.Authenticated_users.get(session_id)

    def is_authenticated(self, username):
        current_user = self.getCurrentUserBySessionId()
        if current_user:
            return username == current_user.username
        return False

    def authenticate_user(self, username, password):
        session_student_id = self.students.verify_user(username, password)
        session_admin_id = self.admins.verify_user(username, password)
        if session_student_id:
            response.set_cookie('session_id', session_student_id, \
            httponly=True, secure=False, max_age=7200)
            redirect(f'/student')
        elif session_admin_id:
            response.set_cookie('session_id', session_admin_id, \
            httponly=True, secure=False, max_age=7200)
            redirect('/admin')
        else:
            redirect('/index')

    def logout_user(self):
        session_id = request.get_cookie('session_id')
        self.students.logout_user(session_id)
        self.admins.logout_user(session_id)
        response.delete_cookie('session_id')

    def delete_user(self):
        current_user = self.getCurrentUserBySessionId()
        self.logout_user()
        self.users.removeUser(current_user)
        redirect('/admin')

    def insert_student(self, username, password, meta):
        user_id= str(uuid.uuid4())
        self.students.create_user(username,password,meta,{},user_id)
        redirect('/admin')

    def insert_admin(self, username, password, meta, permissions):
        user_id= str(uuid.uuid4())
        self.admins.create_user(username,password,meta,permissions,user_id)
        redirect('/admin')

    def insert_task(self,title,type,explains,practices,content):
        number = str(uuid.uuid4())
        self.tasks.create_task(title,type,explains,practices,content,number)
        redirect('/admin')

    def update_task(self,title,type,explains,practices,content,number,on):
        self.tasks.update_task(title,type,explains,practices,content,number,on)
        redirect('/admin')

    def update_student(self,username,password,meta,tasks,availability,permissions,user_id):
        self.students.update_user(username,password,meta,tasks,availability,permissions,user_id)
        self.check_availability()
        redirect('/admin')

    def update_admin(self,username,password,meta,tasks,availability,permissions,user_id):
        self.admins.update_user(username,password,meta,tasks,availability,permissions,user_id)
        redirect('/admin')

    def delete_task(self,number):
        self.tasks.remove_task(number)
        for each_student in self.students.models:
            if number in each_student.tasks:
                del each_student.tasks[number]
        for each_admin in self.admins.models:
            if number in each_admin.tasks:
                del each_admin.tasks[number]
        redirect('/admin')

    def delete_user(self,number):
        self.students.remove_user(number)
        self.admins.remove_user(number)
        redirect('/admin')

    ############################################################################
    # Método alternativo de renderização: funcionalidade Block-endblock

    def jinja2_template(self,template_name, **kwargs):
        env = Environment(loader=FileSystemLoader('./app/views/html'))
        template = env.get_template(template_name)
        return template.render(**kwargs)

    def index(self):
        return self.jinja2_template('index.tpl')

    def student(self,user_id=None):
        current_user= self.getCurrentUserBySessionId()
        if current_user:
            if not current_user.is_admin():
                current_admin= None
                welcome= \
                f"""
                Estamos felizes com sua presença nesta turma de Orientação a Objetos!
                Confira nas tabelas abaixo as suas listas de micros e macros tarefas, bem com as respectivas evoluções ^^D.
                Desejamos a você uma excelente experiência!
                """
            else:
                current_admin = copy.deepcopy(current_user)
                current_user = self.students.get_user_by_id(user_id)
                welcome= \
                f"""
                Os avanços do(a) estudante {current_user.username} estão indicados nas tabelas
                abaixo.
                """
            # todas as micro e macro tarefas separadas
            micros= [task for task in self.tasks.models if task.type == "Micro"]
            macros= [task for task in self.tasks.models if task.type == "Macro"]
            # micro tarefas e macro tarefas filtradas para cada usuário
            user_micros= [task for task in micros if \
            task.number in current_user.tasks.keys()]
            user_macros= [task for task in macros if \
            task.number in current_user.tasks.keys()]
            # pontuações de cada micro e macro tarefas do usuário
            user_micros_numbers= [task.number for task in micros if \
            task.number in current_user.tasks.keys()]
            user_macros_numbers= [task.number for task in macros if \
            task.number in current_user.tasks.keys()]
            # envio para a pagina
            return self.jinja2_template('student.tpl', \
            welcome= welcome, \
            admin= current_admin, \
            user= current_user, \
            user_id= current_user.user_id, \
            user_micros= user_micros, \
            user_macros= user_macros)
        else:
            redirect('/index')

    def mentor(self):
        current_user = self.getCurrentUserBySessionId()
        if self.dojo_is_open:
            if current_user and current_user.is_admin:
                if current_user.on:
                    content= [cont for cont in self.content.contents if not cont.feedback]
                    self.show_content()
                    status_dojos= 'As avaliações foram iniciadas'
                    self.set_status_dojos(status_dojos)
                    return self.jinja2_template('mentor.tpl',user=current_user, \
                    content=content)
        redirect('/admin')

    def admin(self):
        current_user = self.getCurrentUserBySessionId()
        if current_user and current_user.is_admin():
                tasks= self.tasks
                students= self.students
                admins= self.admins
                return self.jinja2_template('admin.tpl', \
                user= current_user, tasks=tasks, students=students, \
                admins= admins, status_dojos=self.dojo_status)
        redirect('/index')

    def task(self, number):
        current_user = self.getCurrentUserBySessionId()
        if current_user:
            task = next((it for it in self.tasks.models \
            if it.number == number), None)
            return self.jinja2_template('task.tpl',user=current_user, \
            task=task, user_id=current_user.user_id)
        redirect('/index')

    def dojo(self,params):
        current_user = self.getCurrentUserBySessionId()
        if self.dojo_is_open:
            if current_user:
                if current_user.on:
                    number= params['number']
                    level= params['level']
                    if current_user and not current_user.is_admin():
                        task= self.tasks.get_task_by_number(number)
                        for question_id in current_user.done:
                            task.update_answered_number(level,question_id, \
                            current_user.user_id)
                        for question_id in current_user.lost:
                            task.update_answered_number(level,question_id, \
                            current_user.user_id)
                        for content in self.content.contents:
                            if current_user.user_id == content.user_id:
                                task.update_answered_number(level,content.question_id, \
                                current_user.user_id)
                        if task:
                            questions= task.questions(level,current_user.user_id)
                            if not questions:
                                if number not in current_user.crowded:
                                    current_user.crowded[number]= level
                                    self.students.save()
                            return self.jinja2_template('dojo.tpl', \
                            username=current_user.username, \
                            user=current_user, user_id= current_user.user_id, \
                            task=task, level=level, questions=questions)
        redirect('/student')

    def reciclar(self,user_id=None,task_number= None, task_level= None):
        tasks= self.tasks
        if user_id and ( task_number and task_level ):
            user= self.students.get_user_by_id(user_id)
            if task_number in user.crowded.keys():
                task= tasks.get_task_by_number(task_number)
                all_q_ids = {q["number"] for q in task.content[task_level]}
                for q_id in all_q_ids:
                    user.done.pop(q_id, None)
                    user.lost.pop(q_id, None)
                if task_number in user.crowded.keys():
                    del user.crowded[task_number]
        else:
            users= self.students.models
            for user in users:
                if user.crowded:
                    for task_number, level in user.crowded.items():
                        task= tasks.get_task_by_number(task_number)
                        all_q_ids = {q["number"] for q in task.content[level]}
                        for q_id in all_q_ids:
                            user.done.pop(q_id, None)
                            user.lost.pop(q_id, None)
                if task_number in user.crowded.keys():
                    del user.crowded[task_number]
        self.students.save()

    def generate_user_report(self, user_id):

        user = self.students.get_user_by_id(user_id)
        # Define o fuso horário de Brasília
        brasilia_tz = pytz.timezone('America/Sao_Paulo')
        # Obtém a data e hora atuais no fuso horário de Brasília
        time_now = datetime.now(brasilia_tz).strftime("%Y%m%d_%H%M%S")
        filename = f"Report_{user.username}_{user.password}@{time_now}.pdf"
        doc = SimpleDocTemplate(filename, pagesize=A4)
        elements = []
        styles = getSampleStyleSheet()

        title = Paragraph("Relatório de Avaliação de Dojo", styles['Title'])
        elements.append(title)

        # Data de geração do relatório
        date_str = datetime.now(brasilia_tz).strftime("%d/%m/%Y %H:%M:%S")
        date_paragraph = Paragraph(f"Data de Geração: {date_str}", styles['Normal'])
        elements.append(date_paragraph)
        elements.append(Paragraph("<br/><br/>", styles['Normal']))

        user_paragraph = Paragraph(f"Estudante: {user.username}", styles['Heading2'])
        elements.append(user_paragraph)
        elements.append(Paragraph("<br/><br/>", styles['Normal']))

        user_paragraph = Paragraph(f"Pontuação total:", styles['Normal'])
        elements.append(user_paragraph)
        elements.append(Paragraph("<br/><br/>", styles['Normal']))

        data = [["Tarefa", "Nível 1", "Nível 2", "Nível 3", "Nível 4"]]
        for task, hits in user.tasks_sum.items():
            title = self.tasks.get_task_by_number(task).title
            row = [f"Tarefa {title}"] + hits
            data.append(row)

        table = Table(data)
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.grey),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('GRID', (0, 0), (-1, -1), 1, colors.black),
        ]))

        elements.append(table)
        elements.append(Paragraph("<br/><br/>", styles['Normal']))

        # Variável para armazenar o conteúdo do relatório completo
        report_content = ""

        # Função auxiliar para adicionar respostas ao relatório e ao conteúdo
        def add_responses(responses, response_type):
            nonlocal report_content
            section_title = f"Últimas respostas {response_type} @ {date_str}\n\n"
            report_content += section_title
            elements.append(Paragraph(f"<b>{section_title.strip()}</b>", styles['Heading3']))

            if responses:
                for codigo, response in responses.items():
                    question = self.tasks.get_question_by_id(codigo)
                    if question:  # Verifique se a pergunta existe
                        report_content += f"Pergunta: {question}\nResposta: {response}\n\n"

                        question_paragraph = Paragraph(f"<b>Pergunta:</b> {question}", styles['Normal'])
                        elements.append(question_paragraph)

                        descricao_paragraph = Paragraph(f"<b>Resposta:</b> {response}", styles['Normal'])
                        elements.append(descricao_paragraph)

                        elements.append(Spacer(1, 12))
                    else:
                        print(f"Pergunta com código {codigo} não encontrada.")
            else:
                nenhum_texto = Paragraph(f"Nenhuma resposta foi encontrada para {response_type}.", styles['Normal'])
                elements.append(nenhum_texto)
                report_content += f"Nenhuma resposta foi encontrada para {response_type}.\n\n"

        # Adiciona as respostas corretas e incorretas ao PDF e ao conteúdo do relatório
        add_responses(user.done, "corretas")
        add_responses(user.lost, "erradas")

        try:
            print('Gerando relatório')
            doc.build(elements)
        except Exception as e:
            print(f"Erro ao gerar o PDF: {e}")

        # Salva o conteúdo completo no atributo `last` do usuário
        user.last = report_content
        self.students.save()

    def set_status_dojos(self, status_dojos):
        self.dojo_status= status_dojos
        if status_dojos == 'Os dojos foram abertos':
            self.dojo_status= 'Os dojos foram abertos'
            self.dojo_is_open= True
        elif status_dojos == 'Os dojos foram fechados':
            self.dojo_status= 'Os dojos foram fechados'
            self.dojo_is_open= False
            # Ações após fechamento
            self.evaluate_dojos()
            self.content.clear_all()
            self.tasks.reset_submission()
        elif status_dojos == 'As avaliações foram iniciadas':
            self.sio.emit('update_status_dojos', {'status_dojos': status_dojos}, room='mentors')

    def evaluate_dojos(self):
        self.students.summation()
        self.students.reset_tasks()
        self.students.save()

    def reset_them_all(self):
        students= self.students
        for student in students.models:
            tasks= student.tasks
            for number, points in tasks.items():
                tasks[number]= [0,0,0,0]
            student.tasks_sum= {}
            student.done= {}
            student.last= ""
        self.students.save()
        redirect('/admin')

    def check_availability(self):
        print('Checando a disponibilidade de cada estudante')
        admins= self.admins.models
        students= self.students.models
        for student in students:
            if not student.on:
                print('Um estudante encontrado com status desabilitado')
                user_id= student.user_id
                self.sio.emit('disable_student', {}, room= user_id)

    def show_content(self):
        self.content.print_all()

    ############################################################################
    # Websocket events (cables and chanels):

    def setup_websocket_events(self):

        @self.sio.event
        async def connect(sid, environ):
            print(f'Client connected{{ user_id | tojson }};: {sid}')
            self.sio.emit('conget_task_data_by_nected', {'data': 'Connected'}, room=sid)

        @self.sio.event
        async def disconnect(sid):
            print(f'Client disconnected: {sid}')

        @self.sio.event
        def submit_response(sid, data):
            user_id = data['user_id']
            question_id = data['question_id']
            question= data['question']
            response = data['response']
            self.content.add_content(user_id,question_id,question,response,None)
            self.sio.emit('new_response', {'user_id': user_id, 'question_id': question_id, 'question': question, 'response': response}, room='mentors')

        @self.sio.event
        def mentor_feedback(sid, data):
            user_id = data['user_id']
            response= data['response']
            feedback = data['feedback']
            question= data['question']
            question_id= data['question_id']
            task_number, task_level= self.tasks.get_task_data_by_number(question_id)
            self.content.update_content(user_id,question_id, feedback)
            task= self.tasks.get_task_by_number(task_number)
            task.update_answered_number(task_level,question_id, user_id)
            if feedback == "Correta":
                self.students.add_question_data_to_done(question_id,response,user_id)
                self.students.add_points_to_task(task_number,task_level,user_id)
            else:
                self.students.add_question_data_to_lost(question_id,response,user_id)
            self.sio.emit('receive_feedback', {'feedback': feedback, 'question_id': question_id, 'response': response}, room=user_id)
            self.sio.emit('app_update_handle_button', {'question_id': question_id}, room='mentors')

        @self.sio.event
        def send_status_dojos(sid, data):
            status_dojos = data['status_dojos']
            self.set_status_dojos(status_dojos)
            self.sio.emit('update_status_dojos', {'status_dojos': status_dojos}, room='mentors')
            if status_dojos == 'Os dojos foram fechados':
                self.sio.emit('close_order', {'status_dojos': status_dojos})

        @self.sio.event
        def send_status_tasks(sid, data):
            if data['status_tasks'] == "Atualizar":
                self.tasks.reload()
                micros = [task.to_dict() for task in self.tasks.models if task.type == "Micro"]
                macros = [task.to_dict() for task in self.tasks.models if task.type == "Macro"]
                self.sio.emit('send_updated_status_tasks', {'micros': micros, 'macros': macros})

        @self.sio.event
        def join(sid, data):
            role = data['role']
            if role == 'user':
                user_id = data['user_id']
                self.users_sessions[user_id] = sid
                self.sio.enter_room(sid, user_id)
                print(f'Usuário: {user_id} entrando em uma sala')
            elif role == 'mentor':
                self.sio.enter_room(sid, 'mentors')
                print(f'Mentor entrando em uma sala')
