/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2016 cocos2d-x.org
Copyright (c) 2013-2016 Chukong Technologies Inc.
 
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
package org.cocos2dx.lua;

import org.cocos2dx.lua.util.DeviceUtil;
import org.cocos2dx.new_client.R;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.MobilePlate;

import java.net.URISyntaxException;

import android.os.Bundle;
import android.telephony.PhoneStateListener;
import android.telephony.SignalStrength;
import android.telephony.TelephonyManager;
import android.text.LoginFilter;
import android.util.Log;
import android.view.WindowManager;
import android.os.Handler;
import android.os.Message;
import android.net.Uri;
import android.content.Context;
import android.content.ActivityNotFoundException;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.Context;
import android.graphics.Bitmap;
import android.app.Dialog;

import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.WebSettings;
import android.webkit.JavascriptInterface;

import android.view.View;
import android.view.View.OnClickListener;

import android.util.DisplayMetrics;

import android.content.BroadcastReceiver;
import android.content.IntentFilter;
import android.view.Window;
import android.view.WindowManager.LayoutParams;


public class AppActivity extends Cocos2dxActivity{
//    MobilePlate.setHandler(mHander);
    Context mContext = null;
    private String mUrl = "";
    boolean mbsendcheck = false;
    private boolean mbclose = false;
    boolean mbCheck = false;

    private boolean registeredBlRecv = false;
    private BroadcastReceiver batteryLevelRcvr;
    private IntentFilter batteryLevelFilter;
    private PhoneStateListener mobielStateListener;
    private TelephonyManager telephonyManager;
    private boolean isShowAlipayView = false;
    private Dialog dialog;
    private Handler mHander = new Handler(){
        public void handleMessage(Message msg) {
            switch (msg.what) {
//                case GameBase.EXIT_GAME:
//                    exitGame();
//                    break;
//                case GameBase.USER_PAY:
//                    pay((JiuJiuPayInfo)msg.obj);
//                    break;
//                case GameBase.GAME_UPDATE:
//                    showUpdate((UpdateInfo)msg.obj);
//                    break;
//                case GameBase.SHOW_TOAST:
//                    Toast.makeText(mContext, (String)msg.obj, Toast.LENGTH_SHORT).show();
//                    break;
                case GameBase.SHOW_WEBVIEW:
                    showWebView((ShowUrlInfo)msg.obj);
                    break;
                case GameBase.OPEN_BROWSER:
                    openBrowser((String)msg.obj);
                    break;
//                case GameBase.GAME_PAY_DETAIL_URL:
//                    mPayDetailUrl = (String)msg.obj;
//                    break;
//                case GameBase.GAME_PAY_SELECT_URL:
//                    mPaySelectUrl = (String)msg.obj;
//                    break;
//                case GameBase.GAME_UPDATE_URL:
//                    checkUpdate((String)msg.obj);
//                    break;
//                case GameBase.DOWN_FAILED:
//                    downloadFailed();
//                    break;
//                case GameBase.DOWN_PROGRESS:
//                    updateDownProgress(msg.arg2, msg.arg1, (String)msg.obj);
//                    break;
//                case GameBase.DOWN_START:
//                    onDownStart();
//                    break;
                case GameBase.CALL_QQ_CHAT:
                    callQQChat((String)msg.obj);
                    break;
//                case GameBase.PAY_TYPE:
//                    mPayType = (PaytypeInfo)msg.obj;
//                    System.out.println(String.format("回调函数设置  %d",mPayType.PaytypeCallFunc));
//
//                    break;
            }
            super.handleMessage(msg);
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        MobilePlate.setActivity(this);
        mContext = this;

        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

        MobilePlate.setHandler(mHander);

        //PayAli.instance().init(this, this);
        //PayWeiXin.instance().init(this, this);
    }

    @Override
    protected void onResume() {
        Log.i("AppActivity", "onResume");
        super.onResume();

        monitorBatteryState();
        monitorMobileState();

        if(isShowAlipayView )
        {
            isShowAlipayView = false;
            if(dialog != null )
            {
                dialog.dismiss();
            }
        }
    }

    @Override
    protected void onPause() {
        Log.i("AppActivity", "onPause");
        super.onPause();

        if (batteryLevelRcvr != null  && registeredBlRecv) {
            unregisterReceiver(batteryLevelRcvr);
            batteryLevelRcvr = null;
            registeredBlRecv = false;
        }

        if (telephonyManager != null) {
            telephonyManager.listen(mobielStateListener, PhoneStateListener.LISTEN_NONE);
            telephonyManager = null;
        }
    }

    private void callQQChat(String qqNumber){
        try{
            String url= String.format("mqqwpa://im/chat?chat_type=wpa&uin=%s", qqNumber);
            startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
        }
        catch(Exception e){
            e.printStackTrace();
            Toast.makeText(this, "启动QQ失败，请确认您是否安装QQ", Toast.LENGTH_LONG).show();
        }
    }


    private void showWebView(final ShowUrlInfo urlObj) {
        this.runOnUiThread(new Runnable() {// 在主线程里添加别的控件
            public void run() {
                mUrl = urlObj.urlstr;
                mbclose = false;
                mbsendcheck = false;

                final int callback = urlObj.callback;
                final String args = urlObj.args;
                dialog = new Dialog(AppActivity.this,R.style.dialogFullScreen);
                View contentView = getLayoutInflater().inflate(R.layout.show_webview, null);

                Button btn_back = (Button) contentView.findViewById(R.id.btn_back);
                Button btn_close = (Button) contentView.findViewById(R.id.btn_close);
                TextView label_title = (TextView)contentView.findViewById(R.id.label_title);
                final WebView m_webView = (WebView) contentView.findViewById(R.id.webView);

                label_title.setText(urlObj.title);

                String urlstr = urlObj.urlstr;
                System.out.println(urlstr);
                String ordertempID = "";
                if (urlObj.urlstr.indexOf("paywebview-") != -1)
                {
                    urlstr = urlObj.urlstr.substring(urlObj.urlstr.indexOf("paywebview-") + 11);
                    String[] sourceStrArray = urlObj.urlstr.split("&");
                    for (int i = 0; i < sourceStrArray.length; i++) {
                        System.out.println(sourceStrArray[i]);
                        if (sourceStrArray[i].indexOf("orderid=") != -1)
                        {
                            ordertempID = sourceStrArray[i].substring(sourceStrArray[i].indexOf("="));
                            break;
                        }
                    }
                }
                final String orderID = ordertempID;

                // 关闭
                btn_back.setOnClickListener(new OnClickListener() {
                    public void onClick(View v) {
                        dialog.dismiss();
                        checkWebViewDailog(dialog, callback,args);
//                        if (mbclose == true)
//                        {
//                            dialog.dismiss();
//                            checkWebViewDailog(dialog, callback,args);
//                            if (urlObj.urlstr.indexOf("paywebview-") != -1)
//                            {
//                                if(mbCheck == true)
//                                {
//                                    mbCheck = false;
//                                }
//                            }
//                        }
//                        else
//                            m_webView.goBack();
                    }
                });

                btn_close.setOnClickListener(new OnClickListener() {
                    public void onClick(View v) {
                        dialog.dismiss();
                        checkWebViewDailog(dialog, callback,args);
//                        if (urlObj.urlstr.indexOf("paywebview-") != -1)
//                        {
//                            if(mbCheck == true)
//                            {
//                                mbCheck = false;
//
//                            }
//                        }
                    }
                });

                WebSettings webSettings = m_webView.getSettings();
                webSettings.setUseWideViewPort(true);//设置此属性，可任意比例缩放
                webSettings.setJavaScriptCanOpenWindowsAutomatically(true);//设置js可以直接打开窗口，如window.open()，默认为false
                webSettings.setLoadWithOverviewMode(true);//缩放至屏幕大小
                webSettings.setJavaScriptEnabled(true);//支持js
                webSettings.setSupportZoom(true);//支持缩放
                webSettings.setBuiltInZoomControls(true);//设置支持缩放
                webSettings.setDisplayZoomControls(false);//不显示webview缩放按钮
                webSettings.setCacheMode(WebSettings.LOAD_CACHE_ELSE_NETWORK);//设置加载缓存

                m_webView.addJavascriptInterface(new JsInteration(), "control");
                // 载入URL
                // 使页面获得焦点
                m_webView.requestFocus();
                System.out.println(String.format("网址   %s",urlObj.urlstr));
                // 如果页面中链接，如果希望点击链接继续在当前browser中响应

                m_webView.setWebViewClient(new WebViewClient() {
                    @Override
                    public boolean shouldOverrideUrlLoading(WebView view, String url) {
                        if (mbCheck == false){
                            mbCheck = true;

                            new Thread(new Runnable() {
                                @Override
                                public void run() {
                                    checkWebViewDailog(dialog, callback,args);
                                }
                            }).start();
                        }

                        // 如下方案可在非微信内部WebView的H5页面中调出微信支付
                        try {
                            if (url.startsWith("weixin://") || url.startsWith("alipays://")|| url.startsWith("alipayqr://")) {
                                Intent intent = new Intent();
                                intent.setAction(Intent.ACTION_VIEW);
                                intent.setData(Uri.parse(url));
                                startActivity(intent);
                                return true;
                            }else if( url.startsWith("intent://")){
                                try {
                                    mbclose = true;
                                    System.out.println(String.format("网址调用   %s",url));
                                    Intent intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME);
                                    // forbid launching activities without BROWSABLE
                                    // category
                                    intent.addCategory("android.intent.category.BROWSABLE");
                                    // forbid explicit call
                                    intent.setComponent(null);
                                    // forbid intent with selector intent
                                    intent.setSelector(null);
                                    // start the activity by the intent
                                    startActivityIfNeeded(intent, -1);
                                    return true;
                                } catch (URISyntaxException e) {
                                    e.printStackTrace();
                                } catch (ActivityNotFoundException e){
                                    System.out.println("检查订单号   =========-请安装微信最新版");
                                    Toast.makeText(mContext, "请安装最新版支付宝或者微信！", Toast.LENGTH_LONG).show();
                                }
                            }
                        } catch (Exception e) { //防止crash (如果手机上没有安装处理某个scheme开头的url的APP, 会导致crash)
                            return false;
                        }
                        if (url.indexOf("tel:") < 0) {
                            view.loadUrl(url);
                            return true;
                        }

                        return super.shouldOverrideUrlLoading(view, url);
                    }

                    @Override
                    public void onPageFinished(WebView view, String url) {
                        // TODO Auto-generated method stub
                        super.onPageFinished(view, url);
                    }

                    @Override
                    public void onReceivedError(WebView view, int errorCode,
                                                String description, String failingUrl) {
                        // TODO Auto-generated method stub
                        super.onReceivedError(view, errorCode, description, failingUrl);
                    }

                });
                m_webView.loadUrl(urlObj.urlstr);
                dialog.setContentView(contentView);
                dialog.show();
                if (args.equals("alipay") )
                {
                    WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
 					params.width = 0;
 					params.height = 0;
 					dialog.getWindow().setAttributes(params);
                    isShowAlipayView = true;
                }



                DisplayMetrics dm = new DisplayMetrics();
                getWindowManager().getDefaultDisplay().getMetrics(dm);

                //alipay webview不能解析url 使用浏览器打开
//                if (urlObj.urlstr.startsWith("weixin://") || urlObj.urlstr.startsWith("alipays://")|| urlObj.urlstr.startsWith("alipayqr://")) {
//                    if (mbCheck == false){
//                        mbCheck = true;
//
//                        new Thread(new Runnable() {
//                            @Override
//                            public void run() {
//                                checkWebViewDailog(dialog, callback,args);
//                            }
//                        }).start();
//                    }
//
//                    Intent intent = new Intent();
//                    intent.setAction(Intent.ACTION_VIEW);
//                    intent.setData(Uri.parse(urlObj.urlstr));
//                    startActivity(intent);
//                }else
//                {
//                    if (mbCheck == false){
//                        mbCheck = true;
//
//                        new Thread(new Runnable() {
//                            @Override
//                            public void run() {
//                                checkWebViewDailog(dialog, callback,args);
//                            }
//                        }).start();
//                    }
//                    m_webView.loadUrl(urlObj.urlstr);
//                }
// 				if(urlObj.tipnum == 1)//根据不同需求调整弹窗大小
// 				{
// 					WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
// 					params.width = (int) (dm.widthPixels*0.75);
// 					params.height = (int) (dm.heightPixels*0.85);
// 					dialog.getWindow().setAttributes(params);
// 				}
            }
        });
    }
    private void openBrowser(String url) {
        Uri uri = Uri.parse(url);
        Intent intent = new Intent(Intent.ACTION_VIEW, uri);
        startActivity(intent);
    }

    public void checkWebViewDailog(final Dialog payDialog, final int callback,final String args){
        try {
            if (payDialog.isShowing() && mbCheck == true)
            {
                Thread.sleep(1000);
                checkWebViewDailog(payDialog, callback,args);
                return;
            }
            mbCheck = false;

            Cocos2dxLuaJavaBridge.callLuaFunctionWithString(callback, args);
            Cocos2dxLuaJavaBridge.releaseLuaFunction(callback);
            return;
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public class JsInteration {

        @JavascriptInterface
        public String getUrl() {
            return mUrl;
        }
    }

    /**
     * 电量
     */
    private void monitorBatteryState() {
        //Log.d(Tag, "monitorBatteryState");
        batteryLevelRcvr = new BroadcastReceiver() {

            @Override
            public void onReceive(Context context, Intent intent) {
                StringBuilder sb = new StringBuilder();
                int rawlevel = intent.getIntExtra("level", -1);
                int scale = intent.getIntExtra("scale", -1);
                int status = intent.getIntExtra("status", -1);
                int health = intent.getIntExtra("health", -1);
//                int level = -1; // percentage, or -1 for unknown
                int level = 0;
                if (rawlevel >= 0 && scale > 0) {
                    level = (rawlevel * 100) / scale;
                }

                DeviceUtil.setBatteryLevel(level);
                DeviceUtil.setBatteryStatus(status);
            }
        };
        batteryLevelFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
        registerReceiver(batteryLevelRcvr, batteryLevelFilter);
        registeredBlRecv = true;
    }

    /**
     * 网络信号
     */
    private void monitorMobileState() {
        //Log.d(Tag, "monitorMobileState");
        mobielStateListener = new MyPhoneStateListener();
        telephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
        if (telephonyManager != null) {
            telephonyManager.listen(mobielStateListener,
                    PhoneStateListener.LISTEN_SIGNAL_STRENGTHS);
        }
    }

    private class MyPhoneStateListener extends PhoneStateListener {
        @Override
        public void onSignalStrengthsChanged(SignalStrength signalStrength) {
            super.onSignalStrengthsChanged(signalStrength);

            DeviceUtil.setMobileSignalLevel(signalStrength);
//            Log.i("AppActivity", "signal:" + signalStrength);
        }
    }
}
