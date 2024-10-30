from app.controllers.data_record import DataRecord
from app.models.task_model import Task
from abc import ABC
import uuid


class TaskRecord(DataRecord):
    """Modelo para CRUD de tarefas"""

    def __init__(self, database):
        super().__init__(database, Task)
        self.load_objects()

    def update_task(self, title, type, explains, practices, content, number, on):
        for task in self.models:
            if number == task.number:
                task.title = title
                task.explains = explains
                task.practices = practices
                task.content = content
                task.type = type
                task.on = on
                self.write_objects()
                return True
        return False


    def get_number_by_question(self,question):
        for task in self.models:
            for level in task.content:
                content= task.content[level]
                for each_content in content:
                    if question in each_content['text']:
                        return each_content['number']
        return None

    def get_question_by_id(self, question_id):
        for task in self.models:
            for level in task.content:
                content = task.content[level]
                for each_content in content:
                    if each_content['number'] == question_id:
                        return each_content['text']
        return None

    def get_task_data_by_text(self, question):
        for task in self.models:
            for level in task.content:
                content= task.content[level]
                for each_content in content:
                    if question in each_content['text']:
                        return task.number, level
        return None

    def get_task_data_by_number(self, question_id):
        for task in self.models:
            for level in task.content:
                content= task.content[level]
                for each_content in content:
                    if question_id in each_content['number']:
                        return task.number, level
        return None

    def create_task(self, title, type, explains, practices, content, number):
        for existing_task in self.models:
            if existing_task.title == title:
                return False
        new_task = Task(title, type, explains, practices, content, number, False)
        self.models.append(new_task)
        self.write_objects()
        return True

    def get_task_by_number(self, number):
        for task in self.models:
            if task.number == number:
                return task
        return None

    def remove_task(self, number):
        for task in self.models:
            if task.number == number:
                self.models.remove(task)
                self.write_objects()
                return True
        return False

    def set_all_tasks(self, status):
        for task in self.models:
            task.on = status

    def reset_submission(self):
        for task in self.models:
            task.reset_answered_numbers()

    def reload(self):
        """Recarrega as tarefas a partir do banco de dados."""
        self.load_objects()
        print("Tarefas recarregadas com sucesso.")
