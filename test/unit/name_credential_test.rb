# -*- coding: utf-8 -*-
require 'test_helper'

class NameCredentialTest < ActiveSupport::TestCase
  def setup
    @klass = NameCredential
    @basic = @klass.new(:user_id         => users(:yuya).id,
                        :name            => "yuya",
                        :hashed_password => ("0" * 8) + ":" + ("0" * 64))
    @nayutaya = name_credentials(:nayutaya)
    @risa_risa = name_credentials(:risa_risa)
  end

  #
  # 関連
  #
  test "belongs_to :user" do
    assert_equal(users(:yuya), @nayutaya.user)
    assert_equal(users(:risa), @risa_risa.user)
  end

  #
  # 検証
  #
  test "all fixtures are valid" do
    assert_equal(true, @klass.all.all?(&:valid?))
  end

  test "basic is valid" do
    assert_equal(true, @basic.valid?)
  end

  test "validates_presence_of :name" do
    @basic.name = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :hashed_password" do
    @basic.hashed_password = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_format_of :hashed_password" do
    [
      # ソルト値部分
      ["01234567"  + ":" + "0" * 64, true ],
      ["89abcdef"  + ":" + "0" * 64, true ],
      ["0000000"   + ":" + "0" * 64, false],
      ["00000000"  + ":" + "0" * 64, true ],
      ["000000000" + ":" + "0" * 64, false],
      ["0000000A"  + ":" + "0" * 64, false],
      ["0000000g"  + ":" + "0" * 64, false],
      # ハッシュ値部分
      ["00000000" + ":" + "0123456789abcdef" + "0" * (64 - 16), true ],
      ["00000000" + ":" + "0" * (64 - 1),                       false],
      ["00000000" + ":" + "0" * 64,                             true ],
      ["00000000" + ":" + "0" * (64 + 1),                       false],
      ["00000000" + ":" + "0" * (64 - 1) + "A",                 false],
      ["00000000" + ":" + "0" * (64 - 1) + "g",                 false],
    ].each { |value, expected|
      @basic.hashed_password = value
      assert_equal(expected, @basic.valid?, value)
    }
  end

  test "validates_uniqueness_of :name, on create" do
    @basic.name = @nayutaya.name
    assert_equal(false, @basic.valid?)
  end

  test "validates_uniqueness_of :name, on update" do
    @nayutaya.name = @risa_risa.name
    assert_equal(false, @nayutaya.valid?)
  end

  test "validates_each :user_id" do
    srand(0)
    user = users(:yuya)
    create_record = proc {
      user.name_credentials.create!(
        :name             => "name#{rand(1000)}",
        :hashed_password  => ("0" * 8) + ":" + ("0" * 64))
    }

    assert_nothing_raised {
      (10 - user.name_credentials.size).times {
        record = create_record[]
        record.save!
      }
    }
    assert_raise(ActiveRecord::RecordInvalid) {
      create_record[]
    }
  end
  test "self.create_hashed_password" do
    assert_match(
      /\A[0-9a-f]{8}:[0-9a-f]{64}\z/,
      @klass.create_hashed_password("a"))

    # 異なるパスワードでは、異なる値になること
    assert_not_equal(
      @klass.create_hashed_password("a"),
      @klass.create_hashed_password("b"))

    # 同一のパスワードでも、異なる値になること
    assert_not_equal(
      @klass.create_hashed_password("a"),
      @klass.create_hashed_password("a"))
  end

  test "self.compare_hashed_password" do
    # ソルト、パスワードが一致
    assert_equal(
      true,
      @klass.compare_hashed_password(
        "password",
        "00000000:" + Digest::SHA256.hexdigest("00000000:password")))

    # ソルトが不一致、パスワードが一致
    assert_equal(
      false,
      @klass.compare_hashed_password(
        "password",
        "00000000:" + Digest::SHA256.hexdigest("11111111:password")))

    # ソルトが一致、パスワードが不一致
    assert_equal(
      false,
      @klass.compare_hashed_password(
        "password",
        "00000000:" + Digest::SHA256.hexdigest("00000000:PASSWORD")))
  end

  test "self.authenticate" do
    assert_equal(
      name_credentials(:nayutaya),
      @klass.authenticate(name_credentials(:nayutaya).name, "nayutaya"))

    assert_equal(
      nil,
      @klass.authenticate(name_credentials(:nayutaya).name, "NAYUTAYA"))

    assert_equal(
      nil,
      @klass.authenticate(nil, nil))
  end

  #
  # インスタンスメソッド
  #

  test "authenticated?" do
    assert_equal(true,  name_credentials(:nayutaya).authenticated?("nayutaya"))
    assert_equal(false, name_credentials(:nayutaya).authenticated?("YUYA_GMAIL"))
  end

  test "activated?" do
    assert_equal(true,  name_credentials(:nayutaya).activated?)
    assert_equal(true, NameCredential.new.activated?)
  end

  test "activate!" do
    assert_equal(true,  name_credentials(:nayutaya).activate!)
    assert_equal(true, NameCredential.new.activate!)
  end

  test "login!" do
    time = Time.local(2010, 1, 1)
    assert_equal(nil, @risa_risa.loggedin_at)
    Kagemusha::DateTime.at(time) { @risa_risa.login! }
    assert_equal(time, @risa_risa.reload.loggedin_at)
  end
end
