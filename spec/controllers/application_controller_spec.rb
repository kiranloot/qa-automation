require 'spec_helper'

describe ApplicationController do
  describe "#user_for_paper_trail" do
    context "when current_user is a User" do
      include_context 'login_user'

      it "returns user's id" do
        expect(controller.user_for_paper_trail).to eq @user.id
      end
    end

    context "when current_user is an AdminUser" do
      include_context 'login_admin'

      it "returns user's email" do
        expect(controller.user_for_paper_trail).to eq @admin_user.email
      end
    end
  end
end
