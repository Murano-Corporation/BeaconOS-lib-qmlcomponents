import QtQuick 2.15

Screen__BASE {
    id: root

    height: 1080
    width: 1920

    screenName: "Drone"
    property color bgColor: "#000435"
    property color droneBorderColor: "#000068"
    property color droneCamColor: "grey"

    Rectangle {
        id: bgColor

        anchors.fill: root
        color: root.bgColor
        radius: 20
    }

    Rectangle {
        id: droneCam

        height: root.height * 0.98
        width: root.width * 0.98
        border.color: root.droneBorderColor
        anchors.centerIn: root
        radius: 20
        color: root.droneCamColor

    }

    Comp_Drone_Gimble{
        id: stick1

        opacity: 0.6
        x: root.width * 0.025
        y: root.height * 0.54
        isThrottle: true
    }
    Comp_Drone_Gimble{
        id: stick2

        opacity: 0.6
        x: root.width * 0.975 - (stick2.width)
        y: root.height * 0.54
        isThrottle: false
    }
    Comp_Drone_Switch{
        id: switch1

        opacity: 0.6
        x: root.width * 0.04
        y: root.height * 0.29
    }
    Comp_Drone_Switch{
        id: switch2

        opacity: 0.6
        x: root.width * 0.11
        y: root.height * 0.29
    }
    Comp_Drone_Switch{
        id: switch3

        opacity: 0.6
        x: root.width * 0.89 - (switch3.rectWidth)
        y: root.height * 0.29
        tripleMode: true
    }
    Comp_Drone_Switch{
        id: switch4

        opacity: 0.6
        x: root.width * 0.96 - (switch4.rectWidth)
        y: root.height * 0.29
    }
    Comp_Drone_Dial{
        id: dial1

        opacity: 0.6
        x: root.width * 0.063
        y: root.height * 0.15
    }
    Comp_Drone_Dial{
        id: dial2

        opacity: 0.6
        x: root.width * 0.937 - (dial2.width)
        y: root.height * 0.15
    }
    Comp_Drone_Settings{
        id: settings

        opacity: 0.6
        x: root.width * 0.855
        y: root.height * 0.036
    }
}
