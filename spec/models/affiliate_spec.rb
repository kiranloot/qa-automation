describe Affiliate do

  describe "validations" do
    it { is_expected.to validate_uniqueness_of :name }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to_not allow_value('?!^&*()', '', 'one two three', "apos'trophe", ' space ').for(:name) }
    it { is_expected.to allow_value('abc', 'XYZ', '123', "-_-").for(:name) }
  end
end