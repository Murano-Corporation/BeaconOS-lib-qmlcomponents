import QtQuick 2.15

Comp__BASE {
    id: afMain
    height: 24
    width: 252

    Row {
        spacing: 5

        Comp__BASE_ComboBox {
            id: afDropDown
            height: 24
            width: 134
        }
        CompButton{
            id: afLow
            height: 24
            width: 30

            font{
                font.pixelSize: 16
                text: "Low"
            }
        }

        CompButton{
            id: afMedium
            height: 24
            width: 30

            font {
                font.pixelSize: 16
                text: "Mid"
            }
        }

        CompButton{
            id: afHigh
            height: 24
            width: 30

            font {
                font.pixelSize: 16
                text: "High"
            }
        }
    }
}
