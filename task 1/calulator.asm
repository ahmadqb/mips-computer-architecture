# ---------------------------------------------------------------
# Calculator in MIPS assembly (MARS)
# Equivalent of the C program: modulus (%), power (^), quit (q)
# Course assignment, june 2024
# ---------------------------------------------------------------

        .data
msg1:       .asciiz "Please enter first number: "          # Prompt for first number
msg2:       .asciiz "Please enter second number: "         # Prompt for second number
msg3:       .asciiz "Please enter the operation ('%' for mod, '^' for power, 'q' to quit): "  # Prompt for operation
msg4:       .asciiz "\nError: Please enter another value of Y.\n"  # Error message for zero divisor
msg5:       .asciiz "\n"                                   # Leading part of the modulus message
msg6:       .asciiz "\n"                                   # Leading part of the power message
mod_msg:    .asciiz " mod "                                # Middle part of the modulus message
pow_msg:    .asciiz " to the power "                       # Middle part of the power message
result_msg: .asciiz " = "                                  # Equals part of the message
newline:    .asciiz "\n"                                   # Newline character

X:          .word 0                                        # Variable: X
Y:          .word 0                                        # Variable: Y
operation:  .byte 0                                        # Variable: operation
Results:    .word 0                                        # Variable: Results

        .text
main:                                   # Start of main program
        # Read the first number
        la   $a0, msg1                  # Load address of msg1
        li   $v0, 4                     # System call code 4 (print string)
        syscall

        li   $v0, 5                     # System call code 5 (read integer)
        syscall
        la   $t0, X                     # Load address of X
        sw   $v0, ($t0)                 # Store the first number in X

read_y:                                 # Read the second number (also reached after an error)
        la   $a0, msg2                  # Load address of msg2
        li   $v0, 4                     # System call code 4 (print string)
        syscall

        li   $v0, 5                     # System call code 5 (read integer)
        syscall
        la   $t0, Y                     # Load address of Y
        sw   $v0, ($t0)                 # Store the second number in Y

loop:                                   # Start of loop
        # Read the operation
        la   $a0, msg3                  # Load address of msg3
        li   $v0, 4                     # System call code 4 (print string)
        syscall

        li   $v0, 12                    # System call code 12 (read character)
        syscall
        la   $t0, operation             # Load address of operation
        sb   $v0, ($t0)                 # Store the operation character in operation

        # Switch statement
        la   $t0, operation             # Load address of operation
        lb   $t1, ($t0)                 # Load the operation character into $t1
        beq  $t1, '%', mod              # If operation is '%', jump to mod
        beq  $t1, '^', pow              # If operation is '^', jump to pow
        beq  $t1, 'q', exit             # If operation is 'q', jump to exit
        j    loop                       # Default case, ask for the operation again

mod:                                    # Modulus operation
        la   $t0, X                     # Load address of X
        lw   $a0, ($t0)                 # First argument: X
        la   $t0, Y                     # Load address of Y
        lw   $a1, ($t0)                 # Second argument: Y
        beq  $a1, $zero, error          # Check for division by zero
        jal  mod_f                      # Call mod_f
        la   $t0, Results               # Load address of Results
        sw   $v0, ($t0)                 # Store the result in Results

        # Print the result
        la   $a0, msg5                  # Load address of msg5
        li   $v0, 4                     # System call code 4 (print string)
        syscall

        la   $t0, X                     # Load address of X
        lw   $a0, ($t0)                 # Load X into $a0
        li   $v0, 1                     # System call code 1 (print integer)
        syscall

        la   $a0, mod_msg               # Load address of mod_msg
        li   $v0, 4                     # System call code 4 (print string)
        syscall

        la   $t0, Y                     # Load address of Y
        lw   $a0, ($t0)                 # Load Y into $a0
        li   $v0, 1                     # System call code 1 (print integer)
        syscall

        la   $a0, result_msg            # Load address of result_msg
        li   $v0, 4                     # System call code 4 (print string)
        syscall

        la   $t0, Results               # Load address of Results
        lw   $a0, ($t0)                 # Load Results into $a0
        li   $v0, 1                     # System call code 1 (print integer)
        syscall

        la   $a0, newline               # Load address of newline
        li   $v0, 4                     # System call code 4 (print string)
        syscall

        j    loop                       # Jump back to loop

pow:                                    # Power operation
        la   $t0, X                     # Load address of X
        lw   $a0, ($t0)                 # First argument: base X
        la   $t0, Y                     # Load address of Y
        lw   $a1, ($t0)                 # Second argument: exponent Y
        jal  pow_f                      # Call pow_f
        la   $t0, Results               # Load address of Results
        sw   $v0, ($t0)                 # Store the result in Results

        # Print the result
        la   $a0, msg6                  # Load address of msg6
        li   $v0, 4                     # System call code 4 (print string)
        syscall

        la   $t0, X                     # Load address of X
        lw   $a0, ($t0)                 # Load X into $a0
        li   $v0, 1                     # System call code 1 (print integer)
        syscall

        la   $a0, pow_msg               # Load address of pow_msg
        li   $v0, 4                     # System call code 4 (print string)
        syscall

        la   $t0, Y                     # Load address of Y
        lw   $a0, ($t0)                 # Load Y into $a0
        li   $v0, 1                     # System call code 1 (print integer)
        syscall

        la   $a0, result_msg            # Load address of result_msg
        li   $v0, 4                     # System call code 4 (print string)
        syscall

        la   $t0, Results               # Load address of Results
        lw   $a0, ($t0)                 # Load Results into $a0
        li   $v0, 1                     # System call code 1 (print integer)
        syscall

        la   $a0, newline               # Load address of newline
        li   $v0, 4                     # System call code 4 (print string)
        syscall

        j    loop                       # Jump back to loop

exit:                                   # Exit the program
        li   $v0, 10                    # System call code 10 (exit)
        syscall

error:                                  # Division by zero: report it and ask for Y again
        la   $a0, msg4                  # Load address of msg4
        li   $v0, 4                     # System call code 4 (print string)
        syscall
        j    read_y                     # Jump back to read a new Y

# ---------------------------------------------------------------
# Function definitions
# Arguments: $a0 = X, $a1 = Y      Return value: $v0
# ---------------------------------------------------------------

mod_f:                                  # Modulus function: X % Y
        div  $a0, $a1                   # Divide $a0 by $a1
        mfhi $v0                        # Move the remainder to $v0
        jr   $ra                        # Return from function

pow_f:                                  # Power function: X ^ Y
        li   $v0, 1                     # Initialize result to 1
        bltz $a1, pow_neg               # Negative exponent: result truncates to 0 (as int in C)
        li   $t4, 0                     # Initialize counter to 0
pow_l:                                  # Power loop
        beq  $a1, $t4, pow_end          # If counter equals exponent, end loop
        mul  $v0, $v0, $a0              # Multiply result by base
        addi $t4, $t4, 1                # Increment counter
        j    pow_l                      # Jump back to start of loop
pow_neg:
        li   $v0, 0                     # Integer result of a negative exponent
pow_end:                                # End of power function
        jr   $ra                        # Return from function
