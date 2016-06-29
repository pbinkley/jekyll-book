#!/usr/bin/env ruby

require 'yaml'

@mainyamldone = false
@inyaml = false
@inbox = false
@yaml_block = ""
@main_yaml = nil
@section_yaml = nil

ARGF.each_with_index do |line, idx|

	# handle yaml blocks
	if /^---$/.match(line)
		# pass the main yaml block through
		print line if !@mainyamldone
		@inyaml = !@inyaml
		if @inyaml
			# we're starting a yaml block
			@yaml_block = line + "\n"
		else
			# we've reached end of yaml block
			@yaml_block = @yaml_block + line + "\n"
			if @main_yaml.nil?
				@main_yaml = YAML.load(@yaml_block)
			else
				@section_yaml = YAML.load(@yaml_block)
				# add section h2 header to output
				# note: can't get header_attributes to work, so have to create 
				# section anchor explicitly
				print "\n\n\\newpage\n"
				print "\\hypertarget{" + @section_yaml['id'].to_s + "}{}" 
				print "\n\n## " + @section_yaml['title'].to_s + "\n"

			end	
			@mainyamldone = true
		end 
	elsif @inyaml
		print line unless @mainyamldone
		@yaml_block = @yaml_block + line + "\n"
	else

		# replace internal links
		# match [text](./03-chapter2.html#s03n6) -> \hyperlink{s03n6}{text}
		line.gsub!(/\[([^\]]*)\]\(\.\/.+?\.html#(.+?)\)/, "\\hyperlink{\\2}{\\1}")
		# match [text](./03-chapter2.html) -> \hyperlink{s03}{text}
		line.gsub!(/\[([^\]]*)\]\(\.\/([0-9]*).+?\.html\)/, "\\hyperlink{s\\2}{\\1}")
		# match <span name="s00n3"></span> -> \hypertarget{s00n3}{}
		line.gsub!(/\<span name=['"]([A-Za-z0-9]*)['"]\>\<\/span\>/, "\\hypertarget{\\1}{} ")

		# handle catalog-card boxes
		if /<p class=\"right\".*/.match(line)
			print "\\rightline{\\texttt{" + /\>(.*)\</.match(line)[1] + "}}\n"
		elsif /^\<div class=\"box\"/.match(line)
			@inbox = true
			print "\\fboxsep=10pt\n\\fbox{\\begin{minipage}{30em}\n"
		elsif /^\<\/div\>/.match(line)
			@inbox = false
		    print "\\end{minipage}}\n"
		elsif @inbox
			# handle text lines in catalogue card box
			print "\\texttt{" + line.gsub(/\*(.+?)\*/,"\\underline{\\1}").sub(/^(\ )*/,"\\hspace*{0.5ex}") + "\\\\}\n"
		else
			print line
		end
	end
end
