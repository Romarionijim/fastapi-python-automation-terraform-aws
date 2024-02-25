from faker import Faker


class FakeDataGenerator:
    fake = Faker()

    @classmethod
    def get_random_first_name(cls):
        first_name = cls.fake.first_name()
        return first_name

    @classmethod
    def get_random_last_name(cls):
        last_name = cls.fake.last_name()
        return last_name

    @classmethod
    def get_random_number(cls):
        random_int = cls.fake.random_int(min=18, max=50)
        return random_int
