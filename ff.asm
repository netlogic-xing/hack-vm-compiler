    @256 //bootstrap
    D=A
    @SP
    M=D
    D=0
    @LCL
    MD=D-1
    @ARG
    MD=D-1
    @THIS
    MD=D-1
    @THAT
    MD=D-1
            @Sys.init_return_address$
        D=A
        @SP
        A=M
        M=D
        @SP
        AM=M+1
                @LCL
        D=M
        @SP
        A=M
        M=D
        @SP
        AM=M+1

                @ARG
        D=M
        @SP
        A=M
        M=D
        @SP
        AM=M+1

                @THIS
        D=M
        @SP
        A=M
        M=D
        @SP
        AM=M+1

                @THAT
        D=M
        @SP
        A=M
        M=D
        @SP
        AM=M+1

        @5
        D=A
        @SP
        D=M-D
        @ARG
        M=D
        @SP
        D=M
        @LCL
        M=D
        @Sys.init
        0;JMP
        (Sys.init_return_address$)

@4 //push constant 4(Sys.init)// function Sys.init 0
D=A
@SP
A=M
M=D
@SP
AM=M+1
@Main.fibonacci_return_address$2 //call Main.fibonacci 1
D=A
@SP
A=M
M=D
@SP
AM=M+1
@LCL
D=M
@SP
A=M
M=D
@SP
AM=M+1
@ARG
D=M
@SP
A=M
M=D
@SP
AM=M+1
@THIS
D=M
@SP
A=M
M=D
@SP
AM=M+1
@THAT
D=M
@SP
A=M
M=D
@SP
AM=M+1
@6
D=A
@SP
D=M-D
@ARG
M=D
@SP
D=M
@LCL
M=D
@Main.fibonacci
0;JMP
@Sys:WHILE //goto WHILE(Sys:WHILE)// label WHILE
0;JMP
@0 //push argument 0(Main.fibonacci)// function Main.fibonacci 0
D=A
@ARG
A=D+M
D=M
@SP
A=M
M=D
@SP
AM=M+1
@2 //push constant 2
D=A
@SP
A=M
M=D
@SP
AM=M+1
@SP //lt
AM=M-1
D=M
A=A-1
D=M-D
@TRUE3
D;JLT
@SP
A=M-1
M=0
@END3
0;JMP
@SP//(TRUE3)
A=M-1
M=-1
(END3)
@SP //if-goto IF_TRUE
AM=M-1
D=M
@Main:IF_TRUE
D;JNE
@Main:IF_FALSE //goto IF_FALSE
0;JMP
(Main:IF_TRUE) //label IF_TRUE
@0 //push argument 0
D=A
@ARG
A=D+M
D=M
@SP
A=M
M=D
@SP
AM=M+1
@SP //return
A=M-1
D=M
@ARG
A=M
M=D
@ARG
D=M+1
@SP
M=D
@LCL
AM=M-1
D=M
@THAT
M=D
@LCL
AM=M-1
D=M
@THIS
M=D
@LCL
AM=M-1
D=M
@ARG
M=D
@LCL
AM=M-1
D=M
@R13
M=D
@LCL
AM=M-1
D=M
@R14
M=D
@R13
D=M
@LCL
M=D
@R14
A=M
0;JMP
@0 //push argument 0(Main:IF_FALSE)// label IF_FALSE
D=A
@ARG
A=D+M
D=M
@SP
A=M
M=D
@SP
AM=M+1
@2 //push constant 2
D=A
@SP
A=M
M=D
@SP
AM=M+1
@SP //sub
AM=M-1
D=M
A=A-1
M=M-D
@Main.fibonacci_return_address$13 //call Main.fibonacci 1
D=A
@SP
A=M
M=D
@SP
AM=M+1
@LCL
D=M
@SP
A=M
M=D
@SP
AM=M+1
@ARG
D=M
@SP
A=M
M=D
@SP
AM=M+1
@THIS
D=M
@SP
A=M
M=D
@SP
AM=M+1
@THAT
D=M
@SP
A=M
M=D
@SP
AM=M+1
@6
D=A
@SP
D=M-D
@ARG
M=D
@SP
D=M
@LCL
M=D
@Main.fibonacci
0;JMP
@0 //push argument 0(Main.fibonacci_return_address$13)
D=A
@ARG
A=D+M
D=M
@SP
A=M
M=D
@SP
AM=M+1
@1 //push constant 1
D=A
@SP
A=M
M=D
@SP
AM=M+1
@SP //sub
AM=M-1
D=M
A=A-1
M=M-D
@Main.fibonacci_return_address$17 //call Main.fibonacci 1
D=A
@SP
A=M
M=D
@SP
AM=M+1
@LCL
D=M
@SP
A=M
M=D
@SP
AM=M+1
@ARG
D=M
@SP
A=M
M=D
@SP
AM=M+1
@THIS
D=M
@SP
A=M
M=D
@SP
AM=M+1
@THAT
D=M
@SP
A=M
M=D
@SP
AM=M+1
@6
D=A
@SP
D=M-D
@ARG
M=D
@SP
D=M
@LCL
M=D
@Main.fibonacci
0;JMP
@SP //add(Main.fibonacci_return_address$17)
AM=M-1
D=M
A=A-1
M=D+M
@SP //return
A=M-1
D=M
@ARG
A=M
M=D
@ARG
D=M+1
@SP
M=D
@LCL
AM=M-1
D=M
@THAT
M=D
@LCL
AM=M-1
D=M
@THIS
M=D
@LCL
AM=M-1
D=M
@ARG
M=D
@LCL
AM=M-1
D=M
@R13
M=D
@LCL
AM=M-1
D=M
@R14
M=D
@R13
D=M
@LCL
M=D
@R14
A=M
0;JMP
