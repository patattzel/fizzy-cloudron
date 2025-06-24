class Search::Result < ApplicationRecord
  belongs_to :creator, class_name: "User"

  def source
    self[:source]&.inquiry
  end

  def readonly?
    true
  end
end
