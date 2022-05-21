# frozen_string_literal: true

##
# Project class
#
class Project < ApplicationRecord
  #
  # Virtual Attributes
  #

  attr_accessor :owner

  #
  # Associations
  #

  has_many :categories, dependent: :destroy
  has_many :projects_users
  has_many :users, through: :projects_users

  #
  # Validations
  #

  validates :name, presence: true, allow_blank: false
  validate :owner_valid?

  #
  # Lifecycles
  #

  before_validation :set_owner, on: :create

  ##
  # Returns current user Role
  #
  def user_role(user)
    return nil if user.blank?

    projects_users.where(user: user).first&.role
  end

  private

  ##
  # Check if there is exactly ONE owner in the project
  #
  def owner_valid?
    if projects_users.count { |project_user| project_user.role == 'owner' } != 1
      errors.add(:base, :must_have_one_owner)
      throw :abort
    end
    true
  end

  ##
  # Set the current user as the project owner
  #
  def set_owner
    projects_users.build(user: owner, role: 'owner')
    self
  end
end
