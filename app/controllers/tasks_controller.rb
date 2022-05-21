# frozen_string_literal: true

##
# Tasks Controller
#
class TasksController < ApiController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :set_project, only: %i[index search]

  ##
  # List all Tasks
  #
  def index
    @tasks = Task.where(category: @project.categories)
    authorize @tasks
    render json: TaskSerializer.new(@tasks).serializable_hash
  end

  ##
  # Show a Task by ID
  #
  def show
    authorize @task
    render json: TaskSerializer.new(@task).serializable_hash
  end

  ##
  # Create a Task
  #
  def create
    @task = Task.new(task_params)
    authorize @task
    if @task.save
      render json: TaskSerializer.new(@task).serializable_hash
    else
      bad_request(@task.errors.full_messages)
    end
  end

  ##
  # Update a Task
  #
  def update
    @task.category_id = params[:category_id] if params[:category_id].present?
    authorize @task
    if @task.update(task_params)
      render json: TaskSerializer.new(@task).serializable_hash
    else
      bad_request(@task.errors.full_messages)
    end
  end

  ##
  # Destroy a Task
  #
  def destroy
    authorize @task
    @task.destroy
  end

  ##
  # Find a Task by a search
  #
  def search
    @tasks = Task.where(category: @project.categories).search(search_params)
    authorize @tasks
    render json: TaskSerializer.new(@tasks).serializable_hash
  end

  private

  ##
  # Overwrites the Pundit Authorize function for the policy validation
  #
  def authorize(resource)
    unless TaskPolicy.new(current_user, resource, @project).send("#{action_name}?")
      raise Pundit::NotAuthorizedError
    end
  end

  ##
  # Set the parameters for search
  #
  def search_params
    params.fetch(:search).permit(:name)
  end

  ##
  # Set Task
  #
  def set_task
    @task = Task.find(params[:id])
  end

  ##
  # Set Project
  #
  def set_project
    @project = Project.find(params[:project_id])
  end

  ##
  # Set Task params
  #
  def task_params
    params.require(:task).permit(:name, :description, :start_date, :due_date, :status, :category_id, :user_id)
  end
end
