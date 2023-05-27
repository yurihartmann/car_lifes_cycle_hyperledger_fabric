from http import HTTPStatus
from typing import Any

from httpx import AsyncClient, TimeoutException, Response
from httpx._types import (
    HeaderTypes, QueryParamTypes, RequestFiles, CookieTypes
)


class BaseTalker:

    def __init__(self, base_url: str):
        self.base_url = base_url

    async def request(
            self,
            method: str,
            url: str,
            json: Any = None,
            headers: HeaderTypes = None,
            params: QueryParamTypes = None,
            files: RequestFiles = None,
            cookies: CookieTypes = None
    ) -> Response:
        # print(f"Request< method={method} url={url}")

        client = None

        try:
            client = AsyncClient(base_url=self.base_url)
            response = await client.request(
                method=method,
                url=url,
                params=params,
                timeout=30,
                headers=headers,
                json=json,
                files=files,
                cookies=cookies
            )

            # try:
            #     print(
            #         f"Response [{response.status_code}] - "
            #         "Content: {response.content}")
            # except Exception:
            #     pass

            if response.status_code == HTTPStatus.OK:
                return response

            raise Exception()

        except (TimeoutException):
            raise Exception()

        finally:
            await client.aclose()
