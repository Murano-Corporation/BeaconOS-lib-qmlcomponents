import QtQuick 2.0

Comp__BASE_MapQuickItem {
    id: compMapItem_Antenna_Root

    property bool isAlly: false
    property real effectiveRadiusKm: 2.0

    //itemHeight: 2
    //itemWidth: 2

    //zoomLevel: 1.0

    sourceItem: CompIcon_Antenna {
        id: compIcon_Antenna

        property var coords

        color: compMapItem_Antenna_Root.isAlly ? "#dd00FF11" : "#ddff1111"

        height: compMapItem_Antenna_Root.itemHeight
        width: compMapItem_Antenna_Root.itemWidth

        //Rectangle{

        //    z: -1
        //    opacity: 0.5
        //    anchors{
        //        centerIn: compIcon_Antenna
        //    }

        //    height: 2.0 * compMapItem_Antenna_Root.effectiveRadiusKm
        //    width: height

        //    radius: 0.5 * height

        //    color: Qt.lighter(compIcon_Antenna.color)
        //}


        MouseArea{
            anchors.fill: parent

            onClicked: {
                compMapItem_Antenna_Root.centerOnPoint(coordinate)
            }

            onDoubleClicked: {
                compMapItem_Antenna_Root.fitViewportToVisibleMapItems()
                compMapItem_Antenna_Root.centerOnPoint(coordinate)
            }
        }

    }


}
