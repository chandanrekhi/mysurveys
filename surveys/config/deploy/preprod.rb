# Must be inside the RBS App Bank VPN
server "10.24.7.199", :app, :web, :db, :primary => true

set :rails_env, "preprod"

set :branch, "preprod"

set :deploy_to, "/var/www/#{application}-preprod"

set :thin_config, "/etc/thin/Surveys.yml"