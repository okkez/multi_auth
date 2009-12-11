# -*- coding: utf-8 -*-
# NOTE: 本当に必要？
require 'multi_auth'
require 'multi_auth_helper'
MultiAuth.setup do |config|
 config.user_model = 'DummyUser' 
end

