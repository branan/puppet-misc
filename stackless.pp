class stackless (
  $revision,
  $destdir = '/opt/stackless'
) {
  file { $destdir:
    ensure => directory,
  }

  vcsrepo { 'stackless':
    path     => "${destdir}/source",
    source   => 'http://hg.python.org/stackless/',
    ensure   => latest,
    revision => $revision,
    provider => hg,
    require  => File[$destdir],
  }

  exec { "${destdir}/source/configure --prefix=${destdir}":
    cwd         => "${destdir}/source",
    refreshonly => true,
    subscribe   => Vcsrepo['stackless'],
  }

  exec { "/usr/bin/make -j${::processorcount}":
    cwd         => "${destdir}/source",
    refreshonly => true,
    subscribe   => Exec["${destdir}/source/configure --prefix=${destdir}"],
  }

  exec { '/usr/bin/make install':
    cwd         => "${destdir}/source",
    refreshonly => true,
    subscribe   => Exec["/usr/bin/make -j${::processorcount}"],
  }
}
