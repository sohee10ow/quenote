#!/bin/zsh

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: ./publish_ios_dev.sh [dev|prod]" >&2
  exit 1
fi

case "$1" in
  dev)
    flavor="development"
    ;;
  prod)
    flavor="production"
    ;;
  *)
    echo "usage: ./publish_ios_dev.sh [dev|prod]" >&2
    exit 1
    ;;
esac

echo "Start packaging... (${flavor})"

flutter build ipa \
  -t lib/main.dart \
  --flavor="${flavor}" \
  --dart-define="flavor=${flavor}" \
  --dart-define="host=" \
  --release \
  --export-method=ad-hoc
