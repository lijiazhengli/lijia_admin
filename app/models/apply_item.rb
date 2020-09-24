class ApplyItem < ApplicationRecord
  belongs_to :apply
  scope :noncanceled, -> { where.not(status: ['canceled']) }
end