import QtQuick 2.15
import Qt.labs.qmlmodels 1.0

Screen_Raptor__BASE {
    id: screen_Raptor_Delta_Root
    property var selectedAssetID
    property var beaconIDSelected
    property var beaconIDSelectedLast
    // property string lat
    // property string lon
    // property string altitude
    // property string deviceSpeed
    // property var selectedItem

    onBeaconIDSelectedChanged: {
        console.log("BEACON ID CHANGED");
        changedBeaconID(beaconIDSelected);
    }

    function changedBeaconID(beaconIDSelected) {
        beaconIDSelected = beaconIDSelected;
        if(beaconIDSelected === ""){
            beaconIDSelectedLast = beaconIDSelected
            return;
        }
        TableModelRaptorRoot.setIsSelected(beaconIDSelected, true);
        if(beaconIDSelectedLast === ""){
            beaconIDSelectedLast = beaconIDSelected
            return;
        }
        TableModelRaptorRoot.setIsSelected(beaconIDSelectedLast, false);
        beaconIDSelectedLast = beaconIDSelected;

        //signalBeaconIDSelected(beaconIDSelected);

    }

    Loader{
        id:loaderScreenDeviceInfo
        anchors.fill: parent
        asynchronous: true
        active: raptorNavMenu.selectedScreen === "Raptor"

        sourceComponent: Screen_Device_Info{

            onBeaconIDSelectedChanged: {
                screen_Raptor_Delta_Root.beaconIDSelected = beaconIDSelected
                console.log("BEACON ID CHANGED IN SCREEN RAPTOR");

            }

            // onLatChanged: {
            //     screen_Raptor_Delta_Root.lat = lat
            //     //console.log("LATITUDE CHANGED IN SCREEN RAPTOR");
            // }

            // onLonChanged: {
            //     screen_Raptor_Delta_Root.lon = lon
            //     //console.log("LONGITUDE CHANGED IN SCREEN RAPTOR");
            // }

            // onAltitudeChanged: {
            //     screen_Raptor_Delta_Root.altitude = altitude
            //     console.log("ALTITUDE CHANGED IN SCREEN RAPTOR");
            // }

            // onDeviceSpeedChanged: {
            //     screen_Raptor_Delta_Root.deviceSpeed = deviceSpeed
            //     console.log("DEVICE SPEED CHANGED IN SCREEN RAPTOR");
            // }

            //onBeaconIDSelectedChanged: screen_Raptor_Delta_Root.beaconIDSelected = beaconIDSelected
        }
    }

    Loader{
        id: loaderScreenRaptorControl
        anchors.fill: parent
        asynchronous: true
        active: raptorNavMenu.selectedScreen === "Control"
        sourceComponent: Screen_Raptor_Control{
            beaconIDSelected: screen_Raptor_Delta_Root.beaconIDSelected
            onSignalBeaconIDSelected: {
                screen_Raptor_Delta_Root.beaconIDSelected = beaconID

            }

        }

    }

    Loader{
        id: loaderScreenRaptorFlightPlanner
        anchors.fill: parent
        asynchronous: true
        active: raptorNavMenu.selectedScreen === "FlightPlanner"

        sourceComponent: Screen_Raptor_Flight_Planner{}

    }

    CompRaptorNavMenu {
        id: raptorNavMenu

        anchors{
            left: parent.left
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }
        width: 100
        height: 500
    }

}
