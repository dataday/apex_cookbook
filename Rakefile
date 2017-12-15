#!/usr/bin/env ruby -w
# encoding: UTF-8
require 'yard'

root = File.expand_path(__dir__)
ci_env = ENV['CI'] ? true : false

dir_results = "#{root}/results"
dir_specs = "#{root}/spec"

dir_docs = "#{dir_results}/docs"
file_unit_tests = "#{dir_results}/tests/spec-results"

cmd = {
  rspec: {
    spec: "chef exec bundle exec rspec #{dir_specs} ",
    spec_ci: "--format documentation --out #{file_unit_tests}.txt --format RspecJunitFormatter --out #{file_unit_tests}.xml"
  },
  kitchen: {
    test: 'chef exec kitchen test'
  },
  docs: {
    standard: "chef exec bundle exec yardoc '**/*.rb' ",
    chef_option: "--plugin chefdoc"
  }
}

namespace :spec do
  desc 'Runs associated tests with optional JUnit formatter'
  task :run do
    cmd_spec = cmd[:rspec][:spec]
    cmd_spec.concat cmd[:rspec][:spec_ci] if ci_env
    system(cmd_spec)
  end
end

namespace :docs do
  desc 'Generates associated documentation'
  task :standard, [:type] do |t, args|
    type = args[:type] ||= :standard
    cmd_docs = cmd[:docs][:standard]
    cmd_docs.concat "--output-dir #{dir_docs}/#{type} "
    cmd_docs.concat cmd[:docs][:chef_option] if type == :cookbook
    system(cmd_docs)
  end
  task :cookbook do
    Rake::Task['docs:standard'].invoke(:cookbook)
  end
end

namespace :kitchen do
  desc 'Runs KitchenCI tests'
  task :test do
    ENV['KITCHEN_YAML'] = "#{root}/.kitchen.ci.yml" if ci_env
    system(cmd[:kitchen][:test])
  end
end

task :default => 'spec:run'
