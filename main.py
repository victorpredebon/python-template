from logging import basicConfig, getLogger

from calculator import sum_numbers


logger = getLogger(__name__)


def main() -> None:
    basicConfig(level='INFO')
    logger.info('Hello from python-template!')
    logger.info('Result: %s', sum_numbers(1, 2))


if __name__ == '__main__':
    main()
