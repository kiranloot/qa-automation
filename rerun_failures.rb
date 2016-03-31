#only run if all_rerun.txt exists?
#only run if there are no more than x failures

args = ARGV if ARGV

def SITE(s)
  @SITE = s
end

def TEMP_DIR(t)
  @TEMP_DIR = t
end

def n(n)
  @n = n
end

@TEMP_DIR = "tmp/reruns/"
@SITE ||= "qa"
@n ||= "5"
@RERUN_FILE ||= "all_rerun.txt"

if args
  args.each do |arg|
    m = arg[/[^=]+/]
    p = arg.partition('=').last
    send("#{m}", p)
 end
end

threads = @n
tmp_dir = @TEMP_DIR
site = @SITE
rerun_file = @RERUN_FILE
output = `cucumber SITE=qa @#{rerun_file} SERVER_CONFIGS=${HOME}/server_configs.yml --dry-run`

system "mkdir #{tmp_dir}"
system "rm #{tmp_dir}rerun_*.feature"

lines = output.split("\n")
write_flag = false
iterator = 1
current_file = "rerun_#{iterator}.feature"

lines.each do |line|
  line = line.gsub(/#.*/,"")
  if line =~ /@/ || line =~ /scenarios/ || line =~ /steps/ 
    #do nothing
  elsif line =~ /Feature:/ && write_flag == false
    write_flag = true
    File.open(tmp_dir + current_file,"w") do |f|
      f.write(line + "\n")
    end
  elsif line =~ /Feature:/ && write_flag == true
    iterator += 1
    current_file = "rerun_#{iterator}.feature"
    File.open(tmp_dir + current_file,"w") do |f|
      f.write(line + "\n")
    end
  elsif write_flag == true
    File.open(tmp_dir + current_file,"a") do |f|
      f.write(line + "\n")
    end
  else
  end
end

system "SITE=#{site} parallel_cucumber -n #{threads} #{tmp_dir} --serialize-stdout"
