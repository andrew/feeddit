#!/usr/bin/env ruby -wKU

require 'find'
require 'fileutils'
include FileUtils::Verbose

def is_excluded(file)
  type = case
  when file =~ /(404|500).html/
    true
  end
end

Find.find("../public") do |f|
  if File.file?(f) and f =~ /\w.(html|atom)/ 
    rm f unless is_excluded(f)
  end
end
