=====================================================================
Task 2: Translating MIPS Assembly Instructions into Machine Code
=====================================================================

Description:
Translate the assembly code (MIPS instructions) below into the
equivalent machine code, using the MIPS datasheet for the opcode,
register and function fields.


---------------------------------------------------------------------
Assembly code
---------------------------------------------------------------------

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


---------------------------------------------------------------------
Machine code (binary, fields separated by spaces)
---------------------------------------------------------------------

INSTRUCTION               MACHINE CODE
-----------------------   ------------------------------------------------
move $s0, $zero           000000 00000 00000 10000 00000 100000
Loop: slti $t0, $s1, 0    001010 10001 01000 0000000000000000
bne $t0, $zero, exit      000101 01000 00000 0000000000001011
sll $t1, $s1, 2           000000 00000 10001 01001 00010 000000
add $t2, $s2, $t1         000000 10010 01001 01010 00000 100000
lw $t3, 0($t2)            100011 01010 01011 0000000000000000
lw $t4, 4($t2)            100011 01010 01100 0000000000000100
slt $t0, $t4, $t3         000000 01100 01011 01000 00000 101010
beq $t0, $zero, exit      000100 01000 00000 0000000000000101
move $a0, $s2             000000 00000 10010 00100 00000 100000
move $a1, $s1             000000 00000 10001 00101 00000 100000
jal Function              000011 00000000000000000000000001
addi $s1, $s1, -1         001000 10001 10001 1111111111111111
j Loop                    000010 00000000000000000000000010
exit: addi $s0, $s0, 1    001000 10000 10000 0000000000000001
