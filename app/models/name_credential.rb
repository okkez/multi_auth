# -*- coding: utf-8 -*-
class NameCredential < ActiveRecord::Base

  untranslate :created_at, :user_id, :hashed_password

  NameMaximumLength = 200
  HashedPasswordPattern = /\A([0-9a-f]{8}):([0-9a-f]{64})\z/
  MaximumRecordsPerUser = 10

  belongs_to :user, :class_name => MultiAuth.user_model, :foreign_key => 'user_id'

  validates_presence_of :name
  validates_presence_of :hashed_password
  validates_length_of :name, :maximum => NameMaximumLength, :allow_nil => true
  validates_format_of :hashed_password, :with => HashedPasswordPattern, :allow_nil => true
  validates_uniqueness_of :name
  validates_each(:user_id, :on => :create) { |record, attr, value|
    if record.user && record.user.name_credentials(true).size >= MaximumRecordsPerUser
      record.errors.add(attr, "これ以上%{fn}に#{_(record.class.to_s.downcase)}を追加できません。")
    end
  }

  def self.create_hashed_password(password)
    salt = 8.times.map { rand(16).to_s(16) }.join
    return salt + ":" + Digest::SHA256.hexdigest(salt + ":" + password)
  end

  def self.compare_hashed_password(password, hashed_password)
    return false unless HashedPasswordPattern =~ hashed_password
    salt, digest = $1, $2
    return (Digest::SHA256.hexdigest(salt + ":" + password) == digest)
  end

  def self.authenticate(name, password)
    credential = self.find_by_name(name)
    return nil unless credential
    return nil unless credential.authenticated?(password)
    return credential
  end

  def authenticated?(password)
    return false unless self.class.compare_hashed_password(password, self.hashed_password)
    return false unless self.activated?
    return true
  end

  def activated?
    true
  end

  def activate!
    true
  end

  def login!
    self.update_attributes!(:loggedin_at => Time.now)
  end

  def to_label
    name
  end

end
