Rails.application.config.to_prepare do
  ActiveJob::Base.queue_adapter = :solid_queue
end
