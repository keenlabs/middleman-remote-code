require 'awesome_print'

module Middleman
  module RemoteCode
    class RemoteCodeExtension < Extension
      option :whitelist, [], 'A list of acceptable domains to fetch remote content from.'
      option :detect_pattern, /https?/, 'The regular expression to pass to URI to discover links.'

      def after_configuration
        if app.config[:markdown_engine] == :redcarpet
          require 'middleman-core/renderers/redcarpet'

          # TODO: I'd like to clean this up to use the same redcarpet/markdown processing used elsewhere
          @renderer  = RemoteExtractor.new
          @remote_md = Redcarpet::Markdown.new(@renderer, app.config[:markdown])

          RedcarpetRemoteCodeRenderer.options   = options
          RedcarpetRemoteCodeRenderer.renderer  = @renderer
          RedcarpetRemoteCodeRenderer.remote_md = @remote_md

          Middleman::Renderers::MiddlemanRedcarpetHTML.send :include, RedcarpetRemoteCodeRenderer
        else
          raise StandardError.new("Unable to fetch remote code outside of redcarpet (yet, patches welcome)")
        end
      end

      module RedcarpetRemoteCodeRenderer
        mattr_accessor :options
        mattr_accessor :renderer
        mattr_accessor :remote_md

        def detect_links(code)
          URI.extract(code, options[:detect_pattern] || /https?/)
        end

        def extract_remote_body(body)
          renderer.reset_blocks
          remote_md.render(body)
          renderer.blocks
        end

        def handle_remote_error(res)
          puts "Whoop Whoop, an error: #{res}"
        end

        def block_code(code, language)
          return super(code, language) unless language == "remote"

          ap options

          detect_links(code).each do |uri|
            puts "Discovered #{uri}"
            index = 0
            if uri =~ /#(.+)$/
              index = $1.to_i
              uri.gsub!(/#.+$/, '')
            end
            uri = URI(uri)
            if options[:whitelist].nil? or options[:whitelist].empty? or options[:whitelist].include?(uri.host)
              res = Net::HTTP.get_response(uri)
              if res.is_a?(Net::HTTPSuccess)
                blocks = extract_remote_body(res.body)
                if blocks[index]
                  code     = blocks[index][:code]
                  language = blocks[index][:language]
                end
              else
                code = handle_remote_error(res)
              end
            end
          end

          super(code, language)
        end
      end
    end

    class RemoteExtractor < Redcarpet::Render::HTML
      def initialize
        @blocks = []
        super
      end

      def reset_blocks
        @blocks = []
      end

      def block_code(code, language)
        @blocks << { code: code, language: language }
        "<pre><code>" + code + "</code></pre>"
      end

      def blocks
        @blocks
      end
    end
  end
end
