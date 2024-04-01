import QtQuick 2.0

Item{
    id: popup_Settings_System

    property alias title: lblTitle.text
    property alias spacingOutter: colContents.spacing

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
                    }

                    textEdit{
                        text: "Beacon OS Delta"
                    }
                }

                CompLabelledTextEdit {
                    id: textOsVersion

                    width: parent.width

                    label{
                        text: "Beacon OS Version:"
                    }

                    textEdit{
                        text: "v0.1.2.3"
                    }
                }

                CompLabelledTextEdit {
                    id: textDeviceName

                    width: parent.width

                    label{
                        text: "Device Name:"
                    }

                    textEdit{
                        text: "Delta 2"
                    }
                }

                CompLabelledTextEdit {
                    id: textBeaconBuxRxVersion

                    width: parent.width

                    label{
                        text: "BeaconBusRx Version:"
                    }

                    textEdit{
                        text: "v0.1.2"
                    }
                }
            }



        }

    }


}
