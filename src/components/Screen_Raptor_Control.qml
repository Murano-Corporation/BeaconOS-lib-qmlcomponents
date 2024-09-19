import QtQuick 2.15
import QtQuick.Controls 2.12
import Qt.labs.qmlmodels 1.0

import CONSTANTS 1.0
import Murano.Beacon.Raptor.DeviceControllers 1.0

Screen_Raptor__BASE {
    id: screen_RaptorControlRoot

    readonly property bool isNullSource: controllerSource === undefined
    readonly property int deviceConnectionState: isNullSource ? -1 : controllerSource.droneConnectionState
    readonly property bool isDrone: controlledDeviceType === Constants.ERaptorDeviceType_Drone
    readonly property bool isAntenna: controlledDeviceType === Constants.ERaptorDeviceType_Antenna
    readonly property bool isArmed: isNullSource ? false : controllerSource.bIsArmed
    readonly property string imageProviderString: isDrone ? "drone-camera" : isAntenna ? "antenna-camera" : ""
    readonly property string imageAltProviderString: "antenna-camera-ir"
    readonly property string dispText_Drone: isNullSource ? "" : controllerSource.latitude + ", " + controllerSource.longitude + ", " + controllerSource.altitude + " " + controllerSource.deviceSpeed
    readonly property string dispText_Antenna: isNullSource ? "" : controllerSource.latitude + ", " + controllerSource.longitude + ", " + controllerSource.altitude
    readonly property string eSTATE_NO_ASSET_SELECTED: "State-No Asset Selected"
    readonly property string eSTATE_CONNECTING: "State-Connecting"
    readonly property string eSTATE_CONNECTED: "State-Connected"

    property bool isEStopArmed: isNullSource ? true : controllerSource.isEStopArmed
    property bool controlON: true
    property bool hudON: true
    property bool mapON: true
    property bool dataON: true
    property bool lblFlightModeOn: false
    property bool miniMapToggle: false
    property bool showButtonPanel: false
    property bool drawerLeftClosed: (drawerRaptorDeviceInfoControl.position < 0.01)
    property bool drawerRightClosed: (drawerRaptorDroneControlQuickActions.position < 0.01)
    property bool drawerRightVisible: drawerRaptorDroneControlQuickActions.visible
    property string beaconIDSelected: ""
    property string dispText: isDrone ? dispText_Drone : isAntenna ? dispText_Antenna : "???"
    property int controlledDeviceType: -1
    property real batteryPercent: raptorDroneController.deviceBattery
    property var gimbal1Struct: raptorDroneController.gimbalA
    property var gimbal2Struct: raptorDroneController.gimbalB
    property var detectionInfo: raptorDroneController.detectionInfo
    property var selectedItem
    property var controllerSource: isDrone ? raptorDroneController : isAntenna ? raptorAntennaController : undefined

    onControllerSourceChanged: {
        console.debug("Controller source is now: " + controllerSource)

        try {
            if (controllerSource === raptorDroneController) {
                raptorDroneController.connectToDevice()
                raptorAntennaController.disconnectFromDevice()
            } else if (controllerSource === raptorAntennaController) {
                raptorDroneController.disconnectFromDevice()
                raptorAntennaController.connectToDevice()
            } else {
                raptorDroneController.disconnectFromDevice()
                raptorAntennaController.disconnectFromDevice()
            }
        } catch (ex) {
            console.log("Something bad happened")
            console.error("[EXCEPTION] " + ex)
        }
    }

    signal signalBeaconIDSelected(var beaconID)
    signal setShowButtonPanel(var bShowButonPanel)

    anchors.fill: parent
    state: eSTATE_NO_ASSET_SELECTED
    states: [
        State {
            name: eSTATE_NO_ASSET_SELECTED

            when: screen_RaptorControlRoot.deviceConnectionState === 0
        },
        State {
            name: eSTATE_CONNECTING

            when: screen_RaptorControlRoot.deviceConnectionState === 1
        },
        State {
            name: eSTATE_CONNECTED

            when: screen_RaptorControlRoot.deviceConnectionState === 2
        }
    ]

    onSelectedItemChanged: {

        //console.log("Selected Item is now: " + selectedItem)
        screen_RaptorControlRoot.beaconIDSelected = selectedItem.beacon_id
        screen_RaptorControlRoot.controlledDeviceType = selectedItem.asset_type
        //console.log('Asset Type is: ' + screen_RaptorControlRoot.controlledDeviceType)
        // console.log('--- Is Drone: ' + (screen_RaptorControlRoot.controlledDeviceType
        //                                === Constants.ERaptorDeviceType_Drone))
        //console.log('--- Is Antenna: ' + (screen_RaptorControlRoot.controlledDeviceType
        //                                  === Constants.ERaptorDeviceType_Antenna))
    }

    onBeaconIDSelectedChanged: {

        //console.log('Beacon ID Selected changed to: ' + beaconIDSelected)
    }

    function setGimbal1Values(x_value, y_value) {
        var new_struct = screen_RaptorControlRoot.gimbal1Struct

        new_struct.axisX_Value = x_value
        new_struct.axisY_Value = y_value
    }

    function setGimbal2Values(x_value, y_value) {
        var new_struct = screen_RaptorControlRoot.gimbal2Struct

        new_struct.axisX_Value = x_value
        new_struct.axisY_Value = y_value
    }

    Component.onCompleted: {
        console.trace()
    }

    RaptorDroneController {
        id: raptorDroneController
        assetName: "Drone-1"
    }

    RaptorAntennaController {
        id: raptorAntennaController

        assetName: "Antenna-1"
    }

    Item {
        id: deviceScreen

        enabled: miniMapToggle ? false : true
        visible: miniMapToggle ? false : true
        anchors.fill: parent

        z: miniMapToggle ? 0 : 1

        Component.onCompleted: {
            console.trace()
        }

        Item {
            id: compTargetBoundingBox1

            visible: screen_RaptorControlRoot.controllerSource.watchdogOk
                     && screen_RaptorControlRoot.detectionInfo.valid
                     && screen_RaptorControlRoot.hudON

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: 70
            }

            Rectangle {
                anchors.top: parent.top
                color: "#00FF94"
                height: 2
                width: 270
                radius: 16
            }
            Rectangle {
                anchors.left: parent.left
                color: "#00FF94"
                height: 123
                width: 2
                radius: 16
            }

            Rectangle {
                anchors.top: parent.top
                anchors.right: parent.right
                color: "#00FF94"
                height: 2
                width: 270
                radius: 16
            }
            Rectangle {
                anchors.right: parent.right
                color: "#00FF94"
                height: 123
                width: 2
                radius: 16
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                color: "#00FF94"
                height: 2
                width: 270
                radius: 16
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                color: "#00FF94"
                height: 123
                width: 2
                radius: 16
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                color: "#00FF94"
                height: 2
                width: 270
                radius: 16
            }
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                color: "#00FF94"
                height: 123
                width: 2
                radius: 16
            }

            Component.onCompleted: {
                console.trace()
            }
        }

        Comp_Raptor_Altimeter {
            id: attitudeMeter

            visible: screen_RaptorControlRoot.hudON
                     && screen_RaptorControlRoot.beaconIDSelected !== ""
                     && screen_RaptorControlRoot.isDrone
            height: 700
            width: 700
            anchors.centerIn: parent

            transform: Scale {
                xScale: 0.8
                yScale: 0.8

                origin {
                    x: attitudeMeter.width * 0.5
                    y: attitudeMeter.height * 0.5
                }
            }

            Connections {
                target: raptorDroneController

                function onSignal_YawChanged() {
                    attitudeMeter.compassAngle = raptorDroneController.yaw
                }

                function onSignal_PitchChanged() {
                    attitudeMeter.tiltAngle = raptorDroneController.pitch
                }

                function onSignal_RollChanged() {
                    attitudeMeter.rollAngle = raptorDroneController.roll
                }
            }

            Component.onCompleted: {
                console.trace()
            }
        }

        Popup_Raptor_Control_Messages {
            id: popupRaptorControlMessages

            controller: raptorDroneController
            startSize: Qt.size(500, 580)
            startPoint: Qt.point(81.0, 249.0)

            Component.onCompleted: {
                console.trace()
            }
        }

        Popup_Raptor_Control_ParamSeter {
            id: popupRaptorControlParamSeter

            controller: raptorDroneController

            Component.onCompleted: {
                console.trace()
            }
        }

        Popup_Raptor_Control_ManualCommand {
            id: popupRaptorControlManualCommand

            controller: raptorDroneController

            Component.onCompleted: {
                console.trace()
            }
        }

        PopupRaptorControlParameterView {
            id: popupRaptorControlParameterView

            controller: raptorDroneController

            Component.onCompleted: {
                console.trace()
            }
        }

        CompLabel {
            id: lblFlightMode

            visible: lblFlightModeOn && raptorDroneController.watchdogOk
                     && screen_RaptorControlRoot.isDrone
            text: "Sys. State: " + raptorDroneController.sSystemState
                  + "; - Flight Mode: " + raptorDroneController.flightMode
                  + "; - Land State: " + raptorDroneController.sLandedState
                  + "; - GPS Fix Type: " + raptorDroneController.sGpsFixType
                  + "; GPS Sats: " + raptorDroneController.gpsSatellitesAvailable
            fontPixelSize: 22

            anchors {
                top: parent.top
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                anchors.fill: parent
                anchors {
                    leftMargin: -20
                    rightMargin: -20
                }
                opacity: 0.6
                radius: 10
                z: -1

                color: "#80000000"
            }

            Component.onCompleted: {
                console.trace()
            }
        }

        CompImageIcon {
            id: openRightGridViewControl

            source: "file:///usr/share/BeaconOS-lib-images/images/RightOpen.svg"
            visible: drawerRightClosed && (beaconIDSelected !== "")
            height: 578
            width: 48
            opacity: 0.6

            anchors {
                right: deviceScreen.right
                verticalCenter: parent.verticalCenter
            }

            Component.onCompleted: {
                console.trace()
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    console.log("OPENING EXTRA BUTTONS DRAWER!!!")
                    if (drawerRaptorDroneControlQuickActions.visible === true) {
                        drawerRaptorDroneControlQuickActions.visible = false
                        drawerRaptorDroneControlQuickActions.visible = true
                    } else {
                        drawerRaptorDroneControlQuickActions.visible = true
                    }

                    console.log("Drawer open status after:",
                                drawerRaptorDroneControlQuickActions.visible)
                }
            }
        }

        Comp_Drone_Gimble {
            id: stick1

            //THIS NEEDS TO STAY FALSE SO IT BEHAVES LIKE DJI DRONE CONTROLLER
            isThrottle: false
            visible: screen_RaptorControlRoot.controlON
                     && beaconIDSelected !== "" //&& DroneController.watchdogOk
            opacity: 0.3

            anchors {
                left: parent.left
                leftMargin: 10
                bottom: parent.bottom
                bottomMargin: 10
            }

            onJoystickXValueChanged: {
                setGimbal1Values(joystickXValue, joystickYValue)
            }

            onJoystickYValueChanged: {
                setGimbal1Values(joystickXValue, joystickYValue)
            }

            Component.onCompleted: {
                console.trace()
            }
        }

        CompRaptorNavMenuItem {
            id: btnEStop

            height: 90
            width: height
            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/ESTOP.svg"

            anchors {
                left: popoutMenuLeft.right
                leftMargin: 0.5 * width

                bottom: popoutMenuLeft.bottom
            }

            onClicked: {
                screen_RaptorControlRoot.controllerSource.isEStopArmed
                        = !screen_RaptorControlRoot.isEStopArmed
            }

            Component.onCompleted: {
                console.trace()
            }
        }

        Comp_Drone_Gimble {
            id: stick2

            isThrottle: false
            visible: screen_RaptorControlRoot.controlON
                     && beaconIDSelected !== ""
                     && screen_RaptorControlRoot.isDrone
            opacity: 0.3

            anchors {
                right: parent.right
                rightMargin: 10
                bottom: parent.bottom
                bottomMargin: 10
            }

            onJoystickXValueChanged: {
                setGimbal2Values(joystickXValue, joystickYValue)
            }

            onJoystickYValueChanged: {
                setGimbal2Values(joystickXValue, joystickYValue)
            }

            Component.onCompleted: {
                console.trace()
            }
        }

        CompRaptorControlDeviceData {
            id: compRaptorControlDeviceData

            controller: raptorDroneController
            visible: screen_RaptorControlRoot.beaconIDSelected !== ""
                     && screen_RaptorControlRoot.dataON
            height: openRightGridViewControl.height

            batteryPercent: screen_RaptorControlRoot.batteryPercent
            dispText: screen_RaptorControlRoot.dispText

            anchors {
                right: parent.right
                rightMargin: (drawerRaptorDroneControlQuickActions.position > 0.7) ? 220 : 155
                verticalCenter: parent.verticalCenter
            }

            Component.onCompleted: {
                console.trace()
            }
        }

        CompImageIcon {
            id: openLeftDeviceInfoControl

            source: "file:///usr/share/BeaconOS-lib-images/images/LeftOpen.svg"
            height: 578
            width: 48
            opacity: 0.6
            visible: drawerLeftClosed

            anchors {
                left: deviceScreen.left
                verticalCenter: parent.verticalCenter
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (drawerRaptorDeviceInfoControl.visible === true) {
                        drawerRaptorDeviceInfoControl.visible = false
                        drawerRaptorDeviceInfoControl.visible = true
                    } else {
                        drawerRaptorDeviceInfoControl.visible = true
                    }
                }
            }

            Component.onCompleted: {
                console.trace()
            }
        }

        DrawerRaptorDeviceInfoControl {
            id: drawerRaptorDeviceInfoControl

            edge: Qt.LeftEdge
            y: 140

            onSignalSelectedItemChanged: model => {
                                             screen_RaptorControlRoot.selectedItem = model
                                         }

            onSignalBeaconIDChanged: bid => {

                                         screen_RaptorControlRoot.beaconIDSelected = bid
                                         signalBeaconIDSelected(bid)
                                         drawerRaptorDroneControlQuickActions.open()
                                     }

            Component.onCompleted: {
                console.trace()
            }
        }

        DrawerRaptorDroneControlQuickActions {
            id: drawerRaptorDroneControlQuickActions

            edge: Qt.RightEdge
            y: 250
            interactive: (beaconIDSelected === "") ? false : true
            visible: (beaconIDSelected !== "" && !miniMapToggle
                      && showButtonPanel) ? true : false

            Component.onCompleted: {
                console.trace()
            }

            onVisibleChanged: {
                if (!drawerRaptorDroneControlQuickActions.visible) {
                    setShowButtonPanel(false)
                } else {
                    setShowButtonPanel(true)
                }
            }

            model: ListModel {
                ListElement {
                    isActive: function () {
                        return true
                    }
                    iconPath: "file:///usr/share/BeaconOS-lib-images/images/Refresh.svg"
                    action: function () {
                        raptorDroneController.sendCommand_FlightController_Restart()
                        drawerRaptorDroneControlQuickActions.close()
                    }
                }
                ListElement {
                    isActive: function () {
                        return popupRaptorControlMessages.isOpen
                    }
                    iconPath: "file:///usr/share/BeaconOS-lib-images/images/MessageCMD.svg"
                    action: function () {
                        popupRaptorControlMessages.toggleOpen()
                        drawerRaptorDroneControlQuickActions.close()
                    }
                }
                ListElement {
                    isActive: function () {
                        return true
                    }
                    iconPath: "file:///usr/share/BeaconOS-lib-images/images/ManualCMD.svg"
                    action: function () {
                        popupRaptorControlManualCommand.open()
                        drawerRaptorDroneControlQuickActions.close()
                    }
                }
                ListElement {
                    isActive: function () {
                        return true
                    }
                    iconPath: "file:///usr/share/BeaconOS-lib-images/images/ViewParam.svg"
                    action: function () {
                        popupRaptorControlParameterView.open()
                        drawerRaptorDroneControlQuickActions.close()
                    }
                }
                ListElement {
                    isActive: function () {
                        return screen_RaptorControlRoot.hudON
                    }
                    iconPath: "file:///usr/share/BeaconOS-lib-images/images/HUD.svg"
                    action: function () {
                        screen_RaptorControlRoot.hudON = !screen_RaptorControlRoot.hudON
                    }
                }
                ListElement {
                    isActive: function () {
                        return screen_RaptorControlRoot.mapON
                    }
                    iconPath: "file:///usr/share/BeaconOS-lib-images/images/MAP.svg"
                    action: function () {
                        screen_RaptorControlRoot.mapON = !screen_RaptorControlRoot.mapON
                    }
                }
                ListElement {
                    isActive: function () {
                        return screen_RaptorControlRoot.dataON
                    }
                    iconPath: "file:///usr/share/BeaconOS-lib-images/images/DATA.svg"
                    action: function () {
                        screen_RaptorControlRoot.dataON = !screen_RaptorControlRoot.dataON
                    }
                }
                ListElement {
                    isActive: function () {
                        return screen_RaptorControlRoot.controlON
                    }
                    iconPath: "file:///usr/share/BeaconOS-lib-images/images/ControlEnabled.svg"
                    action: function () {
                        screen_RaptorControlRoot.controlON = !screen_RaptorControlRoot.controlON
                    }
                }
                ListElement {
                    isActive: function () {
                        return screen_RaptorControlRoot.lblFlightModeOn
                    }
                    iconPath: "file:///usr/share/BeaconOS-lib-images/images/Analytics.svg"
                    action: function () {
                        screen_RaptorControlRoot.lblFlightModeOn
                                = !screen_RaptorControlRoot.lblFlightModeOn
                    }
                }
            }
        }

        CompRaptorRadialPopoutMenu {
            id: popoutMenuLeft

            visible: screen_RaptorControlRoot.isDrone

            orientation: 6

            anchors {
                left: stick1.right
                leftMargin: 0.5 * width
                bottom: stick1.bottom
            }

            Component.onCompleted: {
                console.trace()
            }

            model: ListModel {
                ListElement {
                    type: "default"
                    is_enabled: function () {
                        return !screen_RaptorControlRoot.isArmed
                    }
                    imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Armed.svg"
                    tooltip_text: "Set the drone to the ARMed state, engaging the motors."
                    action: function () {
                        raptorDroneController.sendCommand_Arm()
                    }
                }
                ListElement {
                    type: "default"
                    is_enabled: function () {
                        return screen_RaptorControlRoot.isArmed
                    }
                    imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/DisArmed.svg"
                    tooltip_text: "Set the drone to the DISARMed state, disengaging the motors."
                    action: function () {
                        raptorDroneController.sendCommand_Disarm()
                    }
                }
                ListElement {
                    type: "default"
                    is_enabled: function () {
                        return screen_RaptorControlRoot.isArmed
                    }
                    is_active: function () {
                        return raptorDroneController.flightMode === "TAKEOFF"
                    }
                    imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/AutoTakeoff.svg"
                    tooltip_text: "Have the drone take-off from the current location and to the specified altitude."
                    action: function () {
                        raptorDroneController.sendCommand("takeoff",
                                                          "flightcontroller")
                    }
                }
                ListElement {
                    type: "default"
                    is_enabled: function () {
                        return screen_RaptorControlRoot.isArmed
                    }
                    imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/R2H.svg"
                    tooltip_text: "Have the drone return to the specified altitude above the established HOME."
                    action: function () {
                        raptorDroneController.sendCommand("set_mode_rtl",
                                                          "flightcontroller")
                    }
                }
                ListElement {
                    type: "default"
                    is_enabled: function () {
                        return screen_RaptorControlRoot.isArmed
                    }
                    is_active: function () {
                        return raptorDroneController.flightMode === "LAND"
                    }
                    imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/AutoLand.svg"
                    tooltip_text: "Have the drone automatically control descent while allowing the operator to maintain LEFT, RIGHT, FRONT, and BACK movement."
                    action: function () {
                        raptorDroneController.sendCommand("set_mode_land",
                                                          "flightcontroller")
                    }
                }
            }
        }

        CompRaptorRadialPopoutMenu {
            id: popoutMenuRight

            visible: screen_RaptorControlRoot.isDrone
            orientation: 4

            anchors {
                right: stick2.left
                rightMargin: 0.5 * width
                bottom: stick2.bottom
            }

            model: ListModel {
                ListElement {
                    type: "drone_state"
                    is_enabled: function () {
                        return true
                    }
                    is_active: function () {
                        return raptorDroneController.flightMode === "STABILIZE"
                    }
                    imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Stabilize.svg"
                    drone_state: "Stabilize"

                    action: function () {
                        raptorDroneController.sendCommand("set_mode_stabilize",
                                                          "flightcontroller")
                    }
                }
                ListElement {
                    type: "drone_state"
                    is_enabled: function () {
                        return true
                    }
                    is_active: function () {
                        return raptorDroneController.flightMode === "LOITER"
                    }
                    imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Loiter.svg"
                    drone_state: "Loiter"
                    action: function () {
                        raptorDroneController.sendCommand("set_mode_loiter",
                                                          "flightcontroller")
                    }
                }
                ListElement {
                    type: "drone_state"
                    is_enabled: function () {
                        return true
                    }
                    is_active: function () {
                        return raptorDroneController.flightMode === "GUIDED"
                    }
                    imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Guided.svg"
                    drone_state: "Guided"
                    action: function () {
                        raptorDroneController.sendCommand("set_mode_guided",
                                                          "flightcontroller")
                    }
                }
                ListElement {
                    type: "pursuit_state"
                    is_enabled: function () {
                        return true
                    }
                    is_active: function () {
                        return raptorDroneController.bPursuitEnabled
                    }
                    imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Pursuit.svg"
                    pursuit_state: "Detect"
                    action: function () {
                        raptorDroneController.snedCommand_PursuitModeActiveSet(
                                    !raptorDroneController.bPursuitEnabled)
                    }
                }
            }
        }
    }

    Item {
        id: areaMiniViewer

        height: 216
        width: 360

        Component.onCompleted: {
            console.trace()
        }

        anchors {
            bottom: parent.bottom
            bottomMargin: stick1.anchors.bottomMargin
            horizontalCenter: parent.horizontalCenter
        }
    }

    Image {
        id: imageCameraFeed

        //visible: screen_RaptorControlRoot.beaconIDSelected !== ""
        cache: false
        source: screen_RaptorControlRoot.controllerSource.sImageProviderURL_Primary
        //onSourceChanged: console.log("Source is now: " + source)
        sourceSize {
            height: imageCameraFeed.height
            width: imageCameraFeed.width
        }
        height: miniMapToggle ? areaMiniViewer.height : 1080
        width: miniMapToggle ? areaMiniViewer.width : 1920
        x: miniMapToggle ? areaMiniViewer.x : 0
        y: miniMapToggle ? areaMiniViewer.y : 0
        z: miniMapToggle ? 1 : 0

        //Rectangle {
        //    anchors.fill: parent
        //    color: "Green"
        //}
        Behavior on width {
            NumberAnimation {
                duration: 250
            }
        }

        Behavior on x {
            NumberAnimation {
                duration: 250
            }
        }

        Behavior on y {
            NumberAnimation {
                duration: 250
            }
        }

        Behavior on height {
            NumberAnimation {
                duration: 250
            }
        }

        Component.onCompleted: {
            console.trace()
        }
    }

    MouseArea {
        id: miniMapMouseArea

        enabled: hudON && drawerLeftClosed && beaconIDSelected !== ""

        anchors.fill: areaMiniViewer
        z: 2

        onClicked: {
            miniMapToggle = !miniMapToggle
        }

        Component.onCompleted: {
            console.trace()
        }
    }

    CompMapViewer {
        id: miniMap

        visible: mapON && drawerLeftClosed && beaconIDSelected !== ""
        enabled: mapON && drawerLeftClosed && beaconIDSelected !== ""
        height: !miniMapToggle ? areaMiniViewer.height : 1080
        width: !miniMapToggle ? areaMiniViewer.width : 1920
        x: !miniMapToggle ? areaMiniViewer.x : 0
        y: !miniMapToggle ? areaMiniViewer.y : 0
        z: !miniMapToggle ? 1 : 0
        showMapTypes: false
        activeMapTypeIndex: 4
        listAssets: TableModelRaptorMap

        Component.onCompleted: {
            console.trace()
            setZoomLevel(15.0)
        }

        Behavior on width {
            NumberAnimation {
                duration: 250
            }
        }

        Behavior on x {
            NumberAnimation {
                duration: 250
            }
        }

        Behavior on y {
            NumberAnimation {
                duration: 250
            }
        }

        Behavior on height {
            NumberAnimation {
                duration: 250
            }
        }
    }
}
