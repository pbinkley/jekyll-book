Jekyll::Hooks.register :site, :pre_render do |site|

	require 'slugify'

	# calculate git-style sha1 hashes for each file in list
	def makehashlist(files)
		fileswithhashes = {}
		files.each do |file|
			size = File.stat(file).size
			fileswithhashes[file] = Digest::SHA1.hexdigest( 'blob ' + size.to_s + '\0' + File.binread(file) )
		end
		return fileswithhashes
	end

	# load list of content and dependency files from previous run (to detect deletions/additions/changes)
	if File.file?(site.config["previousrun"])
		previousrun = YAML.load_file(site.config["previousrun"])
	else
		previousrun = {"content" => {}, "deps" => {}}
	end
	previouscontent = previousrun["content"]
	previousdeps = previousrun["deps"]

	# calculate slug, to be used as filename for download files
	slug = site.config["brand"].slugify

	dirContent = site.config["dircontent"]
	contentfiles = Dir[dirContent + "/*"].sort!
	
	dirDownloads = site.config["dirdownloads"]
	downloadfiles = Dir[dirDownloads + "/*"]

	# populate formats: hash of objects, one for each output format
	# and build union list of deps
	formats = {}
	alldeps = []
	site.config['downloads'].each do |key,value|
		formats[key] = {"deps" => value['deps'], "command" => (value['command'] % {dirDownloads: dirDownloads, slug: slug})}
		alldeps = (alldeps + value['deps']).uniq
	end

	alldepswithhashes = makehashlist(alldeps)
	fileswithhashes = makehashlist(contentfiles)

	# determine whether the content files have changed since last run
	contentchanged = (Set.new(previouscontent) != Set.new(fileswithhashes))

	# for each format, determine whether its dep files have changed since last run
	# delete files whose names don't match the current slug
	downloadfiles.each do |file|
		extension = File.extname(file).sub(/^\./) {""}
		basename = File.basename(file, ".*")
		if basename == slug && formats[extension] then
			# check hashes of dependencies of this format
			depchanged = false
			formats[extension]["deps"].each do |dep|
				depchanged = depchanged || (previousdeps[dep] != alldepswithhashes[dep])
			end
			formats[extension]["depchanged"] = depchanged
		else
			# it has a different slug or an unlisted extension, so must be from before a recent change to _config.yml
			puts "Deleting obsolete file " + file
			File.delete file
		end
	end

	# generate new files if the file for a format doesn't exist or is obsolete
	puts "Rendering downloads..."
	formats.each do |key, format|
		if contentchanged || format["depchanged"]
			print "Generating " + slug + "." + key + "... "
			result = system(format["command"])
			puts result ? "OK" : "Error"
		else
			puts slug + "." + key + " is OK"
		end
	end

	# write yaml file containing list of content and deps files from this run
	File.open(site.config["previousrun"], 'w') {|f| f.write ({"content" => fileswithhashes, "deps" => alldepswithhashes}).to_yaml }

	# generate list of downloads in site.data for use in current jekyll build operation
	downloadfiles = []
	Dir[dirDownloads + "/*"].sort.each do |file|
		extension = File.extname(file).sub(/^\./) {""}
		size = File.stat(file).size
		downloadfiles.push({"permalink" => file, "title" => extension.upcase + " (" + (size/1024).to_s + "K)"})	
	end
	site.data["downloads"] = downloadfiles
end
