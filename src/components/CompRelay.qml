import QtQuick 2.15

Comp__BASE {
    id:rMain
    height: 7
    width: 42

    Row {
        spacing: 5

        CompButton{
            id: rLow
            height: 22
            width: 33

            font{
                font.pixelSize: 16
                text: "Low"
            }
        }

        CompButton{
            id: srHigh
            height: 22
            width: 33

            font {
                font.pixelSize: 16
                text: "High"
            }
        }

        CompButton{
            id: srToggle
            height: 22
            width: 55

            font {
                font.pixelSize: 16
                text: "Toggle"
            }
        }

        TextInput {
            id: srNum
            height: 22
            width: 55

            font {
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "blue"
            }

            anchors{
                top: srMain.top
                bottom: srMain.bottom
            }

        }
    }

}
