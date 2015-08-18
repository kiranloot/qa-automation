args = ARGV if ARGV

if args
  args.each do |arg|
    if arg.include?("SITE")
    end
 end
end

Process.spawn('SITE=qa2 DRIVER=remote parallel_cucumber -o "--tags @ready" -n 4 acceptance_tests --serialize-stdout')