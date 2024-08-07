import QtQuick 2.15
import QtQuick.Controls 2.12


Screen_Raptor__BASE {
    id: screen_RaptorControlRoot

    property string beaconIDSelected: ""
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
    property bool mapON: true
    property bool dataON: true
    property bool lblFlightModeOn: false
    property bool miniMapToggle: false
    property bool drawerLeftClosed: (drawerDeviceInfoControl.position < 0.01)
    property bool drawerRightClosed: (drawerDroneGridMenuControl.position < 0.01)
    property bool drawerRightVisible: drawerDroneGridMenuControl.visible
    property var gimbal1Struct: DroneController.gimbalA
    property var gimbal2Struct: DroneController.gimbalB
    property var detectionInfo: DroneController.detectionInfo
    property real batteryPercent: DroneController.deviceBattery
    signal signalBeaconIDSelected(var beaconID)

    onBeaconIDSelectedChanged: {
        for (var i = 0; i < TableModelRaptorMap.length; i++) {
            if (beaconIDSelected === TableModelRaptorMap[i].Beacon_ID) {
                selectedItem = TableModelRaptorMap[i]
            }
        }
    }

    readonly property string eSTATE_NO_ASSET_SELECTED: "State-No Asset Selected"
    readonly property string eSTATE_CONNECTING: "State-Connecting"
    readonly property string eSTATE_CONNECTED: "State-Connected"


    state: eSTATE_NO_ASSET_SELECTED
    onStateChanged: {
        //console.log('Drone Connection State is now: ' + state)
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

    Item {
        id: deviceScreen

        width: 1920
        height: 1080

        x: 0
        y: 0
        z: miniMapToggle ? 0 : 1

        enabled: miniMapToggle ? false : true
        visible: miniMapToggle ? false : true

        Item {
            id: compTargetBoundingBox1

            visible: DroneController.watchdogOk && screen_RaptorControlRoot.detectionInfo.valid && screen_RaptorControlRoot.hudON

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: 70
            }

            Rectangle{
                anchors.top: parent.top
                color: "#00FF94"
                height: 2
                width: 270
                radius: 16
            }
            Rectangle{
                anchors.left: parent.left
                color: "#00FF94"
                height: 123
                width: 2
                radius: 16
            }

            Rectangle{
                anchors.top: parent.top
                anchors.right: parent.right
                color: "#00FF94"
                height: 2
                width: 270
                radius: 16
            }
            Rectangle{
                anchors.right: parent.right
                color: "#00FF94"
                height: 123
                width: 2
                radius: 16
            }

            Rectangle{
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                color: "#00FF94"
                height: 2
                width: 270
                radius: 16
            }

            Rectangle{
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                color: "#00FF94"
                height: 123
                width: 2
                radius: 16
            }

            Rectangle{
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                color: "#00FF94"
                height: 2
                width: 270
                radius: 16
            }
            Rectangle{
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                color: "#00FF94"
                height: 123
                width: 2
                radius: 16
            }
        }

        Item {
            id: areaAltimeter
            visible: screen_RaptorControlRoot.hudON && screen_RaptorControlRoot.beaconIDSelected !== ""//&& DroneController.watchdogOk

            anchors.centerIn: parent

            transform: Scale {
                xScale: 0.8
                yScale: 0.8
            }

            Comp_Raptor_Altimeter{
                id: attitudeMeter
                anchors.centerIn: parent
                height: 700
                width: 700

                Connections{
                    target: DroneController

                    function onSignal_YawChanged(){
                        attitudeMeter.compassAngle = DroneController.yaw
                    }

                    function onSignal_PitchChanged(){
                        attitudeMeter.tiltAngle = DroneController.pitch
                    }

                    function onSignal_RollChanged(){
                        attitudeMeter.rollAngle = DroneController.roll
                    }
                }
            }
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

        PopupRaptorControlParameterView {
            id: popupRaptorControlParameterView
        }

        CompLabel{
            id: lblFlightMode

            visible: lblFlightModeOn //&& DroneController.watchdogOk

            text: "Sys. State: " + DroneController.sSystemState + "; - Flight Mode: " + DroneController.flightMode + "; - Land State: " + DroneController.sLandedState + "; - GPS Fix Type: " + DroneController.sGpsFixType + "; GPS Sats: " + DroneController.gpsSatellitesAvailable
            fontPixelSize: 22

            anchors {
                top: parent.top
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }

            Rectangle{
                anchors.fill: parent
                //anchors.margins: -10
                opacity: 0.6
                radius: 10
                z: -1

                color: "#80000000"
            }
        }

        Drawer{
            id: drawerDroneGridMenuControl

            interactive: (beaconIDSelected === "") ? false : true
            visible: (beaconIDSelected !== "" && !miniMapToggle && screen_Raptor_Delta_Root.bButtonLayout) ? true : false

            closePolicy: Popup.NoAutoClose
            dim: false
            modal: false

            width: 220
            height: 578
            edge: Qt.RightEdge
            y: 250

            rightPadding: 10

            onVisibleChanged: {
                if (!drawerDroneGridMenuControl.visible) {
                    console.log("Drawer is closed")
                    bButtonLayout = false
                }
                else {
                    console.log("Drawer is open")
                    bButtonLayout = true
                }
            }

            CompBtnBreadcrumb{
                anchors.fill: parent
                visible: (beaconIDSelected !== "" && !miniMapToggle && screen_Raptor_Delta_Root.bButtonLayout) ? true : false
            }
            background: Rectangle {
                color: "transparent"
            }
            leftPadding: 10

            CompRaptorDroneGridView{ //ALL DRONE BUTTON FUNCTIONALITY ISSUES HERE
                id: compRaptorDroneGridView

                visible: (beaconIDSelected !== "" && !miniMapToggle && screen_Raptor_Delta_Root.bButtonLayout) ? true : false

                transform: Scale {
                    xScale: 0.8
                    yScale: 0.8
                }

                anchors{
                    top: parent.top
                    topMargin: 20
                    right: parent.right
                    rightMargin: -58
                }
            }
        }

        CompImageIcon{
            id: openRightGridViewControl

            visible: drawerRightClosed && (beaconIDSelected !== "")
            height: 578
            width: 48
            opacity: 0.6

            anchors{
                right: deviceScreen.right
                verticalCenter: parent.verticalCenter
            }

            source: "file:///usr/share/BeaconOS-lib-images/images/RightOpen.svg"

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    console.log("OPENING EXTRA BUTTONS DRAWER!!!")
                    if (drawerDroneGridMenuControl.visible === true) {
                        drawerDroneGridMenuControl.visible = false
                        drawerDroneGridMenuControl.visible = true
                    }
                    else {
                        drawerDroneGridMenuControl.visible = true
                    }

                    console.log("Drawer open status after:", drawerDroneGridMenuControl.visible);
                }
            }
        }

        Comp_Drone_Gimble{
            id: stick1

            isThrottle: true
            visible: screen_RaptorControlRoot.controlON && beaconIDSelected !== ""//&& DroneController.watchdogOk
            opacity: 0.3

            anchors {
                left: parent.left
                leftMargin: 770
                bottom: parent.bottom
                bottomMargin: 10
            }

            onJoystickXValueChanged: {
                setGimbal1Values(joystickXValue, joystickYValue)
            }

            onJoystickYValueChanged: {
                setGimbal1Values(joystickXValue, joystickYValue)
            }
        }
        Comp_Drone_Gimble{
            id: stick2

            isThrottle: false
            visible: screen_RaptorControlRoot.controlON && beaconIDSelected !== ""//&& DroneController.watchdogOk
            opacity: 0.3

            anchors {
                right: parent.right
                rightMargin: 770
                bottom: parent.bottom
                bottomMargin: 10
            }

            onJoystickXValueChanged: {
                setGimbal2Values(joystickXValue, joystickYValue)
            }

            onJoystickYValueChanged: {
                setGimbal2Values(joystickXValue, joystickYValue)
            }
        }

        Rectangle {
            id:deviceData

            visible: screen_RaptorControlRoot.beaconIDSelected !== "" && screen_RaptorControlRoot.dataON//&& DroneController.watchdogOk
            height: openRightGridViewControl.height
            width: 390
            color: "transparent"
            radius: 20

            anchors {
                right: parent.right
                verticalCenter: openRightGridViewControl.verticalCenter
                rightMargin: (drawerDroneGridMenuControl.position > 0.7) ? 220 : 155
            }

            Rectangle{
                anchors.fill: parent
                opacity: 0.6
                radius: 10
                z: -1
                color: "#80000000"
            }
            Column{
                id: row

                anchors{
                    centerIn: parent
                }

                spacing: 20

                CompLabel{
                    id: lblDevData

                    text: "Device Data"
                    fontPixelSize: 30
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter

                    anchors{
                        topMargin: 50
                        left: parent.left
                    }
                }

                Row{
                    spacing: 20
                    anchors.left: parent.left

                    CompLabel{
                        id: deviceFlightRemaining

                        text: screen_RaptorControlRoot.beaconIDSelected ? DroneController.flightRemaining : ""
                        fontPixelSize: 22
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
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
                        iconColor: "white"
                    }
                    Row{
                        spacing: 20
                        Item {
                            id: groupBars

                            visible: false

                            property int bars: DroneController.deviceSignal
                            property color colorWeak: "#ffffff"
                            property color colorStrong: "#ffffff"
                            property real barWidth: width * 0.20

                            height: parent.height * 0.50
                            width: parent.width * ( 0.12 )
                            anchors.horizontalCenter: parent.horizontalCenter

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
                CompLabel {
                    id: areaSelfCoordinates

                    text: screen_RaptorControlRoot.beaconIDSelected ? dispText : ""

                    anchors.left: parent.left

                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: "white"

                }
                CompLabel{
                    id: lblTarData

                    text: "Target Data"
                    fontPixelSize: 30
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors{
                        topMargin: 50
                        left: parent.left
                    }
                }
                CompLabel{
                    id: lblSampleData1

                    text: "Sample Data 1 : Sample Value 1"
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                CompLabel{
                    id: lblSampleData2

                    text: "Sample Data 2 : Sample Value 2"
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                CompLabel{
                    id: lblSampleData3

                    text: "Sample Data 3 : Sample Value 3"
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                CompLabel{
                    id: lblSampleData4

                    text: "Sample Data 4 : Sample Value 4"
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                CompLabel{
                    id: lblSampleData5

                    text: "Sample Data 5 : Sample Value 5"
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        Drawer{
            id: drawerDeviceInfoControl

            height: 780
            width: 415
            closePolicy: Popup.NoAutoClose
            dim: false
            modal: false
            edge: Qt.LeftEdge
            y: 140
            leftPadding: 10

            CompBtnBreadcrumb{
                anchors.fill: parent
            }
            background: Rectangle {
                color: "#00000000"
            }

            Comp_Device_Info{
                id: deviceInfo

                anchors.fill: parent
                anchors.topMargin: 20

                listofDevices: TableModelRaptorMap

                onSignalBeaconIDChanged: (bid)=>{
                                             console.log("Signal " + bid + " caught")

                                             screen_RaptorControlRoot.beaconIDSelected = bid
                                             signalBeaconIDSelected(bid)
                                             drawerDroneGridMenuControl.open()
                                         }
            }
        }

        CompImageIcon{
            id: openLeftDeviceInfoControl

            height: 578
            width: 48
            opacity: 0.6
            visible: drawerLeftClosed

            anchors{
                left: deviceScreen.left
                verticalCenter: parent.verticalCenter
            }

            source: "file:///usr/share/BeaconOS-lib-images/images/LeftOpen.svg"

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    console.log("Drawer open status before:", drawerDeviceInfoControl.visible);
                    console.log("OPENING DEVICE INFO DRAWER!!!")

                    if (drawerDeviceInfoControl.visible === true) {
                        drawerDeviceInfoControl.visible = false
                        drawerDeviceInfoControl.visible = true
                    }
                    else {
                        drawerDeviceInfoControl.visible = true
                    }

                    console.log("Drawer open status after:", drawerDeviceInfoControl.visible);
                }
            }
        }


    }

    Image {
        id: imageCameraFeed
        visible: screen_RaptorControlRoot.beaconIDSelected !== ""
        source: "image://drone-camera/" + DroneController.imageProviderFrameId

        height: miniMapToggle ? 216 : 1080
        width: miniMapToggle ? 360 : 1920
        x: miniMapToggle ? 100 : 0
        y: miniMapToggle ? 850 : 0
        z: miniMapToggle ? 1 : 0
    }

    MouseArea {
        id: miniMapMouseArea

        enabled: hudON && drawerLeftClosed && beaconIDSelected !== ""

        height: 216
        width: 360
        x: 100
        y: 850
        z: 2

        onClicked: {
            miniMapToggle = !miniMapToggle
        }
    }

    CompMapViewer{
        id: miniMap

        visible: mapON && drawerLeftClosed && beaconIDSelected !== ""
        enabled: mapON && drawerLeftClosed && beaconIDSelected !== ""

        height: !miniMapToggle ? 216 : 1080
        width: !miniMapToggle ? 360 : 1920
        x: !miniMapToggle ? 100 : 0
        y: !miniMapToggle ? 850 : 0
        z: !miniMapToggle ? 1 : 0

        showMapTypes: false

        Component.onCompleted: {
            setZoomLevel(15.0)
        }
        activeMapTypeIndex: 4
        listAssets: TableModelRaptorMap
    }
}
