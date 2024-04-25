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

                Button{
                    id: btnInit


                    highlighted: screen_Configuration_View_Nano.state == stateInit.name

                    text: "Init"
                    onClicked: {
                        screen_Configuration_View_Nano.state = "Initialize"
                    }
                }

                Button{
                    id: btnNetplan

                    highlighted: screen_Configuration_View_Nano.state == stateNetplan.name


                    text: "Netplan"
                    onClicked: {
                        screen_Configuration_View_Nano.state = "Netplan"
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

    Loader{
        id: loaderNanoConnectState

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: (loaderDevTools.active ? loaderDevTools.top : parent.bottom)
        }
        asynchronous: true
        active: screen_Configuration_View_Nano.state === "Initialize"

        sourceComponent:    Column{
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

    Loader{
        id: loaderNanoConfigControls

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: (loaderDevTools.active ? loaderDevTools.top : parent.bottom)
        }
        asynchronous: true
        active: screen_Configuration_View_Nano.state === "Netplan"

        sourceComponent: Item{


            Connections{
                target: screen_Configuration_View_Nano

                function onNetplanConfigChanged() {

                    if(screen_Configuration_View_Nano.state !== stateNetplan.name)
                    {
                        return
                    }

                    console.log("INCOMING DC CONFIG ENABLED?: " + screen_Configuration_View_Nano.netplanConfig.enabled)
                    lblDCConfigEnabled.isOn = screen_Configuration_View_Nano.netplanConfig.enabled
                    lblDCConfigAssetAddress.value = screen_Configuration_View_Nano.netplanConfig.assetAddress
                    lblDCConfigNanoAddress.value = screen_Configuration_View_Nano.netplanConfig.nanoAddress
                }
            }

            Column{
                anchors{
                    top: parent.top
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }

                spacing: 30

                CompToggle{
                    id: lblDCConfigEnabled

                    text: "Direct Connect Enabled: " + Nano.netplanDCConfig.enabled
                    isOn: false
                }

                CompLabelledTextEdit{
                    id: lblDCConfigNanoAddress

                    text: "Direct Connect Nano Address: "
                    value: "---"
                }

                CompLabelledTextEdit{
                    id: lblDCConfigAssetAddress

                    text: "Direct Connect Asset Address: "
                    value: "---"
                }

                Button{
                    id: btnReadConfig

                    text: "Read"

                    onClicked:{
                        Nano.netplan_ReadConfigFile()
                    }
                }

                Button{
                    id: btnWriteConfig

                    text: "Write"

                    onClicked:{

                        var outGoingNetplanConfig = Nano.getNetplanDCConfig()

                        console.log("DC CONFIG ENABLED?: " + lblDCConfigEnabled.isOn)
                        outGoingNetplanConfig.enabled = lblDCConfigEnabled.isOn
                        console.log("DC CONFIG ENABLED 2?: " + outGoingNetplanConfig.enabled)
                        outGoingNetplanConfig.nanoAddress = lblDCConfigNanoAddress.value
                        outGoingNetplanConfig.assetAddress = lblDCConfigAssetAddress.value

                        Nano.netplan_WriteConfig(outGoingNetplanConfig)
                    }
                }
            }

        }
    }

}
