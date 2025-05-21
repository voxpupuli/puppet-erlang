# frozen_string_literal: true

require 'spec_helper'

describe 'erlang::repo::apt::erlang_solutions' do # rubocop:disable RSpec/EmptyExampleGroup
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
              with('ensure' => 'present',
                   'location' => 'https://packages.erlang-solutions.com/debian',
                   'release' => release,
                   'repos' => 'contrib',
                   'key' => {
                     'id' => 'A476FFB0288ADC13FE8B91A7708D410964E7272E',
                     'source' => 'https://binaries2.erlang-solutions.com/GPG-KEY-pmanager.asc'
                   })
          end
        end
      end
    end
  end
end
