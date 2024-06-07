import QtQuick 2.15
import QtQuick.Controls 2.15
Comp__BASE {
    id: tlRoot

    property alias textSpeed: tlButton.text

    property bool isCurrent: false

    //signal clicked ???

    CompButton {
        id: tlButton

        anchors.fill: tlRoot
        textObject.font.pixelSize: root.pixelSize
        fontColor: root.fontColor1
        backgroundColor: isCurrent ? "darkGreen" : root.boxColor1
        backgroundRect.radius: 10

        MouseArea {
            anchors.fill: parent

            onPressed: {
                parent.opacity = 0.8
            }
            onReleased: {
                parent.opacity = 1.0
                tlRoot.clicked()
            }
            onExited: {
                parent.opacity = 1.0
            }
        }
    }
}
