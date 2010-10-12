module SwissKnife
  module Support
    module RemoteFile
      def update
        File.open(Rails.root.join("public/#{file}"), "w+") do |f|
          f << open(url).read
        end
      end
    end
  end
end
