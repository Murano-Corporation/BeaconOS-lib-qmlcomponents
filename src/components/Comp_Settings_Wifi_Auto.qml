import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.15

Item{
    id: comp_Settings_Wifi_Auto

    property CompBtnBreadcrumb selectedSubTab

    property real itemSpacingVertical: 24
    property bool isOk: true

    property point globalSelectedSubTab
    property point localSelectedSubTab

    property real minimumWidth: 600
    property real minimumHeight: 300


    onSelectedSubTabChanged: {
        if(!selectedSubTab)
            return

        screenNetworkingContentControlWifi.globalSelectedSubTab = selectedSubTab.mapToGlobal(0,0)
    }

    onGlobalSelectedSubTabChanged: {
        screenNetworkingContentControlWifi.localSelectedSubTab = screenNetworkingContentControlWifi.mapFromGlobal(screenNetworkingContentControlWifi.globalSelectedSubTab)
    }

    Component.onCompleted: {
        screenNetworkingContentControlWifi.selectedSubTab = isDelta ? btnAuto : btnAutoOmega
    }
    CompResizableMoveableContainer{
        id: contentsRoot

        minimumHeight: screenNetworkingContentControlWifi.minimumHeight
        minimumWidth: screenNetworkingContentControlWifi.minimumWidth


        Component.onCompleted:{
            var startOrigin = SingletonOverlayManager.getPopupOrigin("WiFi Viewer")
            var startSize = SingletonOverlayManager.getPopupSize("WiFi Viewer")

            console.log("Setting start size to: " + startSize)
            console.log("Setting start origin to: " + startOrigin);

            contentsRoot.x = startOrigin.x
            contentsRoot.y = startOrigin.y
            contentsRoot.width = startSize.width
            contentsRoot.height = startSize.height
        }

        CompPopupBG{
            id: rectBG

            anchors{
                fill: parent
            }

        }



        Item{
            id: areaContent

            anchors{
                top: column.bottom
                topMargin: screenNetworkingContentControlWifi.itemSpacingVertical
                left: column.left
                right: column.right
                bottom: parent.bottom
                bottomMargin: 50
            }

        }

        Loader{
            id: loaderManual

            asynchronous: true
            active: screenNetworkingContentControlWifi.selectedSubTab === btnManual || screenNetworkingContentControlWifi.selectedSubTab === btnManualOmega
            anchors.fill: areaContent

        }

        Loader{
            id: loaderAuto
            active: screenNetworkingContentControlWifi.selectedSubTab === btnAuto || screenNetworkingContentControlWifi.selectedSubTab === btnAutoOmega
            asynchronous: true
            anchors.fill: areaContent

            sourceComponent: Screen_Networking_Content_Control_Wifi_Auto {

            }
        }
    }
}
