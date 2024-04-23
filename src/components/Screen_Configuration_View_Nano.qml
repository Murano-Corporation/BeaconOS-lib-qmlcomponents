import QtQuick 2.0
import QtQuick.Controls 2.12

Screen_Configuration_View__BASE {
    id: screen_Configuration_View_Nano

    property bool isNanoConnected: Nano.isConnected
    property bool isPingOk: Nano.canPing
    property bool isSshOk: Nano.canSSH
    property bool isNanoReady: Nano.readyForUse

    Component.onCompleted: {
        Nano.initialize()
    }

    Connections{
        target: Nano

        function onSignal_RequestUserConnectNano() {
            dialogYesNo.headerText = "Connect a Nano"
            dialogYesNo.bodyText = "Please connect a Nano to the Delta via a USB to USB-Micro Cable."
            dialogYesNo.yesText = "Nano Connected";
            dialogYesNo.noText = "Cancel"

            dialogYesNo.funcOnNo = function(){
                Nano.userCancelled();
            }

            dialogYesNo.funcOnYes = function(){
                Nano.userAck_ConnectNano(true);
            }

            dialogYesNo.open()
        }
    }

    DlgYesNo{
        id: dialogYesNo
    }

    Comp__BASE_Dialog{
        id: dialog

        title: "Please Connect a Nano to the System"
    }

    Column{
        width: 600

        anchors{
            top: parent.top
            bottom: parent.bottom
            centerIn: parent
        }

        CompLabel{
            id: lblNanoConnected

            text: "Nano Connected: " + (isNanoConnected ? "TRUE" : "FALSE")
            color: isNanoConnected ? "Green" : "Red"
        }

        CompLabel{
            id: lblNanoPingable

            text: "Nano Pingable: " + (isPingOk ? "TRUE" : "FALSE")
            color: isPingOk ? "Green" : "Red"
        }

        CompLabel{
            id: lblNanoSshAble

            text: "Nano SSH OK?: " + (isSshOk ? "TRUE" : "FALSE")
            color: isSshOk ? "Green" : "Red"
        }

        CompLabel{
            id: lblNanoReady

            text: "Nano Ready?: " + (isNanoReady ? "TRUE" : "FALSE")
            color: isNanoReady ? "Green" : "Red"
        }
    }
}
