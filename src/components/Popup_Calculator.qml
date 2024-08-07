import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

//position it freely, maximum size
//minimum size cannot be achieved again once resized
//store size as well as position

Popup {
    id: popup

    property real screenHeight: parent.height
    property real screenWidth: parent.width

    property real minimumWidth: 800
    property real minimumHeight: 600

    modal: false
    closePolicy: Popup.NoAutoClose
    background: Item{}

    CompResizableMoveableContainer {
        id: containerRoot
        //x: popup.savedX
        //y: popup.savedY
        minX: 0
        minY: 0
        maxX: screenWidth - containerRoot.width - 25 //not dynamic //for screen borders
        maxY: screenHeight - containerRoot.height - 25 // not dynamic //for screen borders

        opacity: 0.8

        //height: popup.minimumHeight
        //width: popup.minimumWidth

        minimumWidth: popup.minimumWidth
        minimumHeight: popup.minimumHeight

        //maximumWidth: 600
        //maximumHeight: 1350

        CompPopupBG{
            id: rectBG
            anchors.fill: parent
        }



        Component.onCompleted: {

            var rect = UtilityCalculator.rPopupRect

            containerRoot.x = rect.x
            containerRoot.y = rect.y
            containerRoot.width = rect.width
            containerRoot.height = rect.height

            updateResizeRectPos()
        }

        onXChanged: {
            var rect = UtilityCalculator.rPopupRect

            rect.x = containerRoot.x

            UtilityCalculator.rPopupRect = rect
        }

        onYChanged: {
            var rect = UtilityCalculator.rPopupRect

            rect.y = containerRoot.y

            UtilityCalculator.rPopupRect = rect
        }

        onWidthChanged: {
            var rect = UtilityCalculator.rPopupRect

            rect.width = containerRoot.width

            UtilityCalculator.rPopupRect = rect
        }

        onHeightChanged: {
            var rect = UtilityCalculator.rPopupRect

            rect.height = containerRoot.height

            UtilityCalculator.rPopupRect = rect
        }



        Screen_Calculator{
            bCanLeaveScreen: false
            anchors.fill: parent
            anchors.topMargin: 40
            anchors.bottomMargin: 20
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            //anchors.margins: 20
            keyFontSize: Math.min(containerRoot.height, containerRoot.width) * 0.04;
        }
    }
}


