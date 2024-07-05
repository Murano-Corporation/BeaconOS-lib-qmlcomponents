import QtQuick 2.15

Item {
    id: comp_Raptor_Altimeter

    property alias compassAngle: compass.angle
    property alias rollAngle: roll.roll
    property alias tiltAngle: tilt.angle

    Comp_Raptor_Altimeter_Roll {
        id: roll

        anchors.centerIn: parent
    }

    Comp_Raptor_Altimeter_Tilt {
        id: tilt

        anchors.centerIn: parent
    }

    Comp_Raptor_Altimeter_CrossHair {
        id: crosshair

        anchors.centerIn: parent
    }

    Comp_Raptor_Altimeter_Compass {
        id: compass

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
    }
}
