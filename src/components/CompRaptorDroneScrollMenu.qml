import QtQuick 2.15
import QtQuick.Controls 2.12

ListView {
    orientation: ListView.Horizontal
    property bool estopIsActive: false

    spacing: 18

    width: 522 // Width of the Flickable view area (visible area)
    height: 90 // Full height of the Flickable area
    contentWidth: 90 // Make sure Flickable knows the content width
    contentHeight: 90 // Height of the content (can be adjusted if needed)
    flickableDirection: Flickable.HorizontalFlick // Enable horizontal scrolling
    clip: true // Ensure that only the part within Flickable's bounds is visible

    // Rectangle {
    //     color: "blue"
    //     anchors.fill: parent
    // }


    model: ListModel {
        ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/ESTOP.svg"; action: "eStop" }
        ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/Loiter.svg"; action: "loiter" }
        ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/R2H.svg"; action: "rtl" }
        ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/AutoTakeoff.svg"; action: "takeoff" }
        ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/AutoLand.svg"; action: "land" }
        ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/Stabilize.svg"; action: "stabilize" }
        ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/Brake.svg"; action: "brake" }
        ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/Pursuit.svg"; action: "pursuit" }
        ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/HUD.svg"; action: "toggleHud" }
        ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/ControlEnabled.svg"; action: "toggleControl" }
        ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/DroneCMD.svg"; action: "togglePopup" }
        ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/Analytics.svg"; action: "toggleFlightMode" }
    }

    delegate: CompRaptorNavMenuItem{

        // Rectangle {
        //     color: "blue"
        //     anchors.fill: parent
        // }

        opacity: 0.6
        imgIconSrc: model.iconPath

        MouseArea {
            anchors.fill: parent
            onClicked: handleAction(model.action)
        }
    }

    ScrollBar.horizontal: ScrollBar{
        policy: ScrollBar.AlwaysOn
        width: 8
        leftPadding: 10
        rightPadding: 10
    }

    function handleAction(action) {
        switch (action) {
        case "eStop":
            estopIsActive = !estopIsActive
            DroneController.setEStopArmed(estopIsActive)
            break
        case "loiter":
            DroneController.sendCommand("set_mode_loiter")
            break
        case "rtl":
            DroneController.sendCommand("set_mode_rtl")
            break
        case "takeoff":
            DroneController.sendCommand("set_mode_takeoff")
            break
        case "land":
            DroneController.sendCommand("set_mode_land")
            break
        case "stabilize":
            DroneController.sendCommand("set_mode_stabilize")
            break
        case "brake":
            DroneController.sendCommand("set_mode_brake")
            break
        case "pursuit":
            DroneController.sendCommand("set_mode_pursuit")
            break
        case "toggleHud":
            screen_RaptorControlRoot.hudON = !screen_RaptorControlRoot.hudON
            console.log("screen_RaptorControlRoot.hudON : " + screen_RaptorControlRoot.hudON)
            break
        case "toggleControl":
            screen_RaptorControlRoot.controlON = !screen_RaptorControlRoot.controlON
            console.log("screen_RaptorControlRoot.controlON : " + screen_RaptorControlRoot.controlON)
            break
        case "togglePopup":
            if (popupRaptorControlQuickCommands.visible) {
                popupRaptorControlQuickCommands.close()
            } else {
                popupRaptorControlQuickCommands.open()
            }
            break
        case "toggleFlightMode":
            lblFlightMode.visible = !lblFlightMode.visible
            break
        }
    }


}
