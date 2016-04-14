require 'factory_girl'

FactoryGirl.define do

  factory :subscription do
    product 'Loot Crate'
    months '1'
    name {"#{months} Month Plan Subscription"}
    shirt_size 'Mens - S'
    waist_size 'Womens - S'
    recurly_name {"#{months} Month Subscription"}

    trait :year do
      name {name.gsub(/12 Month/, '1 Year')}
    end

    trait :core_crate do
    end
    trait :loot_crate do
    end

    trait :anime_crate do
      product 'Anime'
      name {"Anime #{months} Month Subscription"}
      recurly_name {name}
      year
    end
    trait :anime do
      anime_crate
    end

    trait :pets_crate do
      name {"Pets #{months} Month Subscription"}
      recurly_name {name}
    end
    trait :pets do
      pets_crate
    end

    trait :gaming_crate do
      name {"Gaming #{months} Month Subscription"}
      recurly_name {name}
    end
    trait :gaming do
      gaming_crate
    end

    trait :firefly_cargo_crate do
      product 'Firefly'
    end
    trait :firefly do
      firefly_cargo_crate
    end

    trait :loot_crate_dx do
      product 'Lcdx'
      name {"Lcdx #{months} Month Subscription"}
      recurly_name {name}
    end
    trait :lcdx do
      loot_crate_dx
    end
  end

  factory :levelupsubscription, class:LevelUpSubscription do
    product 'accessory'
    months '1'
    name {"Level Up Accessories #{months} Month"}
    shirt_size 'Mens - S'
    waist_size 'Womens - S'
    recurly_name {"LC - LU - Accessory - #{months} month"}

    trait :level_up_accessories do
      #matches default values
    end
    trait :accessory do
      level_up_accessories
    end

    trait :level_up_bundle_tshirt_accessories do
      product 'level-up-bundle-tshirt-accessories'
      name {"Level Up T-Shirt + Accessories Bundle #{months} Month"}
      recurly_name {"LC - LU - Bundle (socks + wearables) - #{months} month"}
    end

    trait :level_up_socks do
      product 'socks'
      name "Level Up Socks #{months} Month"
      recurly_name "LC - LU - Socks - #{months} month"
    end
    trait :socks do
      level_up_socks
    end

    trait :level_up_tshirt do
      product 'level-up-tshirt'
      name "Level Up T-Shirt #{months} Month"
      recurly_name "LC - LU - T-Shirt - #{months} month"
    end

    trait :wearable do
      product 'wearable'
      name "Level Up Wearable #{months} Month"
      recurly_name "LC - LU - Wearable - #{months} month"
    end

    trait :level_up_bundle_socks_wearable do
      product 'level-up-bundle-socks-wearable'
      name "Level Up Bundle (socks & wearable) #{months} Month"
      recurly_name "LC - LU - Bundle (socks + wearables) - #{months} month"
    end
  end
end
