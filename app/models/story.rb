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

  # 调用历史回滚
  audited
  
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


  # 回滚内容状态到指定的版本  
  def rollback_to(audit)
    if audit.auditable != self
      raise '你不能回滚到一个不属于本故事的版本记录'
    end

    how_to_demo = case audit.action
      when 'create'
        audit.audited_changes['how_to_demo']
      when 'update'
        audit.audited_changes['how_to_demo'].last
    end

    tips = case audit.action
      when 'create'
        audit.audited_changes['tips']
      when 'update'
        audit.audited_changes['tips'].last
    end

    self.how_to_demo = how_to_demo
    self.tips = tips
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


  # 设置全文索引字段
  define_index do
    # fields
    indexes how_to_demo, :sortable => true
    indexes tips
    indexes product_id
    
    # attributes
    has created_at, updated_at

    set_property :delta => true
  end
end
