# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-sailwave

CONFIG += sailfishapp
QT += multimedia

SOURCES += src/harbour-sailwave.cpp \
    src/sailwave.cpp

OTHER_FILES += qml/harbour-sailwave.qml \
    qml/pages/*.qml \
    qml/common/*.qml \
    qml/cover/CoverPage.qml \
    qml/js/*.js \
    qml/images/radio.png \
    qml/images/GPLv3.png \
    rpm/harbour-sailwave.spec \
    rpm/harbour-sailwave.yaml \
    harbour-sailwave.desktop \
    translations/*.ts

CONFIG += sailfishapp_i18n
TRANSLATIONS += \
    translations/harbour-sailwave.ts \
    translations/harbour-sailwave-*.ts

HEADERS += \
    src/sailwave.h

