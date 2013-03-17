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
	import starling.core.Starling;
	
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.extensions.starling.utils.DeviceCapabilities;

	/**
	 *
	 * @author suspendmode@gmail.com
	 *
	 */
	public class Multiresolution
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		/**
		 *
		 */
		protected static const ORIGINAL_DPI_IPHONE_RETINA:int=326;

		/**
		 *
		 */
		protected static const ORIGINAL_DPI_IPAD_RETINA:int=160;

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        [Inject]
        /**
         * 
         */
        public var log: ILogger;
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
		/**
		 *
		 */
		public var scale:Number=1;

        /**
         * 
         * @return 
         * 
         */
        public function get isHD(): Boolean {
            return scale>0.5;
        }
        
        /**
         * 
         * @return 
         * 
         */
        public function get isSD(): Boolean {
            return scale<=0.5;    
        }
        
		/**
		 *
		 */
		protected var _originalDPI:int;

		/**
		 *
		 * @return
		 *
		 */
		public function get originalDPI():int
		{
			return this._originalDPI;
		}

		/**
		 *
		 */
		protected var _scaleToDPI:Boolean=true;

		/**
		 *
		 * @return
		 *
		 */
		public function get scaleToDPI():Boolean
		{
			return this._scaleToDPI;
		}


		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		[PostConstruct]
		public function initialize():void
		{
			const scaledDPI:int=DeviceCapabilities.dpi / Starling.contentScaleFactor;
			this._originalDPI=scaledDPI;
			if (this._scaleToDPI)
			{
                var isTablet:Boolean = DeviceCapabilities.isTablet(Starling.current.nativeStage); 
				if (isTablet)
				{
					this._originalDPI=ORIGINAL_DPI_IPAD_RETINA;
				}
				else
				{
					this._originalDPI=ORIGINAL_DPI_IPHONE_RETINA;
				}
			}

			this.scale=scaledDPI / this._originalDPI;
            
            log.info("Multiresolution->scale:{0}, originalDPI:{1}, scaledDPI:{2}, isTablet:{3}", [scale, originalDPI, scaledDPI, isTablet]);
		}

		[PreDestroy]
		public function dispose():void
		{

		}
	}
}
