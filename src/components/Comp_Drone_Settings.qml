import QtQuick 2.15

Comp__BASE{ //scaleable, switch font sizes
    id: root

    height: 80
    width: 200

    property color fontColor: "white"
    property color outerBorderColor: "#0E1111"
    property color innerColor: "#065465"

    property int fontSize: 30

    Rectangle {
        id: rect

        height: root.height
        width: root.width
        //anchors.fill: parent
        anchors.centerIn: parent
        color: root.innerColor
        border.color: root.outerBorderColor
        radius: 20

        Text {
            id: settingsText

            text: "SETTINGS"
            font.pixelSize: root.fontSize
            color: root.fontColor
            anchors.centerIn: parent
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onEntered: {
            rect.opacity = 0.8
            rect.width *= 0.95
            rect.height *= 0.95
            fontSize = 28

        }
        onExited: {
            rect.opacity = 1.0
            rect.width = root.width
            rect.height = root.height
            fontSize = 30
        }
        onClicked: {
            console.log("Call Settings funct")
        }
    }
}
