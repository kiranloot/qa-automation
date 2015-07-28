ActiveAdmin.register_page "Gizmo Surveys" do
  menu parent: "More", :if => proc{ !GlobalConstants::BLOCK_ADMIN_USERS }

  content do
    unless GlobalConstants::BLOCK_ADMIN_USERS
      survey = Gizmo::Survey.first(:id => ENV['GIZMO_SURVEY_ID'])
      statistics = Gizmo::Statistics.first(:id => ENV['GIZMO_SURVEY_ID'])

      render partial: 'show_survey_results', locals: { survey: survey,  statistics: statistics }
    end
  end

end
