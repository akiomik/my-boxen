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
  # include osx

  # install with homebrew
  package {
    [
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
    'Yahoo!Messenger':
      source   => "http://dl.msg.yahoo.co.jp/pgdownload/YahooMessengerJ_31.dmg",
      provider => pkgdmg;
    'GoogleJapaneseInput':
      source => "http://dl.google.com/japanese-ime/latest/GoogleJapaneseInput.dmg",
      provider => pkgdmg;
  }

  $home      = "/Users/${::luser}"
  $src       = "${home}/src"

  # settings for dotfiles
  $dotfiles  = "${src}/dotfiles"
  repository { $dotfiles:
    source  => "akiomik/dotfiles",
    require => File[$src]
  }
  exec { "sh ${dotfiles}/configure":
    cwd => $dotfiles,
    creates => [ "${home}/.zshrc", "${home}/.vimrc", "${home}/.gitconfig", "${home}/.tmux.conf" ],
    require => Repository[$dotfiles],
  }

  # settings for vim
  $vim         = "${home}/.vim"
  $neobundle   = "${vim}/bundle"
  $fontpatcher = "${neobundle}/vim-powerline/fontpatcher/fontpatcher"
  $inconsolata = "${neobundle}/vim-powerline/fontpatcher/Inconsolata.otf"
  $wgetInconsolata = "wget http://levien.com/type/myfonts/Inconsolata.otf"
  $vimPluginInstall = "yes | vim -c 'q'"
  file { $vim:
    ensure => "directory",
  }
  repository { $neobundle:
    source => "Shougo/neobundle.vim",
    require => File[$vim]
  }
  exec { $vimPluginInstall:
    creates => "${fontpatcher}",
    require => Repository[$neobundle],
  }
  exec { $wgetInconsolata:
    cwd => $fontpatcher,
    creates => "$inconsolata",
    require => Package['wget'],
  }
  exec { "fontforge -script ${fontpatcher} ${inconsolata}":
    cwd => $fontpatcher,
    require => [ Exec[$vimPluginInstall], Exec[$wgetInconsolata], Package['fontforge'] ],
  }

  # settings for zsh
   file_line { 'add zsh to /etc/shells':
     path    => '/etc/shells',
     line    => "${boxen::config::homebrewdir}/bin/zsh",
     require => Package['zsh'],
     before  => Osx_chsh[$::luser];
   }
   osx_chsh { $::luser:
     shell   => "${boxen::config::homebrewdir}/bin/zsh";
   }
}
