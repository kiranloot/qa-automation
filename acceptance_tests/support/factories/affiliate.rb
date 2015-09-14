require 'factory_girl'
require 'date'
FactoryGirl.define do

  factory :affiliate do
    name {("auto_affiliate" + Date.today.strftime("%b") + Date.today.day.to_s +
           "_" + Time.now.to_f.to_s.reverse[0..6].delete(".")).downcase}
    redirect_url "//www.lootcrate.com/?utm_source=radio&utm_medium=sirius&utm_campaign=techcrunch&cvosrc=radio.techcrunch.sirius"
    redirect_url_escaped "//www.lootcrate.com/\\?utm_source=radio&utm_medium=sirius&utm_campaign=techcrunch&cvosrc=radio.techcrunch.sirius"
  end
end
