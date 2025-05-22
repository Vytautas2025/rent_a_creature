class Creature < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy

  include PgSearch::Model

  pg_search_scope :search_by_name_and_description,
  against: [ :name, :description ],
  using: {
    tsearch: { prefix: true } 
  }

end
