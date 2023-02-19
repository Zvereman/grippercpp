QT += quick serialbus serialport charts qml
CONFIG += c++11

include(project.properties)

SOURCES += \
        gripper.cpp \
        main.cpp

RESOURCES += qml.qrc

VERSION = $${APP_VERSION}
RC_ICONS = $${APP_ICON}
QMAKE_TARGET_COMPANY = ASBIS

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    defines.h \
    gripper.h

DISTFILES +=

DEFINES += "APP_NAME=\"\\\"$$APP_NAME\\\"\""
DEFINES += APP_VERSION='\\"$$VERSION\\"'
