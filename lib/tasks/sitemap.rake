namespace :sitemap do
	desc 'Create XML sitemaps for the site'
	task :generate => :environment do
		list = []
		list << { :url => '/', :lastmod => Time.now }
		list.concat(generate_from_general_pages)
		list.concat(generate_from_public)

		# Create the individual sitemap XML documents.
		File.open("#{RAILS_ROOT}/public/sitemap/static.xml", 'w') do |file|
			file.write generate_sitemap(list, 'http://geo.goro.am')
		end

		# Create the overall sitemap list document.
		File.open("#{RAILS_ROOT}/public/sitemap.xml", 'w') do |file|
			file.write generate_sitemap_index(['static.xml'], 'http://geo.goro.am')
		end
	end

	# Find all pages in the "general_page" views directory.
	def generate_from_general_pages
		list = []
		# Only search for files that end in ".html.erb" or only ".erb".
		re = /(\.html\.erb|^[^\.]+\.erb|\.html)$/i
		files = Dir.new("#{RAILS_ROOT}/app/views/general_page").entries
		files.each do |filename|
			ext = re.match(filename)
			unless (ext == nil): list << { :url => '/' + filename.gsub(ext[0], ''), :lastmod => File.mtime("#{RAILS_ROOT}/app/views/general_page/#{filename}") } end
		end
		list
	end

	# Find all static pages in the /public directory.  This can be called recursively.
	def generate_from_public(root_dir = '')
		list = []
		files = Dir.new("#{RAILS_ROOT}/public#{root_dir}").entries
		files.each do |filename|
			# Ignore certain folders and files.
			unless ((filename == '.') or (filename == '..') or (filename.slice(-1, 1) == '~'))
				# For directories, drill down.
				if (File.directory?("#{RAILS_ROOT}/public/#{filename}"))
					folder = ''
					if (root_dir == '')
						# From the root /public folder, only drill down on certain folders.
						folder = case filename.downcase
							when '.svn', 'javascripts', 'images', 'sitemap', 'stylesheets'
								''
							else filename
						end
					elsif (filename != '.svn')
						folder = filename
					end
					unless (folder == ''): list.concat(generate_from_public(root_dir + '/' + folder)) end
				elsif (root_dir != '')
					url_filename = ''
					unless /^index(\.html|\.htm)?$/i.match(filename): url_filename = '/' + filename end
					list << { :url => root_dir + url_filename, :lastmod => File.mtime("#{RAILS_ROOT}/public/#{root_dir}/#{filename}") }
				end
			end
		end
		list
	end

  def generate_sitemap(path_ar = [], base_url = '', priority = 0.5)
    xml_str = ""
    xml = Builder::XmlMarkup.new(:target => xml_str)
    xml.instruct!
    xml.urlset(:xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9') {
      path_ar.each do |path|
        xml.url {
      	  xml.loc(base_url + path[:url])
      	  xml.lastmod(path[:lastmod].strftime("%Y-%m-%d"))
      	  xml.changefreq('weekly')
					xml.priority(priority)
        }
      end
    }
    xml_str
	end

	# Create a sitemap index document
  def generate_sitemap_index(sitemaps = [], base_url = '')
    xml_str = ""
    xml = Builder::XmlMarkup.new(:target => xml_str)
    xml.instruct!
    xml.sitemapindex(:xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9', "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xsi:schemaLocation" => "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd") {
      sitemaps.each do |site|
        xml.sitemap {
      	  xml.loc(base_url + "/sitemap/#{site}")
      	  xml.lastmod(Time.now.strftime('%Y-%m-%d'))
   			}
      end
    }
    xml_str
  end
end


