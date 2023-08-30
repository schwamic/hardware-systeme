# Setup

Virtualbox inkl. Extensions installieren und VM downloaden und entpacken.

## VM Setup

- [x11 + wsl2](https://www.guide2wsl.com/x11/)
- [x11 forwarding on wsl2](https://stackoverflow.com/questions/61110603/how-to-set-up-working-x11-forwarding-on-wsl2)

## Docker

1. [ti-wiki](https://ti-wiki.informatik.hs-augsburg.de/doku.php?id=ees-labor_eesvm#docker). In this project I used option 1b; helper script to load the image: `bin/load-docker-image.sh`.
2. Expand image with Dockerfile: `docker image build -t hardsys1b`
3. `docker image ls -a` should display `hardsys1b` and `hsa-ees/lab`
4. Install docker-compose

## Set Permissions

If it is not possible to create files or folder run the following:

1. Set user `root:root` in `docker-compose.yml`
2. Run `docker-compose run -rm lab`
3. Run `chown labuser <your folder>`
4. Exit
5. Undo changes in `docker-compose.yml`

To avoid permission errors, do not create files or folder as host in the workspace folder.
- VS Code Editor installieren + Plugins
- Git Conifg
- SSH-Key
