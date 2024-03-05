import QtQuick 2.12
import QtQuick.Controls 2.12

Popup {
    id: popupHelpRoot

    width: root.contentItem.width
    height: root.contentItem.height

    anchors{
        centerIn: Overlay.overlay
    }

    background: Rectangle{
        color: "#80000000"
    }

    CompHealthPanelBg{
        id: rectBG

        radius: 17

        anchors{
            fill: parent

            topMargin: 64
            leftMargin: 40
            rightMargin: 40
            bottomMargin: 64
        }

        Column{
            id: colContents

            anchors{
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: btnClose.top

                margins: 40
            }

            spacing: 40

            CompImageIcon{
                height: 64
                width: 64
                color: "white"

                source: "file:///usr/share/BeaconOS-lib-images/images/Help.svg"

                anchors.horizontalCenter: parent.horizontalCenter
            }

            CompBtnBreadcrumb{
                id: btnSupport

                width: parent.width
                height: 112
                text: "Contact Support"
            }

            CompBtnBreadcrumb{
                id: btnTutorials

                width: parent.width
                height: btnSupport.height
                text: "Walk-through Tutorials"
            }

            CompBtnBreadcrumb{
                id: btnFAQ

                width: parent.width
                height: btnSupport.height
                text: "FAQ"
            }
        }


        CompBtnBreadcrumb{
            id: btnClose

            anchors{
                bottom: parent.bottom
                right: parent.right
                margins: 40
            }

            text: "Close"
        }
    }

}

/*##^##
Designer {
    D{i:0;formeditorColor:"#4c4e50";formeditorZoom:0.33;height:1080;width:1920}
}
##^##*/
