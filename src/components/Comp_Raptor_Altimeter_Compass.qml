import QtQuick 2.15

Rectangle {
    id: compRaptorAltimeterCompassRoot

    height: 98
    width: 848
    color: "transparent"

    property real zero: 0

    property real minX: zero - compassImage.width + 4
    property real maxX: zero + compassImage.width - 4

    property real angle: 0.00

    onAngleChanged: {


        compassImageTranslate.x = angle
    }

    // Component.onCompleted: {
    // timter.start()
    // }

    Timer {
        id: timter
        interval: 50
        onTriggered: {
            compassImageTranslate.x -= 500
        }
        repeat: true
    }

    // Rectangle {
    //     height: 98
    //     width: 848

    //     color: "purple"

    //     anchors.centerIn: parent
    // }
    Item {
        id: clipItem

        clip: enabled

        height: compRaptorAltimeterCompassRoot.height
        width: compRaptorAltimeterCompassRoot.width * 0.26

        // Rectangle{
        //     anchors.fill: parent
        //     color: "grey"
        // }

        anchors.centerIn: parent

        Image {
            id: compassImage
            //z: 0

            // Rectangle {
            //     anchors.fill: parent
            //     color: "#800000ff"
            // }

            source: "file:///usr/share/BeaconOS-lib-images/images/Compass.svg"

            transform: Translate{
                id: compassImageTranslate

                x: compRaptorAltimeterCompassRoot.zero

                onXChanged:{
                    ///console.log("yo:: " + compassImageTranslate.x)
                    ///console.log("minX: " + minX + " maxX: " + maxX)
                    if( x <= compRaptorAltimeterCompassRoot.minX || x >= compRaptorAltimeterCompassRoot.maxX)
                    {
                        behaviourX.enabled = false
                        x = compRaptorAltimeterCompassRoot.zero
                        behaviourX.enabled = true
                    }
                }

                //Behavior on x {
                //    id: behaviourX

                //    enabled: true
                //    NumberAnimation{
                //        id: compassAnimation

                //        duration: 10
                //    }
                //}
            }
        }
        Image {
            id: compassImageLeft
            //z: 0

            source: "file:///usr/share/BeaconOS-lib-images/images/Compass.svg"

            // Rectangle{
            //     anchors.fill: parent
            //     color: "green"
            // }

            anchors.right: compassImage.left
            anchors.verticalCenter: compassImage.verticalCenter
            anchors.margins: {
                right: 4
            }

            transform: Translate {
                x: compassImageTranslate.x + (compassImage.width * 2)
            }
        }
        Image {
            id: compassImageRight
            //z: 0

            source: "file:///usr/share/BeaconOS-lib-images/images/Compass.svg"

            // Rectangle{
            //     anchors.fill: parent
            //     color: "#80ff0000"
            // }

            anchors.left: compassImage.right
            anchors.verticalCenter: compassImage.verticalCenter
            anchors.margins: {
                left: 4
            }

            transform: Translate {
                x: compassImageTranslate.x - (compassImage.width * 2)
            }
        }
    }

}
