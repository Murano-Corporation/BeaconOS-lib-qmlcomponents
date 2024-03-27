import QtQuick 2.12
import QtQuick.Controls 2.15

Item{
    id: compSwitch

    property color colorOn: "#9287ED"
    property color colorOff: "#80000000"

    property color colorCurrent: colorOff
    property bool isOn: false


    height: 60
    state: "off"
    width: 114

    states: [
        State{
            name: "on"
            when: compSwitch.isOn
            PropertyChanges {
                target: compSwitch

                colorCurrent: compSwitch.colorOn

            }

            PropertyChanges {
                target: rectHandle

                x: compSwitch.width - rectHandle.width - rectBg_Toggle_State.anchors.margins

            }
        },
        State{
            name: "off"
            when: !compSwitch.isOn
            PropertyChanges {
                target: compSwitch

                colorCurrent: compSwitch.colorOff

            }

            PropertyChanges {
                target: rectHandle

                x: 0 + rectBg_Toggle_State.anchors.margins

            }
        }
    ]

    Rectangle{
        id: rectBg_Toggle

        anchors{
            fill: parent
        }

        color: "#80000000"

        radius: 0.5 * height

        Rectangle{
            id: rectBg_Toggle_State

            anchors{
                fill: parent
                margins: 6
            }

            radius: 0.5 * height

            color: compSwitch.colorCurrent
        }
    }

    Rectangle{
        id: rectHandle

        height: rectBg_Toggle_State.height
        width: 1.25 * height

        radius: 0.5 * height

        anchors.verticalCenter: rectBg_Toggle.verticalCenter

        color: "#D9D9D9"

        Behavior on x{
            NumberAnimation{
                duration: 250
            }
        }
    }

    MouseArea{
        anchors.fill: parent

        onClicked: compToggle.isOn = !compToggle.isOn
    }
}
