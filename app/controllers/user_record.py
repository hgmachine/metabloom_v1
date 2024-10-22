from app.controllers.data_record import DataRecord
from app.models.user_model import UserAccount, SuperAccount
import uuid




class UserRecord(DataRecord):


    """Modelo para CRUD e autenticação de usuários"""

    Authenticated_users = {}

    def __init__(self, database, model_class):
        super().__init__(database, model_class)
        self.load_objects()


    def get_current_user_by_id(self, session_id):
        user= UserRecord.Authenticated_users.get(session_id)
        if user:
            return user
        return None

    def add_question_data(self,question_number,response,user_id):
        for user in self.models:
            if user_id == user.user_id:
                if question_number not in user.done:
                    user.done[question_number]= response
                self.write_objects()
                return True
        return False

    def get_user_by_id(self, user_id):
        for user in self.models:
            if user.user_id == user_id:
                return user
        return None

    def update_user(self, username, password, meta, tasks, availability, permissions, user_id):
        for user in self.models:
            if user_id == user.user_id:
                user.username = username
                user.password = password
                user.meta = meta
                user.on= availability
                for task in tasks:
                    if task not in user.tasks:
                        user.tasks[task] = [0,0,0,0]
                numbers_to_remove = [key for key in user.tasks if key not in tasks]
                for number in numbers_to_remove:
                    del user.tasks[number]
                user.permissions = permissions
                self.write_objects()
                return True
        return False

    def save(self):
        self.write_objects()

    def create_user(self, username, password, meta, permissions, user_id):
        for existing_user in self.models:
            if existing_user.user_id == user_id:
                return False
        new_user = self.model_class(username, password, meta, user_id, \
        False, {}, permissions)
        self.models.append(new_user)
        self.write_objects()
        return True

    def reset_tasks(self):
        for user in self.models:
            user.done= {}
            if not user.is_admin():
                for key in user.tasks.keys():
                    user.tasks[key] = [0, 0, 0, 0]
        self.save()

    def remove_user(self, user_id):
        for user in self.models:
            if user.user_id == user_id:
                self.models.remove(user)
                self.write_objects()
                return True
        return False


    def verify_user(self, username, password):
        for user in self.models:
            if user.username == username and user.password == password:
                session_id = str(uuid.uuid4())
                UserRecord.Authenticated_users[session_id] = user
                return session_id
        return False


    def logout_user(self, session_id):
        if session_id in UserRecord.Authenticated_users:
            del UserRecord.Authenticated_users[session_id]
            return True
        return False
