class Content:
    def __init__(self, user_id, question_id, question, response, feedback):
        self.user_id = user_id
        self.question = question
        self.response = response
        self.question_id = question_id
        self.feedback= feedback

    def __str__(self):
        return f"Question_Id: {self.question_id}, Response: {self.response}, Feedback: {self.feedback}"
