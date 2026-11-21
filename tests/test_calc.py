from hypothesis import given, strategies as st

from calculator.calc import sum_numbers


def test_sum_numbers() -> None:
    assert sum_numbers(1, 2) == 3


@given(st.integers(), st.integers())
def test_sum_numbers_is_commutative(a: int, b: int) -> None:
    assert sum_numbers(a, b) == sum_numbers(b, a)


@given(st.integers())
def test_zero_is_identity(a: int) -> None:
    assert sum_numbers(a, 0) == a
