import logging
import runpy
from typing import TYPE_CHECKING

from calculator import cli


if TYPE_CHECKING:
    import pytest


EXPECTED_MESSAGES = ['Hello from python-template!', 'Result: 3']


def test_main_logs_exact_messages(caplog: pytest.LogCaptureFixture) -> None:
    with caplog.at_level(logging.INFO):
        cli.main()
    assert [record.getMessage() for record in caplog.records] == EXPECTED_MESSAGES


def test_main_configures_info_logging(monkeypatch: pytest.MonkeyPatch) -> None:
    calls: list[dict[str, object]] = []
    monkeypatch.setattr(cli, 'basicConfig', lambda **kwargs: calls.append(kwargs))
    cli.main()
    assert calls == [{'level': 'INFO'}]


def test_module_entry_point(caplog: pytest.LogCaptureFixture) -> None:
    with caplog.at_level(logging.INFO):
        runpy.run_module('calculator', run_name='__main__')
    assert [record.getMessage() for record in caplog.records] == EXPECTED_MESSAGES
