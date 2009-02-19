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

# removes all cached html and atom files 

Find.find("../public") do |f|
  if File.file?(f) and f =~ /\w.(html|atom)/ 
    rm f unless is_excluded(f)
  end
end

# example crontab 
# # m h  dom mon dow   command
# 0,15,30,45  *  *   *   *     ruby -C /home/andrew/apps/feeddit/current/lib cleanup.rb