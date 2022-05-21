# frozen_string_literal: true

##
# User class
#
class User < ApplicationRecord
  include DeviseTokenAuth::Concerns::User

  #
  # Validations
  #

  devise :database_authenticatable, :registerable, :validatable

  #
  # Associations
  #

  has_many :projects_users
  has_many :projects, through: :projects_users
  has_many :tasks

  #
  # Lifecycle
  #

  before_validation :set_confirmed_at
  before_destroy :destroy_user_projects

  private

  ##
  # Destroy all the projects where the user are Owner
  #
  def destroy_user_projects
    Project.where(id: projects_users.where(role: 'owner').pluck(:project_id)).destroy_all
    projects_users.destroy_all
  end

  ##
  # Set user confirmed_at for Devise
  #
  def set_confirmed_at
    self.confirmed_at = Time.zone.now if confirmed_at.blank?
    self
  end
end
