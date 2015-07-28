module PostponementServiceInjector
  def postponement_service_klass
    Rails.configuration.postponement_service
  end
end
