VCR.configure do |c|
  #the directory where your cassettes will be saved
  c.cassette_library_dir = 'spec/vcr'
  # your HTTP request service. You can also use fakeweb, webmock, and more
  c.hook_into :webmock

  # URI Ignoring ID
  c.register_request_matcher :uri_ignoring_id do |request_1, request_2|
    uri1, uri2 = request_1.uri, request_2.uri
    regexp_trail_id = %r(/\d+)
    if uri1.match(regexp_trail_id)
      r1_without_id = uri1.gsub(regexp_trail_id, "")
      r2_without_id = uri2.gsub(regexp_trail_id, "")
      uri1.match(regexp_trail_id) && uri2.match(regexp_trail_id) && r1_without_id == r2_without_id
    else
      uri1 == uri2
    end
  end

  # Ignore localhost requests
  c.ignore_localhost = true
end