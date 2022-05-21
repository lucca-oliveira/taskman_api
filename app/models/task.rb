# frozen_string_literal: true

##
# Task class
#
class Task < ApplicationRecord
  #
  # Associations
  #

  belongs_to :category
  belongs_to :user, optional: true

  #
  # Enumerators
  #

  enum status: %i[pending expired done]

  #
  # Scopes
  #

  scope :by_name, ->(name) { TaskQuery.by_name(name) }
  scope :search, ->(params) { TaskQuery.search(params) }

  #
  # Validations
  #

  validates :name, :start_date, :due_date, :description, presence: true, allow_blank: false
  validates :user_id, presence: false, allow_blank: false
  validate :task_date_is_valid?
  validate :task_user_valid?
  validate :user_is_valid?

  ##
  # Check if the user have only done tasks
  #
  def user_tasks_done?
    user.tasks.where.not(status: 'done').present?
  end

  private

  ##
  # Check if the task date is greater than today and due date is greater than start date
  #
  def task_date_is_valid?
    if start_date < Date.today || due_date < start_date
      errors.add(:base, :invalid_date)
      throw :abort
    end
    true
  end

  ##
  # Check if the user can receive a new task
  #
  def task_user_valid?
    return true if user.present? && user_tasks_done?

    expired_tasks_valid? && date_valid?
  end

  ##
  # Check if the new task being added isn't causing any date conflict with pending tasks
  #
  def date_valid?
    tasks = user.tasks.where(status: 'pending').where.not(id: id)
    if tasks.where(start_date: start_date..due_date).or(tasks.where(due_date: start_date..due_date)).present?
      errors.add(:base, :date_conflict)
      throw :abort
    end
    true
  end

  ##
  # Check if the user don't have any expired tasks for
  #
  def expired_tasks_valid?
    if user.tasks.where(status: 'expired').present?
      errors.add(:base, :expired_tasks_founded)
      throw :abort
    end
    true
  end

  ##
  # Check if the user that is being assigned to the task belongs to the project
  #
  def user_is_valid?
    if category.project.users.ids.exclude?(user_id)
      errors.add(:base, :user_do_not_belongs_to_project)
      throw :abort
    end
    true
  end
end
