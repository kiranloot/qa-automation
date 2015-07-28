puts 'Updating Plans' unless Rails.env == "test"

# Create Products
core_crate      = Product.where(sku: 'core-crate', brand: 'Loot Crate Core').first_or_create
core_crate.update_attributes(name: 'Core Crate', description: "Loot Crate is an epic monthly subscription box for geeks and gamers for under $20.")
socks_crate     = Product.where(sku: 'socks-crate', brand: 'Level Up').first_or_create
socks_crate.update_attributes(name: '+2 Socks', description: "Socks are awesome! They're basically really soft, stretchy shoes. Add two mystery pairs of themed, premium socks to your order every month!")
accessory_crate = Product.where(sku: 'accessory-crate', brand: 'Level Up').first_or_create
accessory_crate.update_attributes(name: "+1 Accessory", description: "We've got you covered, geek chic Lady Looters! Will you get a necklace? A scarf? Or possibly a bracelet? The only thing we're saying about this accessory is that it'll look awesome (just like you when you wear it)! Treat the ladies in your life (or yourself) to 1-2 nice and nerdy accessories matching the month's theme!
")
wearable_crate  = Product.where(sku: 'wearable-crate', brand: 'Level Up').first_or_create
wearable_crate.update_attributes(name: '+1 Wearable', description: "Could it be a premium shirt? A cool hat? Nerdy loungewear? That's the mystery, Looters! But we promise it'll be cool, durable and fit the month's theme! Wrap yourself in style with a fashionable, functional and wonderfully wearable item (that you can't find in your Loot Crate) every month!")


# Create Socks Crate Plans
Plan.where(name: 'lc-lu01-01-us').first_or_create.update_attributes({title: 'Level Up Socks 1 Month', product_id: socks_crate.id, cost: 9.99, period: 1, shipping_and_handling: 0, savings_copy: "Cancel Anytime", country: 'US'})
Plan.where(name: 'lc-lu01-03-us').first_or_create.update_attributes({title: 'Level Up Socks 3 Month', product_id: socks_crate.id, cost: 28.47, period: 3, shipping_and_handling: 0, savings_copy: "You save $1.50!", country: 'US'})
Plan.where(name: 'lc-lu01-06-us').first_or_create.update_attributes({title: 'Level Up Socks 6 Month', product_id: socks_crate.id, cost: 53.94, period: 6, shipping_and_handling: 0, savings_copy: "You save $6.00!", country: 'US'})

Plan.where(name: 'lc-lu01-01-in').first_or_create.update_attributes({title: 'Level Up Socks 1 Month', product_id: socks_crate.id, cost: 12.99, period: 1, shipping_and_handling: 0, savings_copy: "Cancel Anytime", country: 'INT'})
Plan.where(name: 'lc-lu01-03-in').first_or_create.update_attributes({title: 'Level Up Socks 3 Month', product_id: socks_crate.id, cost: 37.47, period: 3, shipping_and_handling: 0, savings_copy: "You save $1.50!", country: 'INT'})
Plan.where(name: 'lc-lu01-06-in').first_or_create.update_attributes({title: 'Level Up Socks 6 Month', product_id: socks_crate.id, cost: 71.94, period: 6, shipping_and_handling: 0, savings_copy: "You save $6.00!", country: 'INT'})

# Create Accessory Crate Plans
Plan.where(name: 'lc-lu02-01-us').first_or_create.update_attributes({title: 'Level Up Accessory 1 Month', product_id: accessory_crate.id, cost: 14.99, period: 1, shipping_and_handling: 0, savings_copy: "Cancel Anytime", country: 'US'})
Plan.where(name: 'lc-lu02-03-us').first_or_create.update_attributes({title: 'Level Up Accessory 3 Month', product_id: accessory_crate.id, cost: 43.47, period: 3, shipping_and_handling: 0, savings_copy: "You save $1.50!", country: 'US'})
Plan.where(name: 'lc-lu02-06-us').first_or_create.update_attributes({title: 'Level Up Accessory 6 Month', product_id: accessory_crate.id, cost: 83.94, period: 6, shipping_and_handling: 0, savings_copy: "You save $6.00!", country: 'US'})

Plan.where(name: 'lc-lu02-01-in').first_or_create.update_attributes({title: 'Level Up Accessory 1 Month', product_id: accessory_crate.id, cost: 17.99, period: 1, shipping_and_handling: 0, savings_copy: "Cancel Anytime", country: 'INT'})
Plan.where(name: 'lc-lu02-03-in').first_or_create.update_attributes({title: 'Level Up Accessory 3 Month', product_id: accessory_crate.id, cost: 52.47, period: 3, shipping_and_handling: 0, savings_copy: "You save $1.50!", country: 'INT'})
Plan.where(name: 'lc-lu02-06-in').first_or_create.update_attributes({title: 'Level Up Accessory 6 Month', product_id: accessory_crate.id, cost: 101.94, period: 6, shipping_and_handling: 0, savings_copy: "You save $6.00!", country: 'INT'})

# Create Wearable Crate Plans
Plan.where(name: 'lc-lu03-01-us').first_or_create.update_attributes({title: 'Level Up Wearable 1 Month', product_id: wearable_crate.id, cost: 14.99, period: 1, shipping_and_handling: 0, savings_copy: "Cancel Anytime", country: 'US'})
Plan.where(name: 'lc-lu03-03-us').first_or_create.update_attributes({title: 'Level Up Wearable 3 Month', product_id: wearable_crate.id, cost: 43.47, period: 3, shipping_and_handling: 0, savings_copy: "You save $1.50!", country: 'US'})
Plan.where(name: 'lc-lu03-06-us').first_or_create.update_attributes({title: 'Level Up Wearable 6 Month', product_id: wearable_crate.id, cost: 83.94, period: 6, shipping_and_handling: 0, savings_copy: "You save $6.00!", country: 'US'})

Plan.where(name: 'lc-lu03-01-in').first_or_create.update_attributes({title: 'Level Up Wearable 1 Month', product_id: wearable_crate.id, cost: 17.99, period: 1, shipping_and_handling: 0, savings_copy: "Cancel Anytime", country: 'INT'})
Plan.where(name: 'lc-lu03-03-in').first_or_create.update_attributes({title: 'Level Up Wearable 3 Month', product_id: wearable_crate.id, cost: 52.47, period: 3, shipping_and_handling: 0, savings_copy: "You save $1.50!", country: 'INT'})
Plan.where(name: 'lc-lu03-06-in').first_or_create.update_attributes({title: 'Level Up Wearable 6 Month', product_id: wearable_crate.id, cost: 101.94, period: 6, shipping_and_handling: 0, savings_copy: "You save $6.00!", country: 'INT'})

# Create Core Crate Plans
Plan.where(name: '1-month-subscription').first_or_create.update_attributes({title: '1 Month Subscription', product_id: core_crate.id, cost: 19.95, period: 1, shipping_and_handling: 6.0, savings_copy: "Cancel Anytime", country: 'US'})
Plan.where(name: '3-month-subscription').first_or_create.update_attributes({title: '3 Month Subscription', product_id: core_crate.id, cost: 57.75, period: 3, shipping_and_handling: 6.0, savings_copy: "You Save $2.10!", country: 'US'})
Plan.where(name: '6-month-subscription').first_or_create.update_attributes({title: '6 Month Subscription', product_id: core_crate.id, cost: 113.70, period: 6, shipping_and_handling: 6.0, savings_copy: "You Save $6!", country: 'US'})
Plan.where(name: 'canadian-one-month').first_or_create.update_attributes({title: '1 Month Subscription', product_id: core_crate.id, cost: 29.95, period: 1, shipping_and_handling: 0.0, savings_copy: "Cancel Anytime"})
Plan.where(name: 'au-1-month-subscription').first_or_create.update_attributes({title: '1 Month Subscription', product_id: core_crate.id, cost: 29.95, period: 1, shipping_and_handling: 0.0, savings_copy: "Cancel Anytime", country: 'AU'})
Plan.where(name: 'au-3-month-subscription').first_or_create.update_attributes({title: '3 Month Subscription', product_id: core_crate.id, cost: 84.00, period: 3, shipping_and_handling: 0.0, savings_copy: "You Save $5.85!", country: 'AU'})
Plan.where(name: 'au-6-month-subscription').first_or_create.update_attributes({title: '6 Month Subscription', product_id: core_crate.id, cost: 162.00, period: 6, shipping_and_handling: 0.0, savings_copy: "You Save $17.70!", country: 'AU'})
Plan.where(name: 'ca-1-month-subscription').first_or_create.update_attributes({title: '1 Month Subscription', product_id: core_crate.id, cost: 29.95, period: 1, shipping_and_handling: 0.0, savings_copy: "Cancel Anytime", country: 'CA'})
Plan.where(name: 'ca-3-month-subscription').first_or_create.update_attributes({title: '3 Month Subscription', product_id: core_crate.id, cost: 84.00, period: 3, shipping_and_handling: 0.0, savings_copy: "You Save $5.85!", country: 'CA'})
Plan.where(name: 'ca-6-month-subscription').first_or_create.update_attributes({title: '6 Month Subscription', product_id: core_crate.id, cost: 162.00, period: 6, shipping_and_handling: 0.0, savings_copy: "You Save $17.70!", country: 'CA'})
Plan.where(name: 'gb-1-month-subscription').first_or_create.update_attributes({title: '1 Month Subscription', product_id: core_crate.id, cost: 29.95, period: 1, shipping_and_handling: 0.0, savings_copy: "Cancel Anytime", country: 'GB'})
Plan.where(name: 'gb-3-month-subscription').first_or_create.update_attributes({title: '3 Month Subscription', product_id: core_crate.id, cost: 84.00, period: 3, shipping_and_handling: 0.0, savings_copy: "You Save $5.85!", country: 'GB'})
Plan.where(name: 'gb-6-month-subscription').first_or_create.update_attributes({title: '6 Month Subscription', product_id: core_crate.id, cost: 162.00, period: 6, shipping_and_handling: 0.0, savings_copy: "You Save $17.70!", country: 'GB'})
Plan.where(name: 'de-1-month-subscription').first_or_create.update_attributes({title: '1 Month Subscription', product_id: core_crate.id, cost: 29.95, period: 1, shipping_and_handling: 0.0, savings_copy: "Cancel Anytime", country: 'DE'})
Plan.where(name: 'de-3-month-subscription').first_or_create.update_attributes({title: '3 Month Subscription', product_id: core_crate.id, cost: 84.00, period: 3, shipping_and_handling: 0.0, savings_copy: "You Save $5.85!", country: 'DE'})
Plan.where(name: 'de-6-month-subscription').first_or_create.update_attributes({title: '6 Month Subscription', product_id: core_crate.id, cost: 162.00, period: 6, shipping_and_handling: 0.0, savings_copy: "You Save $17.70!", country: 'DE'})
Plan.where(name: 'dk-1-month-subscription').first_or_create.update_attributes({title: '1 Month Subscription', product_id: core_crate.id, cost: 29.95, period: 1, shipping_and_handling: 0.0, savings_copy: "Cancel Anytime", country: 'DK'})
Plan.where(name: 'dk-3-month-subscription').first_or_create.update_attributes({title: '3 Month Subscription', product_id: core_crate.id, cost: 84.00, period: 3, shipping_and_handling: 0.0, savings_copy: "You Save $5.85!", country: 'DK'})
Plan.where(name: 'dk-6-month-subscription').first_or_create.update_attributes({title: '6 Month Subscription', product_id: core_crate.id, cost: 162.00, period: 6, shipping_and_handling: 0.0, savings_copy: "You Save $17.70!", country: 'DK'})
Plan.where(name: 'ie-1-month-subscription').first_or_create.update_attributes({title: '1 Month Subscription', product_id: core_crate.id, cost: 29.95, period: 1, shipping_and_handling: 0.0, savings_copy: "Cancel Anytime", country: 'IE'})
Plan.where(name: 'ie-3-month-subscription').first_or_create.update_attributes({title: '3 Month Subscription', product_id: core_crate.id, cost: 84.00, period: 3, shipping_and_handling: 0.0, savings_copy: "You Save $5.85!", country: 'IE'})
Plan.where(name: 'ie-6-month-subscription').first_or_create.update_attributes({title: '6 Month Subscription', product_id: core_crate.id, cost: 162.00, period: 6, shipping_and_handling: 0.0, savings_copy: "You Save $17.70!", country: 'IE'})
Plan.where(name: 'nl-1-month-subscription').first_or_create.update_attributes({title: '1 Month Subscription', product_id: core_crate.id, cost: 29.95, period: 1, shipping_and_handling: 0.0, savings_copy: "Cancel Anytime", country: 'NL'})
Plan.where(name: 'nl-3-month-subscription').first_or_create.update_attributes({title: '3 Month Subscription', product_id: core_crate.id, cost: 84.00, period: 3, shipping_and_handling: 0.0, savings_copy: "You Save $5.85!", country: 'NL'})
Plan.where(name: 'nl-6-month-subscription').first_or_create.update_attributes({title: '6 Month Subscription', product_id: core_crate.id, cost: 162.00, period: 6, shipping_and_handling: 0.0, savings_copy: "You Save $17.70!", country: 'NL'})
Plan.where(name: 'no-1-month-subscription').first_or_create.update_attributes({title: '1 Month Subscription', product_id: core_crate.id, cost: 29.95, period: 1, shipping_and_handling: 0.0, savings_copy: "Cancel Anytime", country: 'NO'})
Plan.where(name: 'no-3-month-subscription').first_or_create.update_attributes({title: '3 Month Subscription', product_id: core_crate.id, cost: 84.00, period: 3, shipping_and_handling: 0.0, savings_copy: "You Save $5.85!", country: 'NO'})
Plan.where(name: 'no-6-month-subscription').first_or_create.update_attributes({title: '6 Month Subscription', product_id: core_crate.id, cost: 162.00, period: 6, shipping_and_handling: 0.0, savings_copy: "You Save $17.70!", country: 'NO'})
Plan.where(name: 'se-1-month-subscription').first_or_create.update_attributes({title: '1 Month Subscription', product_id: core_crate.id, cost: 29.95, period: 1, shipping_and_handling: 0.0, savings_copy: "Cancel Anytime", country: 'SE'})
Plan.where(name: 'se-3-month-subscription').first_or_create.update_attributes({title: '3 Month Subscription', product_id: core_crate.id, cost: 84.00, period: 3, shipping_and_handling: 0.0, savings_copy: "You Save $5.85!", country: 'SE'})
Plan.where(name: 'se-6-month-subscription').first_or_create.update_attributes({title: '6 Month Subscription', product_id: core_crate.id, cost: 162.00, period: 6, shipping_and_handling: 0.0, savings_copy: "You Save $17.70!", country: 'SE'})
Plan.where(name: 'amiibo-crate-three-weekly-payments').first_or_create.update_attributes({title: 'Amiibo 3 Weekly', product_id: core_crate.id, cost: 55.00, period: 1, shipping_and_handling: 5.0, savings_copy: "Cancel Anytime"})
Plan.where(name: 'amiibo-crate-single-payment').first_or_create.update_attributes({title: 'Amiibo Single', product_id: core_crate.id, cost: 155.00, period: 1, shipping_and_handling: 15.0, savings_copy: "SAVE $10!!"})
Plan.where(name: 'fi-1-month-subscription').first_or_create.update_attributes({title: '1 Month Subscription', product_id: core_crate.id, cost: 29.95, period: 1, shipping_and_handling: 0.0, savings_copy: "Cancel Anytime", country: 'FI'})
Plan.where(name: 'fi-3-month-subscription').first_or_create.update_attributes({title: '3 Month Subscription', product_id: core_crate.id, cost: 84.00, period: 3, shipping_and_handling: 0.0, savings_copy: "You Save $5.85!", country: 'FI'})
Plan.where(name: 'fi-6-month-subscription').first_or_create.update_attributes({title: '6 Month Subscription', product_id: core_crate.id, cost: 162.00, period: 6, shipping_and_handling: 0.0, savings_copy: "You Save $17.70!", country: 'FI'})
Plan.where(name: 'fr-1-month-subscription').first_or_create.update_attributes({title: '1 Month Subscription', product_id: core_crate.id, cost: 29.95, period: 1, shipping_and_handling: 0.0, savings_copy: "Cancel Anytime", country: 'FR'})
Plan.where(name: 'fr-3-month-subscription').first_or_create.update_attributes({title: '3 Month Subscription', product_id: core_crate.id, cost: 84.00, period: 3, shipping_and_handling: 0.0, savings_copy: "You Save $5.85!", country: 'FR'})
Plan.where(name: 'fr-6-month-subscription').first_or_create.update_attributes({title: '6 Month Subscription', product_id: core_crate.id, cost: 162.00, period: 6, shipping_and_handling: 0.0, savings_copy: "You Save $17.70!", country: 'FR'})
Plan.where(name: 'nz-1-month-subscription').first_or_create.update_attributes({title: '1 Month Subscription', product_id: core_crate.id, cost: 29.95, period: 1, shipping_and_handling: 0.0, savings_copy: "Cancel Anytime", country: 'NZ'})
Plan.where(name: 'nz-3-month-subscription').first_or_create.update_attributes({title: '3 Month Subscription', product_id: core_crate.id, cost: 84.00, period: 3, shipping_and_handling: 0.0, savings_copy: "You Save $5.85!", country: 'NZ'})
Plan.where(name: 'nz-6-month-subscription').first_or_create.update_attributes({title: '6 Month Subscription', product_id: core_crate.id, cost: 162.00, period: 6, shipping_and_handling: 0.0, savings_copy: "You Save $17.70!", country: 'NZ'})
Plan.where(name: '12-month-subscription').first_or_create.update_attributes({title: '1 Year Subscription', product_id: core_crate.id, cost: 215.40, period: 12, shipping_and_handling: 6.0, savings_copy: "You Save $24!", country: 'US'})
Plan.where(name: 'au-12-month-subscription').first_or_create.update_attributes({title: '1 Year Subscription', product_id: core_crate.id, cost: 312.00, period: 12, shipping_and_handling: 0.0, savings_copy: "You Save $47.40!", country: 'AU'})
Plan.where(name: 'ca-12-month-subscription').first_or_create.update_attributes({title: '1 Year Subscription', product_id: core_crate.id, cost: 312.00, period: 12, shipping_and_handling: 0.0, savings_copy: "You Save $47.40!", country: 'CA'})
Plan.where(name: 'de-12-month-subscription').first_or_create.update_attributes({title: '1 Year Subscription', product_id: core_crate.id, cost: 312.00, period: 12, shipping_and_handling: 0.0, savings_copy: "You Save $47.40!", country: 'DE'})
Plan.where(name: 'dk-12-month-subscription').first_or_create.update_attributes({title: '1 Year Subscription', product_id: core_crate.id, cost: 312.00, period: 12, shipping_and_handling: 0.0, savings_copy: "You Save $47.40!", country: 'DK'})
Plan.where(name: 'fi-12-month-subscription').first_or_create.update_attributes({title: '1 Year Subscription', product_id: core_crate.id, cost: 312.00, period: 12, shipping_and_handling: 0.0, savings_copy: "You Save $47.40!", country: 'FI'})
Plan.where(name: 'fr-12-month-subscription').first_or_create.update_attributes({title: '1 Year Subscription', product_id: core_crate.id, cost: 312.00, period: 12, shipping_and_handling: 0.0, savings_copy: "You Save $47.40!", country: 'FR'})
Plan.where(name: 'gb-12-month-subscription').first_or_create.update_attributes({title: '1 Year Subscription', product_id: core_crate.id, cost: 312.00, period: 12, shipping_and_handling: 0.0, savings_copy: "You Save $47.40!", country: 'GB'})
Plan.where(name: 'ie-12-month-subscription').first_or_create.update_attributes({title: '1 Year Subscription', product_id: core_crate.id, cost: 312.00, period: 12, shipping_and_handling: 0.0, savings_copy: "You Save $47.40!", country: 'IE'})
Plan.where(name: 'nl-12-month-subscription').first_or_create.update_attributes({title: '1 Year Subscription', product_id: core_crate.id, cost: 312.00, period: 12, shipping_and_handling: 0.0, savings_copy: "You Save $47.40!", country: 'NL'})
Plan.where(name: 'no-12-month-subscription').first_or_create.update_attributes({title: '1 Year Subscription', product_id: core_crate.id, cost: 312.00, period: 12, shipping_and_handling: 0.0, savings_copy: "You Save $47.40!", country: 'NO'})
Plan.where(name: 'nz-12-month-subscription').first_or_create.update_attributes({title: '1 Year Subscription', product_id: core_crate.id, cost: 312.00, period: 12, shipping_and_handling: 0.0, savings_copy: "You Save $47.40!", country: 'NZ'})
Plan.where(name: 'se-12-month-subscription').first_or_create.update_attributes({title: '1 Year Subscription', product_id: core_crate.id, cost: 312.00, period: 12, shipping_and_handling: 0.0, savings_copy: "You Save $47.40!", country: 'SE'})

# Legacy Plans
Plan.where(name: '1-month-subscription-v1').first_or_create.update_attributes({title: '1 Month Subscription', product_id: core_crate.id, cost: 19.37, period: 1, shipping_and_handling: 6.0, savings_copy: "Cancel Anytime", country: 'US'})
Plan.where(name: '3-month-subscription-v1').first_or_create.update_attributes({title: '3 Month Subscription', product_id: core_crate.id, cost: 55.11, period: 3, shipping_and_handling: 6.0, savings_copy: "You Save $2.10!", country: 'US'})
Plan.where(name: '6-month-subscription-v1').first_or_create.update_attributes({title: '6 Month Subscription', product_id: core_crate.id, cost: 105.99, period: 6, shipping_and_handling: 6.0, savings_copy: "You Save $6!", country: 'US'})

# Create socks product variants and inventory units
unisex_socks = Variant.where(product_id: socks_crate.id, sku: 'unisex-socks', is_master: true).first_or_create
unisex_socks.update_attributes({name: 'All Sock Sizes'})
InventoryUnit.where(variant_id: unisex_socks.id).first_or_create

# Create accessory product variants and inventory units
unisex_accessory = Variant.where(product_id: accessory_crate.id, sku: 'unisex-accessories', is_master: true).first_or_create
unisex_accessory.update_attributes({name: 'All Accessory Sizes'})
InventoryUnit.where(variant_id: unisex_accessory.id).first_or_create

# Create wearable product variants and inventory units
unisex_s_shirt = Variant.where(product_id: wearable_crate.id, sku: 'unisex-s-shirt', is_master: false).first_or_create
unisex_s_shirt.update_attributes({name: 'Unisex - S'})
InventoryUnit.where(variant_id: unisex_s_shirt.id).first_or_create

unisex_m_shirt = Variant.where(product_id: wearable_crate.id, sku: 'unisex-m-shirt', is_master: false).first_or_create
unisex_m_shirt.update_attributes({name: 'Unisex - M'})
InventoryUnit.where(variant_id: unisex_m_shirt.id).first_or_create

unisex_l_shirt = Variant.where(product_id: wearable_crate.id, sku: 'unisex-l-shirt', is_master: false).first_or_create
unisex_l_shirt.update_attributes({name: 'Unisex - L'})
InventoryUnit.where(variant_id: unisex_l_shirt.id).first_or_create

unisex_xl_shirt = Variant.where(product_id: wearable_crate.id, sku: 'unisex-xl-shirt', is_master: false).first_or_create
unisex_xl_shirt.update_attributes({name: 'Unisex - XL'})
InventoryUnit.where(variant_id: unisex_xl_shirt.id).first_or_create

unisex_xxl_shirt = Variant.where(product_id: wearable_crate.id, sku: 'unisex-xxl-shirt', is_master: false).first_or_create
unisex_xxl_shirt.update_attributes({name: 'Unisex - XXL'})
InventoryUnit.where(variant_id: unisex_xxl_shirt.id).first_or_create

unisex_xxxl_shirt = Variant.where(product_id: wearable_crate.id, sku: 'unisex-xxxl-shirt', is_master: false).first_or_create
unisex_xxxl_shirt.update_attributes({name: 'Unisex - XXXL'})
InventoryUnit.where(variant_id: unisex_xxxl_shirt.id).first_or_create

