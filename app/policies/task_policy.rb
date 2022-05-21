# frozen_string_literal: true

##
# Task Policy
#
class TaskPolicy < ApplicationPolicy
  #
  # Virtual attributes
  #

  attr_accessor :old_category

  attr_reader :user, :task, :project

  def initialize(user, task, project = nil)
    super(user, task)
    @user = user
    @task = task
    @project = project || task&.category&.project
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

  def show?
    index?
  end

  def destroy?
    create?
  end

  def update?
    user_is_owner_or_maintainer? && category_belongs_to_project?
  end

  def search?
    index?
  end

  private

  ##
  # Check if the category belongs to the same Project
  #
  def category_belongs_to_project?
    return true if task.category.id_was.blank? || !task.category_id_changed?

    self.old_category = Category.find(task.category_id_was)
    task.category.project_id.eql?(old_category&.project_id)
  end

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
    user.projects_users.where(project: project, role: %w[owner maintainer]).present?
  end
end
