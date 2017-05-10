#include "MyScene.h"
#include "cocostudio/CCArmature.h"
#include "cocostudio/CCArmatureDataManager.h"
#include "MyObject.h"
#include "PathManager.h"
#include "spine/spine.h"
#include "spine/SkeletonAnimation.h"

NS_FISHGAME2D_BEGIN
MyScene::MyScene() : cocos2d::Scene()
{
	m_pLayerBullet = nullptr;
	m_pLayerBulletDie = nullptr;
	m_pLayerFish = nullptr;
}

MyScene::~MyScene()
{
	for (auto i : m_mapSkeletonCache){
		spSkeletonData_dispose(i.second);
	}
	for (auto i : m_mapAtlas){
		spAtlas_dispose(i.second);
	}
}

spSkeletonData* MyScene::getSkeletonData(std::string image){
	auto* pSkeletonData = m_mapSkeletonCache[image];
	if (pSkeletonData == nullptr){
		std::string fileJson = "fishgame2d/animation/" + image + "/" + image + ".json";
		std::string fileAtlas = "fishgame2d/animation/" + image + "/" + image + ".atlas";

		auto* _atlas = spAtlas_createFromFile(fileAtlas.c_str(), 0);
		if (_atlas == nullptr) return nullptr;

		spSkeletonJson* json = spSkeletonJson_create(_atlas);

		json->scale = 1.0f;
		spSkeletonData* skeletonData = spSkeletonJson_readSkeletonDataFile(json, fileJson.c_str());
		//spAtlas_dispose(_atlas);
		spSkeletonJson_dispose(json);
		if (skeletonData == nullptr){
			if (_atlas){
				spAtlas_dispose(_atlas);
			}
			return nullptr;
		}

		m_mapSkeletonCache[image] = skeletonData;
		m_mapAtlas[image] = _atlas;
			
		return skeletonData;
	}

	return pSkeletonData;
}

bool MyScene::AddFish(Fish* pFish, std::vector<VisualNode>* result){

	// 初始化鱼的层次;
	if (m_pLayerFish == nullptr){
		m_pLayerFish = cocos2d::Layer::create();
		addChild(m_pLayerFish, OBJECT_FISH);
	}

	VisualData* pVisualData = nullptr;
	bool bDead;
	int visualId = pFish->GetVisualId();
	switch (pFish->GetState())
	{
	case EOS_LIVE:
	case EOS_HIT:
		bDead = false;
		pVisualData = FishObjectManager::GetInstance()->GetPathManager()->GetVisualData(visualId);
		break;
	case EOS_DEAD:
		bDead = true;
		pVisualData = FishObjectManager::GetInstance()->GetPathManager()->GetVisualData(visualId);
		break;
	default:
		break;
	}
	if (pVisualData != nullptr){
		int orderId = pVisualData->nZOrder;
		auto& images = bDead ? pVisualData->ImageInfoDie : pVisualData->ImageInfoLive;
		for (auto& image : images){
			switch (image.AniType){
			case VAT_FRAME:{		
				VisualNode visualNode;
				visualNode.direction = image.Direction;
				visualNode.offsetX = image.OffestX;
				visualNode.offsetY = image.OffestY;
				visualNode.scale = image.Scale;

				// 阴影;
				if (!image.HideShadow){
					cocostudio::Armature* pArmatureShadow = cocostudio::Armature::create(image.Image);
					if (pArmatureShadow != nullptr){
						if (pArmatureShadow->getAnimation() != nullptr){
							pArmatureShadow->getAnimation()->play(image.Name, -1, bDead ? 0 : -1);
							if (bDead){
								pArmatureShadow->getAnimation()->setMovementEventCallFunc([=](cocostudio::Armature* sender, cocostudio::MovementEventType type, const std::string& id)
								{
									if (type == cocostudio::MovementEventType::COMPLETE)
									{
										sender->getAnimation()->stop();
										sender->setVisible(false);
									}
								});
							}
						}

						pArmatureShadow->setScale(image.Scale);
						pArmatureShadow->setColor(cocos2d::Color3B::BLACK);
						pArmatureShadow->setOpacity(127);
						m_pLayerFish->addChild(pArmatureShadow, orderId * 2);

						visualNode.targetShadow = pArmatureShadow;
					}
				}
				// 鱼;
				cocostudio::Armature* pArmature = cocostudio::Armature::create(image.Image);
				if (pArmature != nullptr){
					if (pArmature->getAnimation() != nullptr){
						pArmature->getAnimation()->play(image.Name, -1, bDead ? 0 : -1);
						if (bDead){
							pArmature->getAnimation()->setMovementEventCallFunc([=](cocostudio::Armature* sender, cocostudio::MovementEventType type, const std::string& id)
							{
								if (type == cocostudio::MovementEventType::COMPLETE)
								{
									sender->getAnimation()->stop();
									sender->setVisible(false);
								}
							});
						}
					}
					pArmature->setScale(image.Scale);
					m_pLayerFish->addChild(pArmature, orderId * 2 + 1);

					visualNode.target = pArmature;
				}

				result->push_back(visualNode);

				break;
			}
			case VAT_SKELETON:{
				auto* pSkeletonData = getSkeletonData(image.Image);
				if (pSkeletonData == nullptr){
					break;
				}
				VisualNode visualNode;
				visualNode.direction = image.Direction;
				visualNode.offsetX = image.OffestX;
				visualNode.offsetY = image.OffestY;
				visualNode.scale = image.Scale;

				// 阴影;
				if (!image.HideShadow){
					auto* pSkeletonShadow = spine::SkeletonAnimation::createWithData(pSkeletonData);
					if (pSkeletonShadow != nullptr){
						pSkeletonShadow->setAnimation(0, image.Name, true);
						pSkeletonShadow->setScale(image.Scale);
						pSkeletonShadow->setColor(cocos2d::Color3B::BLACK);
						pSkeletonShadow->setOpacity(127);
						m_pLayerFish->addChild(pSkeletonShadow, orderId * 2);
						visualNode.targetShadow = pSkeletonShadow;
					}
				}
				// 鱼;
				auto* pSkeleton = spine::SkeletonAnimation::createWithData(pSkeletonData);
				if (pSkeleton != nullptr){
					pSkeleton->setAnimation(0, image.Name, true);
					pSkeleton->setScale(image.Scale);
					m_pLayerFish->addChild(pSkeleton, orderId * 2 + 1);

					visualNode.target = pSkeleton;
				}
				result->push_back(visualNode);
				break;
			}
			}
		}
		// 测试包围盒;
		//auto boundingBox = cocos2d::DrawNode::create();
		//boundingBox->drawDot(cocos2d::Vec2(0,0), 10, cocos2d::Color4F(1, 0, 0, 0.3));

		//auto boxId = pFish->GetBoundingBox();
		//auto* pathData = PathManager::GetInstance()->GetBoundingBoxData(boxId);
		//if (pathData != nullptr){
		//	for (auto v : pathData->value){
		//		boundingBox->drawDot(cocos2d::Vec2(v.offsetX, v.offsetY), v.rad, cocos2d::Color4F(1, 1, 1, 0.3));
		//	}
		//}

		//addChild(boundingBox, OBJECT_FISH_TEST);

		//VisualNode visualNode;
		//
		//visualNode.direction = 0;
		//visualNode.offsetX = 0;
		//visualNode.offsetY = 0;
		//visualNode.scale = 1;
		//visualNode.target = boundingBox;
		//
		//result->push_back(visualNode);

		return result;
	}
}

bool MyScene::AddBullet(Bullet* pBullet, std::vector<VisualNode>* result){
	if (m_pLayerBullet == nullptr){
		m_pLayerBullet = cocos2d::Layer::create();
		addChild(m_pLayerBullet, OBJECT_BULLET);
	}
	if (m_pLayerBulletDie == nullptr){
		m_pLayerBulletDie = cocos2d::Layer::create();
		addChild(m_pLayerBulletDie, OBJECT_BULLET_DIE);
	}


	int cannonSetType = pBullet->GetCannonSetType();
	int cannonType = pBullet->GetCannonType();

	bool bDead;
	Cannon* cannon = nullptr;
	switch (pBullet->GetState())
	{

	case EOS_LIVE:
	case EOS_HIT:
		bDead = false;
		cannon = FishObjectManager::GetInstance()->GetPathManager()->GetCannonData(cannonSetType, cannonType);
		break;
	case EOS_DEAD:
		bDead = true;
		cannon = FishObjectManager::GetInstance()->GetPathManager()->GetCannonData(cannonSetType, cannonType);
		break;
	default:
		break;
	}
	if (cannon != nullptr){
		if (bDead){
			VisualNode visualNode;

			cocostudio::Armature* hehe = cocostudio::Armature::create(cannon->net.resName);
			if (hehe){
				hehe->getAnimation()->play(cannon->net.Name, -1, 0);
				hehe->getAnimation()->setMovementEventCallFunc([=](cocostudio::Armature* sender, cocostudio::MovementEventType type, const std::string& id)
				{
					if (type == cocostudio::MovementEventType::COMPLETE)
					{
						sender->getAnimation()->stop();
						sender->setVisible(false);
					}
				});
				visualNode.direction = 0;
				visualNode.offsetX = cannon->net.PosX;
				visualNode.offsetY = cannon->net.PosY;
				visualNode.scale = 1;
				visualNode.target = hehe;

				m_pLayerBulletDie->addChild(hehe, cannon->type);
				result->push_back(visualNode);
			}
		}
		else{
			VisualNode visualNode;

			cocostudio::Armature* hehe = cocostudio::Armature::create(cannon->bullet.resName);
			if (hehe){
				hehe->getAnimation()->play(cannon->bullet.Name, -1, -1);
				visualNode.direction = 0;
				visualNode.offsetX = 0;
				visualNode.offsetY = 0;
				visualNode.scale = 1;
				visualNode.target = hehe;

				m_pLayerBullet->addChild(hehe, cannon->type);
				result->push_back(visualNode);
			}
		}
	}

	return result;
}

bool MyScene::AddMyObject(MyObject* pObj, std::vector<VisualNode>* result){
	if (pObj == NULL) return false;

	int objType = pObj->GetType();
	switch (objType)
	{
	case EOT_FISH:{
		return AddFish((Fish*)pObj, result);
	}
	case EOT_BULLET:{
		return AddBullet((Bullet*)pObj, result);
	}
	default:
		break;
	}

	return true;
}

cocos2d::Node* MyScene::CreateTestFishNode(MyScene* self, int visualId, int boxId, bool bDead){
	auto pVisualData = FishObjectManager::GetInstance()->GetPathManager()->GetVisualData(visualId);
	if (pVisualData == nullptr){
		return nullptr;
	}

	auto* node = cocos2d::Node::create();
	auto* node_1 = cocos2d::Node::create();
	auto* node_2 = cocos2d::Node::create();


	// 测试包围盒;
	auto boundingBox = cocos2d::DrawNode::create();
	boundingBox->drawDot(cocos2d::Point(0, 0), 80, cocos2d::Color4F(1, 0, 0, 0.1));
	boundingBox->drawLine(cocos2d::Point(-100, 0), cocos2d::Point(100, 0), cocos2d::Color4F(0, 1, 0, 0.1));
	boundingBox->drawLine(cocos2d::Point(0, -100), cocos2d::Point(0, 100), cocos2d::Color4F(0, 1, 0, 0.1));

	auto* pathData = FishObjectManager::GetInstance()->GetPathManager()->GetBoundingBoxData(boxId);
	if (pathData != nullptr){
		for (auto v : pathData->value){
			boundingBox->drawDot(cocos2d::Vec2(v.offsetX, v.offsetY), v.rad, cocos2d::Color4F(1, 1, 1, 0.3));
		}
	}

	node->addChild(boundingBox, -2);
	node->addChild(node_1,-1);
	node->addChild(node_2, 0);

	auto& images = bDead ? pVisualData->ImageInfoDie : pVisualData->ImageInfoLive;
	for (auto& image : images){
		switch (image.AniType){
		case VAT_FRAME:{
			cocostudio::Armature* pArmature = cocostudio::Armature::create(image.Image);
			if (pArmature != nullptr){
				if (pArmature->getAnimation() != nullptr){
					pArmature->getAnimation()->play(image.Name, -1, -1);
				}

				pArmature->setScale(image.Scale);
				pArmature->setPosition(cocos2d::Point(image.OffestX, image.OffestY));
				node_2->addChild(pArmature, visualId);

			}
			if (!image.HideShadow){
				cocostudio::Armature* pArmatureShadow = cocostudio::Armature::create(image.Image);
				if (pArmatureShadow != nullptr){
					if (pArmatureShadow->getAnimation() != nullptr){
						pArmatureShadow->getAnimation()->play(image.Name, -1, -1);
					}

					pArmatureShadow->setScale(image.Scale);
					pArmatureShadow->setPosition(cocos2d::Point(image.OffestX, image.OffestY - 30));
					pArmatureShadow->setColor(cocos2d::Color3B::BLACK);
					pArmatureShadow->setOpacity(127);
					node_1->addChild(pArmatureShadow, visualId);

				}
			}
				
			break;
		}
		case VAT_SKELETON:{
			auto* pSkeletonData = self->getSkeletonData(image.Image);
			if (pSkeletonData == nullptr){
				break;
			}

			auto* pSkeleton = spine::SkeletonAnimation::createWithData(pSkeletonData);
			if (pSkeleton != nullptr){
				pSkeleton->setAnimation(0, image.Name, true);
				pSkeleton->setScale(image.Scale);
				pSkeleton->setPosition(cocos2d::Point(image.OffestX, image.OffestY));
				node_2->addChild(pSkeleton, visualId);
			}

			if (!image.HideShadow){
				auto* pSkeletonShadow = spine::SkeletonAnimation::createWithData(pSkeletonData);
				if (pSkeletonShadow != nullptr){
					pSkeletonShadow->setAnimation(0, image.Name, true);
					pSkeletonShadow->setScale(image.Scale);
					pSkeletonShadow->setPosition(cocos2d::Point(image.OffestX, image.OffestY - 30));
					pSkeletonShadow->setColor(cocos2d::Color3B::BLACK);
					pSkeletonShadow->setOpacity(127);
					node_1->addChild(pSkeletonShadow, visualId);
				}
			}
			break;
		}
		}
	}
	return node;
}

cocos2d::Node* MyScene::CreateFishNode(MyScene* self,int visualId){
	auto pVisualData = FishObjectManager::GetInstance()->GetPathManager()->GetVisualData(visualId);
	if (pVisualData == nullptr){
		return nullptr;
	}

	auto* node = cocos2d::Node::create();

	float width = 0.0f;
	float height = 0.0f;

	auto& images = pVisualData->ImageInfoLive;
	for (auto& image : images){
		switch (image.AniType){
			case VAT_FRAME:{
				cocostudio::Armature* pArmature = cocostudio::Armature::create(image.Image);
				if (pArmature != nullptr){
					if (pArmature->getAnimation() != nullptr){
						pArmature->getAnimation()->play(image.Name, -1, -1);
					}

					pArmature->setScale(image.Scale);
					pArmature->setPosition(cocos2d::Point(image.OffestX, image.OffestY));
					node->addChild(pArmature, visualId);

					width = MAX(pArmature->getContentSize().width, width);
					height = MAX(pArmature->getContentSize().height, height);
				}
				break;
			}
			case VAT_SKELETON:{
				auto* pSkeletonData = self->getSkeletonData(image.Image);
				if (pSkeletonData == nullptr){
					break;
				}

				auto* pSkeleton = spine::SkeletonAnimation::createWithData(pSkeletonData);

				if (pSkeleton != nullptr){
					pSkeleton->setAnimation(0, image.Name, true);
					pSkeleton->setScale(image.Scale);
					pSkeleton->setPosition(cocos2d::Point(image.OffestX, image.OffestY));
					node->addChild(pSkeleton, visualId);

					width = MAX(200, width);
					height = MAX(300, height);
				}
				break;
			}
		}
	}
	node->setContentSize(cocos2d::Size(width, height));
	return node;
}
NS_FISHGAME2D_END