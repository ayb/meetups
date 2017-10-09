require 'csv'
class UsersController < ApplicationController

  def create
    counter = 0
    starting_users = User.count
    starting_groups = Group.count
    csv_rows.each do |row|
      # allow row with or without headers
      next if row.first.downcase.strip.scan(/first|name/).present?

      first_name, last_name, group_name, role = row.map(&:strip)

      user = User.where(last_name: last_name).find_by_first_name(first_name)
      # add user if they don't already exist
      user ||= User.create!(first_name: first_name, last_name: last_name)

      group = Group.find_by_name(group_name)
      group ||= Group.create(name: group_name)

      membership = Membership.where(group_id: group.id).find_by_user_id(user.id)
      membership ||= Membership.new(group_id: group.id, user_id: user.id)
      membership.role_id = role_ids[role.downcase]
      membership.save!
      counter += 1
    end
    users_added = User.count - starting_users
    groups_added = Group.count - starting_groups
    flash[:notice] = "Processed #{counter} records. Added #{users_added} users and #{groups_added} groups."
    redirect_to groups_path
  end

  def csv_rows
    csv = params[:csv].read
    if csv.blank?
      flash[:error] = "Missing CSV file"
      return redirect_to groups_path
    end
    CSV.parse(csv, headers: false)
  end

  def role_ids
    @role_ids ||= Role.all.inject({}) { |h, r| h[r.name.downcase] = r.id; h }
  end

end
