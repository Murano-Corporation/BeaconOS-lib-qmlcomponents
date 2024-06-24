import QtQuick 2.15
import QtQuick.Controls 2.15

Comp__BASE{
    id: comp_Terminal

    Rectangle{
        id: rectBG

        anchors.fill: parent

        color: "black"

        radius: 10

        border{
            width: 2
            color: "green"
        }
    }

    TextArea{

        anchors{
            fill: rectBG
            margins: rectBG.radius + rectBG.border.width
        }

        color: "green"

    }
}
