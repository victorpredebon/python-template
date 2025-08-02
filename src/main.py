from logging import basicConfig, getLogger

from calc import sum_numbers

logger = getLogger(__name__)
basicConfig(level='INFO')


def main() -> None:
    logger.info('Hello from uv-python-template!')
    logger.info(sum_numbers(1, 2))


if __name__ == '__main__':
    main()
