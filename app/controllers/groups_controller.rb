class GroupsController < ApplicationController
  before_action :fetch_group, only: [:show, :edit, :update, :destroy]

  def index
    @groups = Group.all.includes(:organizers).order(name: :asc)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      flash[:notice] = "#{@group.name} saved."
      redirect_to action: :index
    else
      process_error_message
      render action: :new
    end
  end

  def show
    @memberships = @group.memberships.includes(:member, :role).
      order("users.last_name ASC, users.first_name ASC")
  end

  def edit
  end

  def update
    if @group.update_attributes(group_params)
      flash[:notice] = "#{@group.name} updated."
      redirect_to action: :index
    else
      process_error_message
      render action: :edit
    end
  end

  def destroy
    if @group.destroy
      flash[:notice] = "Group '#{@group.name}' has been deleted."
    else
      flash[:error] = "Unable to delete group '#{@group.name}'."
    end
    redirect_to action: :index
  end

  private
  def group_params
    params.require(:group).permit(:name)
  end

  def fetch_group
    @group = Group.find_by_id(params[:id])
    if @group.blank?
      flash[:error] = "Can't find group with that ID"
      return redirect_to action: :index
    end
  end

  def process_error_message
    return unless @group.present?
    message = group_params.keys.map {
      |field| "#{field} (#{@group.send(field)}) " + @group.errors.messages[field.to_sym].join(", ")
    }.join("<br/>")
    flash[:error] = message.html_safe
  end

end
