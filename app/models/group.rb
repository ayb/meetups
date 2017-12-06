class Group < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :members, class_name: "User", through: :memberships
  has_many :roles, through: :memberships

  # filter on the has_many to get the :through result we want (i.e. organizers)
  has_many :organizer_memberships, -> { joins(:role).where("roles.name = ?", 'Organizer') },
    class_name: "Membership"
  has_many :organizers, through: :organizer_memberships, source: :member do
    def names
      self.map(&:name)
    end
  end

  validates :name, presence: true, uniqueness: true

  def organizer_names
    memberships.organizers.map { |org| org.member.name }
  end

end
