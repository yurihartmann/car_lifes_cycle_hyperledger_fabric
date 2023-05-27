import uuid

from src.base_talker import BaseTalker

talker = BaseTalker(base_url="https://3000-yurihartman-carlifescyc-hhysjlod5kd.ws-us98.gitpod.io")


async def add_car() -> float:
    try:
        response = await talker.request(
            method="PUT",
            url="/submit/car-channel/car/AddCar",
            json=[f"{str(uuid.uuid4())}", "model 1", "2020", "blue"],
            headers={
                'X-API-Key': 'montadoraC'
            }
        )
        return response.elapsed.seconds + (response.elapsed.microseconds / 1000000)
    except Exception:
        print("Error")
        return -1


async def get_count_car() -> int:
    try:
        response = await talker.request(
            method="PUT",
            url="/submit/car-channel/car/Count",
            json=[""],
            headers={
                'X-API-Key': 'montadoraC'
            }
        )
        return response.json()["count"]
    except Exception:
        print("Error")
        return -1