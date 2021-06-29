module Hack
  module Command
    class << self
      attr_accessor :current_vm_file

      def parse(text)
        parts = text.split(/\s+/)
        clazz = get_class parts[0].capitalize.gsub(/\-(.)/) { $1&.upcase }
        raise "Unknown command #{parts[0]}" if clazz.nil?

        return clazz.new if parts.size == 1
        return clazz.new parts[1] if parts.size == 2
        return clazz.new parts[1], parts[2] if parts.size == 3

        raise "Illegal command  #{parts[0]}"
      end

      private

      def get_class(class_name)
        return const_get class_name if const_defined? class_name

        nil
      end
    end
    class BaseCommand
      attr_accessor :text, :line_number
    end
    class BinaryCommand < BaseCommand
    end
    class UnaryCommand < BaseCommand
    end

    class FunctionCommand < BaseCommand
      attr_accessor :function, :count

      def initialize(function, count)
        @function = function
        @count = count
      end
    end

    class Function < FunctionCommand
      def init_local
        <<-ASM
        @SP
        A=M
        M=0
        @SP
        M=M+1
        ASM
      end

      def compile
        <<-ASM
        (#{@function})
        #{init_local * @count.to_i}
        ASM
      end
    end

    class Return < FunctionCommand
      def initialize; end
      def compile
        <<-ASM
        @LCL
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
        M=D //THAT=*(Frame-1)
        @R13
        AM=M-1 //Frame-2
        D=M
        @THIS
        M=D //THIS=*(Frame-2)
        @R13
        AM=M-1 //Frame-3
        D=M
        @ARG
        M=D //ARG=*(Frame-3)
        @R13
        AM=M-1 //Frame-4
        D=M
        @LCL
        M=D //LCL=*(Frame-4)
        @R14 //return address
        A=M
        0;JMP
        ASM
      end
    end

    class Call < FunctionCommand
      def push_seq(var)
        <<-ASM
        @#{var}
        D=M
        @SP
        A=M
        M=D
        @SP
        AM=M+1
        ASM
      end

      def compile
        <<-ASM
        @#{@function}_return_address$#{@line_number}
        D=A
        @SP
        A=M
        M=D
        @SP
        AM=M+1
        #{push_seq('LCL')}
        #{push_seq('ARG')}
        #{push_seq('THIS')}
        #{push_seq('THAT')}
        @#{@count.to_i + 5}
        D=A
        @SP
        D=M-D
        @ARG
        M=D
        @SP
        D=M
        @LCL
        M=D
        @#{@function}
        0;JMP
        (#{@function}_return_address$#{@line_number})
        ASM
      end
    end

    class ControlCommand < BaseCommand
      attr_accessor :label

      def initialize(label)
        @label = label
      end
    end

    class Label < ControlCommand
      def compile
        <<-ASM
        (#{Command.current_vm_file}:#{@label})
        ASM
      end
    end

    class Goto < ControlCommand
      def compile
        <<-ASM
        @#{Command.current_vm_file}:#{@label}
        0;JMP
        ASM
      end
    end

    class IfGoto < ControlCommand
      def compile
        <<-ASM
        @SP
        AM=M-1
        D=M
        @#{Command.current_vm_file}:#{@label}
        D;JNE
        ASM
      end
    end

    class MemeryAccessCommand < BaseCommand
      attr_accessor :segment, :index

      def initialize(segment, index)
        @segment = segment
        @index = index
      end

      def get_segment(seg)
        case seg
        when 'argument'
          'ARG'
        when 'local'
          'LCL'
        when 'this'
          'THIS'
        when 'that'
          'THAT'
        else
          raise "Unknown segment #{seg}"
        end
      end
    end

    class Add < BinaryCommand
      def compile
        <<-ASM
        @SP
        AM=M-1
        D=M
        A=A-1
        M=D+M
        ASM
      end
    end

    class Sub < BinaryCommand
      def compile
        <<-ASM
        @SP
        AM=M-1
        D=M
        A=A-1
        M=M-D
        ASM
      end
    end

    class Eq < BinaryCommand
      def compile
        <<-ASM
        @SP
        AM=M-1
        D=M
        A=A-1
        D=M-D
        @TRUE#{line_number}
        D;JEQ
        @SP
        A=M-1
        M=0
        @END#{line_number}
        0;JMP
        (TRUE#{line_number})
        @SP
        A=M-1
        M=-1
        (END#{line_number})
        ASM
      end

    end

    class Gt < BinaryCommand
      def compile
        <<-ASM
        @SP
        AM=M-1
        D=M
        A=A-1
        D=M-D
        @TRUE#{line_number}
        D;JGT
        @SP
        A=M-1
        M=0
        @END#{line_number}
        0;JMP
        (TRUE#{line_number})
        @SP
        A=M-1
        M=-1
        (END#{line_number})
        ASM
      end
    end
    class Lt < BinaryCommand
      def compile
        <<-ASM
        @SP
        AM=M-1
        D=M
        A=A-1
        D=M-D
        @TRUE#{line_number}
        D;JLT
        @SP
        A=M-1
        M=0
        @END#{line_number}
        0;JMP
        (TRUE#{line_number})
        @SP
        A=M-1
        M=-1
        (END#{line_number})
        ASM
      end
    end

    class And < BinaryCommand
      def compile
        <<-ASM
        @SP
        AM=M-1
        D=M
        A=A-1
        M=D&M
        ASM
      end
    end

    class Or < BinaryCommand
      def compile
        <<-ASM
        @SP
        AM=M-1
        D=M
        A=A-1
        M=D|M
        ASM
      end
    end

    class Neg < UnaryCommand
      def compile
        <<-ASM
        @SP
        A=M-1
        M=-M
        ASM
      end
    end

    class Not < UnaryCommand
      def compile
        <<-ASM
        @SP
        A=M-1
        M=!M
        ASM
      end
    end

    class Pop < MemeryAccessCommand
      def compile
        if @segment == 'static'
          return <<-ASM
          @SP
          AM=M-1
          D=M
          @#{Command.current_vm_file}.#{index}
          M=D
          ASM
        end
        if @segment == 'temp'
          return <<-ASM
          @SP
          AM=M-1
          D=M
          @#{index.to_i + 5}
          M=D
          ASM
        end
        if @segment == 'pointer'
          return <<-ASM
          @SP
          AM=M-1
          D=M
          @#{index.to_i + 3}
          M=D
          ASM
        end
        <<-ASM
        @#{index}
        D=A
        @#{get_segment(@segment)}
        D=D+M
        @R13
        M=D
        @SP
        AM=M-1
        D=M
        @R13
        A=M
        M=D
        ASM
      end
    end

    class Push < MemeryAccessCommand
      def compile
        if @segment == 'static'
          return <<-ASM
          @#{Command.current_vm_file}.#{index}
          D=M
          @SP
          A=M
          M=D
          @SP
          AM=M+1
          ASM
        end

        if @segment == 'constant'
          return <<-ASM
          @#{index}
          D=A
          @SP
          A=M
          M=D
          @SP
          AM=M+1
          ASM
        end

        if @segment == 'temp'
          return <<-ASM
          @#{index.to_i + 5}
          D=M
          @SP
          A=M
          M=D
          @SP
          AM=M+1
          ASM
        end
        if @segment == 'pointer'
          return <<-ASM
          @#{index.to_i + 3}
          D=M
          @SP
          A=M
          M=D
          @SP
          AM=M+1
          ASM
        end
        <<-ASM
        @#{index}
        D=A
        @#{get_segment(@segment)}
        A=D+M
        D=M
        @SP
        A=M
        M=D
        @SP
        AM=M+1
        ASM
      end
    end
  end

end
