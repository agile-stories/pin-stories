class MemberInfo < ActiveRecord::Base
  belongs_to :user
  
  
  module UserMethods
    def self.included(base)
      base.has_one :member_info
      base.after_save :_create_member_info_after_save

      base.accepts_nested_attributes_for :member_info
    end
    
    def _create_member_info_after_save
      if self.member_info.blank?
        self.create_member_info
      end
    end
    
    def find_or_create_info
      info = self.member_info
      return info if !info.blank?
      return self.create_member_info
    end
    
    def info_real_name
      self.find_or_create_info.real_name
    end

    def info_phone_number
      self.find_or_create_info.phone_number
    end

    def info_bank_card_number
      self.find_or_create_info.bank_card_number
    end
    
  end
  
end