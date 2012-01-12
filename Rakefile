#!/usr/bin/env ruby
require 'redmine_plugin_support'

Dir[File.expand_path(File.dirname(__FILE__)) + "/lib/tasks/**/*.rake"].sort.each { |ext| load ext }

RedminePluginSupport::Base.setup do |plugin|
  plugin.project_name = 'redmine_nota_di_rilascio'
  plugin.default_task = [:doc]
end
begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "redmine_nota_di_rilascio"
    s.summary = "Questo plugin aggiunge una wiki macro per agevolare il recupero di informazioni relative ad una segnalazione in una pagina wiki allo scopo di creare note di rilascio."
    s.email = "andrea.saccavini@dedagroup.it"
    s.homepage = ""
    s.description = "Questo plugin aggiunge una wiki macro per agevolare il recupero di informazioni relative ad una segnalazione in una pagina wiki allo scopo di creare note di rilascio."
    s.authors = ["Andrea Saccavini"]
    s.rubyforge_project = ""
    s.files =  FileList[
                        "[A-Z]*",
                        "init.rb",
                        "rails/init.rb",
                        "{bin,generators,lib,test,app,assets,config,lang}/**/*",
                        'lib/jeweler/templates/.gitignore'
                       ]
  end
  Jeweler::GemcutterTasks.new
  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "doc"
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

