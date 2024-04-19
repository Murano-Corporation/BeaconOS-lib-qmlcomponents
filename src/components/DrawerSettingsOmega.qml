import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import QtQml 2.12
import CONSTANTS 1.0

Drawer{

    id: drawerSettingsroot
    property alias navigationModel: groupNavButtons.model

    signal itemClicked(string viewName)

    function delayOpen(iDelay){
        tmrOpenDelay.interval = iDelay
        tmrOpenDelay.start()
    }

    Timer {
        id: tmrCloseDelay

        interval: 100
        onTriggered: {
            drawerSettingsroot.close()
        }
    }

    Timer {
        id: tmrOpenDelay

        interval: 100
        onTriggered: {
            drawerSettingsroot.open()
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
            drawerSettingsroot.close()
        }
    }

    //    CompIconBtn {

    //        id: iconBtnAssetInfo

    //        visible: drawerSettingsroot.closed

    //        anchors {
    //            top: parent.top
    //            left: parent.left
    //            topMargin: 150
    //            leftMargin: 66
    //        }

    //        height: 100
    //        width: 100
    //        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/ListFill.svg"
    //        iconColor: "White"

    //        onClicked: {
    //            drawerSettingsroot.open()
    //        }
    //    }

    CompLabel {
        id: lblScreenName

        anchors{
            //top: btnClose.top
            left: btnClose.right
            right: parent.right
            leftMargin: 45
            verticalCenter: btnClose.verticalCenter
        }
        font.pixelSize: 75
        text: "Settings"
    }

    CompCustomisableTextField{
        id: searchField

        width: 990

        anchors{
            //horizontalCenter: lblScreenName.horizontalCenter
            topMargin: 45
            top: btnClose.bottom
            left: btnClose.left
            //right: lblScreenName.right
            //rightMargin: 50
            //verticalCenter: lblScreenName.verticalCenter
        }
        height: 100
        textFontSize: 40
        btnClearSize: 60
    }

    GridView
    {

        id: groupNavButtons
        anchors {
            top: searchField.bottom
            leftMargin: 45
            left: parent.left
            topMargin: 50
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
            ["file:///usr/share/BeaconOS-lib-images/images/HelpFill.svg", "Applications"],
            ["file:///usr/share/BeaconOS-lib-images/images/CameraFill.svg", "Camera"],
            ["file:///usr/share/BeaconOS-lib-images/images/GearFill.svg", "System"],
            ["file:///usr/share/BeaconOS-lib-images/images/HelpFill.svg", "Database (Local)"]
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
                    source: model.icon_path
                    color: "White"
                }
                CompLabel {
                    anchors {
                        verticalCenter: iconMenu.verticalCenter
                        left: iconMenu.right
                        leftMargin: 30
                    }

                    text: model.name
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
                    //compSettingsroot.selectedNavName = modelData[1];
                    drawerSettingsroot.itemClicked(model.name)
                    tmrCloseDelay.start()
                }
            }
        }

    }
}
