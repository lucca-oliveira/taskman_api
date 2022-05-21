# frozen_string_literal: true

##
# ProjectUser Policy
#
class ProjectUserPolicy < ApplicationPolicy
  attr_reader :user, :project_user

  def initialize(user, project_user)
    super
    @user = user
    @project_user = project_user
  end
  #
  # Actions
  #

  def create?
    user_role_is_inferior_that_current_user?
  end

  def destroy?
    create?
  end

  private

  ##
  # Check if current user role is superior than the role of user being added or removed
  #
  def user_role_is_inferior_that_current_user?
    user_role = user.projects_users.where(project: project_user.project).first
    return false if user_role.blank?

    user_role.role_weight > project_user.role_weight
  end
end
