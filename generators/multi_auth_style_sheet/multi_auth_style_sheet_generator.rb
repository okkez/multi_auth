
class MultiAuthStyleSheetGenerator < Rails::Generator::Base
  def initialize(runtime_args, runtime_options = { })
    super
  end

  def manifest
    record do |m|
      m.directory('public/stylesheets')
      m.file('style.css', 'public/stylesheets/multi_auth.css')
    end
  end
end
