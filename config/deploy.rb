set :application, "geo.goro.am"
set :launch_ip, "174.129.235.147"
ssh_options[:keys] = ["/home/ryan/Documents/id-linux-keypair"]
set :repository, 
"svn+ssh://svn@goro.am/vol/svn/goro.am/geo/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :scm_username, "svn"
#set :scm_password, "5uBv3r5i0N"
set :scm_checkout, "export"

set :user, "root"
default_run_options[:pty] = true
set :use_sudo, false
set :rails_env, "migration"

# Note that this IP address may change for future deployments.
role :app, "#{launch_ip}"
role :web, "#{launch_ip}"
role :db,  "#{launch_ip}", :primary => true

namespace :deploy do
	desc "Restart the Mongrel cluster"
	task :restart, :roles => :app do
		stop
		start
	end

	# Other startup methods (memcached, backgroundrb, etc) should be added here.
	desc "Start the Mongrel cluster and Nginx"
	task :start, :roles => :app do
		start_mongrel
		start_nginx
	end

	# Other stop methods should be added here.
	desc "Stop the Mongrel cluster and Nginx"
	task :stop, :roles => :app do
		stop_mongrel
		stop_nginx
	end

	desc "Start Mongrel"
	task :start_mongrel, :roles => :app do
		begin
			run "/etc/init.d/mongrel_cluster start"
		rescue RuntimeError => e
			puts e
			puts "Mongrel appears to be on already."
		end
	end

	desc "Stop Mongrel"
	task :stop_mongrel, :roles => :app do
		begin
			run "/etc/init.d/mongrel_cluster stop"
		rescue RuntimeError => e
			puts e
			puts "Mongrel appears to be off already."
		end
	end

	desc "Start nginx"
	task :start_nginx, :roles => :app do
		begin
			run "/etc/init.d/nginx start"
		rescue RuntimeError => e
			puts e
			puts "Nginx appears to be on already."
		end
	end

	desc "Stop Nginx"
	task :stop_nginx, :roles => :app do
		begin
			run "/etc/init.d/nginx stop"
		rescue RuntimeError => e
			puts e
			puts "Nginx appears to be off already."
		end
	end
end

task :after_migrate do
	require 'active_record/fixtures'
	Dir.glob("#{deploy_to}/current/db/fixtures/*.yml").each do |file|
		Fixtures.create_fixtures('db/fixtures', File.basename(file, '.*'))
	end
end

task :before_migrate do
  `rake db:fixtures:dump_constants`
  `svn commit db/fixtures/constants.yml -m ""`
  `scp -i ~/Documents/id-linux-keypair root@#{launch_ip}:#{release_path}/db/fixtures db/fixtures/constants.yml`
end

task :after_symlink, :roles => :app do
	run "chown -hR root:www-data #{deploy_to}"
end


#before "deploy:migrate", :export_constants
#after "deploy:migrate", :import_constants

