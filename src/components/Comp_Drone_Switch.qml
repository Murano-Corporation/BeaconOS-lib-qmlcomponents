import QtQuick 2.15

Comp__BASE { //not scaleable yet
    id: root

    height: 308
    width: 84

    property color outerColor: "grey"
    property color outerBorderColor: "#0E1111"
    property color innerColor: "#065465"
    property int rectHeight: 220
    property int rectWidth: 60

    property int circleSwitchX: -(circleSwitch.width / 2) + (outerRect.width / 2)

    property int circleSwitchHighY: (root.rectHeight - circleSwitch.height) * 0.05
    property int circleSwitchLowY: (root.rectHeight - circleSwitch.height) * 0.95
    property int circleSwitchMidY: (root.rectHeight - circleSwitch.height) / 2

    property bool isOn: false

    property bool tripleMode: false //false is doubleMode //CHANGE THIS

    property int threeMode: 1 //starts at low is 1; mid is 2, 3 is high

    Rectangle {
        id: outerRect

        height: root.rectHeight
        width: root.rectWidth
        color: root.outerColor
        border.color: root.outerBorderColor
        radius: 20

        MouseArea {
            anchors.fill: parent
            onPressed: {
                if (tripleMode === false) {
                    if (root.isOn === true) {
                        circleSwitch.y = circleSwitchLowY
                        root.isOn = false
                        console.log("Off")
                    }
                    else {
                        circleSwitch.y = circleSwitchHighY
                        root.isOn = true
                        console.log("On")
                    }
                }
                else {
                    if (root.threeMode === 1) {
                        root.threeMode = 2
                        circleSwitch.y = circleSwitchMidY
                        console.log("Mid")
                    }
                    else if (root.threeMode === 2) {
                        root.threeMode = 3
                        circleSwitch.y = circleSwitchHighY
                        console.log("High")
                    }
                    else {
                        root.threeMode = 1
                        circleSwitch.y = circleSwitchLowY
                        console.log("Low")
                    }
                }
            }
        }
    }

    Rectangle {
        id: circleSwitch

        color: root.innerColor
        border.color: root.outerBorderColor
        height: root.rectWidth * 1.4
        width: root.rectWidth * 1.4
        radius: 100

        x: root.circleSwitchX
        y: root.circleSwitchLowY
    }
}
