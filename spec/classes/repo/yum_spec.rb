# frozen_string_literal: true

require 'spec_helper'

describe 'erlang::repo::yum' do # rubocop:disable RSpec/EmptyExampleGroup
  on_supported_os.each do |os, facts|
    case facts[:os]['family']
    when 'RedHat'
      context "on #{os}" do
        let(:facts) { facts }

        it { is_expected.to compile.with_all_deps }

        context 'with default parameters' do
          it do
            is_expected.to contain_yumrepo('erlang-packagecloud').
              with('ensure' => 'present',
                   'name' => 'erlang-packagecloud',
                   'baseurl' => "https://packagecloud.io/rabbitmq/erlang/el/#{facts[:os]['release']['major']}/$basearch",
                   'enabled' => '1',
                   'gpgcheck' => '0',
                   'repo_gpgcheck' => '1',
                   'gpgkey' => 'https://packagecloud.io/rabbitmq/erlang/gpgkey')
          end
        end

        context 'with source set to epel' do
          let(:params) { { source: 'epel' } }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('epel').that_comes_before('Package[erlang]') }
        end

        context 'with source set to erlang_solutions' do
          let(:params) { { source: 'erlang_solutions' } }

          it { is_expected.to compile.with_all_deps }

          context 'with default parameters' do
            it do
              is_expected.to contain_yumrepo('erlang-erlang_solutions').
                with('ensure' => 'present',
                     'name' => 'erlang-erlang_solutions',
                     'baseurl' => 'https://packages.erlang-solutions.com/rpm/centos/$releasever/$basearch',
                     'enabled' => '1',
                     'gpgcheck' => '1',
                     'gpgkey' => 'https://packages.erlang-solutions.com/rpm/erlang_solutions.asc')
            end
          end
        end

        context 'with source set to packagecloud' do
          let(:params) { { source: 'packagecloud' } }

          it { is_expected.to compile.with_all_deps }

          context 'with default parameters' do
            it do
              is_expected.to contain_yumrepo('erlang-packagecloud').
                with('ensure' => 'present',
                     'name' => 'erlang-packagecloud',
                     'baseurl' => "https://packagecloud.io/rabbitmq/erlang/el/#{facts[:os]['release']['major']}/$basearch",
                     'enabled' => '1',
                     'gpgcheck' => '0',
                     'repo_gpgcheck' => '1',
                     'gpgkey' => 'https://packagecloud.io/rabbitmq/erlang/gpgkey')
            end
          end
        end

        context 'with source set to invalid' do
          let(:params) { { source: 'invalid' } }

          it { is_expected.to compile.and_raise_error(%r{parameter 'source' expects a match for}) }
        end
      end
    end
  end
end
