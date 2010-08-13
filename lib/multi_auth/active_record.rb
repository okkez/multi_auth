
module MultiAuth
  module ActiveRecord
    module ClassMethods
      def multi_auth(options = { })
        class_eval do
          has_many :open_id_credentials, :foreign_key => 'user_id', :dependent => :destroy
          has_many :email_credentials, :foreign_key => 'user_id', :dependent => :destroy
          has_many :name_credentials, :foreign_key => 'user_id', :dependent => :destroy
        end
      end
    end
  end
end

