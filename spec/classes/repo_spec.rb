# frozen_string_literal: true

require 'spec_helper'

describe 'erlang::repo' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }

      case facts[:os]['family']
      when 'RedHat'
        it { is_expected.to contain_class('erlang::repo::yum') }
      end
    end
  end

  context 'on unsupported os' do
    let(:facts) { { os: { family: 'Unsupported' } } }

    it { is_expected.to compile.and_raise_error(%r{The only supported OS families are 'Debian' and 'RedHat'}) }
  end
end
