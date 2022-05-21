# frozen_string_literal: true

##
# Users Controller
#
class UsersController < ApiController
  before_action :set_user, only: %i[destroy]
  skip_after_action :update_auth_header, only: %i[destroy]

  ##
  # Destroy a User and all his data
  #
  def destroy
    authorize @user
    @user.destroy
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
