class Game < ApplicationRecord
  normalizes :name, with: ->(e) { e.strip.downcase.gsub(/\s+/, " ") }

  validates :name, presence: true, uniqueness: true

  def human_name
    name.titleize
  end
end
