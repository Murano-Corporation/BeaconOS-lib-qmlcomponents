import QtQuick 2.15

Rectangle {
    id: compRaptorAltimerTiltRoot

    height: 975
    width: 195
    color: "transparent"

    property real zero: -clipItem.height - 107

    property real minY: zero - tiltImage.height + 23
    property real maxY: zero + tiltImage.height - 23

    property alias angle: tiltImageTranslate.y

    // Component.onCompleted: {
    // timter.start()
    // }

    Timer {
        id: timter
        interval: 50
        onTriggered: {
            tiltImageTranslate.y -= 400
        }
        repeat: true
    }

    Item {
        id: clipItem

        clip: true

        // Rectangle {
        //     anchors.fill: parent
        //     color: "blue"
        // }

        height: compRaptorAltimerTiltRoot.height * 0.26
        width: compRaptorAltimerTiltRoot.width

        anchors.centerIn: parent

        Image {
            id: tiltImage

            // Rectangle {
            //     anchors.fill: parent
            //     color: "#800000ff"
            // }

            source: "file:///usr/share/BeaconOS-lib-images/images/Tilt.svg"

            transform: Translate{
                id: tiltImageTranslate

                y: compRaptorAltimerTiltRoot.zero
                onYChanged:{
                    //console.log("yo:: " + tiltImageTranslate.y)
                    //console.log("minY: " + minY + " maxY: " + maxY)
                    if( y <= compRaptorAltimerTiltRoot.minY || y >= compRaptorAltimerTiltRoot.maxY)
                    {
                        behaviourY.enabled = false
                        y = compRaptorAltimerTiltRoot.zero
                        behaviourY.enabled = true
                    }
                }

                //Behavior on y{
                //    id: behaviourY

                //    enabled: true
                //    NumberAnimation{
                //        id: tiltAnimation

                //        duration: 10
                //    }
                //}
            }

        }

        Image {
            id: tiltImageBottom

            source: "file:///usr/share/BeaconOS-lib-images/images/Tilt.svg"

            // Rectangle{
            //     anchors.fill: parent
            //     color: "#80ff0000"
            // }

            anchors.top: tiltImage.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: {
                top: 23
            }

            transform: Translate {
                y: tiltImageTranslate.y - (tiltImage.height * 2)


            }
        }
        Image {
            id: tiltImageTop

            source: "file:///usr/share/BeaconOS-lib-images/images/Tilt.svg"

            // Rectangle{
            //     anchors.fill: parent
            //     color: "#8000ff00"
            // }

            anchors.bottom: tiltImage.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: {
                bottom: 23
            }

            transform: Translate {
                y: tiltImageTranslate.y + (tiltImage.height *2)

            }
        }
    }

}
