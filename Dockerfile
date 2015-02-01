#
FROM muccg/python-base:debian8-2.7
MAINTAINER ccg <ccgdevops@googlegroups.com>

RUN pip install \
  "devpi-client>=2.0.4,<2.1" \
  "devpi-server>=2.1.3,<2.2" \
  "requests>=2.5.0,<2.6"

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
