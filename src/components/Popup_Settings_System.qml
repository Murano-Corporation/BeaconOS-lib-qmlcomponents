import QtQuick 2.0

Comp__BASE{
    id: popup_Settings_System

    property alias title: lblTitle.text
    property alias spacingOutter: colContents.spacing
    property bool isDelta: base.isDelta

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
            font.pixelSize: isDelta ? 25 : 60
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

    }


}
