# frozen_string_literal: true

##
# This class manage Task scopes
#
class TaskQuery < ApplicationQuery
  ##
  # Search task based on the name
  #
  def self.by_name(term)
    search_with_like(Task, term, 'name')
  end

  def self.search(params = {})
    params = (params || {}).to_h&.deep_symbolize_keys
    scope = Task.order(name: :asc)
    scope.by_name(params[:name])
  end
end
