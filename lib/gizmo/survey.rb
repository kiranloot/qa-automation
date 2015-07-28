module Gizmo
  # Overwrites custom API call for a extended one
  class Survey
   include SurveyGizmo::Resource
    # @macro [attach] virtus_attribute
    #   @return [$2]
    attribute :id,             Integer
    attribute :team,           Integer
    attribute :type,           String
    attribute :_subtype,       String
    attribute :status,         String
    attribute :forward_only,   Boolean
    attribute :title,          String
    attribute :internal_title, String
    attribute :title_ml,       Hash
    attribute :links,          Hash
    attribute :theme,          Integer
    attribute :blockby,        String
    attribute :languages,      Array
    attribute :statistics,     Array
    attribute :created_on,     DateTime
    attribute :modified_on,    DateTime
    attribute :copy,           Boolean
    attribute :pages,          Array

    route '/survey/:id', via: [:get, :update, :delete]
    route '/survey',     via: :create

    # @macro collection
    collection :pages

    # @see SurveyGizmo::Resource#to_param_options
    def to_param_options
      { id: self.id }
    end
  end
end

