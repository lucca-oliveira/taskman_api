# frozen_string_literal: true

##
# API Controller
#
class ApiController < ApplicationController
  before_action :authenticate_user!
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit::Authorization
  respond_to :json

  ##
  # If a record fails validation or otherwise cannot be created, fail with
  # a bad request (400) HTTP Status Code.
  #
  def bad_request(errors = nil, code = nil)
    @errors = if errors.present?
                errors.flatten.map do |error|
                  error.present? && error.respond_to?(:slice) ? error.slice(0, 1).upcase << (error.slice(1..-1) || '') : error
                end.uniq
              else
                [I18n.t('api.errors.bad_request')]
              end
    render json: { errors: @errors }, status: :bad_request
  end

  ##
  # Provide unauthorized JSON response if user is not permitted
  # to conduct certain actions
  #
  rescue_from Pundit::NotAuthorizedError do |exception|
    begin
      message = JSON.parse(exception.message)
    rescue JSON::ParserError
      message = []
    end
    forbidden(message || [])
  end

  ##
  # Quick response for authentication failures.
  #
  def forbidden(*errors)
    @errors = (errors.flatten.present? ? errors : [I18n.t('api.errors.forbidden')]).flatten.uniq
    render json: { errors: @errors }, status: :forbidden
  end
end
