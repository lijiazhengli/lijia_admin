class Page < ApplicationRecord
  audited
  validates_uniqueness_of :url
end
