# -*- coding: utf-8 -*-

module MultiAuth

  class << self
    attr_accessor_with_default :application_name, 'app'
    attr_accessor_with_default :from_address, 'noreply@example.com'
    attr_accessor_with_default :user_model, 'User'
    def setup
      yield self
    end
  end

  def self.user_model_class
    user_model.constantize
  end
end

require 'multi_auth/action_controller'
require 'multi_auth/active_record'

