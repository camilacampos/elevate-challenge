module Types
  include Dry.Types()

  UpcasedString = Types::String.constructor(&:upcase)
  DowncasedStrippedString = Types::String.constructor { |s| s.strip.downcase.gsub(/\s+/, " ") }
end
