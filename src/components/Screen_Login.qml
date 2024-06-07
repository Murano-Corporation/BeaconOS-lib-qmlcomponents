import QtQuick 2.12
import QtQuick.Controls 2.12

Screen__BASE {
    id: screenLoginRoot

    screenName: "Login"
    anchors.centerIn: parent

    signal passcodeEntered(string passcode)

    property int numPinEntry: 0
    property int loginPinLength: Settings.loginPinLength
    property int delayMoveIndex: 750
    property int delayInputVisible: 300

    property string passcodeCurrent: ''
    property string passkeyCurrent: ''
    property string passkeyLast: ''

    property CompAlphaNumericPinBtn currentPin: emptyPin
    property CompAlphaNumericPinBtn lastPin: emptyPin
    CompAlphaNumericPinBtn{
        id: emptyPin
        visible: false
        enabled: false
        text: "Empty"
    }
    Component.onCompleted: {

        MqttTopicCmdBRX.slot_Subscribe()
        SingletonScreenManager.clearBreadcrumbs()
    }

    onCurrentPinChanged: {

        if(currentPin.text !== lastPin.text && lastPin.text !== emptyPin.text)
        {
            if(tmrDelayMoveInputIndex.running)
            {
                tmrDelayMoveInputIndex.stop()

                passkeyLast = passkeyCurrent
                updatePasscode(passkeyLast)
            }
        }

        lastPin = currentPin
    }

    onPasskeyCurrentChanged: {
        if(passkeyCurrent === '')
        {
            return
        }
        tmrDelayInputVisible.restart()
        tmrDelayMoveInputIndex.restart()

    }


    Connections {
        target: SingletonInterfaceLogin
        function onSignal_OnPasscodeAccepted() {
            //console.log('LOGIN SUCCESS')
            SingletonScreenManager.slot_GoToScreen("Home", false)
        }
    }

    Connections {
        target: SingletonInterfaceLogin
        function onSignal_OnPasscodeRejected() {
            console.log('LOGIN DENIED')
            SingletonOverlayManager.slot_ShowMsgBoxInfo('Failed Login Attempt', 'Please re-enter the login pin')
            passcodeCurrent = ""
            numPinEntry = 0
        }
    }

    onPasscodeCurrentChanged: {
        if (passcodeCurrent.length === screenLoginRoot.loginPinLength) {
            //console.log('Submitting passcode: ' + passcodeCurrent)
            SingletonInterfaceLogin.slot_OnPasscodeEntered(passcodeCurrent)
        }
    }

    function onAlphaNumButtonclicked(pinBtn, passkey)
    {
        currentPin = pinBtn
        if(currentPin.text === emptyPin.text)
        {
            currentPin = pinBtn
        }
        passkeyCurrent = passkey
    }

    function updatePasscode(sPass){
        passkeyCurrent = ''
        passcodeCurrent += sPass
        numPinEntry = passcodeCurrent.length
        currentPin = emptyPin
        lastPin = emptyPin
    }

    Timer{
        id: tmrDelayMoveInputIndex

        interval: delayMoveIndex

        onTriggered: {
            //console.log('TIMER TRIGGERED Updating passcode to ' + passkeyCurrent)
            updatePasscode(passkeyCurrent)
        }
    }

    Timer{
        id: tmrDelayInputVisible

        interval: delayInputVisible
    }

    Item{

        anchors{
            centerIn: parent

        }

        height: childrenRect.height
        width: parent.width

        Image{
            id: imgBeaconLogo

            anchors{
                top: parent.top
                topMargin: 40
                //verticalCenter: parent.verticalCenter
                //horizontalCenter: parent.horizontalCenter
                left: parent.left
                right: parent.right
            }

            source: "file:///usr/share/BeaconOS-lib-images/images/Img_Beacon.png"
            fillMode: Image.PreserveAspectFit
            height: 300
            width: 75
            visible: !isDelta
            opacity: 1.0
            antialiasing: true
            smooth: true

            horizontalAlignment: Image.AlignHCenter
        }


        Label {
            id: lblEnterPin

            text: 'Enter PIN'
            color: "#F1F4F8"
            font {
                pixelSize: 50
                weight: Font.Light
                family: "Lato"
            }
            horizontalAlignment: "AlignHCenter"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: isDelta ? parent.top : imgBeaconLogo.bottom
            anchors.topMargin: isDelta ? 0 : 66
        }

        Row {
            id: rowInputIndicators
            spacing: 32
            anchors{
                horizontalCenter: parent.horizontalCenter
                top: lblEnterPin.bottom
                topMargin: isDelta ? 20 : 38
             }
            height: 32

            Repeater{
                model: screenLoginRoot.loginPinLength

                Rectangle {

                    property int assignedIndex: index

                    height: isDelta ? 32 : 45
                    width: height
                    radius: 0.5 * height

                    border.color: "#FFFFFF"
                    color: 'Transparent'

                    property bool isSet: numPinEntry >= (assignedIndex + 1)
                    onIsSetChanged: {
                        if(isSet === true)
                        {
                            //console.log('setting')
                            animSet.restart()
                        } else {
                            //console.log('clearing')
                            animClear.restart()
                        }
                    }

                    ColorAnimation on color{
                        id: animSet

                        running: false

                        to: "#FFFFFF"
                        duration: 200
                    }

                    ColorAnimation on color{
                        id: animClear
                        running: false
                        to: 'Transparent'
                        duration: 200
                    }

                    CompLabel{

                        visible: screenLoginRoot.numPinEntry === parent.assignedIndex && tmrDelayInputVisible.running

                        anchors{
                            centerIn: parent
                        }

                        text: visible ? screenLoginRoot.passkeyCurrent : ''
                        font{
                            pixelSize: 18
                        }
                    }
                }
            }

        }


        Grid {
            id: gridBtns
            spacing: 40
            rows: 4
            columns: 3
            anchors{
                top: rowInputIndicators.bottom
                topMargin: 64
                horizontalCenter: parent.horizontalCenter
            }
            CompAlphaNumericPinBtn {

                listOfOptions: ['1']

                maxPinLength: screenLoginRoot.loginPinLength
                numPinEntry: screenLoginRoot.numPinEntry
                currentPinBtn: screenLoginRoot.currentPin

                onAlphaNumPinClicked: function(txt) {
                    //console.log('Input key clicked; Text out: ' + txt)
                    screenLoginRoot.onAlphaNumButtonclicked(this, txt)

                }
            }

            CompAlphaNumericPinBtn {

                listOfOptions: ['2', 'A', 'B', 'C']

                maxPinLength: screenLoginRoot.loginPinLength
                numPinEntry: screenLoginRoot.numPinEntry
                currentPinBtn: screenLoginRoot.currentPin

                onAlphaNumPinClicked: function(txt) {
                    //console.log('Input key clicked; Text out: ' + txt)
                    screenLoginRoot.onAlphaNumButtonclicked(this, txt)
                }
            }

            CompAlphaNumericPinBtn {

                listOfOptions: ['3', 'D', 'E', 'F']

                maxPinLength: screenLoginRoot.loginPinLength
                numPinEntry: screenLoginRoot.numPinEntry
                currentPinBtn: screenLoginRoot.currentPin

                onAlphaNumPinClicked: function(txt)  {
                    //console.log('Input key clicked; Text out: ' + txt)
                    screenLoginRoot.onAlphaNumButtonclicked(this, txt)
                }
            }

            CompAlphaNumericPinBtn {

                listOfOptions: ['4', 'G', 'H', 'I']

                maxPinLength: screenLoginRoot.loginPinLength
                numPinEntry: screenLoginRoot.numPinEntry
                currentPinBtn: screenLoginRoot.currentPin

                onAlphaNumPinClicked: function(txt)  {
                    screenLoginRoot.onAlphaNumButtonclicked(this, txt)

                }
            }

            CompAlphaNumericPinBtn {

                listOfOptions: ['5', 'J', 'K', 'L']

                maxPinLength: screenLoginRoot.loginPinLength
                numPinEntry: screenLoginRoot.numPinEntry
                currentPinBtn: screenLoginRoot.currentPin

                onAlphaNumPinClicked: function(txt)  {
                    screenLoginRoot.onAlphaNumButtonclicked(this, txt)
                }
            }

            CompAlphaNumericPinBtn {

                listOfOptions: ['6', 'M', 'N', 'O']

                maxPinLength: screenLoginRoot.loginPinLength
                numPinEntry: screenLoginRoot.numPinEntry
                currentPinBtn: screenLoginRoot.currentPin

                onAlphaNumPinClicked: function(txt)  {
                    screenLoginRoot.onAlphaNumButtonclicked(this, txt)
                }
            }

            CompAlphaNumericPinBtn {

                listOfOptions: ['7', 'P', 'Q', 'R', 'S']

                maxPinLength: screenLoginRoot.loginPinLength
                numPinEntry: screenLoginRoot.numPinEntry
                currentPinBtn: screenLoginRoot.currentPin

                onAlphaNumPinClicked: function(txt)  {
                    screenLoginRoot.onAlphaNumButtonclicked(this, txt)
                }
            }

            CompAlphaNumericPinBtn {

                listOfOptions: ['8', 'T', 'U', 'V']

                maxPinLength: screenLoginRoot.loginPinLength
                numPinEntry: screenLoginRoot.numPinEntry
                currentPinBtn: screenLoginRoot.currentPin

                onAlphaNumPinClicked: function(txt)  {
                    screenLoginRoot.onAlphaNumButtonclicked(this, txt)
                    //console.log("txt = " + txt)
                    //console.log("screenLoginRoot.currentPin = " + screenLoginRoot.currentPin)
                    //console.log("screenLoginRoot.passkeyCurrent = " + screenLoginRoot.passkeyCurrent)
                }
            }

            CompAlphaNumericPinBtn {

                listOfOptions: ['9', 'W', 'X', 'Y', 'Z']

                maxPinLength: screenLoginRoot.loginPinLength
                numPinEntry: screenLoginRoot.numPinEntry
                currentPinBtn: screenLoginRoot.currentPin

                onAlphaNumPinClicked: function(txt)  {
                    screenLoginRoot.onAlphaNumButtonclicked(this, txt)
                }
            }

            Item {
                width: 64
                height: 64
            }

            CompAlphaNumericPinBtn {

                listOfOptions: ['0']

                maxPinLength: screenLoginRoot.loginPinLength
                numPinEntry: screenLoginRoot.numPinEntry
                currentPinBtn: screenLoginRoot.currentPin

                onAlphaNumPinClicked: function(txt)  {
                    screenLoginRoot.onAlphaNumButtonclicked(this, txt)
                }
            }

            CompIconBtn {

                iconUrl: "file:///usr/share/BeaconOS-lib-images/images/BackspaceFill.svg"
                iconColor: 'White'
                height: 120
                width: 120
                enabled: passcodeCurrent.length > 0

                onClicked: {

                    if (passcodeCurrent.length > 0) {

                        passcodeCurrent = passcodeCurrent.substring(0, passcodeCurrent.length - 1)
                        numPinEntry -= 1
                    }
                }
            }
        }



    }




}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.33;height:1080;width:1920}
}
##^##*/
