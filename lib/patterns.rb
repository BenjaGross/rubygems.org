module Patterns
  extend ActiveSupport::Concern

  SPECIAL_CHARACTERS    = ".-_".freeze
  ALLOWED_CHARACTERS    = "[A-Za-z0-9#{Regexp.escape(SPECIAL_CHARACTERS)}]+".freeze
  ROUTE_PATTERN         = /#{ALLOWED_CHARACTERS}/
  LAZY_ROUTE_PATTERN    = /#{ALLOWED_CHARACTERS}?/
  NAME_PATTERN          = /\A#{ALLOWED_CHARACTERS}\Z/
  URL_VALIDATION_REGEXP = %r{\Ahttps?:\/\/([^\s:@]+:[^\s:@]*@)?[A-Za-z\d\-]+(\.[A-Za-z\d\-]+)+\.?(:\d{1,5})?([\/?]\S*)?\z}
  GEM_NAME_BLACKLIST    = %w[
    abbrev
    base64
    benchmark
    cgi
    cgi-session
    complex
    continuation
    coverage
    delegate
    digest
    drb
    english
    enumerator
    erb
    expect
    fiber
    find
    getoptlong
    install
    io-nonblock
    io-wait
    jruby
    logger
    mkmf
    monitor
    mri
    mruby
    net-ftp
    net-http
    net-imap
    net-pop
    net-protocol
    net-smtp
    nkf
    observer
    open-uri
    open3
    optparse
    pathname
    prettyprint
    profile
    profiler
    pstore
    pty
    rational
    rbconfig
    resolv
    rinda
    ruby
    rubygems
    securerandom
    set
    shellwords
    singleton
    socket
    syslog
    tempfile
    thread
    time
    timeout
    tmpdir
    tsort
    un
    unicode_normalize
    uninstall
    uri
    weakref
    win32ole
    yaml
    ubygems
    sidekiq-pro
    graphql-pro

    # Blacklisted internal Rails dependency misspellings
    # which could be used for malicious purposes.
    action-cable
    action_cable
    action-mailer
    action_mailer
    action-pack
    action_pack
    action-view
    action_view
    active-job
    active_job
    active-model
    active_model
    active-record
    active_record
    active-storage
    active_storage
    active-support
    active_support
    sprockets_rails
    rail-ties
    rail_ties
  ].freeze
end
