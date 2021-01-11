# Setup a configuration file using configargparse

More info can be found here, https://pypi.org/project/ConfigArgParse/

```
import sys
import os
import logging
import configargparse

def parseArgs(script_args, config_file="my_config.conf"):
    """
    Parse the configuration arguments

    If no input arguments is given, it will read them from the configuration file my_config.conf

    script_args: Input arguments
    config_file: The configuration file. Default value my_config.conf
    """

    def _get_log_level_names():
        return [
            logging.getLevelName(v).lower()
            for v in sorted(
                getattr(logging, "_levelToName", None) or logging._levelNames
            )
            if getattr(v, "real", 0)
        ]

    LOG_LEVEL_NAMES = _get_log_level_names()
    cwd = os.path.dirname(os.path.realpath(__file__))

    default_config_files = [os.path.join(cdir, config_file) for cdir in (cwd, ".")]

    conf = configargparse.ArgParser(default_config_files=default_config_files)
    conf.add(
        "-c",
        "--my-config",
        required=False,
        is_config_file=True,
        help="config file path",
    )
    conf.add(
        "-l",
        "--log-level",
        required=True,
        env_var="LOG_LEVEL",
        choices=LOG_LEVEL_NAMES,
        help="Set the logging level",
    )
    conf.add(
        "--proxy-ws-server-host",
        env_var="PROXY_WS_SERVER_HOST",
        required=True,
        type=str,
        help="The proxy websocket server host",
    )
    conf.add(
        "--proxy-ws-server-port",
        env_var="PROXY_WS_SERVER_PORT",
        required=True,
        type=int,
        help="The proxy websocket server port",
    )
    conf.add(
        "--remote-ws-server-host",
        env_var="REMOTE_WS_SERVER_HOST",
        required=True,
        type=str,
        help="The remote websocket server host",
    )
    conf.add(
        "--remote-ws-server-port",
        env_var="REMOTE_WS_SERVER_PORT",
        required=True,
        type=int,
        help="The remote websocket server port",
    )

    return conf.parse_args(script_args)

def main():
    """
    Main function
    """

    config = parseArgs(sys.argv[1:])
    LOGGER.debug(config)

    REMOTE_WS_SERVER_URI = "ws://%s:%s" % (
        config.remote_ws_server_host,
        config.remote_ws_server_port,
    )

    proxy_ws_server = websockets.serve(
        handler, config.proxy_ws_server_host, config.proxy_ws_server_port
    )

if __name__ == "__main__":
    main()

```

The `my_config.conf` will look like the following

```
log-level = debug
proxy-ws-server-host = localhost
proxy-ws-server-port = 9999
remote-ws-server-host = localhost
remote-ws-server-port = 9991
```
