import sys
from time import sleep

import asyncer

from src.car_talker import add_car, get_count_car


async def main():
    count_car = await get_count_car()
    print("Numero de carros atual:", count_car)

    N = int(input("Qual o numero de entidades que deseja? (int) "))
    print("Começando a adicionando carros...")

    time_to_check = 3
    while True:
        time_to_check += 1

        if time_to_check > 3:
            time_to_check = 0
            sleep(1)
            count_car = await get_count_car()
            print("count_car:", count_car)
            if count_car >= N:
                print("Chegou no numero de entidades")
                break

        print(f"Rodando ...")
        async with asyncer.create_task_group() as task_group:
            for _ in range(50):
                task_group.soonify(add_car)()


if __name__ == '__main__':
    asyncer.runnify(main)()
