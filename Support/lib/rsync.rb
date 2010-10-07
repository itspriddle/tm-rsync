#!/usr/bin/env ruby
require ENV['TM_SUPPORT_PATH'] + '/lib/web_preview'
require ENV['TM_SUPPORT_PATH'] + '/lib/escape'
require ENV['TM_SUPPORT_PATH'] + '/lib/osx/plist'

module Rsync
  class ConfigError < StandardError; end

  WINDOW = e_sh File.join(ENV['TM_BUNDLE_SUPPORT'], 'nibs/rsync.nib')
  DIALOG = e_sh ENV['DIALOG'] unless defined?(TM_DIALOG)

  PARAMS = {
    'SSH_KEY'            => ENV['SSH_KEY'],
    'SSH_USER'           => ENV['SSH_USER'],
    'SSH_HOST'           => ENV['SSH_HOST'],
    'SSH_REMOTE_PATH'    => ENV['SSH_REMOTE_PATH'],
    'RSYNC_OPTIONS'      => ENV['RSYNC_OPTIONS'],
    'RSYNC_EXCLUDE_FROM' => ENV['RSYNC_EXCLUDE_FROM']
  }.delete_if { |key, val| val.nil? }

  def self.execute!
    unless configured?
      ask_for_config!
    end
    begin
      [rsync!, command]
    rescue ConfigError
      "SSH_HOST and SSH_REMOTE_PATH must be set to continue"
    end
  end

  def self.configured?
    PARAMS['SSH_HOST'] && PARAMS['SSH_REMOTE_PATH']
  end
  private_class_method :configured?

  def self.ask_for_config!
    res = %x{#{DIALOG} -p '#{PARAMS.to_plist}' -m #{WINDOW}}
    PARAMS.merge!(OSX::PropertyList.load(res))
  end
  private_class_method :ask_for_config!

  def self.rsync!
    if configured?
      %x{#{command}}
    else
      raise ConfigError
    end
  end
  private_class_method :rsync!

  def self.command
    return @command if @command

    project = ENV['TM_PROJECT_DIRECTORY']

    if PARAMS['SSH_KEY'] && PARAMS['SSH_KEY'] != ""
      ssh = "ssh -i #{PARAMS['SSH_KEY']}"
    else
      ssh = "ssh"
    end

    opts = '-auv'

    if PARAMS['RSYNC_OPTIONS'] && PARAMS['RSYNC_OPTIONS'] != ""
      opts += " #{PARAMS['RSYNC_OPTIONS']}"
    end

    if PARAMS['RSYNC_EXCLUDE_FROM'] && PARAMS['RSYNC_EXCLUDE_FROM'] != ""
      exclude = PARAMS['RSYNC_EXCLUDE_FROM']
      if File.exists?(exclude)
        opts += " --exclude-from=#{exclude}"
      elsif File.exists?(File.join(project, exclude))
        opts += " --exclude-from=#{File.join(project, exclude)}"
      end
    end

    remote = "#{PARAMS['SSH_HOST']}:#{PARAMS['SSH_REMOTE_PATH']}"

    if PARAMS['SSH_USER'] && PARAMS['SSH_USER'] != ""
      remote = "#{PARAMS['SSH_USER']}@#{remote}"
    end

    @command = %{rsync -e "#{ssh}" #{opts} "#{project}"/ "#{remote}"}
  end
  private_class_method :command
end
