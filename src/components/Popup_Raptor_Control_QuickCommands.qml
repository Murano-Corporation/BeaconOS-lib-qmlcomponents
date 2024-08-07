import QtQuick 2.15

Comp__BASE_Popup{
    id: popupRaptorControlQuickCommands

    property bool droneArmed: false

    height: 600
    width: 570
    compBaseRadius: 20

    modal: false

    signal openPopup_Parameters()

    CompPopupBG {
        id: bg
        anchors.fill: parent

        // Rectangle {
        //     anchors.fill: parent
        //     color: "blue"
        // }

        Grid{

            //anchors.fill: parent
            height: popupRaptorControlQuickCommands.height * 0.733
            width: popupRaptorControlQuickCommands.width * 0.737

            anchors.centerIn: parent
            columns: 2
            rows: 3
            columnSpacing: parent.width * 0.18
            rowSpacing: parent.height * 0.06

            CompRaptorNavMenuItem{
                id: btn_ArmDisArm

                width: popupRaptorControlQuickCommands.width * 0.28
                height: popupRaptorControlQuickCommands.height * 0.2

                imgIconSrc: droneArmed ? "file:///usr/share/BeaconOS-lib-images/images/Armed.svg" : "file:///usr/share/BeaconOS-lib-images/images/DisArmed.svg"

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        console.log("armed/disarmed")
                        if (!droneArmed) {
                            DroneController.sendCommand_Arm()
                            popupRaptorControlQuickCommands.close()
                            popupRaptorControlPrearmChecks.open()
                        }
                        else {
                            DroneController.sendCommand_Disarm()
                        }
                        droneArmed = !droneArmed
                    }
                }
            }

            CompRaptorNavMenuItem{
                id: btn_RestartFlightController

                width: popupRaptorControlQuickCommands.width * 0.28
                height: popupRaptorControlQuickCommands.height * 0.2

                imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Refresh.svg"

                MouseArea {
                    anchors.fill: parent

                    onClicked:{
                        console.log("restart")
                        DroneController.sendCommand_FlightController_Restart();
                    }
                }
            }

            CompRaptorNavMenuItem{
                id: btn_ShowMessages

                width: popupRaptorControlQuickCommands.width * 0.28
                height: popupRaptorControlQuickCommands.height * 0.2

                imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/MessageCMD.svg"

                MouseArea {
                    anchors.fill: parent

                    onClicked:{
                        popupRaptorControlQuickCommands.close();
                        popupRaptorControlMessages.open();}
                }
            }
            CompRaptorNavMenuItem{
                id: btn_ShowManualCommands

                width: popupRaptorControlQuickCommands.width * 0.28
                height: popupRaptorControlQuickCommands.height * 0.2

                imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/ManualCMD.svg"

                MouseArea {
                    anchors.fill: parent

                    onClicked:{
                        popupRaptorControlQuickCommands.close();
                        popupRaptorControlManualCommand.open();
                    }
                }
            }
            CompRaptorNavMenuItem{
                id: btn_ShowParameterEntry

                width: popupRaptorControlQuickCommands.width * 0.28
                height: popupRaptorControlQuickCommands.height * 0.2

                imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/SetParam.svg"

                MouseArea {
                    anchors.fill: parent

                    onClicked:{
                        popupRaptorControlQuickCommands.close();
                        popupRaptorControlParamSeter.open();
                    }
                }
            }
            CompRaptorNavMenuItem{
                id: btn_ShowParameterViewer

                width: popupRaptorControlQuickCommands.width * 0.28
                height: popupRaptorControlQuickCommands.height * 0.2

                imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/ViewParam.svg"

                MouseArea {
                    anchors.fill: parent

                    onClicked:{
                        popupRaptorControlQuickCommands.close();
                        popupRaptorControlQuickCommands.openPopup_Parameters()
                    }
                }
            }
        }
    }
}
