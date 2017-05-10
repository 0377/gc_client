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

#include "utils/HLCustomRichText.h"
#include "platform/CCFileUtils.h"
#include "2d/CCLabel.h"
#include "2d/CCSprite.h"
#include "base/ccUTF8.h"
#include "ui/UIHelper.h"
#include "ui/UIButton.h"
NS_CC_BEGIN

namespace ui {
#pragma mark -  LinkLabel
    LinkLabel::LinkLabel(FontAtlas *atlas, TextHAlignment hAlignment, TextVAlignment vAlignment, bool useDistanceField, bool useA8Shader)
    : _touchListener(NULL),
    _delegate(NULL), _linkcolor(Color4B::WHITE), _linksize(0), _linkline(NULL)
    {
        
    }
    
    LinkLabel::~LinkLabel()
    {
        if (_linksize)
        {
            _eventDispatcher->removeEventListener(_touchListener);
            CC_SAFE_RELEASE_NULL(_touchListener);
        }
        CC_SAFE_RELEASE_NULL(_linkline);
    }
    
	LinkLabel* LinkLabel::createLinkLabel(const std::string& text, const std::string& fontFile, float fontSize, const Size& dimensions,
                                 TextHAlignment hAlignment, TextVAlignment vAlignment)
    {
        auto ret =     new LinkLabel(nullptr, hAlignment, vAlignment);
        if (ret)
        {
            std::string realFontName = fontFile;
            if (FileUtils::getInstance()->isFileExist(fontFile) == false)
            {
                realFontName = "";
				ret->setSystemFontName(fontFile);
				ret->setSystemFontSize(fontSize);
				ret->setDimensions(dimensions.width, dimensions.height);
				ret->setString(text);
                ret->autorelease();
            }
			else
			{
				TTFConfig ttfConfig(realFontName.c_str(), fontSize, GlyphCollection::DYNAMIC);
				if (ret->setTTFConfig(ttfConfig))
				{
					ret->setDimensions(dimensions.width, dimensions.height);
					ret->setString(text);
					ret->autorelease();
				}
				
			}
			ret->setFontSize(fontSize);
            return ret;
        }
        delete ret;
        return nullptr;
    }
    
    void LinkLabel::enableLinkLine(const Color4B& linkcolor, GLubyte linksize)
    {
        _linkcolor = linkcolor;
        _linksize = linksize;
        if (_linksize > 0)
        {
//            _touchListener = EventListenerTouchOneByOne::create();
//            CC_SAFE_RETAIN(_touchListener);
//            _touchListener->setSwallowTouches(true);
//            _touchListener->onTouchBegan = CC_CALLBACK_2(LinkLabel::onTouchBegan, this);
//            _touchListener->onTouchEnded = CC_CALLBACK_2(LinkLabel::onTouchEnded, this);
//            _eventDispatcher->addEventListenerWithFixedPriority(_touchListener, -1);
//            
            Button *btn = Button::create();
            TTFConfig ttfConfig = _fontConfig;
            btn->setTitleText(this->getString());
            std::string fontFilePath = ttfConfig.fontFilePath;
            if (fontFilePath != "")
            {
                btn->getTitleRenderer() ->setTTFConfig(ttfConfig);
//                btn->setTitleFontName(ttfConfig.fontFilePath);
            }
            else
            {
                btn ->setTitleFontName(this ->getSystemFontName());
                btn->setTitleFontSize(this->getSystemFontSize());
            }
            Color3B labelColor = this->getColor();
            btn->setTitleColor( Color3B(labelColor.r,labelColor.g,labelColor.b));
//            btn->getTitleRenderer()->setVisible(false);
            this->setVisible(false);

            btn->addTouchEventListener(CC_CALLBACK_2(LinkLabel::touchEvent, this));
            
            btn->setAnchorPoint(Vec2(0, 0));
//            btn->setcall
            _linkline = btn;
            _linkline ->retain();
            LayerColor   *colorLine = LayerColor::create(_linkcolor);
            colorLine->setContentSize(Size(getContentSize().width, _linksize));
             btn->setPosition(Vec2(colorLine->getContentSize().width/2,btn->getContentSize().height/2));
            btn->addChild(colorLine,3);
//            _linkline->addChild(btn,20);
//             btn->setPosition(Vec2(_linkline->getContentSize().width/2,btn->getContentSize().height/2));
            
            }
    }
    
    bool LinkLabel::onTouchBegan(Touch *touch, Event *unusedEvent)
    {
        Point _touchStartPos = touch->getLocation();
        Point nsp = convertToNodeSpace(_touchStartPos);
        Rect bb;
        bb.size = _contentSize;
        if (bb.containsPoint(nsp))
        {
            return true;
        }
        return false;
    }
    
    void LinkLabel::onTouchEnded(Touch *touch, Event *unusedEvent)
    {
        if (_delegate)
        {			
            _delegate->labelClicked(this);
        }		
    }
    void LinkLabel::touchEvent(Ref *pSender, Widget::TouchEventType type)
    {
        switch (type)
        {
            case Widget::TouchEventType::BEGAN:
                break;
                
            case Widget::TouchEventType::MOVED:
                break;
                
            case Widget::TouchEventType::ENDED:
            {
//                CCLOG("ended");
                break;
            }
            case Widget::TouchEventType::CANCELED:
                break;
                
            default:
                break;
        }
    }
#pragma mark - HLCustomRichElement
    
    bool HLCustomRichElement::init(int tag, const Color3B &color, GLubyte opacity)
    {
        _tag = tag;
        _color = color;
        _opacity = opacity;
        return true;
    }
    
    
    HLCustomRichElementText* HLCustomRichElementText::create(int tag, const Color3B &color, GLubyte opacity, const std::string& text, const std::string& fontName, float fontSize)
    {
        HLCustomRichElementText* element = new (std::nothrow) HLCustomRichElementText();
        if (element && element->init(tag, color, opacity, text, fontName, fontSize))
        {
            element->autorelease();
            return element;
        }
        CC_SAFE_DELETE(element);
        return nullptr;
    }
    
    bool HLCustomRichElementText::init(int tag, const Color3B &color, GLubyte opacity, const std::string& text, const std::string& fontName, float fontSize)
    {
        if (HLCustomRichElement::init(tag, color, opacity))
        {
            _text = text;
            _fontName = fontName;
            _fontSize = fontSize;
            
            _outcolor = Color4B::WHITE;
            _linkcolor = Color4B::WHITE;
            _outlinesize = 0;
            _linksize = 0;
            return true;
        }
        return false;
    }
    
    HLCustomRichElementImage* HLCustomRichElementImage::create(int tag, const Color3B &color, GLubyte opacity, const std::string& filePath)
    {
        HLCustomRichElementImage* element = new (std::nothrow) HLCustomRichElementImage();
        if (element && element->init(tag, color, opacity, filePath))
        {
            element->autorelease();
            return element;
        }
        CC_SAFE_DELETE(element);
        return nullptr;
    }
    
    bool HLCustomRichElementImage::init(int tag, const Color3B &color, GLubyte opacity, const std::string& filePath)
    {
        if (HLCustomRichElement::init(tag, color, opacity))
        {
            _filePath = filePath;
            return true;
        }
        return false;
    }
    
    HLCustomRichElementCustomNode* HLCustomRichElementCustomNode::create(int tag, const Color3B &color, GLubyte opacity, cocos2d::Node *customNode)
    {
        HLCustomRichElementCustomNode* element = new (std::nothrow) HLCustomRichElementCustomNode();
        if (element && element->init(tag, color, opacity, customNode))
        {
            element->autorelease();
            return element;
        }
        CC_SAFE_DELETE(element);
        return nullptr;
    }
    
    bool HLCustomRichElementCustomNode::init(int tag, const Color3B &color, GLubyte opacity, cocos2d::Node *customNode)
    {
        if (HLCustomRichElement::init(tag, color, opacity))
        {
            _customNode = customNode;
            _customNode->retain();
            return true;
        }
        return false;
    }
#pragma mark - HLCustomRichText method
    HLCustomRichText::HLCustomRichText():
    _formatTextDirty(true),
    _leftSpaceWidth(0.0f),
    _verticalSpace(0.0f),
    _maxWidthForElement(0),
    textHorizontalAlign(HLCustomRichText::TextHorizontalAlignment::LEFT),
    textVerticalAlign(HLCustomRichText::TextVerticalAlignment::TOP),
    _isShadow(false)//    _elementRenderersContainer(nullptr)
    {

    }
    
    HLCustomRichText::~HLCustomRichText()
    {
//        _richElements.clear();
    }
    
    HLCustomRichText* HLCustomRichText::create()
    {
        HLCustomRichText* richText = new (std::nothrow) HLCustomRichText();
        if (richText && richText->init())
        {
//            richText->setDirection(ScrollView::Direction::HORIZONTAL);
            richText->setInertiaScrollEnabled(true);
            richText->setBounceEnabled(true);
            richText->autorelease();;
            return richText;
        }
        CC_SAFE_DELETE(richText);
        return nullptr;
    }
    
    bool HLCustomRichText::init()
    {
        if (ScrollView::init())
        {
            _richTextEventListener = nullptr;
            _richTextEventSelector = nullptr;
            return true;
        }
        return false;
    }
    void HLCustomRichText::onEnter()
    {
        ScrollView::onEnter();
        formatText();
    }
    void HLCustomRichText::initRenderer()
    {
        ScrollView::initRenderer();
    }
    
    void HLCustomRichText::insertElement(HLCustomRichElement *element, int index)
    {
        _richElements.insert(index, element);
        _formatTextDirty = true;
    }
    
    void HLCustomRichText::pushBackElement(HLCustomRichElement *element)
    {
        _richElements.pushBack(element);
        _formatTextDirty = true;
    }
    
    void HLCustomRichText::removeElement(int index)
    {
        _richElements.erase(index);
        _formatTextDirty = true;
    }
    
    void HLCustomRichText::removeElement(HLCustomRichElement *element)
    {
        _richElements.eraseObject(element);
        _formatTextDirty = true;
    }
    
    void HLCustomRichText::formatText()
    {
        if (_formatTextDirty)
        {
            removeAllChildren();
            _elementRenders.clear();
            addNewLine();
            for (ssize_t i=0; i<_richElements.size(); i++)
            {
                
                HLCustomRichElement* element = static_cast<HLCustomRichElement*>(_richElements.at(i));
                switch (element->_type)
                {
                    case HLCustomRichElement::Type::TEXT:
                    {
                        HLCustomRichElementText* elmtText = static_cast<HLCustomRichElementText*>(element);
                        handleTextRenderer(elmtText, elmtText->_text.c_str());
                        break;
                    }
                    case HLCustomRichElement::Type::IMAGE:
                    {
                        HLCustomRichElementImage* elmtImage = static_cast<HLCustomRichElementImage*>(element);
                        handleImageRenderer(elmtImage->_filePath.c_str(), elmtImage->_color, elmtImage->_opacity);
                        break;
                    }
                    case HLCustomRichElement::Type::CUSTOM:
                    {
                        HLCustomRichElementCustomNode* elmtCustom = static_cast<HLCustomRichElementCustomNode*>(element);
                        handleCustomRenderer(elmtCustom->_customNode);
                        break;
                    }
                    default:
                        break;
                }
            }
            formarRenderers();
            _formatTextDirty = false;
        }
    }
    void HLCustomRichText::enableShadow(const Color4B& shadowColor,
                                        const Size &offset,
                                        int blurRadius)
    {
        _shadowConfig.shadow4BColor = shadowColor;
        _shadowConfig.shadowOffset = offset;
        _shadowConfig.shadowblurRadius = blurRadius;
        _isShadow = true;
    }
    LinkLabel* HLCustomRichText::createLabel(HLCustomRichElementText* item, const char* text)
    {
		LinkLabel* textRenderer = LinkLabel::createLinkLabel(text, item->_fontName, item->_fontSize);
        textRenderer->setColor(item->_color);
        textRenderer->setOpacity(item->_opacity);
        textRenderer->setUserObject(item);
        if (textRenderer)
        {
            if (item->_outlinesize > 0)
            {
                textRenderer->enableOutline(item->_outcolor, item->_outlinesize);
            }
            if (item->_linksize > 0)
            {
                textRenderer->enableLinkLine(item->_linkcolor, item->_linksize);
            }
            if(_isShadow)
            {
                textRenderer ->enableShadow(_shadowConfig.shadow4BColor,_shadowConfig.shadowOffset,0);
            }
        }
        textRenderer->setLableDelegate(this);
        return textRenderer;
    }
    
    void HLCustomRichText::handleTextRenderer(HLCustomRichElementText* item, const char* text)
    {
        std::string textStr = text;
        size_t found = textStr.find("\n");
        if(found != std::string::npos)//
        {
            std::string preStr = textStr.substr(0,found - 0);
            std::string lastStr = textStr.substr(found+1);
            handleTextRenderer(item,preStr.c_str());
            addNewLine();
            handleTextRenderer(item, lastStr.c_str());
            return;
            //
        }
        LinkLabel* textRenderer = createLabel(item, text);
        float textRendererWidth = textRenderer->getContentSize().width;
        if (_leftSpaceWidth < textRendererWidth)
        {
            float overstepPercent = (textRendererWidth - _leftSpaceWidth) / textRendererWidth;
            std::string curText = text;
            size_t stringLength = StringUtils::getCharacterCountInUTF8String(text);
            int leftLength = stringLength * (1.0f - overstepPercent);
            //The minimum cut length is 1, otherwise will cause the infinite loop.

            std::string leftWords = Helper::getSubStringOfUTF8String(curText,0,leftLength);
            
            LinkLabel*leftRenderer = createLabel(item, leftWords.c_str());
            float leftRendererWidth = leftRenderer ->getContentSize().width;
            if(leftRendererWidth > _leftSpaceWidth)//
            {
                while(leftRenderer->getContentSize().width > _leftSpaceWidth)
                {
                    leftLength = leftLength - 1;
                    leftWords = Helper::getSubStringOfUTF8String(curText,0,leftLength);
                    leftRenderer = createLabel(item, leftWords.c_str());
                }
            }
            else if(leftRendererWidth <= _leftSpaceWidth - leftRenderer->getFontSize())
            {
                while(leftRenderer->getContentSize().width <= _leftSpaceWidth - leftRenderer->getFontSize())
                {
                    leftLength = leftLength + 1;
                    leftWords = Helper::getSubStringOfUTF8String(curText,0,leftLength);
                    leftRenderer = createLabel(item, leftWords.c_str());
                }
            }
            if (leftRenderer)
            {
                pushToContainer(leftRenderer);
            }
            std::string cutWords = Helper::getSubStringOfUTF8String(curText, leftLength, stringLength - leftLength);
            addNewLine();
			handleTextRenderer(item, cutWords.c_str());
        }
        else
        {
            _leftSpaceWidth -= textRendererWidth;
            textRenderer->setColor(item->_color);
            textRenderer->setOpacity(item->_opacity);
            textRenderer->setUserObject(item);
            pushToContainer(textRenderer);
        }
    }
    
    void HLCustomRichText::handleImageRenderer(const std::string& fileParh, const Color3B &color, GLubyte opacity)
    {
        Sprite* imageRenderer = Sprite::create(fileParh);
        handleCustomRenderer(imageRenderer);
    }
    
    void HLCustomRichText::handleCustomRenderer(cocos2d::Node *renderer)
    {
        Size imgSize = renderer->getContentSize();
        _leftSpaceWidth -= imgSize.width;
        if (_leftSpaceWidth < 0.0f)
        {
            addNewLine();
            pushToContainer(renderer);
            _leftSpaceWidth -= imgSize.width;
        }
        else
        {
            pushToContainer(renderer);
        }
    }
    
    void HLCustomRichText::addNewLine()
    {
        _leftSpaceWidth = _customSize.width;
        _elementRenders.push_back(new Vector<Node*>());
    }
    
    void HLCustomRichText::formarRenderers()
    {
//        while (_elementRenders.size() > _maxline)
//        {
//            _elementRenders.erase(_elementRenders.begin());
//        }
        float newContainerSizeHeight = 0.0f;
        float *maxHeights = new float[_elementRenders.size()];
        float *lineWidths = new float[_elementRenders.size()];
        for (size_t i=0; i<_elementRenders.size(); i++)
        {
            Vector<Node*>* row = (_elementRenders[i]);
            float maxHeight = 0.0f;
            float lineWidth = 0.0f;
            for (ssize_t j=0; j<row->size(); j++)
            {
                Node* l = row->at(j);
                maxHeight = MAX(l->getContentSize().height, maxHeight);
                lineWidth += l->getContentSize().width;
            }
            maxHeights[i] = maxHeight;
            lineWidths[i] = lineWidth;
            _maxWidthForElement = MAX(_maxWidthForElement,lineWidth);
            newContainerSizeHeight += maxHeights[i]+_verticalSpace;
        }
        if (newContainerSizeHeight > getInnerContainerSize().height)
        {
            setInnerContainerSize(Size(getInnerContainerSize().width, newContainerSizeHeight));
        }
        if (getInnerContainerSize().height <= getContentSize().height)
        {
            setEnabled(false);
        }
        
        float nextPosY = getInnerContainerSize().height;
        switch (textVerticalAlign)
        {
            case TextVerticalAlignment::TOP:
                nextPosY = getInnerContainerSize().height;
                break;
            case TextVerticalAlignment::MID:
                nextPosY = getInnerContainerSize().height/2 + newContainerSizeHeight/2;
                break;
            case TextVerticalAlignment::BUTTOM:
                nextPosY = newContainerSizeHeight;
                break;
            default:
                nextPosY = getInnerContainerSize().height;
                break;
        }

        float innerW = getInnerContainerSize().width;
        for (size_t i=0; i<_elementRenders.size(); i++)
        {
            Vector<Node*>* row = (_elementRenders[i]);
            float nextPosX = 0.0f;
            float curLineW = lineWidths[i];
            switch (textHorizontalAlign)
            {
                case TextHorizontalAlignment::LEFT:
                    nextPosX = 0;
                    break;
                case TextHorizontalAlignment::CENTER:
                    nextPosX = innerW/2 - curLineW/2;
                    break;
                case TextHorizontalAlignment::RIGHT:
                    nextPosX = innerW - curLineW;
                    break;
                default:
                    nextPosX = 0;
                    break;
            }
            if(i == 0)
            {
                nextPosY -= (maxHeights[i]);
            }
            else
            {
                nextPosY -= (maxHeights[i] + _verticalSpace);
            }
            //
            for (ssize_t j=0; j<row->size(); j++)
            {
                Node* l = row->at(j);
                l->setAnchorPoint(Vec2::ZERO);
                l->setPosition(nextPosX, nextPosY);
                addChild(l, 1);
                LinkLabel* la = dynamic_cast<LinkLabel*>(l);
                if (la && la->getLinkline())
                {
                    Node *lineNode = la->getLinkline();
                    lineNode->setPosition(nextPosX, nextPosY - 1);
                    addChild(lineNode, 1, (int)(i * 10 + j));
                }
                nextPosX += l->getContentSize().width;
            }
        }
//
        delete [] maxHeights;
        delete [] lineWidths;
        
        size_t length = _elementRenders.size();
        for (size_t i = 0; i<length; i++)
        {
            Vector<Node*>* l = _elementRenders[i];
            l->clear();
            delete l;
        }    
//        _elementRenders.clear();
    }
    
    void HLCustomRichText::adaptRenderers()
    {
//        this->formatText();
    }
    
    void HLCustomRichText::pushToContainer(cocos2d::Node *renderer)
    {
        if (_elementRenders.size() <= 0)
        {
            return;
        }
        _elementRenders[_elementRenders.size()-1]->pushBack(renderer);
    }
    
    void HLCustomRichText::setVerticalSpace(float space)
    {
        _verticalSpace = space;
    }
    
    void HLCustomRichText::setAnchorPoint(const Vec2 &pt)
    {
        ScrollView::setAnchorPoint(pt);
//        _elementRenderersContainer->setAnchorPoint(pt);
    }
    
    Size HLCustomRichText::getVirtualRendererSize() const
    {
        return getContentSize();
    }
    
    void HLCustomRichText::ignoreContentAdaptWithSize(bool ignore)
    {
        if (_ignoreSize != ignore)
        {
            _formatTextDirty = true;
            ScrollView::ignoreContentAdaptWithSize(ignore);
        }
    }
    
    std::string HLCustomRichText::getDescription() const
    {
        return "HLCustomRichText";
    }
    void HLCustomRichText::addEventListenerRichText(Ref* target, SEL_RichTextClickEvent selector)
    {
        _richTextEventListener = target;
        _richTextEventSelector = selector;
    }
    void HLCustomRichText::labelClicked(LinkLabel* lab)
    {
        HLCustomRichElementText* itemText = static_cast<HLCustomRichElementText*>(lab->getUserObject());
        if (_richTextEventListener && _richTextEventSelector)
        {
            (_richTextEventListener->*_richTextEventSelector)(this, RICHTEXT_ANCHOR_CLICKED);
        }
    }
}

NS_CC_END
