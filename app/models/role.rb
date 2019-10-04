class Role < ActiveRecord::Base
  has_many :role_assignments
  has_many :admins, through: :role_assignments

  validates_uniqueness_of :name
end
