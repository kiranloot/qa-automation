require 'json'

json = Dir['./reports/report*.json'].map { |f| File.read(f).length >= 2 ? JSON.parse(File.read(f, :encoding => 'UTF-8')) : nil }.flatten
File.open("output.json","w") do |f|
  f.write(json.to_json)
  f.close
end
