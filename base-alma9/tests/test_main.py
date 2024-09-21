import pytest


def test_host_system(host):
    assert host.system_info.type == "linux"
    assert host.system_info.distribution == "almalinux"
    assert host.system_info.release == "9.4"


@pytest.mark.parametrize("tool",  [
    "dnf",
])
def test_command_is_availablie(host, tool):
    assert host.exists(tool)
