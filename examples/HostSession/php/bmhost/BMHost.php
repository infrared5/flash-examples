<?php

/**
 * 
 * PHP Brasmonkey Host API v 1.2
 * @author Andy Shaules
 *
 */
class BMHost{
	
	public $url = 'http://registry.monkeysecurity.com:8080/bmregistry/gateway';
	public $seed;
	public $token;
	public $API_KEY;
	public $handshake;
	public $session;
	public $launchToken;
	public $address;
	public $location;
	/**
	 * Use the secret application key.
	 */
	public function BMHost($apiKey)	{
	
		$this->API_KEY=$apiKey;	
		
	}

	/**
	 * Get a public challenge key for your application, for the remote ip.
	 */
	public function getToken($appId,$forIp)
	{
		$this-> address=$forIp;
		$fields = array(
            'appId'=>$appId,
            'ip'=>$this->address
		);
		
		$fields_string="";
		
		foreach($fields as $key=>$value){
			 
			$fields_string .= $key.'='.$value.'&';
		}
		 
		rtrim($fields_string,'&');

		$ch = curl_init();

		
		curl_setopt($ch,CURLOPT_URL,'http://registry.monkeysecurity.com:8080/bmregistry/hostsession.jsp');
		curl_setopt($ch,CURLOPT_POST,count($fields));
		curl_setopt($ch,CURLOPT_POSTFIELDS,$fields_string);
		curl_setopt($ch,CURLOPT_RETURNTRANSFER,1);
		
		$ret=curl_exec($ch);
		
		curl_close($ch);
		
		$this->launchToken = json_decode($ret);
	}
	/**
	 * Create the challenge-response
	 */	
	public function creatHandshake(){
		
		$this->seed="Hg".rand(100000, 999999);
		
		$this->token=$this->launchToken->token;
		
		$this->handshake=md5($this->token.$this->seed.$this-> API_KEY)."|".$this->seed;

	}
	/**
	 * Flash can call this one directly.
	 */
	public function creatSession(){
		
		$fields = array(
            'banana'=>$this->token,
            'handshake'=>$this->handshake,
            'setTime'=>'900000',
            'action'=>"session.createSession"
		);
		
		$fields_string="";
		
		foreach($fields as $key=>$value) 
		{ 
			$fields_string .= $key.'='.$value.'&';
		}
		 
		rtrim($fields_string,'&');

		
		$ch = curl_init();

		
		curl_setopt($ch,CURLOPT_URL,$this->url);
		curl_setopt($ch,CURLOPT_POST,count($fields));
		curl_setopt($ch,CURLOPT_POSTFIELDS,$fields_string);
		curl_setopt($ch,CURLOPT_RETURNTRANSFER,1);
		
		$ret=curl_exec($ch);
		
		curl_close($ch);
		
		$this->session = json_decode($ret);

	}



};

?>