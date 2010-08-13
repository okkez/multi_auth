# -*- coding: utf-8 -*-
class CreateNameCredentials < ActiveRecord::Migration
  def self.up
    create_table :name_credentials do |t|
      # 作成日時
      t.datetime :created_at,       :null => false
      # ユーザID
      t.integer  :user_id,          :null => false
      # 名前
      t.string   :name,             :null => false, :limit => 200
      # ハッシュされたパスワード
      t.string   :hashed_password,  :null => false, :limit => 8 + 1 + 64
      # ログイン日時
      t.datetime :loggedin_at,      :null => true
    end

    add_index :name_credentials, :created_at
    add_index :name_credentials, :user_id
    add_index :name_credentials, :name, :unique => true
  end

  def self.down
    drop_table :name_credentials
  end
end
