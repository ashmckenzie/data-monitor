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

  w.keepalive

  w.transition(:up, :start) do |on|
    on.condition(:process_exits) do |c|
      c.notify = 'admin'
    end
  end
end
