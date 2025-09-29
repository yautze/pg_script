FROM bitnami/postgresql-repmgr:16.5.0-debian-12-r0

USER root

RUN apt-get update && \
    apt-get install -y curl gnupg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "deb http://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    curl -s https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update

RUN apt-get install -y postgresql-16-repack && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -O https://dl.min.io/client/mc/release/linux-amd64/mc && \
    chmod +x mc && mv mc /usr/local/bin/mc

ENTRYPOINT ["/bin/bash"]
