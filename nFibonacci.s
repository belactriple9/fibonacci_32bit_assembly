# comple with cc -fno-asynchronous-unwind-tables -fno-stack-protector -m32
    
.file    "fibonacci.s"
    .section   .rodata

.data
    name: .string "Enter an integer: " # prompt the user for an integer, n
    inputFormatScanf: .string "%d" # format for scanf to read an integer
    outputFormatScanf: .string "%s\n" # format for scanf to print an integer
    outputFormatPrintf: .string "%d\n" # format for printf to print an integer
    outputNewline: .string "\n" # newline character
.bss
    buffer: .space 4 # buffer to store the input, integers are 4 bytes long
    tempfib: .space 4 # buffer to store the fibonacci numbers
    fnow: .space 4 # buffer to store the current fibonacci number
    fnext: .space 4 # buffer to store the next fibonacci number

    .text
    .globl main
    .type main,@function
main:
    pushl %ebp
    movl %esp, %ebp

    # clear the buffer by setting it to 0
    xorl %eax, %eax
    movl %eax, buffer    

    # prompt the user for an integer, n
    pushl $name
    call printf

    # read the user's input 
    pushl $buffer # push the address of buffer onto the stack
    pushl $inputFormatScanf # push the first argument to scanf
    call scanf


    # DEBUG: print the input
    # print out user's input
    # pushl buffer # push the address of buffer onto the stack 
    # pushl $outputFormatScanf # push the first argument to scanf
    # call printf

    # store buffer into eax
    movl buffer, %esi # what we use to go through the loop
    # set fnow to 0
    movl $0, fnow
    # set fnext to 1
    movl $1, fnext

    # set edi to 1, we'll use this to sum the fibonacci numbers
    movl $1, %edi

.FIB:
    # while esi is not 0
    cmpl $1, %esi
    je .END
    # subtract 1 from esi using subl
    subl $1, %esi

    # store the sum of fnow and fnext into tempfib
    movl fnow, %edx
    addl %edx, tempfib
    movl fnext, %edx
    addl %edx, tempfib

    addl tempfib, %edi # add the sum to the running sum

    # store the fnext number into fnow
    movl fnext, %edx
    movl %edx, fnow
    # store the tempfib number into fnext
    movl tempfib, %edx
    movl %edx, fnext

    # DEBUG: print the fibonacci numbers
    # pushl fnow # push the current value of fnow onto the stack
    # pushl $outputFormatPrintf # push the first argument to printf
    # call printf

    # pushl fnext # push the value of fnext onto the stack
    # pushl $outputFormatPrintf # push the first argument to printf
    # call printf
 
    # pushl %edi  # running sum
    # pushl $outputFormatPrintf
    # call printf

    # pushl $outputNewline # push the newline character onto the stack
    # call printf
    # END OF DEBUG

    movl $0, tempfib # reset tempfib to 0

    jmp .FIB


.END:
    # DEBUG print the current fibonacci number
    # print out the fibonacci number
    # pushl fnow # push the address of fnow onto the stack
    # pushl $outputFormatPrintf # push the first argument to printf
    # call printf

    # print the running sum
    pushl %edi # push the running sum onto the stack
    pushl $outputFormatPrintf # push the first argument to printf
    call printf

    # end 
    movl $0,%eax
    leave
    ret
