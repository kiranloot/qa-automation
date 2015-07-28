require 'carmen'

Carmen.append_data_path(File.join(Rails.root, 'config', 'carmen'))
Carmen.i18n_backend.load_path << File.join(Rails.root, 'config', 'carmen', 'locales.yml')
