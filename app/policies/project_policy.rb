# frozen_string_literal: true

##
# Project Policy
#
class ProjectPolicy < ApplicationPolicy
  attr_reader :user, :project

  def initialize(user, project)
    super
    @user = user
    @project = project
  end

  #
  # Actions
  #

  def index?
    true
  end

  def create?
    current_user_is_owner?
  end

  def show?
    user_belongs_to_project?
  end

  def destroy?
    user_is_owner?
  end

  def update?
    show?
  end

  private

  def current_user_is_owner?
    user.id == project.owner.id
  end

  def user_is_owner?
    project.projects_users.where(role: 'owner').pluck(:user_id).include?(user.id)
  end

  def user_belongs_to_project?
    project.users.ids.include?(user.id)
  end

  def user_is_owner_or_maintainer?
    project.projects_users.where(user.id == :user_id).role == 'owner' || 'maintainer'
  end
end
