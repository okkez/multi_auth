
class MultiAuthPublicAssetsGenerator < Rails::Generator::Base
  def initialize(runtime_args, runtime_options = { })
    super
  end

  def manifest
    record do |m|
      m.directory('public/stylesheets')
      m.file('style.css', 'public/stylesheets/multi_auth.css')
      m.directory('public/images/icons/fam')
      ['openid.png', 'openid-with-desc.png'].each do |file|
        m.file("images/icons/#{file}", "public/images/icons/#{file}")
      end
      ['add.png', 'bomb.png', 'delete.png', 'email.png', 'help.png', 'key.png', 'plugin.png',
       'table_save.png', 'user.png', 'bin.png', 'cog.png', 'email-with-desc.png', 'feed.png',
       'key-with-desc.png', 'lightning.png', 'stop.png', 'tick.png', 'vcard.png'
      ].each do |file|
        m.file("images/icons/fam/#{file}", "public/images/icons/fam/#{file}")
      end
      m.directory('public/images/favicons')
      ['livedoor.png', 'mixi.png', 'yahoo.png'].each do |file|
        m.file("images/favicons/#{file}", "public/images/favicons/#{file}")
      end
    end
  end
end
