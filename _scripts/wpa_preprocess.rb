#!/usr/bin/env ruby

@inyaml = false
@inbox = false

ARGF.each_with_index do |line, idx|
	if /<p class=\"right\".*/.match(line)
		print "\\rightline{\\texttt{" + /\>(.*)\</.match(line)[1] + "}}\n"
	elsif /^\<div class=\"box\"/.match(line)
		@inbox = true
		print "\\fboxsep=10pt\n\\fbox{\\begin{minipage}{30em}\n"
	elsif /^\<\/div\>/.match(line)
		@inbox = false
	    print "\\end{minipage}}\n"
	elsif /^---$/.match(line)
		@inyaml = !@inyaml
	elsif @inbox
		# handle text lines in catalogue card box
		print "\\texttt{" + line.sub(/^(\ )*/,"\\hspace*{0.5ex}") + "\\\\}\n"
	else
		print line unless @inyaml
	end
end
