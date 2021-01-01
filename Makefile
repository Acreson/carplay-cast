export THEOS_DEVICE_IP=192.168.86.10

ARCHS = arm64
TARGET=iphone:clang:13.5.1:13.5.1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = carplayenable
carplayenable_FILES = $(wildcard src/hooks/*.xm) $(wildcard src/*.mm) $(wildcard src/crash_reporting/*.mm)
carplayenable_PRIVATE_FRAMEWORKS += CoreSymbolication

include $(THEOS_MAKE_PATH)/tweak.mk

after-carplayenable-stage::
	mkdir -p $(THEOS_STAGING_DIR)/var/mobile/Library/Preferences/
	cp BLACKLISTED_APPS.plist $(THEOS_STAGING_DIR)/var/mobile/Library/Preferences/com.carplayenable.blacklisted-apps.plist

after-install::
	install.exec "killall -9 SpringBoard CarPlay"

test::
	install.exec "cycript -p SpringBoard" < tests/springboard_tests.cy
	install.exec "cycript -p CarPlay" < tests/carplay_tests.cy