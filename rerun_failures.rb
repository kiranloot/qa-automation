#only run if all_rerun.txt exists?
#only run if there are no more than x failures
output = `cucumber SITE=qa @all_rerun.txt SERVER_CONFIGS=${HOME}/server_configs.yml --dry-run`
lines = output.split("\n")
line = lines.pop
feature_array = []
feature_string = ""
write_flag = false
iterator = 1
current_file = "rerun_#{iterator}.feature"

lines.each do |line|
  line = line.gsub(/#.*/,"")
  if line =~ /@/ 
    #do nothing
  elsif line =~ /Feature:/ && write_flag == false
    write_flag = true
    File.open("tmp/reruns/#{current_file}","w") do |f|
      f.write(line + "\n")
    end
  elsif line =~ /Feature:/ && write_flag == true
    write_flag = false
    iterator += 1
    current_file = "rerun_#{iterator}.feature"
  elsif write_flag == true
    File.open("tmp/reruns/#{current_file}","a") do |f|
      f.write(line + "\n")
    end
  else
  end
end
