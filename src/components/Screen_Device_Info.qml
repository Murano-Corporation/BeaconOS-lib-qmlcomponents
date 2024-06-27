import QtQuick 2.12
import QtLocation 5.12
import QtPositioning 5.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Item {
    id: screenDeviceInfoRoot

    property var beaconIDSelected
    property var beaconIDSelectedLast

    onBeaconIDSelectedChanged: {
        console.log("BEACON ID CHANGED IN SCREEN DEVICE INFO");
    }

    CompMapViewer{
        id: devicemap
        anchors{
            top: parent.top
            //topMargin: 20
            left: parent.left
            //right: parent.right
            bottom: parent.bottom
            bottomMargin: 20
        }
        width: 1250

        showMapTypes: false
        Component.onCompleted: setZoomLevel(1.0)
        listAssets: TableModelRaptorMap
    }

    Comp_Device_Info{

        id: antennaInfo

        anchors{
            top: devicemap.top
            //topMargin: 20
            left: devicemap.right
            leftMargin: 20
            right: parent.right
            //bottom: devicemap.bottom
            bottomMargin: 10
        }
        height: 478

        labelTitle.text: "Antennas"
        isDeviceAntenna: true
        listofDevices: TableModelRaptorAntenna

        onCenterOnCoords: devicemap.centerOnPointXY(x, y)
        onSignalBeaconIDChanged: (bid)=>{
            console.log("Signal caught")
            screenDeviceInfoRoot.beaconIDSelected = bid
        }


    }

    Comp_Device_Info{

        anchors{
            top: antennaInfo.bottom
            topMargin: 20
            left: devicemap.right
            leftMargin: 20
            right: parent.right
            //bottom: devicemap.bottom
            //bottomMargin: 20
        }

        height: antennaInfo.height
        labelTitle.text: "Drones"
        isDeviceAntenna: false
        listofDevices: TableModelRaptorDrone

        onCenterOnCoords: devicemap.centerOnPointXY(x, y)
        onSignalBeaconIDChanged: (bid)=>{
            console.log("Signal caught")
            screenDeviceInfoRoot.beaconIDSelected = bid
        }
    }

}
