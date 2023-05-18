# frozen_string_literal: true

require 'spec_helper'

describe 'erlang::repo::apt::cloudsmith' do # rubocop:disable RSpec/EmptyExampleGroup
  on_supported_os.each do |os, facts|
    case facts[:os]['family']
    when 'Debian'
      context "on #{os}" do
        let(:facts) { facts }
        let(:release) { facts[:os]['distro']['codename'] }

        if facts[:os]['distro']['codename'] == 'stretch'
          it { is_expected.to raise_error(Puppet::Error, %r{cloudsmith does not support this debian release}) }
        else
          it { is_expected.to compile.with_all_deps }

          context 'with default parameters' do
            it do
              is_expected.to contain_apt__source('erlang-cloudsmith').
                with('ensure' => 'present',
                     'location' => "https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/deb/#{facts[:os]['name'].downcase}",
                     'release' => release,
                     'repos' => 'main',
                     'key' => {
                       'id' => 'A16A42516F6A691BC1FF5621E495BB49CC4BBE5B',
                       'source' => 'https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/gpg.E495BB49CC4BBE5B.key'
                     })
            end
          end
        end
      end
    end
  end
end
