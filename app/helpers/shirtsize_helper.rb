module ShirtsizeHelper
  def shirt_sizes
    options = []
    GlobalConstants::READABLE_SHIRT_SIZES.each_with_index do |item, index|
      options << [item, GlobalConstants::SHIRT_SIZES[index]]
    end
    options
  end
end
