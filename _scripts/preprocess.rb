#!/usr/bin/env ruby

@mainyamldone = false
@inyaml = false

ARGF.each_with_index do |line, idx|
	if /^---$/.match(line)
		print line if !@mainyamldone
		@inyaml = !@inyaml
		@mainyamldone = true if !@inyaml
	else
		print line unless (@inyaml && @mainyamldone)
	end
end
