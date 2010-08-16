# -*- coding: utf-8 -*-

class NameCredentialEditForm < ActiveForm
  PasswordLengthRange = 4..20
  PasswordPattern     = /\A[\x21-\x7E]+\z/

  column :name,                  :type => :text
  column :password,              :type => :text
  column :password_confirmation, :type => :text

  N_("NameCredentialEditForm|Name")
  N_("NameCredentialEditForm|Password")
  N_("NameCredentialEditForm|Password confirmation")

  validates_presence_of :name
  validates_presence_of :password
  validates_presence_of :password_confirmation
  validates_length_of :name, :maximum => ::NameCredential::NameMaximumLength, :allow_nil => true
  validates_length_of :password, :in => PasswordLengthRange, :allow_nil => true
  validates_format_of :password, :with => PasswordPattern, :allow_nil => true
  validates_each(:password) { |record, attr, value|
    # MEMO: validates_confirmation_of は password_confirmation 属性を上書きしてしまうため、
    #       ここでは使用できない。そのため、validates_confirmation_of を参考に独自に実装。
    confirmation = record.__send__("#{attr}_confirmation")
    if confirmation.blank? || value != confirmation
      record.errors.add(attr, :confirmation)
    end
  }

  def masked_password
    return self.password.to_s.gsub(/./, "*")
  end

  def to_name_credential_hash
    return {
      :name            => self.name,
      :hashed_password => NameCredential.create_hashed_password(self.password.to_s),
    }
  end
end
