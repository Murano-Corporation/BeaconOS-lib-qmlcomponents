import QtQuick 2.15

Comp__BASE {
    id:sMain
    height: 38
    width: 326

    Row {
        spacing: 5

        CompButton{
            id: sLow
            height: 22
            width: 33

            font{
                font.pixelSize: 16
                text: "Low"
            }
        }

        CompButton{
            id: sMedium
            height: 22
            width: 33

            font {
                font.pixelSize: 16
                text: "Mid"
            }
        }

        CompButton{
            id: sHigh
            height: 22
            width: 33

            font {
                font.pixelSize: 16
                text: "High"
            }
        }

        CompButton{
            id: sToggle
            height: 22
            width: 10

            font {
                font.pixelSize: 16
                text: "Toggle"
            }
        }

        TextInput {
            id: sNum
            height: 22
            width: 11

            font {
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "blue"
            }

            anchors{
                top: sMain.top
                bottom: sMain.bottom
            }

        }
        TextInput {
            id: sMin
            height: 11
            width: 38.5

            font {
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "green"
            }

            anchors{
                top: sMain.top
                bottom: sMain.bottom
            }
        }
        TextInput {
            id: sMax
            height: 11
            width: 27.5

            font {
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "red"
            }

            anchors{
                top: sMain.top
                bottom: sMain.bottom
            }
        }
    }
}
