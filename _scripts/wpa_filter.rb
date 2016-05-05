#!/usr/bin/env ruby

require 'pandoc-filter'

class WPAFilter
  @inrightpara = false
  @incard = false
  @valuestring = ""

  def wpafilter(type, value, format, meta)
    if type == 'RawBlock'
      fmt = value[0]
      s = value[1]
      if fmt == 'html'
        if /<p class=\"right\">/.match(s)
          @inrightpara = true
          return []
        elsif /<\/p>/.match(s)
          # create and return latex element	
          latex = PandocElement.Para([PandocElement.RawInline("tex","\\rightline{" + @valuestring.to_s + "}")])
          @inrightpara = false
          @valuestring = ""
          return latex
        end
        # suppress html
        return []
      end
    elsif type == 'Plain' && @inrightpara
    	# value should be an array of objects with t and c properties 
      value.each do |bit|
      	# todo deal with non-string elements, though that should never happen
      	@valuestring += bit["c"]
      end
    end
    if @inrightpara
      # Suppress anything in a comment
      return []
    end
  end
end

filter = WPAFilter.new

PandocFilter.filter do |type,value,format,meta|
  filter.wpafilter(type,value,format,meta)
end
