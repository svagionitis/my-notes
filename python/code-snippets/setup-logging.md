# Setup a logger in python

More info can be found here, https://docs.python.org/3/howto/logging.html

```
import logging

LOGGER = logging.getLogger(__name__)

def setupLogging(level):
    """
    Setup the logging levels for LOGGER

    level: Logging level to set
    """

    fmt = "%(asctime)s %(levelname)s: %(message)s [%(name)s:%(funcName)s:%(lineno)d] "
    logging.basicConfig(level=logging.getLevelName(str(level).upper()), format=fmt)
    LOGGER.info("Log level set to %s", level)


def main():
    """
    Main function
    """

    setupLogging("debug")


if __name__ == "__main__":
    main()
```
