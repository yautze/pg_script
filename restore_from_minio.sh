#!/bin/bash
set -e

# $1 = MinIO path, $2 = PostgreSQL host
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <minio_path> <postgres_host>"
  echo "Example: $0 backup-bucket/2024-05-22/full.sql pgpool"
  exit 1
fi

MINIO_PATH="$1"
POSTGRES_HOST="$2"
SQL_FILE="/tmp/restore.sql"

# minio
: "${MINIO_ALIAS:=minio}"
: "${MINIO_BUCKET:=${MINIO_PATH%%/*}}"
: "${MINIO_FILE_PATH:=${MINIO_PATH#*/}}"
: "${MINIO_ENDPOINT:?Need to set MINIO_ENDPOINT}"
: "${MINIO_ACCESS_KEY:?Need to set MINIO_ACCESS_KEY}"
: "${MINIO_SECRET_KEY:?Need to set MINIO_SECRET_KEY}"

# pstgres
: "${POSTGRES_PORT:=5432}"
: "${POSTGRES_DB:?Need to set POSTGRES_DB}"
: "${POSTGRES_USER:?Need to set POSTGRES_USER}"
: "${POSTGRES_PASSWORD:?Need to set POSTGRES_PASSWORD}"

mc alias set "$MINIO_ALIAS" "$MINIO_ENDPOINT" "$MINIO_ACCESS_KEY" "$MINIO_SECRET_KEY"

echo "Downloading s3://$MINIO_PATH to $SQL_FILE"
mc cp "$MINIO_ALIAS/$MINIO_BUCKET/$MINIO_FILE_PATH" "$SQL_FILE"

echo "Restoring to PostgreSQL: $POSTGRES_DB@$POSTGRES_HOST:$POSTGRES_PORT"
PGPASSWORD="$POSTGRES_PASSWORD" psql \
  -h "$POSTGRES_HOST" \
  -p "$POSTGRES_PORT" \
  -U "$POSTGRES_USER" \
  -d "$POSTGRES_DB" \
  -f "$SQL_FILE"

echo "Restore completed."
