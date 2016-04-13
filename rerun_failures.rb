#only run if all_rerun.txt exists?
#only run if there are no more than x failures

args = ARGV if ARGV

def SITE(s)
  @SITE = s
end

def TEMP_DIR(t)
  @TEMP_DIR = t
end

def RETRY_THRESHOLD(r)
  @RETRY_THRESHOLD = r
end

def n(n)
  @n = n
end

def SITE(s)
  @SITE = s
end

@TEMP_DIR = "tmp/reruns/"
@RERUN_FILE ||= "all_rerun.txt"
@RETRY_THRESHOLD ||= "45"
@n ||= "8"
@SITE ||= "qa"

if args
  args.each do |arg|
    m = arg[/[^=]+/]
    p = arg.partition('=').last
    send("#{m}", p)
 end
end

output = `cucumber SITE=qa @#{@RERUN_FILE} SERVER_CONFIGS=${HOME}/server_configs.yml --dry-run`

system "mkdir tmp"
system "mkdir #{@TEMP_DIR}"
system "rm #{@TEMP_DIR}rerun_*.feature"

lines = output.split("\n")

#exit if we have more failures than the retry threshold
failures = lines[lines.length - 2][/^(\d+)/]
if failures.to_i > @RETRY_THRESHOLD.to_i
  puts "Failures exceeded retry threshold of " + @RETRY_THRESHOLD + "!"
  exit
end

write_flag = false
iterator = 1
current_file = "rerun_#{iterator}.feature"

lines.each do |line|
  line = line.gsub(/#.*/,"")
  if line =~ /@/ || line =~ /scenarios/ || line =~ /steps/ || line =~ /scenario/ 
    #do nothing
  elsif line =~ /Feature:/ && write_flag == false
    write_flag = true
    File.open(@TEMP_DIR + current_file,"w") do |f|
      f.write(line + "\n")
    end
  elsif line =~ /Feature:/ && write_flag == true
    iterator += 1
    current_file = "rerun_#{iterator}.feature"
    File.open(@TEMP_DIR + current_file,"w") do |f|
      f.write(line + "\n")
    end
  elsif write_flag == true
    File.open(@TEMP_DIR + current_file,"a") do |f|
      f.write(line + "\n")
    end
  else
  end
end

unless(Dir.entries("#{@TEMP_DIR}").size <= 2)
  system "DRIVER=remote BROWSER=chrome REMOTE_URL=http://localhost:4444/wd/hub SITE=#{@SITE} parallel_cucumber -n #{@n} -o '-p parallel' #{@TEMP_DIR} --serialize-stdout"
  system "ruby combine_json.rb"
else
  puts "No rerun temp files found! Rerun skipped."
end
