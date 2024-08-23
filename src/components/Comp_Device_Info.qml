import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import QtQml 2.12

Item {
    id: compDeviceInfo


    property alias isDeviceAntenna : compDeviceInfo.isAntenna
    property bool isAntenna: true
    property string deviceID: ""
    property string selectedAction: ""
    property var xVal
    property var yVal
    property var listofDevices: []
    property var idx


    signal signal_onItemClicked
    signal signal_onItemLongPressed
    signal centerOnCoords(var x, var y);
    signal signalBeaconIDChanged(var Beacon_ID);


    function listItemClicked(model, index){
        compDeviceInfo.deviceID = model.Beacon_ID;
        compDeviceInfo.isAntenna = model.asset_type === "Antenna" ? true : false
        listofDevices.currentIndex = index
        compDeviceInfo.xVal = model.Latitude
        compDeviceInfo.yVal = model.Longitude

        compDeviceInfo.signalBeaconIDChanged(compDeviceInfo.deviceID);
    }


    ListView {
        id: listofDevices


        clip: true
        boundsBehavior: Flickable.StopAtBounds

        height: parent.height - 20
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right

            topMargin: 10
            leftMargin: 10
            rightMargin: 10
            bottomMargin: 10
        }

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AlwaysOn
            width: 8
            topPadding: 10
            bottomPadding: 10
        }

        spacing: 15
        model: compDeviceInfo.listofDevices
        delegate: CompBtnBreadcrumb {

            text: model.location + " - " + model.Beacon_ID
            width: parent.width - 15
            lblBtnLbl.horizontalAlignment: Text.AlignLeft
            lblBtnLbl.leftPadding: 50


            onClicked: {
                compDeviceInfo.listItemClicked(model, index)
                compDeviceInfo.centerOnCoords(compDeviceInfo.xVal, compDeviceInfo.yVal)
                compDeviceInfo.signal_onItemClicked()
            }

            onPressAndHold: {
                compDeviceInfo.listItemClicked(model, index)
                compDeviceInfo.centerOnCoords(compDeviceInfo.xVal, compDeviceInfo.yVal)
                compDeviceInfo.signal_onItemLongPressed()
            }


            Rectangle {
                visible: model.is_selected

                anchors.fill: parent
                color: "Transparent"
                radius: 20
                border {
                    width: 3
                    color: "#ffffff"
                }

            }

            CompImageIcon {
                id: imgDeviceIcon

                source: model.asset_type === "Antenna" ? "file:///usr/share/BeaconOS-lib-images/images/AntennaFill.svg" : "file:///usr/share/BeaconOS-lib-images/images/DroneFill.svg"

                width: 40
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                    leftMargin: 10
                    rightMargin: 20
                }   
            }
        }
    }
}

