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
package robotlegs.extensions.starling.impl
{
	import flash.display.Stage3D;
	
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	/**
	 *
	 * @author suspendmode@gmail.com
	 *
	 */
	public class StarlingConfig
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		public var stage3D:Stage3D=null;
		public var renderMode:String="auto";
		public var profile:String="baselineConstrained";
		public var showStats:Boolean=true;
		public var statsHAlign:String=HAlign.LEFT;
		public var statsVAlign:String=VAlign.TOP;
		public var statsScale:Number=1;
		public var antiAliasing:Number=0;
		public var simulateMultitouch:Boolean=false;
		public var autoSuspend:Boolean = false;

		public function StarlingConfig(antiAliasing:Number=0, autoSuspend:Boolean = false, simulateMultitouch: Boolean = true, showStats:Boolean=true, statsHAlign:String="left", statsVAlign:String="top", statsScale:Number=1, stage3D:Stage3D=null, renderMode:String="auto", profile:String="baselineConstrained")
		{
            this.simulateMultitouch = simulateMultitouch;
            this.autoSuspend = autoSuspend;
			this.antiAliasing=antiAliasing;
			this.showStats=showStats;
			this.statsHAlign=statsHAlign;
			this.statsVAlign=statsVAlign;
			this.statsScale=statsScale;
			this.stage3D=stage3D;
			this.renderMode=renderMode;
			this.profile=profile;
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}
