<?php
		require_once 'bmhost/BMHost.php';

		$API_KEY="your swf secret app key";
		
		$appid = "your swf public app id";
		
		//the created token will be good for this ip/client.
		$ip = $_SERVER['REMOTE_ADDR'];
		//setup
		$bmhost=new BMHost($API_KEY);
		//get public hash seed
		$bmhost-> getToken($appid, $ip);
		//compute response with private api key.
		$bmhost-> creatHandshake();
		//pass to flash for handshake.
?>

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
            //flash var the critical tokens.
            flashvars.token ="<?php echo $bmhost->token;?>";
            flashvars.handshake ="<?php echo $bmhost->handshake;?>";                    
            var params = {};
            params.quality = "high";
            params.bgcolor = "#000000";
            params.allowscriptaccess = "sameDomain";
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
                
			<!-- JavaScript enabled so display the flashContent div in case it is not replaced with a swf object. -->
			swfobject.createCSS("#flashContent", "display:block;text-align:left;");
       
        </script>
    </head>
    
    <body>
        <!-- SWFObject's dynamic embed method replaces this alternative HTML content with Flash content when enough 
			 JavaScript and Flash plug-in support is available. The div is initially hidden so that it doesn't show
			 when JavaScript is disabled.
		-->
        <div id="flashContent">
        	<p>
	        	To view this page ensure that Adobe Flash Player version 
				${version_major}.${version_minor}.${version_revision} or greater is installed. 
			</p>
			<script type="text/javascript"> 
				var pageHost = ((document.location.protocol == "https:") ? "https://" :	"http://"); 
				document.write("<a href='http://www.adobe.com/go/getflashplayer'><img src='" 
								+ pageHost + "www.adobe.com/images/shared/download_buttons/get_flash_player.gif' alt='Get Adobe Flash player' /></a>" ); 
			</script> 
        </div>	
   </body>
</html>
