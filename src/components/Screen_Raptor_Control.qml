import QtQuick 2.15
import QtQuick.Controls 2.15
import CONSTANTS 1.0

Screen_Raptor__BASE {
    id: screen_RaptorControlRoot

    property string beaconIDSelected
    property var selectedItem
    property var controllerSource: isDrone ? DroneController : isAntenna ? AntennaController : undefined
    property int controlledDeviceType: Constants.ERaptorDeviceType_Drone
    readonly property bool isNullSource: controllerSource === undefined
    readonly property int deviceConnectionState: isNullSource ? -1 : controllerSource.droneConnectionState
    readonly property bool isDrone: controlledDeviceType === Constants.ERaptorDeviceType_Drone
    readonly property bool isAntenna: controlledDeviceType === Constants.ERaptorDeviceType_Antenna
    readonly property string imageProviderString: isDrone ? "drone-camera" : isAntenna ? "antenna-camera" : ""
    readonly property string imageAltProviderString: "antenna-camera-ir"
    onImageProviderStringChanged: console.log("Image Provider String changed to: " + imageProviderString)
    property string dispText: isDrone ? dispText_Drone : isAntenna ? dispText_Antenna : "???"
    readonly property string dispText_Drone: isNullSource ? "" : controllerSource.latitude + ", " + controllerSource.longitude + ", " + controllerSource.altitude + " " + controllerSource.deviceSpeed
    readonly property string dispText_Antenna: isNullSource ? "" : controllerSource.latitude + ", " + controllerSource.longitude + ", " + controllerSource.altitude
    property bool controlON: true
    property bool hudON: true
    readonly property bool isEStopArmed: isNullSource ? true : controllerSource.isEStopArmed
    onIsEStopArmedChanged: {
        console.log("EStop is armed: " + isEStopArmed)
    }

    property var gimbal1Struct: isNullSource ? {} : controllerSource.gimbalA
    property var gimbal2Struct: isNullSource ? {} : controllerSource.gimbalB
    property var detectionInfo: isNullSource ? {} : controllerSource.detectionInfo
    property real batteryPercent: isDrone ? controllerSource.deviceBattery : 1.0
    readonly property bool watchdogOk: true //isNullSource ? false : controllerSource.watchdogOk
    signal signalBeaconIDSelected(var beaconID)

    onBeaconIDSelectedChanged: {
        for (var i = 0; i < TableModelRaptorMap.length; i++) {
            if (beaconIDSelected === TableModelRaptorMap[i].Beacon_ID) {
                selectedItem = TableModelRaptorMap[i]
            }
        }
    }

    Component.onCompleted: {
        tmrDelayOnCompleted.start()
        console.log(selectedItem)
    }

    readonly property string eSTATE_NO_ASSET_SELECTED: "State-No Asset Selected"
    readonly property string eSTATE_CONNECTING: "State-Connecting"
    readonly property string eSTATE_CONNECTED: "State-Connected"


    state: eSTATE_NO_ASSET_SELECTED
    onStateChanged: {
        console.log('Drone Connection State is now: ' + state)
    }
    states: [
        State{
            name: eSTATE_NO_ASSET_SELECTED

            when: screen_RaptorControlRoot.deviceConnectionState === 0
        },
        State{
            name: eSTATE_CONNECTING

            when: screen_RaptorControlRoot.deviceConnectionState === 1
        },
        State{
            name: eSTATE_CONNECTED

            when: screen_RaptorControlRoot.deviceConnectionState === 2
        }
    ]

    function setGimbal1Values(x_value, y_value){
        var new_struct = screen_RaptorControlRoot.gimbal1Struct
        new_struct.axisX_Value = x_value
        new_struct.axisY_Value = y_value
    }

    function setGimbal2Values(x_value, y_value){
        var new_struct = screen_RaptorControlRoot.gimbal2Struct
        new_struct.axisX_Value = x_value
        new_struct.axisY_Value = y_value
    }

    anchors.fill: parent

    Timer {
        id: tmrDelayOnCompleted

        interval:  10
        onTriggered: {
            if(screen_RaptorControlRoot.beaconIDSelected === ""){
                popupSelectedAssets.open();
            }
        }
    }

    Image {
        id: imageCameraFeed
        visible: screen_RaptorControlRoot.beaconIDSelected !== ""
        //source: "file:///usr/share/BeaconOS-lib-images/images/sunsetSwarm 1.png"
        source: screen_RaptorControlRoot.isNullSource ? "" : "image://" + screen_RaptorControlRoot.imageProviderString + "/" + screen_RaptorControlRoot.controllerSource.imageProviderFrameId
        anchors {
            fill: parent
        }

        Rectangle{
            visible: !screen_RaptorControlRoot.watchdogOk
            anchors.fill: parent
            color: "#DD000000"
        }
    }

    Image {
        id: imageCameraFeed_Alt

        visible: imageCameraFeed.visible && screen_RaptorControlRoot.isAntenna
        opacity: 0.5
        source: "image://" + screen_RaptorControlRoot.imageAltProviderString + "/" + screen_RaptorControlRoot.controllerSource.imageProviderIRFrameId

        anchors {
            fill: imageCameraFeed
        }
    }

    CompBtnBreadcrumb {
        id: lblBeaconID

        visible: screen_RaptorControlRoot.beaconIDSelected !== "" && screen_RaptorControlRoot.hudON


        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: 20
        }

        height: 60
        width: 220

        text: screen_RaptorControlRoot.beaconIDSelected ? "Asset ID: " + screen_RaptorControlRoot.beaconIDSelected : ""
        fontColor: "#00FF94"
        onClicked: popupSelectedAssets.open()
    }

    CompRaptorTargetBoundingBox {
        id: compTargetBoundingBox1

        visible: screen_RaptorControlRoot.watchdogOk && screen_RaptorControlRoot.detectionInfo.valid && screen_RaptorControlRoot.hudON

        detectionInfo: screen_RaptorControlRoot.controllerSource.detectionInfo.rectDetection

    }

    Item {
        id: areaAltimeter
        visible: screen_RaptorControlRoot.watchdogOk && screen_RaptorControlRoot.beaconIDSelected !== "" && screen_RaptorControlRoot.hudON

        anchors.centerIn: parent

        Comp_Raptor_Altimeter{
            id: attitudeMeter
            anchors.centerIn: parent
            height: 700
            width: 700

            Connections{
                enabled: !screen_RaptorControlRoot.isNullSource
                target: screen_RaptorControlRoot.controllerSource

                function onSignal_YawChanged(){
                    attitudeMeter.compassAngle = screen_RaptorControlRoot.controllerSource.yaw
                }

                function onSignal_PitchChanged(){
                    attitudeMeter.tiltAngle = screen_RaptorControlRoot.controllerSource.pitch
                }

                function onSignal_RollChanged(){
                    attitudeMeter.rollAngle = screen_RaptorControlRoot.controllerSource.roll
                }
            }
        }
    }

    Rectangle {

        visible: screen_RaptorControlRoot.beaconIDSelected !== "" && screen_RaptorControlRoot.hudON

        border.color: "#00FF94"
        border.width: 3
        color: "transparent"
        height: 60
        width: 440
        radius: 20

        anchors {
            right: lblBeaconID.left
            verticalCenter: lblBeaconID.verticalCenter
            rightMargin: 120
        }

        CompLabel {
            id: areaSelfCoordinates

            text: screen_RaptorControlRoot.beaconIDSelected ? dispText : ""

            anchors{
                centerIn: parent
            }
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "#00FF94"

        }
    }

    Rectangle {
        id: areaTargetMetaData

        visible: screen_RaptorControlRoot.watchdogOk && screen_RaptorControlRoot.beaconIDSelected !== "" && screen_RaptorControlRoot.hudON

        height: screen_RaptorControlRoot.height * 0.48
        width: screen_RaptorControlRoot.width * 0.17
        radius: 16

        x: screen_RaptorControlRoot.width * 0.80
        y: screen_RaptorControlRoot.height * 0.2

        color: "Transparent"

        border{
            width: 3
            color: "#00FF94"
        }

        Timer {
            id: tmrNotTouched

            interval: 2000

            onTriggered: {
                areaTargetMetaData.color = "Transparent"
            }
        }

        CompLabel{
            id: lblDroneSwarm
            anchors{
                top: parent.top
                left: parent.left
                margins: 20
            }
            color: "#00FF94"
            text: "Drone Swarm"
            font.pixelSize: 30
        }

        ListView{
            id: metaDataList

            anchors{
                top: lblDroneSwarm.bottom
                topMargin: 20
                left: lblDroneSwarm.left
            }
            height: parent.height

            model: [
                {"label": "Asset Name", "value": "Drone Swarm"},
                {"label": "Main Arm", "value": "No weapon"},
                {"label": "Second Arm", "value": "- "},
                {"label": "Peronnel", "value": "- "},
                {"label": "Destroyed", "value": "23/47"},
                {"label": "Health", "value": "- "},
                {"label": "Range", "value": "20 kilometers"}
            ]

            delegate:Item{
                height: 60
                CompLabel{
                    text: modelData.label + " : " + modelData.value
                    color: "#00FF94"
                    font.pixelSize: 20
                }
            }
        }

        Behavior on color{

            ColorAnimation {
                duration: 200
            }
        }

        MouseArea{
            anchors.fill: parent

            onPressed: {
                tmrNotTouched.stop()
                areaTargetMetaData.color = "#80000000"
            }

            onReleased: {
                tmrNotTouched.start()
            }
        }
    }


    CompLabel {
        id: areaClassifcation

        visible: screen_RaptorControlRoot.watchdogOk && screen_RaptorControlRoot.beaconIDSelected !== "" && screen_RaptorControlRoot.hudON
        x: 140//132
        y: 140//737

        color: "#00FF94"
        text: "Drone Swarm"
        font.pixelSize: 25



        Rectangle{
            color: "Transparent"
            z: -1
            anchors.fill: parent
            anchors.margins: -20
            radius: 16

            border{
                color: "#00FF94"
                width: 3
            }

            Timer{
                id: tmr_DelayFade
                interval: 2000

                onTriggered: {
                    parent.color = "Transparent"
                }
            }


            Behavior on color{

                ColorAnimation {
                    duration: 200
                }
            }

            MouseArea{
                anchors.fill: parent

                onPressed: {
                    tmr_DelayFade.stop()
                    parent.color = "#80000000"

                }

                onReleased: {
                    tmr_DelayFade.start()

                }
            }
        }
    }

    Rectangle{
        id: areaFlightModes

        anchors{
            left: stick1.right
            bottom: areaControlsRow.top
            right: stick2.left
        }

        color: "#80ffffff"
        height: 64
        Rectangle{
            anchors.fill: listviewTextFlightmode

            color: "#80ffffff"
        }

        ListView{
            id: listviewTextFlightmode
            anchors{
                left: parent.left
                right: parent.right
                bottom: parent.top
            }

            height: 64

            clip: true
            orientation: ListView.Horizontal
            boundsBehavior: Flickable.StopAtBounds
            model: 1
            delegate: CompLabel{
                id: lblFlightMode

                readonly property string text_drone: screen_RaptorControlRoot.isDrone ? "Sys. State: " + DroneController.sSystemState + "; - Flight Mode: " + DroneController.flightMode + "; - Land State: " + DroneController.sLandedState + "; - GPS Fix Type: " + DroneController.sGpsFixType + "; GPS Sats: " + DroneController.gpsSatellitesAvailable : ""
                readonly property string text_antenna: screen_RaptorControlRoot.isAntenna ? "Antenna" : ""
                text: screen_RaptorControlRoot.isDrone ? text_drone : screen_RaptorControlRoot.isAntenna ? text_antenna : "???"

                Rectangle{
                    anchors.fill: parent
                    anchors.margins: -10
                    radius: 10
                    z: -1

                    color: "#80000000"
                }
            }


        }


        ListView{
            anchors{
                fill: parent
            }

            clip: true
            boundsBehavior: Flickable.StopAtBounds
            model: 1

            orientation: ListView.Horizontal

            delegate: Row {
                visible: isDrone
                property int btnWidth: 200
                spacing: 64
                CompBtnBreadcrumb{
                    id: btnLoiter

                    text: "LOITER"
                    onClicked: DroneController.sendCommand("set_mode_loiter", "flightcontroller")
                    width: parent.btnWidth
                }

                CompBtnBreadcrumb{
                    id: btnGuided

                    text: "GUIDED"
                    onClicked: DroneController.sendCommand("set_mode_guided", "flightcontroller")
                    width: parent.btnWidth
                }

                CompBtnBreadcrumb{
                    id: btnRtl

                    text: "RTL"
                    onClicked: DroneController.sendCommand("set_mode_rtl", "flightcontroller")
                    width: parent.btnWidth
                }

                CompBtnBreadcrumb{
                    id: btnLand

                    text: "LAND"
                    onClicked: DroneController.sendCommand("set_mode_land", "flightcontroller")
                    width: parent.btnWidth
                }

                CompBtnBreadcrumb{
                    id: btnStabilize

                    text: "STABILIZE"
                    onClicked: DroneController.sendCommand("set_mode_stabilize","flightcontroller")
                    width: parent.btnWidth
                }

                CompBtnBreadcrumb{
                    id: btnBreak

                    text: "BRAKE"
                    onClicked: DroneController.sendCommand("set_mode_brake","flightcontroller")
                    width: parent.btnWidth
                }
            }

        }

    }


    Row {
        id: areaControlsRow

        height: 90
        width: 210//450

        //visible: DroneController.watchdogOk && screen_RaptorControlRoot.beaconIDSelected !== ""
        opacity: screen_RaptorControlRoot.beaconIDSelected ? 1.0 : 0.3

        anchors{
            bottom: parent.bottom
            bottomMargin: 20
            horizontalCenter: parent.horizontalCenter
        }

        spacing: 30

        // CompRaptorNavMenuItem {
        //     id: menuItemRaptor
        //     visible: false
        //     opacity: 0.6

        //     imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Camera.svg"
        //     imgIconColor: "White"
        // }
        // CompRaptorNavMenuItem {
        //     id: menuItemControl
        //     visible: false
        //     opacity:0.6

        //     imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Video.svg"
        //     imgIconColor: "White"

        // }
        CompRaptorNavMenuItem {
            id: menuItemShowHideHud

            opacity: 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Controller.svg"

            imgIconColor: screen_RaptorControlRoot.hudON ? "Green" : "Red"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(screen_RaptorControlRoot.hudON){
                        screen_RaptorControlRoot.hudON = false
                    } else {
                        screen_RaptorControlRoot.hudON = true
                    }
                    console.log("screen_RaptorControlRoot.hudON : " + screen_RaptorControlRoot.hudON)
                }
            }

        }

        CompRaptorNavMenuItem {
            id: menuItemFlightPlanner
            opacity: 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/ControlEnabled.svg"

            imgIconColor: screen_RaptorControlRoot.controlON ? "Green" : "Red"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(screen_RaptorControlRoot.controlON){
                        screen_RaptorControlRoot.controlON = false
                    } else {
                        screen_RaptorControlRoot.controlON = true
                    }
                    console.log("screen_RaptorControlRoot.controlON : " + screen_RaptorControlRoot.controlON)
                }
            }

        }

        CompRaptorNavMenuItem {
            id: menuItemQuickCommands
            opacity: 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/ControlEnabled.svg"

            imgIconColor: screen_RaptorControlRoot.controlON ? "Green" : "Red"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    popupRaptorControlQuickCommands.visible ? popupRaptorControlQuickCommands.close() : popupRaptorControlQuickCommands.open()
                }
            }

        }
    }

    Popup_Raptor_Control_QuickCommands {
        id: popupRaptorControlQuickCommands

        onOpenPopup_Parameters: popupRaptorControlParameterView.open()
    }

    Popup_Raptor_Control_Messages {
        id: popupRaptorControlMessages

        width: stick2.x  - (stick1.x + stick1.width)
    }


    Popup_Raptor_Control_ParamSeter {
        id: popupRaptorControlParamSeter
    }


    Popup_Raptor_Control_ManualCommand {
        id: popupRaptorControlManualCommand
    }

    PopupAsset {
        id: popupSelectedAssets
    }

    PopupRaptorControlParameterView {
        id: popupRaptorControlParameterView
    }

    CompBtnBreadcrumb{
        id: selectAssetBtn

        anchors.centerIn: parent
        visible: screen_RaptorControlRoot.beaconIDSelected === "" && !popupSelectedAssets.visible
        height: 200
        width: 400

        text: "Please select an asset to continue."

        onClicked: popupSelectedAssets.open()
    }


    Rectangle {
        id: btnEStop

        property bool isActive: screen_RaptorControlRoot.isEStopArmed

        anchors{
            bottom: stick1.top
            left: stick1.left
            right: stick1.right
        }

        height: width
        radius: 0.5 * height
        color: isActive ? "green" : "red"

        CompLabel {
            id: lblEStopTitle
            text: "E-STOP"

            anchors.centerIn: parent
        }

        CompLabel {
            id: lblEStopState
            text: btnEStop.isActive ? "ARMED" : ""

            anchors {
                top: lblEStopTitle.bottom
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }

            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                if(screen_RaptorControlRoot.isNullSource)
                {
                    console.log('Screen Raptor Control: Null source found on EStop Pressed')
                    return
                }

                try{
                    //console.log("EStop arm pressed before...")
                    var isArmedCurrently = screen_RaptorControlRoot.controllerSource.isEStopArmed
                    //console.log("...currently: " + isArmedCurrently)
                    isArmedCurrently = !isArmedCurrently
                    //console.log("...toggled: " + isArmedCurrently)
                    //console.log("...isNonNull: " + screen_RaptorControlRoot.controllerSource)
                    screen_RaptorControlRoot.controllerSource.isEStopArmed = isArmedCurrently

                    //console.log("EStop arm pressed after...")
                } catch(exception){
                    console.log("[EXCEPTION] - Screen_Raptor_Control : OnClicked of EStop Button : Exception: " + exception)
                }

            }
        }

    }

    Rectangle {
        id: btnPursuitActive
        property bool isActive: false
        visible: screen_RaptorControlRoot.isDrone
        anchors{
            bottom: stick2.top
            left: stick2.left
            right: stick2.right
        }

        height: width
        radius: 0.5 * height
        color: isActive ? "green" : "red"

        CompLabel {
            text: "Pursuit"

            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                btnPursuitActive.isActive = !btnPursuitActive.isActive
                screen_RaptorControlRoot.controllerSource.setPursuitModeActive(btnPursuitActive.isActive)
            }
        }
    }

    Rectangle {
        id: btnPursuitFollowActive

        visible: screen_RaptorControlRoot.isDrone
        anchors{
            bottom: btnPursuitActive.top
            left: btnPursuitActive.left
            right: btnPursuitActive.right
        }

        height: width
        radius: 0.5 * height
        color: isActive ? "green" : "red"

        CompLabel {
            text: "Follow"

            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                screen_RaptorControlRoot.controllerSource.setPursuitModeFollow(true)
            }
        }
    }


    Comp_Drone_Gimble {
        id: stick1

        visible: screen_RaptorControlRoot.watchdogOk && screen_RaptorControlRoot.beaconIDSelected !== "" && screen_RaptorControlRoot.controlON
        opacity: 0.25
        x: root.width * 0.09 - (stick1.width / 2)
        y: root.height * 0.72
        isThrottle: false

        onJoystickXValueChanged: {
            setGimbal1Values(joystickXValue, joystickYValue)
        }

        onJoystickYValueChanged: {
            setGimbal1Values(joystickXValue, joystickYValue)
        }
    }
    Comp_Drone_Gimble {
        id: stick2

        visible: screen_RaptorControlRoot.isDrone && stick1.visible
        opacity: 0.25
        x: root.width * 0.91 - (stick2.width / 2)
        y: root.height * 0.72
        isThrottle: false

        onJoystickXValueChanged: {
            setGimbal2Values(joystickXValue, joystickYValue)
        }

        onJoystickYValueChanged: {
            setGimbal2Values(joystickXValue, joystickYValue)
        }
    }

    Rectangle {
        id:deviceData

        visible: screen_RaptorControlRoot.isDrone && screen_RaptorControlRoot.controllerSource.watchdogOk && screen_RaptorControlRoot.beaconIDSelected !== "" && screen_RaptorControlRoot.hudON

        border.color: "#00FF94"
        border.width: 3
        color: "transparent"
        height: 60
        width: 240
        radius: 20

        anchors {
            verticalCenter: lblBeaconID.verticalCenter
            left: lblBeaconID.right
            leftMargin: 120
        }

        Row{
            id: row

            anchors{
                centerIn: parent
            }

            spacing: 20

            CompLabel{
                id: deviceFlightRemaining

                text: screen_RaptorControlRoot.beaconIDSelected ? DroneController.flightRemaining : ""

                anchors.verticalCenter: parent.verticalCenter

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                color: "#00FF94"

            }

            CompIconBtn{
                id: btnBattery
                height: 40


                anchors.verticalCenter: parent.verticalCenter

                iconUrl: {

                    ///console.log('Battery Percentage is: ' + screen_RaptorControlRoot.batteryPercent)
                    if(screen_RaptorControlRoot.batteryPercent <= 25)

                        return "file:///usr/share/BeaconOS-lib-images/images/BatteryLow_All.svg"
                    else if(screen_RaptorControlRoot.batteryPercent <= 50)
                        return "file:///usr/share/BeaconOS-lib-images/images/Battery25_All.svg"
                    else if(screen_RaptorControlRoot.batteryPercent <= 75)
                        return "file:///usr/share/BeaconOS-lib-images/images/Battery50_All.svg"
                    else if(screen_RaptorControlRoot.batteryPercent <= 80)
                        return "file:///usr/share/BeaconOS-lib-images/images/Battery75_All.svg"
                    else
                        return "file:///usr/share/BeaconOS-lib-images/images/Battery100_All.svg"
                }
                iconColor: "#00FF94"
            }

            Item {
                id: groupBars

                property int bars: screen_RaptorControlRoot.isNullSource ? 0 : screen_RaptorControlRoot.controllerSource.deviceSignal
                property color colorWeak: "#ffffff"
                property color colorStrong: "#00FF94"
                property real barWidth: width * 0.20

                height: parent.height * 0.50
                width: parent.width * ( 0.12 )
                anchors.verticalCenter: parent.verticalCenter

                Row {
                    anchors.fill: parent
                    spacing: 2

                    Rectangle {
                        anchors.bottom: parent.bottom

                        height: parent.height * 0.2
                        width: groupBars.barWidth

                        color: (groupBars.bars >= 1 ? groupBars.colorStrong : groupBars.colorWeak)
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom

                        height: parent.height * 0.4
                        width: groupBars.barWidth

                        color: (groupBars.bars >= 2 ? groupBars.colorStrong : groupBars.colorWeak)
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom

                        height: parent.height * 0.6
                        width: groupBars.barWidth

                        color: (groupBars.bars >= 3 ? groupBars.colorStrong : groupBars.colorWeak)
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom

                        height: parent.height * 0.8
                        width: groupBars.barWidth

                        color: (groupBars.bars >= 4 ? groupBars.colorStrong : groupBars.colorWeak)
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom

                        height: parent.height * 1.0
                        width: groupBars.barWidth

                        color: (groupBars.bars >= 5 ? groupBars.colorStrong : groupBars.colorWeak)
                    }
                }


            }
        }
    }

    Rectangle{
        id: rectEStopActiveDimmer
        visible: screen_RaptorControlRoot.isEStopArmed
        anchors{
            fill: parent
        }

        color: "#80000000"

        CompLabel{
            anchors.centerIn: parent

            text: "E-STOP ACTIVE"
        }

    }
}
