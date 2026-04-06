# config/puma.rb

threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

port ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "production" }

# На Render обязательно 0 воркеров, чтобы не падал кластер
workers 0

# Разрешаем перезапуск через bin/rails restart
plugin :tmp_restart

# Solid Queue, если нужно
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]

# PID файл (если нужно)
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]