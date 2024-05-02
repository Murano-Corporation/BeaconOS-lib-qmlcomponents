import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQml 2.12
//import Qt.labs.qmlmodels 1.0

Drawer {

    id: drawerAssetDashboardMenu
    width: parent.width
    height: parent.height

    property string currentScreen: ""

    signal itemClicked(string viewName)

    Timer {
        id: tmrCloseDelay

        interval: 100
        onTriggered: {
            drawerAssetDashboardMenu.close()
        }
    }

    Rectangle {
        anchors {
            fill: parent
        }
        color: "#031125"
    }

    CompIconBtn {

        id: btnClose
        anchors {
            top: parent.top
            left: parent.left
            topMargin: 150
            leftMargin: 66
        }

        height: 100
        width: 100
        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/LeftFill.svg"
        iconColor: "White"

        onClicked: {
            drawerAssetDashboardMenu.close()
        }
    }

    CompLabel {
        id: lblTitle

        text: "Health Dashboard"
        font {
            pixelSize: 58
            weight: Font.Light
        }
        color: "White"
        anchors {
            left: btnClose.left
            top: btnClose.bottom
            topMargin: 92
        }
    }

Item {
    anchors {
        top: lblTitle.bottom
        left: lblTitle.left
        topMargin: 90
        right: parent.right
        rightMargin: 66
        bottom: parent.bottom
        bottomMargin: 95
    }

    Rectangle {
        anchors {
            fill: parent
        }
        color: "#3C3F65"

}
    GridView {

        id: groupNavButtons
        anchors {
            top: parent.top
            leftMargin: 45
            left: parent.left
            topMargin: 75
            right: parent.right
            //rightMargin: 66
            bottom: parent.bottom
            bottomMargin: 65
        }
        //spacing: 106

        clip: true

        //        cellWidth: compHealthDashboardContentParams.targetData === 'params' ? 400 : (387 + cellPadding)
        //        cellHeight: compHealthDashboardContentParams.targetData === 'params' ? 400 : (375 + cellPadding)
        cellHeight: 300
        cellWidth: width

        model: [
            ["file:///usr/share/BeaconOS-lib-images/images/Asset.svg", "Asset Information", "file:///usr/share/BeaconOS-lib-images/images/AssetFill.svg"],
            ["file:///usr/share/BeaconOS-lib-images/images/Lightning.svg", "Quick Look", "file:///usr/share/BeaconOS-lib-images/images/LightningFill.svg"],
            ["file:///usr/share/BeaconOS-lib-images/images/Predict.svg", "Computer Vision", "file:///usr/share/BeaconOS-lib-images/images/PredictFill.svg"],
            ["file:///usr/share/BeaconOS-lib-images/images/Health.svg", "Live Data", "file:///usr/share/BeaconOS-lib-images/images/HealthFill.svg"]
        ]

        delegate: Item {
            id: delRoot

            height: groupNavButtons.cellHeight - 50
            width: (groupNavButtons.cellWidth - 50)
            //anchors.rightMargin: 50
            CompGlassRect{
                anchors.fill: parent
                CompImageIcon {
                    id: iconMenu
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                        leftMargin: 50
                    }
                    width: 120
                    height: 120
                    source: drawerAssetDashboardMenu.currentScreen === modelData[1] ? modelData[2] : modelData[0]
                    color: "White"
                }
                CompLabel {
                    anchors {
//                        top: iconMenu.top
//                        bottom: iconMenu.bottom
                        verticalCenter: iconMenu.verticalCenter
                        left: iconMenu.right
                        //right: parent.right
                        leftMargin: 30
                    }

                    text: modelData[1]
                    font {
                        pixelSize: 40
                    }
                }
            }

            CompIconBtn{
                id: btnRightArrow

                //visible: false

                height: 55
                iconUrl: "file:///usr/share/BeaconOS-lib-images/images/RightFill.svg"

                iconColor: "#ffffff"

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 20

            }

            MouseArea {
                anchors {
                    fill: parent
                }

                onClicked: {
                    drawerAssetDashboardMenu.itemClicked(modelData[1])

                    tmrCloseDelay.start()
                }
            }
        }

    }
}

}
