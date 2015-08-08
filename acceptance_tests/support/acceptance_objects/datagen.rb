class DataGen

  def initialize(args)
    @args = args.split(" ")
    @args = preprocess(args)
    @args = args.join("_")
  end

  def preprocess(args)
    address = /an? (.*?) address/.match(args)
    months = /an? (.*?) month subscription/.match(args)
    address ? @args = address_trait(address[1]) : @args = @args
    months ? @args = send(months[1]) : @args = @args
  end


 def address_trait(country)
   type_hash = {"denmark" => :denmark, "uk" => :uk, "germany" => :germany,
                "finland" => :finland, "france" => :france, "norway" => :norway,
                "newzealand" => :new_zealand, "ireland" => :ireland,
                "austrailia" => :austrailia, "netherlands" => :netherlands,
                "sweden" => :sweden, "ie" => :ireland, "de" => :germany,
                "dk" => :denmark, "nl" => :netherlands, "fr" => :france, 
                "no" => :norway, "fi" => :finland, "nz" => :new_zealand,
                "au" => :austrailia, "se" => "sweden", "gb" => :uk, 
                "california" => :california}
  p = type_hash.values
   result = type == "random" ? 
   if type != "random"
     return type_hash[type]
   else
     possibilities = type_hash.values
     return possibilities[rand(possibilities.size)]
   end

 end

 def rand_val(possibilities)
   possibilities[rand()]
 end


end