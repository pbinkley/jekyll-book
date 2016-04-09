require 'fileutils'
Jekyll::Hooks.register :site, :post_write do |site|
	FileUtils.copy_entry('downloads', '_site/')
end