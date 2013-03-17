//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.extensions.starling.impl
{
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.extensions.starling.api.IStarlingViewMap;

	/**
	 *
	 * StarlingViewMap Impl
	 *
	 * @author jamieowen
	 */
	public class StarlingViewMap implements IStarlingViewMap
	{
		[Inject]
		public var mediatorMap:IMediatorMap;		
				
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/
		
		
		
		/*============================================================================*/
		/* Constructor
		/*============================================================================*/		
		
		[PostConstruct]
		public function initialize():void
		{				
			var current: Starling = Starling.current;
			if (!current.root) {				
				current.addEventListener( Event.ROOT_CREATED, onRootCreated );				
			} else {
				addStarlingView(current.stage);
				addStarlingView(current.root);
				initializeListeners();
			}
		}
		
        [PreDestroy]
		public function dispose(): void {
			var current: Starling = Starling.current;
			if (!current.root) {				
				current.removeEventListener( Event.ROOT_CREATED, onRootCreated );
			}
			disposeListeners();
		}
		
		/*============================================================================*/
		/* Public Methods
		/*============================================================================*/
		
		public function addStarlingView(view : DisplayObject) : void
		{
			mediatorMap.mediate(view);
		}

		public function removeStarlingView(view : DisplayObject) : void
		{
			mediatorMap.unmediate(view);
		}
		
		/*============================================================================*/
		/* Private Methods
		/*============================================================================*/
		
		private function onStarlingAdded( event:Event ):void
		{
			addStarlingView( event.target as DisplayObject );
		}
		
		private function onStarlingRemoved( event:Event ):void
		{
			removeStarlingView( event.target as DisplayObject );
		}
		
		private function onRootCreated( event:Event ):void
		{
			var current: Starling = Starling.current;
			current.removeEventListener( Event.ROOT_CREATED, onRootCreated );
			initializeListeners();
			
			addStarlingView(current.stage);
			addStarlingView(current.root);
		}
		
		private function initializeListeners():void
		{			
			var current: Starling = Starling.current;
			current.stage.addEventListener( Event.ADDED, onStarlingAdded );
			current.stage.addEventListener( Event.REMOVED, onStarlingRemoved );		
		}
		
		private function disposeListeners():void
		{
			var current: Starling = Starling.current;
			current.stage.removeEventListener( Event.ADDED, onStarlingAdded );
			current.stage.removeEventListener( Event.REMOVED, onStarlingRemoved );
		}
	}
}
