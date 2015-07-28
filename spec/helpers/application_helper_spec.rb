require 'spec_helper'

describe ApplicationHelper do

  it 'detects #international? by passed value and cookie' do
    expect(international?).to be_falsey
    expect(international?("US")).to be_falsey
    expect(international?("SN")).to be_truthy
  end

  it 'detects #supported_international? by cookie' do
    cookies[:country] = { :value => "AU", :expires => 1.year.from_now, :path => "/" }
    expect(supported_international?).to be_truthy
    cookies[:country] = { :value => "SN", :expires => 1.year.from_now, :path => "/" }
    expect(supported_international?).to be_falsey
  end

  it '#tax' do
    expect(tax).to eq(0.99)
  end

  it '#shipping_cost' do
    expect(shipping_cost).to eq(6.0)
  end

end
