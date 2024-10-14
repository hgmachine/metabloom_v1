from app.models.content_model import Content



class ContentRecord:
    def __init__(self):
        self.clear_all()

    def add_content(self, user_id, question_id, question, response, feedback):
        if not self.get_response_by_question(question):
            new_content = Content(user_id, question_id, question, response, feedback)
            self.contents.append(new_content)
            return True
        print("A pergunta já existe.")
        return False

    def get_response_by_question(self, question):
        for content in self.contents:
            if content.question == question:
                return content.response
        print("Pergunta não encontrada.")
        return False

    def update_content(self,user_id,question_id,question,response,feedback):
        for content in self.contents:
            if content.user_id == user_id:
                if content.question_id == question_id:
                    content.question= question
                    content.response= response
                    content.feedback= feedback
                    return True
        print("O ID do usuário ou da pergunta não existe!")
        return False

    def clear_all(self):
        self.contents = []
