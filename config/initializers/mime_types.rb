# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone
Rack::Mime::MIME_TYPES.merge!({
  ".x3d"     => "model/x3d+xml"
  })