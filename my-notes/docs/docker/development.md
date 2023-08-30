# Local Development

Run `VcXsrv/xlaunch.exe` as administrator:

- Multiple Windows
- Start no client
- disable Native opengl
- enable Disable access control

## Start (HSA Remote)

1. Connect via OpenVPN
2. Login via RZ Account: `bin/connect-remote.sh`

## Start (Local)

1. Run `VcXsrv/xlaunch.exe` as administrator
2. Run `docker-compose run --rm lab`
3. Everything in folder `workspace` will be mounted inside the container

## Links

- [HSA Rechenzentrum VPN](https://www.hs-augsburg.de/Rechenzentrum/Datennetz-WLAN-VPN.html)

## Source

- `.vscode`: Editor settings
- `bin`: Docker scripts
- `docs`: Documentation
- `src`: VHDL files
- `workspace`: Mounted project for simulation and synthesis
- `docker-compose.yml`: Hardware-Systeme environment
- `Makefile`: Helper for simulation and synthesis
