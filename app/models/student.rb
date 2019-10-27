class Student < ApplicationRecord
  belongs_to :course
  belongs_to :user
  belongs_to :order
end
