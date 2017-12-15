#
# Cookbook:: apex_cookbook
# Spec:: default
#
# Copyright:: 2017, dataday, All Rights Reserved.
#
# Description
# Default tests for the default recipe used in the project

# allow net connections
WebMock.allow_net_connect!

describe 'apex_cookbook::default' do
  let(:bin_path) { '/opt/local/bin' }
  let(:etc_path) { '/etc/profile.d' }
  let(:tmp_path) { '/tmp/kitchen/cache' }
  let(:tmp_file) { '/tmp/kitchen/cache/apex' }

  let(:bin_path_resource) { 'directory[create bin path]' }
  let(:bin_file_resource) { 'execute[create bin file]' }
  let(:etc_file_resource) { 'template[create etc file]' }
  let(:tmp_file_resource) { 'file[delete tmp file]' }

  cached(:chef_run) {
    # for a complete list of available platforms and versions see:
    # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
    ChefSpec::SoloRunner.new(
      platform: 'centos',
      version: '7.2.1511'
    ).converge(described_recipe)
  }

  # allow File.exist? method
  def allow_file_exist
    allow(File).to receive(:exist?).and_return(true)
  end

  it 'converges successfully' do
    expect{ chef_run }.to_not raise_error
  end

  context 'cookbook attributes' do
    let(:apex) { chef_run.node[:apex_cookbook] }
    let(:tag_url) { 'https://api.github.com/repos/apex/apex/tags' }
    let(:rel_url) { 'https://github.com/apex/apex/releases/download/%s/apex_%s' }

    it { expect(apex[:name]).to eq 'apex' }
    it { expect(apex[:tmp]).to eq tmp_path }
    it { expect(apex[:bin]).to eq bin_path }
    it { expect(apex[:etc]).to eq etc_path }
    it { expect(apex[:owner]).to eq 'root' }
    it { expect(apex[:group]).to eq 'root' }
    it { expect(apex[:mode]).to eq 0755 }
    it { expect(apex[:releases]).to eq tag_url }
    it { expect(apex[:download]).to eq rel_url }

    describe 'platform support' do
      it { expect(apex[:platforms].keys).to eq %w(darwin linux openbsd clones) }
      it { expect(apex[:platforms][:darwin]).to eq %i[x86_64] }
      it { expect(apex[:platforms][:linux]).to eq %i[i686 x86_64] }
      it { expect(apex[:platforms][:openbsd]).to eq %i[amd64] }

      context 'supported clones' do
        it { expect(apex[:platforms][:clones].keys).to eq %w[x86_64] }
        it { expect(apex[:platforms][:clones][:x86_64]).to eq :amd64 }
      end
    end
  end

  context 'cookbook resources' do
    describe 'create bin path' do
      subject { chef_run.directory('create bin path') }
      it { is_expected.to do_nothing }
    end

    describe 'create bin file' do
      subject { chef_run.execute('create bin file') }
      it { is_expected.to do_nothing }
    end

    describe 'create etc file' do
      subject { chef_run.template('create etc file') }
      it { is_expected.to do_nothing }
    end

    describe 'delete tmp file' do
      subject { chef_run.file('delete tmp file') }
      it { is_expected.to do_nothing }
    end

    describe 'create tmp file' do
      subject { chef_run.remote_file('create tmp file') }
      it { is_expected.to notify(bin_path_resource).to(:create).immediately }
      it { is_expected.to notify(bin_file_resource).to(:run).immediately }
      it { is_expected.to notify(etc_file_resource).to(:create).immediately }
      it { is_expected.to notify(tmp_file_resource).to(:delete).immediately }

      context 'created tmp file' do
        subject { chef_run }
        it {
          is_expected.to create_remote_file(tmp_file).with(
            owner: 'root',
            group: 'root'
          )
        }
      end
    end
  end
end
