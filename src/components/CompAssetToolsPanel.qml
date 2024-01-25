import QtQuick 2.12

Item {

    id: compAssetToolsPanelRoot
    property real btnHeight: 94
    property real btnWidth: 94
    property size iconSize: Qt.size(50,50)

    property real spacing: 64
    signal cameraToolBtnClicked()
    signal galleryToolBtnClicked()
    signal microphoneToolBtnClicked()
    signal maintenanceToolBtnClicked()

    CompHealthPanelBg {
    }


    Item {
        id: rowButtons

        anchors{
            centerIn: parent
        }

        height: btnHeight
        width:btnMaintenance.x + btnWidth

        CompIconBtnRound {
            id: btnCamera

            anchors{
                top: parent.top
                left: parent.left
            }

            icon.source: "file:///usr/share/BeaconOS-lib-images/images/Camera.svg"
            icon.height: compAssetToolsPanelRoot.iconSize.height
            icon.width: compAssetToolsPanelRoot.iconSize.width
            height: compAssetToolsPanelRoot.btnHeight
            width: compAssetToolsPanelRoot.btnWidth

            onClicked: {
                compAssetToolsPanelRoot.cameraToolBtnClicked()
            }

        }

        CompIconBtnRound {
            id: btnGallery

            anchors{
                top: btnCamera.top
                left: btnCamera.right
                leftMargin: compAssetToolsPanelRoot.spacing
            }

            icon.source: "file:///usr/share/BeaconOS-lib-images/images/Gallery.svg"
            icon.height: btnCamera.icon.height
            icon.width: btnCamera.icon.height

            height: compAssetToolsPanelRoot.btnHeight
            width: compAssetToolsPanelRoot.btnWidth

            onClicked: {
                compAssetToolsPanelRoot.galleryToolBtnClicked()
            }

        }

        CompIconBtnRound {
            id: btnMicrophone

            enabled: false

            anchors{
                top: btnGallery.top
                left: btnGallery.right
                leftMargin: compAssetToolsPanelRoot.spacing
            }

            icon.source: "file:///usr/share/BeaconOS-lib-images/images/Microphone.svg"
            icon.height: btnCamera.icon.height
            icon.width: btnCamera.icon.height

            height: compAssetToolsPanelRoot.btnHeight
            width: compAssetToolsPanelRoot.btnWidth

            onClicked: {
                compAssetToolsPanelRoot.microphoneToolBtnClicked()
            }

        }

        CompIconBtnRound {
            id: btnMaintenance

            enabled: false

            anchors{
                top: btnMicrophone.top
                left: btnMicrophone.right
                leftMargin: compAssetToolsPanelRoot.spacing
            }

            icon.source: "file:///usr/share/BeaconOS-lib-images/images/MaintenanceCalendar.svg"
            icon.height: btnCamera.icon.height
            icon.width: btnCamera.icon.height

            height: compAssetToolsPanelRoot.btnHeight
            width: compAssetToolsPanelRoot.btnWidth

            onClicked: {
                compAssetToolsPanelRoot.maintenanceToolBtnClicked()
            }

        }
    }


}
