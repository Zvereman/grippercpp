QT += quick serialbus opengl serialport charts qml 3dcore 3drender 3dinput 3dlogic 3dquick 3dquickextras quickcontrols2 quick3d
CONFIG += c++11

include(project.properties)

SOURCES += \
        gripper.cpp \
        main.cpp

RESOURCES += qml.qrc \
    models.qrc

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
