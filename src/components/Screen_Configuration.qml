import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Screen__BASE {
    id: screenConfigurationRoot

    anchors.fill: parent

    property string selectedDeviceType: isDelta ? selectedDeviceType_Delta : selectedDeviceType_Omega
    readonly property string selectedDeviceType_Delta: "Delta"
    readonly property string selectedDeviceType_Omega: "Omega"
    readonly property string selectedDeviceType_Nano: "Nano"
    readonly property string selectedDeviceType_Raptor_Drone: "Raptor: Drone"
    readonly property string selectedDeviceType_Raptor_Detect: "Raptor: Detect"
    readonly property string selectedDeviceType_Raptor_Defend: "Raptor: Defense"
    readonly property bool isDelta_Now: isDelta;
    readonly property bool isNotDelta_Now: !isDelta;
    //property bool whichDevice: isDelta

    property CompLabel selectedLabel: CompLabel{}
    onSelectedLabelChanged: {
        selectedDeviceType = selectedLabel.text
        selectedDeviceLabelX = selectedLabel.x
    }
    property real selectedDeviceLabelX: 0
    property real selectDeviceLabelWidth: isDelta ? 900 : 450

    Item {
        id: groupTopControls

        width: isDelta ? 1800 : 1000

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

        Rectangle{
            id: assetUnderscoreBg

            anchors.top: rowAssetTypes.bottom
            anchors.topMargin: -16
            anchors.left: parent.left
            anchors.right: parent.right

            height: 6

            color: "#4D4A5F"


        }

        ListView {
            id: rowAssetTypes

            property int labelWidth:{
                var ret;

                if( rowAssetTypes.count >= 4 )
                {
                    ret = rowAssetTypes.width / 4
                } else {
                    ret = rowAssetTypes.width / rowAssetTypes.count
                }

                return ret;
            }

            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.right: parent.right

            height: isDelta ? 62 : 62
            clip: true
            orientation: Qt.Horizontal

            model: [
                {
                    name: selectedDeviceType_Delta,
                    is_visible: screenConfigurationRoot.isDelta
                },
                {
                    name: selectedDeviceType_Omega,
                    is_visible: !screenConfigurationRoot.isDelta
                },
                {
                    name: selectedDeviceType_Nano,
                    is_visible: true
                },
                {
                    name: selectedDeviceType_Raptor_Drone,
                    is_visible: Applications.isAppEnabled("Raptor")
                },
                {
                    name: selectedDeviceType_Raptor_Detect,
                    is_visible: Applications.isAppEnabled("Raptor")
                },
                {
                    name: selectedDeviceType_Raptor_Defend,
                    is_visible: Applications.isAppEnabled("Raptor")
                }
            ]

            delegate: CompLabel {

                visible: modelData.is_visible
                text: modelData.name
                color: screenConfigurationRoot.selectedDeviceType === text ? "White" : "#80ffffff"

                //Layout.fillWidth: true
                width: visible ? rowAssetTypes.labelWidth : 0

                //Rectangle{
                //    anchors.fill: parent
                //    border{
                //        color: "black"
                //        width: 2
                //    }
                //}

                font{
                    pixelSize: 35
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        rowAssetTypes.currentIndex = index
                        screenConfigurationRoot.selectedLabel = parent
                    }
                }
            }

            highlightMoveDuration: 100
            highlight: Item {
                id: assetUnderscoreSelector

                Rectangle{
                    x: -10

                    anchors{
                        top: parent.bottom
                        topMargin: 10
                    }

                    height: 6
                    radius: 3
                    color: "#80FFFFFF"

                    width: (20) + (fontMx_UnderscoreSelect.boundingRect(selectedDeviceType).width) + 20

                    Behavior on width{
                        NumberAnimation{
                            duration: 250
                        }
                    }

                    FontMetrics{
                        id: fontMx_UnderscoreSelect
                        font: selectedLabel.font

                    }

                }



                //Behavior on x{
                //    NumberAnimation{
                //        duration: 100
                //    }
                //}


            }

            highlightFollowsCurrentItem: true
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
                id: loaderView_Delta

                asynchronous: true
                anchors.fill: configurationControls
                active: selectedDeviceType === selectedDeviceType_Delta

                sourceComponent: Screen_Configuration_View_Delta {
                    id: screen_Configuration_View_Delta
                }
            }

            Loader{
                id: loaderView_Omega

                asynchronous: true
                anchors.fill: configurationControls
                active: selectedDeviceType === selectedDeviceType_Omega

                sourceComponent: Screen_Configuration_View_Omega {
                    id: screen_Configuration_View_Omega
                }
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

            Loader{
                id: loaderView_Drone

                enabled: Applications.isAppEnabled("Raptor")

                asynchronous: true
                anchors.fill: configurationControls
                active: selectedDeviceType === selectedDeviceType_Raptor_Drone

                sourceComponent: Screen_Configuration_View_Drone {
                    id: screen_Configuration_View_Drone
                }
            }

            Loader{
                id: loaderView_Raptor_Detection

                enabled: Applications.isAppEnabled("Raptor")

                asynchronous: true
                anchors.fill: configurationControls
                active: selectedDeviceType === selectedDeviceType_Raptor_Detect

                sourceComponent: Screen_Configuration_View_Raptor_Detect {
                    id: screen_Configuration_View_Raptor_Detect
                }
            }

            Loader{
                id: loaderView_Raptor_Defend

                enabled: Applications.isAppEnabled("Raptor")

                asynchronous: true
                anchors.fill: configurationControls
                active: selectedDeviceType === selectedDeviceType_Raptor_Defend

                sourceComponent: Screen_Configuration_View_Raptor_Defend {
                    id: screen_Configuration_View_Raptor_Defend
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
