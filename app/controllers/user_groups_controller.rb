class UserGroupsController < ApplicationController
  before_action :set_user_group, only: [:show, :edit, :update, :destroy, :join, :leave]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy, :join, :leave]

  def index
    query        = params[:q]
    @user_groups = if query.present?
                     UserGroup.search_for(query)
                   else
                     UserGroup.order('created_at').reverse_order
                   end

    respond_to do |format|
      format.html { render :index }
      format.rss { render layout: nil }
    end
  end

  def show
    @page_title = "#{@user_group.name} on User-Group List" if @user_group && @user_group.name
    memberships
  end

  def new
    @user_group = current_user.user_groups_registered.build
  end

  def edit
  end

  def create
    @user_group = current_user.user_groups_registered.build(user_group_params)

    respond_to do |format|
      if @user_group.save
        format.html { redirect_to @user_group, notice: 'User-Group was successfully created.' }
        format.json { render :show, status: :created, location: @user_group }
      else
        format.html { render :new }
        format.json { render json: @user_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    unless current_user.admin? || @user_group.registered_by.id == current_user.id
      fail 'You may only update User-Groups that you registered.'
    end

    # TODO Extract the tag parsing to a before_action
    # TODO Add validation rules around Tags. Maybe it should just be a model relationship?
    update_user_group_params          = user_group_params.dup
    update_user_group_params[:topics] = parse_topics_list(update_user_group_params[:topics])

    respond_to do |format|
      if @user_group.update(update_user_group_params)
        format.html { redirect_to @user_group, notice: 'User-Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_group }
      else
        format.html { render :edit }
        format.json { render json: @user_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    unless current_user.admin? || @user_group.registered_by.id == current_user.id
      fail 'You may only destroy User-Groups that you registered.'
    end

    @user_group.destroy
    respond_to do |format|
      format.html { redirect_to user_groups_url, notice: 'User-Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def join
    # 0 == member
    @ugm = UserGroupMembership.create_with(relationship: 0).find_or_create_by(user_id: current_user.id, user_group_id: @user_group.id)
  end

  def leave
    UserGroupMembership.find_by(user_id: current_user.id, user_group_id: @user_group.id, relationship: 0).destroy
  end

  def memberships
    @ugms = UserGroupMembership.where(user_group: @user_group)
  end

  private

  def parse_topics_list(topics)
    topics.to_s.split(',').map(&:downcase).map(&:strip).compact.sort.reject { |t| t.blank? }.uniq
  end

  def set_user_group
    @user_group = UserGroup.friendly.find(params[:id] || params[:user_group_id])
  end

  def user_group_params
    if current_user.admin?
      params.require(:user_group).permit!
    else
      params.require(:user_group).permit(
        :city,
        :country,
        :description,
        :homepage,
        :name,
        :state_province,
        :twitter,
        :topics,
        :logo
      )
    end
  end
end
