# frozen_string_literal: true

##
# Category class
#
class Category < ApplicationRecord
  #
  # Associations
  #

  belongs_to :project
  has_many :tasks

  #
  # Validations
  #

  validates :name, presence: true, allow_blank: false, uniqueness: { scope: %i[project] }

  #
  # Lifecycle
  #

  after_destroy :update_tasks
  before_create :set_position
  before_save :set_default_category
  before_update :reorder_positions_update
  after_save :set_default_category_as_false
  after_destroy :reorder_positions_delete

  private

  ##
  # Set all the category of all the tasks of the destroyed category as the default category
  #
  def update_tasks
    tasks&.update_all(category_id: Category.where(project_id: project_id, default_category: true).first.id)
  end

  ##
  # Reorder the Category Array positions
  #
  def reorder_positions(categories)
    categories.size.times do |position|
      categories[position].update_column(:position, position)
    end
  end

  ##
  # Reorder the Category positions in Project after an delete
  #
  def reorder_positions_delete
    categories = project.categories.order(position: :asc)
    reorder_positions(categories)
  end

  ##
  # Reorder the Category positions in Project after an update
  #
  def reorder_positions_update
    categories = project.categories.where.not(id: id).sort_by(&:position)
    categories.insert(position, self)
    reorder_positions(categories.compact)
  end

  ##
  # Set the create category as default if it's the first Project Category
  #
  def set_default_category
    return self if default_category

    self.default_category = true if project.categories.blank?
    self
  end

  ##
  # Set the other categories as false
  #
  def set_default_category_as_false
    return unless default_category

    project.categories.where.not(id: id).update_all(default_category: false)
  end

  ##
  # Set the Category position in Project
  #
  def set_position
    self.position = project.categories.count
    self
  end
end
