require 'spec_helper'

describe ShirtsizeHelper do
  it '#shirt_sizes returns options list for select tag' do
    expect(shirt_sizes).to eq([["Mens - S", "M S"],
                           ["Mens - M", "M M"],
                           ["Mens - L", "M L"],
                           ["Mens - XL", "M XL"],
                           ["Mens - XXL", "M XXL"],
                           ["Mens - XXXL", "M XXXL"],
                           ["Womens - S", "W S"],
                           ["Womens - M", "W M"],
                           ["Womens - L", "W L"],
                           ["Womens - XL", "W XL"],
                           ["Womens - XXL", "W XXL"],
                           ["Womens - XXXL", "W XXXL"]])
  end
end
