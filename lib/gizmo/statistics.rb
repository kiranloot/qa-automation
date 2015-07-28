module Gizmo
  # Overwrites custom API call for a extended one
  class Statistics
    include SurveyGizmo::Resource

    attribute :statistics, Array

    route '/survey/:id/surveystatistic', via: [:get, :update, :delete]
    route '/survey', via: :create

    collection :statistics

    # @see SurveyGizmo::Resource#to_param_options
    def to_param_options
      { id: self.id }
    end
  end
end


