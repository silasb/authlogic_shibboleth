require "authlogic_shibboleth/version"
require "authlogic_shibboleth/acts_as_authentic"
require "authlogic_shibboleth/session"

ActiveRecord::Base.send(:include, AuthlogicShibboleth::ActsAsAuthentic)
Authlogic::Session::Base.send(:include, AuthlogicShibboleth::Session)
