# frozen_string_literal: true

require 'spec_helper'

describe 'erlang' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }

      context 'with default params' do
        it { is_expected.to contain_class('erlang::repo') }

        it do
          is_expected.to contain_package('erlang')
            .with_ensure('installed')
            .with_name('erlang')
            .that_requires('Class[erlang::repo]')
        end
      end

      context 'with package parameters specified' do
        let(:params) do
          {
            package_name: 'erlang-custom',
            package_ensure: 'present',
          }
        end

        it { is_expected.to contain_package('erlang-custom').with_ensure('present').with_name('erlang-custom') }
      end

      context 'with manage_repo false' do
        let(:params) { { manage_repo: false } }

        it { is_expected.not_to contain_class('erlang::repo') }
        it { is_expected.to contain_package('erlang').with_ensure('installed').with_name('erlang') }
      end
    end
  end
end
