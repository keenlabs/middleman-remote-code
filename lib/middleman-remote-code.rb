require "middleman-core"
require "middleman-remote-code/version"

::Middleman::Extensions.register(:remote_code) do
  require "middleman-remote-code/extension"
  ::Middleman::RemoteCode::RemoteCodeExtension
end
