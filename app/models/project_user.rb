# frozen_string_literal: true

##
# User x Project class
#
class ProjectUser < ApplicationRecord
  #
  # Constants
  #
  ROLE_WEIGHTS = { 'developer' => 1, 'maintainer' => 2, 'owner' => 3 }.freeze

  #
  # Associations
  #

  belongs_to :user
  belongs_to :project

  #
  # Enumerators
  #

  enum role: %i[developer maintainer owner]

  #
  # Validations
  #

  validates :role, presence: true, allow_blank: false
  validates :role, uniqueness: { scope: %i[project] }, if: :owner?
  validate :tuple_project_user_valid?

  ##
  # Check the weight of user's role in a Project
  #
  def role_weight
    ROLE_WEIGHTS[role]
  end

  private

  ##
  # Verify the uniqueness of a Project x User relationship
  #
  def tuple_project_user_valid?
    if ProjectUser.where(user_id: user.id, project_id: project.id).present?
      errors.add(:base, :project_user_relation_must_be_unique)
      throw :abort
    end
    true
  end
end
