from fastapi import FastAPI, Path, HTTPException, status
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from typing import List


class Person(BaseModel):
    first_name: str
    last_name: str
    age: int
    favorite_sport: str


app = FastAPI()

persons = {
    1: {"first_name": "John", "last_name": "Doe", "age": 30, "favorite_sport": "Basketball"},
    2: {"first_name": "Sara", "last_name": "Wills", "age": 28, "favorite_sport": "Climbing"},
    3: {"first_name": "Mike", "last_name": "Brown", "age": 32, "favorite_sport": "Swimming"},
    4: {"first_name": "Dana", "last_name": "Doe", "age": 40, "favorite_sport": "Football"},
    5: {"first_name": "James", "last_name": "Jones", "age": 37, "favorite_sport": "Football"},
    6: {"first_name": "Jones", "last_name": "Silk", "age": 25, "favorite_sport": "Football"},
    7: {"first_name": "Jane", "last_name": "Doe", "age": 40, "favorite_sport": "Football"},
}


@app.get("/")
async def root():
    return {"message": "welcome to root route"}


@app.get("/person", response_model=List[Person])
async def get_all_persons():
    return JSONResponse(content=persons, status_code=status.HTTP_200_OK)


@app.get("/person/{person_id}")
async def get_person(person_id: int):
    if person_id not in persons:
        raise HTTPException(status_code=404, detail="Person not found")
    return JSONResponse(content=persons[person_id], status_code=status.HTTP_200_OK)


@app.post("/person")
async def create_person(new_person: Person):
    max_id = max(persons.keys())
    new_id = max_id + 1
    persons[new_id] = new_person.dict()
    if new_id in persons:
        return JSONResponse(content={"message": "Person created successfully", "person_id": new_id},
                            status_code=status.HTTP_201_CREATED)
    else:
        raise HTTPException(status_code=404, detail="Person was not added to persons")


@app.put("/person/{person_id}")
async def modify_person(person_id: int, updated_person: Person):
    if person_id not in persons:
        raise HTTPException(status_code=404, detail="person does not exist")
    persons[person_id] = updated_person.dict()
    return JSONResponse(content={"message": "person was updated successfully", "person": updated_person},
                        status_code=status.HTTP_200_OK)


@app.patch("/person/{person_id}")
async def partially_modify_person(person_id: int, updated_record: Person):
    if person_id not in persons:
        raise HTTPException(status_code=404, detail="Person not found")
    existing_person = persons[person_id]
    for field, value in updated_record.dict().items():
        if value is not None:
            existing_person[field] = value
    return JSONResponse(content={"message": "person partially updated"}, status_code=status.HTTP_200_OK)


@app.delete("/person/{person_id}")
async def delete_person(person_id: int):
    if person_id not in persons:
        raise HTTPException(status_code=404, detail="person does not exist")
    del persons[person_id]
    return JSONResponse(content={"message": "person was deleted successfully"}, status_code=status.HTTP_204_NO_CONTENT)
