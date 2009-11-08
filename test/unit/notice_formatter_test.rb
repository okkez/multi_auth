# -*- coding: utf-8 -*-

require 'test_helper'

class NoticeFormatterTest < ActiveSupport::TestCase
  def setup
    @module = NoticeFormatter
  end

  test "replace_keywords, empty" do
    assert_equal("", @module.replace_keywords("", {}))
  end

  test "replace_keywords" do
    assert_equal(
      "A",
      @module.replace_keywords("{a}", "a" => "A"))
    assert_equal(
      "A,B",
      @module.replace_keywords("{a},{b}", "a" => "A", "b" => "B"))
    assert_equal(
      "A,B,A,B",
      @module.replace_keywords("{a},{b},{a},{b}", "a" => "A", "b" => "B"))
  end

  test "add_namespace" do
    expected = {
      "name:a" => "b",
      "name:c" => "d",
    }
    assert_equal(expected, @module.add_namespace("name", {"a" => "b", "c" => "d"}))
  end

  test "format_integer_value" do
    assert_equal("1", @module.format_integer_value(1))
    assert_equal("-", @module.format_integer_value(nil))
  end

  test "format_integer_json_value" do
    assert_equal("1", @module.format_integer_json_value(1))
    assert_equal("null", @module.format_integer_json_value(nil))
  end

  test "format_string_value" do
    assert_equal("a", @module.format_string_value("a"))
    assert_equal("あ", @module.format_string_value("あ"))
    assert_equal("-", @module.format_string_value(""))
    assert_equal("-", @module.format_string_value(nil))
  end

  test "format_string_json_value" do
    assert_equal('"a"', @module.format_string_json_value("a"))
    assert_equal('"\\u3042"', @module.format_string_json_value("あ"))
    assert_equal("null", @module.format_string_json_value(""))
    assert_equal("null", @module.format_string_json_value(nil))
  end

  test "format_part_of_date" do
    expected = {
      "date"      => "2009-01-02",
      "date:json" => '"2009-01-02"',
      "date:ja"   => "2009年01月02日",
      "yyyy"      => "2009",
      "mm"        => "01",
      "dd"        => "02",
    }
    assert_equal(expected, @module.format_part_of_date(Date.new(2009, 1, 2)))
  end

  test "format_part_of_date, nil" do
    expected = {
      "date"      => "-",
      "date:json" => "null",
      "date:ja"   => "-",
      "yyyy"      => "-",
      "mm"        => "-",
      "dd"        => "-",
    }
    assert_equal(expected, @module.format_part_of_date(nil))
  end

  test "format_part_of_time" do
    expected = {
      "time"      => "01:02:03",
      "time:json" => '"01:02:03"',
      "time:ja"   => "01時02分03秒",
      "hh"        => "01",
      "nn"        => "02",
      "ss"        => "03",
    }
    assert_equal(expected, @module.format_part_of_time(Time.local(2009, 12, 31, 1, 2, 3)))
  end

  test "format_part_of_time, nil" do
    expected = {
      "time"      => "-",
      "time:json" => "null",
      "time:ja"   => "-",
      "hh"        => "-",
      "nn"        => "-",
      "ss"        => "-",
    }
    assert_equal(expected, @module.format_part_of_time(nil))
  end

  test "format_part_of_datetime" do
    datetime = Time.local(2009, 12, 31, 12, 34, 56)
    expected = {
      "datetime"      => "2009-12-31 12:34:56",
      "datetime:json" => '"2009-12-31 12:34:56"',
      "datetime:ja"   => "2009年12月31日 12時34分56秒",
    }
    expected.merge!(@module.format_part_of_date(datetime))
    expected.merge!(@module.format_part_of_time(datetime))
    assert_equal(expected, @module.format_part_of_datetime(datetime))
  end

  test "format_part_of_datetime, nil" do
    expected = {
      "datetime"      => "-",
      "datetime:json" => "null",
      "datetime:ja"   => "-",
    }
    expected.merge!(@module.format_part_of_date(nil))
    expected.merge!(@module.format_part_of_time(nil))
    assert_equal(expected, @module.format_part_of_datetime(nil))
  end

  test "format_part_of_user" do
    expected = {
      "user:token"         => "0" * User::TokenLength,
      "user:token:json"    => '"' + "0" * User::TokenLength + '"',
      "user:nickname"      => "nickname",
      "user:nickname:json" => '"nickname"',
    }
    user = User.new(
      :user_token => "0" * User::TokenLength,
      :nickname   => "nickname")
    assert_equal(expected, @module.format_part_of_user(user))
  end

  test "format_part_of_user, nil" do
    expected = {
      "user:token"         => "-",
      "user:token:json"    => "null",
      "user:nickname"      => "-",
      "user:nickname:json" => "null",
    }
    assert_equal(expected, @module.format_part_of_user(User.new))
    assert_equal(expected, @module.format_part_of_user(nil))
  end

end
