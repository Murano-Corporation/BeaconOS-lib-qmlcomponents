import QtQuick 2.15
//import QtQuick.Controls 2.15

Comp__BASE {
    id: root

    height: 250 //scaleable!!!
    width: 250

    property color outerColor: "#9287ed"
    property color outerBorderColor: "blue"
    property color innerColor: "#9287ed"

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
                height: root.height * 0.3
                width: root.width * 0.3
                radius: root.width * 0.5
                x: root.joystickDefaultX
                y: root.joystickDefaultY

                property real liveCenterX: joystick.x + (joystick.width / 2) - (root.width / 2) //live location in relation to the center of the outer circle
                property real liveCenterY: joystick.y + (joystick.height / 2) - (root.height / 2)

                property real finalX
                property real finalY

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

                if (touchPoints[0].x - (joystick.width / 2) >= 0 && touchPoints[0].x + (joystick.width / 2) <= root.width ) {
                    joystick.x = touchPoints[0].x - joystick.width / 2
                    joystick.finalX = parseInt(joystick.liveCenterX / .0875) /// 90
                }
                if (touchPoints[0].y - (joystick.width / 2) >= 0 && touchPoints[0].y + (joystick.height / 2) <= root.height){
                    joystick.y = touchPoints[0].y - joystick.height / 2
                    joystick.finalY = parseInt(joystick.liveCenterY / .0875) /// 90
                }

                    if (touchPoints[0].x < (joystick.width / 2)) {
                        joystick.x = 0
                        joystick.finalX = -1000
                    }
                    if (touchPoints[0].y < (joystick.height / 2)) {
                        joystick.y = 0
                        joystick.finalY = -1000
                    }
                    if (touchPoints[0].x > (root.width - (joystick.width / 2))) {
                        joystick.x = root.width - (joystick.width)
                        joystick.finalX = 1000
                    }
                    if (touchPoints[0].y > (root.height - (joystick.height / 2))) {
                        joystick.y = root.height - (joystick.height)
                        joystick.finalY = 1000
                    }

                    console.log(touchPoints[0].x + " " + touchPoints[0].y)
                    console.log(joystick.liveCenterX + " liveCenterX " + joystick.liveCenterY + " liveCenterY ") //circle radius is 150
                    console.log(joystick.finalX + " finalX " + joystick.finalY + " finalY ")
                    console.log(joystick.x + " joystick.x " + joystick.y + " joystick.y")
            }

            onGestureStarted: {
               joystick.opacity = 0.8
            }

            onReleased: {
                if (isThrottle === false) {
                    joystick.x = root.joystickDefaultX
                    joystick.y = root.joystickDefaultY
                    console.log(touchPoints[0].x + " " + touchPoints[0].y)
                    console.log(joystick.liveCenterX + " liveCenterX " + joystick.liveCenterY + " liveCenterY ") //circle radius is 150
                    console.log(joystick.finalX + " finalX " + joystick.finalY + " finalY ")
                    console.log(joystick.x + " joystick.x " + joystick.y + " joystick.y")

                }
                else {
                    joystick.x = root.joystickDefaultX
                    joystick.finalX = 0
                    console.log(touchPoints[0].x + " " + touchPoints[0].y)
                    console.log(joystick.liveCenterX + " liveCenterX " + joystick.liveCenterY + " liveCenterY ") //circle radius is 150
                    console.log(joystick.finalX + " finalX " + joystick.finalY + " finalY ")
                    console.log(joystick.x + " joystick.x " + joystick.y + " joystick.y")
                }

                joystick.opacity = 1.0
            }
        }
    }
}
