# -*- coding: utf-8 -*-

# アクティベーションメーラ
class ActivationMailer < ActionMailer::Base
  include ActionMailerUtil

  SubjectPrefix = "[#{MultiAuth.application_name}] "
  FromAddress   = MultiAuth.from_address

  def self.create_request_for_signup_params(options)
    options = options.dup
    recipients     = options.delete(:recipients)     || raise(ArgumentError)
    activation_url = options.delete(:activation_url) || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return {
      :subject    => SubjectPrefix + p_("MultiAuth", "User registration"),
      :from       => FromAddress,
      :recipients => recipients,
      :body       => {:activation_url => activation_url},
    }
  end

  def self.create_complete_for_signup_params(options)
    options = options.dup
    recipients = options.delete(:recipients) || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return {
      :subject    => SubjectPrefix + p_("MultiAuth", "User registration completed"),
      :from       => FromAddress,
      :recipients => recipients,
      :body       => {},
    }
  end

  def self.create_request_for_credential_params(options)
    options = options.dup
    recipients     = options.delete(:recipients)     || raise(ArgumentError)
    activation_url = options.delete(:activation_url) || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return {
      :subject    => SubjectPrefix + p_("MultiAuth", "Email address registration for authentication"),
      :from       => FromAddress,
      :recipients => recipients,
      :body       => {:activation_url => activation_url},
    }
  end

  def self.create_complete_for_credential_params(options)
    options = options.dup
    recipients = options.delete(:recipients) || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return {
      :subject    => SubjectPrefix + p_("MultiAuth", "Email address registration for authentication completed"),
      :from       => FromAddress,
      :recipients => recipients,
      :body       => {},
    }
  end

  def self.create_request_for_notice_params(options)
    options = options.dup
    recipients     = options.delete(:recipients)     || raise(ArgumentError)
    activation_url = options.delete(:activation_url) || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return {
      :subject    => SubjectPrefix + p_("MultiAuth", "Email address registration for notification"),
      :from       => FromAddress,
      :recipients => recipients,
      :body       => {:activation_url => activation_url},
    }
  end

  def self.create_complete_for_notice_params(options)
    options = options.dup
    recipients = options.delete(:recipients) || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return {
      :subject    => SubjectPrefix + p_("MultiAuth", "Email address registration for notification completed"),
      :from       => FromAddress,
      :recipients => recipients,
      :body       => {},
    }
  end

  def request_for_signup(options)
    build_message(self.class.create_request_for_signup_params(options))
  end

  def complete_for_signup(options)
    build_message(self.class.create_complete_for_signup_params(options))
  end

  def request_for_credential(options)
    build_message(self.class.create_request_for_credential_params(options))
  end

  def complete_for_credential(options)
    build_message(self.class.create_complete_for_credential_params(options))
  end

  def request_for_notice(options)
    build_message(self.class.create_request_for_notice_params(options))
  end

  def complete_for_notice(options)
    build_message(self.class.create_complete_for_notice_params(options))
  end
end
