class ShirtSize
  class << self; attr_accessor :sizes_hash end

  @sizes_hash = {
    'M S'    => 'Mens - S',
    'M M'    => 'Mens - M',
    'M L'    => 'Mens - L',
    'M XL'   => 'Mens - XL',
    'M XXL'  => 'Mens - XXL',
    'M XXXL' => 'Mens - XXXL',
    'W S'    => 'Womens - S',
    'W M'    => 'Womens - M',
    'W L'    => 'Womens - L',
    'W XL'   => 'Womens - XL',
    'W XXL'  => 'Womens - XXL',
    'W XXXL' => 'Womens - XXXL'
  }

  def self.sizes
    @sizes_hash.keys
  end

  # size param must be in persistant format ("M L") for example.
  def self.readable(size)
    @sizes_hash[size]
  end

  # size param must be in readable format ("Men's Large") for example.
  def self.persistable(size)
    @sizes_hash.invert[size]
  end
end
