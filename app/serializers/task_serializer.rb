# frozen_string_literal: true

##
# Project Serializer
#
class TaskSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :start_date, :due_date, :status, :category_id, :user_id
end
