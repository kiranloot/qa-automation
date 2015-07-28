namespace :address do
  desc 'validate addresses'
  task :validate, [:start_id, :end_id, :type] => :environment do |t, args|
    puts Benchmark.measure {
      correct  = 0
      wrong    = 0
      from_chargify = 0
      to_chargify = 0
      total    = 0
      unsynced = 0
      manual_resolve_hash = {}

      #ids = Subscription.all.map(&:shipping_address).map(&:subscription_id)
      #Subscription.find(ids).each do |subscription|
      Subscription.where(subscription_status: 'active').where(shipping_address_id: (args[:start_id].to_i)..(args[:end_id].to_i)).find_each do |subscription|
        total += 1

        s_address = subscription.shipping_address
        customer = Chargify::Customer.find(subscription.customer_id)

        if customer.subscriptions.select { |s| s.state == 'active' }.count > 1
          puts "\n#{customer.email} #{customer.id} - has multiple subs under customer".cyan
          if manual_resolve_hash[customer.email].present?
            manual_resolve_hash[customer.email] << customer.id
          else
            manual_resolve_hash[customer.email] = [customer.id]
          end

          next
        end

        if in_sync?(s_address, customer)
          correct += 1
          next
        else
          puts ''
        end

        begin
          if true #local_valid?(s_address) and chargify_valid?(customer)
            if in_sync?(s_address, customer)
              next
              print_summary(total, s_address, customer, 'green')
              #puts "correct".green
              correct += 1
              next
            else
              unsynced += 1
              print_summary(total, s_address, customer, 'yellow')
              #puts "out-of-sync".yellow
              # find latest version, sync both
              if s_address.updated_at < customer.updated_at
                s_address.sync_from_chargify(customer, args[:type])
                puts 'synced local <- from chargify'.red
                from_chargify += 1
              else
                s_address.sync_to_chargify(customer, args[:type])
                puts 'synced local -> to chargify'.light_magenta
                to_chargify += 1
              end
            end
          end
=begin
          elsif not local_valid?(s_address) and not chargify_valid?(customer)
            wrong += 1

            puts "both invalid".red
            # find latest version, correct it, sync both
            if s_address.updated_at < customer.updated_at
              state = customer.zip.to_region(state: true)
              customer.state = state
              if args[:type] == "live"
                customer.save
                s_address.sync_from_chargify(customer, true)
              else
                s_address.sync_from_chargify(customer)
              end
              puts "synced local <- from chargify".yellow
            else
              state = s_address.zip.to_region(state: true)
              s_address.state = state
              if args[:type] == "live"
                s_address.save
                s_address.sync_to_chargify(customer, true)
              else
                s_address.sync_to_chargify(customer)
              end
              puts "synced local -> to chargify".yellow
            end
          elsif not local_valid?(s_address)
            wrong += 1

            puts "local invalid".red
            if args[:type] == "live"
              s_address.save
              s_address.sync_from_chargify(customer, true)
            else
              s_address.sync_from_chargify(customer)
            end
            puts "synced local <- from chargify".yellow
          elsif not chargify_valid?(customer)
            wrong += 1

            puts "chargify invalid".red
            if args[:type] == "live"
              s_address.save
              s_address.sync_to_chargify(customer, true)
            else
              s_address.sync_to_chargify(customer)
            end
            puts "synced local -> to chargify".yellow
          else
            puts "WTF? Local    - #{s_address}".magenta
            puts "WTF? Chargify - #{customer.attributes}".magenta
          end
=end
        rescue => e
          puts e.inspect.magenta
          if manual_resolve_hash[customer.email].present?
            manual_resolve_hash[customer.email] << customer.id
          else
            manual_resolve_hash[customer.email] = [customer.id]
          end
        end
        print_summary(total, s_address, customer)
      end

      puts "\nWrong Addresses:  #{wrong}".red
      puts "Valid Addresses:  #{correct}".green
      puts "Synced Addresses: #{wrong}".magenta
      puts "Synced From Chargify: #{from_chargify}".red
      puts "Synced To Chargify: #{to_chargify}".magenta
      puts "Total Processed:  #{total}\n"

      puts manual_resolve_hash.keys
    }
  end


  def local_valid?(s_address)
    s_address.state_and_zip_match and s_address.valid?
  end

  def chargify_valid?(customer)
    if customer.country != 'CA'
      customer.zip.to_region(state: true) == customer.state
    end
  end

  def in_sync?(s_address, customer)
    if s_address.line_1 == customer.address and
        s_address.line_2.present? == customer.address_2.present? and
        s_address.city == customer.city and
        s_address.state == customer.state and
        s_address.zip == customer.zip and
        s_address.country == customer.country
      return true
    else
      return false
    end
  end

  def print_summary(total, a, b, color = 'white')
    puts total.to_s.white + " | #{a.id.to_s.ljust(7)} |" + " #{a.line_1} #{a.line_2}, #{a.city}, #{a.state}, #{a.zip}, #{a.country} - local".send(color)
    puts total.to_s.white + " | #{b.id} |" + " #{b.address} #{b.address_2}, #{b.city}, #{b.state}, #{b.zip}, #{b.country} - chargify".send(color)
  end
end
