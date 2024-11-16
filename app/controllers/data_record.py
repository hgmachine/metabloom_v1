from abc import ABC
import json
from filelock import FileLock  # Importa a biblioteca de bloqueio de arquivos
import time

class DataRecord(ABC):
    """Modelo para Serialização de objetos em JSON com controle de concorrência"""

    def __init__(self, database, model_class):
        self.models = []
        self.model_class = model_class
        self.database = database + '_database'
        self.db_path = f"app/controllers/db/{self.database}.json"
        self.lock_file = f"{self.db_path}.lock"  # Arquivo de lock

    def load_objects(self):
        """Carrega objetos a partir do arquivo JSON, com lock para evitar concorrência"""
        with FileLock(self.lock_file, timeout=10):  # Espera até 10 segundos para adquirir o lock
            try:
                with open(self.db_path, "r") as fjson:
                    file_data = json.load(fjson)
                    self.models = [self.model_class(**data) for data in file_data]
                    return True
            except FileNotFoundError:
                print(f'O banco {self.database} não foi carregado com sucesso!')
                return False

    def write_objects(self):
        """Grava os dados no arquivo JSON com controle de concorrência"""
        retries = 5  # Número de tentativas caso o lock não seja adquirido
        timeout = 10  # Tempo máximo de espera para adquirir o lock (em segundos)

        for attempt in range(retries):
            try:
                with FileLock(self.lock_file, timeout=timeout):  # Timeout de 10 segundos
                    with open(self.db_path, "w") as fjson:
                        file_data = [vars(obj) for obj in self.models]
                        json.dump(file_data, fjson, indent=4)  # Formatação melhorada para o JSON
                    print(f"Operação de gravação bem-sucedida na tentativa {attempt + 1}")
                    return True
            except TimeoutError:
                print(f"Tentativa {attempt + 1} de {retries}: Timeout ao tentar obter o lock.")
                time.sleep(1)  # Espera 1 segundo antes de tentar novamente
            except Exception as e:
                print(f"Erro ao gravar no banco {self.database}: {e}")
                return False

        print(f"Erro: Todas as {retries} tentativas de gravação falharam.")
        return False

    def add_object(self, new_object):
        """Adiciona um objeto à lista e grava os dados"""
        self.models.append(new_object)
        return self.write_objects()
