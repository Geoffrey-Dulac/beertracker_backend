class Beer < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :brewer
  has_many :user_beers
end
