# erlang erlang_solutions apt repo
class erlang::repo::apt::erlang_solutions (
  String $ensure = $erlang::repo::apt::ensure,
  String $location    = "https://binaries2.erlang-solutions.com/${(downcase($facts['os']['distro']['id']))}",
  String $release     = "${downcase($facts['os']['distro']['codename'])}-esl-erlang-25",
  String $repos       = 'contrib',
  String $key         = '26F8ADE7441C97EBE03DFEEA218B8A806CEFF98B',
  String $key_source  = 'https://binaries2.erlang-solutions.com/GPG-KEY-pmanager.asc',
  Optional[Variant[Numeric, String]] $pin = $erlang::package_apt_pin,
) inherits erlang {
  apt::source { 'erlang-erlang_solutions':
    ensure   => $ensure,
    location => $location,
    release  => $release,
    repos    => $repos,
    key      => {
      'id'     => $key,
      'source' => $key_source,
    },
  }

  if $pin {
    apt::pin { 'erlang':
      packages => '*',
      priority => $pin,
      origin   => inline_template('<%= require \'uri\'; URI(@location).host %>'),
    }
  }
}
