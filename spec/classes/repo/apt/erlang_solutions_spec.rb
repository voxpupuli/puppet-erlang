require 'spec_helper'

describe 'erlang::repo::apt::erlang_solutions' do
  on_supported_os.each do |os, facts|
    case facts[:os]['family']
    when 'Debian'
      context "on #{os}" do
        let(:facts) { facts }
        let(:release) { facts[:os]['distro']['codename'] }

        it { is_expected.to compile.with_all_deps }

        context 'with default parameters' do
          it do
            is_expected.to contain_apt__source('erlang-erlang_solutions').
              with('ensure'   => 'present',
                   'location' => 'https://packages.erlang-solutions.com/debian',
                   'release'  => release,
                   'repos'    => 'contrib',
                   'key'      => {
                     'id'     => '434975BD900CCBE4F7EE1B1ED208507CA14F4FCA',
                     'source' => 'https://packages.erlang-solutions.com/debian/erlang_solutions.asc'
                   })
            is_expected.to contain_apt__pin('erlang-erlang_solutions').
              with('priority' => 600)
          end
        end
      end
    end
  end
end
