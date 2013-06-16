require 'rake'

desc "Start the application"
task :start do
  start_application
end

def start_application
  stop_application if application_running

  system "truncate --size 0 thin.log" if File.exists?("thin.log")
  fail "Failed to start app" unless system "thin start -p 3000 -l thin.log -d"
  wait_until do
    application_running
  end
end

def stop_application
  system "kill -9 #{application_process_id}"
end

def application_running
  not `lsof -i tcp:3000 | grep LISTEN`.empty?
end

def application_process_id
  `lsof -i tcp:3000 | grep LISTEN`.split[1]
end

def wait_until timeout=60
  start_time = Time.now
  until Time.now > start_time + timeout
    return if yield
    sleep 0.5
  end
  raise "action took too long"
end