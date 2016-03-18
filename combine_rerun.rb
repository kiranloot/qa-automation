reruns = Dir['./reports/rerun*.txt'].map { |f| File.read(f) }.flatten
File.open("all_rerun.txt","w") do |f|
  reruns.each do |rerun|
    if rerun.length > 2
      f.write(rerun + " ")
    end
  end
  f.close
end
