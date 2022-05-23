FROM continuumio/miniconda3:latest

COPY ./requirements.txt ./requirements.txt

RUN set -x \
    && apt-get update \
    && apt-get upgrade --no-install-recommends --no-install-suggests -y \
    && apt-get install --no-install-recommends --no-install-suggests -y \
    supervisor gettext-base nginx apache2-utils curl

RUN pip install mlflow boto3 wheel psycopg2-binary

RUN apt-get remove --purge --auto-remove -y ca-certificates && rm -rf /var/lib/apt/lists/*


# WWW (nginx)
RUN addgroup -gid 1000 www \
    && adduser -uid 1000 -H -D -s /bin/sh -G www www


COPY nginx.conf.template /app/nginx.conf.template

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./entry-point.sh /app/entry-point.sh

COPY ./webserver.sh /app/webserver.sh
COPY ./mlflow.sh /app/mlflow.sh

EXPOSE 6000
EXPOSE 5000

CMD ["/bin/bash", "/app/entry-point.sh"]