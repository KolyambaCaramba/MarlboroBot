from handlers import create_connection

sql_generator_text = open('sql_generator.txt', 'r')

def init_database():
    conn = create_connection()
     # Создаем курсор для выполнения SQL-запросов
    cursor = conn.cursor()


    cursor.execute(sql_generator_text)

    # Закрываем курсор и соединение с базой данных
    cursor.close()
    conn.close()
