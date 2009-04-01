class ActsAsSecureUrlGenerator < Rails::Generator::NamedBase

  def initialize(runtime_args, runtime_options = {})
    super
    @model_name = ARGV[0]
    @controller_name = (ARGV[1] || @model_name).pluralize
    @migration_file_name = "#{@model_name.downcase.pluralize}_acts_as_secure_url"
  end

  def manifest
    record do |m|
      # m.directory "lib"
      # m.template 'README', "README"
      m.directory "app/models"
      m.template "model.rb", "app/models/#{class_name.downcase}.rb"
      m.template "controller.rb", "app/controllers/#{@controller_name.downcase}_controller.rb", :assigns => {:controller_name => @controller_name}
      unless options[:skip_migration]
        m.migration_template "migration.rb", "db/migrate", :migration_file_name => @migration_file_name
      end
      m.route_resource("#{@controller_name.downcase}")
      m.route_name("#{@controller_name.downcase}_direct", "#{@controller_name.downcase}/:public_key/:id", {:controller => @controller_name.downcase, :action => 'create'})
      m.template "site_keys.rb", "config/initializers/site_keys.rb"
      m.template "spec/controllers/controller_spec.rb", "spec/controllers/#{@controller_name.downcase}_controller_spec.rb", :assigns => {:controller_name => @controller_name}
      m.template "spec/models/model_spec.rb", "spec/models/#{class_name.downcase}_spec.rb"
    end
  end
  
  protected
  
  
  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--skip-migration",
      "Don't generate a migration file for this model") { |o| options[:skip_migration] = o }
    opt.on("--persist-public-key",                                   
      "Persists public keys in the database") { |o| options[:persist_public_key] = true }
  end

  
end

Rails::Generator::Commands::Create.class_eval do
  def route_resource(*resources)
    resource_list = resources.map { |r| r.to_sym.inspect }.join(', ')
    sentinel = 'ActionController::Routing::Routes.draw do |map|'

    logger.route "map.resource #{resource_list}"
    unless options[:pretend]
      gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
        "#{match}\n  map.resource #{resource_list}\n"
      end
    end
  end
  
  def route_name(name, path, route_options = {})
    sentinel = 'ActionController::Routing::Routes.draw do |map|'
    
    logger.route "map.#{name} '#{path}', :controller => '#{route_options[:controller]}', :action => '#{route_options[:action]}'"
    unless options[:pretend]
      gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
        "#{match}\n  map.#{name} '#{path}', :controller => '#{route_options[:controller]}', :action => '#{route_options[:action]}'"
      end
    end
  end
  
  
end