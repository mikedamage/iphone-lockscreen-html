#!/usr/bin/env ruby
#
# = Lock Screen Disk Space Display

require 'erb'

class Diskspace
	attr_reader :df
	
	TEMPLATE = <<-END
<div id="disk_space">

</div>
	END
	
	def initialize
		@df = `df -h`
	end
	
	def render
		
	end
	
	def get_binding
		binding
	end
end