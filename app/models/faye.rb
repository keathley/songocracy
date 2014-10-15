class Faye
  def self.broadcast(channel, data)
    message = {
      :channel => channel,
      :data => data
    }
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def self.uri
    URI.parse("http://localhost:9292/faye")
  end
end
