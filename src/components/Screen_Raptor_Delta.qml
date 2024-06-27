import QtQuick 2.15
import Qt.labs.qmlmodels 1.0

Screen_Raptor__BASE {
    id: screen_Raptor_Delta_Root
    property var selectedAssetID
    property var beaconIDSelected: ""
    property var beaconIDSelectedLast: ""

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
            onSignalBeaconIDSelected: screen_Raptor_Delta_Root.beaconIDSelected = beacon_ID
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
            top: parent.top
            leftMargin: 20
            topMargin: 20
        }
        width: 100
        height: 500
    }

}
