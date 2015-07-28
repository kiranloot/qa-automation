namespace :recurly do
  desc 'Create test accounts - TTL: June 25, 2015'
  task :create_test_accounts, [:filename] => [:environment] do |t, args|
    @filename = args[:filename]
    @csv_parser = CSVParser.new(@filename)
    @job_queue = Queue.new
    puts "Populate Job Queue"
    start_time = Time.now
    populate_job_queue
    puts "Populate Job Queue Completed in #{Time.now-start_time} seconds"
    pool_size = 30
    puts "Started: #{DateTime.now}"
    start_time = Time.now
    workers = pool_size.times.map do
      Thread.new do
        begin
          while rows = @job_queue.pop(true)
          puts "remaining: #{@job_queue.size}"
            process(rows)
          end # while
        rescue ThreadError => e
          puts "ThreadError: #{e.message}"
        end
      end
    end
    workers.map(&:join)
    puts "Completed: #{DateTime.now}"
    puts "Took #{Time.now - start_time}"
  end

  task :destroy_test_accounts, [:filename] => [:environment] do |t, args|
    @filename = args[:filename]
    @csv_parser = CSVParser.new(@filename)
    @job_queue = Queue.new
    puts "Populate Job Queue"
    start_time = Time.now
    populate_job_queue
    puts "Populate Job Queue Completed in #{Time.now-start_time} seconds"
    pool_size = 30
    puts "Started: #{DateTime.now}"
    start_time = Time.now
    workers = pool_size.times.map do
      Thread.new do
        begin
          while rows = @job_queue.pop(true)
            puts "remaining: #{@job_queue.size}"
            destroy_accounts(rows)
          end # while
        rescue ThreadError => e
          puts "ThreadError: #{e.message}"
        end
      end
    end
    workers.map(&:join)
    puts "Completed: #{DateTime.now}"
    puts "Took #{Time.now - start_time}"

  end

  private

  def process(rows)
    rows.each do |row|
      account_object = account_object_from_row(row)
      puts "Creating: #{account_object.customer_id} - #{account_object.credit_card_first_name} #{account_object.credit_card_last_name}"
      create_recurly_account(account_object)
    end
  end

  def destroy_accounts(rows)
    rows.each do |row|
      account_object = account_object_from_row(row)
      destroy_recurly_account(account_object)
    end
  end

  def destroy_recurly_account(account_object)
    begin
      recurly_account = Recurly::Account.find(account_object.customer_id)
      recurly_account.destroy
    rescue => e
      puts "#{e.message}"
    end
  end

  def populate_job_queue
    lines = []
    IO.foreach(@filename) do |line|
      lines << line
      if lines.size >= 1000
        lines = CSV.parse(lines.join) rescue next
        store lines
        lines = []
      end
    end
    store lines
  end

  def store(lines)
    return if lines.blank?
    puts "Storing #{lines.size} rows..."
    @job_queue.push(lines)
  end

  def account_object_from_row(row)
    OpenStruct.new(
      customer_id: row[0],
      credit_card_vault_token: row[1],
      credit_card_first_name: row[2],
      credit_card_last_name: row[3],
      credit_card_billing_address: row[4],
      credit_card_billing_address_2: row[5],
      credit_card_billing_city: row[6],
      credit_card_billing_state: row[7],
      credit_card_billing_zip: row[8]
    )
  end

  def create_recurly_account(account_object)
    billing_info = build_billing_info(account_object)
    begin
      Recurly::Account.create(
        account_code: account_object.customer_id,
        first_name: account_object.credit_card_first_name,
        last_name: account_object.credit_card_last_name,
        billing_info: billing_info
      )
    rescue => exception
      puts "Recurly Exception: #{exception.message}"
    end
  end

  def build_billing_info(account_object)
    {
      address1: account_object.credit_card_billing_address,
      address2: account_object.credit_card_billing_address_2,
      city: account_object.credit_card_billing_city,
      state: account_object.credit_card_billing_state,
      country: 'US',
      zip: account_object.credit_card_billing_zip,
      number: '4111111111111111',
      month: 01,
      year: 2016,
      verification_value: '123'
    }
  end
end
