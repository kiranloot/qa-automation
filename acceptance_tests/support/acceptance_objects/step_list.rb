class StepList

  def initialize(arg_symbol)
    create_list(arg_symbol)
  end

  def create_list
    @list = self.send(arg_symbol)
  end

  def build
    @list
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

end