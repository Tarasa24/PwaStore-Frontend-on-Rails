# frozen_string_literal: true

class Review < ApplicationRecord
  # Table name
  self.table_name = 'core.Review'

  # Primary key
  self.primary_key = :reviewID

  # Associations
  belongs_to :App, foreign_key: 'appID'

  # Validations
  validates :ip, presence: true
  validates :rating, presence: true
  validates :rating, numericality: { only_integer: true }
  validates :rating, numericality: { greater_than_or_equal_to: 0 }
  validates :rating, numericality: { less_than_or_equal_to: 5 }
end
