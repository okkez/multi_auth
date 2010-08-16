# -*- coding: utf-8 -*-

require 'test_helper'

class NameLoginFormTest < ActiveSupport::TestCase

  def setup
    @klass = NameLoginForm
    @form  = @klass.new
    @basic = @klass.new(:name => "name", :password => "password")
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
      [:name,     nil, "str", "str"],
      [:password, nil, "str", "str"],
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

  #
  # インスタンスメソッド
  #

  test "authenticate, success" do
    @form.name    = name_credentials(:nayutaya).name
    @form.password = "nayutaya"
    assert_equal(name_credentials(:nayutaya), @form.authenticate)
  end

  test "authenticate, empty" do
    assert_equal(nil, @form.authenticate)
  end
end
