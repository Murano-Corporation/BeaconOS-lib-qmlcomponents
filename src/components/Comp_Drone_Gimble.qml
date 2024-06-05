import QtQuick 2.15
//import QtQuick.Controls 2.15

Comp__BASE {
    id: root

    height: 250 //scaleable!!!
    width: 250

    property color outerColor: "grey"
    property color outerBorderColor: "#0E1111"
    property color innerColor: "#065465"

    property real joystickDefaultX: (outerCircle.width - joystick.width) / 2 //centers the joystick in the middle of the outerCircle
    property real joystickDefaultY: (outerCircle.height - joystick.height) / 2

    property bool isThrottle //for left stick true, right stick false

    Rectangle {
        id: outerBox //purely aesthetics

        color: root.innerColor
        height: root.height
        width: root.width
        border.color: root.outerBorderColor
        border.width: 1
        radius: 20
        anchors.centerIn: root

        Rectangle {
            id: outerCircle

            color: root.outerColor
            height: root.height
            width: root.width
            border.color: root.outerBorderColor
            border.width: 1
            radius: root.width * 0.5
            anchors.centerIn: parent

            Rectangle {
                id: joystick

                color: root.innerColor
                border.color: root.outerBorderColor
                height: root.height * 0.4
                width: root.width * 0.4
                radius: root.width * 0.5
                x: root.joystickDefaultX
                y: root.joystickDefaultY

                property real liveCenterX: joystick.x + (joystick.width / 2) - (root.width / 2) //live location in relation to the center of the outer circle
                property real liveCenterY: joystick.y + (joystick.height / 2) - (root.height / 2)

                property real liveX
                property real liveY

            }
        }

        MultiPointTouchArea {
            id: joystickArea
            anchors.fill: parent
            minimumTouchPoints: 1
            maximumTouchPoints: 1

            onTouchUpdated: touchPoints => {

                if( touchPoints.length === 0)
                return

                //console.log(touchPoints[0].x + " " + touchPoints[0].y)
                console.log(joystick.liveCenterX + " liveCenterX " + joystick.liveCenterY + " liveCenterY ") //circle radius is 150
                console.log(joystick.liveX + " droneX " + joystick.liveY + " droneY ")

                if (touchPoints[0].x - (joystick.width / 2) >= 0 && touchPoints[0].x + (joystick.width / 2) <= root.width ) {
                    joystick.x = touchPoints[0].x - joystick.width / 2
                    joystick.liveX = joystick.liveCenterX / (root.width / 3.33333333) /// 90
                }
                if (touchPoints[0].y - (joystick.width / 2) >= 0 && touchPoints[0].y + (joystick.height / 2) <= root.height){
                    joystick.y = touchPoints[0].y - joystick.height / 2
                    joystick.liveY = joystick.liveCenterY / (root.height / 3.33333333) /// 90
                }

                else {
                    if (touchPoints[0].x < 0) {
                        joystick.x = 0
                        joystick.liveX = -1
                    }
                    if (touchPoints[0].y < 0) {
                        joystick.y = 0
                        joystick.liveY = -1
                    }
                    if (touchPoints[0].x > root.width) {
                        joystick.x = root.width - (joystick.width)
                        joystick.liveX = 1
                    }
                    if (touchPoints[0].y > root.height) {
                        joystick.y = root.height - (joystick.height)
                        joystick.liveY = 1
                    }
                }
            }

            onGestureStarted: {
               joystick.opacity = 0.8
            }

            onReleased: {
                if (isThrottle === false) {
                    joystick.x = root.joystickDefaultX
                    joystick.y = root.joystickDefaultY
                }
                else {
                    joystick.x = root.joystickDefaultX
                }

                joystick.opacity = 1.0
            }
        }
    }
}
