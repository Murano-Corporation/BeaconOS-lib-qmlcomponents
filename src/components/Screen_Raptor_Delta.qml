import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0

Screen_Raptor__BASE {
    id: screen_Raptor_Delta_Root
    property var selectedAssetID
    property string beaconIDSelected: ""
    property var beaconIDSelectedLast
    property bool showButtonPanel: false
    property bool controlRightClosed: true

    onBeaconIDSelectedChanged: {
        changedBeaconID(beaconIDSelected);
        if (beaconIDSelected === "") {
            showButtonPanel = false
        }
        else if (beaconIDSelected !== "" && showButtonPanel !== true){
            showButtonPanel = true
        }
    }

    Component.onCompleted: {
        TableModelRaptorRoot.resetAllIsSelected()
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
        id: loaderScreenDeviceInfo
        anchors.fill: parent
        asynchronous: true
        active: raptorNavMenu.selectedScreen === "Raptor"

        sourceComponent: Screen_Device_Info{

            onBeaconIDSelectedChanged: {
                screen_Raptor_Delta_Root.beaconIDSelected = beaconIDSelected

            }
        }
    }

    Loader{
        id: loaderScreenRaptorControl

        anchors.fill: parent
        asynchronous: true
        active: raptorNavMenu.selectedScreen === "Control"
        sourceComponent: Screen_Raptor_Control{
            id: ldrControl

            Component.onCompleted: {
                screen_Raptor_Delta_Root.controlRightClosed = drawerRightClosed
            }

            Component.onDestruction: {
                screen_Raptor_Delta_Root.controlRightClosed = true
            }

            onDrawerRightClosedChanged: {
                screen_Raptor_Delta_Root.controlRightClosed = drawerRightClosed
            }

            showButtonPanel: screen_Raptor_Delta_Root.showButtonPanel

            onSetShowButtonPanel: bShow => {
                                  screen_Raptor_Delta_Root.showButtonPanel = bShow
                                  }

            onDrawerRightVisibleChanged: {
                if (drawerRightVisible === true) {
                    raptorNavMenu.visible = true
                    raptorNavMenu.visible = false
                }
                else {
                    raptorNavMenu.visible = true
                }
            }

            beaconIDSelected: screen_Raptor_Delta_Root.beaconIDSelected
            onSignalBeaconIDSelected: {
                screen_Raptor_Delta_Root.beaconIDSelected = beaconIDSelected
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

        visible: raptorNavMenu.selectedScreen !== "Control" || (!showButtonPanel && raptorNavMenu.selectedScreen === "Control")

        y: raptorNavMenu.selectedScreen !== "Control" ? 450 : 360

        anchors{
            right: parent.right
            rightMargin: 50
        }
        width: 90
        height: 420
    }

}
