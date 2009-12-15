require File.dirname(__FILE__) + '/../test_helper.rb'
require 'rails_generator'
require 'rails_generator/scripts/generate'

class MultiAuthPublicAssetsGeneratorTest < Test::Unit::TestCase

  def setup
    @src = File.expand_path(File.join(File.dirname(__FILE__), '../..', 'generators'))
    @dest = File.expand_path(File.join(File.dirname(__FILE__), '../..', 'lib', 'generators'))
    FileUtils.ln_s(@src, @dest)
    FileUtils.mkdir_p(fake_rails_root)
    @original_files = Dir.glob(File.join(fake_rails_root, '**/*'))
  end

  def teardown
    FileUtils.safe_unlink(@dest)
    FileUtils.rm_r(fake_rails_root)
  end

  def test_generates_correct_file_name
    Rails::Generator::Scripts::Generate.new.run(["multi_auth_public_assets"],
                                                :destination => fake_rails_root)
    new_icons = Dir.glob(File.join(fake_rails_root, 'public/images/icons/*.png')).sort
    assert_equal 2, new_icons.size
    ['openid-with-desc.png', 'openid.png'].sort.map{|f|
      "#{fake_rails_root}/public/images/icons/#{f}"
    }.zip(new_icons) do |expected, actual|
      assert_equal expected, actual
    end
    new_fam_icons = Dir.glob(File.join(fake_rails_root, 'public/images/icons/fam/*.png')).sort
    assert_equal 18, new_fam_icons.size
    ['add.png', 'bomb.png', 'delete.png', 'email.png', 'help.png', 'key.png', 'plugin.png',
     'table_save.png', 'user.png', 'bin.png', 'cog.png', 'email-with-desc.png', 'feed.png',
     'key-with-desc.png', 'lightning.png', 'stop.png', 'tick.png', 'vcard.png'
    ].sort.map{|f|
      "#{fake_rails_root}/public/images/icons/fam/#{f}"
    }.zip(new_fam_icons) do |expected, actual|
      assert_equal expected, actual
    end
    new_favicons = Dir.glob(File.join(fake_rails_root, 'public/images/favicons/*.png')).sort
    assert_equal 3, new_favicons.size
    ['livedoor.png', 'mixi.png', 'yahoo.png'].sort.map{|f|
      "#{fake_rails_root}/public/images/favicons/#{f}"
    }.zip(new_favicons) do |expected, actual|
      assert_equal expected, actual
    end
  end

  private

  def fake_rails_root
    File.join(File.dirname(__FILE__), 'rails_root')
  end

end
