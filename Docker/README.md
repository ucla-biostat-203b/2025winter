# Instructions for building your own Docker image

Remember to change to your own DockerHub user name and repo name in the following instructions.

Add or remove Ubuntu packages in `ubuntu_pkgs.txt`.

Add or remove Python packages in `python_pkgs.txt`.

Add or remove R packages in `r_pkgs.txt`.

Add or remove Julia packages in `julia_pkgs.txt`.

## Build images for amd64 and arm64 platforms

Depending on your computer, eithre build image for `amd64`/`x86_64` architecture (e.g., Intel/AMD):
```bash
docker build -f Dockerfile.amd64 --platform linux/amd64 --provenance false --tag huazhou/ucla-biostat-203b-2025w-amd64 .
```
or build image for `arm64`/`aarch64` architecture (e.g., Apple M1/M2/M3):
```bash
docker build -f Dockerfile.arm64 --platform linux/arm64 --provenance false --tag huazhou/ucla-biostat-203b-2025w-arm64 .
```

Be patient. The initial build process may take a while (up to 1 hour on my laptop).

## Push images

Push images to Docker Hub (`amd64` architecture):
```bash
docker push huazhou/ucla-biostat-203b-2025w-amd64
```
or (`arm64` architecture):
```bash
docker push huazhou/ucla-biostat-203b-2025w-arm64
```

## Create multi-arch image (optional)

```bash
docker buildx imagetools create -t huazhou/ucla-biostat-203b-2025w:latest \
    huazhou/ucla-biostat-203b-2025w-amd64 \
    huazhou/ucla-biostat-203b-2025w-arm64
```

Push multi-arch image to Docker Hub:
```bash
docker push huazhou/ucla-biostat-203b-2025w
```

## Run image

Modify `docker-compose.yml` to choose the image and map `203-lecture`, `203-hw`, `212a-lecture`, `mimic`, `~/.ssh`, and `~/.gitconfig`  folders on local machine to container. Then
```bash
docker compose up
```
Then access the RStudio server at `localhost:8787` in your browser.

## References

<https://stackoverflow.com/questions/75521775/buildx-docker-image-claims-to-be-a-manifest-list>
