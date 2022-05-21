# frozen_string_literal: true

##
# Project Serializer
#
class ProjectSerializer
  include JSONAPI::Serializer
  attributes :name
  attribute :user_role do |object, params|
    object.user_role(params[:user])
  end
end
