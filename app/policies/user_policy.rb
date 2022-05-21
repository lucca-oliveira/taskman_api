# frozen_string_literal: true

##
# ProjectUser Policy
#
class UserPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    super
    @user = user
    @record = record
  end

  def destroy?
    current_user_eql_user?
  end

  private

  ##
  # Check if the current user is the user that is being deleted
  #
  def current_user_eql_user?
    user == record
  end
end
