require 'digest/sha1'

class Admin < ActiveRecord::Base
  validates_presence_of        :password #TODO - DSA - Is length validation needed to correctly implement SHA1?
  validates_presence_of        :username
  validates_uniqueness_of      :username

  def password=(pw)
    self[:password] = Admin.encrypt(pw)
  end
  
  class << self

    def encrypt(password)
      return Digest::SHA1.hexdigest(password)
    end
  
    def authenticate(username,password)
      admin = Admin.find_by_username(username) 
      return false unless admin
      return (Admin.encrypt(password) == admin.password)
    end 
  
  end
  
end
