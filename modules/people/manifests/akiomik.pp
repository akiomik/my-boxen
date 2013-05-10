class people::akiomik {
  # 自分の環境で欲しいresourceをincludeする
  include java
  include googledrive
  include sublime_text_2
  include dropbox
  include iterm2::stable
  include skype
  include cyberduck
  include chrome
  #  include osx

  # install with homebrew
  package {
    [
      'ack',
      'asciidoc',
      'autoconf',
      'automake',
      'cmake',
      'ctags',
      'docbook',
      'fontforge',
      'gdbm',
      'gettext',
      'gmp',
      'gnu-sed',
      'htop-osx',
      'jpeg',
      'jq',
      'jsl',
      'libevent',
      'libpng',
      'libtiff',
      'libtool',
      'lv',
      'mobile-shell',
      'mongodb',
      'mosh',
      'mysql',
      'oniguruma',
      'pcre',
      'pkg-config',
      'protobuf',
      'redis',
      'sbt',
      'scala',
      'tmux',
      'wget',
      'z',
      'zsh',
    ]:
  }

  # install mac applications
  package {
    'XtraFinder':
      source   => "http://www.trankynam.com/xtrafinder/downloads/XtraFinder.dmg",
      provider => pkgdmg;
    'BetterTouchTool':
      source   => "http://www.boastr.de/BetterTouchTool.zip",
      provider => compressed_app;
  }

  $home     = "/Users/${::luser}"
  $src      = "${home}/src"
  $dotfiles = "${src}/dotfiles"

  # settings for dotfiles
  repository { $dotfiles:
    source  => "akiomik/dotfiles",
    require => File[$src]
  }
  exec { "sh ${dotfiles}/.configure":
    cwd => $dotfiles,
    creates => [ "${home}/.zshrc", "${home}/.vimrc", "${home}/.gitconfig", "${home}/.tmux.conf" ],
    require => Repository[$dotfiles],
  }

  # settings for zsh
  #  file_line { 'add zsh to /etc/shells':
  #    path    => '/etc/shells',
  #    line    => "${boxen::config::homebrewdir}/bin/zsh",
  #    require => Package['zsh'],
  #    before  => Osx_chsh[$::luser];
  #  }
  #  osx_chsh { $::luser:
  #    shell   => "${boxen::config::homebrewdir}/bin/zsh";
  #  }
}
