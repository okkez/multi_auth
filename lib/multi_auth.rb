# -*- coding: utf-8 -*-

module MultiAuth

  class << self
    attr_accessor_with_default :application_name, 'app'
    attr_accessor_with_default :from_address, 'noreply@example.com'
    attr_accessor_with_default :user_model, 'User'
    attr_accessor_with_default :session_times_out_in, 1.hour
    attr_accessor_with_default :credentials, { :open_id => true, :email => true, :name => true }
    def setup
      yield self
    end
  end

  def self.user_model_class
    user_model.constantize
  end

  def self.root
    Pathname.new(File.join(File.dirname(__FILE__), '../'))
  end
end

require 'multi_auth/action_controller'
require 'multi_auth/active_record'

