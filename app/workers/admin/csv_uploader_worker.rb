module Admin
  class CsvUploaderWorker
    include Sidekiq::Worker

    def perform
      uploader = CsvUploader.new
      uploader.upload
    end
  end
end
