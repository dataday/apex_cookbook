# # encoding: utf-8

# Inspec test for recipe apex_cookbook::default
#
# Copyright:: 2017, dataday, All Rights Reserved.
#
# Description
# Default InSpec tests used in the project
# @see http://inspec.io/docs/reference/resources/

bin_path = '/opt/local/bin'
etc_file = '/etc/profile.d/apex.sh'
bin_file = '/opt/local/bin/apex'
tmp_path = '/tmp/kitchen/cache'
tmp_file = '/tmp/kitchen/cache/apex'

control 'apex_cookbook' do
  impact 0.1
  title 'Recipe'
  desc 'Apex cookbook recipe'

  describe user('root') do
    it { should exist }
  end

  describe group('root') do
    it { should exist }
  end

  describe 'tmp directory' do
    subject { directory(tmp_path) }
    it { should exist }
    it { should be_directory }
  end

  describe 'create bin path' do
    subject { directory(bin_path) }
    it { should exist }
    it { should be_directory }
    its('mode') { should cmp '0755' }
  end

  describe 'create bin file' do
    subject { file(bin_file) }
    it { should exist }
    it { should be_file }
    it { should be_executable.by_user('root') }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0755' }
    its('size') { should be > 10485760 } # > 10mb
  end

  describe 'create etc file' do
    subject { file(etc_file) }
    it { should exist }
    it { should be_file }
    it { should be_executable.by_user('root') }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0755' }
    its('content') { should eq "export PATH=$PATH:#{bin_path}\n" }
  end

  describe 'delete tmp file' do
    subject { file(tmp_file) }
    it { should_not exist }
  end
end
