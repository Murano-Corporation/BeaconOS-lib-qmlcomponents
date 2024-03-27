import QtQuick 2.12

Item{
    id: screenNetworkingContentControlRoot


    property CompAssetHotParam selectedTechTab

    Component.onCompleted: {
        selectedTechTab = btnWiFi
    }



    property real hotParamSpacing: 21
    property real hotParamWidth: (width * 0.25) - (hotParamSpacing * 2.5)
    property real hotParamHeight: 93

    Item{
        id: rectSelectedTechTabBG
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

    Item{
        id: areaContent

        clip: true

        anchors{
            left: parent.left
            right: parent.right
            top: rectSelectedTechTabBG.bottom
            bottom: parent.bottom
        }

        Rectangle{
            id: rectContentBG
            anchors{
                fill: parent
                topMargin: -rectContentBG.radius
            }

            radius: 24
            color: rectSelectedTechTabBG.color


        }

        Item{
            id: areaTechContent

            anchors{
                fill: rectContentBG
                leftMargin: rectContentBG.radius
                rightMargin: rectContentBG.radius
                bottomMargin: rectContentBG.radius

                topMargin: rectContentBG.radius - rectContentBG.anchors.topMargin
            }
        }

        Loader{
            id: loaderWiFi

            active: screenNetworkingContentControlRoot.selectedTechTab === btnWiFi

            asynchronous:  true
            anchors.fill: areaTechContent
            sourceComponent:         Screen_Networking_Content_Control_Wifi {
                id: screen_Networking_Content_Control_Wifi


            }
        }


    }

}
