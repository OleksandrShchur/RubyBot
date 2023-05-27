require 'rubygems'
require 'bundler/setup'


require 'pg'
require 'active_record'
require 'yaml'


namespace :db do

 desc 'Migrate the database'
 task :migrate do
   connection_details = YAML::load(File.open("config/database.yml"))
   p connection_details
   ActiveRecord::Base.establish_connection(connection_details)
   puts ActiveRecord.version.version
  # ActiveRecord::Migration.migrate("db/migrate/")
  ActiveRecord::MigrationContext.new("db/migrate",ActiveRecord::SchemaMigration).migrate

end


desc 'Create the database'
task :create do
#заповнити
end


desc 'Drop the database'
task :drop do
#заповнити
end
end
