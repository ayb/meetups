class Role < ApplicationRecord
  has_many :memberships
  validates :name, presence: true, uniqueness: true
end
