#!/bin/bash
set -e

exec /usr/bin/mongod &
exec helm init --client-only
exec /usr/local/bin/jenkins-slave "$@"