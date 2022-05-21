# frozen_string_literal: true

##
# Category Serializer
#
class CategorySerializer
  include JSONAPI::Serializer
  attributes :name, :project_id, :default_category, :position
end
