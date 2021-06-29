require './hack'
require './hack_parser'
require 'optparse'
require 'stringio'
options = {}

o = OptionParser.new do |opts|
  OptionParser::Version = [1, 0, 0]
  opts.banner = 'Usage: compiler.rb vmfile1, vmfile2.. [options]' + "\n" + '       compiler.rb vm-directory [options]'

  opts.on('-g', '--generate-symbol-table', 'Generate symbol table') do |g|
    options[:generate_symbol] = g
  end

  opts.on('-v', '--[no-]verbose', 'Run verbosely') do |v|
    options[:verbose] = v
  end

  opts.on('-s', '--Simple-mode', 'compile directly') do |v|
    options[:simple] = v
  end

  opts.on('-n', '--no-boot', 'compile no boot code') do |v|
    options[:boot] = v
  end
  # No argument, shows at tail.  This will print an options summary.
  # Try it and see!
  opts.on_tail('-h', '--help', 'Show this message') do
    puts opts
    exit
  end

  # Another typical switch to print the version.
  opts.on_tail('--version', 'Show version') do
    puts OptionParser::Version.join('.')
    exit
  end
end

begin
  o.parse! ARGV
rescue OptionParser::InvalidOption => e
  puts e
  puts o
  exit 1
end

if ARGV.empty?
  puts 'No vmfile!'
  puts o
  exit(1)
end
vm_files = []
if ARGV.size == 1
  if ARGV[0].end_with?('.vm')
    asm_file = File.new(File.expand_path(ARGV[0].sub(/\.vm/, '.asm')), 'w')
  elsif File.directory?(File.expand_path(ARGV[0]))
    Dir[File.expand_path("#{ARGV[0]}/*.vm")].each do |vm|
      vm_files << File.new(vm, 'r')
    end
    asm_file = File.new(File.expand_path("#{ARGV[0]}.asm"), 'w')
  else
    puts "#{ARGV[0]} is not a directory"
    puts o
    exit(1)
  end
end

ARGV.select { |arg| arg.end_with? '.vm' }.each { |arg| vm_files << File.new(File.expand_path(arg), 'r') }
sys_file = vm_files.find { |file| file.path.end_with? 'Sys.vm' }
if sys_file.nil?
  sys_file = StringIO.new <<-SYS
      function Sys.init 0
      call Main.main 0
      label WHILE
      goto WHILE
  SYS

  def sys_file.path
    'Sys.vm'
  end

  def to_str
    path
  end
end
unless options[:simple]
  vm_files.reject! { |file| file.path.end_with? 'Sys.vm' }
  vm_files.unshift sys_file
  call_sys = Hack::Command::Call.new('Sys.init', 0)
  boot = <<-BOOT
    @256
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
    #{call_sys.compile}
  BOOT
  if options[:boot].nil?|| options[:boot]
    asm_file.puts boot.gsub(/^\s*/, '')
  end
  if options[:verbose]&&(options[:boot].nil?|| options[:boot])
    puts boot.sub(/(?=\n)/, " //bootstrap")
  end
end
vm_files.each do |vm_file|
  parser = Parser.new vm_file
  label = ''
  parser.each do |c|
    asm_file.puts c.compile.gsub(/^\s*/, '')
    next unless options[:verbose]

    if c.compile.match(/\s*\(/) && !c.compile.include?('return') && !c.compile.include?('TRUE')
      label = c.compile.strip + '// ' + c.text
      label = label.strip
      next
    end
    if c.compile.include? 'return'
      part_code = c.compile[0...c.compile.index('(')]
      puts part_code.gsub(/^\s*/, '').sub(/(?=\n)/, ' //' + c.text)
      label = c.compile[c.compile.index('(')..-1]
      label = label.strip
      next
    end
    if c.compile.include?('TRUE')
      code = c.compile.gsub(/^\s*/, '')
      code.gsub!(/(\((?:TRUE|END)\d+\))\n(@SP)/, '\2//\1')
      puts code.sub(/(?=\n)/, ' //' + c.text)
      next
    end
    puts c.compile.gsub(/^\s*/, '').sub(/(?=\n)/, ' //' + c.text + label)
    label = ''
  end
  if options[:generate_symbol]
    File.open(ARGV[0].sub(/\.asm/, '.tbl'), 'w+') do |f|
      parser.symbol_table.each do |k, v|
        f.puts "#{k}=>#{v}"
      end
    end
  end
  vm_file.close
end
asm_file.close
