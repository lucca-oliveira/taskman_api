# frozen_string_literal: true

##
# Categories Controller
#
class CategoriesController < ApiController
  before_action :set_category, only: %i[update destroy]
  before_action :set_project, only: %i[index]

  ##
  # Create a Category
  #
  def create
    @category = Category.new(category_params)
    authorize @category
    if @category.save
      render json: CategorySerializer.new(@category).serializable_hash.to_json
    else
      bad_request(@category.errors.full_messages)
    end
  end

  ##
  # Delete a Category
  #
  def destroy
    authorize @category
    @category.destroy
  end

  ##
  # List all Categories in a Project
  #
  def index
    @categories = Category.where(project: @project)
    authorize @categories, @project
    render json: CategorySerializer.new(@categories).serializable_hash
  end

  ##
  # Update a Category
  #
  def update
    authorize @category
    if @category.update(category_params_update)
      render json: CategorySerializer.new(@category).serializable_hash
    else
      bad_request(@category.errors.full_messages)
    end
  end

  private

  ##
  # Overwrites the Pundit Authorize function for the policy validation
  #
  def authorize(resource, project = nil)
    unless CategoryPolicy.new(current_user, resource, project).send("#{action_name}?")
      raise Pundit::NotAuthorizedError
    end
  end

  ##
  # Set Category params
  #
  def category_params
    params.require(:category).permit(:name, :position, :project_id)
  end

  ##
  # Set Category params for update
  #
  def category_params_update
    params.require(:category).permit(:name, :position)
  end

  ##
  # Set Category
  #
  def set_category
    @category = Category.find(params[:id])
  end

  ##
  # Set Project
  #
  def set_project
    @project = Project.find(params[:project_id])
  end
end
