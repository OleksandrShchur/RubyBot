require 'rubygems'
require 'bundler/setup'
require 'sqlite3'
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
  ActiveRecord::MigrationContext.new("db/migrate",ActiveRecord::SchemaMigration).migrate

end

desc 'With sqlite'
 task :sqlite do
   connection_details = YAML::load(File.open("config/database_sqlite.yml"))
   p connection_details
   ActiveRecord::Base.establish_connection(connection_details)
   ActiveRecord::MigrationContext.new("db/migrate",ActiveRecord::SchemaMigration).migrate

end


desc 'Create the database'
task :create do
  connection_details = YAML::load(File.open("config/database.yml"))
  p admin_connection
  ActiveRecord::Base.establish_connection(admin_connection)
  ActiveRecord::Base.connection.create_database(connection_details.fetch("database"))

end


desc 'Drop the database'
task :drop do
  connection_details = YAML::load(File.open("config/database.yml"))
  p connection_details
  admin_connection = connection_details.merge('database' => 'postgres', 'schema_search_path' => 'public')
  ActiveRecord::Base.establish_connection(admin_connection)
  ActiveRecord::Base.connection.drop_database(connection_details.fetch('database'))
  end
end