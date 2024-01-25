import QtQuick 2.15

Item{
    id: compTableHeaderItem

    property alias text: lblText.text

    Rectangle{
        id: bgRect

        anchors{
            fill:parent
        }

        color: "#333958"
    }

    CompLabel{
        id: lblText

        horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"

        text: "%NAME ME%"
        font{
            pixelSize: 20
        }

        anchors{
            fill: parent
        }
    }
}
