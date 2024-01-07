import psycopg2
from aiogram import types, F, Router
from aiogram.types import Message
from aiogram.filters import Command

import kb
import text

router = Router()

@router.message(Command("start"))
async def start_handler(msg: Message):
    # Отправляем приветственное сообщение с именем пользователя и меню
    await msg.answer(text.greet.format(name=msg.from_user.full_name), reply_markup=kb.menu)

@router.message(F.text == "Меню")
@router.message(F.text == "Выйти в меню")
async def menu(msg: Message):
    # Отправляем текст меню с клавиатурой
    await msg.answer(text.menu, reply_markup=kb.menu)

@router.message(Command("lastm"))
async def message_handler(msg: Message):
    # Устанавливаем соединение с базой данных
    conn = psycopg2.connect(
        host="localhost",
        database="MarlBoro-001",
        user="postgres",
        password="123qwe"
    )
    try:
        # Создаем курсор для выполнения SQL-запросов
        with conn.cursor() as cursor:
            # Извлекаем список результатов из таблицы match
            cursor.execute("SELECT scored, missed, opponent FROM matches;")
            results_list = cursor.fetchall()
             # Формируем текстовый список результатов
            results_list_text = "Последние матчи команды:\n" + "\n".join(
                f"Marlboro - {scored} - {missed} - {opponent}" for scored, missed, opponent in results_list
            )
             # Создаем список кнопок с оппонентами
            buttons = [
                types.InlineKeyboardButton(text=f"({scored}:{missed}) - {opponent}", callback_data=f"match:{opponent}")
                for scored, missed, opponent in results_list
            ]
             # Разбиваем список кнопок на две колонки
            columns = 2
            inline_keyboard = types.InlineKeyboardMarkup(
                inline_keyboard=[buttons[i:i + columns] for i in range(0, len(buttons), columns)]
            )
             # Отправляем сообщение с результатами и inline клавиатурой
            await msg.answer("Выберите матч:\n\n" + results_list_text, reply_markup=inline_keyboard)
    finally:
        # Закрываем соединение с базой данных
        conn.close()

@router.callback_query(F.data == "lastm")
async def callback_query_handler(query: types.CallbackQuery):
    # Устанавливаем соединение с базой данных
    conn = psycopg2.connect(
        host="localhost",
        database="MarlBoro-001",
        user="postgres",
        password="123qwe"
    )

    # Создаем курсор для выполнения SQL-запросов
    cursor = conn.cursor()

    # Извлекаем список игроков из таблицы player
    cursor.execute("SELECT scored, missed, opponent FROM matches;")
    results_list = cursor.fetchall()

    # Закрываем курсор и соединение с базой данных
    cursor.close()
    conn.close()

    # Формируем текстовый список результатов
    results_list_text = "Посление матчи команды:\nMarlboro - " + "\nMarlboro - ".join(
        " - ".join(str(item) for item in row) for row in results_list)
    chat_id = query.message.chat.id
    await query.bot.send_message(chat_id, results_list_text)

@router.message(Command("players"))
async def message_handler(msg: Message):
    # Устанавливаем соединение с базой данных
    conn = psycopg2.connect(
        host="localhost",
        database="MarlBoro-001",
        user="postgres",
        password="123qwe"
    )
     # Создаем курсор для выполнения SQL-запросов
    cursor = conn.cursor()
     # Извлекаем список игроков из таблицы player
    cursor.execute("SELECT first_name, last_name FROM players")
    player_list = cursor.fetchall()
     # Закрываем курсор и соединение с базой данных
    cursor.close()
    conn.close()
     # Создаем список кнопок с фамилиями игроков
    buttons = []
    for row in player_list:
        last_name = row[1]
        buttons.append(types.InlineKeyboardButton(text=last_name, callback_data=f"players:{last_name}"))
     # Разбиваем список кнопок на две колонки
    columns = 2
    inline_keyboard = types.InlineKeyboardMarkup(inline_keyboard=[buttons[i:i+columns] for i in range(0, len(buttons), columns)])
    await msg.answer("Выберите игрока:", reply_markup=inline_keyboard)

@router.callback_query(lambda c: c.data.startswith('players:'))
async def player_callback_handler(query: types.CallbackQuery):
    # Извлекаем фамилию игрока из callback_data
    last_name = query.data.split(':')[1]
     # Устанавливаем соединение с базой данных
    conn = psycopg2.connect(
        host="localhost",
        database="MarlBoro-001",
        user="postgres",
        password="123qwe"
    )
     # Создаем курсор для выполнения SQL-запросов
    with conn.cursor() as cursor:
        # Извлекаем данные игрока из таблицы player
        cursor.execute("SELECT first_name, birthday FROM players WHERE last_name = %s", (last_name,))
        player_data = cursor.fetchone()
        if player_data is None:
            await query.message.answer("Данные об игроке не найдены")
            return
        first_name, birthday = player_data
         # Извлекаем данные о голах игрока из таблицы goal_detail
        cursor.execute(
            "SELECT count(*) FROM goal_details WHERE who_score = (SELECT player_id FROM players WHERE last_name = %s)",
            (last_name,))
        goals_scored = cursor.fetchone()[0]

        # Извлекаем данные о сыгранных матчах из таблицы match_player
        cursor.execute(
            "SELECT count(*) FROM matches_players WHERE player_id = (SELECT player_id FROM players WHERE last_name = %s)",
            (last_name,))
        match_player = cursor.fetchone()[0]

        # Извлекаем данные о голевых передачах из таблицы goal_detail
        cursor.execute(
            "SELECT count(*) FROM goal_details WHERE who_assist = (SELECT player_id FROM players WHERE last_name = %s)",
            (last_name,))
        goal_assists = cursor.fetchone()[0]

        # Извлекаем данные о номере на футболке из таблицы json_mbr
        cursor.execute(
            "SELECT data-> 'jersey' FROM json_mbr WHERE id = (SELECT player_id FROM players WHERE last_name = %s)",
            (last_name,))
        jersey_number = cursor.fetchone()[0]

        # Извлекаем данные о позиции из таблицы json_mbr
        cursor.execute(
            "SELECT data-> 'position' FROM json_mbr WHERE id = (SELECT player_id FROM players WHERE last_name = %s)",
            (last_name,))
        position = cursor.fetchone()[0]

        # Извлекаем данные о стране из таблицы json_mbr
        cursor.execute(
            "SELECT data-> 'country' FROM json_mbr WHERE id = (SELECT player_id FROM players WHERE last_name = %s)",
            (last_name,))
        country = cursor.fetchone()[0]

     # Формируем сообщение с данными игрока
    message = f"Досье игрока:\n\n"
    message += f"Имя - {last_name}, {first_name}\n"
    message += f"Номер - {jersey_number} \n"
    message += f"Позиция - {position} \n"
    message += f"Дата рождения - {birthday}\n"
    message += f"Страна - {country} \n"
    message += f"Сыграно матчей - {match_player} \n"
    message += f"Голов забито - {goals_scored}\n"
    message += f"Голевых передач - {goal_assists}\n"
     # Отправляем сообщение с досье игрока
    await query.message.answer(message)

@router.callback_query(F.data == "players")
async def callback_query_handler(query: types.CallbackQuery):
    # Устанавливаем соединение с базой данных
    conn = psycopg2.connect(
        host="localhost",
        database="MarlBoro-001",
        user="postgres",
        password="123qwe"
    )

    # Создаем курсор для выполнения SQL-запросов
    cursor = conn.cursor()

    # Извлекаем список игроков из таблицы player
    cursor.execute("SELECT first_name, last_name FROM players")
    player_list = cursor.fetchall()

    # Закрываем курсор и соединение с базой данных
    cursor.close()
    conn.close()

    # Отправляем команду в чат
    player_list_text = "\n".join(", ".join(str(item) for item in row) for row in player_list)
    chat_id = query.message.chat.id
    await query.bot.send_message(chat_id, player_list_text)

@router.callback_query(F.data == "results")
async def callback_query_handler(query: types.CallbackQuery):
     # Устанавливаем соединение с базой данных
    conn = psycopg2.connect(
        host="localhost",
        database="MarlBoro-001",
        user="postgres",
        password="123qwe"
    )
     # Создаем курсор для выполнения SQL-запросов
    with conn.cursor() as cursor:

        # Извлекаем данные игрока из таблицы matches
        cursor.execute("SELECT count(match_id) FROM matches")
        matches_played = cursor.fetchone()[0]

        # Извлекаем данные о забитых голах из таблицы match_player
        cursor.execute(
            "SELECT count(*) FROM goal_details WHERE who_score != 0")
        goal_scored = cursor.fetchone()[0]

        # Извлекаем данные о количестве ассистов из таблицы match_player
        cursor.execute(
            "SELECT count(*) FROM goal_details WHERE who_assist != 0")
        goal_assists = cursor.fetchone()[0]

        # Извлекаем данные о сыгранных матчах из таблицы match_player
        cursor.execute(
            "select max(extract(year from age(current_date, birthday))) from players")
        max_age = cursor.fetchone()[0]

        # Извлекаем данные о сыгранных матчах из таблицы match_player
        cursor.execute(
            "select min(extract(year from age(current_date, birthday))) from players")
        min_age = cursor.fetchone()[0]

     # Формируем сообщение с данными игрока
    message = f"Результаты Marlboro:\n\n"
    message += f"Число игр - {matches_played}\n"
    message += f"Забито голов - {goal_scored}\n"
    message += f"Число ассистов - {goal_assists} \n"
    message += f"Возрастной диапазон - {min_age} - {max_age}\n"
     # Отправляем сообщение с досье игрока
    await query.message.answer(message)

@router.message(Command("results"))
async def message_handler(msg: Message):
    # Устанавливаем соединение с базой данных
    conn = psycopg2.connect(
         host="localhost",
         database="MarlBoro-001",
         user="postgres",
         password="123qwe"
    )
         # Создаем курсор для выполнения SQL-запросов
    with conn.cursor() as cursor:
             # Извлекаем данные игрока из таблицы matches
        cursor.execute("SELECT count(match_id) FROM matches")
        matches_played = cursor.fetchone()[0]

             # Извлекаем данные о забитых голах из таблицы match_player
        cursor.execute("SELECT count(*) FROM goal_details WHERE who_score != 0")
        goal_scored = cursor.fetchone()[0]

             # Извлекаем данные о количестве ассистов из таблицы match_player
        cursor.execute("SELECT count(*) FROM goal_details WHERE who_assist != 0")
        goal_assists = cursor.fetchone()[0]

             # Извлекаем данные о сыгранных матчах из таблицы match_player
        cursor.execute("select max(extract(year from age(current_date, birthday))) from players")
        max_age = cursor.fetchone()[0]

             # Извлекаем данные о сыгранных матчах из таблицы match_player
        cursor.execute("select min(extract(year from age(current_date, birthday))) from players")
        min_age = cursor.fetchone()[0]

         # Формируем сообщение с данными игрока
        message = f"Результаты Marlboro:\n\n"
        message += f"Число игр - {matches_played}\n"
        message += f"Забито голов - {goal_scored}\n"
        message += f"Число ассистов - {goal_assists} \n"
        message += f"Возрастной диапазон - {min_age} - {max_age}\n"
         # Отправляем сообщение с досье игрока
        await msg.answer(message)
