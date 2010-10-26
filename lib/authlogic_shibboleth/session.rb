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
		end
		
		module Methods
			def self.included(klass)
        klass.class_eval do
          attr_accessor :shibboleth_id
        end
      end
      
      def credentials
        if authenticating_with_shibboleth?
          details = {}
          details[:shibboleth_id] = send(login_field)
          details
        else
          super
        end
		  end
		  
		  #Sets credentials based on value in REMOTE_USER
		  def credentials=(value)
		    #super
		    self.shibboleth_id = request.env['REMOTE_USER']
	    end
      
			private
			
			def authenticating_with_shibboleth?
			  !shibboleth_id.blank?
		  end
			
			def find_by_shibboleth_id_method
				self.class.find_by_shibboleth_id_method
			end
			
			#Return if our environment variable is set
			def validate_by_shibboleth_id
				request.env.has_key? 'REMOTE_USER'
			end
		end
	end
end