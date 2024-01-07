# Используем базовый образ Python
FROM python:3.9

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем файлы зависимостей в контейнер
COPY requirements.txt .

# Устанавливаем зависимости
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Копируем все файлы проекта в контейнер
COPY . .

# Устанавливаем часовой пояс на Московский
RUN ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

# Запускаем приложение при старте контейнера
CMD ["python", "run_scripts.py"]