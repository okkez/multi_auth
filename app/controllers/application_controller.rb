# -*- coding: utf-8 -*-

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter { |c| c.instance_eval { @topic_path = [] }; true }

  GetText.locale = "ja"
  init_gettext "multi_auth"

end
