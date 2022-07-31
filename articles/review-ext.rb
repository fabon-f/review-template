module ReVIEW
  module PDFMakerOverride
    def make_colophon_role(role)
      super(role).gsub(/https?:\/\/[^ ]*/) { "\\url{#{unescape_latex(_1)}}" }
    end
  end

  class PDFMaker
    prepend PDFMakerOverride
  end
end
