require 'spec_helper'

describe CouponCodeGenerator do
  let(:plan) { create(:plan) }
  let(:promotion) { create(:promotion, eligible_plans: [plan]) }
  let(:generator) do
    CouponCodeGenerator.new(
      prefix: 'code',
      char_length: 10,
      quantity: 100,
      plan_ids: [plan.id]
    )
  end

  describe "#generate" do
    it "returns an array of unique codes" do
      codes = generator.generate
      unique_codes = codes.uniq

      expect(codes).to be_an Array
      expect(codes.size).to eq unique_codes.size
    end

    it "returns the specified quantity" do
      codes = generator.generate

      expect(codes.size).to eq 100
    end

    it "adds an error when returned codes is not equal to the specified quantity" do
      allow(generator).to receive_message_chain(:prefix).and_return('codecodee')
      
      generator.generate

      expect(generator.errors[:quantity]).to_not be_empty
    end

    # # Not sure how to test this. Poorly designed.
    # it "does not have codes that are already in a promotion with the same eligible_plan" do
    #   taken_codes = []
    #   10000.times do
    #     taken_codes << "code#{SecureRandom.hex}".truncate(10, omission: '')
    #   end
    #   generator.stub(:taken_codes).and_return(taken_codes)

    #   codes = generator.generate

    #   expect((codes - taken_codes).size).to eq codes.size
    # end
  end
end
