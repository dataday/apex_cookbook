#
# Cookbook:: apex_cookbook
# Spec:: helpers
#
# Copyright:: 2017, dataday, All Rights Reserved.
#
# Description
# Default tests for release helper used in the project

require File.expand_path('../../../libraries/helpers_release', __dir__)

describe 'libraries' do
  let(:release_class) {
    # mock object for module inclusion
    Class.new {
      # include Utils module
      include Apex::Helpers::Release
      # call #new (rspec > 3.3.0)
    }.new
  }

  let(:platforms) {{
    darwin:   %i[x86_64],
    linux:    %i[i686 x86_64],
    openbsd:  %i[amd64],
    clones:   { x86_64: :amd64 }
  }}

  # allow references to is_platform_supported? method
  def allow_is_platform_supported?
    allow_any_instance_of(Apex::Helpers::Release).to receive(
      :is_platform_supported?
    )
  end

  # allow references to get_supported_platform method
  def allow_get_supported_platform
    allow_any_instance_of(Apex::Helpers::Release).to receive(
      :get_supported_platform
    )
  end

  def get_name_arch(fixture)
    fixture[:input][:platform]
  end

  describe Apex::Helpers::Release do
    context '#get_release' do
      it 'returns expected release' do
        fixture = {
          input: {
            platform: %i[linux x86_64],
            platforms: platforms
          },
          result: 'linux_amd64'
        }

        allow_get_supported_platform.and_return(fixture[:result])
        result = release_class.send(:get_release, fixture[:input])
        expect(result).to eq fixture[:result]
      end
    end

    context '#get_version' do
      it 'returns expected version' do
        fixture = {
          input: {
            releases: 'https://domain.co.uk/path/to/json_resource.json',
            body: '[{"name": "v0.16.0"}]',
            status: 200
          },
          result: 'v0.16.0'
        }

        stub_request(:any, fixture[:input][:releases]).to_return(
          status: fixture[:input][:status],
          body: fixture[:input][:body]
        )

        result = release_class.send(:get_version, fixture[:input])
        expect(result).to eq(fixture[:result])
      end
    end

    context '#is_platform_supported?' do
      it 'returns true for supported platforms' do
        allow_is_platform_supported?.and_return(true)
        result = release_class.send(
          :is_platform_supported?,
          :foo,
          :bar,
          platforms
        )
        expect(result).to eq true
      end

      it 'returns false for unsupported platforms' do
        allow_is_platform_supported?.and_return(false)
        result = release_class.send(
          :is_platform_supported?,
          :foo,
          :bar,
          platforms
        )
        expect(result).to eq false
      end
    end

    context '#get_platform_clone' do
      it 'returns platform clone' do
        fixture = {
          input: :x86_64,
          result: :amd64
        }

        result = release_class.send(
          :get_platform_clone,
          fixture[:input],
          platforms
        )
        expect(result).to eq fixture[:result]
      end

      it 'returns platform original' do
        fixture = {
          input: :i686,
          result: :i686
        }

        result = release_class.send(
          :get_platform_clone,
          fixture[:input],
          platforms
        )
        expect(result).to eq fixture[:result]
      end
    end

    context '#get_supported_platform' do
      before(:each) { allow_is_platform_supported?.and_return(true) }

      it 'returns darwin x86_64 platform as amd64 clone' do
        fixture = {
          input: { platform: %i[darwin x86_64] },
          result: 'darwin_amd64'
        }

        name, arch = get_name_arch(fixture)
        result = release_class.send(
          :get_supported_platform,
          name,
          arch,
          platforms
        )
        expect(result).to eq fixture[:result]
      end

      it 'returns linux x86_64 platform as amd64 clone' do
        fixture = {
          input: { platform: %i[linux x86_64] },
          result: 'linux_amd64'
        }

        name, arch = get_name_arch(fixture)
        result = release_class.send(
          :get_supported_platform,
          name,
          arch,
          platforms
        )
        expect(result).to eq fixture[:result]
      end

      it 'returns linux i686 platform as i686' do
        fixture = {
          input: { platform: %i[linux i686] },
          result: 'linux_i686'
        }

        name, arch = get_name_arch(fixture)
        result = release_class.send(
          :get_supported_platform,
          name,
          arch,
          platforms
        )
        expect(result).to eq fixture[:result]
      end

      it 'returns openbsd amd64 platform as amd64' do
        fixture = {
          input: { platform: %i[openbsd amd64] },
          result: 'openbsd_amd64'
        }

        name, arch = get_name_arch(fixture)
        result = release_class.send(
          :get_supported_platform,
          name,
          arch,
          platforms
        )
        expect(result).to eq fixture[:result]
      end

      it 'returns nil for unsupported platform' do
        fixture = {
          input: { platform: %i[foo bar] },
          result: nil
        }

        allow_is_platform_supported?.and_return(false)
        name, arch = get_name_arch(fixture)
        result = release_class.send(
          :get_supported_platform,
          name,
          arch,
          platforms
        )
        expect(result).to eq fixture[:result]
      end
    end

    context '#get_json' do
      it 'returns valid json' do
        fixture = {
          input: {
            url: URI('https://domain.co.uk/path/to/json_resource.json'),
            body: '{"foo": "bar"}',
            status: 200
          },
          result: { foo: 'bar' }
        }

        stub_request(:any, fixture[:input][:url]).to_return(
          status: fixture[:input][:status],
          body: fixture[:input][:body]
        )

        result = release_class.send(:get_json, fixture[:input][:url])
        expect(result).to eq fixture[:result]
      end

      it 'returns empty list for invalid json' do
        fixture = {
          input: {
            url: URI('https://domain.co.uk/path/to/json_resource.json'),
            body: '---',
            status: 200
          },
          result: []
        }

        stub_request(:any, fixture[:input][:url]).to_return(
          status: fixture[:input][:status],
          body: fixture[:input][:body]
        )

        result = release_class.send(:get_json, fixture[:input][:url])
        expect(result).to eq fixture[:result]
      end
    end
  end
end
