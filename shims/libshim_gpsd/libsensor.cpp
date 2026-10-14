
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#include <utils/Singleton.h>

namespace android {
    // Forward-declared only: Singleton<SensorManager>::sLock/sInstance below
    // don't need SensorManager's complete type (sInstance is just a pointer),
    // and avoiding the include keeps this shim decoupled from the real
    // sensor headers.
    class SensorManager;
    //android::String16::String16(char const*)
    extern "C" void _ZN7android8String16C1EPKc(void **str16P, const char *str);

    //android::String16::~String16()
    extern "C" void _ZN7android8String16D1Ev(void **str16P);

    extern "C" void _ZN7android13SensorManager16createEventQueueENS_7String8EiNS_8String16E(void **retVal, void *sensorMgr, void **str8P, int mode, void **str16P);

    extern "C" void _ZN7android13SensorManager16createEventQueueENS_7String8Ei(void **retVal, void *sensorMgr, void **str8P, int mode)
    {
        void *string;

        _ZN7android8String16C1EPKc(&string, "");
        _ZN7android13SensorManager16createEventQueueENS_7String8EiNS_8String16E(retVal, sensorMgr, str8P, mode, &string);
        _ZN7android8String16D1Ev(&string);
    }

    extern "C" void _ZN7android8String16aSEOS0_();
    extern "C" void _ZN7android8String16aSEOS0_(){}

    extern "C" void _ZN7android8String16C1EOS0_();
    extern "C" void _ZN7android8String16C1EOS0_(){}

    // sLock/sInstance are the static data members backing
    // Singleton<SensorManager>::getInstance()/hasInstance() (see
    // utils/Singleton.h's ANDROID_SINGLETON_STATIC_INSTANCE macro, which
    // this hand-expands without requiring SensorManager's complete type).
    // The prebuilt gpsd binary references these two mangled symbol names
    // directly (it predates the modern non-template SensorManager
    // reimplementation in hardware/lineage/compat, and still has the old
    // Singleton<SensorManager>-based getInstance() baked into its own
    // compiled code). The previous version of this shim defined them as
    // empty FUNCTIONS just to satisfy the linker - but any code that
    // actually calls getInstance()/hasInstance() treats this memory as
    // real Mutex/pointer data (locking sLock, dereferencing sInstance),
    // and executable stub bytes are neither. Defining them as genuine data
    // fixes that, while keeping the exact same symbol names gpsd expects.
    template<> Mutex Singleton<SensorManager>::sLock(Mutex::PRIVATE);
    template<> SensorManager* Singleton<SensorManager>::sInstance(nullptr);

    extern "C" void _ZN7android13SensorManager16createEventQueueEv();
    extern "C" void _ZN7android13SensorManager16createEventQueueEv(){}

    extern "C" void _ZN7android13SensorManagerC1Ev();
    extern "C" void _ZN7android13SensorManagerC1Ev(){}

    extern "C" void _ZNK7android16SensorEventQueue5getFdEv();
    extern "C" void _ZNK7android16SensorEventQueue5getFdEv(){};

}
