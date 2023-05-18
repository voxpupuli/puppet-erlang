# @summary Manages the Erlang repository hosted on cloudsmith for debian based systems.
#
# @param [Stdlib::HTTPSUrl] location
#   Repository location / url
#
# @param [String] release
#   Specifies a distribution of the Apt repository.
#
# @param [String] repos
#   Specifies a component of the Apt repository.
#
# @param [String] key
#   Repository public key id of signage key.
#
# @param [Stdlib::HTTPSUrl] key_source
#   Location / url / source of the repository public key part for signage.
#
class erlang::repo::apt::cloudsmith (
  Stdlib::HTTPSUrl $location   = downcase("https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/deb/${facts['os']['name']}"),
  String[1] $release           = downcase($facts['os']['distro']['codename']),
  String[1] $repos             = 'main',
  String[1] $key               = 'A16A42516F6A691BC1FF5621E495BB49CC4BBE5B',
  Stdlib::HTTPSUrl $key_source = 'https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/gpg.E495BB49CC4BBE5B.key',
) {
  include erlang

  if ($facts['os']['name'] == 'debian' and versioncmp($facts['os']['release']['major'], '10') < 0 ) {
    fail('cloudsmith does not support this debian release')
  }

  apt::source { 'erlang-cloudsmith':
    ensure   => $erlang::repo_ensure,
    location => $location,
    release  => $release,
    repos    => $repos,
    key      => {
      'id'     => $key,
      'source' => $key_source,
    },
  }

  if $erlang::package_apt_pin {
    apt::pin { 'erlang':
      packages => '*',
      priority => $erlang::package_apt_pin,
      origin   => inline_template('<%= require \'uri\'; URI(@location).host %>'),
    }
  }
}
