module Paperclip
  class Watermark < Thumbnail
    attr_accessor :watermarks, :extent

    def initialize file, options = {}, attachment = nil
      super
      @watermarks       = options[:watermarks]
      @extent           = options[:extent]
      @background_color       = options[:background_color]
    end

    def make
      #call the method from the base class to perform the required changes on the original image
      dst = super

      if @watermarks
        command = 'composite'

        @watermarks.each do |watermark|
          next unless watermark[:path] && watermark[:position]

          params = "-gravity #{watermark[:position]} #{watermark[:path]} #{tofile(dst)} #{tofile(dst)}"

          begin
            success = Paperclip.run(command, params)
            puts params
          rescue PaperclipCommandLineError
            raise PaperclipError, "An error occured while applying the watermarks for #{@basename}" if @whiny
          end
        end
      end

      if @extent
        parameters = []
        parameters << "#{tofile(dst)}"
        parameters << "-background" << (@background_color.nil? ? "black":@background_color)
        parameters << "-gravity center"
        parameters << "-extent" << %["#{@extent}"]
        parameters << "#{tofile(dst)}"

        parameters = parameters.flatten.compact.join(" ").strip.squeeze(" ")

        convert(parameters)
      end

      dst
    end

    def fromfile
      "\"#{ File.expand_path(@file.path) }[0]\""
    end

    def tofile(destination)
      "\"#{ File.expand_path(destination.path) }[0]\""
    end
  end
end