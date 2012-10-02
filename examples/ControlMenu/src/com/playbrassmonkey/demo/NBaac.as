package com.playbrassmonkey.demo
{
	import com.thebitstream.flv.CodecFactory;
	import com.thebitstream.flv.Transcoder;
	import com.thebitstream.flv.codec.*;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamAppendBytesAction;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	[SWF (width="2",height="2")]
	
	public dynamic class NBaac
	{
		public var request:URLRequest;
		public var transcoder :Transcoder
		public var transport :NetConnection;
		public var transportStream :NetStream;
		public var serverConnection:URLStream;
		
		
		public var host:String='http://glb-stream15.streaming.init7.net';
		
		public var resource:String='/1/rsc_de/aacp_64';
		
		public function NBaac()
		{

			
			CodecFactory.ImportCodec(MetaData);
			CodecFactory.ImportCodec(AAC);
			CodecFactory.ImportCodec(AACP);         
			
			
			transcoder = new Transcoder();
			transcoder.addEventListener(CodecEvent.STREAM_READY,onChannelReady);
			transcoder.addEventListener(StreamDataEvent.DATA, onTag);
			transcoder.initiate();
			transcoder.loadCodec("AAC ");
			
			
			transport = new NetConnection();
			transport.connect(null);

			flash.utils.setTimeout(boot,500);
		
		}
		public function boot():void
		{
	
			ExternalInterface.addCallback('nbaac.setVolume', onVolume);
			ExternalInterface.addCallback('nbaac.togglePause', onTogglePause);
			ExternalInterface.addCallback('nbaac.setBuffer', setBufferLength);
			ExternalInterface.addCallback('nbaac.getBuffer', getBufferLength);
			ExternalInterface.addCallback('nbaac.getTime', getTime);
			var meta:Object={};
			meta.uri="";
			meta.StreamTitle=""; 
			
			transportStream = new NetStream(transport);
			
			transportStream.bufferTime=2;
			transportStream.client = this;
			transportStream.soundTransform=new SoundTransform(.5,0);
			transportStream.play(null);                             
			transportStream.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
			
			var headerTag:ByteArray=transcoder.createHeader(false,true);
			transportStream.appendBytes(headerTag);                         
			headerTag.clear();
			
			transcoder.readMetaObject(meta,0);
			
			serverConnection=new URLStream();
			serverConnection.addEventListener(ProgressEvent.PROGRESS,loaded);
			serverConnection.addEventListener(IOErrorEvent.IO_ERROR, onIo);                                 
			serverConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onNoPolicy);
			serverConnection.addEventListener(Event.CLOSE, onClose);
			request=new URLRequest(host+resource);

			request.method=URLRequestMethod.GET;
			serverConnection.load(request);
			
			
			
		}
		private function getTime():Number
		{
			return transportStream.time;
		}
		
		private function getBufferLength():Number
		{
			return transportStream.bufferLength;
		}
		
		private function setBufferLength(val:Number):void
		{
			transportStream.bufferTime=val;
		}
		
		private function onTogglePause():void
		{
			transportStream.togglePause();
		}
		
		private function onVolume(val:Number):void
		{
			transportStream.soundTransform=new SoundTransform(val,0);
		}
		
		private function onIo(pe:IOErrorEvent):void
		{
			ExternalInterface.call('logit','IOErrorEvent')
		}       
		private function onTag(sde:StreamDataEvent):void
		{
			sde.tag.position=0;
			transportStream.appendBytes(sde.tag);
		}
		
		private function onChannelReady(ce:CodecEvent):void
		{       
			trace('onChannelReady :',ce.codec.type);
			
		}
		private function onClose(e:Event):void
		{
			ExternalInterface.call('logit','onClose')
		}
		public function onMetaData(e:Object):void
		{
			ExternalInterface.call('logit','onMetaData')
			
		}
		
		private function loaded(e:ProgressEvent):void
		{                       
			
			
			
			var chunk:ByteArray=new ByteArray();
			
			while(serverConnection.bytesAvailable)
			{
				chunk.writeByte(serverConnection.readByte());
			}
			
			chunk.position=0;
			transcoder.addRawData(chunk, 0 ,"AAC ");                                                        
		}
		
		private function onNoPolicy(se:SecurityErrorEvent):void
		{
			ExternalInterface.call('logit','SecurityErrorEvent'+host+resource+'<br />'+se.text);
		}
		
	}

}