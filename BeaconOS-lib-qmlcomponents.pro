QT -= gui
QT += qml

TEMPLATE = lib
DEFINES += BEACONOSLIBQMLCOMPONENTS_LIBRARY

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    src/beaconos_lib_qmlcomponents.cpp

HEADERS += \
    src/BeaconOS-lib-qmlcomponents_global.h \
    src/beaconos_lib_qmlcomponents.h

# Default rules for deployment.
unix {
    target.path = /usr/lib
}
!isEmpty(target.path): INSTALLS += target

RESOURCES += \
    src/components/beaconos_lib_qmlcomponents.qrc


##LIBRARY - QML COMPONENTS
#LIB_QMLCOMPONENTS_QML_DIR = $$PWD/../../libraries/BeaconOS-lib-qmlcomponents/src/components/beaconos_lib_qmlcomponents.qrc
#RESOURCES += $${LIB_QMLCOMPONENTS_QML_DIR}



