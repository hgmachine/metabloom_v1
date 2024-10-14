from app.models.job_model import Job

class DojoRecord:

    def __init__(self):
        self.close()
        self.restart()
        self.set_status('')

    def open(self):
        self.is_open= True
        self.set_status('Os dojos foram abertos')

    def close(self):
        self.is_open= False
        self.set_status('Os dojos foram fechados')

    def create_job(self, user_id, task_number, task_level):
        job = Job(user_id, task_number, task_level)
        self.jobs.append(job)
        print(f"Nova tarefa criada para o usuário com ID {user_id}.")

    def hit_to_job(self, user_id, task_number, task_level):
        for job in self.jobs:
            if (job.user_id == user_id and job.task_number == task_number) and job.task_level == task_level:
                job.task_hits = job.task_hits + 1
                print(f'O usuário com ID {user_id} obteve um acerto na tarefa de numero {task_number} e level {task_level}.')
                print(f'Quantidade atualizada de acertos: {job.task_hits}')
                return job
        return None

    def read_jobs_from_user_id(self, user_id):
        return [job for job in self.jobs if job.user_id == user_id]

    def get_all_jobs(self):
        return self.jobs

    def restart(self):
        self.jobs= []
        self.set_status("Os dojos foram reiniciados")

    def set_status(self,message):
        self.__status= message

    def get_status(self):
        return self.__status
