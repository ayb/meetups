class User < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships, as: :member
  has_many :roles, through: :memberships

  validates :first_name, presence: true, uniqueness: { scope: :last_name }
  validates :last_name, presence: true, uniqueness: { scope: :first_name }

  def name
    "#{last_name}, #{first_name}"
  end

end
