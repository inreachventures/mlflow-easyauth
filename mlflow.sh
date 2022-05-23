#!/bin/bash -x

exec mlflow server --host=0.0.0.0 --port=5000 --backend-store-uri=$DATABASE_URL --default-artifact-root=$ARTIFACT_URL --serve-artifacts
