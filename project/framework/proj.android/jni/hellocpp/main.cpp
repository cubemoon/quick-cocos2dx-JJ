
#include "cocos2d.h"
#include "AppDelegate.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>
#include <android/log.h>

#define  LOG_TAG    "main"
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)

using namespace cocos2d;
extern int register_android_ime_Methods(JNIEnv* env);
extern "C"
{
jint JNI_OnLoad(JavaVM *vm, void *reserved)
{
	JNIEnv* env = NULL;
    jint result = JNI_ERR;
    JniHelper::setJavaVM(vm);
	if (vm->GetEnv((void**) &env, JNI_VERSION_1_4) != JNI_OK) {  
		CCLog("[JNI]: GetEnv failed!");  
        return result;  
    }
	 //JniHelper::setJavaVM(vm);

	if (register_android_ime_Methods(env) != JNI_OK)
     {
		 CCLog("[JNI]: register_MainController_Methods failed!");       
		 return result;
     }

    return JNI_VERSION_1_4;
}

void Java_org_cocos2dx_lib_Cocos2dxRenderer_nativeInit(JNIEnv*  env, jobject thiz, jint w, jint h, jboolean reload, jboolean pause)
{
    CCEGLView* view = cocos2d::CCDirector::sharedDirector()->getOpenGLView();
    if (!view)
    {
        view = CCEGLView::sharedOpenGLView();
        view->setFrameSize(w, h);

        AppDelegate *pAppDelegate = new AppDelegate();
        CCApplication::sharedApplication()->run();
    }
    else
    {
        // [Yangzukang][2014.05.15]For CC_ENABLE_CACHE_TEXTURE_DATA
//        ccDrawInit();
//        ccGLInvalidateStateCache();
//
//        CCShaderCache::sharedShaderCache()->reloadDefaultShaders();
//        CCTextureCache::reloadAllTextures();
//        CCNotificationCenter::sharedNotificationCenter()->postNotification(EVENT_COME_TO_FOREGROUND, NULL);
//        CCDirector::sharedDirector()->setGLDefaultValues();

        if (view->getFrameSize().width != w || view->getFrameSize().height != h) {
            view->setFrameSize(w, h);
            view->setDesignResolutionSize(w, h, kResolutionShowAll);

            // 通知 Lua，界面大小变化
            if (!pause)
            {
                CCNotificationCenter::sharedNotificationCenter()->postNotification("SizeChange");                
            }
        }
    }

    // [Yangzukang][2014.05.20]reload texture while gl10 context changed
    if (reload && !pause)
    {
        ccDrawInit();
        ccGLInvalidateStateCache();

        CCShaderCache::sharedShaderCache()->reloadDefaultShaders();
        CCTextureCache::reloadAllTextures();
        CCNotificationCenter::sharedNotificationCenter()->postNotification(EVENT_COME_TO_FOREGROUND, NULL);
        CCDirector::sharedDirector()->setGLDefaultValues();
    }
}

}
