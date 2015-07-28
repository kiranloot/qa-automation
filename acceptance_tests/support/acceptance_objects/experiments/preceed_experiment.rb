class PreceedTest 
  require "aspector"
  ENV['ASPECTOR_LOG_LEVEL'] = 'NONE'
  @@set_one = [:first_try, :second_try]
  def initialize

  end

  def first_try
    puts "Yo there."
  end

  def second_try
    puts "Second method."
  end

  @@set_one.each do |name|
    aspector do
     before name do
        puts "I am always first"
      end
    end
  end

end