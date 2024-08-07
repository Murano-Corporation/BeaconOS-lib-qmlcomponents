import QtQuick 2.15
import QtQuick.Controls 2.12

ScrollView {
    property bool estopIsActive: false

    width: 230 + xTranslate.x // Width of the Flickable view area (visible area)
    height: 640 //360
    contentWidth: droneScrollMenu.width
    contentHeight: droneScrollMenu.height
    clip: true

    GridView {
        id: droneScrollMenu

        signal openPopup_Parameters()

        transform: Translate {
            id: xTranslate
            x: 20
        }

        //scrollable
        width: 220 // Width of the Flickable view area (visible area)
        height: 990//360 // Full height of the Flickable area
        cellWidth: 110
        cellHeight: 110
        clip: true // Ensure that only the part within Flickable's bounds is visible

        // ////notscrollable
        // width: 200
        // height: 900
        // cellWidth: 100
        // cellHeight: 100



        // Rectangle {
        //     color: "blue"
        //     anchors.fill: parent
        // }

        model: ListModel {
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/ESTOP.svg"; action: "eStop" }
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/Armed.svg"; action: "armDrone" }
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/DisArmed.svg"; action: "disarmDrone" }
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/Refresh.svg"; action: "refresh" }
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/MessageCMD.svg"; action: "messages" }
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/ManualCMD.svg"; action: "manualCMD" }
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/SetParam.svg"; action: "setParam" }
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/ViewParam.svg"; action: "viewParam" }
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/Loiter.svg"; action: "loiter" }
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/R2H.svg"; action: "rtl" }
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/AutoTakeoff.svg"; action: "takeoff" }
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/AutoLand.svg"; action: "land" }
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/Stabilize.svg"; action: "stabilize" }
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/Brake.svg"; action: "brake" }
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/Pursuit.svg"; action: "pursuit" }
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/HUD.svg"; action: "toggleHud" }
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/MAP.svg"; action: "toggleMap" }
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/DATA.svg"; action: "toggleData" }
            ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/ControlEnabled.svg"; action: "toggleControl" }
            //ListElement { iconPath: "file:///usr/share/BeaconOS-lib-images/images/DroneCMD.svg"; action: "togglePopup" }
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

    }

    ScrollBar.vertical: ScrollBar{
        //anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.leftMargin: 20
        policy: ScrollBar.AlwaysOn
        width: 8
        topPadding: 8
        bottomPadding: 8
    }

    function handleAction(action) {
        switch (action) {
        case "eStop":
            estopIsActive = !estopIsActive
            DroneController.setEStopArmed(estopIsActive)
            break
        case "armDrone":
            DroneController.sendCommand_Arm()
            //popupRaptorControlPrearmChecks.open()
            break
        case "disarmDrone":
            DroneController.sendCommand_Disarm()
            break
        case "refresh":
            console.log("restart")
            DroneController.sendCommand_FlightController_Restart()
            break
        case "messages":
            console.log("clicked on messages")
            //popupRaptorControlMessages.open()
            break
        case "manualCMD":
            popupRaptorControlManualCommand.open()
            break
        case "setParam":
            popupRaptorControlParamSeter.open()
            break
        case "viewParam":
            droneScrollMenu.openPopup_Parameters()
            popupRaptorControlParameterView.open()
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
            DroneController.sendCommand("set_mode_stabilize") //CHECK ME
            break
        case "brake":
            DroneController.sendCommand("set_mode_brake")
            break
        case "pursuit":
            DroneController.sendCommand("set_mode_pursuit") //CHECK ME
            break
        case "toggleHud":
            screen_RaptorControlRoot.hudON = !screen_RaptorControlRoot.hudON
            console.log("screen_RaptorControlRoot.hudON : " + screen_RaptorControlRoot.hudON)
            break
        case "toggleMap":
            screen_RaptorControlRoot.mapON = !screen_RaptorControlRoot.mapON
            //console.log("screen_RaptorControlRoot.hudON : " + screen_RaptorControlRoot.hudON)
            break
        case "toggleData":
            screen_RaptorControlRoot.dataON = !screen_RaptorControlRoot.dataON
            //console.log("screen_RaptorControlRoot.hudON : " + screen_RaptorControlRoot.hudON)
            break
        case "toggleControl":
            screen_RaptorControlRoot.controlON = !screen_RaptorControlRoot.controlON
            console.log("screen_RaptorControlRoot.controlON : " + screen_RaptorControlRoot.controlON)
            break
        case "toggleFlightMode":
            lblFlightMode.visible = !lblFlightMode.visible
            break
        }
    }
}
