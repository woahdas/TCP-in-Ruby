#building a webserver
require 'socket'

server = TCPServer.new ('localhost', 2345) #2345 is TCP/UDP

loop do
	socket = server.accept #wait for connection
	
	http_request = ""							  #reading the http request
	while(line = socket.gets) && (line != "\r\n") #
		http_request += line					  #
	end											  #
	STDERR.puts http_request					  #
	socket.close
end

Digest::SHA1.base64digest([sec_websocket_accept, "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"].join)
#^ server response

#adding a handshake
if matches = http_request.match(/^Sec-WebSocket-Key: (\S+)/)
	websocket_key = matches[1]
	STDERR.puts "handshake with key:  #{ websocket_key }"
else
	socket.close
	next
end

response_key = Digest::SHA1.base64digest([websocket_key, "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"].join)
STDERR.puts "responding to handshake with key: #{ response_key }"

socket.write <<-eos
HTTP/1.1 101 switching protocols
Upgrade: websocket
Connection: upgrade
Sec-WebSocket-Accept: #{ response_key }

eos

STDERR.puts "handshake completed"
