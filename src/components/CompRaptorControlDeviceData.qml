import QtQuick 2.15
import QtQuick.Controls 2.12
import CONSTANTS 1.0

Rectangle {
    id: compRaptorControlDeviceData

    required property int batteryPercent
    required property string dispText
    property int itemHeight: 60

    width: 390
    color: "transparent"
    radius: 20


    Component{
        id: delegateRaptorControlDevicesItem

        Item{
            height: compRaptorControlDeviceData.itemHeight
            width: column.width

            CompLabel{
                id: lblText
                text: model.text + ":"
                fontPixelSize: 16
                anchors{
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }

            }

            CompLabel{
                text: model.value()
                anchors{
                    left: lblText.right
                    leftMargin: 20
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }

                elide: Text.ElideRight
            }
        }
    }

    Rectangle{
        anchors.fill: parent
        opacity: 0.6
        radius: 10
        z: -1
        color: "#80000000"
    }

    Column {
        id: column

        property bool isDeviceExpanded: true
        property bool isTargetExpanded: false
        property int nonLabelHeight: (height - lblDevData.height - lblTarData.height)

        clip: true
        anchors {
            fill: parent
            margins: 10
        }

        CompLabel {
            id: lblDevData

            text: "Device Data"
            fontPixelSize: 30
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft

            anchors{
                left: parent.left
                right: parent.right
            }

            CompIconBtn{
                iconUrl: column.isDeviceExpanded ? "file:///usr/share/BeaconOS-lib-images/images/RightFill.svg" : "file:///usr/share/BeaconOS-lib-images/images/DownFill.svg"
                anchors{
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }

                onClicked: column.isDeviceExpanded = !column.isDeviceExpanded
            }

        }

        ListView {
            id: listviewDeviceData
            height: column.isDeviceExpanded ? (column.isTargetExpanded ? column.nonLabelHeight * 0.5 : column.nonLabelHeight) : 0
            width: parent.width
            clip: true

            Rectangle{
                anchors.fill: parent
                color: "#80000000"
                z: -1
            }

            Behavior on height{
                NumberAnimation{
                    duration: 250
                }
            }

            model: ListModel{

                ListElement{
                    text: "Pursuit State"
                    value: function(){ return DroneController.sPursuitState }
                }

                ListElement{
                    text: "Sys. State"
                    value: function(){ return DroneController.sSystemState }
                }

                ListElement{
                    text: "Flight Mode"
                    value: function(){ return DroneController.flightMode }
                }

                ListElement{
                    text: "Land State"
                    value: function(){ return DroneController.sLandedState }
                }

                ListElement{
                    text: "GPS Fix Type"
                    value: function(){ return DroneController.sGpsFixType }
                }

                ListElement{
                    text: "GPS Sats. Count"
                    value: function(){ return DroneController.gpsSatellitesAvailable }
                }

                ListElement{
                    text: "Battery"
                    value: function(){return compRaptorControlDeviceData.batteryPercent}
                }

                ListElement{
                    text: "Flight Remaining"
                    value: function(){ return DroneController.flightRemaining}
                }

                ListElement{
                    text: "Latitude"
                    value: function(){ return DroneController.latitude}
                }

                ListElement{
                    text: "Longitude"
                    value: function(){ return DroneController.longitude}
                }

                ListElement{
                    text: "Heading"
                    value: function(){ return DroneController.altitude}
                }

                ListElement{
                    text: "Speed"
                    value: function(){ return DroneController.deviceSpeed}
                }
            }

            delegate: delegateRaptorControlDevicesItem
        }

        CompLabel{
            id: lblTarData

            text: "Target Data"
            fontPixelSize: lblDevData.fontPixelSize
            verticalAlignment: lblDevData.verticalAlignment
            horizontalAlignment: lblDevData.horizontalAlignment
            anchors{
                left: parent.left
                right: parent.right
            }

            CompIconBtn{
                iconUrl: column.isTargetExpanded ? "file:///usr/share/BeaconOS-lib-images/images/RightFill.svg" : "file:///usr/share/BeaconOS-lib-images/images/DownFill.svg"
                anchors{
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }

                onClicked: column.isTargetExpanded = !column.isTargetExpanded
            }
        }

        ListView {
            id: listviewTargetData

            height: column.isTargetExpanded ? (column.isDeviceExpanded ? column.nonLabelHeight * 0.5 : column.nonLabelHeight) : 0
            width: parent.width
            clip: true
            model: ListModel{
                ListElement{
                    text: "Sample Data 1"
                    value: function(){ return "Sample Value 1"}
                }

                ListElement{
                    text: "Sample Data 2"
                    value: function(){ return "Sample Value 2"}
                }

                ListElement{
                    text: "Sample Data 3"
                    value: function(){ return "Sample Value 3"}
                }

                ListElement{
                    text: "Sample Data 4"
                    value: function(){ return "Sample Value 4"}
                }

                ListElement{
                    text: "Sample Data 5"
                    value: function(){ return "Sample Value 5"}
                }
            }
            delegate: delegateRaptorControlDevicesItem

            Behavior on height{
                NumberAnimation{
                    duration: 250
                }
            }


            Rectangle{
                anchors.fill: parent
                color: "#80000000"
                z: -1
            }
        }
    }
}
