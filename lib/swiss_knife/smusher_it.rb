require "net/http"
require "uri"
require "json"
require "open-uri"
require "digest/sha1"

module SwissKnife
  class SmushIt
    ENDPOINT = URI.parse("http://ws1.adq.ac4.yahoo.com/ysmush.it/ws.php")
    CONTENT_TYPE = {
      ".png"  => "image/png",
      ".gif"  => "image/gif",
      ".jpg"  => "image/jpeg",
      ".jpeg" => "image/jpeg"
    }

    HOOKS = {}

    def self.on(hook, &block)
      HOOKS[hook] ||= []
      HOOKS[hook] << block
    end

    def self.compress(filepath)
      http = Net::HTTP.new(ENDPOINT.host, ENDPOINT.port)
      request = Net::HTTP::Post.new(ENDPOINT.request_uri)
      file_contents = File.read(filepath)
      boundary = Digest::SHA1.hexdigest(file_contents)
      request["Content-Type"] = "multipart/form-data, boundary=#{boundary}"
      request.body = [].tap do |body|
        body << "--#{boundary}"
        body << %[Content-Disposition: form-data; name="files[]"; filename="#{File.basename(filepath)}"]
        body << %[Content-Type: #{CONTENT_TYPE[File.extname(filepath).downcase]}\r\n]
        body << file_contents
        body << "--#{boundary}--\r\n"
      end.join("\r\n")

      response = http.request(request)
      return nil unless response.code == "200"

      JSON.load(response.body).tap do |info|
        HOOKS[:complete].each {|block| block[filepath, info]}
      end
    end

    def self.convert(from, to)
      info = compress(from)
      return if info["error"]
      File.open(to, "wb+") {|file| file << open(info["dest"]).read }
    end

    def self.convert_directory(source)
      Dir["#{source}/**/*.{png,gif,jpg,jpeg}"].each do |filepath|
        p "converting #{filepath}"
        convert filepath, filepath
      end
    end
  end
end
