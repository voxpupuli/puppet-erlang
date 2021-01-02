require 'spec_helper'

describe 'erlang::repo::apt::bintray' do
  on_supported_os.each do |os, facts|
    case facts[:os]['family']
    when 'Debian'
      context "on #{os}" do
        let(:facts) { facts }
        let(:release) { facts[:os]['distro']['codename'] }

        it { is_expected.to compile.with_all_deps }

        context 'with default parameters' do
          it do
            is_expected.to contain_apt__source('erlang-bintray').
              with('ensure'   => 'present',
                   'location' => 'https://dl.bintray.com/rabbitmq-erlang/debian',
                   'release'  => release,
                   'repos'    => 'erlang',
                   'key'      => {
                     'id'     => '0A9AF2115F4687BD29803A206B73A36E6026DFCA',
                     'source' => 'https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc'
                   })
            is_expected.to contain_apt__pin('erlang-bintray').
              with('priority' => 600)
          end
        end
      end
    end
  end
end
