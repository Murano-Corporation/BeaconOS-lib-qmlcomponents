import QtQuick 2.12

Screen__BASE {
    id: screenHomeRoot
    anchors.fill: parent

    screenName: "Home"

    Component.onCompleted:{
        TableModelApplications.slot_RefreshListOfApplications()
        MqttTopic_notifyOS.slot_Subscribe()

        //Applications.setApplicationInfo("Induct", {sName: "Jimmy", sNavPath: "none", sAppId: "20", sIconPath: "", bEnabled: false})
    }

    function setOverlayDefaults(){
        var openSize = Qt.size(400,300)
        var openOrigin = Qt.point(((root.contentItem.width * 0.5) - openSize.width), ((root.contentItem.height * 0.5) - openSize.height))

        SingletonOverlayManager.setPerScreenPopupOpenRect("Chat AI", openOrigin, openSize);

        openSize = Qt.size(600, 300)
        SingletonOverlayManager.setPerScreenPopupOpenRect("NSN Viewer", openOrigin, openSize);

        openSize = Qt.size(1920,1080)
        openOrigin = Qt.point(0, 0)
        SingletonOverlayManager.setPerScreenPopupOpenRect("WiFi Viewer", openOrigin, openSize);
    }



    Item {
        id: stretchyCenter

        height: isDelta ? 1080 : 1920
        width: isDelta ? 1920 : 1080

        anchors{
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        CompInfoPanel {
            id: compInfoPanel

            anchors{
                left: parent.left
                leftMargin: isDelta ? 124 : 40
                right: isDelta ? undefined : parent.right
                rightMargin: isDelta ? 0 : 20
                top: parent.top
                topMargin: isDelta ? 212 : 150
            }
        }

        CompNotificationsPanel {
            id: compNotificationsPanel
            visible: isDelta

            anchors{
                left: compInfoPanel.left
                top: compInfoPanel.bottom
                right: compInfoPanel.right
                topMargin: 20
            }
        }


//        //TextEdit{
//        //    id: textDEV1

//        //    height: 40
//        //    width: 400

//        //    anchors{
//        //        left: parent.left
//        //        bottom: textDEV2.top
//        //        bottomMargin: 200
//        //    }
//        //}Asset

//        //TextEdit{
//        //    id: textDEV2

//        //    height: 40
//        //    width: 400

//        //    anchors{
//        //        left: parent.left
//        //        bottom: parent.bottom
//        //    }
//        //}

        GridView{
            id: compHomeNavBtnGrid

            clip: true

            anchors{
                left: isDelta ? compNotificationsPanel.right : compInfoPanel.left
                leftMargin: isDelta ? 124 : 75
                top: isDelta ? compInfoPanel.top : compInfoPanel.bottom
                topMargin: isDelta ? 0 : 100
                right: isDelta ? parent.right : compInfoPanel.right
                rightMargin: isDelta ? 124 : 0
                bottom: parent.bottom
                bottomMargin: isDelta ? 124 : 0
            }

            cellHeight: isDelta ? (height / 3) : (height * 0.8 / 4)
            cellWidth: isDelta ? (width / 4) : (width / 3)

            //onCellHeightChanged: console.log('Cell height now: ' + cellHeight)

            model: TableModelApplications
            onModelChanged:{
                TableModelApplications.sort(0)
            }

            delegate: CompHomeNavBtn {
                id: btnHealth

                name: model.app_display_name
                pathName: model.app_nav_path
                iconPath: model.app_icon_path
                enabled: model.is_enabled

            }
        }

    }

}
