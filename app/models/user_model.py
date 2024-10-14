import uuid



class UserAccount():

    def __init__(self, username, password, meta, user_id, done, tasks={}, permissions=[]):
        self.username= username
        self.password= password
        self.tasks= tasks # dicionário {"task-number":"pontuações por nivel"}
        self.meta= meta # meta de aprendizagem
        self.user_id= user_id # identidade única
        self.permissions= [] # sem permissões neste nível
        self.done= done # tarefas realizadas (numbers)


    def is_admin(self):
        return False



class SuperAccount(UserAccount):

    def __init__(self, username, password, meta, user_id, tasks={}, permissions= [], done= []):
        super().__init__(username, password, meta, user_id, done, tasks, permissions)
        self.permissions= permissions
        if not permissions:
            self.permissions= ['monitor']

    def is_admin(self):
        return True
