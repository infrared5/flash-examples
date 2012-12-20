<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"
	import="java.net.*,
	java.io.*,	
	com.google.gson.JsonParser,
	com.google.gson.JsonObject,
	java.security.MessageDigest,
	java.security.NoSuchAlgorithmException"%>

<%

String API_SECRET = "your swf private secret key";

String APP_ID_PUB = "your swf public app id" ;

String tokenValue = "";

//get the public token for your app
URL tokenUrl = new URL("http://registry.monkeysecurity.com:8080/bmregistry/hostsession.jsp?appId="+APP_ID_PUB);

URLConnection connection = tokenUrl.openConnection();

BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));

String inputLine;

while ((inputLine = in.readLine()) != null) 
	tokenValue+=inputLine;

in.close();

//retrieve from the json
JsonParser  parser = new JsonParser();;	
JsonObject obj = parser.parse(tokenValue).getAsJsonObject();	
tokenValue=obj.get("token").getAsString();


//create some random value as a hash-salt.
String seed ="Hg"+ new Integer((int)(Math.random()*Integer.MAX_VALUE)).toString();
//form the value to be digested.
String toHash = tokenValue+seed+API_SECRET;

byte[] defaultBytes = toHash.getBytes();

MessageDigest algorithm = MessageDigest.getInstance("MD5");

algorithm.reset();

algorithm.update(defaultBytes);

byte messageDigest[] = algorithm.digest();

StringBuffer hexString = new StringBuffer();

for (int i = 0; i < messageDigest.length; i++) {

	String int_s = Integer.toHexString(0xFF & messageDigest[i]);

	if (int_s.length() > 1) {
		hexString.append(int_s);
	} else {
		hexString.append("0" + int_s);
	}
}
//here is the complete handshake, ready for FlashVar
String handshake = hexString.toString() + "|" + seed;

//Pass it to Flash.
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- saved from url=(0014)about:internet -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">	
    <head>
        <title></title>
        <meta name="google" value="notranslate">         
                <style type="text/css" media="screen"> 
			html, body	{ height:100%; }
			body { margin:0; padding:0; overflow:auto; text-align:center; 
			       background-color: #000000; }   
			object:focus { outline:none; }
			#flashContent { display:none; }
        </style>

		    
        <script type="text/javascript" src="swfobject.js"></script>
       
        <script type="text/javascript">
 			var swfVersionStr = "10.2.0";
            var flashvars = {};
            flashvars.token ="<%= tokenValue%>";
            flashvars.handshake ="<%= handshake%>";                    
            var params = {};
            params.quality = "high";
            params.bgcolor = "#000000";
            params.allowscriptaccess = "always";
            params.allowfullscreen = "true";
            var attributes = {};
            attributes.id = "HostSession";
            attributes.name = "HostSession";
            attributes.align = "middle";
            swfobject.embedSWF(
                "HostSessionTest.swf", "flashContent", 
                "960", "640", 
                swfVersionStr, "", 
                flashvars, params, attributes);
                
			swfobject.createCSS("#flashContent", "display:block;text-align:left;");
       
        </script>
    </head>
    
    <body>

        <div id="flashContent">

        </div>	
   </body>
</html>



