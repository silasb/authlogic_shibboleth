module AuthlogicShibboleth
	module ActsAsAuthentic
		def self.included(klass)
			klass.class_eval do
				extend Config
				add_acts_as_authentic_module(Methods, :prepend)
			end
		end
		
		module Config
			def validate_shibboleth_login(value=nil)
				config(:validate_shibboleth_login, value, true)
			end
			alias_method :validate_shibboleth_login=, :validate_shibboleth_login
		end
		
		module Methods
			def self.included(klass)
				return if !klass.column_names.include?("shibboleth_id") #we need to store our ids in the database
        
        klass.class_eval do
          validates_uniqueness_of :shibboleth_id, :scope => validations_scope
        end
      end
		end
	end
end