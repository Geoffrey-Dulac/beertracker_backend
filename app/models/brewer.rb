class Brewer < ApplicationRecord
    validates :name, presence: true
    validates :city, presence: true

    has_many :beers
end
