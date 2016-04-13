# from http://stackoverflow.com/questions/25802204/jekyll-filter-for-regex-substitution-in-content

module Jekyll
  module RegexFilter
    def replace_regex(input, reg_str, repl_str, firstonly)
      re = Regexp.new reg_str, Regexp::MULTILINE
      if firstonly
	      input.sub re, repl_str
	  else
	      input.gsub re, repl_str
	  end
    end
  end
end

Liquid::Template.register_filter(Jekyll::RegexFilter)