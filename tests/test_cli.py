import logging
import runpy
from typing import TYPE_CHECKING

from calculator.cli import main


if TYPE_CHECKING:
    import pytest


def test_main_logs_result(caplog: pytest.LogCaptureFixture) -> None:
    with caplog.at_level(logging.INFO):
        main()
    assert 'Result: 3' in caplog.text


def test_module_entry_point(caplog: pytest.LogCaptureFixture) -> None:
    with caplog.at_level(logging.INFO):
        runpy.run_module('calculator', run_name='__main__')
    assert 'Result: 3' in caplog.text
