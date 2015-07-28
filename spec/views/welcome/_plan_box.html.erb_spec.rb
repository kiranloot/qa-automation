require 'spec_helper'

describe "rendering welcome/_plan_box.html.erb" do

  let(:plan_12) { create(:plan_12_months) }
  let(:plan) { create(:plan) }
  let(:plan_box_partial_path) { 'welcome/plan_box' }

  context "when plan.period == 12" do
    before do
      render partial: plan_box_partial_path, locals: {plan: plan_12}
    end

    it "displays plan_12.readable_title.upcase" do
      expect(rendered).to match(plan_12.readable_title.upcase)
    end

    it "displays 'Includes Bonus Gift'" do
      expect(rendered).to match('Includes Bonus Gift')
    end

    it "displays plan_12.monthly_cost" do
      expect(rendered).to have_content(number_to_currency(plan_12.monthly_cost))
    end

    it "displays plan_12.cost" do
      expect(rendered).to have_content(number_to_currency(plan_12.cost))
    end

    it "displays plan_12.readable_title" do
      expect(rendered).to match(plan_12.readable_title)
    end

    it "displays plan_12.savings_copy" do
      expect(rendered).to match(plan_12.readable_title)
    end

    it "displays the correct URL to sign up for 12 month plan" do
      expect(rendered).to match("#{plan_12.name}/checkouts/new")
    end

    it "displays the modal URL for 12 month plan" do
      expect(rendered).to match("#learnmore_modal_#{plan_12.id}")
    end

  end

  context "when plan.period != 12" do
    before do
      render partial: plan_box_partial_path, locals: {plan: plan}
    end

    it "displays plan.readable_title.upcase" do
      expect(rendered).to match(plan.readable_title.upcase)
    end

    it "displays 'Includes Bonus Gift'" do
      expect(rendered).to_not match('Includes Bonus Gift')
    end

    it "displays plan.monthly_cost" do
      expect(rendered).to have_content(number_to_currency(plan.monthly_cost))
    end

    it "displays plan.cost" do
      expect(rendered).to have_content(number_to_currency(plan.cost))
    end

    it "displays plan.readable_title" do
      expect(rendered).to match(plan.readable_title)
    end

    it "displays plan.savings_copy" do
      expect(rendered).to match(plan.readable_title)
    end
  end

end