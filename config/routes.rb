# -*- coding: utf-8 -*-

ActionController::Routing::Routes.draw do |map|
  IdPattern    = /[0-9]+/
  TokenPattern = /[0-9a-f]+/

  map.root :controller => "home", :action => "index"

  map.connect "signup", :controller => "signup", :action => "index"

  map.with_options :controller => "signup/email" do |email|
    email.connect "signup/email/:action",                      :action => /(index|validate|validated|create|created|activate|activated)/
    email.connect "signup/email/activation/:activation_token", :action => "activation", :activation_token => TokenPattern
  end

  map.with_options :controller => "signup/open_id" do |open_id|
    open_id.connect "signup/open_id/:action", :action => /(index|authenticate|authenticated|create|created)/
  end

  map.connect "auth/:action", :controller => "auth", :action => /(logged_in|logout|logged_out)/
  map.connect "auth/email/:action", :controller => "auth/email", :action => /(index|login)/
  map.connect "auth/open_id/:action", :controller => "auth/open_id", :action => /(index|login)/

  map.connect "credentials/:action", :controller => "credentials", :action => /(index)/

  map.with_options :controller => "credentials/email" do |email|
    email.connect "credentials/email/:action",                        :action => /(new|create)/
    email.connect "credential/email/:email_credential_id/:action",    :action => /(created|edit_password|update_password|delete|destroy)/, :email_credential_id => IdPattern
    email.connect "credential/email/token/:activation_token/:action", :action => /(activation|activate|activated)/, :activation_token => TokenPattern
  end

  map.with_options :controller => "credentials/open_id" do |open_id|
    open_id.connect "credentials/open_id/:action",                       :action => /(new|create)/
    open_id.connect "credential/open_id/:open_id_credential_id/:action", :action => /(delete|destroy)/, :open_id_credential_id => IdPattern
  end

  map.with_options :controller => "emails" do |emails|
    emails.connect "emails/:action",                        :action => /(new|create)/
    emails.connect "email/:email_address_id/:action",       :action => /(created|delete|destroy)/, :email_address_id => IdPattern
    emails.connect "email/token/:activation_token/:action", :action => /(activation|activate|activated)/, :activation_token => TokenPattern
  end

  # MEMO: 下記2行のデフォルトルールをコメントアウトしてrake test:functionalsを
  #       実行することにより、リンクチェックを行うことができる
  map.connect ":controller/:action/:id"
  map.connect ":controller/:action/:id.:format"
end
