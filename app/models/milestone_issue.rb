class MilestoneIssue < ActiveRecord::Base
  class State
    OPEN   = 'OPEN'
    CLOSED = 'CLOSED'
    PAUSE  = 'PAUSE'
  end

  STATES = [
    MilestoneIssue::State::OPEN,
    MilestoneIssue::State::CLOSED,
    MilestoneIssue::State::PAUSE
  ]


  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :milestone_report, :class_name => 'MilestoneReport', :foreign_key => :check_report_id
  belongs_to :usecase, :class_name => 'UseCase', :foreign_key => :usecase_id


  validates :creator_id, :check_report_id,  :usecase_id, :content, :presence => true
  validates :state, :presence => true,
    :inclusion => MilestoneIssue::STATES


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
