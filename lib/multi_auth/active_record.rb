
module MultiAuth
  module ActiveRecord
    module ClassMethods
      def multi_auth(options = { })
        class_eval do
          has_many :open_id_credentials, :dependent => :destroy
          has_many :email_credentials, :dependent => :destroy
        end
      end
    end
  end
end

ActiveRecord::Base.__send__(:extend, MultiAuth::ActiveRecord::ClassMethods)

