# frozen_string_literal: true

##
# Category Policy
#
class CategoryPolicy < ApplicationPolicy
  attr_reader :category, :project, :user

  def initialize(user, category, project = nil)
    super(user, category)
    @category = category
    @project = project
    @user = user
  end

  #
  # Actions
  #

  def index?
    user_belongs_to_project?
  end

  def create?
    user_is_owner_or_maintainer?
  end

  def destroy?
    create?
  end

  def update?
    create?
  end

  private

  ##
  # Check if the user is associated to the Project
  #
  def user_belongs_to_project?
    project.users.ids.include?(user.id)
  end

  ##
  # Check if the user role is superior than Developer
  #
  def user_is_owner_or_maintainer?
    category&.project.present? && user.projects_users.where(project: category.project, role: %w[owner maintainer]).present?
  end
end
