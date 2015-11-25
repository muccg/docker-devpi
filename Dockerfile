#
FROM muccg/python-base:debian8-2.7
MAINTAINER https://github.com/muccg

ARG DEVPI_VERSION
ARG PIP_INDEX_URL=https://pypi.python.org/simple/
ARG PIP_TRUSTED_HOST=127.0.0.1

ENV DEVPI_VERSION $DEVPI_VERSION

RUN NO_PROXY=$PIP_TRUSTED_HOST pip --trusted-host $PIP_TRUSTED_HOST install -i $PIP_INDEX_URL --upgrade \
  "devpi-client>=2.3.0,<2.4" \
  "devpi-server==$DEVPI_VERSION"

EXPOSE 3141
VOLUME /data

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Drop privileges, set home for ccg-user
USER ccg-user
ENV HOME /data
WORKDIR /data

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["devpi"]
