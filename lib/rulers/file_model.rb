require "multi_json"

module Rulers
  module Model
    class FileModel
      STRONG_PARAMS = %w(submitter quote attribution)

      def initialize(filename)
        @filename = filename

        basename = File.split(filename)[-1]
        @id = File.basename(basename, '.json').to_i

        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def save
        save_to_json(@id, @hash)
      end

      def self.find(id)
        begin
          FileModel.new(model_path(id))
        rescue
          return nil
        end
      end

      def self.all
        files = Dir[model_path]
        files.map { |f| FileModel.new f }
      end

      def self.create(attrs)
        hash = sanitize_attributes(attrs)
        id = get_next_id

        save_to_json(id, hash)

        FileModel.new model_path(id)
      end

      private

      def self.save_to_json(id, hash)
        File.open(model_path(id), 'w') do |f|
          f.write MultiJson.dump(hash, pretty: true)
        end
      end

      def self.model_path(id = '*')
        File.join 'db', 'quotes', "#{id}.json"
      end

      def self.get_next_id
        files = Dir[model_path]
        names = files.map { |f| f.split('/')[-1] }
        names.map { |b| b.to_i}.max + 1
      end

      def self.sanitize_attributes(attrs)
        STRONG_PARAMS.reduce({}) do |hash, attr|
          hash.merge(attr => attrs[attr] || '')
        end
      end
    end
  end
end
