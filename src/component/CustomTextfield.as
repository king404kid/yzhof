package component
{
	import flash.events.FocusEvent;
	import flash.filters.GlowFilter;
	import flash.filters.GradientBevelFilter;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.IME;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * 自定义文本显示类。
	 *  可 设置字体，颜色 ，字边缘颜色..
	 * @author liudisong
	 *
	 */
	public class CustomTextfield extends TextField
	{
		/**
		 *用于存放数据在文字中 
		 */		
		public var data:*;
		/**
		 * 文本格式设置对象
		 */
		private var _textFormat:TextFormat;
		/**
		 * 文字描边
		 */
		private var _glowFilter:GlowFilter;
		
		/**
		 * 滤镜数组
		 */
		private var _filterArray:Array;
		
		/**是否添加下划线效果*/
		private var _isUnderLine:Boolean;
		private var _texttips:String;
		
		public function CustomTextfield(isGlow:Boolean=true,typeId:int = 1)
		{
			super();
			_filterArray = [];
			
			_textFormat=new TextFormat();
			_textFormat.align=TextFormatAlign.LEFT;
			_textFormat.font = "Tahoma";
			_textFormat.size = 12;
			_textFormat.color = 0xefefef;
			_glowFilter = new GlowFilter(0x000000,1,2,2,10);
			
			if (isGlow)
			{
				if (_glowFilter!=null) 
				{
					_filterArray.push(_glowFilter);
				}
				filters=_filterArray;
			}
			
			defaultTextFormat=_textFormat;
			height=21;
			_isUnderLine = false;			
		}
		
		/**
		 * 设置HTML
		 * @param value
		 *
		 */
		override public function set htmlText(value:String):void
		{
			defaultTextFormat=defaultTextFormat;
			super.htmlText=value;
		}
		/**
		 * 设置对其方式
		 * @param value
		 *
		 */
		public function set align(value:String):void
		{
			_textFormat.align=value;
			defaultTextFormat=_textFormat;
			//text=text;
			callLater()
		}
		
		/**
		 * 指定文本是否为粗体字。默认值为 null，这意味着不使用粗体字。如果值为 true，则文本为粗体字。
		 * @param value
		 *
		 */
		public function set bold(value:Object):void
		{
			_textFormat.bold=value;
			defaultTextFormat=_textFormat;
			callLater()
		}
		
		/**
		 * 指示文本的颜色。
		 * 包含三个 8 位 RGB 颜色成分的数字；例如，0xFF0000 为红色，0x66ff00 为绿色。默认值为 null，这意味着 Flash Player 使用黑色 (0x000000)。
		 * @param value
		 *
		 */
		public function set color(value:Object):void
		{
			_textFormat.color=value;
			defaultTextFormat=_textFormat;
			//text=text;
			callLater()
		}
		
		/**
		 * 使用此文本格式的文本的字体名称，以字符串形式表示。默认值为 null，这意味着 Flash Player 对文本使用 Times New Roman 字体
		 * @param value
		 *
		 */
		public function set font(value:String):void
		{
			_textFormat.font=value;
			defaultTextFormat=_textFormat;
			//text=text;
			callLater()
		}
		
		/**
		 * 使用此文本格式的文本的磅值。默认值为 null，这意味着使用的磅值为 12
		 * @param value
		 *
		 */
		public function set size(value:Object):void
		{
			_textFormat.size=value;
			defaultTextFormat=_textFormat;
			//text=text;
			callLater()
		}
		
		/**
		 * 设置字间距
		 * @param value
		 *
		 */
		public function set letterSpacing(value:Object):void
		{
			_textFormat.letterSpacing=value;
			defaultTextFormat=_textFormat;
			//text=text;
			callLater()
		}
		
		public function get letterSpacing():Object
		{
			return _textFormat.letterSpacing;
		}
		
		/**
		 * 设置行间距
		 * @param value
		 *
		 */
		public function set leading(value:Object):void
		{
			_textFormat.leading=value;
			defaultTextFormat=_textFormat;
			//text=text;
			callLater()
		}
		
		/**
		 * 设置下划线
		 * @param value
		 *
		 */
		public function set underline(value:Object):void
		{
			_textFormat.underline=value;
			defaultTextFormat=_textFormat;
			//text=text;
			callLater()
		}
		
		/**
		 * 第一行文本缩进
		 * @param value
		 * 
		 */
		public function set indent(value:Object):void
		{
			_textFormat.indent = value;
			defaultTextFormat = _textFormat;
			//text = text;
			callLater()
		}
		private function callLater():void
		{
			text = text;
		}
		/**
		 * 设置字体边缘的颜色
		 * @param value
		 *
		 */
		public function set textBorderColor(value:uint):void
		{
			_glowFilter.color=value;
			filters=_filterArray;
			
		}
		
		/**
		 * 设置边缘的透明度
		 * @param value
		 *
		 */
		public function set textBorderAlpha(value:Number):void
		{
			_glowFilter.alpha=value;
			filters=_filterArray;
			
		}
		
		/**
		 * 设置字体边缘X方向模糊度
		 * @param value
		 *
		 */
		public function set textBorderBlurX(value:Number):void
		{
			_glowFilter.blurX=value;
			filters=_filterArray;
		}
		
		/**
		 * 设置字体边缘Y方向的模糊度
		 * @param value
		 *
		 */
		public function set textBorderBlurY(value:Number):void
		{
			_glowFilter.blurY=value;
			filters=_filterArray;
		}
		
		/**
		 * 印记或跨页的强度。
		 * 该值越高，压印的颜色越深，而且发光与背景之间的对比度也越强。有效值为 0 到 255。默认值为 2。
		 * @param value
		 *
		 */
		public function set textBorderStrength(value:Number):void
		{
			_glowFilter.strength=value;
			filters=_filterArray;
		}
		
		/**
		 *  指定发光是否为内侧发光。 值 true 表示内侧发光。 默认值为 false，即外侧发光（对象外缘周围的发光）。
		 * @return
		 *
		 */
		public function get inner():Boolean
		{
			return _glowFilter.inner;
		}
		
		/**
		 * 指定发光是否为内侧发光。 值 true 表示内侧发光。 默认值为 false，即外侧发光（对象外缘周围的发光）。
		 * @param value
		 *
		 */
		public function set inner(value:Boolean):void
		{
			_glowFilter.inner=value;
			filters=_filterArray;
		}
		
		
		
		/**
		 * 销毁对象资源
		 *
		 */
		public function dispose():void
		{
			//			ObjectShare.getInstance().setObject(this);			
		}
		
		override public function set type(value:String):void
		{
			super.type=value;
			if (TextFieldType.INPUT == value)
			{
				addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
				addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			}
		}
		
		private function focusInHandler(e:FocusEvent):void
		{
			if(type==TextFieldType.INPUT)
			{
				if(Capabilities.hasIME==true)
				{
					IME.enabled=true;
				}
			}
		}
		
		private function focusOutHandler(e:FocusEvent):void
		{
			if(Capabilities.hasIME==true)
			{
				IME.enabled=false;
			}
		}
		
		public function set isUnderLine(b:Boolean):void
		{
			_isUnderLine = b;
		}
		
		public function get isUnderLine():Boolean
		{
			return _isUnderLine;
		}
	}
}