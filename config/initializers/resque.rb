require 'resque_scheduler/server'
# require 'resque/status_server'

# Load redis configuration
redis_config = YAML.load_file(Rails.root.join('config', 'redis.yml'))[Rails.env]
Resque.redis = Redis.new(
  host:     redis_config['host'],
  port:     redis_config['port'],
  password: redis_config['password'])
Resque.redis.namespace = 'phone_contacts'

# Load schedule configuration
# Resque.schedule = YAML.load_file(Rails.root.join('config', 'resque_schedules.yml'))
