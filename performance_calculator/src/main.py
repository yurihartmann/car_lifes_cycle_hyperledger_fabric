import asyncio
import traceback
from base_talker import BaseTalker

talker = BaseTalker()


async def main():
    try:
        response = await talker.request("GET", "https://google.com")
        print(response.status_code)
    except Exception as exc:
        traceback.print_exc()


asyncio.run(main())
