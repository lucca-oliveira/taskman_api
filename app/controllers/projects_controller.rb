# frozen_string_literal: true

##
# Projects Controller
#
class ProjectsController < ApiController
  before_action :set_project, only: %i[show edit update destroy]

  ##
  # List all Projects
  #
  def index
    @projects = current_user.projects
    authorize @projects
    render json: ProjectSerializer.new(@projects, params: { user: current_user }).serializable_hash
  end

  ##
  # Show a Project by ID
  #
  def show
    authorize @project
    render json: ProjectSerializer.new(@project, params: { user: current_user }).serializable_hash
  end

  ##
  # Create a Project
  #
  def create
    @project = Project.new(project_params)
    @project.owner = current_user
    authorize @project
    if @project.save
      render json: ProjectSerializer.new(@project, params: { user: current_user }).serializable_hash
    else
      bad_request(@project.errors.full_messages)
    end
  end

  ##
  # Update a Project
  #
  def update
    authorize @project
    if @project.update(project_params)
      render json: ProjectSerializer.new(@project, params: { user: current_user }).serializable_hash
    else
      bad_request(@project.errors.full_messages)
    end
  end

  ##
  # Destroy a Project
  #
  def destroy
    authorize @project
    @project.destroy
  end

  private

  ##
  # Set Project params
  #
  def project_params
    params.require(:project).permit(:name)
  end

  ##
  # Set Project
  #
  def set_project
    @project = Project.find(params[:id])
  end
end
