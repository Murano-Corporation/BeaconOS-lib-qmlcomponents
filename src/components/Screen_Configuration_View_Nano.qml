import QtQuick 2.15
import QtQuick.Controls 2.15

Screen_Configuration_View__BASE {
    id: screen_Configuration_View_Nano

    property bool isNanoConnected: Nano.isConnected
    property bool isPingOk: Nano.canPing
    property bool isSshOk: Nano.canSSH
    property bool isNanoReady: Nano.readyForUse
    property int iNanoState: 0
    property string sNanoMessage: ""


    property var netplanConfig: Nano.netplanDCConfig


    Component.onCompleted: {
        //Nano.initialize()

        //tmrDebug.start()
    }

    onIsNanoConnectedChanged: {
        if( !isNanoConnected )
        {
            return
        }

        dialogYesNo.close()
    }

    state: "Initialize"

    states: [
        State{
            id: stateInit
            name: "Initialize"
        },
        State{
            id: stateNetplan
            name: "Netplan"
        },
        State{
            id: stateMosquitto
            name: "Mosquitto"
        },
        State{
            id: stateBeaconBus
            name: "Beacon Bus"
        }
    ]

    Timer{
        id: tmrDebug

        interval: 5000

        onTriggered: {
            Nano.initialize()
        }
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



        function onSignal_StateChanged(iState)
        {
            screen_Configuration_View_Nano.iNanoState = iState
        }

        function onSignal_Message(sMessage)
        {
            screen_Configuration_View_Nano.sNanoMessage = sMessage
        }
    }

    DlgYesNo{
        id: dialogYesNo
    }

    Comp__BASE_Dialog{
        id: dialog

        title: "Please Connect a Nano to the System"
    }

    Loader{
        id: loaderDevTools

        anchors{
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        height: 60
        active: true
        sourceComponent: Item{
            Row{
                anchors.fill: parent
                spacing: 30
                Button{
                    id: btnInit


                    highlighted: screen_Configuration_View_Nano.state == "Initialize"

                    text: "Init"
                    onClicked: {
                        screen_Configuration_View_Nano.state = "Initialize"
                    }
                }

                Button{
                    id: btnNetplan

                    highlighted: screen_Configuration_View_Nano.state == "Netplan"


                    text: "Netplan"
                    onClicked: {
                        screen_Configuration_View_Nano.state = "Netplan"
                    }
                }

                Button{
                    id: btnMosquitto

                    highlighted: screen_Configuration_View_Nano.state == "Mosquitto"


                    text: "Mosquitto"
                    onClicked: {
                        screen_Configuration_View_Nano.state = "Mosquitto"
                    }
                }

                Button{
                    id: btnBeaconbus

                    highlighted: screen_Configuration_View_Nano.state == "Beacon Bus"


                    text: "Beacon Bus"
                    onClicked: {
                        screen_Configuration_View_Nano.state = "Beacon Bus"
                    }
                }

                CompLabel{
                    id: lblDCConfigNanoState

                    text: "State: " + iNanoState
                }

                CompLabel{
                    id: lblDCConfigNanoSMessage

                    text: "Message: " + sNanoMessage
                }

            }
        }
    }

    Item{
        id: areaContent

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: (loaderDevTools.active ? loaderDevTools.top : parent.bottom)
        }
    }

    Loader{
        id: loaderNanoConnectState

        anchors.fill: areaContent

        asynchronous: true
        active: screen_Configuration_View_Nano.state === "Initialize"

        sourceComponent:    Screen_Configuration_View_Nano_Connect {
            id: screen_Configuration_View_Nano_Connect
        }

    }

    Loader{
        id: loaderNanoConfigControls

        anchors.fill: areaContent
        asynchronous: true
        active: screen_Configuration_View_Nano.state === "Netplan"

        sourceComponent: Screen_Configuration_View_Nano_Netplan {
            id: screen_Configuration_View_Nano_Netplan
        }
    }

    Loader{
        id: loaderNanoMosquittoConfig

        anchors.fill: areaContent
        asynchronous: true
        active: screen_Configuration_View_Nano.state === "Mosquitto"

        sourceComponent: Screen_Configuration_View_Nano_Mosquitto {
            id: screen_Configuration_View_Nano_Mosquitto
        }

    }

    Loader{
        id: loaderNanoBeaconBusConfig

        anchors.fill: areaContent
        asynchronous: true
        active: screen_Configuration_View_Nano.state === "Beacon Bus"

        sourceComponent: Screen_Configuration_View_Nano_BeaconBus {
            id: screen_Configuration_View_Nano_BeaconBus
        }

    }

}
