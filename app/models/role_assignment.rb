class RoleAssignment < ActiveRecord::Base
  belongs_to :admin
  belongs_to :role

  validates_uniqueness_of :admin_id, scope: :role_id
  validates_presence_of :admin_id, :role_id
end
