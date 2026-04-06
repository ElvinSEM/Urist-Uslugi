threads_count = ENV.fetch("RAILS_MAX_THREADS") { 3 }
threads threads_count, threads_count

workers ENV.fetch("WEB_CONCURRENCY") { 0 } # single-mode для Render

port ENV.fetch("PORT") { 3000 } # порт от Render

preload_app!

plugin :tmp_restart