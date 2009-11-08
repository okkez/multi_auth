
plugin_root = File.expand_path(File.join(File.dirname(__FILE__), '../..'))
plugin_migration_files = FileList[File.join(plugin_root, 'db/migrate', '*.rb')].exclude(/(create_users|sessions)\.rb/)
plugin_stylesheets = FileList[File.join(plugin_root, 'public/stylesheets', '*.css')]
plugin_image_path = File.join(plugin_root, 'public/images')
plugin_favicons = FileList[File.join(plugin_image_path, 'favicons', '*.png')]
plugin_icons = FileList[File.join(plugin_image_path, 'icons', '*.png')]
plugin_fam_icons = FileList[File.join(plugin_image_path, 'icons/fam', '*.png')]

namespace :multi_auth do
  namespace :copy do
    desc "copy migrations from this plugin"
    task :migrations do
      FileUtils.cp plugin_migration_files, 'db/migrate/'
    end
    desc "copy stylesheets from this plugin"
    task :stylesheets => 'public/stylesheets/multi_auth.css'

    desc "copy images from this plugin"
    task :images => [:favicons, :icons]

    task :favicons do
      FileUtils.mkdir_p 'public/images/favicons'
      FileUtils.cp plugin_favicons, 'public/images/favicons/'
    end

    task :icons do
      FileUtils.mkdir_p 'public/images/icons/fam'
      FileUtils.cp plugin_icons, 'public/images/icons/'
      FileUtils.cp plugin_fam_icons, 'public/images/icons/fam/'
    end

    file 'public/stylesheets/multi_auth.css' => plugin_stylesheets do |f|
      File.open(f.name, 'w+') do |io|
        f.prerequisites.each do |s|
            io.puts File.read(s)
        end
      end
    end
  end
end

