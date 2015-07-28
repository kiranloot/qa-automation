class User::EmailChanger
  attr_reader :user, :new_email, :errors
  delegate :subscriptions, :errors, to: :user

  def initialize(user, new_email)
    @user      = user
    @new_email = new_email
  end

  def perform
    User.transaction do
      update_user
      raise ActiveRecord::Rollback unless errors.empty?
      update_recurly_accounts
    end
  end

  private

  def update_user
    @user.assign_attributes email: @new_email
    @user.save! if @user.valid?
  end

  def update_recurly_accounts
    subscriptions.each do |subscription|
      RecurlyAdapter::AccountService.new(subscription.recurly_account_id).update(email: new_email)
    end
  end
end
