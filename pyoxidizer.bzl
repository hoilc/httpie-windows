def make_dist():
    return default_python_distribution()

def make_exe(dist):
    python_config = PythonInterpreterConfig(
        run_module="httpie.__main__",
    )
    exe = dist.to_python_executable(
        name="http",
        config=python_config,
        extension_module_filter='all',
        include_sources=True,
        include_resources=False,
        include_test=False,
    )
    exe.add_in_memory_python_resources(dist.pip_install(["setuptools","certifi==2020.4.5","httpie==2.2.0"]))
    return exe

def make_embedded_resources(exe):
    return exe.to_embedded_resources()

def make_install(exe):
    files = FileManifest()
    files.add_python_resource(".", exe)
    return files

register_target("dist", make_dist)
register_target("exe", make_exe, depends=["dist"], default=True)
register_target("resources", make_embedded_resources, depends=["exe"], default_build_script=True)
register_target("install", make_install, depends=["exe"])
resolve_targets()

PYOXIDIZER_VERSION = "0.7.0"
PYOXIDIZER_COMMIT = "UNKNOWN"
