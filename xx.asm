@4000 //push constant 4000(Sys.init)// function Sys.init 0
D=A
@SP
A=M
M=D
@SP
AM=M+1
@SP //pop pointer 0
AM=M-1
D=M
@3
M=D
@5000 //push constant 5000
D=A
@SP
A=M
M=D
@SP
AM=M+1
@SP //pop pointer 1
AM=M-1
D=M
@4
M=D
@Sys.main_return_address$5 //call Sys.main 0
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
@Sys.main
0;JMP
@SP //pop temp 1(Sys.main_return_address$5)
AM=M-1
D=M
@6
M=D
@Sys:LOOP //goto LOOP(Sys:LOOP)// label LOOP
0;JMP
@4001 //push constant 4001(Sys.main)
                @SP
        A=M
        M=0
        @SP
        M=M+1
        @SP
        A=M
        M=0
        @SP
        M=M+1
        @SP
        A=M
        M=0
        @SP
        M=M+1
        @SP
        A=M
        M=0
        @SP
        M=M+1
        @SP
        A=M
        M=0
        @SP
        M=M+1// function Sys.main 5
D=A
@SP
A=M
M=D
@SP
AM=M+1
@SP //pop pointer 0
AM=M-1
D=M
@3
M=D
@5001 //push constant 5001
D=A
@SP
A=M
M=D
@SP
AM=M+1
@SP //pop pointer 1
AM=M-1
D=M
@4
M=D
@200 //push constant 200
D=A
@SP
A=M
M=D
@SP
AM=M+1
@1 //pop local 1
D=A
@LCL
D=D+M
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D
@40 //push constant 40
D=A
@SP
A=M
M=D
@SP
AM=M+1
@2 //pop local 2
D=A
@LCL
D=D+M
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D
@6 //push constant 6
D=A
@SP
A=M
M=D
@SP
AM=M+1
@3 //pop local 3
D=A
@LCL
D=D+M
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D
@123 //push constant 123
D=A
@SP
A=M
M=D
@SP
AM=M+1
@Sys.add12_return_address$21 //call Sys.add12 1
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
@Sys.add12
0;JMP
@SP //pop temp 0(Sys.add12_return_address$21)
AM=M-1
D=M
@5
M=D
@0 //push local 0
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
AM=M+1
@1 //push local 1
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
AM=M+1
@2 //push local 2
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
AM=M+1
@3 //push local 3
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
AM=M+1
@4 //push local 4
D=A
@LCL
A=D+M
D=M
@SP
A=M
M=D
@SP
AM=M+1
@SP //add
AM=M-1
D=M
A=A-1
M=D+M
@SP //add
AM=M-1
D=M
A=A-1
M=D+M
@SP //add
AM=M-1
D=M
A=A-1
M=D+M
@SP //add
AM=M-1
D=M
A=A-1
M=D+M
@LCL //return
D=M
@R13
M=D //Frame = LCL, R13 holds *LCL
@5
A=D-A //Frame - 5
D=M  //return address to D
@R14
M=D //R14 holds return address
@SP
AM=M-1
D=M // Pop stack value
@ARG
A=M
M=D //put it on *ARG
@ARG
D=M+1 //ARG+1
@SP
M=D //SP=ARG+1
@R13
AM=M-1//Frame-1
D=M
@THAT
M=D //THAT=*
@4002 //push constant 4002(Sys.add12)// function Sys.add12 0
D=A
@SP
A=M
M=D
@SP
AM=M+1
@SP //pop pointer 0
AM=M-1
D=M
@3
M=D
@5002 //push constant 5002
D=A
@SP
A=M
M=D
@SP
AM=M+1
@SP //pop pointer 1
AM=M-1
D=M
@4
M=D
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
@12 //push constant 12
D=A
@SP
A=M
M=D
@SP
AM=M+1
@SP //add
AM=M-1
D=M
A=A-1
M=D+M
@LCL //return
D=M
@R13
M=D //Frame = LCL, R13 holds *LCL
@5
A=D-A //Frame - 5
D=M  //return address to D
@R14
M=D //R14 holds return address
@SP
AM=M-1
D=M // Pop stack value
@ARG
A=M
M=D //put it on *ARG
@ARG
D=M+1 //ARG+1
@SP
M=D //SP=ARG+1
@R13
AM=M-1//Frame-1
D=M
@THAT
M=D //THAT=*
