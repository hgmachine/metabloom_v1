import uuid



class UserAccount():

    def __init__(self, username, password, meta, user_id, done, on, tasks={}, permissions=[], tasks_sum={}, last= ""):
        self.username= username
        self.password= password
        self.tasks= tasks # dicionário {"task-number":"pontuações por nivel"}
        self.meta= meta # meta de aprendizagem
        self.user_id= user_id # identidade única
        self.permissions= [] # sem permissões neste nível
        self.done= done # tarefas realizadas (numbers)
        self.on= on # o aluno está disponpivel ou não
        self.tasks_sum= tasks_sum # quantidade de estrelas por tarefa
        self.last= last # último relatório realizado


    def is_admin(self):
        return False



class SuperAccount(UserAccount):

    def __init__(self, username, password, meta, user_id, done, on, tasks={}, permissions= [], tasks_sum={}, last=""):
        super().__init__(username, password, meta, user_id, done, on, tasks, permissions, tasks_sum, last)
        self.permissions= permissions
        if not permissions:
            self.permissions= ['monitor']

    def is_admin(self):
        return True
