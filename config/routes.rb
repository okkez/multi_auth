# -*- coding: utf-8 -*-

ActionController::Routing::Routes.draw do |map|
  IdPattern    = /[0-9]+/
  TokenPattern = /[0-9a-f]+/

  if Rails.root.to_s == File.expand_path(File.join(File.dirname(__FILE__), '..'))
    map.root :controller => "home", :conditions => { :method => :get }
  end

  map.signup "signup", :controller => "signup", :conditions => { :method => :get }

  map.namespace :signup do |signup|
    signup.with_options :controller => "email" do |email|
      email.connect "email/:action",                      :action => /(index|validate|validated|create|created|activate|activated)/
      email.connect "email/activation/:activation_token", :action => "activation", :activation_token => TokenPattern
    end
    signup.with_options :controller => "open_id" do |open_id|
      open_id.connect "open_id/:action", :action => /(index|authenticate|authenticated|create|created)/
    end
  end

  map.with_options :controller => "auth" do |auth|
    auth.auth "auth", :action => "index", :conditions => { :method => :get }
    auth.logout "auth/logout", :action => "logout", :conditions => { :method => :post }
    auth.connect "auth/:action", :action => /(logged_in|logged_out)/, :conditions => { :method => :get }
  end
  map.namespace :auth do |auth|
    auth.connect "email/:action", :controller => "email", :action => /(index|login)/
    auth.connect "open_id/:action", :controller => "open_id", :action => /(index|login)/
    auth.connect "name/:action", :controller => "name", :action => /(index|login)/
  end

  map.credentials "credentials",  :controller => "credentials", :conditions => { :method => :get }

  map.with_options :controller => "credentials/email" do |email|
    email.connect "credentials/email/:action",                        :action => /(new|create)/
    email.connect "credential/email/:email_credential_id/:action",    :action => /(created|edit_password|update_password|delete|destroy)/, :email_credential_id => IdPattern
    email.connect "credential/email/token/:activation_token/:action", :action => /(activation|activate|activated)/, :activation_token => TokenPattern
  end

  map.with_options :controller => "credentials/open_id" do |open_id|
    open_id.connect "credentials/open_id/:action",                       :action => /(new|create)/
    open_id.connect "credential/open_id/:open_id_credential_id/:action", :action => /(delete|destroy)/, :open_id_credential_id => IdPattern
  end

  # MEMO: 下記2行のデフォルトルールをコメントアウトしてrake test:functionalsを
  #       実行することにより、リンクチェックを行うことができる
  # NOTE: この二行を有効にするとアプリケーション側の config/routes.rb で定義した
  #       ルートが有効にならない
  # map.connect ":controller/:action/:id"
  # map.connect ":controller/:action/:id.:format"
end
