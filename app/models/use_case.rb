class UseCase < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :milestone, :class_name => 'Milestone', :foreign_key => :milestone_id
  has_many :sub_usecases, :class_name => 'UseCase', :foreign_key => :usecase_id
  has_many :issues, :class_name => 'MilestoneIssue', :foreign_key => :usecase_id


  validates :product_id, :milestone_id,  :usecase_id,  :presence => true


  def opened_issues
    MilestoneIssue.where(:usecase_id => self.id, :state => MilestoneIssue::State::OPEN)
  end

  def closed_issues
    MilestoneIssue.where(:usecase_id => self.id, :state => MilestoneIssue::State::CLOSED)
  end

  def paused_issues
    MilestoneIssue.where(:usecase_id => self.id, :state => MilestoneIssue::State::PAUSE)
  end


  module UserMethods
    def self.included(base)
      base.has_many :usecases, :class_name => 'UseCase', :foreign_key => :creator_id

      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      
    end
    
  end
  # end of UserMethods
end
