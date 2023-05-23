import logging
from http import HTTPStatus
from typing import Any

from httpx import AsyncClient, TimeoutException, Response
from httpx._types import (
    HeaderTypes, QueryParamTypes, RequestFiles, CookieTypes
)


class BaseTalker:

    @classmethod
    async def request(
            cls,
            method: str,
            url: str,
            json: Any = None,
            headers: HeaderTypes = None,
            params: QueryParamTypes = None,
            files: RequestFiles = None,
            cookies: CookieTypes = None
    ) -> Response:
        logging.debug(f"Request< method={method} url={url}")

        try:
            client = AsyncClient()
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

            try:
                logging.debug(
                    f"Response [{response.status_code}] - "
                    "Content: {response.content}")
            except Exception:
                pass

            if response.status_code == HTTPStatus.OK:
                return response

            raise Exception()

        except (TimeoutException):
            raise Exception()

        finally:
            await client.aclose()
