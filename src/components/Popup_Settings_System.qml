import QtQuick 2.0

Comp__BASE{
    id: popup_Settings_System

    property alias title: lblTitle.text
    property alias spacingOutter: colContents.spacing
    property real dataSize: 28
    property alias sizeofText: popup_Settings_System.dataSize
    property alias labelTitle: lblTitle

    height: 60

    Column{
        id: colContents

        spacing: 20

        anchors{
            fill: parent
        }

        CompLabel{
            id: lblTitle

            text: "System"

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom

            height: 40
            width: parent.width
        }

        CompPopupBG{
            id: bg
            width: parent.width
            height: parent.height - parent.spacing - lblTitle.height

            anchors.fill: undefined

            Column{
                id: areaContent

                spacing: 20

                anchors{
                    fill: parent
                    margins: bg.radiusBG
                }

                CompLabelledTextEdit {
                    id: textOsName

                    width: parent.width

                    label{
                        text: "Beacon OS Name:"
                        font.pixelSize: popup_Settings_System.dataSize
                    }

                    textEdit{
                        text: "Beacon OS Delta"
                        font.pixelSize: popup_Settings_System.dataSize
                    }
                }

                CompLabelledTextEdit {
                    id: textOsVersion

                    width: parent.width

                    label{
                        text: "Beacon OS Version:"
                        font.pixelSize: popup_Settings_System.dataSize
                    }

                    textEdit{
                        text: "v0.1.2.3"
                        font.pixelSize: popup_Settings_System.dataSize
                    }
                }

                CompLabelledTextEdit {
                    id: textDeviceName

                    width: parent.width

                    label{
                        text: "Device Name:"
                        font.pixelSize: popup_Settings_System.dataSize
                    }

                    textEdit{
                        text: "Delta 2"
                        font.pixelSize: popup_Settings_System.dataSize
                    }
                }

                CompLabelledTextEdit {
                    id: textBeaconBuxRxVersion

                    width: parent.width

                    label{
                        text: "BeaconBusRx Version:"
                        font.pixelSize: popup_Settings_System.dataSize
                    }

                    textEdit{
                        text: "v0.1.2"
                        font.pixelSize: popup_Settings_System.dataSize
                    }
                }
            }



        }

    }


}
