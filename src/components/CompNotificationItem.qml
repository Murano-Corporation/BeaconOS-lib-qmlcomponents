import QtQuick 2.12
import QtQuick.Controls 2.12


Button {
    id: compNotificationItemRoot

    height: 60

    property string appSourceName: "Predict"
    property string message: "3 New Insights"

    text: compNotificationItemRoot.message

    contentItem: Item{
        anchors.fill: parent
        CompImageIcon {
            id: iconPred
            visible: compNotificationItemRoot.appSourceName === "Predict"
            color: "White"
            source: "file:///usr/share/BeaconOS-lib-images/images/PredictFill.svg"
            iconHeight: 30
            iconWidth: 30

            anchors{
                left: parent.left
                leftMargin: 28
                top: parent.top
                bottom: parent.bottom
            }

        }

        CompImageIcon {
            id: iconMsg
            visible: compNotificationItemRoot.appSourceName === "Messages"
            color: "White"
            source: "file:///usr/share/BeaconOS-lib-images/images/MessageFill.svg"
            iconHeight: 30
            iconWidth: 30

            anchors{
                left: parent.left
                leftMargin: 28
                top: parent.top
                bottom: parent.bottom
            }

        }

        CompImageIcon {
            id: iconRef
            visible: compNotificationItemRoot.appSourceName === "Reference"
            color: "White"
            source: "file:///usr/share/BeaconOS-lib-images/images/ReferenceFill.svg"
            iconHeight: 30
            iconWidth: 30

            anchors{
                left: parent.left
                leftMargin: 28
                top: parent.top
                bottom: parent.bottom
            }

        }

        CompImageIcon {
            id: iconRep
            visible: compNotificationItemRoot.appSourceName === "Repair"
            color: "White"
            source: "file:///usr/share/BeaconOS-lib-images/images/RepairFill.svg"
            iconHeight: 30
            iconWidth: 30

            anchors{
                left: parent.left
                leftMargin: 28
                top: parent.top
                bottom: parent.bottom
            }

        }

        CompLabel{
            text: compNotificationItemRoot.text
            color: "White"
            font{
                pixelSize: 28
                weight: Font.Light
            }

            anchors{
                left: iconPred.right
                leftMargin: 23
                verticalCenter: parent.verticalCenter
            }
        }
    }



    background: CompRoundGlassBG {
        anchors.fill: parent
    }
}
