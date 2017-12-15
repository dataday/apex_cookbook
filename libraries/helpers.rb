#
# Cookbook:: apex_cookbook
# Library:: helpers
#
# Copyright:: 2017, dataday, All Rights Reserved.
#
# Description
# Default helpers attached to chef recipes

require_relative 'helpers_release'

Chef::Recipe.send(:include, Apex::Helpers::DSL)
