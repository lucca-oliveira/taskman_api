# frozen_string_literal: true

##
# Projects x Users relationship Controller
#
class ProjectsUsersController < ApiController
  before_action :set_project_user, only: %i[destroy]

  ##
  # Associate a User to a Project
  #
  def create
    @project_user = ProjectUser.new(project_user_params)
    authorize @project_user
    if @project_user.save
      render json: ProjectUserSerializer.new(@project_user).serializable_hash.to_json
    else
      bad_request(@project_user.errors.full_messages)
    end
  end

  ##
  # Remove a User from a Project
  #
  def destroy
    authorize @project_user
    @project_user.destroy
  end

  private

  ##
  # Set ProjectUser params
  #
  def project_user_params
    params.require(:project_user).permit(:project_id, :user_id, :role)
  end

  ##
  # Set ProjectUser Relationship
  #
  def set_project_user
    @project_user = ProjectUser.find(params[:id])
  end
end
