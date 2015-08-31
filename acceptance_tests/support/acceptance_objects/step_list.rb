class StepList
  require 'forwardable'
  include Enumerable
  extend Forwardable
  def_delegators :@list, :each, :<<

  def initialize(arg_symbol)
    @list = []
    create_list(arg_symbol)
  end

  def create_list(arg_symbol)
    respond_to?(arg_symbol) ? @list += self.send(arg_symbol) : @list = []
  end

  def registered_with_active
    ["create a random month subscription"]
  end

  def one_month
    ["create a one month subscription"]
  end

  def multi_use_promo
    ["an admin user with access to their info",
    "the user visits the admin page",
    "logs in as an admin",
    "the admin user navigates to the admin promotions page",
    "admin creates a new promotion and passes to user"]
  end

  def canceled
    ["create a one month subscription",
    "an admin user with access to their info",
    "the user visits the admin page",
    "logs in as an admin",
    "performs an immediate cancellation on the user account",
    "logs out of admin",
    "focus on subject user"]
  end

end