import QtQuick 2.15

Comp__BASE_Popup{
    id: popupRaptorControlQuickCommands

    height: 600
    width: 400

    modal: false

    signal openPopup_Parameters()

    Column {
        anchors.fill: parent
        anchors.margins: 20

        CompBtnBreadcrumb {
            id: btn_Arm

            text: "ARM Drone"

            onClicked: {
                DroneController.sendCommand_Arm()
                popupRaptorControlQuickCommands.close()
                popupRaptorControlPrearmChecks.open()
            }
        }

        CompBtnBreadcrumb{
            id: btn_Disarm

            text: "DISARM Drone"

            onClicked: DroneController.sendCommand_Disarm()
        }

        CompBtnBreadcrumb{
            id: btn_RestartFlightController

            text: "RESTART Flight Control"

            onClicked: DroneController.sendCommand_FlightController_Restart();
        }

        CompBtnBreadcrumb {
            id: btn_ShowMessages

            text: "Messages"

            onClicked: {
                popupRaptorControlQuickCommands.close();
                popupRaptorControlMessages.open();}
        }

        CompBtnBreadcrumb {
            id: btn_ShowManualCommands

            text: "Manual CMDs"

            onClicked: {
                popupRaptorControlQuickCommands.close();
                popupRaptorControlManualCommand.open();
            }
        }

        CompBtnBreadcrumb {
            id: btn_ShowParameterEntry

            text: "Set Params"

            onClicked: {
                popupRaptorControlQuickCommands.close();
                popupRaptorControlParamSeter.open();
            }
        }

        CompBtnBreadcrumb {
            id: btn_ShowParameterViewer

            text: "View Params"

            onClicked: {
                popupRaptorControlQuickCommands.close();
                popupRaptorControlQuickCommands.openPopup_Parameters()
            }
        }
    }
}
