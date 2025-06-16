class User < ApplicationRecord
  has_secure_password

  normalizes :email, with: ->(e) { e.strip.downcase.gsub(/\s+/, "") }

  validates :email, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP
  validates :password, presence: true, length: {minimum: 6}

  has_many :game_events
  has_many :games, -> { distinct }, through: :game_events
end
