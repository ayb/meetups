class Group < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :members, class_name: "User", through: :memberships
  has_many :roles, through: :memberships

  validates :name, presence: true, uniqueness: true

  def organizer_names
    memberships.organizers.map { |org| org.member.name }
  end

end
