// Support both the WebSocket and MozWebSocket objects
if ((typeof(WebSocket) == 'undefined') &&
    (typeof(MozWebSocket) != 'undefined')) {
  WebSocket = MozWebSocket;
}

var LeapMotion=function(uri, handler, openHandler){
	
	this.uri=uri;
	
	this.openHandler=openHandler;
	
	this.handler=handler;
	
	this.leapSocket  ;
	
	this.open=false;

	this.start=function(){
		
		this.leapSocket = new WebSocket(uri);
		
		this.leapSocket.onopen = function(event) {
			this.open=true;
			openHandler(event.data);
		};
				
		this.leapSocket.onmessage = function(event) {			
			handler(event.data);		
		};
				
		this.leapSocket.onclose = function(event) {
			this.open=false;
			this.leapSocket = null;			
		};	
			
		this.leapSocket.onerror = function(event) {	
		};
	};
};
