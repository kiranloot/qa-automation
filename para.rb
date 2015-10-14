args = ARGV if ARGV

def SITE(s)
  @SITE = s
end


def DRIVER(d)
  @DRIVER = (d)
end

@DRIVER ||= "remote"
@SITE ||= "qa"

if args
  args.each do |arg|
    m = arg[/[^=]+/]
    p = arg.partition('=').last
    send("#{m}", p)
 end
end

command = "SITE=#{@SITE} DRIVER=#{@DRIVER} parallel_cucumber -o '--tags @ready' -n 5 acceptance_tests --serialize-stdout"
puts command

Process.spawn(command)