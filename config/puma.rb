# config/puma.rb

# Потоков на воркер
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 3 }
threads threads_count, threads_count

# Порт для Render или локально 3000
port ENV.fetch("PORT") { 3000 }

# Запуск в single-mode, если WEB_CONCURRENCY не задан
workers ENV.fetch("WEB_CONCURRENCY") { 0 }  # 0 = single-mode

preload_app!  # улучшает перезапуск и память

# Разрешаем restart через bin/rails restart
plugin :tmp_restart

# Solid Queue supervisor, если нужно
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]

# PID файл, если указан
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

# Логи для деплоя
on_worker_boot do
  puts "Worker #{Process.pid} booted"
  # Для ActiveRecord, если используется
  if defined?(ActiveRecord)
    ActiveRecord::Base.connection_pool.disconnect!
    ActiveRecord::Base.establish_connection
  end
end