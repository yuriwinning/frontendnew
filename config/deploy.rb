lock '3.4.0'

set :application, 'radium-front'
set :repo_url, 'git@github.com:radiumsoftware/frontend.git'

set :deploy_to, '/var/www/radium-front/'

set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}

set :keep_releases, 5
set :ssh_options, { forward_agent: true }

set :rvm_ruby_version, '2.1.2@radium-frontend'

set :puma_preload_app, true
set :puma_init_active_record, true

desc "Compile Iridium"
task :compile_iridium do
  on roles(:all) do |host|
    within fetch(:release_path) do
      execute "cd #{fetch(:release_path)} && API_HOST=#{fetch(:api_host)} INTERCOM_APP_ID=#{fetch(:intercom_app_id)} ~/.rvm/bin/rvm #{fetch(:rvm_ruby_version)} do bundle exec iridium compile"

      # Iridium deltes previously symlinked dirs inside tmp! Create links again.
      %w{tmp/pids tmp/cache tmp/sockets}.each do |dir|
        execute :ln, "-fs #{fetch(:deploy_to)}/shared/#{dir} #{fetch(:release_path)}/#{dir}"
      end
    end
  end
end

after 'deploy:updated', 'compile_iridium'