FROM python:3.11.9-slim

WORKDIR /app

ENV PATH="${PATH}:/root/.local/bin"

ENV TZ=Asia/Shanghai

RUN sed -i 's|deb.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list.d/debian.sources

RUN pip config set global.index-url 'https://mirrors.aliyun.com/pypi/simple/' \
    && pip config set global.timeout '120' \
    && pip config set global.trusted-host 'mirrors.aliyun.com'

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt install curl git -y \
    && apt-get autoremove \
    && apt-get clean \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && pip install --no-cache-dir --upgrade pip \
    && pip install poetry
# && pdm config pypi.url https://mirrors.aliyun.com/pypi/simple/

ADD ./ /app/

RUN poetry install \
    && rm -rf /app/{*,.*}


