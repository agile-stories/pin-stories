class MilestoneIssue < ActiveRecord::Base
  STATES = [
    'OPEN',
    'CLOSED',
    'PAUSE'
  ]


  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :milestone_report, :class_name => 'MilestoneReport', :foreign_key => :check_report_id
  belongs_to :usecase, :class_name => 'UseCase', :foreign_key => :usecase_id


  validates :creator_id, :check_report_id,  :usecase_id,  :presence => true


  module UserMethods
    def self.included(base)
      base.has_many :milestone_issues, :foreign_key => :creator_id

      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      
    end
  end
  # end of UserMethods
  
end
