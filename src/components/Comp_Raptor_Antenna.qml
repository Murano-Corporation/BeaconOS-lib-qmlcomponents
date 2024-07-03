import QtQuick 2.15
import Qt.labs.qmlmodels 1.0


Comp__BASE {
    id: comp_Raptor_Antenna

    Component.onCompleted: {
        RaptorAntenna.connectAntenna("10.2.18.70", 12345)
    }

    Component.onDestruction: {
        RaptorAntenna.disconnectAntenna("10.2.18.70")
    }

    Image {
        id: imgCameraFeed

        property int frameIndex: -1

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right

        }

        height: parent.height - comp_Terminal.height

        fillMode: Image.PreserveAspectFit
        smooth: true
        source: "image://antenna/current-" + frameIndex
        //onSourceChanged: {
        //    console.log("provider source is now: " + source)
        //}

        cache: false

        Timer{
            running: true
            interval: 10
            repeat: true

            onTriggered: {
                parent.frameIndex *= -1
            }
        }
    }

    Comp_Terminal {
        id: comp_Terminal

        anchors{
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: 90

    }
}
