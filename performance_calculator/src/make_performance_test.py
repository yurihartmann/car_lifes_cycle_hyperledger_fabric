import json

import asyncer as asyncer

from car_talker import add_car

FILE_NAME = input("Nome do arquivo para salvar os resultados?")
REQUEST_PER_SECOND = [1, 30]
FUNCTIONS = {
    "add_car": add_car
}

result = {
    func_name: {
            request_per_second: []
            for request_per_second in REQUEST_PER_SECOND
        }
    for func_name in FUNCTIONS.keys()
}


def save_result():
    with open(f'{FILE_NAME}.json', 'w', encoding='utf-8') as fp:
        json.dump(result, fp, indent=4, ensure_ascii=False)


async def make_performance_test(
        request_per_second: int,
        func,
        func_name
):
    data = []
    async with asyncer.create_task_group() as task_group:
        for _ in range(request_per_second):
            time = task_group.soonify(func)()
            data.append(time)

    for i in data:
        result[func_name][request_per_second].append(i.value)


async def main():
    for func_name, func in FUNCTIONS.items():
        for request_per_second in REQUEST_PER_SECOND:
            await make_performance_test(
                request_per_second=request_per_second,
                func=add_car,
                func_name=func_name
            )
            save_result()

if __name__ == '__main__':
    asyncer.runnify(main)()
