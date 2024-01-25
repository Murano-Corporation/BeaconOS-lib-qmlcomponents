import QtQuick 2.12

Item {
    id: compAssetAlertsPanel
    
    property var listOfAlerts: TableModelAlerts //[{"img_path": "file:///usr/share/BeaconOS-lib-images/images/Alert.svg", "title": "Something bad happened"}]
    property string beaconID: ''
    property string assetID: ''

    signal requestVertMaxToggle()
    signal requestHorizMaxToggle()
    signal requestForceFullScreen()

    signal chatWithAiClicked(var alertIndex)

    CompHealthPanelBg {
    }

    Item {
        id: contents

        anchors{
            fill: parent

            topMargin: 22
            rightMargin: 20
            leftMargin: 20
            bottomMargin: 20
        }

        CompLabel{
            id: lblAlerts

            text: qsTr("Alerts")
            color: "White"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            font{
                pixelSize: 24
                weight: Font.Light
            }

        }

        Item{
            id: compViewHistoryBtn

            signal clicked()

            anchors{
                right: parent.right

                verticalCenter: lblAlerts.verticalCenter
            }

            implicitHeight: childrenRect.height
            implicitWidth: childrenRect.width

            CompLabel{
                id: lblViewAlertHistory

                anchors{
                    right: btnViewHistory.left
                    rightMargin: 10

                    verticalCenter: parent.verticalCenter
                }

                text: qsTr("View Alert History")

                color: "#80FFFFFF"

                font{
                    pixelSize: 20
                    weight: Font.Light
                }

                verticalAlignment: "AlignBottom"
            }

            CompIconBtn{
                id: btnViewHistory

                iconUrl: "file:///usr/share/BeaconOS-lib-images/images/RightFill.svg"
                iconColor: "#80FFFFFF"
                iconHeight: 15
                height: 15
                anchors{
                    verticalCenter: lblViewAlertHistory.verticalCenter
                    right: parent.right
                }
            }

            MouseArea{
                anchors{
                    fill: parent
                }

                onClicked: parent.clicked()
            }
        }

        Rectangle {
            id: rectBg_Contents
            radius: 20

            anchors{
                top: lblAlerts.bottom
                topMargin: 20
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            color: compAssetAlertsPanel.listOfAlerts ? compAssetAlertsPanel.listOfAlerts.length > 0 ? 'transparent' : "#30000000" : "#30000000"

            Rectangle {
                id: panelNothingToShow
                visible: compAssetAlertsPanel.listOfAlerts ? compAssetAlertsPanel.listOfAlerts.length === 0 : false
                anchors.centerIn: parent

                radius: 16

                height: 20 +lblNothingToShow.implicitHeight
                width: 40 +lblNothingToShow.implicitWidth

                color: "transparent"

                CompLabel {
                    id: lblNothingToShow

                    anchors.centerIn: parent

                    text: qsTr("Nothing to display")

                    font{
                        pixelSize: 24
                    }
                }
            }
        }

        ListView {
            id: alertsScrollView
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            spacing: 32

            anchors{
                fill: rectBg_Contents
                margins: 10
            }


            model: compAssetAlertsPanel.listOfAlerts

            delegate: CompExpandableBtnBreadcrumb{

                width: parent.width

                //appSourceName: myModelData ? myModelData.appSource : '?'
                titleText: model ? model.title : '?'
                titleIconSource: ''
                contents: model.Parameters.data
                listQuickActions: model.Parameters.responses

                onChatWithAiClicked: {
                    compAssetAlertsPanel.chatWithAiClicked(model)
                }
            }

        }

    }


}



/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:640}
}
##^##*/
