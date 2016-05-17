#
FROM python:2.7-alpine
MAINTAINER https://github.com/muccg

ARG DEVPI_VERSION
ARG PIP_INDEX_URL=https://pypi.python.org/simple/
ARG PIP_TRUSTED_HOST=127.0.0.1

ENV DEVPI_VERSION $DEVPI_VERSION
ENV VIRTUAL_ENV /env

# devpi user
RUN addgroup -S -g 1000 devpi \
    && adduser -D -S -u 1000 -h /data -s /sbin/nologin -G devpi devpi

# entrypoint is written in bash
RUN apk add --no-cache bash
 
# create a virtual env in $VIRTUAL_ENV, ensure it respects pip version
RUN pip install $PIP_OPTS virtualenv \
    && virtualenv $VIRTUAL_ENV \
    && $VIRTUAL_ENV/bin/pip install --upgrade --no-cache-dir pip==$PYTHON_PIP_VERSION
ENV PATH $VIRTUAL_ENV/bin:$PATH

RUN NO_PROXY=$PIP_TRUSTED_HOST pip --trusted-host $PIP_TRUSTED_HOST install -i $PIP_INDEX_URL --upgrade \
    "devpi-client==2.6.3" \
    "devpi-server==$DEVPI_VERSION"

EXPOSE 3141
VOLUME /data

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

USER devpi
ENV HOME /data
WORKDIR /data

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["devpi"]
