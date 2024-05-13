import QtQuick 2.0



Comp__BASE_MapQuickItem{
    id: compMapItem_ACCarrier_Root

    property bool isAlly: false
    property real heading: 0.0
    property real headingIndicatorWidth: 10

    sourceItem: CompIcon_AircraftCarrier {
        id: compIcon_AircraftCarrier

        property var coords

        color: compMapItem_ACCarrier_Root.isAlly ? "#dd00FF11" : "#ddff1111"

        height: compMapItem_ACCarrier_Root.itemHeight
        width: compMapItem_ACCarrier_Root.itemWidth

        Comp_3dReconVisualizer{

        }

        //Rectangle{

        //    anchors.fill: parent

        //    color: "#80ffffff"
        //}

        Item{
            id: groupHeadingIndicator

            x: (compIcon_AircraftCarrier.width * 0.5) - (width * 0.5)
            y: 0

            height: compIcon_AircraftCarrier.height
            width: compMapItem_ACCarrier_Root.headingIndicatorWidth

            transform: Rotation{
                angle: compMapItem_ACCarrier_Root.heading
                origin{
                    x: groupHeadingIndicator.width * 0.5
                    y: groupHeadingIndicator.height * 0.5

                }
            }

            //Rectangle{
            //    anchors.fill: parent
            //    color: "#80000000"
            //}


            Rectangle{
                id: rectHeading

                width: compMapItem_ACCarrier_Root.headingIndicatorWidth
                height: width

                radius: 0.5 * width

                color: compIcon_AircraftCarrier.color

                anchors{
                    bottom: parent.top
                    horizontalCenter: parent.horizontalCenter
                }
            }

            //Rectangle{
            //    id: rectCenter

            //    width: compMapItem_ACCarrier_Root.headingIndicatorWidth
            //    height: width

            //    radius: 0.5 * width

            //    color: "blue"

            //    anchors{
            //        top: parent.bottom
            //        horizontalCenter: parent.horizontalCenter
            //    }

            //}

        }




        MouseArea{
            anchors.fill: parent

            onClicked: {
                compMapItem_ACCarrier_Root.centerOnPoint(coordinate)
            }

            onDoubleClicked: {
                compMapItem_ACCarrier_Root.fitViewportToVisibleMapItems()
                compMapItem_ACCarrier_Root.centerOnPoint(coordinate)
            }
        }
    }

}
