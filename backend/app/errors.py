from fastapi import status
from fastapi.encoders import jsonable_encoder
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse

from app.main import app as main_app


@main_app.exception_handler(RequestValidationError)
async def http_exception_handler(request, exception: RequestValidationError):
    error_response = JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content=jsonable_encoder(
            {
                "detail": [
                    {"msg": error["msg"], "loc": error.get("loc")} for error in exception.errors()
                ]
            }
        ),
    )
    return error_response
