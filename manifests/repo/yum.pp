# erlang yum repo
class erlang::repo::yum (
  Enum['absent','present'] $ensure = $erlang::repo_ensure,
  Erlang::RepoSource $source = $erlang::repo_source,
  Variant[Stdlib::HTTPSUrl,Enum['absent']] $erlang_solutions_baseurl = "https://packages.erlang-solutions.com/rpm/centos/\$releasever/\$basearch",
  Variant[Stdlib::HTTPSUrl,Enum['absent']] $erlang_solutions_gpgkey = 'https://packages.erlang-solutions.com/rpm/erlang_solutions.asc',
  Variant[Stdlib::HTTPSUrl,Enum['absent']] $packagecloud_baseurl = "https://packagecloud.io/rabbitmq/erlang/el/${$facts['os']['release']['major']}/\$basearch",
  Variant[Stdlib::HTTPSUrl,Enum['absent']] $packagecloud_gpgkey = 'https://packagecloud.io/rabbitmq/erlang/gpgkey'
) inherits erlang {
  case $source {
    'epel': {
      # include epel instead of contain because lots of other stuff declares epel
      include epel
      # specifically declare dependency on epel repo
      Class['epel'] -> Package[$erlang::package_name]
    }
    'erlang_solutions': {
      # erlang_solutions package requires things from EPEL
      # include epel instead of contain because lots of other stuff declares epel
      include epel
      # specifically declare dependency on epel repo
      Class['epel'] -> Package[$erlang::package_name]
      yumrepo { 'erlang-erlang_solutions':
        ensure   => $ensure,
        name     => 'erlang-erlang_solutions',
        baseurl  => $erlang_solutions_baseurl,
        enabled  => '1',
        gpgcheck => '1',
        gpgkey   => $erlang_solutions_gpgkey,
      }
    }
    'packagecloud': {
      yumrepo { 'erlang-packagecloud':
        ensure        => $ensure,
        name          => 'erlang-packagecloud',
        baseurl       => $packagecloud_baseurl,
        enabled       => '1',
        gpgcheck      => '0',
        repo_gpgcheck => '1',
        gpgkey        => $packagecloud_gpgkey,
      }
    }
    default: {
      fail("Only 'packagecloud', 'epel' repo_source are supported for Yum repos, the following is not supported: ${source}")
    }
  }
}
