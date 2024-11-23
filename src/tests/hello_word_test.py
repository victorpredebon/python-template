from app.hello_word import get_hello_word


def test_hello_word(faker):
    name = faker.name()
    assert get_hello_word(name) == f'Hello World {name}'
