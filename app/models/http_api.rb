class HttpApi < ActiveRecord::Base
  class RequestType
    GET = 'GET'
    POST = 'POST'
    PUT = 'PUT'
    DELETE = 'DELETE'
  end


  class ResponseFormat
    TEXT = 'TEXT'
    XML = 'XML'
    JSON = 'JSON'
  end


  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  has_many :http_api_params, :dependent => :destroy
  has_many :http_api_responses, :dependent => :destroy

  accepts_nested_attributes_for :http_api_params
  accepts_nested_attributes_for :http_api_responses

  
  validates :creator, :title, :request_type, :url, :logic, :presence => true


  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :http_apis, :class_name => 'HttpApi', :foreign_key => :creator_id

      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      
    end
  end
end
