# frozen_string_literal: true

##
# This class manage all scopes
#
class ApplicationQuery
  ##
  # Retrieve records by multisearch and ILIKE query
  #
  def self.search_with_like(searchable_class, term, field)
    return searchable_class.all if term.blank?

    searchable_class.where("#{field} ILIKE ?", "%#{term}%").order(field => :asc)
  end
end
