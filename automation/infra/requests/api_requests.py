import requests
from enum import Enum
from typing import Optional, TypeVar, Dict, Union

T = TypeVar("T")


class ApiMethodEnum(Enum):
    GET = 'GET'
    POST = 'POST'
    PUT = 'PUT'
    PATCH = 'PATCH'
    DELETE = 'DELETE'


class ApiRequests:
    def __init__(self):
        self.request = requests.session()

    def make_http_request(self, method: ApiMethodEnum, url: str, data: Optional[Union[Dict[str, T], str]] = None):
        headers = {"Content-Type": "application/json", "Accept": "application/json"}
        response = None
        match method:
            case ApiMethodEnum.GET:
                response = self.request.get(url, headers=headers, data=data)
            case ApiMethodEnum.PUT:
                response = self.request.put(url, headers=headers, data=data)
            case ApiMethodEnum.PATCH:
                response = self.request.patch(url, headers=headers, data=data)
            case ApiMethodEnum.POST:
                response = self.request.post(url, headers=headers, data=data)
            case ApiMethodEnum.DELETE:
                response = self.request.delete(url, headers=headers, data=data)
        return response

    def get(self, url, data: Optional[Union[Dict[str, T], str]] = None):
        return self.make_http_request(ApiMethodEnum.GET, url, data=data)

    def post(self, url, data: Optional[Union[Dict[str, T], str]] = None):
        return self.make_http_request(ApiMethodEnum.POST, url, data=data)

    def put(self, url, data: Optional[Union[Dict[str, T], str]] = None):
        return self.make_http_request(ApiMethodEnum.PUT, url, data=data)

    def patch(self, url, data: Optional[Union[Dict[str, T], str]] = None):
        return self.make_http_request(ApiMethodEnum.PATCH, url, data=data)

    def delete(self, url, data: Optional[Union[Dict[str, T], str]] = None):
        return self.make_http_request(ApiMethodEnum.DELETE, url, data=data)
