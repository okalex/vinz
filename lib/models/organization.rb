class Organization < ActiveRecord::Base
  # Associations
  has_many :users
  has_many :consumers
  has_many :groups
  has_many :config_items

  # Validations
  validates :name, presence: true
end