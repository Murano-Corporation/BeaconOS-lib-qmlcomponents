import QtQuick 2.12
import QtGraphicalEffects 1.0
import CONSTANTS 1.0

Screen__BASE {
    anchors.fill: parent

    screenName: "Welcome"

    property bool isReadyToProceed: false
    property bool startProcessComplete: false
    property int iStartupStep: -1

    Component.onCompleted: {
        tmrDelay1.start()
        animateText1.start()
    }

    function startupProcesses_Start() {
        console.log("Startup processes running...")
        iStartupStep = -1

        Processes.signal_Started.connect(onProcessStarted)
        Processes.signal_Finished.connect(onProcessFinished)
        Processes.signal_ErrorOccurred.connect(onProcessError)

        //startupProcesses_Step()
        startupProcesses_Complete()
    }

    function startupProcesses_Step() {
        iStartupStep += 1

        if (iStartupStep === 0) {
            Processes.executeProcess(0)
        } else if (iStartupStep === 1) {
            Processes.executeProcess(3)
        } else {
            startupProcesses_Complete()
        }
    }

    function startupProcesses_Complete() {
        if (startProcessComplete === true)
            return

        startProcessComplete = true

        tmrDelay2.running = true
        SingletonScreenManager.slot_StartupProcessesComplete(true)
    }

    function onProcessStarted(eID) {
        console.log("Process started: " + eID)
    }

    function onProcessError(eID, eErr) {
        console.log("Process errored: " + eID + " :: err: " + eErr)
    }

    function onProcessFinished(eID, iExitCode, eExitState) {
        console.log("Process finished: " + eID,
                    +" :: exit Code: " + iExitCode + " :: exit state: " + eExitState)
        startupProcesses_Step()
    }

    Timer {
        id: tmrDelay1
        interval: 500
        onTriggered: animBeaconLogo.running = true
    }

    OpacityAnimator {
        id: animBeaconLogo
        target: colContents
        from: 0
        to: 0.7

        duration: 500

        onFinished: {
            tmrDelay_StartupProcesses.running = true
        }
    }

    Timer {
        id: tmrDelay_StartupProcesses
        interval: 250
        onTriggered: startupProcesses_Start()
    }

    Timer {
        id: tmrDelay2
        interval: 250
        onTriggered: animContinueButtn.running = true
    }

    OpacityAnimator {
        id: animContinueButtn
        target: iconNext
        from: 0
        to: 0.55

        duration: 500

        onFinished: isReadyToProceed = true
    }

    Timer {
        id: tmrDelay3
        interval: 250
        onTriggered: animMuranoCorpText.running = true
    }

    Timer {
        id: tmrDelay4
        interval: 250
        onTriggered: animFadeOutScreen.running = true
    }

    PropertyAnimation {
        id: animFadeOutScreen
        target: rootContents
        property: "opacity"
        from: 1.0
        to: 0.0
        duration: 1200

        onFinished: {
            tmrDelay5.start()
        }
    }

    Timer {
        id: tmrDelay5
        interval: 1000
        onTriggered: {
            console.log("GOING TO LOGIN SCREEN")
            SingletonScreenManager.slot_GoToScreen("Login", false)
        }
    }

    Item {
        id: rootContents

        anchors.fill: parent

        Item {
            id: colContents

            anchors.centerIn: parent

            anchors.verticalCenterOffset: -20

            height: imgBeaconOs.y + imgBeaconOs.height
            opacity: 0.0

            Image {
                id: imgBeaconLog

                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                }

                source: "file:///usr/share/BeaconOS-lib-images/images/Img_Beacon.png"
                fillMode: Image.PreserveAspectFit
                height: 340 * 0.75
                //width: lblBeaconOs.width
                visible: true
                opacity: 1.0
                antialiasing: true
                smooth: true

                horizontalAlignment: Image.AlignHCenter
            }

            CompLabel {
                id: lblBeaconOs

                visible: false

                property string beaconOsFull: "BEACON OS"
                property string beaconOsLblCurrent: beaconOsFull.slice(
                                                        0,
                                                        beaconOsLblMaxVisChars)
                property int beaconOsLblMaxVisChars: 0

                anchors {
                    top: imgBeaconLog.bottom
                    topMargin: 75
                    horizontalCenter: imgBeaconLog.horizontalCenter
                }

                text: beaconOsLblCurrent

                font {
                    family: 'ethnocentric'
                    weight: Font.Light
                    pixelSize: 80
                }
            }

            Image {
                id: imgBeaconOs
                visible: !lblBeaconOs.visible

                opacity: 1.0

                anchors {
                    top: imgBeaconLog.bottom
                    topMargin: 60
                    horizontalCenter: parent.horizontalCenter
                }

                width: 377 * 1.1
                height: 33 * 1.1

                source: "file:///usr/share/BeaconOS-lib-images/images/BEACON_OS_Logo_Asset.svg"
                sourceSize: Qt.size(width, height)
            }
            CompLabel {
                id: lblclicktoproceed

                //y: 735
                visible: true

                anchors {
                    top: imgBeaconOs.bottom
                    topMargin: 75
                    horizontalCenter: parent.horizontalCenter
                }

                text: "Click to Proceed"
                anchors.horizontalCenterOffset: 0

                font {
                    family: 'Lato'
                    weight: Font.Light
                    pixelSize: 30
                }
            }

            PropertyAnimation {
                id: animateText1
                target: lblclicktoproceed
                property: "opacity"
                from: 1.0
                to: 0
                duration: 1000
                onFinished: animateText2.start()
            }
            Timer {
                id: animationDelay
                interval: 2000
                onTriggered: animateText1.start()
            }
            PropertyAnimation {
                id: animateText2
                target: lblclicktoproceed
                property: "opacity"
                from: 0
                to: 1.0
                duration: 1000
                onFinished: animationDelay.start()
            }
        }

        Image {

            id: iconNext

            anchors {
                right: parent.right
                rightMargin: 25

                bottom: parent.bottom
                bottomMargin: 50
            }

            source: 'file:///usr/share/BeaconOS-lib-images/images/RightFill.svg'

            width: 64
            height: 64
            opacity: 0

            visible: false
        }
    }

    MouseArea {

        //        Rectangle{
        //            anchors.fill: parent

        //            color: "#8000ff00"
        //        }

        //visible: isReadyToProceed
        anchors {
            fill: parent
        }

        onClicked: {
            console.log("CLICKING!!!!")
            tmrDelay4.start()
        }
    }
}
