package fl.transitions
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class Tween extends EventDispatcher
   {
      protected static var _mc:MovieClip = new MovieClip();
      
      private var _position:Number = NaN;
      
      public var prevTime:Number = NaN;
      
      public var prevPos:Number = NaN;
      
      public var isPlaying:Boolean = false;
      
      public var begin:Number = NaN;
      
      private var _fps:Number = NaN;
      
      private var _time:Number = NaN;
      
      public var change:Number = NaN;
      
      private var _finish:Number = NaN;
      
      public var looping:Boolean = false;
      
      private var _intervalID:uint = 0;
      
      public function func(param1:Number, param2:Number, param3:Number, param4:Number):Number
      {
         return param3 * param1 / param4 + param2;
      }
      private var _timer:Timer = null;
      
      private var _startTime:Number = NaN;
      
      public var prop:String = "";
      
      private var _duration:Number = NaN;
      
      public var obj:Object = null;
      
      public var useSeconds:Boolean = false;
      
      public function Tween(param1:Object, param2:String, param3:Function, param4:Number, param5:Number, param6:Number, param7:Boolean = false)
      {
         super();
         if(!arguments.length)
         {
            return;
         }
         this.obj = param1;
         this.prop = param2;
         this.begin = param4;
         this.position = param4;
         this.duration = param6;
         this.useSeconds = param7;
         if(param3 is Function)
         {
            this.func = param3;
         }
         this.finish = param5;
         this._timer = new Timer(100);
         this.start();
      }
      
      public function continueTo(param1:Number, param2:Number) : void
      {
         this.begin = this.position;
         this.finish = param1;
         if(!isNaN(param2))
         {
            this.duration = param2;
         }
         this.start();
      }
      
      public function stop() : void
      {
         this.stopEnterFrame();
         this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_STOP,this._time,this._position));
      }
      
      private function fixTime() : void
      {
         if(this.useSeconds)
         {
            this._startTime = getTimer() - this._time * 1000;
         }
      }
      
      public function set FPS(param1:Number) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.isPlaying;
         this.stopEnterFrame();
         this._fps = param1;
         if(_loc2_)
         {
            this.startEnterFrame();
         }
      }
      
      public function get finish() : Number
      {
         return this.begin + this.change;
      }
      
      public function get duration() : Number
      {
         return this._duration;
      }
      
      protected function startEnterFrame() : void
      {
         var _loc1_:Number = NaN;
         if(isNaN(this._fps))
         {
            _mc.addEventListener(Event.ENTER_FRAME,this.onEnterFrame,false,0,true);
         }
         else
         {
            _loc1_ = 1000 / this._fps;
            this._timer.delay = _loc1_;
            this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
            this._timer.start();
         }
         this.isPlaying = true;
      }
      
      public function set time(param1:Number) : void
      {
         this.prevTime = this._time;
         if(param1 > this.duration)
         {
            if(this.looping)
            {
               this.rewind(param1 - this._duration);
               this.update();
               this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_LOOP,this._time,this._position));
            }
            else
            {
               if(this.useSeconds)
               {
                  this._time = this._duration;
                  this.update();
               }
               this.stop();
               this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_FINISH,this._time,this._position));
            }
         }
         else if(param1 < 0)
         {
            this.rewind();
            this.update();
         }
         else
         {
            this._time = param1;
            this.update();
         }
      }
      
      protected function stopEnterFrame() : void
      {
         if(isNaN(this._fps))
         {
            _mc.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         else
         {
            this._timer.stop();
         }
         this.isPlaying = false;
      }
      
      public function getPosition(param1:Number = NaN) : Number
      {
         if(isNaN(param1))
         {
            param1 = this._time;
         }
         return this.func(param1,this.begin,this.change,this._duration);
      }
      
      public function set finish(param1:Number) : void
      {
         this.change = param1 - this.begin;
      }
      
      public function set duration(param1:Number) : void
      {
         this._duration = param1 <= 0 ? Infinity : param1;
      }
      
      public function setPosition(param1:Number) : void
      {
         this.prevPos = this._position;
         if(this.prop.length)
         {
            this.obj[this.prop] = this._position = param1;
         }
         this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_CHANGE,this._time,this._position));
      }
      
      public function resume() : void
      {
         this.fixTime();
         this.startEnterFrame();
         this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_RESUME,this._time,this._position));
      }
      
      public function fforward() : void
      {
         this.time = this._duration;
         this.fixTime();
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         this.nextFrame();
      }
      
      public function get position() : Number
      {
         return this.getPosition(this._time);
      }
      
      public function yoyo() : void
      {
         this.continueTo(this.begin,this.time);
      }
      
      public function nextFrame() : void
      {
         if(this.useSeconds)
         {
            this.time = (getTimer() - this._startTime) / 1000;
         }
         else
         {
            this.time = this._time + 1;
         }
      }
      
      protected function timerHandler(param1:TimerEvent) : void
      {
         this.nextFrame();
         param1.updateAfterEvent();
      }
      
      public function get FPS() : Number
      {
         return this._fps;
      }
      
      public function rewind(param1:Number = 0) : void
      {
         this._time = param1;
         this.fixTime();
         this.update();
      }
      
      public function set position(param1:Number) : void
      {
         this.setPosition(param1);
      }
      
      public function get time() : Number
      {
         return this._time;
      }
      
      private function update() : void
      {
         this.setPosition(this.getPosition(this._time));
      }
      
      public function start() : void
      {
         this.rewind();
         this.startEnterFrame();
         this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_START,this._time,this._position));
      }
      
      public function prevFrame() : void
      {
         if(!this.useSeconds)
         {
            this.time = this._time - 1;
         }
      }
   }
}

