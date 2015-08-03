require 'json'

json = Dir['./reports/report*.json'].map { |f| JSON.parse File.read(f) }.flatten
File.open("output.json","w") do |f|
  f.write(json.to_json)
end