import QtQuick 2.0
import QtQuick.Controls 2.12

Screen__BASE {
    id: screenConfigurationRoot

    anchors.fill: parent


    property string selectedDeviceType: ""
    readonly property string selectedDeviceType_Nano: "Nano"

    property real selectedDeviceLabelX: 0
    property real selectDeviceLabelWidth: 900

    Item {
        id: groupTopControls

        width: 1800

        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        height: lblScreenName.height

        CompLabel {
            id: lblScreenName

            anchors{
                top: parent.top
                left: parent.left
            }

            text: "Configuration"
            font.pixelSize: 50
        }
    }

    Rectangle {
        id: contentBG

        anchors{
            top: groupTopControls.bottom
            topMargin: 40
            left: groupTopControls.left
            right: groupTopControls.right
            bottom: parent.bottom
            bottomMargin: 56
        }

        color: "#14818087"
        radius: 17
        Row {
            id: rowAssetTypes

            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.right: parent.right

            height: 42

            spacing: 850

            CompLabel {
                id: lblDelta
                //enabled: hasAnyAssets
                text: qsTr("Delta")
                color: selectedDeviceType === text ? "White" : "#80ffffff"
                font{
                    pixelSize: 35
                }

                function clicked(){
                    selectedDeviceType = text
                    selectedDeviceLabelX = width
                    selectedDeviceLabelX = x
                    console.log("Selected Device Type : " + selectedDeviceType)
                }

                MouseArea {
                    id: mouseareaDelta
                    anchors.fill: parent
                    onClicked: {
                        parent.clicked()
                    }
                }
            }

            CompLabel {
                id: lblNano
                //enabled: hasAnyAssets
                text: qsTr("Nano")
                color: selectedDeviceType === text ? "White" : "#80ffffff"
                font{
                    pixelSize: 35
                }

                function clicked(){
                    selectedDeviceType = text
                    selectedDeviceLabelX = width
                    selectedDeviceLabelX = x
                    //console.log("Selected Device Type : " + selectedDeviceType)
                }

                MouseArea {
                    id: mouseareaNano
                    anchors.fill: parent
                    onClicked: {
                        parent.clicked()
                    }
                }
            }

        }

        Rectangle{
            id: assetUnderscoreBg

            anchors.top: rowAssetTypes.bottom
            anchors.topMargin: 24
            anchors.left: parent.left
            anchors.right: parent.right

            height: 6

            color: "#4D4A5F"


        }

        Rectangle {
            id: assetUnderscoreSelector

            anchors.verticalCenter: assetUnderscoreBg.verticalCenter

            height: 6
            radius: 3
            color: "#80FFFFFF"

            x: (rowAssetTypes.anchors.leftMargin -10) + (selectedDeviceLabelX)
            width: (20) + (selectDeviceLabelWidth)

        }

        Item {
            id: configurationControls

            anchors{
                top: assetUnderscoreBg.bottom
                topMargin: 40
                left: parent.left
                leftMargin: 40
                rightMargin: 40
                right: parent.right
                bottom: parent.bottom
                bottomMargin: 40
            }

            Loader{
                id: loaderView_Nano

                asynchronous: true
                anchors.fill: configurationControls
                active: selectedDeviceType === selectedDeviceType_Nano

                sourceComponent: Screen_Configuration_View_Nano {
                    id: screen_Configuration_View_Nano
                }
            }

        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#000000";formeditorZoom:0.33;height:1080;width:1920}
}
##^##*/
