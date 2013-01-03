/*

Basic game structure example for web and mobile published game in Away3d

Demonstrates:

How to use 3d object pooling to keep control of the geometry and material instances of your game
How to use game objects to manage individual logic on game elements.
How to create dynamically resizing screen elements for different resolutions
How to setup game controls for multiple input devices
How to simulate exploding particles

Code by Rob Bateman & Alejandro Santander
rob@infiniteturtles.co.uk
http://www.infiniteturtles.co.uk
Alejandro Santander
http://www.lidev.com.ar/

This code is distributed under the MIT License

Copyright (c) Away Media 2012

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

package 
{
	import away3d.containers.*;
	import away3d.debug.*;
	import away3d.entities.*;
	import away3d.lights.*;
	import away3d.materials.*;
	import away3d.materials.lightpickers.*;
	import away3d.materials.methods.*;
	import away3d.primitives.*;
	import away3d.textures.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.sensors.*;
	import flash.system.*;
	import flash.text.*;
	import flash.ui.*;
	import flash.utils.*;
	
	import invawayders.data.*;
	import invawayders.events.*;
	import invawayders.objects.*;
	import invawayders.pools.*;
	import invawayders.sounds.*;
	import invawayders.utils.*;
	
	
	[SWF(backgroundColor="#000000", frameRate="60")]
	public class Main extends Sprite implements IGameInterface
	{
		//skybox textures
		[Embed(source="/../embeds/skybox/space_posX.jpg")]
		private var SkyboxImagePosX:Class;
		[Embed(source="/../embeds/skybox/space_negX.jpg")]
		private var SkyboxImageNegX:Class;
		[Embed(source="/../embeds/skybox/space_posY.jpg")]
		private var SkyboxImagePosY:Class;
		[Embed(source="/../embeds/skybox/space_negY.jpg")]
		private var SkyboxImageNegY:Class;
		[Embed(source="/../embeds/skybox/space_posZ.jpg")]
		private var SkyboxImagePosZ:Class;
		[Embed(source="/../embeds/skybox/space_negZ.jpg")]
		private var SkyboxImageNegZ:Class;
		
		//engine variables
		private var _view:View3D;
		private var _lightPicker:StaticLightPicker;
		private var _cubeMap:BitmapCubeTexture;
		
		//light variables
		private var _cameraLight:PointLight;
		private var _cameraLightPicker:StaticLightPicker;
		private var _gameObjectPools:Vector.<GameObjectPool>;
		
		//player variables
		private var _player:Player;
		private var _playerVector:Vector.<GameObject>;
		
		//invawayder variables
		private var _invawayderFactory:InvawayderFactory;
		private var _invawayderMaterial:ColorMaterial;
		
		//game variables
		private var _time:uint;
		private var _totalKills:uint;
		private var _currentLevelKills:uint;
		private var _spawnTimeFactor:Number;
		private var _currentLevel:uint;
		private var _soundLibrary:SoundLibrary;
		
		//game object pools
		private var _invawayderPool:InvawayderPool;
		private var _playerProjectilePool:GameObjectPool;
		private var _invawayderProjectilePool:GameObjectPool;
		private var _playerBlastPool:GameObjectPool;
		private var _invawayderBlastPool:GameObjectPool;
		private var _cellPool:GameObjectPool;
		
		//interaction variables
		private var _showingMouse:Boolean = true;
		private var _active:Boolean;
		private var _currentPosition:Point = new Point();
		private var _isAccelerometer:Boolean;
		private var _isDesktop:Boolean;
		private var _accelerometer:Accelerometer = new Accelerometer();
		private var _isFiring:Boolean;
		private var _mouseIsOnStage:Boolean = true;
		private var _firstAccY:Number = 0;
		private var _w:int;
		private var _h:int;
		private var _hw:int;
		private var _hh:int;
		private var _scale:Number;
		
		//hud variables
		private var _hudContainer:Sprite;
		private var _scoreText:TextField;
		private var _livesText:TextField;
		private var _restartButton:SimpleButton;
		private var _pauseButton:SimpleButton;
		
		//popup variables
		private var _activePopUp:MovieClip;
		private var _popUpContainer:Sprite;
		private var _splashPopUp:MovieClip;
		private var _playButton:SimpleButton;
		private var _pausePopUp:MovieClip;
		private var _resumeButton:SimpleButton;
		private var _gameOverPopUp:MovieClip;
		private var _goScoreText:TextField;
		private var _goHighScoreText:TextField;
		private var _playAgainButton:SimpleButton;
		private var _liveIconsContainer:Sprite;
		private var _crossHair:Sprite;
		
		//score variables
		private var _score:uint;
		private var _highScore:uint = 0;
		
		//state save manager
		protected var _saveStateManager : SaveStateManager;
		
		
		
		private var _lan:BrassMonkeyAgent;
		
		
		
		/**
		 * Constructor
		 */
		public function Main()
		{
			//default accelerometer use to true if accelerometer is available
			_isAccelerometer = Accelerometer.isSupported;
			
			//determine the platform we are running on (used for screen dimension variables)
			var man:String = Capabilities.manufacturer;
			_isDesktop = (man.indexOf('Win')>=0 || man.indexOf('Mac')>=0);
			
			init();
		}
		
		/**
		 * Global initialise function
		 */
		private function init():void
		{
			initSaveState();
			initGame();
			initEngine();
			initScene();
			initInvawayders();
			initPlayer();
			initHUD();
			initListeners();
			
			_lan=new BrassMonkeyAgent(this);
			_lan.startAgent(loaderInfo.parameters);
			//brass monkey supplies
			_isAccelerometer=true;
						
			
		}
		
		/**
		 * Initialise the save state of the game
		 */		
		protected function initSaveState():void
		{
			//initialise the save state manager
			_saveStateManager = new SaveStateManager();
		}
		
		/**
		 * Initialise the game
		 */		
		private function initGame():void
		{
			//get saved highscroe
			_highScore = _saveStateManager.loadHighScore();
			
			//set stage properties
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//initialise sound manager
			_soundLibrary = SoundLibrary.getInstance();
			
			//initialise invawayder manager
			_invawayderFactory = InvawayderFactory.getInstance();
		}
		
		/**
		 * Initialise the engine
		 */
		private function initEngine():void
		{
			//setup the 3d view
			_view = new View3D();
			_view.camera.lens.near = 50;
			_view.camera.lens.far = 100000;
			addChild( _view );
			
			// add awaystats if in debug mode
			if( GameSettings.debugMode ) {
				addChild( new AwayStats( _view ) );
				_view.scene.addChild( new Trident() );
			}
		}
		
		private function initScene():void
		{
			// initialise lights
			var frontLight:DirectionalLight = new DirectionalLight();
			frontLight.direction = new Vector3D( 0.5, 0, 1 );
			frontLight.color = 0xFFFFFF;
			frontLight.ambient = 0.1;
			frontLight.ambientColor = 0xFFFFFF;
			_view.scene.addChild( frontLight );
			_cameraLight = new PointLight();
			_view.scene.addChild( _cameraLight );
			_cameraLightPicker = new StaticLightPicker( [ _cameraLight ] );
			_lightPicker = new StaticLightPicker( [ frontLight ] );


			// create skybox texture
			_cubeMap = new BitmapCubeTexture(
				new SkyboxImagePosX().bitmapData, new SkyboxImageNegX().bitmapData,
				new SkyboxImagePosY().bitmapData, new SkyboxImageNegY().bitmapData,
				new SkyboxImagePosZ().bitmapData, new SkyboxImageNegZ().bitmapData
			);
			
			_view.scene.addChild( new SkyBox( _cubeMap ) );

			// initialise game object pools
			_gameObjectPools = new Vector.<GameObjectPool>();
		}
		
		/**
		 * Initialise the invawayder objects
		 */
		private function initInvawayders():void
		{
			// Reusable invawayder blasts.
			_invawayderBlastPool = new GameObjectPool( new Blast(new Mesh( new SphereGeometry(), new ColorMaterial( 0x00FFFF, 0.5 ) )) );
			_gameObjectPools.push( _invawayderBlastPool );
			_view.scene.addChild( _invawayderBlastPool );
			
			// Reusable invawayder projectiles.
			var invawayderProjectileMaterial:ColorMaterial = new ColorMaterial( 0xFF0000 );
			invawayderProjectileMaterial.lightPicker = _lightPicker;
			_invawayderProjectilePool = new GameObjectPool(  new Projectile(new Mesh( new CubeGeometry( 25, 25, 200, 1, 1, 4 ), invawayderProjectileMaterial )) );
			_gameObjectPools.push( _invawayderProjectilePool );
			_view.scene.addChild( _invawayderProjectilePool );
			
			// Reusable invawayders.
			_invawayderMaterial = new ColorMaterial( 0x777780, 1 );
			_invawayderMaterial.lightPicker = _lightPicker;
			_invawayderPool = new InvawayderPool();
			_gameObjectPools.push( _invawayderPool );
			_view.scene.addChild( _invawayderPool );

			// Create cells ( used for invawayder death explosions ).
			_cellPool = new GameObjectPool( new InvawayderCell(new Mesh( new CubeGeometry( GameSettings.invawayderSizeXY, GameSettings.invawayderSizeXY, GameSettings.invawayderSizeZ ), _invawayderMaterial )) );
			_gameObjectPools.push( _cellPool );
			_view.scene.addChild( _cellPool );
		}
		
		/**
		 * Initialise the player
		 */
		private function initPlayer():void
		{
			// initialise reusable player blasts
			_playerBlastPool = new GameObjectPool( new Blast(new Mesh( new SphereGeometry(), new ColorMaterial( 0xFF0000, 0.5 ) )) );
			_gameObjectPools.push( _playerBlastPool );
			_view.scene.addChild( _playerBlastPool );
			
			// initialise player projectiles
			var playerProjectileMaterial:ColorMaterial = new ColorMaterial( 0x00FFFF, 0.75 );
			playerProjectileMaterial.lightPicker = _lightPicker;
			_playerProjectilePool = new GameObjectPool( new Projectile(new Mesh( new CubeGeometry( 25, 25, 200 ), playerProjectileMaterial )) );
			_gameObjectPools.push( _playerProjectilePool );
			_view.scene.addChild( _playerProjectilePool );
			
			// initialise player
			var playerMaterial:ColorMaterial = new ColorMaterial( 0xFFFFFF );
			playerMaterial.lightPicker = _cameraLightPicker;
			_player = new Player( _view.camera, playerMaterial);
			_player.position = new Vector3D( 0, 0, -1000 );
			_player.active = true;
			_player.addEventListener( GameObjectEvent.GAME_OBJECT_HIT, onPlayerHit );
			_player.addEventListener( GameObjectEvent.GAME_OBJECT_FIRE, onPlayerFire);
			_player.addEventListener( GameObjectEvent.GAME_OBJECT_DIE, onPlayerDie);
			_player.targets = _invawayderPool.gameObjects;
			_playerVector = new Vector.<GameObject>();
			_playerVector.push( _player );
			_player.visible = false;
			_view.scene.addChild( _player );
		}
		
		/**
		 * Initialise the game HUD
		 */		
		private function initHUD():void
		{
			// initialise the HUD container
			_hudContainer = new Sprite();
			addChild(_hudContainer);
			
			// initialise the cross hair graphic
			_crossHair = new Crosshair();
			_hudContainer.addChild( _crossHair );
			
			// initialise the score text
			var scoreClip:CustomTextField = new CustomTextField();
			_scoreText = scoreClip.tf;
			_hudContainer.addChild( _scoreText );
			
			// initialise the lives text
			var livesClip:CustomTextField = new CustomTextField();
			_livesText = livesClip.tf;
			_hudContainer.addChild( _livesText );
			
			// initialise the lives icons
			_liveIconsContainer = new Sprite();
			_hudContainer.addChild( _liveIconsContainer );
			for( var i:uint; i < GameSettings.playerLives; i++ ) {
				var live:Sprite = new InvawayderLive();
				live.x = i * ( live.width + 5 );
				_liveIconsContainer.addChild( live );
			}
			
			// initialise the restart button
			_restartButton = new RestartButton();
			_restartButton.addEventListener( MouseEvent.MOUSE_UP, onRestart );
			_hudContainer.addChild( _restartButton );
			
			// initialise the pause button
			_pauseButton = new PauseButton();
			_pauseButton.addEventListener( MouseEvent.MOUSE_UP, onPause );
			_hudContainer.addChild( _pauseButton );
			
			// initialise the popup container
			_popUpContainer = new Sprite();
			addChild(_popUpContainer);
			
			// initialise the splash popup
			_splashPopUp = new SplashPopUp();
			_splashPopUp.visible = false;
			_popUpContainer.addChild(_splashPopUp);
			_playButton = _splashPopUp.playButton;
			_playButton.addEventListener( MouseEvent.MOUSE_UP, onPlay );
			
			// initialise the pause popup
			_pausePopUp = new PausePopUp();
			_pausePopUp.visible = false;
			_popUpContainer.addChild(_pausePopUp);
			_resumeButton = _pausePopUp.resumeButton;
			_resumeButton.addEventListener( MouseEvent.MOUSE_UP, onResume );
			
			// initialise the game over popup
			_gameOverPopUp = new GameOverPopUp();
			_gameOverPopUp.visible = false;
			_popUpContainer.addChild(_gameOverPopUp);
			_playAgainButton = _gameOverPopUp.playAgainButton;
			_playAgainButton.addEventListener( MouseEvent.MOUSE_UP, onPlay, false, 0, true );
			_goScoreText = _gameOverPopUp.scoreText;
			
			// set the splash popup to visible
			showPopUp( _splashPopUp );
		}
		
		/**
		 * Initialise the listeners
		 */
		private function initListeners():void
		{
			addEventListener( Event.ENTER_FRAME, onEnterFrame );
			stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			stage.addEventListener( Event.MOUSE_LEAVE, onMouseLeave );
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
			stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			stage.addEventListener( Event.RESIZE, onResize);
			_accelerometer.addEventListener(AccelerometerEvent.UPDATE, onAccelerometerUpdate);
			onResize();
		}
		
		// -----------------------
		// App flow.
		// -----------------------
		
		/**
		 * Halts the game logic. Called by the pause button or when the player's lives decrease to zero
		 */
		private function pauseGame():void
		{
			showMouse();
			_invawayderPool.stopTimers();
			_active = false;
			_player.visible = false;
		}
		
		/**
		 * Restarts the game. Called by the play button or restart button
		 */
		private function beginGame():void
		{
			// Reset all game object pools.
			var gameObjectPool:GameObjectPool;
			for each ( gameObjectPool in _gameObjectPools)
				gameObjectPool.clear();
			
			//reset level data
			_currentLevel = 0;
			_currentLevelKills = 0;
			_totalKills = 0;
			_spawnTimeFactor = GameSettings.startingSpawnTimeFactor;
			
			//reset score
			_score = 0;
			updateScoreCounter();
			
			//reset lives
			_player.lives = 3;
			updateLivesCounter();
			
			//reset layout to account for lives and score text
			onResize();
			
			//resume play
			resumeGame();
		}
		
		/**
		 * Resumes the game. Called on game start or by the resume button.
		 */
		private function resumeGame():void
		{
			hideMouse();
			hidePopUp();
			
			_firstAccY = 0;
			_invawayderPool.resumeTimers();
			_active = true;
			_player.visible = true;
			
			//reset spawn times
			_invawayderFactory.resetLastSpawnTimes(_time = getTimer());
		}
		
		/**
		 * Hides the active popup.
		 */
		private function hidePopUp():void
		{
			_hudContainer.visible = true;
			_activePopUp.visible = false;
		}
		
		/**
		 * Shows the popup defined in the argument.
		 * 
		 * @param popUp The moviecip containing the desired popup graphics.
		 */
		private function showPopUp( popUp:MovieClip ):void
		{
			pauseGame();
			
			_activePopUp = popUp;
			_hudContainer.visible = false;
			_activePopUp.visible = true;
		}
		
		/**
		 * Hides the mouse cursor for desktop implementations.
		 */
		private function hideMouse():void
		{
			if( !_showingMouse )
				return;
			
			Mouse.hide();
			
			_showingMouse = false;
		}
		
		/**
		 * Shows the mouse cursor for desktop implementations.
		 */
		private function showMouse():void
		{
			if( _showingMouse )
				return;
			
			Mouse.show();
			
			_showingMouse = true;
		}
		
		/**
		 * Updates the lives counter to a new lives value.
		 */
		private function updateLivesCounter():void
		{
			// Update icons.
			for( var i:uint; i < GameSettings.playerLives; i++ )
				_liveIconsContainer.getChildAt( i ).visible = _player.lives >= i + 1;
			
			// Update text.
			_livesText.text = "LIVES " + _player.lives + "";
			_livesText.width = _livesText.textWidth * 1.05;
		}
		
		/**
		 * Updates the score counter to a new score value.
		 */
		private function updateScoreCounter():void
		{
			_scoreText.text = "SCORE " + StringUtils.uintToSameLengthString( _score, 5 ) + "   HIGH-SCORE " + StringUtils.uintToSameLengthString( _highScore, 5 );
			_scoreText.width = int(_scoreText.textWidth * 1.05);
		}
		
		/**
		 * Interaction, game and render loop
		 */		
		private function onEnterFrame( event:Event ):void
		{
			if( _isFiring && _active)
				_player.updateBlasters();
			
			if( _mouseIsOnStage && !_isAccelerometer ) {
				if( stage.mouseX > 0 && stage.mouseX < 100000 )
					_currentPosition.x = stage.mouseX;
				
				if( stage.mouseY > 0 && stage.mouseY < 100000 )
					_currentPosition.y = stage.mouseY;
			}

			// Update player.
			if( _active ) {
				if (_isAccelerometer) {
					_player.velocity.x =  (GameSettings.accelerometerMotionFactorX * _currentPosition.x - _player.x) * GameSettings.accelerometerCameraMotionEase;
					_player.velocity.y =  (GameSettings.accelerometerMotionFactorY * _currentPosition.y - _player.y) * GameSettings.accelerometerCameraMotionEase;
				} else {
					_player.velocity.x = (GameSettings.mouseMotionFactor * ( _currentPosition.x / _hw - 1 ) - _player.x) * GameSettings.mouseCameraMotionEase;
					_player.velocity.y = (-GameSettings.mouseMotionFactor * ( _currentPosition.y / _hh - 1 ) - _player.y) * GameSettings.mouseCameraMotionEase;
				}
				if( GameSettings.panTiltFactor != 0 ) {
					_player.rotationY = -GameSettings.panTiltFactor * _player.x;
					_player.rotationX =  GameSettings.panTiltFactor * _player.y;
				}
			
				_player.update();
			} else {
				_player.velocity.x = 0;
				_player.velocity.y = 0;
			}
			
			_time = getTimer();
			
			// Update all game object pools (continue moving objects after player's death)
			if( _active || !_player.lives) {
				var gameObjectPool:GameObjectPool;
				for each (gameObjectPool  in _gameObjectPools)
					gameObjectPool.update();
			}
			
			//spawn new invawayders if time elapsed has exceeded spawn rate.
			if( _active ) {
				var invawayderData:InvawayderData;
				for each (invawayderData in _invawayderFactory.invawayders) {
					//determine if enough time has passed to spawn another invawayder
					if( _time > invawayderData.lastSpawnTime + invawayderData.spawnRate * _spawnTimeFactor * MathUtils.rand( 0.9, 1.1 ) ) {
						
						//grab an unused invawayder from the invawayder pool
						var invawayder:Invawayder = _invawayderPool.getInvawayderOfType( invawayderData.id );
						
						//create a new invawayder if none are available and add it to the pool
						if (!invawayder) {
							invawayder = _invawayderFactory.getInvawayder(invawayderData.id, _invawayderMaterial);
							
							// handle invawayder events
							invawayder.addEventListener( GameObjectEvent.GAME_OBJECT_DIE, onInvawayderDie );
							invawayder.addEventListener( GameObjectEvent.GAME_OBJECT_FIRE, onInvawayderFire );
							invawayder.addEventListener( GameObjectEvent.GAME_OBJECT_HIT, onInvawayderHit );
							invawayder.addEventListener( GameObjectEvent.GAME_OBJECT_ADD, onInvawayderAdd );
							
							invawayder.add(_invawayderPool);
							_invawayderPool.gameObjects.push( invawayder );
						}
						invawayderData.lastSpawnTime = _time;
					}
				}
			}

			// Camera light follows player's position.
			_cameraLight.transform = _player.transform;
			_cameraLight.y += 500;
			
			// Render the main scene
			_view.render();
			
			if( _active ) {
				if( mouseY < 50*_scale )
					showMouse();
				else
					hideMouse();
			}
		}
		
		/**
		 * Handler for resize events from the stage
		 */
		private function onResize(event:Event = null):void
		{
			_w = _isDesktop? stage.stageWidth : stage.fullScreenWidth;
			_h = _isDesktop? stage.stageHeight : stage.fullScreenHeight;
			_hw = _w/2;
			_hh = _h/2;
			
			//adjust the scale of buttons and text according to the resolution
			if (_w < 800) {
				_scale = 0.5
			} else if (_w > 1600) {
				_scale = 2;
			} else {
				_scale = 1;
			}
			
			//update view size
			_view.width = _w;
			_view.height = _h;
			
			//update crosshair & popup position
			_popUpContainer.scaleX = _popUpContainer.scaleY = _scale;
			_popUpContainer.x = _crossHair.x = _hw;
			_popUpContainer.y = _crossHair.y = _hh;
			
			//update lives text position
			_livesText.scaleX = _livesText.scaleY = _scale;
			_livesText.x = _hw - _livesText.width / 2 - _liveIconsContainer.width / 2 - 5*_scale;
			_livesText.y = _h - 35*_scale;
			
			_liveIconsContainer.scaleX = _liveIconsContainer.scaleY = _scale;
			_liveIconsContainer.x = _livesText.x + _livesText.width + 10*_scale;
			_liveIconsContainer.y = _livesText.y + 8*_scale;
			
			_restartButton.scaleX = _restartButton.scaleY = _scale;
			
			_pauseButton.scaleX = _pauseButton.scaleY = _scale;
			_pauseButton.x = _w - _pauseButton.width;
			
			_scoreText.scaleX = _scoreText.scaleY = _scale;
			_scoreText.x = _hw - _scoreText.width / 2 + 20*_scale;
			_scoreText.y = 7*_scale;
		}
		
		// -----------------------------
		// Game event handlers.
		// -----------------------------
		
		/**
		 * Handler for invawayder add events, broadcast when an invawayder has been added to the game.
		 */
		private function onInvawayderAdd( event:GameObjectEvent ):void
		{
			var invawayder:Invawayder = event.gameTarget as Invawayder;
			
			if( invawayder.invawayderData.id == InvawayderFactory.MOTHERSHIP_INVAWAYDER )
				_soundLibrary.playSound( SoundLibrary.MOTHERSHIP );
		}
		
		/**
		 * Handler for invawayder hit events, broadcast when an invawayder has been hit by a player projectile or player.
		 */
		private function onInvawayderHit( event:GameObjectEvent ):void
		{
			_soundLibrary.playSound( SoundLibrary.BOING );
			var blast:Blast = _invawayderBlastPool.getGameObject() as Blast;
			blast.velocity = event.gameTarget.velocity;
			blast.position = event.gameTrigger.position;
			blast.z -= GameSettings.invawayderSizeZ;
		}
		
		/**
		 * Handler for invawayder fire events, broadcast when an invawayder has fired a projectile.
		 */
		private function onInvawayderFire( event:GameObjectEvent ):void
		{
			var invawayder:Invawayder = event.gameTarget as Invawayder;
			var projectile:Projectile = _invawayderProjectilePool.getGameObject() as Projectile;
			projectile.targets = _playerVector;
			projectile.transform = invawayder.transform.clone();
			projectile.velocity = new Vector3D( 0, 0, -100 );
			
			if( invawayder.invawayderData.id != InvawayderFactory.MOTHERSHIP_INVAWAYDER ) {
				//play invawayder fire sound
				_soundLibrary.playSound( SoundLibrary.INVAWAYDER_FIRE, 0.5 );
			} else {
				//offset projectile on the mothership by a random amount
				projectile.position = projectile.position.add( new Vector3D(MathUtils.rand( -700, 700 ), MathUtils.rand( -150, 150 ), 0) );
			}
		}
		
		/**
		 * Handler for invawayder die events, broadcast when an invawayder has died.
		 */
		private function onInvawayderDie( event:GameObjectEvent ):void
		{
			var invawayder:Invawayder = event.gameTarget as Invawayder;
			
			// Check level update and update UI.
			_currentLevelKills++;
			_totalKills++;
			
			// Update score
			_score += invawayder.invawayderData.score;
			
			// Update highscore
			if( _score > _highScore && _player.lives ) {
				_highScore = _score;
				_saveStateManager.saveHighScore(_highScore);
			}
			
			updateScoreCounter();
			
			// Update level
			if( _currentLevelKills > GameSettings.killsToAdvanceDifficulty ) {
				_currentLevelKills = 0;
				_currentLevel++;
				
				_spawnTimeFactor -= GameSettings.spawnTimeFactorPerLevel;
				
				if( _spawnTimeFactor < GameSettings.minimumSpawnTimeFactor )
					_spawnTimeFactor = GameSettings.minimumSpawnTimeFactor;
			}

			// Play sound
			if( invawayder.invawayderData.id == InvawayderFactory.MOTHERSHIP_INVAWAYDER )
				_soundLibrary.playSound( SoundLibrary.EXPLOSION_STRONG );
			else
				_soundLibrary.playSound( SoundLibrary.INVAWAYDER_DEATH );

			// Show invawayder destruction
			var trigger:GameObject = event.gameTrigger;
			var intensity:Number = GameSettings.deathExplosionIntensity * MathUtils.rand( 1, 4 );
			var positions:Vector.<Point> = invawayder.cellPositions;
			var pos:Point;
			var sc:Number = invawayder.scaleX;
			
			for each ( pos in positions) {
				var cell:InvawayderCell = _cellPool.getGameObject() as InvawayderCell;
				cell.scaleX = cell.scaleY = cell.scaleZ = sc;
				
				// Set cell position according to dummy child position.
				cell.position = invawayder.position;
				cell.x += sc * pos.x;
				cell.y += sc * pos.y;
				
				// Determine explosion velocity of cell.
				var dx:Number = cell.x - trigger.x;
				var dy:Number = cell.y - trigger.y;
				var distanceSq:Number = dx * dx + dy * dy;
				var rotSpeed:Number = intensity * 5000 / distanceSq;
				
				//set the rotation velocity of the cell
				cell.rotationalVelocity.x = MathUtils.rand( -rotSpeed, rotSpeed );
				cell.rotationalVelocity.y = MathUtils.rand( -rotSpeed, rotSpeed );
				cell.rotationalVelocity.z = MathUtils.rand( -rotSpeed, rotSpeed );
				
				//set the linear velocity of the cell
				cell.velocity.x = intensity * MathUtils.rand( 100, 500 ) * dx / distanceSq;
				cell.velocity.y = intensity * MathUtils.rand( 100, 500 ) * dy / distanceSq;
				cell.velocity.z = intensity * 50 * trigger.velocity.z / distanceSq + invawayder.velocity.z;
			}
		}
		
		/**
		 * Handler for player hit events, broadcast when a player has been hit by an invawayder projectile or invawayder.
		 */
		private function onPlayerHit( event:GameObjectEvent ):void
		{
			_soundLibrary.playSound( SoundLibrary.EXPLOSION_SOFT );
			
			//creat a new blast object
			var blast:Blast = _playerBlastPool.getGameObject() as Blast;
			blast.velocity = event.gameTarget.velocity;
			blast.position = event.gameTrigger.position.clone();
			
			//update lives counter
			updateLivesCounter();
		}
		
		/**
		 * Handler for player die events, broadcast when a player has died.
		 */
		private function onPlayerDie( event:GameObjectEvent ):void
		{
			//prepare game over popup
			_goScoreText.text =     "SCORE................................... " + StringUtils.uintToSameLengthString( _score, 5 );
			_goHighScoreText = _gameOverPopUp.highScoreText;
			_goHighScoreText.text = "HIGH-SCORE.............................. " + StringUtils.uintToSameLengthString( _highScore, 5 );
			_goScoreText.width = int(_goScoreText.textWidth * 1.05);
			_goScoreText.x = -int(_goScoreText.width / 2);
			_goHighScoreText.width = int(_goHighScoreText.textWidth * 1.05);
			_goHighScoreText.x = -int(_goHighScoreText.width / 2);
			
			showPopUp( _gameOverPopUp );
			this._lan.gameOver();
		}
		
		/**
		 * Handler for pplayer fire events, broadcast when the player has fired a projectile.
		 */
		private function onPlayerFire( event:GameObjectEvent ):void
		{
			_soundLibrary.playSound( SoundLibrary.PLAYER_FIRE, 0.25 );
			
			//create a new projectile
			var projectile:Projectile = _playerProjectilePool.getGameObject() as Projectile;
			projectile.targets = _invawayderPool.gameObjects;
			projectile.transform = _player.transform.clone();
			projectile.velocity = _player.transform.deltaTransformVector( new Vector3D( 0, 0, 200 ) );
			projectile.position = projectile.position.add( new Vector3D( _player.playerFireCounter % 2 ? GameSettings.blasterOffsetH : -GameSettings.blasterOffsetH, GameSettings.blasterOffsetV, -750 ) );
		}
		
		// -----------------------------
		// User interface event handlers.
		// -----------------------------
		
		/**
		 * Button handler for mouse events, broadcast when the resume button is clicked.
		 */
		private function onResume( event:MouseEvent ):void
		{
			resumeGame();
		}
		
		/**
		 * Button handler for mouse events, broadcast when the pause button is clicked.
		 */
		private function onPause( event:MouseEvent ):void
		{
			showPopUp( _pausePopUp );
		}
		
		/**
		 * Button handler for mouse events, broadcast when the restart button is clicked.
		 */
		private function onRestart( event:MouseEvent ):void
		{
			beginGame();
		}
		
		/**
		 * Button handler for mouse events, broadcast when the play button is clicked.
		 */
		private function onPlay( event:MouseEvent ):void
		{
			hideMouse();
			hidePopUp();			
			beginGame();
		}
		public function brassMonkeyStart():void
		{
			hideMouse();
			hidePopUp();			
			beginGame();
		}
		public function brassMonkeyRestart():void
		{			
			beginGame();
		}
		public function brassMonkeyPause():void
		{			
			pauseGame();
			
			_activePopUp = _pausePopUp;
			_hudContainer.visible = false;
			_activePopUp.visible = true;
		}
		public function brassMonkeyResume():void
		{	
			hideMouse();
			hidePopUp();
			
			_firstAccY = 0;
			_invawayderPool.resumeTimers();
			_active = true;
			_player.visible = true;
			
			//reset spawn times
			_invawayderFactory.resetLastSpawnTimes(_time = getTimer());
		}
		public function brassMonkeyMoveInput(x:Number, y:Number):void
		{
			// Use first encountered acc Y as Y center.
//			if( _firstAccY == 0 ) {
//				_firstAccY = y;
//			}
			
			// Update position.
			_currentPosition.x = -x * GameSettings.cameraPanRange;
			_currentPosition.y =  ( _firstAccY - y ) * GameSettings.cameraPanRange;
		}
		public function clientfire(isFiring:Boolean):void
		{			
			this._isFiring=isFiring;
		}
		// -----------------------------
		// Input event handlers.
		// -----------------------------
		
		/**
		 * Stage handler for mouse events, broadcast when the mouse moves.
		 */
		private function onMouseMove( event:MouseEvent ):void
		{
			_mouseIsOnStage = true;
		}
		
		/**
		 * Stage handler for mouse events, broadcast when the mouse leaves the stage area.
		 */
		private function onMouseLeave( event:Event ):void
		{
			_mouseIsOnStage = false;
		}
		
		/**
		 * Stage handler for mouse events, broadcast when the mouse button is pressed.
		 */
		private function onMouseDown( event:MouseEvent ):void
		{
			switch(event.target){
				case _playButton:
				case _restartButton:
				case _pauseButton:
				case _playAgainButton:
				case _resumeButton:
					SoundLibrary.getInstance().playSound( SoundLibrary.UFO, 0.5 );
					break;
				default:
					_isFiring = true;
					break;
			}
		}
		
		/**
		 * Stage handler for mouse events, broadcast when the mouse button is released.
		 */
		private function onMouseUp( event:MouseEvent ):void
		{
			_isFiring = false;
		}
		
		/**
		 * Stage handler for key events, broadcast when a key is pressed.
		 */
		private function onKeyDown( event:KeyboardEvent ):void
		{
			switch( event.keyCode ) {
				case Keyboard.SPACE:
					_isFiring = true;
					break;
			}
		}
		
		/**
		 * Stage handler for mouse events, broadcast when a key is released.
		 */
		private function onKeyUp( event:KeyboardEvent ):void
		{
			switch( event.keyCode ) {
				case Keyboard.SPACE:
					_isFiring = false;
					break;
			}
		}
		
		/**
		 * Accelerometer handler for accelerometer events, broadcast when the values of the accelerometer update.
		 */
		private function onAccelerometerUpdate( event:AccelerometerEvent ):void
		{
			// Use first encountered acc Y as Y center.
			if( _firstAccY == 0 ) {
				_firstAccY = event.accelerationY;
			}
			
			// Update position.
			_currentPosition.x = -event.accelerationX * GameSettings.cameraPanRange;
			_currentPosition.y =  ( _firstAccY - event.accelerationY ) * GameSettings.cameraPanRange;
		}
	}
}
