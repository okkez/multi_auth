# -*- coding: utf-8 -*-
# NOTE: 本当に必要？
require 'multi_auth'
require 'multi_auth_helper'
MultiAuth.setup do |config|
 config.user_model = 'DummyUser'
end

ActiveRecord::Base.__send__(:extend, MultiAuth::ActiveRecord::ClassMethods)
ActionController::Base.__send__(:extend, MultiAuth::ActionController::ClassMethods)
ActionController::Base.__send__(:include, MultiAuth::ActionController::InstanceMethods)

