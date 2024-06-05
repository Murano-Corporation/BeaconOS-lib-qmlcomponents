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

    property real minimumWidth: 300
    property real minimumHeight: 450

    //property real savedX: UtilityCalculator.savedX
    //property real savedY: UtilityCalculator.savedY

    //property real maxiumumWidth: 900
    //property real maximumHeight: 1350

    opacity: 0.8
    modal: false
    closePolicy: Popup.NoAutoClose
    background: Item {}

    CompResizableMoveableContainer {
        id: containerRoot

        //x: popup.savedX
        //y: popup.savedY
        minX: 0
        minY: 0
        maxX: screenWidth - containerRoot.width - 25 //not dynamic
        maxY: screenHeight - containerRoot.height - 25 // not dynamic

        height: popup.minimumHeight
        width: popup.minimumWidth

        minimumWidth: popup.minimumWidth
        minimumHeight: popup.minimumHeight

        //maximumWidth: 600
        //maximumHeight: 1350

        CompPopupBG{
            id: rectBG
            anchors.fill: parent
        }

        Component.onDestruction: {
            console.log("destructed!")
            console.log("Old coords: " + popup.savedX + ", " + popup.savedY + " x, y " + x + ", " + y)
            popup.savedX = x
            popup.savedY = y
            console.log("New coords: " + popup.savedX + ", " + popup.savedY + " x, y " + x + ", " + y)
        }

        Component.onCompleted: {
            console.log("completed!")
            console.log("Old coords: " + popup.savedX + ", " + popup.savedY + " x, y " + x + ", " + y)
            x = popup.savedX
            y = popup.savedY
            console.log("New coords: " + popup.savedX + ", " + popup.savedY + " x, y " + x + ", " + y)
        }


        Screen_Calculator{
            bCanLeaveScreen: false
            anchors.fill: parent
            anchors.margins: 20
            opacity: 0.8
        }
    }
}


