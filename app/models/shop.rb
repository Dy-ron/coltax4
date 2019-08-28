class Shop < ApplicationRecord
  belongs_to :city
  has_many :users

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
end
