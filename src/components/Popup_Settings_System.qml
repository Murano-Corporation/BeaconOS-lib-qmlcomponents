import QtQuick 2.0

Popup_Settings_View__BASE {
    id: popup_Settings_System

    height: 60
    viewName: "System Settings"

    Column{
        id: areaContent

        spacing: 20

        anchors{
            fill: contents
            margins: contentsBgRadius
        }

        CompLabelledTextEdit {
            id: textOsName

            width: parent.width

            label{
                text: "Beacon OS Name:"
                font.pixelSize: isDelta ? 28 : 40
            }

            textEdit{
                text: "Beacon OS Delta"
                font.pixelSize: isDelta ? 28 : 40
            }
        }

        CompLabelledTextEdit {
            id: textOsVersion

            width: parent.width

            label{
                text: "Beacon OS Version:"
                font.pixelSize: isDelta ? 28 : 40
            }

            textEdit{
                text: "v0.1.2.3"
                font.pixelSize: isDelta ? 28 : 40
            }
        }

        CompLabelledTextEdit {
            id: textDeviceName

            width: parent.width

            label{
                text: "Device Name:"
                font.pixelSize: isDelta ? 28 : 40
            }

            textEdit{
                text: "Delta 2"
                font.pixelSize: isDelta ? 28 : 40
            }
        }

        CompLabelledTextEdit {
            id: textBeaconBuxRxVersion

            width: parent.width

            label{
                text: "BeaconBusRx Version:"
                font.pixelSize: isDelta ? 28 : 40
            }

            textEdit{
                text: "v0.1.2"
                font.pixelSize: isDelta ? 28 : 40
            }
        }
    }




}
