import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import QtQml 2.12

Item{
    id: compDrawerHandle

    property bool isFlipped: true

    signal clicked()

    anchors{
        horizontalCenter: parent.horizontalCenter
    }

    width: 610
    height: 70

    states: [
        State {
            name: "normal"
            when: isFlipped
            PropertyChanges {
                target: imgRot
                angle: 0

            }
        },
        State{
            name: "flipped"
            when: !isFlipped
            PropertyChanges {
                target: imgRot
                angle: 180

            }
        }
    ]

    CompImageIcon{
        anchors{
            fill: parent
        }

        source: "file:///usr/share/BeaconOS-lib-images/images/Omega_TopDrawerHandle.png"

        transform: Rotation{
            id: imgRot
            origin{
                x: compDrawerHandle.width * 0.5
                y: compDrawerHandle.height * 0.5
            }

            angle: 180
        }
    }

    MouseArea{
        anchors{
            fill: parent
        }

        onClicked: {
            parent.clicked()
        }
    }

}

/*##^##
Designer {
    D{i:0;formeditorColor:"#000000";formeditorZoom:0.2;height:1920;width:1080}
}
##^##*/
