from abc import ABC
import json
from filelock import FileLock  # Importa a biblioteca de bloqueio de arquivos


class DataRecord(ABC):

    """Modelo para Serialização de objetos em JSON"""

    def __init__(self, database, model_class):
        self.models = []
        self.model_class = model_class
        self.database = database + '_database'
        self.lock_file = f"app/controllers/db/{self.database}.lock"  # Arquivo de lock

    def load_objects(self):
        with FileLock(self.lock_file):
            try:
                with open(f"app/controllers/db/{self.database}.json", "r") as fjson:
                    file_data = json.load(fjson)
                    self.models = [self.model_class(**data) for data in file_data]
                    return True
            except FileNotFoundError:
                print(f'O banco {self.database} não foi carregado com sucesso!')
                return False

    def write_objects(self):
        with FileLock(self.lock_file):
            try:
                with open(f"app/controllers/db/{self.database}.json", "w") as fjson:
                    file_data = [vars(obj) for obj in self.models]
                    json.dump(file_data, fjson, indent=4)  # Formatação melhorada para o JSON
                    return True
            except FileNotFoundError:
                print(f'O banco {self.database} não foi gravado com sucesso!')
                return False
