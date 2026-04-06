# threads
threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

# порт
port ENV.fetch("PORT") { 3000 }

# среда
environment ENV.fetch("RAILS_ENV") { "development" }

# один воркер, т.к. Render выделяет один контейнер
workers ENV.fetch("WEB_CONCURRENCY") { 0 }

# перезапуск через rails
plugin :tmp_restart

# solid_queue если нужно
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]

# pid файл
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]