# frozen_string_literal: true

##
# Project User Serializer
#
class ProjectUserSerializer
  include JSONAPI::Serializer
  attributes :project_id, :user_id
end
