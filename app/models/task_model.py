import random

class Task:
    def __init__(self, title, type, explains, practices, content, number, on=None):
        self.title = title
        self.type = type
        self.explains = explains  # Lista de dicionários {"assunto": "explicação"}
        self.practices = practices  # Lista de dicionários {"assunto": "explicação"}
        self.content = content  # Dicionário de perguntas por nível {"1":[{"text": "...", "number": "..."}, ...]}
        self.number = number  # Identificador único da tarefa
        self.on = on if on is not None else [False, False, False, False]
        self.answered_numbers = {"1": [], "2": [], "3": []}  # Mantemos os índices respondidos

    def get_index_by_id(self, level, question_id):
        """Retorna o índice da pergunta correspondente ao question_id."""
        questions = self.content[level]
        for index, question in enumerate(questions):
            if question["number"] == question_id:  # Verifica se o número (ID) da pergunta é igual ao question_id
                return index
        raise ValueError(f"ID {question_id} não encontrado no nível {level}.")

    def __sorttask(self, level):
        """Sorteia perguntas de um nível específico, evitando IDs respondidos."""
        if level not in self.content:
            raise ValueError("Nível inválido. Escolha entre '1', '2' ou '3'.")

        questions = self.content[level]

        # Verifica se o número de perguntas é suficiente
        if len(questions) < 1:
            raise ValueError(f"A lista de perguntas para o nível {level} deve ter pelo menos 1 pergunta.")

        # Cria a lista de IDs disponíveis, excluindo aqueles já respondidos
        answered_ids = self.answered_numbers[level]
        available_numbers = [q["number"] for q in questions if q["number"] not in answered_ids]

        # Se houver menos de 10 perguntas disponíveis, retorna o que está disponível
        num_to_select = min(10, len(available_numbers))
        if num_to_select < 1:
            print(f"Não há perguntas disponíveis para o nível {level}.")
            return []

        # Seleciona índices aleatórios dos disponíveis
        selected_numbers = random.sample(available_numbers, num_to_select)
        return selected_numbers

    def update_answered_number(self, level, question_id):
        """Adiciona o question_id aos índices respondidos."""
        if question_id not in self.answered_numbers[level]:
            self.answered_numbers[level].append(question_id)

    def questions(self, level):
        """Retorna as perguntas sorteadas de um nível específico e seus números"""
        try:
            question_ids = self.__sorttask(level)  # Obtemos os IDs das perguntas
            if not question_ids:
                return False
            # Retorna as perguntas correspondentes aos IDs
            return [next(q for q in self.content[level] if q["number"] == question_id) for question_id in question_ids]
        except ValueError as e:
            print(f"Erro: {e}")
            return []

    def to_dict(self):
        return {
            'title': self.title,
            'type': self.type,
            'explain': self.explains,
            'practices': self.practices,
            'content': self.content,
            'number': self.number,
            'on': self.on,
            'answered_numbers': self.answered_numbers
        }

    def __repr__(self):
        return f"Task(title={self.title}, type={self.type}, number={self.number})"
