import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import QtQml 2.12

Drawer{
    id: drawerSystem

    property var listOfNotifications
    property bool isChatModeActive: false
    property var targetAlertForChat
    property real globalOpacity: 1.0

    signal chatWithAiClicked(var alertIndex)

    dragMargin: 60
    edge: Qt.TopEdge

    height: parent.height
    width: parent.width

    background: Rectangle{
        opacity: 0.5 * drawerSystem.position
        color: "#000000"
    }

    function systemButtonClicked(){
        close()
    }

    Connections{
        target: SingletonScreenManager

        function onSignal_StartupInitializationComplete() {

            console.log("Binding TableModel")

            drawerSystem.listOfNotifications = Qt.binding( function(){ return TableModelAlerts; })

        }
    }

    Connections {
        target: Actions

        function onSignal_Request_StartAIChat(mapData){
            //console.log("Closing the drawer system")
            drawerSystem.close();
        }
    }

    Item{
        id: mapItem

        anchors.fill: parent

        function mapRect(){
            return mapToItem(Overlay.overlay, groupSystemControls.x, groupSystemControls.y)
        }
    }

    Item{
        id: contents

        clip: true

        anchors{
            fill: parent
            top: parent.top
            left: parent.left
            leftMargin: 50
            right: parent.right
            rightMargin: 50
            bottom: parent.bottom
            bottomMargin: 50
        }

        Rectangle{
            id: rectBg

            color: "#162231"
            //radius: 60
            anchors{
                fill: parent
                //topMargin: -60
            }
        }

        Item{
            id: innerContents

            anchors{
                fill: parent
                margins: 60
            }
        }

        Item{
            id: groupTopElements

            anchors{
                top: innerContents.top
                left: innerContents.left
                right: innerContents.right
            }

            height: 46

            CompImageIcon{
                id: iconWifi

                anchors{
                    top: parent.top
                    left: parent.left
                    bottom: parent.bottom
                }

                width: height

                source: "file:///usr/share/BeaconOS-lib-images/images/WiFi.svg"
                color: "white"

            }

            CompImageIcon{
                id: icon5G

                anchors{
                    top: parent.top
                    left: iconWifi.right
                    leftMargin: 20
                    bottom: parent.bottom
                }

                width: height

                source: "file:///usr/share/BeaconOS-lib-images/images/5G.svg"
                color: "white"
            }

            CompLabel{
                id: lblBattPercent

                anchors{
                    right: iconBattery.left
                    rightMargin: 16
                    top: parent.top
                    bottom: parent.bottom
                }

                text: "99%"

                font{
                    pixelSize: 38
                }

                horizontalAlignment: Text.AlignRight
            }

            CompImageIcon{
                id: iconBattery

                anchors{
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                }

                width: 75

                source: "file:///usr/share/BeaconOS-lib-images/images/Battery100_All.svg"
                color: "white"
                //iconFillMode: Image.PreserveAspectCrop
            }

        }

        Rectangle{
            id: groupSystemControls

            onWidthChanged: {
                setOverlayDefaults()
            }

            function setOverlayDefaults(){

                var var_width = groupSystemControls.width
                var var_point = mapItem.mapRect();
                console.log("Var width = "+var_width)
                console.log("Var point = "+var_point)
                var openSize = Qt.size(var_width,1300)
                var openOrigin = Qt.point(var_point.x + contents.anchors.leftMargin-11, 510)
                SingletonOverlayManager.setPerScreenPopupOpenRect("NSN Viewer", openOrigin, openSize);
                SingletonOverlayManager.setPerScreenPopupOpenRect("WiFi Viewer", openOrigin, openSize);
                var openSizeSettings = Qt.size(1080, 1920)
                var openOriginSettings = Qt.point(0,0)
                SingletonOverlayManager.setPerScreenPopupOpenRect("Settings", openOriginSettings, openSizeSettings)
            }

            anchors{
                left: innerContents.left
                right: innerContents.right
                top: groupTopElements.bottom
                topMargin: 85
            }

            height: 270

            color: "#80253143"
            radius: 50

            Row{
                id: rowBtns
                anchors{
                    fill: parent
                    leftMargin: 80
                    rightMargin: 80
                    topMargin: 40
                    bottomMargin: 40
                }
                spacing: 66
                Repeater{

                    model: [
                        {"iconPath":"file:///usr/share/BeaconOS-lib-images/images/WiFi.svg", "name": "WiFi"},
                        {"iconPath":"file:///usr/share/BeaconOS-lib-images/images/Gear.svg", "name": "Settings"},
                        {"iconPath":"file:///usr/share/BeaconOS-lib-images/images/Power.svg", "name": "Logout"}
                    ]

                    CompIconBtnRound {
                        id: btnRoot

                        anchors{
                            verticalCenter: parent.verticalCenter
                        }

                        height: rowBtns.height

                        icon.source: modelData.iconPath
                        width: height

                        onClicked: {
                            if (modelData.name === "WiFi"){
                                console.log("GOING TO NETWORKING SCREEN");
                                //screenToLoad = "Networking";
                                loaderPopupWiFiViewer.active = true;
                            } else if(modelData.name === "Logout"){
                                //console.log("Opening popupPowerOptions")
                                popupPowerOptions.open()
                            }else if(modelData.name === "Settings"){
                                drawerSystem.close()
                                loaderSettings.active = true;
                            }
                        }
                    }

                }
            }
//            MouseArea {
//                anchors.fill: parent
//                onClicked: {
//                    console.log("Going to networking screen");
//                    //screenToLoad = "Networking"
//                }
//            }
        }

        Rectangle {
            id: panelNothingToShow
            visible: drawerSystem.listOfNotifications ? drawerSystem.listOfNotifications.length === 0 : false
            anchors.centerIn: parent

            radius: 16

            height: 20 +lblNothingToShow.implicitHeight
            width: 40 +lblNothingToShow.implicitWidth

            color: "transparent"

            CompLabel {
                id: lblNothingToShow

                anchors.centerIn: parent

                text: qsTr("No Notifications")

                font{
                    pixelSize: 24
                }
            }
        }

        ListView {
            id: alertsScrollView
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            visible: count > 0

            spacing: 32

            anchors{
                left: innerContents.left
                right: innerContents.right
                top: groupSystemControls.bottom
                topMargin: 60
                bottom: parent.bottom
                bottomMargin: 30
            }


            model: drawerSystem.listOfNotifications

            delegate: CompExpandableBtnBreadcrumb{

                width: parent.width
                minimumHeight: 100
                maxExpandableHeight: 440

                labelMain.font.pixelSize: 40
                labelLink.font.pixelSize: 30
                titleText: model ? model.title : '?'
                titleIconSource: ''
                contents: model.data
                listQuickActions: model.Parameters.responses

            }

        }

        Popup {
            id: popupPowerOptions
            height: colContents.implicitHeight + 30
            width: colContents.implicitWidth + 40

            x: rowBtns.x + (2.25*width)
            y: rowBtns.y + (2.01*rowBtns.height)

            background: Rectangle{
                color: "#DFDFDF"

                radius: 16
            }

            Column{
                id: colContents
                spacing: 10
                CompButton{
                    id: btnOptionLogout

                    text: qsTr("Logout")

                    height: 100
                    font.pixelSize: 35

                    onClicked: {
                        Actions.signal_Request_Logout()
                        popupPowerOptions.close()
                        drawerSystem.close()
                    }
                }

                CompButton{
                    id: btnOptionPowerOff

                    text: qsTr("Power Off");

                    height: 100
                    font.pixelSize: 35

                    onClicked: {
                        Actions.signal_Request_Shutdown()
                        popupPowerOptions.close()
                        drawerSystem.close();
                    }
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorColor:"#4c4e50";formeditorZoom:0.2;height:1920;width:1080}
}
##^##*/
