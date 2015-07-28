module GizmoHelper
  def gizmo_is_question?(question)
    question.type == 'instructions' ? true : false
  end

  def gizmo_get_question_statistics(question, statistics)
    current_question = nil
    statistics.each do |s|
      current_question = s if s['id'] == "[question(#{question.id})]"
    end
    current_question
  end
end
