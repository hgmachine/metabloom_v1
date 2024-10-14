# Usar a imagem base do Python
FROM python:3.12-slim

# Atualizar o pip e instalar as bibliotecas necessárias
RUN pip install --upgrade pip && \
    pip install bottle eventlet python-socketio reportlab jinja2
    
# Definir o diretório de trabalho
WORKDIR /bmeta

# Copiar todos os arquivos da aplicação para o contêiner
COPY . /bmeta

# Expor a porta que o aplicativo usa
EXPOSE 8080

# Comando para executar a aplicação
CMD ["python3", "startserver.py"]
