#only run if all_rerun.txt exists?
#only run if there are no more than x failures
threads = 8
tmp_dir = "tmp/reruns/"
site = "qa3"
rerun_file = "all_rerun.txt"
output = `cucumber SITE=qa @#{rerun_file} SERVER_CONFIGS=${HOME}/server_configs.yml --dry-run`

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
