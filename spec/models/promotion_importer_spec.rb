require 'spec_helper'

describe PromotionImporter do
  before do
    create(:plan)
    create(:plan_3_months)
  end

  describe "#import_promotions" do
    it "creates promotions" do
      csv_file = Rack::Test::UploadedFile.new('spec/support/promotions_import.csv', 'text/csv')
      importer = PromotionImporter.new(csv_file)

      expect{
        importer.import_promotions
      }.to change(Promotion, :count).by(1)
    end

    context "when there are similar promotions" do
      it "does not create similar promotions" do
        csv_file = Rack::Test::UploadedFile.new('spec/support/promotions_import_duplicates.csv', 'text/csv')
        importer = PromotionImporter.new(csv_file)

        expect{
          importer.import_promotions
        }.to change(Promotion, :count).by(1)
      end
    end
  end
end