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
    import flash.geom.Rectangle;
    
    import starling.core.Starling;
    import starling.display.DisplayObjectContainer;
    import robotlegs.extensions.starling.utils.DeviceCapabilities;
    
    /**
     *
     * @author suspendmode@gmail.com
     *
     */
    public class StarlingRoot
    {
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        public var rootClass:Class;
        
        public var viewPort:Rectangle=null;
        
        public var view:DisplayObjectContainer;
            
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        public function StarlingRoot(rootClass:Class, viewPort:Rectangle=null)
        {
            this.rootClass = rootClass;
            this.viewPort = viewPort;            
        }
        
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
                if (DeviceCapabilities.isTablet(Starling.current.nativeStage))
                {
                    this._originalDPI=ORIGINAL_DPI_IPAD_RETINA;
                }
                else
                {
                    this._originalDPI=ORIGINAL_DPI_IPHONE_RETINA;
                }
            }
            
            this.scale=scaledDPI / this._originalDPI;
        }
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        [PreDestroy]
        public function dispose():void
        {
            
        }

        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
    }
}