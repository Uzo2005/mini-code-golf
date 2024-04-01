### Mini Code Golf
A mini golf game with a source file of about 2.5kb. 
Presented for Vjeux [Algorithm arena](https://github.com/Algorithm-Arena/weekly-challenge-11-mini-code-golf) week11.

*The whole source file is in `main.nim`*

#### Building From Source
To build the game:

1. [Install](https://nim-lang.org/install.html) the Nim programming language
2. Clone this repo and cd into the folder
3. Run the following commands

```nim
nimble install
nim c -d:release main.nim #or nim r -d:release main.nim
./main
```

#### To Run The Game On Linux
Just clone this repo and run the `game` executable