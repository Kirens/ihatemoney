FROM python:3.7-alpine AS base

ENV DEBUG="False" \
    SQLALCHEMY_DATABASE_URI="sqlite:////database/ihatemoney.db" \
    SQLALCHEMY_TRACK_MODIFICATIONS="False" \
    SECRET_KEY="tralala" \
    MAIL_DEFAULT_SENDER="('Budget manager', 'budget@notmyidea.org')" \
    MAIL_SERVER="localhost" \
    MAIL_PORT=25 \
    MAIL_USE_TLS=False \
    MAIL_USE_SSL=False \
    MAIL_USERNAME= \
    MAIL_PASSWORD= \
    ACTIVATE_DEMO_PROJECT="True" \
    ADMIN_PASSWORD="" \
    ALLOW_PUBLIC_PROJECT_CREATION="True" \
    ACTIVATE_ADMIN_DASHBOARD="False" \
    BABEL_DEFAULT_TIMEZONE="UTC" \
    GREENLET_TEST_CPP="no"

RUN apk update && apk add gcc libc-dev libffi-dev openssl-dev wget &&\
    mkdir /ihatemoney &&\
    mkdir -p /etc/ihatemoney &&\
    pip install --no-cache-dir gunicorn


COPY ./ihatemoney /ihatemoney/ihatemoney
COPY ./setup.cfg /ihatemoney/setup.cfg
COPY ./setup.py /ihatemoney/setup.py

RUN pip install --no-cache-dir -e /ihatemoney;

COPY ./conf/entrypoint.sh /entrypoint.sh

VOLUME /database
EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh"]

FROM base AS postgresql
RUN apk add postgresql-dev
RUN pip install --no-cache-dir psycopg2

FROM base AS mysql
# Not sure what aditional dependencies there are here
RUN pip install --no-cache-dir pymysql

FROM base AS default
