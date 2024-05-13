import QtQuick 2.0

Comp__BASE_MapQuickItem{
        id: compMapItem_AntennaRange_Root

        property bool isAlly: false
        property real effectiveRadiusKm: 2.0
        property color color: isAlly ? "#dd00ff11" : "#ddff1111"

        zoomLevel: 0.5

        sourceItem: Rectangle{

            property var coords

            radius: 0.5 * height

            height: compMapItem_AntennaRange_Root.effectiveRadiusKm * 0.5
            width: height

            color: Qt.lighter(compMapItem_AntennaRange_Root.color)
        }

    }
