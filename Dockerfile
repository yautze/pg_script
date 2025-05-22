FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    postgresql-client && \
    curl -sSL https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


COPY restore_from_minio.sh /restore_from_minio.sh
RUN chmod +x /restore_from_minio.sh

ENTRYPOINT ["/bin/bash"]

