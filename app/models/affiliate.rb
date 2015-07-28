class Affiliate < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true, length: { maximum: 255 },
    format: { with: /\A[a-zA-Z0-9\-_]+\z/, message: "no spaces or special characters allowed" }
  before_save :downcase_fields

  def downcase_fields
    self.name.downcase!
  end
end
