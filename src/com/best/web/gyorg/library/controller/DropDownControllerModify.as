package com.best.web.gyorg.library.controller
{
	import com.best.web.gyorg.library.manager.TimerManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.SandboxMouseEvent;
	import mx.managers.ISystemManager;
	
	import spark.components.Button;
	import spark.events.DropDownEvent;
	
	use namespace mx_internal;
	
	public class DropDownControllerModify extends EventDispatcher
	{
		public function DropDownControllerModify(target:IEventDispatcher=null)
		{
			super(target);
		}
		
//		private var _checkChildDropDown:Boolean;//检查子实例是否含有 DropDown的实例
//		public function set checkChildDropDown(value:Boolean):void
//		{
//			_checkChildDropDown = value;
//		}
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private var mouseIsDown:Boolean;
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//----------------------------------
		//  openButton
		//----------------------------------
		private var _openComponent:DisplayObjectContainer;
		/**
		 *  A reference to the <code>openButton</code> skin part 
		 *  of the drop-down component. 
		 *         
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function set openComponent(value:DisplayObjectContainer):void
		{
			if (_openComponent === value)
				return;
			
			removeOpenTriggers();
			_openComponent = value;
			addOpenTriggers();
		}
		
		/**
		 *  @private 
		 */
		public function get openComponent():DisplayObjectContainer
		{
			return _openComponent;
		}
		/**
		 *  @private 
		 */
		private var _systemManager:ISystemManager;
		
		/**
		 *  A reference to the <code>SystemManager</code> used 
		 *  for mouse tracking.  if none is specified, the controller
		 *  will use the systemManager associated with the openButton.
		 *         
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function set systemManager(value:ISystemManager):void
		{
			_systemManager = value; 
		}
		/**
		 *  @private 
		 */
		public function get systemManager():ISystemManager
		{
			return (_systemManager != null) ? _systemManager: null;
		}
		
		/**
		 *  A list of display objects to consider part of the hit area
		 *  of the drop down.  Mouse clicks within any component listed
		 *  as an inclusion will not automatically close the drop down.
		 *         
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var hitAreaAdditions:Vector.<DisplayObject>;
		
		//----------------------------------
		//  dropDown
		//----------------------------------
		
		private var _dropDown:DisplayObject;
		/**
		 *  @private 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function set dropDown(value:DisplayObject):void
		{
			if (_dropDown === value)
				return;
//			if(_dropDown != null){
//				_dropDown.removeEventListener(Event.ADDED_TO_STAGE,dropDownAddToStage);
//			}
			_dropDown = value;
//			_dropDown.addEventListener(Event.ADDED_TO_STAGE,dropDownAddToStage,false,0,true);
		}   
		
//		private function dropDownAddToStage(e:Event):void
//		{
//			if(_checkChildDropDown)checkDropDown();
//		}
//		
//		private function checkDropDown():void
//		{
//			hitAreaAdditions = null;
//			if(_dropDown is DisplayObjectContainer)searchChildDropDown(_dropDown as DisplayObjectContainer);
//		}
//		
//		private function searchChildDropDown(parent:DisplayObjectContainer):void
//		{
//			if(parent.hasOwnProperty("numElements")){
//				var numChildren:int = parent["numElements"];
//				var isComponent:Boolean = true;
//			}else{
//				numChildren = parent.numChildren;
//			}
//			for (var i:int = 0; i < numChildren; i++) 
//			{
//				if(isComponent && parent.hasOwnProperty("getElementAt")){
//					var child:DisplayObject = parent["getElementAt"](i);
//				}else{
//					child = parent.getChildAt(i);
//				}
//				if(child.hasOwnProperty("getPopupDialogInstance")){
//					pushDropDownInstance(child["getPopupDialogInstance"]());
//				}
//				if(child is DisplayObjectContainer){
//					searchChildDropDown(child as DisplayObjectContainer);
//				}
//			}
//		}
//		
		public function pushChildDropDownInstance(instance:DisplayObject):void{
			if(hitAreaAdditions == null)hitAreaAdditions = new Vector.<DisplayObject>();
			if(hitAreaAdditions.indexOf(instance) < 0)//还不存在
				hitAreaAdditions.push(instance);
		}
		
		public function removeChildDropDownInstance(instance:DisplayObject):void{
			if(hitAreaAdditions != null){
				var index:int = hitAreaAdditions.indexOf(instance);
				if(index >= 0){
					hitAreaAdditions.splice(index,1);
				}
			}
		}
		
		/**
		 *  @private 
		 */
		public function get dropDown():DisplayObject
		{
			return _dropDown;
		}
		//----------------------------------
		//  isOpen
		//----------------------------------
		/**
		 *  @private 
		 */
		private var _isOpen:Boolean = false;
		
		/**
		 *  Contains <code>true</code> if the drop down is open.   
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */  
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		//----------------------------------
		//  closeOnResize
		//----------------------------------
		
		private var _closeOnResize:Boolean = true;
		
		/**
		 *  When <code>true</code>, resizing the system manager 
		 *  closes the drop down.
		 *  For mobile applications, you can set this property
		 *  to <code>false</code> so that the drop down stays open when the 
		 *  page orientation changes.
		 * 
		 *  @default true
		 *  
		 *  @langversion 3.0
		 *  @playerversion AIR 3
		 *  @productversion Flex 4.6
		 */
		public function get closeOnResize():Boolean
		{
			return _closeOnResize;
		}
		
		/**
		 *  @private 
		 */
		public function set closeOnResize(value:Boolean):void
		{
			if (_closeOnResize == value)
				return;
			
			// remove existing resize listener if present
			if (isOpen)
				removeCloseOnResizeTrigger();
			
			_closeOnResize = value;
			
			addCloseOnResizeTrigger();
		}
		
		//----------------------------------
		//  rolloverOpenDelay
		//----------------------------------
		
		private var _rollOverOpenDelay:Number = Number.NaN;
		private var _rollOutCloseDelay:Number = Number.NaN;
		public function get rollOutCloseDelay():Number
		{
			return _rollOutCloseDelay;
		}

		public function set rollOutCloseDelay(value:Number):void
		{
			_rollOutCloseDelay = value;
			if (_rollOutCloseDelay == value)
				return;
			
			removeOpenTriggers();
			
			_rollOutCloseDelay = value;
			
			addOpenTriggers();
		}

//		private var rollOverOpenDelayTimer:Timer;
//		private var rollOutCloseDelayTimer:Timer;//移开后延迟消失
		/**
		 *  Specifies the delay, in milliseconds, to wait for opening the drop down 
		 *  when the anchor button is rolled over.  
		 *  If set to <code>NaN</code>, then the drop down opens on a click, not a rollover.
		 * 
		 *  @default NaN
		 *         
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get rollOverOpenDelay():Number
		{
			return _rollOverOpenDelay;
		}
		
		/**
		 *  @private 
		 */
		public function set rollOverOpenDelay(value:Number):void
		{
			if (_rollOverOpenDelay == value)
				return;
			
			removeOpenTriggers();
			
			_rollOverOpenDelay = value;
			
			addOpenTriggers();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------   
		
		/**
		 *  @private 
		 *  Adds event triggers to the openButton to open the popup.
		 * 
		 *  <p>This is called from the openButton setter after the openButton has been set.</p>
		 */ 
		private function addOpenTriggers():void
		{
			if (openComponent)
			{
				if (isNaN(rollOverOpenDelay))
					openComponent.addEventListener(MouseEvent.MOUSE_DOWN, openButton_buttonDownHandler);
				else
					openComponent.addEventListener(MouseEvent.ROLL_OVER, openButton_rollOverHandler);
			}
		}
		
		/**
		 *  @private
		 *  Removes event triggers from the openButton to open the popup.
		 * 
		 *  <p>This is called from the openButton setter after the openButton has been set.</p>
		 */ 
		private function removeOpenTriggers():void
		{
			// TODO (jszeto): Change this to be mouseDown. Figure out how to not 
			// trigger systemManager_mouseDown.
			if (openComponent)
			{
				if (isNaN(rollOverOpenDelay))
					openComponent.removeEventListener(FlexEvent.BUTTON_DOWN, openButton_buttonDownHandler);
				else
					openComponent.removeEventListener(MouseEvent.ROLL_OVER, openButton_rollOverHandler);
			}
		}
		
		/**
		 *  @private
		 *  Adds event triggers close the popup.
		 * 
		 *  <p>This is called when the drop down is popped up.</p>
		 */ 
		private function addCloseTriggers():void
		{
			if (systemManager)
			{
				if (isNaN(rollOverOpenDelay))
				{
					systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_DOWN, systemManager_mouseDownHandler);
					systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, systemManager_mouseDownHandler);
					systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, systemManager_mouseUpHandler_noRollOverOpenDelay);
				}
				else
				{
					systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE, systemManager_mouseMoveHandler);
					systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, systemManager_mouseMoveHandler);
					// MOUSEUP triggers may be added in systemManager_mouseMoveHandler
				}
				
				addCloseOnResizeTrigger();
				
//				if (openComponent && openComponent.systemManager)
//					openComponent.systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_WHEEL, systemManager_mouseWheelHandler);
			}
		}
		
		private function addCloseOnResizeTrigger():void
		{
			if (closeOnResize)
				systemManager.getSandboxRoot().addEventListener(Event.RESIZE, systemManager_resizeHandler, false, 0, true);
		}
		
		/**
		 *  @private
		 *  Adds event triggers close the popup.
		 * 
		 *  <p>This is called when the drop down is closed.</p>
		 */ 
		private function removeCloseTriggers():void
		{
			if (systemManager)
			{
				if (isNaN(rollOverOpenDelay))
				{
					systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_DOWN, systemManager_mouseDownHandler);
					systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, systemManager_mouseDownHandler);
					systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, systemManager_mouseUpHandler_noRollOverOpenDelay);
				}
				else
				{
					systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, systemManager_mouseMoveHandler);
					systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, systemManager_mouseMoveHandler);
					systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, systemManager_mouseUpHandler);
					systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, systemManager_mouseUpHandler);
				}
				
				removeCloseOnResizeTrigger();
				
//				if (openComponent && openComponent.systemManager)
//					openComponent.systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_WHEEL, systemManager_mouseWheelHandler);
			}
		} 
		
		private function removeCloseOnResizeTrigger():void
		{
			if (closeOnResize)
				systemManager.getSandboxRoot().removeEventListener(Event.RESIZE, systemManager_resizeHandler);
		}
		
		/**
		 *  @private
		 *  Helper method for the mouseMove and mouseUp handlers to see if 
		 *  the mouse is over a "valid" region.  This is used to help determine 
		 *  when the dropdown should be closed.
		 */ 
		private function isTargetOverDropDownOrOpenButton(target:DisplayObject):Boolean
		{
			if (target)
			{
				// check if the target is the openButton or contained within the openButton
				if (openComponent && openComponent.contains(target))
					return true;
				if (hitAreaAdditions != null)
				{
					for (var i:int = 0;i<hitAreaAdditions.length;i++)
					{
						if (hitAreaAdditions[i] == target ||
							((hitAreaAdditions[i] is DisplayObjectContainer) && DisplayObjectContainer(hitAreaAdditions[i]).contains(target as DisplayObject)))
							return true;
					}
				}
				
				// check if the target is the dropdown or contained within the dropdown
				if (dropDown is DisplayObjectContainer)
				{
					if (DisplayObjectContainer(dropDown).contains(target))
						return true;
				}
				else
				{
					if (target == dropDown)
						return true;
				}
			}
			
			return false;
		}
		
		/**
		 *  Open the drop down and dispatch a <code>DropdownEvent.OPEN</code> event. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */ 
		public function openDropDown():void
		{
			openDropDownHelper(true);
		}   
		
		/**
		 *  @private
		 *  Set isProgrammatic to true if you are opening the dropDown programmatically 
		 *  or not through a mouse click or rollover.  
		 */ 
		private function openDropDownHelper(isProgrammatic:Boolean = false):void
		{
			if (!isOpen)
			{
				addCloseTriggers();
				
				_isOpen = true;
				// Force the button to stay in the down state
				if (openComponent is Button)
					(openComponent as Button).keepDown(true, !isProgrammatic); 
				
				dispatchEvent(new DropDownEvent(DropDownEvent.OPEN));
			}
		}
		
		/**
		 *  Close the drop down and dispatch a <code>DropDownEvent.CLOSE</code> event.  
		 *   
		 *  @param commit If <code>true</code>, commit the selected
		 *  data item. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function closeDropDown(commit:Boolean,isAtonce:Boolean = false):void
		{
			if(isAtonce || _rollOutCloseDelay == 0 || isNaN(_rollOutCloseDelay)){
				TimerManager.clearTimeOut(doClose);//将要关闭的计时器关闭掉先
				doClose(commit);
			}else{
				TimerManager.setTimeOut(_rollOutCloseDelay,doClose,commit);
//				setTimeout(doClose,_rollOutCloseDelay,commit);
			}
		}   
		
		private function doClose(commit:Boolean):void{
			if (isOpen)
			{   
				_isOpen = false;
				
				if (openComponent is Button)
					(openComponent as Button).keepDown(false);
				
				var dde:DropDownEvent = new DropDownEvent(DropDownEvent.CLOSE, false, true);
				
				if (!commit)
					dde.preventDefault();
				
				dispatchEvent(dde);
				
				removeCloseTriggers();
			}
		}
		//--------------------------------------------------------------------------
		//
		//  Event handling
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Called when the buttonDown event is dispatched. This function opens or closes
		 *  the dropDown depending upon the dropDown state. 
		 */ 
		mx_internal function openButton_buttonDownHandler(event:Event):void
		{
			if (isOpen)
				closeDropDown(true);
			else
			{
				mouseIsDown = true;
				openDropDownHelper();
			}
		}
		
		/**
		 *  @private
		 *  Called when the openButton's <code>rollOver</code> event is dispatched. This function opens 
		 *  the drop down, or opens the drop down after the length of time specified by the 
		 *  <code>rollOverOpenDelay</code> property.
		 */ 
		mx_internal function openButton_rollOverHandler(event:MouseEvent):void
		{
			TimerManager.clearTimeOut(doClose);//将要关闭的计时器关闭掉先
			if (rollOverOpenDelay == 0)
				openDropDownHelper();
			else
			{
				openComponent.addEventListener(MouseEvent.ROLL_OUT, openButton_rollOutHandler);
//				rollOverOpenDelayTimer = new Timer(rollOverOpenDelay, 1);
//				rollOverOpenDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, rollOverDelay_timerCompleteHandler);
//				rollOverOpenDelayTimer.start();
				TimerManager.setTimeOut(rollOverOpenDelay,rollOverDelay_timerCompleteHandler);
			}
		}
		
		/**
		 *  @private 
		 *  Called when the openButton's rollOut event is dispatched while waiting 
		 *  for the rollOverOpenDelay. This will cancel the timer so we don't open
		 *  any more.
		 */ 
		private function openButton_rollOutHandler(event:MouseEvent):void
		{
//			if (rollOverOpenDelayTimer && rollOverOpenDelayTimer.running)
//			{
//				rollOverOpenDelayTimer.stop();
//				rollOverOpenDelayTimer = null;
//			}
			TimerManager.clearTimeOut(rollOverDelay_timerCompleteHandler);
			openComponent.removeEventListener(MouseEvent.ROLL_OUT, openButton_rollOutHandler);
		}
		
		/**
		 *  @private
		 *  Called when the rollOverDelay Timer is up and we should show the drop down.
		 */ 
		private function rollOverDelay_timerCompleteHandler(event:TimerEvent = null):void
		{
			openComponent.removeEventListener(MouseEvent.ROLL_OUT, openButton_rollOutHandler);
//			rollOverOpenDelayTimer = null;
			
			openDropDownHelper();
		}
		
		/**
		 *  @private
		 *  Called when the systemManager receives a mouseDown event. This closes
		 *  the dropDown if the target is outside of the dropDown. 
		 */     
		mx_internal function systemManager_mouseDownHandler(event:Event):void
		{
			// stop here if mouse was down from being down on the open button
			if (mouseIsDown)
			{
				mouseIsDown = false;
				return;
			}
			
			if (!dropDown || 
				(dropDown && 
					(event.target == dropDown 
						|| (dropDown is DisplayObjectContainer && 
							!DisplayObjectContainer(dropDown).contains(DisplayObject(event.target))))))
			{
				// don't close if it's on the openButton
				var target:DisplayObject = event.target as DisplayObject;
				if (openComponent && target && openComponent.contains(target))
					return;
				
				if (hitAreaAdditions != null)
				{
					for (var i:int = 0;i<hitAreaAdditions.length;i++)
					{
						if (hitAreaAdditions[i] == event.target ||
							((hitAreaAdditions[i] is DisplayObjectContainer) && DisplayObjectContainer(hitAreaAdditions[i]).contains(event.target as DisplayObject)))
							return;
					}
				}
				
				closeDropDown(true);
			} 
		}
		
		/**
		 *  @private
		 *  Called when the dropdown is popped up from a rollover and the mouse moves 
		 *  anywhere on the screen.  If the mouse moves over the openButton or the dropdown, 
		 *  the popup will stay open.  Otherwise, the popup will close.
		 */ 
		mx_internal function systemManager_mouseMoveHandler(event:Event):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			var containedTarget:Boolean = isTargetOverDropDownOrOpenButton(target);
			TimerManager.clearTimeOut(doClose);//将要关闭的计时器关闭掉先
			if (containedTarget)
				return;
			
			// if the mouse is down, wait until it's released to close the drop down
			if ((event is MouseEvent && MouseEvent(event).buttonDown) ||
				(event is SandboxMouseEvent && SandboxMouseEvent(event).buttonDown))
			{
				systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, systemManager_mouseUpHandler);
				systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, systemManager_mouseUpHandler);
				return;
			}
			
			closeDropDown(true);
		}
		
		/**
		 *  @private
		 *  Debounce the mouse
		 */
		mx_internal function systemManager_mouseUpHandler_noRollOverOpenDelay(event:Event):void
		{
			// stop here if mouse was down from being down on the open button
			if (mouseIsDown)
			{
				mouseIsDown = false;
				return;
			}
		}
		
		/**
		 *  @private
		 *  Called when the dropdown is popped up from a rollover and the mouse is released 
		 *  anywhere on the screen.  This will close the popup.
		 */ 
		mx_internal function systemManager_mouseUpHandler(event:Event):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			var containedTarget:Boolean = isTargetOverDropDownOrOpenButton(target);
			
			// if we're back over the target area, remove this event listener
			// and do nothing.  we handle this in mouseMoveHandler()
			if (containedTarget)
			{
				systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, systemManager_mouseUpHandler);
				systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, systemManager_mouseUpHandler);
				return;
			}
			
			closeDropDown(true);
		}
		
		/**
		 *  @private
		 *  Close the dropDown if the stage has been resized.
		 */
		mx_internal function systemManager_resizeHandler(event:Event):void
		{
			closeDropDown(true);
		}       
		
		/**
		 *  @private
		 *  Called when the mouseWheel is used
		 */
		private function systemManager_mouseWheelHandler(event:MouseEvent):void
		{
			// Close the dropDown unless we scrolled over the dropdown and the dropdown handled the event
			if (dropDown && !(DisplayObjectContainer(dropDown).contains(DisplayObject(event.target)) && event.isDefaultPrevented()))
				closeDropDown(false);
		}
		
		/**
		 *  Close the drop down if it is no longer in focus.
		 *
		 *  @param event The event object for the <code>FOCUS_OUT</code> event.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function processFocusOut(event:FocusEvent):void
		{
			// Note: event.relatedObject is the object getting focus.
			// It can be null in some cases, such as when you open
			// the dropdown and then click outside the application.
			
			// If the dropdown is open...
			if (isOpen)
			{
				// If focus is moving outside the dropdown...
				if (!event.relatedObject ||
					(!dropDown || 
						(dropDown is DisplayObjectContainer &&
							!DisplayObjectContainer(dropDown).contains(event.relatedObject))))
				{
					// Close the dropdown.
					closeDropDown(true);
				}
			}
		}
		
		/**
		 *  Handles the keyboard user interactions.
		 *
		 *  @param event The event object from the keyboard event.
		 * 
		 *  @return Returns <code>true</code> if the <code>keyCode</code> was 
		 *  recognized and handled.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4 
		 */
		public function processKeyDown(event:KeyboardEvent):Boolean
		{
			
			if (event.isDefaultPrevented())
				return true;
			
			if (event.ctrlKey && event.keyCode == Keyboard.DOWN)
			{
				openDropDownHelper(true); // Programmatically open
				event.preventDefault();
			}
			else if (event.ctrlKey && event.keyCode == Keyboard.UP)
			{
				closeDropDown(true);
				event.preventDefault();
			}    
			else if (event.keyCode == Keyboard.ENTER)
			{
				// Close the dropDown and eat the event if appropriate.
				if (isOpen)
				{
					closeDropDown(true);
					event.preventDefault();
				}
			}
			else if (event.keyCode == Keyboard.ESCAPE)
			{
				// Close the dropDown and eat the event if appropriate.
				if (isOpen)
				{
					closeDropDown(false);
					event.preventDefault();
				}
			}
			else
			{
				return false;
			}   
			
			return true;        
		}
	}
}