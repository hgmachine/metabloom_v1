from app.models.content_model import Content



class ContentRecord:
    def __init__(self):
        self.clear_all()

    def add_content(self, user_id, question_id, question, response, feedback):
        if not self.get_response_by_question(question, user_id):
            new_content = Content(user_id, question_id, question, response, feedback)
            self.contents.append(new_content)
            return True
        print("A pergunta já existe.")
        return False

    def get_response_by_question(self, question, user_id):
        for content in self.contents:
            if content.question == question and content.user_id == user_id:
                return content.response
        print("Pergunta não encontrada.")
        return False

    def update_content(self,user_id,question_id,feedback):
        for content in self.contents:
            if content.user_id == user_id:
                if content.question_id == question_id:
                    content.feedback= feedback
                    return True
        return False

    def print_all(self):
        for content in self.contents:
            print(content)

    def clear_all(self):
        self.contents = []
