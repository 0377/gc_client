// DownDataManager.h
// RPGGame
//
// Created by he on 15/5/13.
//
//
 
#ifndef __RPGGame__DownDataManager__
#define __RPGGame__DownDataManager__
#include "cocos2d.h"
USING_NS_CC;
#include "network/CCDownloader.h"
class MyAsset:public Ref
{
public:
	MyAsset(){};
	virtual ~MyAsset(){};
	CREATE_FUNC(MyAsset);
	virtual bool												init(){ return true; };
	CC_SYNTHESIZE(std::string,srcUrl,SrcUrl);
	CC_SYNTHESIZE(std::string,storagePath,StoragePath);
	CC_SYNTHESIZE(std::string,customId,CustomId);
	CC_SYNTHESIZE(int32_t,downloadeTimes,DownloadeTimes);
	CC_SYNTHESIZE(std::string,group,Group);
};
class MyDownloader : public Ref
{
public:
	typedef std::function<void(MyAsset *asset,float total,float downloaded)> progressCallback;
	typedef std::function<void(MyAsset *asset)>finishedCallback;
	typedef std::function<void(MyAsset *asset, const std::string &error)>errorCallback;
	MyDownloader();
	virtual ~MyDownloader();
	virtual bool												init();
	CREATE_FUNC(MyDownloader);
	void														 addProgressCallback(const progressCallback& progressCallback);
	void														 addFinishedCallback(const finishedCallback& finisehdCallback);
	void														 addErrorCallback(const errorCallback&	errorCallback);

	void														 startDownload(MyAsset *asset);
	void													     reset();
private:
	progressCallback											_progressCallback;
	finishedCallback											_finishedCallback;
	errorCallback												_errorCallback;
	std::unique_ptr<cocos2d::network::Downloader> _downloader;
	void initData();
	virtual void												 onProgress(double total, double downloaded, const std::string &url, const std::string &customId);
	virtual void												 onSuccess(const std::string &srcUrl, const std::string &storagePath, const std::string &customId);
	std::map<std::string, MyAsset *>                             _downloadingAssetMaps;//正在下载的文件信息
};

#endif /* defined(__RPGGame__DownDataManager__) */