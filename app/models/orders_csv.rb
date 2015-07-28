class OrdersCsv < ActiveRecord::Base
  validates_presence_of :job_id
  validates_uniqueness_of :job_id, uniqueness: true
  validates_presence_of :status, presence: true
  validates_inclusion_of :status, in: ['pending', 'current', 'expired']
end
