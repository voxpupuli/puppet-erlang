# frozen_string_literal: true

require 'spec_helper'

describe 'erlang::repo::apt::erlang_solutions' do # rubocop:disable RSpec/EmptyExampleGroup
  on_supported_os.each do |os, facts|
    case facts[:os]['family']
    when 'Debian'
      context "on #{os}" do
        let(:facts) { facts }
        let(:release) { facts[:os]['distro']['codename'] }
        let(:name) { facts[:os]['name'].downcase }

        it { is_expected.to compile.with_all_deps }

        context 'with default parameters' do
          it do
            is_expected.to contain_apt__source('erlang-erlang_solutions').
              with('ensure' => 'present',
                   'location' => "https://binaries2.erlang-solutions.com/#{name}",
                   'release' => "#{release}-esl-erlang-25",
                   'repos' => 'contrib',
                   'key' => {
                     'id' => '26F8ADE7441C97EBE03DFEEA218B8A806CEFF98B',
                     'source' => 'https://binaries2.erlang-solutions.com/GPG-KEY-pmanager.asc'
                   })
          end
        end
      end
    end
  end
end
