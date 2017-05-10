//
// DownloaderManager.cpp
// RPGGame
//
// Created by he on 15/5/13.
//
//
 
#include "MyDownloader.h"
#include "extensions/cocos-ext.h"
#include "3rd/md5/FileMD5.h"
#include "utils/CustomUtils.h"
#include "3rd/jsoncpp/myjson.h"
USING_NS_CC_EXT;
#define DEFAULT_CONNECTION_TIMEOUT   30
#define DEFAULT_RECONNECTION_TIMES      5
MyDownloader::MyDownloader()
{
    _downloader.reset(new network::Downloader());
}
 
MyDownloader::~MyDownloader()
{

}
bool MyDownloader::init()
{
	initData();
	return true;
}
void MyDownloader::reset()
{
	_downloader.reset(new network::Downloader());
	initData();
}
void MyDownloader::addProgressCallback(const progressCallback& progressCallback)
{
	this->_progressCallback = progressCallback;
}
void MyDownloader::addFinishedCallback(const finishedCallback& finisehdCallback)
{
	this->_finishedCallback = finisehdCallback;
}
void MyDownloader::addErrorCallback(const errorCallback&	errorCallback)
{
	this->_errorCallback = errorCallback;
}
void MyDownloader::initData()
{
    _downloader->onTaskProgress = [this](const network::DownloadTask& task,
                                        int64_t bytesReceived,
                                        int64_t totalBytesReceived,
                                        int64_t totalBytesExpected)
    {
        //
        this->onProgress(totalBytesExpected, totalBytesReceived, task.requestURL, task.identifier);
    };
    _downloader->onFileTaskSuccess = [this](const cocos2d::network::DownloadTask& task)
    {
        this->onSuccess(task.requestURL, task.storagePath, task.identifier);
    };
    
    // define failed callback
    _downloader->onTaskError = [this](const cocos2d::network::DownloadTask& task,
                                     int errorCode,
                                     int errorCodeInternal,
                                     const std::string& errorStr)
    {
        log("Failed to download : %s, identifier(%s) error code(%d), internal error code(%d) desc(%s)"
            , task.requestURL.c_str()
            , task.identifier.c_str()
            , errorCode
            , errorCodeInternal
            , errorStr.c_str());
        
        std::string customId = task.identifier;
		MyAsset *asset = _downloadingAssetMaps[customId];
		if (this->_errorCallback)
		{
			_errorCallback(asset, errorStr);
		}
        //bool  needDownload =  checkIsNeedReDownload(customId);
        //if(!needDownload)
        //{
        //    //跑出异常错误
        //    Asset &asset = downloadingAssetMaps[customId];
        //    Json::Value doc;
        //    doc["customId"] = customId;
        //    doc["group"] = asset.group;
        //    std::string msg = errorStr;
        //    doc["error"] = msg;
        //    //        doc["code"] = msg.co
        //    EventCustom event(kNotify_DownloaderError);
        //    event.setUserData(&doc);
        //    _eventDispatcher->dispatchEvent(&event);
        //    //        downloadingAssetMaps.erase(customId);
        //}
    };
}
//下载某个
void    MyDownloader::startDownload(MyAsset *asset)
{
    std::string url = asset->getSrcUrl();
    std::string storagePath = asset->getStoragePath();
	std::string dirPath = CustomUtils::getFilePathDirectory(storagePath);
    bool isExist =  FileUtils::getInstance()->isDirectoryExist(dirPath);
    if (!isExist)
    {
        FileUtils::getInstance()->createDirectory(dirPath);
    }
	_downloadingAssetMaps[asset->getCustomId()] = asset;
    _downloader ->createDownloadFileTask(url, storagePath,asset->getCustomId());
}
void MyDownloader::onProgress(double total, double downloaded, const std::string &url, const std::string &customId)
{
    //显示更新进度
	if (this->_progressCallback)
	{
		MyAsset *asset = _downloadingAssetMaps[customId];
		_progressCallback(asset, total, downloaded);
	}
    return;
}
void MyDownloader::onSuccess(const std::string &srcUrl, const std::string &storagePath, const std::string &customId)
{
	CCLOG("MyDownloader::onSuccess");
	MyAsset *asset = _downloadingAssetMaps[customId];
	_downloadingAssetMaps.erase(customId);
	if (this->_finishedCallback)
	{
		_finishedCallback(asset);
	}


//     Asset &asset =downloadingAssetMaps[customId];
//     std::string md5OfFile = MD5File(asset.storagePath);
//     if (md5OfFile == asset.md5)
//     {
//         //成功
//         //增加下载进度通知
//         Json::Value doc;
//         doc["storagePath"] = storagePath;
//         doc["srcUrl"] =  asset.downloadURL;
//         doc["customId"] = customId;
//         doc["group"] = asset.group;
//         EventCustom event(kNotify_DownloaderFinish);
//         event.setUserData(&doc);
//         _eventDispatcher->dispatchEvent(&event);
//         downloadingAssetMaps.erase(customId);
//     }
//     else//失败
//     {
//         CCLOG("%s md5 is not equal to  md5 of version",srcUrl.c_str());
//         //
//         if(!checkIsNeedReDownload(customId)) //抛出错误
//         {
//             Asset &asset = downloadingAssetMaps[customId];
//             Json::Value doc;
//             doc["customId"] = customId;
//             doc["group"] = asset.group;
//             doc["error"] = __String::createWithFormat("%s md5 is not equal to md5 of version",asset.name.c_str())->getCString();
//             //删除下载的无效文件
//             FileUtils::getInstance()->removeFile(asset.storagePath);
//             //刷新进度条
//             onProgress(asset.totalSize, 0, asset.downloadURL, asset.customId);
//             
//             EventCustom event(kNotify_DownloaderError);
//             event.setUserData(&doc);
//             _eventDispatcher->dispatchEvent(&event);
//         }
//         return;
//     }
}

