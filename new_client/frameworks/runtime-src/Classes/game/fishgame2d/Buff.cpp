#include "Buff.h"

NS_FISHGAME2D_BEGIN

Buff* Buff::create(int buffType, float buffParam, float buffTime){
	auto* ret = new (std::nothrow) Buff();
	if (ret)
	{
		ret->m_BTP = buffType;
		ret->m_param = buffParam;
		ret->m_fLife = buffTime;

		ret->autorelease();
	}
	else{
		CC_SAFE_DELETE(ret);
	}

	return ret;

}

Buff::Buff()
	: cocos2d::Ref()
	, m_BTP(EBT_NONE)
	, m_fLife(0.0f)
	, m_pOwner(nullptr)
	, m_param(1.0f)
{}

Buff::~Buff(){}

void Buff::Clear(){  }

bool Buff::OnUpdate(float fdt){
	if (m_fLife > 0.0f)
		m_fLife -= fdt;

	return m_fLife == -1.0f || m_fLife > 0.0f;
}
NS_FISHGAME2D_END
