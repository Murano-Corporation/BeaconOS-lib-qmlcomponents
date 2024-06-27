import QtQuick 2.15

Rectangle {
    id: compRaptorAltimeterRollRoot

    property real roll: 0

    height: 653
    width: 653
    //border.color: "lightgreen"
    color: "transparent"
    radius: 360

    Component.onCompleted: {roll = 2160
    }

    Item {
        id: clipItem

        clip: true

        height: compRaptorAltimeterRollRoot.height * 0.2
        width: compRaptorAltimeterRollRoot.width

        Image {
            id: rollImage

            //z: 0

            source: "file:///usr/share/BeaconOS-lib-images/images/Rollroll.svg"
            transform: Rotation{
                id: rollImageRot

                origin.x: rollImage.width * 0.5
                origin.y: rollImage.height * 0.5
                angle: compRaptorAltimeterRollRoot.roll

                Behavior on angle{
                    NumberAnimation{
                        duration: 60000
                    }
                }
            }
        }
    }

}
