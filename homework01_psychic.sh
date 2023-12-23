#!/bin/bash

# 1. Скрипт генерирует случайное целое число в диапазоне от 0 до 9.
# 2. Выводит пользователю номер хода и приглашение ввести число в диапазоне от 0 до 9.
# 3. Введённое пользователем число скрипт проверяет на допустимый диапазон от 0 до 9 и при ошибке предлагает повторить ввод числа. Ошибкой так же считается ввод не цифровых символов (кроме символа q) и чисел состоящих из двух и более цифр.
# 4. Если введено корректное число, то скрипт сообщает угадано число или нет и выводит загаданное число и переходит к первому шагу.
# 5. Игра прекращается, когда пользователь введёт символа q, вместо числа.

# Дополнительно скрипт на каждом шаге выводит статистику игры:

# -Долю угаданных чисел в процентах.
# -Долю не угаданных чисел в процентах.
# -10 последних чисел разделённые пробелом, которые были загаданы скриптом, при этом числа угаданные пользователем выделяются зелёным цветом, а не угаданные числа выделяются кранным цветом.

RED='\e[31m'
GREEN='\e[32m'
RESET='\e[0m'

declare -i correct_guesses=0
declare -i total_guesses=0
declare -a answers=()

while true; 
do
    number_to_guess=$((RANDOM % 10))
    echo "Шаг $((total_guesses + 1))"
    read -p "Введите число от 0 до 9 (или 'q' для выхода): " answer

    case "${answer}" in
        [0-9])
            if [[ "$answer" -eq "$number_to_guess" ]]; then
                correct_guesses+=1
                number_string="${GREEN}$number_to_guess${RESET}"
                echo -e "${GREEN}Правильно!${RESET} Вы угадали число ${number_string}.🎉"
            else
                number_string="${RED}$number_to_guess${RESET}"
                echo -e "${RED}Неверно.${RESET} Загаданное число было ${number_string}.😖"
            fi

            answers+=(${number_string})
            total_guesses+=1
        ;;
        q)
            echo "Игра завершена. Спасибо за участие!🙂"
            exit 0
        ;;
        *)
            echo "Ошибка: Введите корректное число от 0 до 9 или 'q' для выхода.😥"
            continue
        ;;
    esac

    echo -e "Статистика игры:"
    let correct_percentage=correct_guesses*100/total_guesses
    let incorrect_percentage=100-correct_percentage

    echo "Угадано: $correct_guesses ($correct_percentage%)"
    echo "Не угадано: $((total_guesses - correct_guesses)) ($incorrect_percentage%)"
    
    if ((${#answers[@]} >= 10))
        then
            echo -e "Последние 10 чисел: ${answers[@]: -10} \n"
        else
            echo -e "Последние ${#answers[@]} чисел: ${answers[@]} \n"
    fi
done