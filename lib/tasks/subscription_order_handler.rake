require 'highline'
require 'highline/import'

# Create a color scheme, naming color patterns with symbol names.
ft = HighLine::ColorScheme.new do |cs|
  cs[:headline]        = [:bold, :yellow, :on_black]
  cs[:horizontal_line] = [:bold, :white, :on_blue]
  cs[:green]        = [:green]
  cs[:magenta]         = [:magenta]
end

# Assign that color scheme to HighLine...
HighLine.color_scheme = ft

def get_month_year
  month_year = ask 'What monthyear is this for (e.g. JAN2015) ?' do |q|
    d = DateTime.now
    if d.day >= 20
      d = d + 1.month
    end
    q.default =  d.strftime("%^b%Y")
    q.validate  = /\A[A-Z]{3}2\d{3}\Z/
  end
end

def ask_month_year
  month_year = nil

  input = nil
  begin
    month_year = get_month_year

    say("<%= color('Review....', :horizontal_line) %>")

    s = "#{s}.  \nIf correct press return.  If incorrect type 'i'"

    input = ask s
  end while input == 'i'

  return month_year
end

def ask_subscription_id
  sub_id = nil

  input = nil
  begin
    sub_id = ask 'Subscription id? ' do |q|
      q.validate  = /\A\d+\Z/
    end

    say("<%= color('Review....', :horizontal_line) %>")

    s = "#{s}.  \nIf correct press return.  If incorrect type 'i'"

    input = ask s
  end while input == 'i'

  return sub_id
end

namespace :soh do
  desc 'push'
  task push_sample_shipment_to_wombat: :environment do
    ss = SubscriptionShipment.last
    ss.send(:push_to_wombat)
  end

  desc 'run subscription order handler for one specific subscription'
  task run_one: :environment do
    month_year = ask_month_year
    subscription_id = ask_subscription_id
    soh = Subscription::OrderHandler.new(month_year)
    soh.force_subscription(subscription_id)
  end

  desc 'run subscription order handler'
  task run: :environment do
    month_year = ask_month_year
    soh = Subscription::OrderHandler.new(month_year)
    soh.handle_all_orders
  end

  desc 'run subscription order handler (domestic)'
  task domestic: :environment do
    month_year = ask_month_year
    soh = Subscription::OrderHandler.new(month_year)
    soh.handle_domestic_orders
  end

  desc 'run subscription order handler (domestic)'
  task international: :environment do
    month_year = ask_month_year
    soh = Subscription::OrderHandler.new(month_year)
    soh.handle_international_orders
  end
end
