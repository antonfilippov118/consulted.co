# encoding: utf-8
# Configure the TorqueBox Servlet-based session store.
# Provides for server-based, in-memory, cluster-compatible sessions
if ENV['TORQUEBOX_APP_NAME']
  Consulted::Application.config.session_store :torquebox_store
else
  key = 'dd6fe1a1784a861750a2cd3ca72cb66fb40aae2a954ad71112e5'
  Consulted::Application.config.session_store :cookie_store, key: key
end
