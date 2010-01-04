# -*- coding: utf-8 -*-

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # multi_auth を使用するアプリケーションには影響しない
  GetText.locale = "ja"
  init_gettext "multi_auth"

end
