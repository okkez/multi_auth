
class MultiAuth

  class << self
    attr_accessor_with_default :application_name, 'app'
    attr_accessor_with_default :from_address, 'noreply@example.com'
    attr_accessor_with_default :user_model, 'User'
    def setup
      yield self
    end

    def self.user_model_class
      @user_model.constantize
    end
  end
end
