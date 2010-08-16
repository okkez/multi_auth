# -*- coding: utf-8 -*-
require 'test_helper'

class NameCredentialEditFormTest < ActiveSupport::TestCase
  def setup
    @klass = NameCredentialEditForm
    @form  = @klass.new
    @basic = @klass.new(:name => "name",
                        :password => "password", :password_confirmation => "password")
  end

  #
  # 基底クラス
  #

  test "superclass" do
    assert_equal(ActiveForm, @klass.superclass)
  end

  #
  # カラム
  #

  test "columns" do
    [
      [:name,                  nil, "str", "str"],
      [:password,              nil, "str", "str"],
      [:password_confirmation, nil, "str", "str"],
    ].each { |name, default, set_value, get_value|
      form = @klass.new
      assert_equal(default, form.__send__(name))
      form.__send__("#{name}=", set_value)
      assert_equal(get_value, form.__send__(name))
    }
  end

  #
  # 検証
  #

  test "basic is valid" do
    assert_equal(true, @basic.valid?)
  end

  test "validates_presence_of :name" do
    @basic.name = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :password" do
    @basic.password = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :password_confirmation" do
    @basic.password_confirmation = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_length_of :name" do
    [
      ["a" * 13, 13, true ],
      ["a" * 200, 200, true ],
      ["a" * 201, 201, false],
    ].each { |value, length, expected|
      assert_equal(length, value.size)
      @basic.name = value
      assert_equal(expected, @basic.valid?)
    }
  end

  test "validates_length_of :password" do
    [
      ["a" *  3, false],
      ["a" *  4, true ],
      ["a" * 20, true ],
      ["a" * 21, false],
    ].each { |value, expected|
      @basic.password              = value
      @basic.password_confirmation = value
      assert_equal(expected, @basic.valid?)
    }
  end

  test "validates_format_of :password" do
    valid_chars = (0x21..0x7E).map { |c| c.chr }.join

    [
      [valid_chars.slice!(0, 20), true ],
      [valid_chars.slice!(0, 20), true ],
      [valid_chars.slice!(0, 20), true ],
      [valid_chars.slice!(0, 20), true ],
      [valid_chars.slice!(0, 20), true ],
      ["aaaa",   true ],
      ["aaa ",   false],
      ["日本語", false],
    ].each { |value, expected|
      @basic.password              = value
      @basic.password_confirmation = value
      assert_equal(expected, @basic.valid?)
    }

    assert_equal(true, valid_chars.empty?)
  end

  test "validates_each, password" do
    @basic.password              = "aaaa"
    @basic.password_confirmation = "aaaa"
    assert_equal(true, @basic.valid?)

    @basic.password              = "aaaa"
    @basic.password_confirmation = "AAAA"
    assert_equal(false, @basic.valid?)
  end
  #
  # インスタンスメソッド
  #

  test "masked_password" do
    @form.password = nil
    assert_equal("", @form.masked_password)

    @form.password = "a"
    assert_equal("*", @form.masked_password)

    @form.password = "abc"
    assert_equal("***", @form.masked_password)
  end

  test "to_name_credential_hash, empty" do
    hash = @form.to_name_credential_hash
    assert_equal(
      [:name, :hashed_password].map(&:to_s).sort,
      hash.keys.map(&:to_s).sort)
    assert_equal(nil, hash[:name])
    assert_equal(true, NameCredential.compare_hashed_password("", hash[:hashed_password]))
  end

  test "to_name_credential_hash, full" do
    @form.attributes = {
      :name    => "foo@example.com",
      :password => "foo",
    }
    hash = @form.to_name_credential_hash
    assert_equal(
      [:name, :hashed_password].map(&:to_s).sort,
      hash.keys.map(&:to_s).sort)
    assert_equal(@form.name, hash[:name])
    assert_equal(true, NameCredential.compare_hashed_password(@form.password, hash[:hashed_password]))
  end
end
