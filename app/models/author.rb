# frozen_string_literal: true

class Author < ApplicationRecord
  # Table name
  self.table_name = 'core.Author'

  # Primary key
  self.primary_key = :authorID

  # Associations
  has_many :App

  # Validations
  validates :name, presence: true
end
