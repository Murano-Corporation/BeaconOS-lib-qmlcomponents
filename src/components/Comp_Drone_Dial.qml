import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15

Comp__BASE{
    id: root

    height: 100
    width: 100

    property color fontColor: "white"
    property color dialPositionColor: "white"
    property color outerBorderColor: "#0E1111"
    property color innerColor: "#065465"

    property int fontSize: 24
    property int dialNum: 0
    property int dialStartingX: -(dialPosition.width / 2) + (dial.width / 2)
    property real startingX

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onPressed: {
            startingX = mouseX
            //console.log("pressed")
        }

        onPositionChanged: {
            //console.log("posChanged")
            //console.log("mouseX: " + mouseX + " mouseY: " + mouseY)
            if (mouseX > startingX) {
                dialNum++

                if (dialNum >= 100) {
                    dialNum = 100
                    console.log("Max")
                }
                else {
                    dial.rotation = dial.rotation + 1.5
                    console.log("Going up")
                }
            }
            else {
                dialNum--
                if (dialNum <= -100) {
                    dialNum = -100
                    console.log("Min")
                }
                else {
                    dial.rotation = dial.rotation - 1.5
                    console.log("Going down")
                }
            }
            startingX = mouseX
        } //press and hold future upgrade
    }

    // MouseArea {
    //     id: dragArea
    //     anchors.fill: parent

    //     // Variables to track mouse movement
    //     property real startX: 0
    //     property real startY: 0
    //     property real startRotation: 0

    //     // Calculate angle based on mouse position
    //     function calculateAngle(x, y) {
    //         var deltaX = x - dial.width / 2
    //         var deltaY = y - dial.height / 2
    //         return Math.atan2(deltaY, deltaX) * 180 / Math.PI
    //     }

    //     onPressed: {
    //         startX = mouse.x
    //         startY = mouse.y
    //         startRotation = dial.rotation
    //     }

    //     onPositionChanged: {
    //         var angle = calculateAngle(mouse.x, mouse.y)
    //         dial.rotation = startRotation + angle
    //     }
    // }

    Rectangle {
        id: dial

        height: root.height
        width: root.width
        radius: dial.width * 0.5
        border.color: root.outerBorderColor
        color: root.innerColor

        Rectangle{
            id: dialPosition

            color: root.dialPositionColor
            border.color: root.outerBorderColor
            height: root.height * 0.2
            width: root.width * 0.2
            radius: dialPosition.width * 0.5

            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: root.height * 0.025
            }
        }

    }
    Text {
        id: dialNumPosition

        text: dialNum
        font.pixelSize: root.fontSize
        color: root.fontColor
        anchors.centerIn: parent
    }
}
