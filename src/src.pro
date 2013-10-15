
# Main project file for Colorful Home

TEMPLATE = app
TARGET = lipstick
VERSION = 0.1

INSTALLS = target
target.path = /usr/bin

CONFIG += qt link_pkgconfig
QT += network svg dbus xml declarative

HEADERS += \
    eventfilter.h

SOURCES += \
    main.cpp

RESOURCES += \
    resources-qml.qrc \
    resources-images.qrc

PKGCONFIG += lipstick-socam

OTHER_FILES += \
    qml/pages/AppLauncher.qml \
    qml/pages/AppSwitcher.qml \
    qml/pages/AppSwitcher/SwitcherItem.qml \
    qml/components/Pager.qml \
    qml/components/TabBar.qml \
    qml/MainScreen.qml \
    qml/components/Lockscreen.qml \
    qml/pages/AppLauncher/LauncherItem.qml \
    qml/pages/Search.qml \
    qml/pages/Cloud.qml \
    qml/NotificationPreview.qml \
    qml/VolumeControl.qml \
    qml/USBModeSelector.qml \
    qml/ShutdownScreen.qml \
    qml/pages/AppShortcut.qml \
    qml/pages/ScreenShortcut.qml \
    qml/pages/Home.sql \
    qml/pages/Home.qml \
    qml/pages/AppSwitcher/ImageButton.qml \
    qml/pages/Lockscreen/LockscreenClock.qml \
    qml/pages/Lockscreen.qml \
    qml/pages/Lockscreen/NotificationIcon.qml \
    qml/feeds.js \
    qml/components/WeatherWidget.qml \
    qml/weather.js \
    qml/components/WeatherLocationSelection.qml \
    lipstick-colorful-home.ts


# translations
TS_FILE = $$OUT_PWD/lipstick-colorful-home.ts
EE_QM = $$OUT_PWD/lipstick-colorful-home_eng_en.qm
ts.commands += lupdate $$PWD -ts $$TS_FILE
ts.CONFIG += no_check_exist
ts.output = $$TS_FILE
ts.input = .
ts_install.files = $$TS_FILE
ts_install.path = /usr/share/translations/source
ts_install.CONFIG += no_check_exist

# should add -markuntranslated "-" when proper translations are in place (or for testing)
engineering_english.commands += lrelease -idbased $$TS_FILE -qm $$EE_QM
engineering_english.CONFIG += no_check_exist
engineering_english.depends = ts
engineering_english.input = $$TS_FILE
engineering_english.output = $$EE_QM
engineering_english_install.path = /usr/share/translations
engineering_english_install.files = $$EE_QM
engineering_english_install.CONFIG += no_check_exist

QMAKE_EXTRA_TARGETS += ts engineering_english
PRE_TARGETDEPS += ts engineering_english
