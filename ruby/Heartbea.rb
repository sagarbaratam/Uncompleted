#!/opt/chef/embedded/bin/ruby
require 'rubygems'
require 'yaml'
require 'logger'
require 'mixlib/shellout'
require 'json'
require 'date'
require 'aws-sdk'

module Bby
  module DC
    class HeartBeat
      attr_accessor :config, :version, :logger, :artifact_path

      def initialize(type)
        log_file = File.open("/opt/deployasaurus/heartbeat.log", 'a+')
        log_file.sync = true

        @logger = Logger.new(log_file)
        @logger.formatter = proc do |severity, datetime, progname, msg|
          "[#{datetime}] : #{severity} : #{msg}\n"
        end

        log '--- Heartbeat Script ---'
        log 'Loading app.yaml config'
        @config = YAML.load_file('/opt/deployasaurus/app.yaml')

        @userdata = retrieve_userdata

        log 'Merging application specific configurations into app.yaml'
        # Override artifact name if defined in userdata
        if @userdata['overrides'] && @userdata['overrides']['retrieve_app']
          @userdata = @userdata['overrides']['retrieve_app']

          %w(heartbeat_on heartbeat_off heartbeat_verify_on heartbeat_verify_off heartbeat_sleep).each do |item|
            @config[item] = @userdata[item] if @userdata[item]
          end
        end

        if type != 'on' && type != 'off' && type != 'verify'
          log 'Heartbeat command is not on, off or verify'
          exit -1
        end

        if type != 'verify'
          modify_heartbeat type
          verify_heartbeat type
        else
          verify_heartbeat_other
        end

        if type == 'on'
          log 'Heartbeat has been turned ON'
        elsif type == 'off'
          log 'Heartbeat has been turned OFF'
        end

      rescue Exception => e
        log "Exception occurred: #{e}", true
        exit -1
      end

      def modify_heartbeat(type)
        log "Turning the heartbeat #{type}"
        cmd=@config["heartbeat_#{type}"]
        modify = Mixlib::ShellOut.new(cmd)
        modify.run_command

        if modify.error?
          log modify.stderr
          log "Cannot turn the heartbeat #{type}. This may mean the heartbeat is already set to #{type}"
          log "Please see log file for details: /opt/deployasaurus/heartbeat.log"

          exit -1
        else
          modify.error!
        end
      end

      def get_object(region, url, dest=nil)
        s3_url = Amazon::S3::Uri::AmazonS3URI.new(url)
        log "URL '#{url}' parsed as: #{s3_url.bucket} / #{s3_url.key}"
        access_key = "AKIAJS7USIKKZEGLLJOQ"
        secret_key = "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"
        if access_key.empty?
          s3 = Aws::S3::Resource.new(region: region)
        else
          s3 = Aws::S3::Resource.new(region: region, access_key_id: access_key, secret_access_key: secret_key)
        end
        s3_obj = s3.bucket(s3_url.bucket).object(s3_url.key)

        if dest.nil?
          s3_obj.get.body.read
        else
          s3_obj.get({ response_target: "#{config['deploy_base']}/cache/#{dest}" })
        end
      end

      def retrieve_userdata
        log "Retrieving User Data"

          bucket_env="test"

          user_farm = 'a'

        begin
          log "Downloading userdata from S3 East - Farm #{user_farm}"
          JSON.parse(get_object('us-east-1', "https://dc-#{bucket_env}-east-user-data.s3.amazonaws.com/mag-publisher/user_data_#{user_farm}.txt"))
        rescue Exception => e
          log 'Download failed - S3 East'
          log "Downloading userdata from S3 West - Farm #{user_farm}"
          JSON.parse(get_object('us-east-1', "https://dc-#{bucket_env}-east-user-data.s3.amazonaws.com/mag-publisher/user_data_#{user_farm}.txt"))
        end
      end

      def verify_heartbeat(type)
        log "Verifying the heartbeat is #{type}"
        cmd=@config["heartbeat_verify_#{type}"]
        sleep=@config['heartbeat_sleep']
        verify = Mixlib::ShellOut.new(cmd)
        verify.run_command

        if verify.stdout != ''
          log "Heartbeat is #{type}"
        else
          log "Heartbeat is not #{type}", true
          exit -1
        end

        if sleep == true
          if type == 'off'
            log 'Sleeping for 60 seconds to wait for traffic to drain'
            sleep 60
          end

          if type == 'on'
            log 'Sleeping for 10 seconds'
            sleep 10
          end
        end
      end

      def verify_heartbeat_other
        log "Verifying the heartbeat"
        verify_on = Mixlib::ShellOut.new(@config["heartbeat_verify_on"])
        verify_on.run_command

        verify_off = Mixlib::ShellOut.new(@config["heartbeat_verify_off"])
        verify_off.run_command

        if verify_off.stdout != ''
          log 'The heartbeat is OFF'
        elsif verify_on.stdout != ''
          log 'The heartbeat is ON'
        else
          log 'The heartbeat file does not exist on this server.  This is bad if it is required to exist.'
        end
      end

      def log(msg, fatal=nil)
        if fatal == nil
          @logger.info msg
          puts "[#{DateTime.now.to_s}] : INFO : #{msg}"
        else
          @logger.fatal msg
          puts "[#{DateTime.now.to_s}] : FATAL : #{msg}"
        end
      end
    end
  end
end


# From amazon-s3-uri gem 0.1.1
module Amazon
  module S3
    module Uri
      class AmazonS3URI
        ENDPOINT_PATTERN = /^(.+\.)?s3[.-]([a-z0-9-]+)\./
        attr_reader :uri, :bucket, :key, :region
        def initialize(url)
          if url.nil?
            raise ArgumentError.new("url cannot be null")
          end
          @uri = URI(url)

          @host = @uri.host
          if @host.nil?
            raise ArgumentError.new("Invalid S3 URI: no hostname: " + url)
          end

          matches = ENDPOINT_PATTERN.match(@host)

          prefix = matches[1]

          if prefix.nil? || prefix.empty?
            # No bucket name in the authority; parse it from the path.
            @isPathStyle = true
            path = uri.path
            if (path == '/')
              @bucket = nil
              @key = nil
            else
              # path genearlly in style of `/sample-bucket/temp/8746ee3e-4089-11e8-9a0b-f3d94c494e17.somaya.jpg`
              index = path.index('/', 1)
              if index.nil?
                # path if equals /sample-bucket
                # puts path
                @bucket = path[1 .. -1]
                @key = nil
              elsif index == path.length - 1
                # path if equals /sample-bucket/
                @bucket = path[1 ... index]
                @key = nil
              else
                # path if equals `/sample-bucket/temp/8746ee3e-4089-11e8-9a0b-f3d94c494e17.somaya.jpg`
                @bucket = path[1 ... index]
                @key = path[index + 1 .. -1]
              end
            end
          else
            @isPathStyle = false

            # Remove the trailing '.' from the prefix to get the bucket.
            @bucket = prefix[0 ... -1]
            path = uri.path
            if path.nil? || path.empty? || path  == '/'
              @key = nil
            else
              # Remove the leading '/'
              @key = path[ 1 .. -1]
            end
          end

          if matches[2] == 'amazonaws'
            # No region specified
            @region = nil
          else
            @region = matches[2]
          end
        end
      end
    end
  end
end

Bby::DC::HeartBeat.new(ARGV[0])