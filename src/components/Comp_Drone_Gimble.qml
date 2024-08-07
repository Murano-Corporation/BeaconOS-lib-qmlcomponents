import QtQuick 2.15
//import QtQuick.Controls 2.15

Comp__BASE {
    id: root

    height: 180 //scaleable!!!
    width: 180

    property color outerColor: "#ffffff"//"#9287ed"
    property color outerBorderColor: "grey" //blue
    property color innerColor: "#ffffff"//"#9287ed"

    property real joystickDefaultX: (outerCircle.width - joystick.width) / 2 //centers the joystick in the middle of the outerCircle
    property real joystickDefaultY: (outerCircle.height - joystick.height) / 2

    property alias joystickXValue: joystick.finalX
    property alias joystickYValue: joystick.finalY

    property real deadZoneX: 0.25
    property real deadZoneY: 0.25
    readonly property real rootHalfWidth: width * 0.5
    readonly property real rootHalfHeight: height * 0.5

    property bool isThrottle //for left stick true, right stick false

    Rectangle {
        id: outerBox

        color: root.innerColor
        height: root.height
        width: root.width
        border.color: root.outerBorderColor
        border.width: 1
        radius: 30
        anchors.centerIn: root

        Rectangle {
            id: outerCircle //purely aesthetics

            visible: false

            color: root.outerColor
            height: root.height
            width: root.width
            border.color: root.outerBorderColor
            border.width: 1
            radius: root.width * 0.5
            anchors.centerIn: parent
        }

        Rectangle {
            id: joystick

                color: root.innerColor
                border.color: root.outerBorderColor
                height: root.height * 0.3
                width: root.width * 0.3
                radius: root.width * 0.5
                x: root.joystickDefaultX
                y: root.joystickDefaultY
                readonly property real joystickHalfWidth: width * 0.5
                readonly property real joystickHalfHeight: height * 0.5
                property real liveCenterX: joystick.x + joystickHalfWidth - rootHalfWidth //live location in relation to the center of the outer circle
                property real liveCenterY: joystick.y + joystickHalfWidth - rootHalfHeight

                property real finalX
                property real finalY

            property real finalX
            property real finalY

        }

        MultiPointTouchArea {
            id: joystickArea
            anchors.fill: parent
            minimumTouchPoints: 1
            maximumTouchPoints: 1

            onTouchUpdated: touchPoints => {

                                if( touchPoints.length === 0)
                                return

                                if (touchPoints[0].x - joystick.joystickHalfWidth >= 0 && touchPoints[0].x + joystick.joystickHalfWidth <= root.width ) {
                                    joystick.x = touchPoints[0].x - joystick.joystickHalfWidth
                                    joystick.finalX = (joystick.liveCenterX / 87.5) /// 90
                                }
                                if (touchPoints[0].y - (joystick.width / 2) >= 0 && touchPoints[0].y + joystick.joystickHalfHeight <= root.height){
                                    joystick.y = touchPoints[0].y - joystick.joystickHalfHeight
                                    joystick.finalY = -(joystick.liveCenterY / 87.5) /// 90
                                }

                                if (touchPoints[0].x < (joystick.joystickHalfWidth)) {
                                    joystick.x = 0
                                    joystick.finalX = -1
                                }
                                if (touchPoints[0].y < (joystick.joystickHalfHeight)) {
                                    joystick.y = 0
                                    joystick.finalY = 1
                                }
                                if (touchPoints[0].x > (root.width - (joystick.joystickHalfWidth))) {
                                    joystick.x = root.width - (joystick.width)
                                    joystick.finalX = 1
                                }
                                if (touchPoints[0].y > (root.height - (joystick.joystickHalfHeight))) {
                                    joystick.y = root.height - (joystick.height)
                                    joystick.finalY = -1
                                }

                                //console.log(touchPoints[0].x + " " + touchPoints[0].y)
                                //console.log(joystick.liveCenterX + " liveCenterX " + joystick.liveCenterY + " liveCenterY ") //circle radius is 150
                                //console.log(joystick.finalX + " finalX " + joystick.finalY + " finalY ")
                                //console.log(joystick.x + " joystick.x " + joystick.y + " joystick.y")
                            }

            onGestureStarted: {
                joystick.opacity = 0.8
            }

            onReleased: {
                if (isThrottle === false) {
                    joystick.x = root.joystickDefaultX
                    joystick.y = root.joystickDefaultY
                    joystick.finalX = 0
                    joystick.finalY = 0
                    ////console.log(touchPoints[0].x + " " + touchPoints[0].y)
                    ////console.log(joystick.liveCenterX + " liveCenterX " + joystick.liveCenterY + " liveCenterY ") //circle radius is 150
                    ////console.log(joystick.finalX + " finalX " + joystick.finalY + " finalY ")
                    ////console.log(joystick.x + " joystick.x " + joystick.y + " joystick.y")

                }
                else {
                    joystick.x = root.joystickDefaultX
                    joystick.finalX = 0
                    //console.log(touchPoints[0].x + " " + touchPoints[0].y)
                    //console.log(joystick.liveCenterX + " liveCenterX " + joystick.liveCenterY + " liveCenterY ") //circle radius is 150
                    //console.log(joystick.finalX + " finalX " + joystick.finalY + " finalY ")
                    //console.log(joystick.x + " joystick.x " + joystick.y + " joystick.y")
                }

                joystick.opacity = 1.0
            }
        }
    }
}
