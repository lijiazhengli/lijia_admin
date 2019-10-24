class Admin < ActiveRecord::Base
  has_many :role_assignments
  has_many :roles, through: :role_assignments

  # PASSWORD
  attr_accessor :password_confirmation

  def is?(role)
    return true if self.roles.where(name: role).first
    false
  end

  Role.all.each do |role|
    define_method "#{role.name}?" do
      self.is?(role.name)
    end
  end

end