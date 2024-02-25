import pytest
from automation.infra.resources.person.person_resource import PersonAPI
from automation.tests.test_data import *
from automation.infra.enums.status_codes.status_code import *
import logging
import json


@pytest.fixture(scope='function')
def create_person_class_instance():
    person = PersonAPI()
    yield person
    logging.info('created person object')


def test_get_all_persons(create_person_class_instance):
    person = create_person_class_instance
    persons_length = person.get_all_persons_dict_length()
    assert persons_length == 7


def test_get_single_person(create_person_class_instance):
    person = create_person_class_instance
    person_response, person_1 = person.get_person(PERSON_1_ID)
    person_name = person_1['first_name']
    person_favorite_sport = person_1['favorite_sport']
    assert person_response.status_code == get_status_code_value(StatusCode.HTTP_OK)
    assert person_name == PERSON_1_NAME
    assert person_favorite_sport == PERSON_1_FAVORITE_SPORT


def test_create_new_person(create_person_class_instance):
    person = create_person_class_instance
    response = person.create_new_person()
    assert response.status_code == get_status_code_value(StatusCode.HTTP_CREATED)


# def test_modify_existing_person(create_person_class_instance):
#     person = create_person_class_instance
#     person_data = {
#         "first_name": PERSON_2_NAME,
#         "last_name": "Adams",
#         "age": 29,
#         "favorite_sport": "Climbing and Hiking"
#     }
#     person_json_data = json.dumps(person_data)
#     response = person.modify_person(PERSON_2_ID, person_json_data)
#     assert response.status_code == get_status_code_value(StatusCode.HTTP_OK)
#     updated_person = person.get_person(PERSON_2_ID)
#     assert updated_person == person_data


def test_delete_person(create_person_class_instance):
    person = create_person_class_instance
    data_length = person.get_all_persons_dict_length()
    assert data_length == 8
    response = person.delete_person(8)
    assert response.status_code == get_status_code_value(StatusCode.HTTP_NO_CONTENT)
    person_dict_keys = person.get_person_keys()
    assert 8 not in person_dict_keys
