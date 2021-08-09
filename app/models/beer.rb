class Beer < ApplicationRecord
  belongs_to :brewer
  has_many :user_beers
end
