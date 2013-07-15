module SpreeProConnector
  module URLUtil
    def self.ensure_http_preffix(url)
      return "http://#{url}" if url.present? && !url.match(/^https?:\/\//)
      url
    end
  end
end

