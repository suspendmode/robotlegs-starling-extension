/**
 *
 * Copyright 2012(C) by Piotr Kucharski.
 * email: suspendmode@gmail.com
 * mobile: +48 791 630 277
 *
 * All rights reserved. Any use, copying, modification, distribution and selling of this software and it's documentation
 * for any purposes without authors' written permission is hereby prohibited.
 *
 */
package robotlegs.extensions.starling
{
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.utils.instanceOfType;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.extensions.starling.api.IStarlingViewMap;
	import robotlegs.extensions.starling.impl.Multiresolution;
	import robotlegs.extensions.starling.impl.StarlingConfig;
	import robotlegs.extensions.starling.impl.StarlingRoot;
	import robotlegs.extensions.starling.impl.StarlingViewMap;

	/**
	 *
	 * @author suspendmode@gmail.com
	 *
	 */
	public class StarlingExtension implements IExtension
	{

		[Inject(optional="true")]
		public var log:ILogger;

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////        

		private var context:IContext;

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		private var injector:*;

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		private var config:StarlingConfig;

		private var root:StarlingRoot;

		private var stage:Stage;

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		private var current:Starling;

		public function extend(context:IContext):void
		{
			this.context=context;
			injector=context.injector;

			if (!log)
			{
				log=context.getLogger(this);
			}

			injector.map(Multiresolution).toSingleton(Multiresolution).seal();

			context.addConfigHandler(instanceOfType(ContextView), onContextView);
			context.addConfigHandler(instanceOfType(StarlingConfig), onStarlingConfig);
			context.addConfigHandler(instanceOfType(StarlingRoot), onStarlingRoot);
			context.beforeInitializing(beforeInitializing);
			context.whenInitializing(onInitialize);
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		private function onInitialize():void
		{
			if (!stage)
			{
				throw new IllegalOperationError("A ContextView must be installed if you install the StarlingExtension.");
			}
			if (!config)
			{
				config=new StarlingConfig();
			}
			if (!root)
			{
				root=new StarlingRoot(Sprite);
			}


			if (log)
			{
				log.debug("create starling viewport:{0}, stage w:{1}, h:{2}", [root.viewPort, stage.stageWidth, stage.stageHeight]);
			}
			current=new Starling(root.rootClass, stage, root.viewPort, config.stage3D, config.renderMode, config.profile);

			injector.map(IStarlingViewMap).toType(StarlingViewMap);
			injector.getInstance(IStarlingViewMap);

			if (config.showStats)
			{
				current.showStats=config.showStats;
				current.showStatsAt(config.statsHAlign, config.statsVAlign, config.statsScale);
			}
			current.antiAliasing=config.antiAliasing;
			current.simulateMultitouch=config.simulateMultitouch;
			injector.map(Starling).toValue(current);
			current.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			current.start();
			running=true;
		}

		private function onRootCreated(event:starling.events.Event):void
		{
			current.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			root.view=DisplayObjectContainer(current.root);
			injector.map(StarlingRoot).toValue(root);
			stage.addEventListener(flash.events.Event.RESIZE, stageResized);
			if (config.autoSuspend)
			{
				stage.addEventListener(flash.events.Event.ACTIVATE, stageActivated);
				stage.addEventListener(flash.events.Event.DEACTIVATE, stageDeactivated);
			}
            updateViewport();
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		/**
		 *
		 * @param event
		 *
		 */
		private function stageResized(event:flash.events.Event):void
		{
            updateViewport();
        }
        
        private function updateViewport(): void {

			var newWidth:Number=stage.stageWidth;
			var newHeight:Number=stage.stageHeight;

			current.stage.stageWidth=newWidth;
			current.stage.stageHeight=newHeight;
			const viewPort:Rectangle=current.viewPort;
			viewPort.width=newWidth;
			viewPort.height=newHeight;
			root.viewPort=viewPort;
			current.viewPort=viewPort;
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		private function stageActivated(event:flash.events.Event):void
		{
			if (!running)
			{
				current.start();
				running=true;
			}
		}

		private function stageDeactivated(event:flash.events.Event):void
		{
			if (running)
			{
				current.stop();
				running=false;
			}
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		private function onContextView(contextView:ContextView):void
		{
			if (stage != contextView.view.stage)
			{
				stage=contextView.view.stage;
			}
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		private function onStarlingConfig(config:StarlingConfig):void
		{
			if (this.config != config)
			{
				this.config=config;
			}
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		private function onStarlingRoot(root:StarlingRoot):void
		{
			if (this.root != root)
			{
				this.root=root;
			}
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		private function beforeInitializing():void
		{
			if (!stage)
			{
				if (log)
				{
					log.error("A Stage or ContextView must be installed if you install the StarlingExtension.");
				}
			}
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		[PreDestroy]
		public function dispose():void
		{
			stage.removeEventListener(flash.events.Event.RESIZE, stageResized);

			if (config.autoSuspend)
			{
				stage.removeEventListener(flash.events.Event.ACTIVATE, stageActivated);
				stage.removeEventListener(flash.events.Event.DEACTIVATE, stageDeactivated);
			}
			stage=null;
			context=null;
			injector=null;
			config=null;
			root=null;
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		private var _running:Boolean=false;
		;

		public function get running():Boolean
		{
			return _running;
		}

		public function set running(value:Boolean):void
		{
			if (_running == value)
				return;
			_running=value;
		}

	}
}
