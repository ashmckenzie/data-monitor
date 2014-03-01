require 'yaml'

base = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
config_file = File.expand_path(File.join(base, '..', 'config.yml'))
c = YAML.load_file(config_file)

God.watch do |w|
  w.name      = 'data-monitor'
  w.uid       = 'ash'

  w.dir       = c['working_directory']
  w.log       = c['log_file']

  w.start     = %Q{bundle exec puma --port #{c['http_port']} -e #{c['environment']}}

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 30.seconds
      c.running = false
    end
  end

  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 3
      c.within = 5.minutes
      c.transition = :unmonitored
      c.retry_in = 5.minutes
      c.retry_times = 3
      c.retry_within = 10.minutes
      c.notify = 'notify-me'
    end
  end
end
