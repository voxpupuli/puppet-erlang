# frozen_string_literal: true

require 'spec_helper'

describe 'erlang::repo::apt' do # rubocop:disable RSpec/EmptyExampleGroup
  on_supported_os.each do |os, facts|
    case facts[:os]['family']
    when 'Debian'
      context "on #{os}" do
        let(:facts) { facts }

        context 'with source set to erlang_solutions' do
          let(:params) { { source: 'erlang_solutions' } }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('erlang::repo::apt::erlang_solutions') }
        end

        context 'with source set to cloudsmith' do # rubocop:disable RSpec/EmptyExampleGroup
          let(:params) { { source: 'cloudsmith' } }

          case facts[:os]['distro']['codename']
          when 'stretch'
            it { is_expected.to raise_error(Puppet::Error, %r{cloudsmith does not support this debian release}) }
          else
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_class('erlang::repo::apt::cloudsmith') }
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
