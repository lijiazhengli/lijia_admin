class Student < ApplicationRecord
  audited
  belongs_to :course
  belongs_to :user
  belongs_to :order
end
