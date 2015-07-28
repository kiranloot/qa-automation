require 'spec_helper'

describe OrdersCsv do

  describe "Validations" do
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:job_id) }
    it { is_expected.to validate_uniqueness_of(:job_id) }
    it { is_expected.to validate_inclusion_of(:status).in_array(['pending', 'current', 'expired']) }
  end
end
