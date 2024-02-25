from enum import Enum


class StatusCode(Enum):
    HTTP_OK = 200
    HTTP_CREATED = 201
    HTTP_NO_CONTENT = 204
    HTTP_NOT_FOUND = 404
    HTTP_INTERNAL_SERVER_ERROR = 500


def get_status_code_value(status_code: StatusCode):
    return status_code.value
