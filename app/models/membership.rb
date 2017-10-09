class Membership < ApplicationRecord
  belongs_to :member, class_name: "User", foreign_key: :user_id
  belongs_to :group
  belongs_to :role

  validates :user_id, presence: true, uniqueness: { scope: :group_id }
  validates :group_id, presence: true, uniqueness: { scope: :user_id }
  validates :role_id, presence: true

  # add scope :organizers, :presenters, :participants
  %w(Organizer Presenter Participant).each do |role|
    scope "#{role.downcase}s".to_sym, -> {
      joins(:role).where(roles: { name: role }).references(:roles)
    }
  end
end
