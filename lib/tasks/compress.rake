namespace :compress do
	desc 'Compress code using the Yahoo UI compressor'
	task :yahoo_js, [:version] do |t, args|
			if (args[:version])
				root = "#{RAILS_ROOT}/app/views/api/js/v#{args.version}"
				# Create the compressed directory if it does not already exist.
				unless File.exists?(root + '_compressed'): Dir.mkdir(root + '_compressed') end
				files = Dir.new(root).entries
				files.each do | file |
					unless (File.directory?(root + '/' + file)) or (file.slice(-1, 1) == '~')
						puts file
						`java -jar /share/goroam/server_config/local_config/yuicompressor-2.2.5/build/yuicompressor-2.2.5.jar --type js -o #{root}_compressed/#{file} #{root}/#{file}`
					end
				end
			else
				puts 'Usage: rake compress:yahoo_js[:version]'
			end
	end
end
