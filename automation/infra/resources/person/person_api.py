from automation.infra.requests.api_requests import ApiRequests
from automation.infra.enums.urls_and_endpoints.url_endpoints import Urls, EndPoints
from typing import TypeVar, Dict, Union
import random
import json
from automation.infra.utils.faker.faker import FakeDataGenerator
from app.person import *

T = TypeVar("T")


class PersonAPI(ApiRequests):
    LOCAL_HOST = Urls.LOCAL_HOST.value
    PERSON_ENDPOINT = EndPoints.PERSON.value

    def get_all_persons_dict_length(self):
        response = self.get(f'{self.LOCAL_HOST}{self.PERSON_ENDPOINT}')
        response_object = response.json()
        return len(response_object)

    def get_person(self, person_id):
        response = self.get(f'{self.LOCAL_HOST}{self.PERSON_ENDPOINT}/{person_id}')
        person_dict = response.json()
        return response, person_dict

    def create_new_person(self):
        sport_choice = self.__get_sport_choice()
        person_dict = {
            "first_name": FakeDataGenerator.get_random_first_name(),
            "last_name": FakeDataGenerator.get_random_last_name(),
            "age": FakeDataGenerator.get_random_number(),
            "favorite_sport": sport_choice
        }
        json_data = json.dumps(person_dict)
        response = self.post(f'{self.LOCAL_HOST}{self.PERSON_ENDPOINT}', data=json_data)
        return response

    def __get_sport_choice(self):
        sport_list = ["Basketball", "Football", "Swimming", "Boxing", "HandBall", "Hockey", "Running",
                      "Baseball", "Olympic athletic sports", "Golf", "Martial Arts", "Wrestling", "Tennis"]
        sport_choice = random.choice(sport_list)
        return sport_choice

    def modify_person(self, person_id: int, modified_data_dict: Union[Dict[str, T], str]):
        response = self.put(f'{self.LOCAL_HOST}{self.PERSON_ENDPOINT}/{person_id}', data=modified_data_dict)
        return response

    def delete_person(self, person_id: int):
        response = self.delete(f'{self.LOCAL_HOST}{self.PERSON_ENDPOINT}/{person_id}')
        return response

    def get_person_keys(self):
        keys_list = []
        response = self.get(f'{self.LOCAL_HOST}{self.PERSON_ENDPOINT}')
        response_data = response.json()
        for key in response_data:
            keys_list.append(key)
        return keys_list
