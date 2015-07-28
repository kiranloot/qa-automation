require 'spec_helper'

describe ShirtSize do

  # class methods
  it '#sizes gets list of persistable sizes' do
    expect(ShirtSize.sizes).to eq(GlobalConstants::SHIRT_SIZES)
  end

  it '#readable(size)' do
    expect(ShirtSize.readable("M S")).to eq("Mens - S")
  end

  it '#persistable(readable_size)' do
    expect(ShirtSize.persistable("Mens - XXXL")).to eq("M XXXL")
  end

end
