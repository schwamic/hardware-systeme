# Development

## Environment

1. EESlab VM (`gcc` bereits installiert)
2. Java Development Kit installieren
    - `sudo apt install default-jdk`
    -> Mit dem JDK ist dann möglich [Core JDK Tools](https://dev.java/learn/the-core-jdk-tools/) wie `javac` (=Compiler) und `javap` (=Disassembler) zu nutzen
3. Go installieren: [Tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-go-on-ubuntu-20-04)
4. VS Code + Extensions (optional)

## Bytecode

- `javac Blinky.java` erstellt Bytecode `Blinky.class` (hexadecimal)
- `javap -c Blinky` zeigt disassemblierten Bytecode an
- [Blinky Output](./blinky.md)

## Code ausführen

- Ausführen via `go run *.go` im Ordner `src`
- Kompilieren via `go build` im Ordner `src`

## Errors

- Go not found -> `source ~/.profile` ausführen
