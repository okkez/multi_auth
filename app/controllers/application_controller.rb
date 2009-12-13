# -*- coding: utf-8 -*-

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  GetText.locale = "ja"
  init_gettext "multi_auth"

end
