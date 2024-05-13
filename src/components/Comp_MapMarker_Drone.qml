import QtQuick 2.0

Comp__BASE_MapQuickItem {
    id: compIcon_Drone

    property bool isAlly: false
    property real heading: 0.0
    property real headingIndicatorWidth: 10
    property real velocity: 10.0

    sourceItem: CompIcon_Drone{

        property var coords

        color: isAlly ? "#DD00ff11" : "#DDff1111"

        transform: Rotation{
            origin{
                x: width * 0.5
                y: height * 0.5
            }

            angle: compIcon_Drone.heading
        }

        height: compIcon_Drone.itemHeight
        width: compIcon_Drone.itemWidth

        Rectangle{
            id: rectHeading

            width: compIcon_Drone.headingIndicatorWidth
            height: width

            radius: 0.5 * width

            color: parent.color

            anchors{
                bottom: parent.top
                horizontalCenter: parent.horizontalCenter
            }

        }

        MouseArea{
            anchors.fill: parent

            onClicked: {
                compIcon_Drone.centerOnPoint(coordinate)
            }

            onDoubleClicked: {
                compIcon_Drone.fitViewportToVisibleMapItems()
                compIcon_Drone.centerOnPoint(coordinate)
            }
        }

    }


}
