import QtQuick 2.12

Comp__BASE{
    id: screenNetworkingContentControlRoot

    property CompAssetHotParam selectedTechTab

    property var listOfNetWorkTypes: ListModel{
        ListElement{ key: "Select Network type"; value: -1}
        ListElement{ key: "WiFi"; value: 0}
        ListElement{ key: "LiFi"; value: 1}
        ListElement{ key: "Cellular"; value: 2}
        ListElement{ key: "Satellite"; value: 3}
    }

    property var selectedTab

    property real hotParamSpacing: isDelta ? 21 : 18
    property real hotParamWidth: isDelta ? ((width * 0.25) - (hotParamSpacing * 2.5)) : ((width * 0.25) - (hotParamSpacing))
    property real hotParamHeight: isDelta ? 93 : 130

    Component.onCompleted: {
        if(isDelta)
            selectedTechTab = btnWiFi
        selectedTab = -1
    }

    Item{
        id: rectSelectedTechTabBG
        visible: isDelta
        property alias color: rectBg_Selected.color
        height: rowQuickButtons.height - rowQuickButtons.anchors.topMargin
        width: screenNetworkingContentControlRoot.hotParamWidth + screenNetworkingContentControlRoot.hotParamSpacing
        clip: true


        Rectangle{
            id: rectBg_Selected

            anchors{
                fill: parent
                bottomMargin: -rectBg_Selected.radius
            }



            radius: 24
            color: "#80000000"


        }

        x: {
            if(!screenNetworkingContentControlRoot.selectedTechTab)
            {
                return 0;
            }

            var globalX = screenNetworkingContentControlRoot.selectedTechTab.mapToGlobal(0,0)
            var mappedX = screenNetworkingContentControlRoot.mapFromGlobal(globalX)

            var w = 0 - screenNetworkingContentControlRoot.hotParamSpacing * 0.5
            var ret = (mappedX.x + w)
            //console.log("Mapped X: " + mappedX)
            //console.log("W: " + w)
            //console.log("Ret: " + ret)
            return ret
        }

        Behavior on x{
            NumberAnimation{
                duration: 250
            }
        }
    }

    Row{
        id: rowQuickButtons
        visible: isDelta

        anchors{
            left: parent.left
            leftMargin: screenNetworkingContentControlRoot.hotParamSpacing * 0.5
            top: parent.top
            topMargin: screenNetworkingContentControlRoot.hotParamSpacing * 0.5
            right: parent.right
            rightMargin: screenNetworkingContentControlRoot.hotParamSpacing * 0.5

        }

        height: 117
        spacing: 20

        CompAssetHotParam{
            id: btnWiFi

            displayName: "WIFI"
            value1: "ENABLED"

            width: screenNetworkingContentControlRoot.hotParamWidth

            height: screenNetworkingContentControlRoot.hotParamHeight

            opacity: (screenNetworkingContentControlRoot.selectedTechTab === this ? 1.0 : 0.6)

            MouseArea{
                anchors.fill: parent

                onClicked:{
                    screenNetworkingContentControlRoot.selectedTechTab = parent
                }
            }
        }

        CompAssetHotParam{
            id: btnLiFi

            displayName: "LIFI"
            value1: "DISABLED"

            width: screenNetworkingContentControlRoot.hotParamWidth

            height: screenNetworkingContentControlRoot.hotParamHeight
            opacity: (screenNetworkingContentControlRoot.selectedTechTab === this ? 1.0 : 0.6)
            MouseArea{
                anchors.fill: parent

                onClicked:{
                    screenNetworkingContentControlRoot.selectedTechTab = parent
                }
            }
        }

        CompAssetHotParam{
            id: btnCellular

            displayName: "CELLULAR"
            value1: "DISABLED"
            width: screenNetworkingContentControlRoot.hotParamWidth

            height: screenNetworkingContentControlRoot.hotParamHeight
            opacity: (screenNetworkingContentControlRoot.selectedTechTab === this ? 1.0 : 0.6)
            MouseArea{
                anchors.fill: parent

                onClicked:{
                    screenNetworkingContentControlRoot.selectedTechTab = parent
                }
            }
        }

        CompAssetHotParam{
            id: btnSatellite

            displayName: "SATELLITE"
            value1: "DISABLED"

            width: screenNetworkingContentControlRoot.hotParamWidth

            height: screenNetworkingContentControlRoot.hotParamHeight
            opacity: (screenNetworkingContentControlRoot.selectedTechTab === this ? 1.0 : 0.6)
            MouseArea{
                anchors.fill: parent

                onClicked:{
                    screenNetworkingContentControlRoot.selectedTechTab = parent
                }
            }
        }
    }

    CompCombobox {
        id: comboSelectNetworkType
        visible: !isDelta

        unselectedText: "Select Network Type"
        textRole: "key"
        model: listOfNetWorkTypes

        anchors{
            left: parent.left
            leftMargin: screenNetworkingContentControlRoot.hotParamSpacing * 0.5
            top: parent.top
            topMargin: screenNetworkingContentControlRoot.hotParamSpacing * 0.5
            right: parent.right
            rightMargin: screenNetworkingContentControlRoot.hotParamSpacing * 0.5

        }

        height: 100
        valueFontSize: 50
        optionsHeight: 100

        onCurrentIndexChanged: {
            selectedTab = currentIndex
        }

    }

    Item{
        id: areaContent

        clip: true

        anchors{
            left: parent.left
            right: parent.right
            top: isDelta ? rectSelectedTechTabBG.bottom : comboSelectNetworkType.bottom
            topMargin: isDelta ? 0 : 30
            bottom: parent.bottom
            bottomMargin: isDelta ? 0 : 30
        }

        Rectangle{
            id: rectContentBG

            anchors{
                fill: parent
                topMargin: isDelta ? -rectContentBG.radius : 0
            }

            radius: 24
            color: rectSelectedTechTabBG.color


        }

        Item{
            id: areaTechContent

            anchors{
                fill: rectContentBG
                leftMargin: isDelta ? rectContentBG.radius : 0
                rightMargin: isDelta ? rectContentBG.radius : 0
                bottomMargin: isDelta ? rectContentBG.radius : 0
                topMargin: isDelta ? (rectContentBG.radius - rectContentBG.anchors.topMargin) : 0
            }
        }

        Loader{
            id: loaderWiFi

            active: screenNetworkingContentControlRoot.selectedTechTab === btnWiFi || screenNetworkingContentControlRoot.selectedTab === 1

            asynchronous:  true
            anchors.fill: areaTechContent
            sourceComponent: Screen_Networking_Content_Control_Wifi {
                id: screen_Networking_Content_Control_Wifi
            }
        }


    }

}
