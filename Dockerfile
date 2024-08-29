FROM python:3.11.9-slim

ENV POETRY_PYPI_MIRROR_URL=https://mirrors.aliyun.com/pypi/simple/

WORKDIR /app

ENV PATH="${PATH}:/root/.local/bin"

RUN sed -i 's|deb.debian.org|mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list.d/debian.sources

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt install curl git -y \
    && apt-get autoremove \
    && apt-get clean \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && pip install --no-cache-dir --upgrade pip -i https://mirrors.aliyun.com/pypi/simple/ \
    && pip install poetry -i https://mirrors.aliyun.com/pypi/simple/
# && pdm config pypi.url https://mirrors.aliyun.com/pypi/simple/

ADD ./ /app/

RUN poetry source add --priority=primary mirrors https://mirrors.aliyun.com/pypi/simple/ \
    && poetry lock --no-update \
    && poetry install \
    && rm -rf /app/*


# RUN rm -rf /app/*

# RUN pdm config python.use_venv false \
#     && pdm install \
#     && pdm run python -m ensurepip \
#     && rm -rf /app/*
