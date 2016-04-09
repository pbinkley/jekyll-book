require 'fileutils'
Jekyll::Hooks.register :site, :post_write do |site|
	FileUtils.cp_r('downloads', '_site/')
end
