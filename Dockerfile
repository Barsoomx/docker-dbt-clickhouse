ARG PYTHON_IMAGE=python:3.10-slim

FROM $PYTHON_IMAGE

ARG BUILD_DEPS="\
  gcc \
  software-properties-common \
  make \
  build-essential \
  libpq-dev \
  gcc \
  g++ \
  libsasl2-dev \
  unixodbc-dev \
"

ARG RUNTIME_DEPS="\
  curl \
"

WORKDIR /usr/app/
ENV DBT_HOME=/usr/app \
    PYTHONIOENCODING=utf-8

ARG DBT_CH_VERSION='1.2.1'

RUN apt-get -qq update && \
    apt-get -qqy --no-install-recommends install $BUILD_DEPS $RUNTIME_DEPS &&  \
    pip --no-cache-dir install dbt-clickhouse==$DBT_CH_VERSION && \
    apt-get -y purge $BUILD_DEPS &&  \
    apt-get -y autoremove &&  \
    rm -rf /var/lib/apt/lists/* &&  \
    rm -rf /var/cache/apt

LABEL maintainer="Filipp Balakin <filipp@balakin.ru>"
ENTRYPOINT [ "/bin/bash" ]
