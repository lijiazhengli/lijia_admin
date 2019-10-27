class Teacher < ApplicationRecord
  class << self
    def current_teacher_hash
      Teacher.where(active: true).pluck(:id, :name).to_h
    end
  end
end
