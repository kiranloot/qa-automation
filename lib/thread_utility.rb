class ThreadUtility
  def self.with_connection(&block)
    begin
      yield block
    rescue ActiveRecord::ConnectionTimeoutError => e
      puts "oh noes, database connection issue"
    rescue Exception => e
      raise e
    ensure
      # Check the connection back into the connection pool
      ActiveRecord::Base.connection.close if ActiveRecord::Base.connection
    end
  end
end
