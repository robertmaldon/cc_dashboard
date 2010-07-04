/**
 * jQuery.scale plugin
 * Copyright (c) 2009 Oregon State Univerisity - info(at)osuosl.org | osuosl.org
 * licensed under GPLv3.
 * Date: 9/4/2009
 *
 * @projectDescription jQuery extension for scaling an object to fit inside its parent while maintaining the aspect ratio
 * @author Rob McGuire-Dale -  rob@osuoslcom
 * @version 1.0
 *
 * @id jQuery.scale
 * @id jQuery.fn.scale
 * @param {String, [String]} In any order, enter "center" (to center the object) and/or "stretch" (to stretch the object to fit inside the parent) and/or "debug" (to turn on verbose logging)
 * @return {jQuery} Returns the same jQuery object, for chaining.
 *
 * jQuery plugin structure based on "A Really Simple jQuery Plugin Tutorial" 
 * (http://www.queness.com/post/112/a-really-simple-jquery-plugin-tutorial) by
 * Kevin Liew
 */

(function($){                               // anonymous function wrapper

    $.fn.extend({                           // attach new method to jQuery
    
        scale: function( arg1, arg2, arg3 ){// declare plugin name and parameter
        
            // iterate over current set of matched elements
            return this.each( function()
            {
                safelog( "jquery.scale is starting...");
                
                safelog( "jquery.scale: Using browser \"" + navigator.appName +
                    "\" version \"" + navigator.appVersion + "\"");

                // parse the arguments into flags
                var center = false;
                var stretch = false;
                var debug = false;
                if( arg1 == "center" || arg2 == "center" || arg3 == "center")
                    center = true;
                if( arg1 == "stretch" || arg2 == "stretch" || arg3 == "stretch")
                    stretch = true;
                if( arg1 == "debug" || arg2 == "debug" || arg3 == "debug")
                    debug = true;
            
                // capture the object
                var obj = $(this);
                
                // if this is the plugin's first run on the object, and the
                // object is an image, force a reload
                if( obj.attr('src') && 
                    !obj.attr('jquery_scale_orig-height') ){
                    
                    safelog( "jquery.scale: object is an image" );
                    var date = new Date();
                    var cursrc = obj.attr("src");
                    var newsrc = cursrc;
                    if( cursrc.indexOf('?') != -1 )
                        newsrc = cursrc.substring( 0, cursrc.indexOf('?'));
                    newsrc = newsrc + "?" + date.getTime();
                    obj.attr( "src", newsrc );
                    safelog( "jquery.scale: img src changed to " + newsrc + 
                        " to force a reload");
                    this.onload = scale;
                    
                } else {
                    safelog("jquery.scale: object is NOT an image");
                    scale();
                }
                
                // plugin's main function
                function scale()
                {
                    // if this is the plugin's first run on the object, capture
                    // the object's original dimensions
                    if( !obj.attr('jquery_scale_orig-height') ){
                        obj.attr('jquery_scale_orig-height', obj.height() );
                        obj.attr('jquery_scale_orig-width', obj.width() );
                        
                        safelog( "jquery.scale: is starting for the first " + 
                            "time. Captured the original dimensions of " + 
                            obj.width() + "x" + obj.height() );
                    
                    // if this is NOT the plugin's first run on the object,
                    // reset the object's dimensions
                    } else {           
                        obj.height( parseInt( 
                            obj.attr('jquery_scale_orig-height') ) );
                        obj.width( parseInt( 
                            obj.attr('jquery_scale_orig-width') ) );
                        
                        safelog( "jquery.scale: has been run before. Reset " +
                            "the object to its original dimensions of " + 
                            obj.width() + "x" + obj.height() );
                    }

                    safelog( "jquery.scale: BEFORE scaling, object's outer " +
                        "size = " + obj.outerWidth(  ) + "x" + 
                        obj.outerHeight(  ) + ", object's parent's inner size " +
                        "= " + obj.parent().width() + "x" + 
                        obj.parent().height() );
                    
                    // Object too tall, but width is fine. Need to shorten.
                    if( obj.outerHeight(  ) > obj.parent().height() && 
                        obj.outerWidth(  ) <= obj.parent().width() ){

                        safelog( "jquery.scale: object is too tall, but width" +
                            " is OK" );
                        matchHeight();       
                    }
                    
                    // Object too wide, but height is fine. Need to diet.
                    else if( obj.outerWidth(  ) > obj.parent().width() && 
                             obj.outerHeight(  ) <= obj.parent().height() ){

                        safelog( "jquery.scale: object is too wide, but " +
                            "height is OK" );
                        matchWidth();    
                    }
                    
                    // Object too short and skinny. If "stretch" option enabled,
                    // match the dimenstion that is closer to being correct.
                    else if( obj.outerWidth(  ) < obj.parent().width() && 
                             obj.outerHeight(  ) < obj.parent().height() &&
                             stretch ){
                      
                        safelog( "jquery.scale: object is too short and " +
                            "skinny, and stretch option enabled" );
                        if( obj.parent().height()/obj.outerHeight(  ) <= 
                            obj.parent().width()/obj.outerWidth(  ) ){
                            
                            safelog( "jquery.scale: height is closer to " +
                                "being correct, or height and width are " +
                                "equally close to being correct");
                            matchHeight();
                            
                        } else {
                            safelog( "jquery.scale: width is closer to being " +
                                "correct");
                            matchWidth();
                        }
                    
                    // Object too tall and wide. Need to match the dimension 
                    // that is further from being correct.
                    } else if( obj.outerWidth(  ) > obj.parent().width() && 
                               obj.outerHeight(  ) > obj.parent().height() ){
                               
                        safelog( "jquery.scale: object is too tall and wide");
                        if( obj.parent().height()/obj.outerHeight(  ) >
                            obj.parent().width()/obj.outerWidth(  ) ){
                            
                            safelog( "jquery.scale: width is closer to being " +
                                "correct");
                            matchWidth();
                            
                        } else {
                            safelog( "jquery.scale: height is closer to " +
                                "being correct, or height and width are " +
                                "equally close to being correct");
                            matchHeight();
                        }                            

                    }//else, object is the same size as the parent. Do nothing.

                    // if the center option is enabled, also center the object 
                    // within the parent
                    if( center ){
                        safelog( "jquery.scale: centering option enabled" );
                        obj.css( 'position', 'relative' );
                        obj.css( 'margin-top', 
                             obj.parent().height()/2 - 
                                        obj.outerHeight(  )/2  );
                        obj.css( 'margin-left', 
                             obj.parent().width()/2 - 
                                        obj.outerWidth(  )/2  );
                    }

                    // reset the onload pointer so the object doesn't flicker
                    // when reloaded other ways.
                    this.onload = null;

                    safelog( "jquery.scale: AFTER scaling, object's size = " +
                        obj.outerWidth(  ) + "x" + obj.outerHeight(  ) + 
                        ", object's parent's size = " + 
                        obj.parent().width() + "x" + 
                        obj.parent().height() + ".'" );                    
                
                }   //END scale
                
                // match the height while maintaining the aspect ratio
                function matchHeight()
                {
                    safelog( "jquery.scale: matching height" );
                    obj.width( obj.outerWidth(  ) * 
                        obj.parent().height()/obj.outerHeight(  ) - 
                        (obj.outerWidth(  ) - obj.width()));
                    obj.height( obj.parent().height() - 
                        (obj.outerHeight(  ) - obj.height()) );
                }
                
                // match the width while maintaining the aspect ratio
                function matchWidth()
                {
                    safelog( "jquery.scale: matching width" );
                    obj.height(  obj.outerHeight(  ) * 
                        obj.parent().width()/obj.outerWidth(  ) - 
                        (obj.outerHeight(  ) - obj.height())  );
                    obj.width( obj.parent().width() - 
                        (obj.outerWidth(  ) - obj.width()));
                }
                
                // a function to safely log
                function safelog( msg )
                { 
                    if( window.console && debug ) console.log( msg );
                }
                            
            });     //END matched element iterations
        }           //END plugin declaration
    });             //END new jQuery method attachment
})(jQuery);         //END anonymous function wrapper
