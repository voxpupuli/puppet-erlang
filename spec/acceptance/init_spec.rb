# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'erlang init:' do
  case fact('os.family')
  when 'RedHat'
    default_repo_source = 'packagecloud'
    repo_source_list = %w[erlang_solutions packagecloud]
  when 'Debian'
    default_repo_source = 'erlang_solutions'
    repo_source_list = %w[erlang_solutions cloudsmith]
  end

  case fact('os.family')
  when 'RedHat'
    context 'default class declaration' do
      let(:pp) do
        <<-EOS
        class { 'erlang': }
        EOS
      end

      it_behaves_like 'an idempotent resource'

      describe package('erlang') do
        it { is_expected.to be_installed }
      end

      describe yumrepo("erlang-#{default_repo_source}") do
        it { is_expected.to exist }
        it { is_expected.to be_enabled }
      end
    end

    context 'removing package and default repo_source' do
      let(:pp) do
        <<-EOS
        class { 'erlang':
          package_ensure => 'absent',
          repo_ensure => 'absent',
        }
        EOS
      end

      it_behaves_like 'an idempotent resource'

      describe package('erlang') do
        it { is_expected.not_to be_installed }
      end

      describe yumrepo("erlang-#{default_repo_source}") do
        it { is_expected.not_to exist }
      end
    end

    repo_source_list.each do |repo_source|
      context "with repo source set to #{repo_source}" do
        let(:pp) do
          <<-EOS
          class { 'erlang':
            repo_source => '#{repo_source}',
          }
          EOS
        end

        it_behaves_like 'an idempotent resource'

        describe package('erlang') do
          it { is_expected.to be_installed }
        end

        describe yumrepo("erlang-#{repo_source}") do
          it { is_expected.to exist }
          it { is_expected.to be_enabled }
        end
      end

      context "removing package and repo source: #{repo_source}" do
        if repo_source == 'erlang_solutions'
          # erlang solutions installs a bunch of broken erlang packages that need
          # to be uninstalled concurrently (erlang and erlang-examples are mutually dependent)
          let(:pp) do
            <<-EOS
            exec { 'yum -y erase erlang*':
              onlyif => 'yum list installed | grep erlang',
              path   => ['/usr/bin', '/bin'],
            }
            class { 'erlang':
              package_ensure => 'absent',
              repo_source => '#{repo_source}',
              repo_ensure => 'absent',
            }
            EOS
          end
        else
          let(:pp) do
            <<-EOS
            class { 'erlang':
              package_ensure => 'absent',
              repo_source => '#{repo_source}',
              repo_ensure => 'absent',
            }
            EOS
          end
        end

        it_behaves_like 'an idempotent resource'

        describe package('erlang') do
          it { is_expected.not_to be_installed }
        end

        describe yumrepo("erlang-#{default_repo_source}") do
          it { is_expected.not_to exist }
        end
      end
    end

    # epel is special in that it enables the epel repo not the erlang-epel repo
    context 'with repo source set to epel' do
      let(:pp) do
        <<-EOS
        class { 'erlang': repo_source => 'epel' }
        EOS
      end

      it_behaves_like 'an idempotent resource'

      describe package('erlang') do
        it { is_expected.to be_installed }
      end

      describe yumrepo('epel') do
        it { is_expected.to exist }
        it { is_expected.to be_enabled }
      end
    end

    context 'removing package and repo source: epel' do
      # erlang solutions installs a bunch of broken erlang packages that need
      # to be uninstalled concurrently (erlang and erlang-examples are mutually dependent)
      let(:pp) do
        <<-EOS
        exec { 'yum -y erase erlang*':
          onlyif => 'yum list installed | grep erlang',
          path   => ['/usr/bin', '/bin'],
        }
        class { 'erlang':
          package_ensure => 'absent',
          repo_source => 'epel',
          repo_ensure => 'absent',
        }
        EOS
      end

      it_behaves_like 'an idempotent resource'

      describe package('erlang') do
        it { is_expected.not_to be_installed }
      end
    end
  when 'Debian'
    context 'default class declaration' do
      let(:pp) do
        <<-EOS
        class { 'erlang': }
        EOS
      end

      it_behaves_like 'an idempotent resource'

      describe package('erlang') do
        it { is_expected.to be_installed }
      end
    end

    repo_source_list.each do |repo_source|
      context "with repo source set to #{repo_source}" do
        package_name = if fact('os.distro.codename') == 'bionic' && repo_source == 'cloudsmith'
                         'erlang-base'
                       else
                         'erlang'
                       end

        let(:pp) do
          <<-EOS
          class { 'erlang': repo_source => '#{repo_source}', package_name => '#{package_name}' }
          EOS
        end

        if fact('os.distro.codename') == 'stretch' && repo_source == 'cloudsmith'
          it { expect(apply_manifest(pp, expect_failures: true).stderr).to match('cloudsmith does not support this debian release') }
        else
          it_behaves_like 'an idempotent resource'

          describe package(package_name) do
            it { is_expected.to be_installed }
          end
        end
      end

      context "removing package and repo source: #{repo_source}" do
        package_name = if fact('os.distro.codename') == 'bionic' && repo_source == 'cloudsmith'
                         'erlang-base'
                       else
                         'erlang'
                       end

        let(:pp) do
          <<-EOS
          class { 'erlang':
            package_ensure => 'absent',
            package_name => '#{package_name}',
            repo_source => '#{repo_source}',
            repo_ensure => 'absent',
          }
          EOS
        end

        if fact('os.distro.codename') == 'stretch' && repo_source == 'cloudsmith'
          it { expect(apply_manifest(pp, expect_failures: true).stderr).to match('cloudsmith does not support this debian release') }
        else
          it_behaves_like 'an idempotent resource'

          describe package(package_name) do
            it { is_expected.not_to be_installed }
          end
        end
      end
    end
  end
end
