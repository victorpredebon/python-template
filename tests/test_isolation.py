import socket

import pytest
from pytest_socket import SocketBlockedError


def test_network_is_blocked_in_tests() -> None:
    # Tests must not depend on the network: use fakes or recorded data instead.
    with (
        pytest.warns(UserWarning, match='socket'),
        pytest.raises(SocketBlockedError),
    ):
        socket.socket(socket.AF_INET, socket.SOCK_STREAM)
