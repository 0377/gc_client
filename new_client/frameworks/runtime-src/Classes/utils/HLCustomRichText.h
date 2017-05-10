/****************************************************************************
 Copyright (c) 2013 cocos2d-x.org
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#ifndef __UIHLCustomRichText_H__
#define __UIHLCustomRichText_H__

#include "ui/UIListView.h"
#include "ui/GUIExport.h"
#include "ui/UIScale9Sprite.h"
#include "ui/UIButton.h"
#include "ui/UIText.h"
#include "cocos2d.h"
NS_CC_BEGIN
/**
 * @addtogroup ui
 * @{
 */

namespace ui {
    struct ShadowConfig
    {
        Color4B shadow4BColor;
        Size        shadowOffset;
        int          shadowblurRadius;
    };
    /**
     *@brief Rich text element base class.
     * It defines the basic common properties for all rich text element.
     */
    typedef enum
    {
        RICHTEXT_ANCHOR_CLICKED,
    }
    CustomRichTextEventType;
    typedef void (Ref::*SEL_RichTextClickEvent)(Ref*, CustomRichTextEventType);
#define richtextclickselector(_SELECTOR) (SEL_RichTextClickEvent)(&_SELECTOR)
    
#pragma mark - Class LinkLabel

    class LinkLabel;
    class LableDelegate
    {
    public:
        virtual void labelClicked(LinkLabel* lab) = 0;
    };
    
    class LinkLabel : public Label
    {
    public:
        LinkLabel(FontAtlas *atlas = nullptr, TextHAlignment hAlignment = TextHAlignment::LEFT,
                  TextVAlignment vAlignment = TextVAlignment::TOP, bool useDistanceField = false, bool useA8Shader = false);
        
        virtual ~LinkLabel();
        
        static LinkLabel* createLinkLabel(const std::string& text, const std::string& fontFile, float fontSize, const Size& dimensions = Size::ZERO,
                                 TextHAlignment hAlignment = TextHAlignment::LEFT, TextVAlignment vAlignment = TextVAlignment::TOP);
        
        void setLableDelegate(LableDelegate* ld) { _delegate = ld; }
        void enableLinkLine(const Color4B& linkcolor, GLubyte linksize) ;
        bool onTouchBegan(Touch *touch, Event *unusedEvent);
        void onTouchEnded(Touch *touch, Event *unusedEvent);
        void touchEvent(Ref *pSender, Widget::TouchEventType type);
        Button* getLinkline() { return _linkline;}
        CC_SYNTHESIZE(float, fontSize, FontSize);
    protected:
        EventListenerTouchOneByOne* _touchListener;
        Button* _linkline;
        LableDelegate* _delegate;
        Color4B _linkcolor;
        GLubyte _linksize;
    };
    
#pragma mark - Class HLCustomRichTextItem
    class  HLCustomRichElement : public Ref
    {
    public:
        /**
         *@brief Rich element type.
         */
        enum class Type
        {
            TEXT,
            IMAGE,
            CUSTOM
        };
        
        /**
         * @brief Default constructor.
         */
        HLCustomRichElement(){};
        
        /**
         * @brief Default destructor.
         */
        virtual ~HLCustomRichElement(){};
        
        
        /**
         * @brief Initialize a rich element with different arguments.
         *
         * @param tag A integer tag value.
         * @param color A color in @see `Color3B`.
         * @param opacity A opacity value in `GLubyte`.
         * @return True if initialize success, false otherwise.
         */
        bool init(int tag, const Color3B& color, GLubyte opacity);
    protected:
        Type _type;
        int _tag;
        Color3B _color;
        GLubyte _opacity;
        friend class HLCustomRichText;
    };
    
    /**
     *@brief Rich element for displaying text.
     */
    #pragma mark - Class HLCustomRichElementText
    class  HLCustomRichElementText : public HLCustomRichElement
    {
    public:
        
        /**
         *@brief Default constructor.
         */
        HLCustomRichElementText(){_type = Type::TEXT;};
        
        
        /**
         *@brief Default destructor.
         */
        virtual ~HLCustomRichElementText(){};
        
        /**
         * @brief Initialize a HLCustomRichTextText with various arguments.
         *
         * @param tag A integer tag value.
         * @param color A color in Color3B.
         * @param opacity A opacity in GLubyte.
         * @param text Content string.
         * @param fontName Content font name.
         * @param fontSize Content font size.
         * @return True if initialize scucess, false otherwise.
         */
        bool init(int tag, const Color3B& color, GLubyte opacity, const std::string& text, const std::string& fontName, float fontSize);
        
        
        /**
         * @brief Create a HLCustomRichTextText with various arguments.
         *
         * @param tag A integer tag value.
         * @param color A color in Color3B.
         * @param opacity A opacity in GLubyte.
         * @param text Content string.
         * @param fontName Content font name.
         * @param fontSize Content font size.
         * @return HLCustomRichTextText instance.
         */
        static HLCustomRichElementText* create(int tag, const Color3B& color, GLubyte opacity, const std::string& text, const std::string& fontName, float fontSize);
        void enableOutLine(const Color4B& outcolor, GLubyte outlinesize)
        {
            _outcolor = outcolor;
            _outlinesize = outlinesize;
        }
        void enableLinkLine(const Color4B& linkcolor, GLubyte linksize)
        {
            _linkcolor = linkcolor;
            _linksize = linksize;
        }
    protected:
        std::string _text;
        std::string _fontName;
        float _fontSize;
        Color4B _outcolor;
        Color4B _linkcolor;
        GLubyte _linksize;
        GLubyte _outlinesize;
        friend class HLCustomRichText;
    };
    
    /**
     *@brief Rich element for displaying images.
     */
        #pragma mark - Class HLCustomRichElementImage
    class  HLCustomRichElementImage : public HLCustomRichElement
    {
    public:
        
        /**
         * @brief Default constructor.
         *
         */
        HLCustomRichElementImage(){_type = Type::IMAGE;};
        
        
        /**
         * @brief Default destructor.
         */
        virtual ~HLCustomRichElementImage(){};
        
        
        /**
         * @brief Initialize a HLCustomRichTextImage with various arguments.
         *
         * @param tag A integer tag value.
         * @param color A color in Color3B.
         * @param opacity A opacity in GLubyte.
         * @param filePath A image file name.
         * @return True if initialize success, false otherwise.
         */
        bool init(int tag, const Color3B& color, GLubyte opacity, const std::string& filePath);
        
        
        /**
         * @brief Create a HLCustomRichTextImage with various arguments.
         *
         * @param tag A integer tag value.
         * @param color A color in Color3B.
         * @param opacity A opacity in GLubyte.
         * @param filePath A image file name.
         * @return A HLCustomRichTextImage instance.
         */
        static HLCustomRichElementImage* create(int tag, const Color3B& color, GLubyte opacity, const std::string& filePath);
    protected:
        std::string _filePath;
        Rect _textureRect;
        int _textureType;
        friend class HLCustomRichText;
    };
    
    /**
     *@brief Rich element for displaying custom node type.
     */
            #pragma mark - Class HLCustomRichElementCustomNode
    class  HLCustomRichElementCustomNode : public HLCustomRichElement
    {
    public:
        
        /**
         * @brief Default constructor.
         */
        HLCustomRichElementCustomNode(){_type = Type::CUSTOM;};
        
        
        /**
         * @brief Default destructor.
         */
        virtual ~HLCustomRichElementCustomNode(){CC_SAFE_RELEASE(_customNode);};
        
        
        /**
         * @brief Initialize a HLCustomRichTextCustomNode with various arguments.
         *
         * @param tag A integer tag value.
         * @param color A color in Color3B.
         * @param opacity A opacity in GLubyte.
         * @param customNode A custom node pointer.
         * @return True if initialize success, false otherwise.
         */
        bool init(int tag, const Color3B& color, GLubyte opacity, Node* customNode);
        
        /**
         * @brief Create a HLCustomRichTextCustomNode with various arguments.
         *
         * @param tag A integer tag value.
         * @param color A color in Color3B.
         * @param opacity A opacity in GLubyte.
         * @param customNode A custom node pointer.
         * @return A HLCustomRichTextCustomNode instance.
         */
        static HLCustomRichElementCustomNode* create(int tag, const Color3B& color, GLubyte opacity, Node* customNode);
    protected:
        Node* _customNode;
        friend class HLCustomRichText;
    };
    
    /**
     *@brief A container for displaying various HLCustomRichTexts.
     * We could use it to display texts with images easily.
     */
                #pragma mark - Class HLCustomRichText
    class  HLCustomRichText : public ScrollView,public LableDelegate
    {
    public:
        enum class  TextHorizontalAlignment
        {
            LEFT,
            CENTER,
            RIGHT,
        };
        enum class  TextVerticalAlignment
        {
            TOP,
            MID,
            BUTTOM,
        };
        
        /**
         * @brief Default constructor.
         */
        HLCustomRichText();
        
        /**
         * @brief Default destructor.
         */
        virtual ~HLCustomRichText();
        
        /**
         * @brief Create a empty HLCustomRichText.
         *
         * @return HLCustomRichText instance.
         */
        static HLCustomRichText* create();
        
        /**
         * @brief Insert a HLCustomRichText at a given index.
         *
         * @param element A HLCustomRichText type.
         * @param index A given index.
         */
        void insertElement(HLCustomRichElement* element, int index);
        
        /**
         * @brief Add a HLCustomRichText at the end of HLCustomRichText.
         *
         * @param element A HLCustomRichText instance.
         */
        void pushBackElement(HLCustomRichElement* element);
        
        /**
         * @brief Remove a HLCustomRichText at a given index.
         *
         * @param index A integer index value.
         */
        void removeElement(int index);
        
        /**
         * @brief Remove specific HLCustomRichText.
         *
         * @param element A HLCustomRichText type.
         */
        void removeElement(HLCustomRichElement* element);
        
        /**
         * @brief Set vertical space between each HLCustomRichText.
         *
         * @param space Point in float.
         */
        void setVerticalSpace(float space);
        
        /**
         * @brief Rearrange all HLCustomRichText in the HLCustomRichText.
         * It's usually called internally.
         */
//        virtual void enableShadow(const Color4B& shadowColor = Color4B::BLACK,const Size &offset = Size(2,-2), int blurRadius = 0);
        void formatText();
        virtual void onEnter() override;
        //override functions.
        virtual void setAnchorPoint(const Vec2 &pt) override;
        virtual Size getVirtualRendererSize() const override;
        virtual void ignoreContentAdaptWithSize(bool ignore) override;
        virtual std::string getDescription() const override;
//        virtual void setMaxLine(short lineCount) {_maxline = lineCount; }
        CC_CONSTRUCTOR_ACCESS:
        virtual bool init() override;
        void labelClicked(LinkLabel* lab) override;
        //add a call back function would called when checkbox is selected or unselected.
        void addEventListenerRichText(Ref* target, SEL_RichTextClickEvent selector);
        CC_SYNTHESIZE(std::string,showTextStr,ShowTextStr);
        CC_SYNTHESIZE(TextHorizontalAlignment,textHorizontalAlign,TextHorizontalAlign);
        CC_SYNTHESIZE(TextVerticalAlignment,textVerticalAlign,TextVerticalAlign);
        void enableShadow(const Color4B& shadowColor = Color4B::BLACK,
                          const Size &offset = Size(2,-2),
                          int blurRadius = 0);
        float getMaxWidthForAllElement(){ return _maxWidthForElement;};
//        float minHeight;
    protected:
        virtual void adaptRenderers() override;
        ShadowConfig  _shadowConfig;
        bool                  _isShadow;
        virtual void initRenderer() override;
        void pushToContainer(Node* renderer);
		void handleTextRenderer(HLCustomRichElementText* item, const char* text);
        void handleImageRenderer(const std::string& fileParh, const Color3B& color, GLubyte opacity);
        void handleCustomRenderer(Node* renderer);
        void formarRenderers();
        void addNewLine();
        LinkLabel* createLabel(HLCustomRichElementText* item, const char* text);
    protected:
        float   _maxWidthForElement;
        bool _formatTextDirty;
        Vector<HLCustomRichElement* > _richElements;
        std::vector<Vector<Node*>*> _elementRenders;
        float _leftSpaceWidth;
        float _verticalSpace;
//        Node* _elementRenderersContainer;
//        short _maxline;
        std::string _context;
        Ref*                                    _richTextEventListener;
        SEL_RichTextClickEvent	_richTextEventSelector;
    };
    
}

// end of ui group
/// @}
NS_CC_END

#endif /* defined(__UIHLCustomRichText__) */
