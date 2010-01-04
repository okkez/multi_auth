
namespace :gettext do
  desc "Update pot/po files."
  task :po do
    require 'gettext_rails'
    require "gettext_rails/tools"
    untranslate_classes = ["OpenIdAuthentication::Association",
                           "OpenIdAuthentication::Nonce",
                           "ActiveForm"]
    GetText::ActiveRecordParser.init(:untranslate_classes => untranslate_classes)
    GetText.update_pofiles(
      "multi_auth",
      Dir.glob("{app,config,components,lib}/**/*.{rb,erb,rjs}"),
      "multi_auth 1.0.0")
  end

  desc "Create mo-files."
  task :mo do
    require "gettext_rails/tools"
    GetText.create_mofiles
  end
end
