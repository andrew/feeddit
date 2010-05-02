# = Digg-Ruby v0.1
#   Ruby wrapper for the Digg.com API
#   http://code.google.com/p/digg-ruby
#   
# Author::    John Wulff <johnw@orcasnet.com>
# Copyright:: Copyright (c) 2007 John Wulff <johnw@orcasnet.com>
# License::   MIT <http://www.opensource.org/licenses/mit-license.php>
#
# USAGE:
#  require 'digg'
#  digg = Digg.new               # create a digg client
#  digg.stories.each do |story|  # fetch and print titles of stories
#    puts story.title
#  end
#  digg.stories('stories/topic/apple', :count => 5)   # fetch 5 stories with topic `Apple`
#
#  Use the same style for users, events, topics, and errors
#
#  See http://apidoc.digg.com for a full listing of possible calls.

# TODO:
#  - convert attributes like { :topic => 'apple' } to Digg style endpoint
#  - also return comment events, currently only returns diggs
#  - check calls againts list of valid endpoints and arguments
#  - load relational elements as proper objects
#  - refactor to not use class_eval

require 'curb'
require 'nokogiri'
require 'cgi'

DIGG_API_URL = 'http://services.digg.com'
USER_AGENT = 'http://code.google.com/p/digg-ruby'
DEFAULT_API_KEY = 'http://code.google.com/p/digg-ruby'

CONTENT_CLASSES = :user, :story, :digg, :comment, :topic, :error, :container

CONTAINER_CONTENTS_MAP = { :users => :user,
                           :stories => :story,
                           :events => :digg,
                           :topics => :topic,
                           :errors => :error }

CONTAINER_ATTRIBUTES = :name, :short_name
CONTAINER_ELEMENTS = []
CONTAINER_ELEMENTS_AS_OBJECTS = []

COMMENT_ATTRIBUTES = []
COMMENT_ELEMENTS = []
COMMENT_ELEMENTS_AS_OBJECTS = []

STORIES_ATTRIBUTES = :timestamp, :min_date, :total, :offset, :count
STORY_ATTRIBUTES = :id, :link, :submit_date, :diggs, :comments, :href, :status
STORY_ELEMENTS = :title, :description
STORY_ELEMENTS_AS_OBJECTS = :user , :topic, :container
VALID_STORY_ENDPOINT_ARGUMENTS = :min_submit_date, :max_submit_date,
                                 :min_promote_date, :max_promote_date,
                                 :sort, :count, :offset, :domain, :link

USERS_ATTRIBUTES = :timestamp, :total, :offset, :count
USER_ATTRIBUTES = :name, :icon, :registered, :profileviews
USER_ELEMENTS = []
USER_ELEMENTS_AS_OBJECTS = []
VALID_USER_ENDPOINT_ARGUMENTS = :sort, :count, :offset

EVENTS_ATTRIBUTES = :timestamp, :min_date, :total, :offset, :count
DIGG_ATTRIBUTES = :date, :story, :id, :user, :status
DIGG_ELEMENTS = []
DIGG_ELEMENTS_AS_OBJECTS = []
VALID_EVENT_ENDPOINT_ARGUMENTS = :min_date, :max_date, :sort, :count, :offset

TOPICS_ATTRIBUTES = [ :timestamp ]
TOPIC_ATTRIBUTES = :name, :short_name
TOPIC_ELEMENTS = []
TOPIC_ELEMENTS_AS_OBJECTS = [ :container ]
VALID_TOPIC_ENDPOINT_ARGUMENTS = []

ERRORS_ATTRIBUTES = [ :timestamp ]
ERROR_ATTRIBUTES = :code, :message
ERROR_ELEMENTS = []
ERROR_ELEMENTS_AS_OBJECTS = []
VALID_ERROR_ENDPOINT_ARGUMENTS = []

class Digg
  def initialize(api_key = DEFAULT_API_KEY)
    @api_key = api_key
  end
  
  def fetch(path, arguments = {})
    host, port, path = assemble_url(path, arguments)    
    response = Curl::Easy.perform("http://#{host}#{path}") do |curl|
      curl.headers["User-Agent"] = "USER_AGENT"
      curl.headers['Accept'] = 'application/xml'
    end
    xml = Nokogiri::XML response.body_str
    return xml
  end

  def assemble_url(path, arguments = {})
    uri = URI.parse(DIGG_API_URL + '/' + path)
    path = uri.path + assemble_arguments(arguments)
    return uri.host, uri.port, path
  end
  
  def assemble_arguments(arguments = {})
    args = "?appkey=#{CGI::escape @api_key}"
    arguments.each_pair do |field, value|
      args += "&#{field}=#{CGI::escape value.to_s}"
    end
    return args
  end
  
  CONTENT_CLASSES.each do |content_class|
    content_class = content_class.to_s.capitalize
    # Define the content class.
    class_eval <<-EOV
      class #{content_class}
        (#{content_class.upcase}_ATTRIBUTES + 
         #{content_class.upcase}_ELEMENTS + 
         #{content_class.upcase}_ELEMENTS_AS_OBJECTS).each { |x| attr_accessor x }
        
        def self.populate_from_xml(xml)
          content = #{content_class}.new
          for attribute in #{content_class.upcase}_ATTRIBUTES
            if xml
              content.send attribute.to_s + '=', xml[attribute.to_s]
            end
          end
          for element in #{content_class.upcase}_ELEMENTS
            content.send element.to_s + '=', xml.children.at('//'+element.to_s).text
          end
          for type in #{content_class.upcase}_ELEMENTS_AS_OBJECTS
            klass = eval type.to_s.capitalize
            content.send(type.to_s + '=', klass.populate_from_xml(xml.xpath(type.to_s).first))
          end
          return content
        end
      end
    EOV
  end
  
  CONTAINER_CONTENTS_MAP.each_pair do |container_type, contents_type|
    container_class = container_type.to_s.capitalize
    content_class = contents_type.to_s.capitalize
    
    # Define the container specific fetcher.
    class_eval <<-EOV
      def #{container_type}(path = '#{container_type}', arguments = {})
        arguments.each_pair do |field, value|
          unless VALID_#{content_class.upcase}_ENDPOINT_ARGUMENTS.include?(field.to_sym)
            raise field.to_s + ' is not a valid argument for the #{container_class} endpoint'
          end
        end
        #{container_class}.populate_from_xml(fetch(path, arguments))
      end
    EOV
    
    # Define the xml to container/contents processor for this container.    
    class_eval <<-EOV
      class #{container_class} < Array
        #{container_class.upcase}_ATTRIBUTES.each { |x| attr_accessor x }
        
        def self.populate_from_xml(xml)
          container = #{container_class}.new
          for attribute in #{container_class.upcase}_ATTRIBUTES
            x = xml.xpath('//#{container_type}').first
            if x
              container.send attribute.to_s + '=', x.attributes[attribute.to_s]
            end
          end
          
          xml.xpath('//#{contents_type}').each do |x|
            container << #{content_class}.populate_from_xml(x)
          end
          
          return container
        end
      end
    EOV
  end
end
