# Task 2: Translating MIPS Assembly into Machine Code

Translate the MIPS assembly code below into machine code, using the MIPS datasheet for the opcode, register and function fields.

## Assembly code

```asm
        move $s0, $zero
Loop:   slti $t0, $s1, 0
        bne  $t0, $zero, exit
        sll  $t1, $s1, 2
        add  $t2, $s2, $t1
        lw   $t3, 0($t2)
        lw   $t4, 4($t2)
        slt  $t0, $t4, $t3
        beq  $t0, $zero, exit
        move $a0, $s2
        move $a1, $s1
        jal  Function
        addi $s1, $s1, -1
        j    Loop
exit:   addi $s0, $s0, 1
```

## Assumptions

- The text segment starts at `0x00400000` (the MARS default), and each instruction is 4 bytes.
- `Function` is not defined in the snippet, so it is assumed to sit right after the last instruction, at `0x0040003C`.
- `move $rd, $rs` is a pseudo-instruction, translated as `add $rd, $zero, $rs`. (MARS itself assembles it as `addu`, whose funct is `100001` instead of `100000`.)

Register numbers used: `$zero`=0, `$a0`=4, `$a1`=5, `$t0`=8, `$t1`=9, `$t2`=10, `$t3`=11, `$t4`=12, `$s0`=16, `$s1`=17, `$s2`=18.

## Addresses

| # | Address | Instruction |
|---|---|---|
| 0 | 0x00400000 | `move $s0, $zero` |
| 1 | 0x00400004 | `Loop: slti $t0, $s1, 0` |
| 2 | 0x00400008 | `bne $t0, $zero, exit` |
| 3 | 0x0040000C | `sll $t1, $s1, 2` |
| 4 | 0x00400010 | `add $t2, $s2, $t1` |
| 5 | 0x00400014 | `lw $t3, 0($t2)` |
| 6 | 0x00400018 | `lw $t4, 4($t2)` |
| 7 | 0x0040001C | `slt $t0, $t4, $t3` |
| 8 | 0x00400020 | `beq $t0, $zero, exit` |
| 9 | 0x00400024 | `move $a0, $s2` |
| 10 | 0x00400028 | `move $a1, $s1` |
| 11 | 0x0040002C | `jal Function` |
| 12 | 0x00400030 | `addi $s1, $s1, -1` |
| 13 | 0x00400034 | `j Loop` |
| 14 | 0x00400038 | `exit: addi $s0, $s0, 1` |

## R-type instructions

Format: `opcode (6) | rs (5) | rt (5) | rd (5) | shamt (5) | funct (6)`

| # | Instruction | opcode | rs | rt | rd | shamt | funct | Hex |
|---|---|---|---|---|---|---|---|---|
| 0 | `move $s0, $zero` | 000000 | 00000 | 00000 | 10000 | 00000 | 100000 | 0x00008020 |
| 3 | `sll $t1, $s1, 2` | 000000 | 00000 | 10001 | 01001 | 00010 | 000000 | 0x00114880 |
| 4 | `add $t2, $s2, $t1` | 000000 | 10010 | 01001 | 01010 | 00000 | 100000 | 0x02495020 |
| 7 | `slt $t0, $t4, $t3` | 000000 | 01100 | 01011 | 01000 | 00000 | 101010 | 0x018B402A |
| 9 | `move $a0, $s2` | 000000 | 00000 | 10010 | 00100 | 00000 | 100000 | 0x00122020 |
| 10 | `move $a1, $s1` | 000000 | 00000 | 10001 | 00101 | 00000 | 100000 | 0x00112820 |

## I-type instructions

Format: `opcode (6) | rs (5) | rt (5) | immediate (16)`

Branch offset = (label address - (PC + 4)) / 4, counted in instructions.

| # | Instruction | opcode | rs | rt | immediate | Hex |
|---|---|---|---|---|---|---|
| 1 | `slti $t0, $s1, 0` | 001010 | 10001 | 01000 | 0000000000000000 | 0x2A280000 |
| 2 | `bne $t0, $zero, exit` | 000101 | 01000 | 00000 | 0000000000001011 | 0x1500000B |
| 5 | `lw $t3, 0($t2)` | 100011 | 01010 | 01011 | 0000000000000000 | 0x8D4B0000 |
| 6 | `lw $t4, 4($t2)` | 100011 | 01010 | 01100 | 0000000000000100 | 0x8D4C0004 |
| 8 | `beq $t0, $zero, exit` | 000100 | 01000 | 00000 | 0000000000000101 | 0x11000005 |
| 12 | `addi $s1, $s1, -1` | 001000 | 10001 | 10001 | 1111111111111111 | 0x2231FFFF |
| 14 | `addi $s0, $s0, 1` | 001000 | 10000 | 10000 | 0000000000000001 | 0x22100001 |

Branch offsets:
- `bne` (#2): PC + 4 = 0x0040000C, `exit` = 0x00400038, so (0x38 - 0x0C) / 4 = 11
- `beq` (#8): PC + 4 = 0x00400024, `exit` = 0x00400038, so (0x38 - 0x24) / 4 = 5

## J-type instructions

Format: `opcode (6) | address (26)`

The address field is the target address divided by 4.

| # | Instruction | opcode | address (26 bits) | Hex |
|---|---|---|---|---|
| 11 | `jal Function` | 000011 | 00000100000000000000001111 | 0x0C10000F |
| 13 | `j Loop` | 000010 | 00000100000000000000000001 | 0x08100001 |

- `Function` = 0x0040003C, and 0x0040003C / 4 = 0x10000F
- `Loop` = 0x00400004, and 0x00400004 / 4 = 0x100001
