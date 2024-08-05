import QtQuick 2.15
import Qt.labs.qmlmodels 1.0

Screen_Raptor__BASE {
    id: screen_Raptor_Delta_Root
    property var selectedAssetID
    property string beaconIDSelected: ""
    property var beaconIDSelectedLast
    property bool bButtonLayout: false// raptorNavMenu.selectedScreen === "Control" ? true : false


    // property string lat
    // property string lon
    // property string altitude
    // property string deviceSpeed
    // property var selectedItem

    onBeaconIDSelectedChanged: {
        //console.log("BEACON ID CHANGED");
        changedBeaconID(beaconIDSelected);
        if (beaconIDSelected === "") {
            bButtonLayout = false
        }
        else if (beaconIDSelected !== "" && bButtonLayout !== true){
            bButtonLayout = true
        }
        //console.log("beaconIDSelected: " + beaconIDSelected + " bButtonLayout: " + bButtonLayout)
    }

    Component.onCompleted: {
        // for (var i = 0; i < TableModelRaptorMap.rowCount(); i++) {
        //     console.log()
        //     //if (TableModelRaptorMap[i].is_selected) {
        //     TableModelRaptorRoot.setIsSelected(TableModelRaptorMap[i].Beacon_ID, false);
        //     //}
        // }
        TableModelRaptorRoot.resetAllIsSelected()
    }

    function changedBeaconID(beaconIDSelected) {
        beaconIDSelected = beaconIDSelected;
        console.log("beaconIDSelectedLast: " + beaconIDSelectedLast)
        console.log("beaconIDSelected: " + beaconIDSelected)
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
                //console.log("BEACON ID CHANGED IN SCREEN RAPTOR");

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
                screen_Raptor_Delta_Root.beaconIDSelected = beaconIDSelected
                //console.log("Signal caught in RaptorControl loader")
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

        transform: Scale {
            xScale: 0.8
            yScale: 0.8
        }

        onSignal_3DreconstructionClicked: {
            bButtonLayout = !bButtonLayout
            console.log("bButtonLayout: " + bButtonLayout)
        }

        beaconIDselected: screen_Raptor_Delta_Root.beaconIDselected

        visible: raptorNavMenu.selectedScreen !== "Control" || (!bButtonLayout && raptorNavMenu.selectedScreen === "Control")

        y: raptorNavMenu.selectedScreen !== "Control" ? 450 : 360

        anchors{
            right: parent.right
            rightMargin: 50
            //verticalCenter: parent.verticalCenter
        }
        width: 90
        height: 420
    }

    // CompRaptorNavMenuItem {
    //     id: buttonLayoutSwitcher

    //     opacity: compRaptorNavMenuRoot.selectedScreen === "Raptor" ? 1.0 : 0.6

    //     imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Swap.svg"

    //     visible: raptorNavMenu.selectedScreen === "Control"

    //     height: 50
    //     width: 50

    //     anchors {
    //         left: parent.left
    //         leftMargin: 40
    //         top: parent.top
    //         topMargin: 250
    //     }

    //     MouseArea {
    //         anchors.fill:parent
    //         onClicked: {
    //             bButtonLayout = !bButtonLayout
    //         }
    //     }
    // }

}
