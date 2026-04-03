namespace :solid_queue do
  desc "Compatibility alias for starting Solid Queue workers"
  task work: :environment do
    SolidQueue::Supervisor.start(mode: :async, only_work: true, skip_recurring: true)
  end
end
