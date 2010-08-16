# -*- coding: utf-8 -*-
class <%= class_name %> < ActiveRecord::Migration
  def self.up
    create_table :open_id_credentials do |t|
      t.datetime :created_at,   :null => false
      t.integer  :user_id,      :null => false
      t.string   :identity_url, :null => false, :limit => 200
      t.datetime :loggedin_at,  :null => true
    end

    add_index :open_id_credentials, :user_id
    add_index :open_id_credentials, :identity_url, :unique => true

    create_table :email_credentials do |t|
      t.datetime :created_at,       :null => false
      t.string   :activation_token, :null => false, :limit => 40
      t.integer  :user_id,          :null => false
      t.string   :email,            :null => false, :limit => 200
      t.string   :hashed_password,  :null => false, :limit => 8 + 1 + 64
      t.datetime :activated_at,     :null => true
      t.datetime :loggedin_at,      :null => true
    end

    add_index :email_credentials, :created_at
    add_index :email_credentials, :activation_token, :unique => true
    add_index :email_credentials, :user_id
    add_index :email_credentials, :email, :unique => true
    add_index :email_credentials, :activated_at

    create_table :name_credentials do |t|
      t.datetime :created_at,       :null => false
      t.integer  :user_id,          :null => false
      t.string   :name,             :null => false, :limit => 200
      t.string   :hashed_password,  :null => false, :limit => 8 + 1 + 64
      t.datetime :loggedin_at,      :null => true
    end

    add_index :name_credentials, :created_at
    add_index :name_credentials, :user_id
    add_index :name_credentials, :name, :unique => true
  end

  def self.down
    drop_table :open_id_credentials
    drop_table :email_credentials
    drop_table :name_credentials
  end
end
