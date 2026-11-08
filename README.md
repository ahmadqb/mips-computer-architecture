# MIPS Computer Architecture Assignment

A two-part assignment on MIPS assembly: translating a C program into assembly and running it in the MARS simulator, and translating MIPS instructions by hand into machine code.

> **Note:** This assignment was completed in **June 2024** as coursework for a computer architecture course. The code formatting and the Task 2 table were tidied up and corrected when this repository was created.

## Contents

```
.
├── README.md
├── task1/
│   ├── calculator.asm      # MIPS assembly version of the C program
    |__ calculator.c        # code in C Language
│   └── Results_of_TheRun        # MARS screenshot (program output)
└── task2/
    └── machine_code.md            # Assembly-to-machine-code translation tables
```

## Task 1: C program to MIPS assembly

The C program is a small calculator. It reads two integers, `X` and `Y`, then repeatedly asks for an operation:

| Input | Action |
|---|---|
| `%` | Prints `X mod Y` (calls a modulus function) |
| `^` | Prints `X` to the power `Y` (calls a power function) |
| `q` | Exits the program |
| anything else | Asks for the operation again |

The assembly version keeps the structure of the C program: global variables live in `.data`, the `switch` is a chain of `beq` instructions, and `modulus` and `power` are separate functions called with `jal`. Arguments are passed in `$a0` and `$a1`, and the result is returned in `$v0`.

### How to run

1. Open [MARS](http://courses.missouristate.edu/kenvollmar/mars/).
2. Open `task1/calculator.asm`.
3. Assemble (F3), then run (F5).
4. Enter two numbers, then an operation: `%`, `^` or `q`.

### Differences from the C program

- The prompts are worded slightly differently. The operation prompt lists the valid choices.
- The C `default` case calls `system("cls")`. The assembly version just asks for the operation again.
- If `Y` is 0 for the modulus, the program prints the error message and asks for a new `Y`.
- A negative exponent returns 0, which matches C's integer truncation of `pow` for the usual cases. It also avoids an endless loop in the power function.
- Numbers are printed as signed integers, while the C program uses `%u`.
- The power function multiplies in a loop instead of calling `pow` from the math library.

## Task 2: MIPS assembly to machine code

A 15-instruction loop is translated by hand into machine code using the MIPS datasheet. The result is in [`task2/machine_code.md`](task2/machine_code.md), with:

- the address of each instruction,
- R-type, I-type and J-type tables with every field shown in binary, plus the hex encoding,
- the working for the branch offsets and jump targets.

Assumptions: the text segment starts at `0x00400000` (the MARS default), and `Function` is placed right after the last instruction, at `0x0040003C`.

## What this covers

- MIPS instruction formats (R, I and J) and how the fields are encoded
- Branch offsets (PC-relative) and jump targets (pseudo-direct)
- Memory access with `lw` and `sw`, and byte access with `lb` and `sb`
- Function calls with `jal` and `jr $ra`
- System calls in MARS for input and output
- Mapping C constructs (`while`, `switch`, functions, globals) to assembly
