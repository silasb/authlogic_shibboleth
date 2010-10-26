module AuthlogicShibboleth
	module Session
		def self.included(klass)
			klass.class_eval do
				extend Config
				include Methods
			end
		end
		
		module Config
			def find_by_shibboleth_id_method(value = nil)
				rw_config(:finx_by_shibboleth_id_method, value, :find_by_shibboleth_id)
			end
			alias_method :find_by_shibboleth_id_method=, :find_by_shibboleth_id_method
			
			def auto_register(value=true)
        auto_register_value(value)
      end
      
      def auto_register_value(value=nil)
        rw_config(:auto_register,value,false)
      end
      
      alias_method :auto_register=,:auto_register
		end
		
		module Methods
			def self.included(klass)
        klass.class_eval do
          attr_reader :shibboleth_id
        end
      end
      
      def verify_session_with_env
    	end
      
			private
			
			def find_by_shibboleth_id_method
				self.class.find_by_shibboleth_id_method
			end
			
			#This method always returns true
			#this it should only be called when the proper
			#environment variable has been set
			def validate_by_shibboleth_id
				true
			end
		end
	end
end