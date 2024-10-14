class Job():

    def __init__(self,user_id,task_number,task_level,task_hits=None):

        self.user_id= user_id
        self.task_number= task_number
        self.task_level= task_level
        self.task_hits= task_hits if task_hits is not None else 0

    def __str__(self):
        return (f"Job Details:\n"
                f"User ID: {self.user_id}\n"
                f"Task Number: {self.task_number}\n"
                f"Task Level: {self.task_level}\n"
                f"Task Hits: {self.task_hits}")
