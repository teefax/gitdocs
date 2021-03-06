require 'gitdocs/version'
require 'gitdocs/configuration'
require 'gitdocs/runner'
require 'gitdocs/server'
require 'gitdocs/cli'
require 'thread'
require 'rb-fsevent'
require 'growl'
require 'yajl'
require 'dante'

module Gitdocs
  def self.run(config_root = nil, debug=false)
    loop do
      @config = Configuration.new(config_root)
      puts "Gitdocs v#{VERSION}" if debug
      puts "Using configuration root: '#{@config.config_root}'" if debug
      puts "Watch paths: #{@config.paths.join(", ")}" if debug
      @threads = @config.paths.map do |path|
        t = Thread.new { Runner.new(path).run }
        t.abort_on_exception = true
        t
      end
      puts "Watch threads: #{@threads.map { |t| "Thread status: '#{t.status}', running: #{t.alive?}" }}" if debug
      puts "Joined #{@threads.size} watch threads...running" if debug
      @threads.each(&:join)
      sleep(60)
    end
  end
end
