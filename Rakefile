# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

require 'tasks/rails'


PKG_FILES = FileList[
                     'app/**/*.{rb,erb}',
                     'config/*',
                     'db/*',
                     'lib/**/*.rb',
                     'public/**/*',
                     'rails/init.rb',
                     'generators/**/*',
                     'test/**/*.rb'
                    ]

spec = Gem::Specification.new do |s|
  s.name             = ENV['GEM_NAME'] || 'multi_auth'
  s.version          = '0.0.2dev'
  s.author           = 'okkez'
  s.email            = ''
  s.homepage         = 'https://github.com/okkez/multi_auth'
  s.platform         = Gem::Platform::RUBY
  s.summary          = "This Rails plugin provides basic login fanctionality"
  s.files            = PKG_FILES.to_a
  s.require_path     = 'lib'
  s.has_rdoc         = true
  s.extra_rdoc_files = ['README']

  s.add_dependency("okkez-open_id_authentication")
  s.add_dependency("validates_email_format_of")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Create or Update gemspec file"
task :gemspec do
  File.open("#{spec.name}.gemspec", 'w+'){|file| file.puts(spec.to_ruby) }
end
