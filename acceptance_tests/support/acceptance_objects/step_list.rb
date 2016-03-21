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

  def registered_with_active_level_up
    ["create a level up three month accessory subscription"]
  end

  def registered_with_active_anime
    ["create a random month Anime subscription"]
  end

  def registered_with_active_pets
    ["create a random month Pets subscription"]
  end

  def one_month
    ["create a one month subscription"]
  end

  def anime_one_month
    ["create a one month Anime subscription"]
  end

  def gaming_one_month
    ["create a one month Gaming subscription"]
  end

  def pets_one_month
    ["create a one month Pets subscription"]
  end

  def wearable_one_month
    ["create a level up one month wearable subscription"]
  end

  def promo
    ["the user visits the admin page",
    "logs in as an admin",
    "the admin user navigates to the admin promotions page",
    "admin creates the new promotion"]
  end

  def multi_use_fixed_promo
    ["the user visits the admin page",
    "logs in as an admin",
    "the admin user navigates to the admin promotions page",
    "admin creates a new multi use promotion with a 10 Fixed discount and passes to user"]
  end

  def one_time_use_percentage_promo
    ["the user visits the admin page",
    "logs in as an admin",
    "the admin user navigates to the admin promotions page",
    "admin creates a new one time use promotion with a 10 Percentage discount and passes to user"]
  end

  def canceled
    ["create a one month subscription",
    "the user visits the admin page",
    "logs in as an admin",
    "performs an immediate cancellation on the user account",
    "logs out of admin"]
  end

  def registered_with_active_last_month
    ["create a one month subscription",
    "move subscription to last month"]
  end
end
