# GET LATEST VERSION FROM: https://github.com/Michaelpalacce/docker-vaultwarden-backup
VERSION=$(curl -s -XGET https://api.github.com/repos/Michaelpalacce/docker-vaultwarden-backup/tags | grep name -m 1 | awk '{print $2}' | cut -d'"' -f2)

docker buildx build --platform linux/amd64,linux/arm64 \
-t stefangenov/vaultwarden-backup:latest \
-t stefangenov/vaultwarden-backup:"${VERSION}" \
-f Dockerfile \
--build-arg TAG_VERSION="${VERSION}" \
--cpu-quota="600000" \
--memory=16g \
--push .
