import pytest


def test_host_system(host):
    assert host.system_info.type == "linux"
    assert host.system_info.distribution == "debian"
    assert host.system_info.release == "12"


@pytest.mark.parametrize("tool",  [
    "htop",
    "traceroute",
    "ping",
    "dig",
    "gpg",
    "vim",
    "ss",
    "tcpdump"
])
def test_command_is_availablie(host, tool):
    assert host.exists(tool)


def test_docker_is_running(service):
    assert service("docker").is_running


def test_containerd_is_running(service):
    assert service("containerd").is_running


def test_docker_is_enabled(service):
    assert service("docker").is_enabled


@pytest.fixture()
def service(host):
    def _func(service_name):
        return host.service(service_name)
    return _func
