# == Schema Information
#
# Table name: admin_users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime2
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  #Cheap fast way of implementing different levels of admins.  Used to restrict access to sensitive areas in Active Admin. TODO: create field in database for user_type.
  def is_super_admin?
    super_admins = [
    "kris.clemente@lootcrate.com",
    "kiran.gajipara@lootcrate.com",
    "chris.lee@lootcrate.com",
    "hai.nguyen@lootcrate.com",
    "hannah@lootcrate.com",
    "jeff.leung@lootcrate.com",
    "jeff.squires@gmail.com",
    "matt@lootcrate.com",
    "patrick@lootcrate.com"
    ]
    return super_admins.include?(email)
  end


end
