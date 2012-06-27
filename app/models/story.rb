class Story < ActiveRecord::Base
  STATUS_NOT_ASSIGN = 'NOT-ASSIGN'
  STATUS_DOING      = 'DOING'
  STATUS_REVIEWING  = 'REVIEWING'
  STATUS_DONE       = 'DONE'
  STATUS_PAUSE      = 'PAUSE'
  
  STATUSES = [
    STATUS_NOT_ASSIGN,
    STATUS_DOING,
    STATUS_REVIEWING,
    STATUS_DONE,
    STATUS_PAUSE
  ]
  
  # -------------------------
  
  has_many :stream_story_links
  has_many :streams, :through => :stream_story_links
  accepts_nested_attributes_for :stream_story_links
  has_many :story_assigns
  has_many :users, :through => :story_assigns
  
  belongs_to :product
  
  # ------------------
  
  default_scope order('id DESC')
  
  scope :with_status, lambda {|status| where(:status=>status)}
  
  # ------------------
  
  validates :product,     :presence => true
  validates :how_to_demo, :presence => true
  validates :status,      :presence => true, :inclusion => {:in => STATUSES}
  
  validate :validate_stream_story_links_count
  def validate_stream_story_links_count
   if 0 == self.stream_story_links.length
      errors.add(:streams, :至少指定一个序列)
   end
  end
  
  before_validation(:on => :create) do
    self.status = STATUS_NOT_ASSIGN
  end
  
  # ----------------------
  
  def change_status(status)
    self.status = status
    self.save
  end


  # 引用其它类
  include Comment::CommentableMethods
  
  # ----------------------
  
  module UserMethods
    def self.included(base)
      base.has_many :story_assigns
      base.has_many :stories, :through => :story_assigns 
    end
    
    def is_admin?
      User.first == self # 第一个用户是管理员，暂时先这样判断
    end
    
    def assigned_stories
      self.stories
    end
    
  end
end
