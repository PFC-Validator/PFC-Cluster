#!/usr/bin/env bash
export DOCKER_BUILDKIT=1
docker build  -t sshd_ubu .

echo docker kill test
echo docker rm test
echo docker run -d --name test sshd_ubu
echo docker inspect --format=\'{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}\' test
exit 

docker exec -it test bash