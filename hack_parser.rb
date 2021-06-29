require './hack'
class Parser
  include Enumerable

  def each
    @commands.each do |x|
      yield x
    end
  end

  def symbol_table
    Hack::Command.symbol_table
  end

  def initialize(file)
    @file = file
    Hack::Command.current_vm_file = File.basename(file, File.extname(file))
    @commands = []
    parse
  end

  private

  def parse
    line_number = -1
    @file.each_line do |line|
      next if line =~ %r{^\s*$}
      next if line =~ %r{^\s*//.*}

      line_number += 1
      command = line.split(%r{//})[0].strip

      cmd = Hack::Command.parse(command)
      cmd.text=command
      cmd.line_number = line_number
      @commands << cmd
    end
  end
end
