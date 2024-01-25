import QtQuick 2.12
import QtQuick.Controls 2.12

Item{
    id: compDrawerInfo

    property bool isOpen: false
    property real globalOpacity: 1.0
    property bool isChatModeActive: false
    property var targetAlertForChat
    property string beaconID: ''
    property string assetID: ''

    signal cameraBtnClicked()
    signal galleryBtnClicked()
    signal hideBtnClicked()
    signal showBtnClicked()
    signal requestColumnFullsize()
    signal requestScreenFullsize()

    width: 654
    height: 673

    Rectangle {

        visible: compDrawerInfo.isOpen === true

        color: "transparent"

        anchors{
            top: parent.top
            bottom: parent.bottom
            right: parent.left

        }

        width: 40

        CompIconBtn{
            id: btnHide

            anchors{
                centerIn: parent
            }

            width: 32
            height: 32


            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/LeftFill.svg"
            iconColor: "#9287ED"

            onClicked: {
                //console.log("HIDE")
                compDrawerInfo.hideBtnClicked()
            }
        }

        MouseArea{
            anchors.fill: parent
            onClicked: btnHide.clicked()
        }
    }


    Rectangle {
        id: rectShowBtn

        visible: compDrawerInfo.isOpen === false

        anchors{
            top: parent.top
            horizontalCenter: parent.right
            bottom: parent.bottom

        }

        color: "#14818087"

        radius: 17
        z: -100
        width: 128

        CompIconBtn{
            id: btnShow

            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/RightFill.svg"
            iconColor: "#9287ED"
            height: 32
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.horizontalCenter
                right: parent.right
            }

            onClicked: {
                //console.log("Show")
                globalOpacity = 1.0
                compDrawerInfo.showBtnClicked()
            }
        }

        MouseArea{
            anchors.fill: parent

            onClicked: {
                //console.log("Show")
                globalOpacity = 1.0
                compDrawerInfo.showBtnClicked()
            }
        }

    }

    CompAssetAlertsPanel {
        id: compAssetAlertsPanel

        visible: !isChatModeActive

        opacity: globalOpacity
        anchors{
            left: parent.left
            top: parent.top
            right: parent.right

            bottom: compToolsPanel.top
            bottomMargin: 36
        }

        onChatWithAiClicked: function(alertIndex)
        {
            console.log("Chat with AI clicked on index: " + alertIndex)
            compDrawerInfo.targetAlertForChat = alertIndex
            compDrawerInfo.isChatModeActive = true

        }

    }


    CompAssetToolsPanel {
        id: compToolsPanel

        visible: !isChatModeActive

        opacity: globalOpacity
        anchors{
            bottom: parent.bottom
            left: compAssetAlertsPanel.left
            right: compAssetAlertsPanel.right
        }

        onCameraToolBtnClicked: compDrawerInfo.cameraBtnClicked()

        onGalleryToolBtnClicked: compDrawerInfo.galleryBtnClicked()

        height: 134
    }

}

/*##^##
Designer {
    D{i:0;formeditorColor:"#4c4e50";formeditorZoom:0.75}
}
##^##*/
