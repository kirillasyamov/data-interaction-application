FROM postgres:15-alpine as preload

EXPOSE 5432

WORKDIR docker-entrypoint-initdb.d
ADD . .
RUN mv schema.sql 01.sql && mv data.sql 02.sql && mv data.sh 03.sh && mv config.sh 04.sh
WORKDIR ..

RUN sed -i 's/exec "$@"/echo "skipping..."/' /usr/local/bin/docker-entrypoint.sh

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV PGDATA=data

RUN /usr/local/bin/docker-entrypoint.sh postgres

FROM postgres:15-alpine

COPY --from=preload data $PGDATA
