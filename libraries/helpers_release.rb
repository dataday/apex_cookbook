#
# Cookbook:: apex_cookbook
# Library:: helpers_release
#
# Copyright:: 2017, dataday, All Rights Reserved.
#
# Description
# Helpers for release functionality used in the project

require 'net/http'
require 'json'

# Namespace for classes and modules to expose Apex helpers
# @author dataday
# @since 0.1.0
module Apex
  module Helpers
    module Release
      extend self

      # Gets release platform
      # @param node [Hash] node data
      # @return [String] platform, 'name_platform'
      def get_release(node)
        unless node[:platform].nil? || node[:platforms].nil?
          platforms = node[:platforms]
          name, arch = node[:platform]
          get_supported_platform(name, arch, platforms)
        end
      end

      # Gets release version
      # @param node [Hash] node data
      # @return [String] version, 'vN.N.N'
      def get_version(node)
        return if node[:releases].nil?
        url = URI(node[:releases])
        releases = get_json(url)
        if releases.any?
          version = releases.first
          version[:name] if version.key? :name
        end
      end

      private

      # Determines supported architecture
      # @param name [String] name
      # @param arch [String] architecture
      # @param platforms [Hash] supported platforms
      # @return [Boolean] if successful true, otherwise false
      def is_platform_supported?(name, arch, platforms)
        platform = platforms.key?(name) ? platforms[name] : Array.new
        platform.include? arch
      end

      # Determines supported clone
      # @param arch [String] architecture
      # @param platforms [Hash] supported platforms
      # @return [Boolean] if successful true, otherwise false
      def get_platform_clone(arch, platforms)
        clones = platforms[:clones]
        clones.key?(arch) ? clones[arch] : arch
      end

      # Gets supported platform
      # @param name [String] name
      # @param arch [String] architecture
      # @param platforms [Hash] supported platforms
      # @return [String] platform, 'name_platform'
      def get_supported_platform(name, arch, platforms)
        if is_platform_supported?(name, arch, platforms)
          platform = get_platform_clone(arch, platforms)
          "#{name}_#{platform}" unless platform.nil?
        end
      end

      # Gets JSON data
      # @param url [String] URL
      # @return [mixed] data
      # @todo rethrow error
      def get_json(url)
        unless url.nil?
          json = Net::HTTP.get(url)
          JSON.parse json, { symbolize_names: true }
        end
      rescue JSON::ParserError
        []
      end
    end

    module DSL
      # @see Apex::Helpers::Release.get_release
      def get_release(node) Apex::Helpers::Release.get_release(node) end
      # @see Apex::Helpers::Release.get_version
      def get_version(node) Apex::Helpers::Release.get_version(node) end
    end
  end
end
