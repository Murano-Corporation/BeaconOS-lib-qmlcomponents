import QtQuick 2.12

Item {
    id: compAssetInsightsPanel

    CompHealthPanelBg {
    }


    Item {
        id: contents

        anchors{
            fill: parent

            topMargin: 22
            leftMargin: 30
            rightMargin: 30
            bottomMargin: 30
        }

        CompLabel{
            id: lblInsights

            anchors{
                left: parent.left
                leftMargin: 8
                top: parent.top
                right: parent.right
            }

            text: qsTr("Insights")
            color: "White"
            font{
                pixelSize: 25
            }

        }

        Rectangle{
            id: rectSep1
            anchors{
                left: parent.left
                right: parent.right
                top: lblInsights.bottom
                topMargin: 18
            }

            height: 2
            radius: 1

            color: "#33FFFFFF"
        }


        Rectangle {
            radius: 16

            anchors{
                top: rectSep1.bottom
                topMargin: 20
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }

            color: "#30000000"

            Rectangle {
                id: panelNothingToShow
                visible: compAssetAlertsPanel.listOfAlerts.length === 0
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

    }


}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
