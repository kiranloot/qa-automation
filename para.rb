args = ARGV if ARGV

def SITE(s)
  @SITE = s
end


def DRIVER(d)
  @DRIVER = d
end

def n(n)
  @n = n
end

@DRIVER ||= "remote"
@SITE ||= "qa"
@n ||= "5"

if args
  args.each do |arg|
    m = arg[/[^=]+/]
    p = arg.partition('=').last
    send("#{m}", p)
 end
end

command = "SITE=#{@SITE} parallel_cucumber -o '--tags @ready' -n #{@n}  acceptance_tests --serialize-stdout"
puts command

Process.spawn(command)