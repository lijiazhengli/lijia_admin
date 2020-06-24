class Page < ApplicationRecord
  validates_uniqueness_of :url
end
