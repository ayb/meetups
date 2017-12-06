class Membership < ApplicationRecord
  belongs_to :member, class_name: "User", foreign_key: :user_id
  belongs_to :group
  belongs_to :role

  validates :user_id, presence: true, uniqueness: { scope: :group_id }
  validates :group_id, presence: true, uniqueness: { scope: :user_id }
  validates :role_id, presence: true
  before_save :enforce_latest_president

  # add scope :organizers, :presenters, :participants
  %w(Organizer Presenter Participant).each do |role|
    scope "#{role.downcase}s".to_sym, -> {
      joins(:role).where(roles: { name: role }).references(:roles)
    }
  end

  def self.reassign_other_presidents(group_id, except=nil)
    president = Role.find_by_name("President")
    organizer = Role.find_by_name("Organizer")
    records = Membership.where(group_id: group_id, role_id: president)
    if except.present?
      records.where.not(id: except).update_all(role_id: organizer)
    else
      records.update_all(role_id: organizer)
    end
  end

  def enforce_latest_president
    return unless role.name.eql?("President")
    presidents = Membership.where(group_id: group_id, role_id: role_id)
    if new_record?
      self.class.reassign_other_presidents(group_id) if presidents.size > 0
    else
      self.class.reassign_other_presidents(group_id, id) if presidents.size > 0 && !presidents.pluck(:id).include?(id)
    end
  end

end
