class App < ApplicationRecord
  # Table name
  self.table_name = 'core.App'
  
  # Primary key
  self.primary_key = :appID

  # Associations
  belongs_to :Author, foreign_key: 'authorID'
  has_many :Review

  # Validations
  validates :name, presence: true
  validates :pageURL, uniqueness: true
  validates :pageURL, presence: true
  validates :byteSize, presence: true
  validates :iconURL, presence: true
  validates :colorBg, presence: true
  validates :colorTheme, presence: true
  validates :promoted, presence: true
end
