#!/usr/bin/env ruby
#
# = Lock Screen Disk Space Display

require 'erb'

class Diskspace
	attr_reader :df, :template, :volumes
	
	def initialize
		@df = `df -h`
		@template = ERB.new(DATA.read)
		@volumes = parse_df_output(@df)
	end
	
	def render
		@template.result(binding)
	end
	
	def parse_df_output(string)
		volumes = []
		string.each_line do |line|
			if line =~ /^Filesystem/
				next
			else
				s = line.split(/\s+/)
				volumes << {
					:filesystem => s[0],
					:size => s[1],
					:used => s[2],
					:avail => s[3],
					:capacity => s[4],
					:mountpoint => s[5]
				}
			end
		end
		return volumes
	end
	
	def get_binding
		binding
	end
end

d = Diskspace.new
puts d.render

__END__
<div id="disk_space">
	<table>
		<tr>
			<th>Filesystem</th>
			<th>Size</th>
			<th>Used</th>
			<th>Avail</th>
			<th>Capacity</th>
			<th>Mounted At</th>
		</tr>
		<% @volumes.each do |volume| %>
			<tr>
				<td><%= volume[:filesystem] %></td>
				<td><%= volume[:size] %></td>
				<td><%= volume[:used] %></td>
				<td><%= volume[:avail] %></td>
				<td><%= volume[:capacity] %></td>
				<td><%= volume[:mountpoint] %></td>
			</tr>
		<% end %>
	</table>
</div>