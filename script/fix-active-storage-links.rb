#!/usr/bin/env ruby

require_relative "../config/environment"
require "uri"
require "base64"
require "json"

ActionText::RichText.all.where("body LIKE '%/rails/active_storage/%'").find_each do |rich_text|
  next unless rich_text.body

  blobs = rich_text.embeds.map(&:blob)

  rich_text.body.send(:attachment_nodes).each do |node|
    url = node["url"]
    next unless url

    url_encoded_filename = url.split("/").last
    filename = URI.decode_www_form_component(url_encoded_filename)

    counter += 1
    blob = blobs.select { |b| b.filename == filename }
    raise "Multiple blobs with filename #{filename}" if blob.size > 1
    blob = blob.first

    if blob
      node["sgid"] = blob.attachable_sgid
    else
      skipped += 1
    end
  end

  rich_text.save!
end
