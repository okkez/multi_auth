
class MultiAuthMigrationGenerator < Rails::Generator::NamedBase
  def initialize(runtime_args, runtime_options = { })
    super
  end

  def manifest
    record do |m|
      m.directory('db/migrate')
      m.migration_template('migration.rb', 'db/migrate')
    end
  end
end
