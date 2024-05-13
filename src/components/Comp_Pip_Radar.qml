import QtQuick 2.15
import QtQuick.Controls 2.15

Comp_Pip__BASE {
    id: component_Pip_Radar

    property color colorGridLineRadial: "#1AE3D1"
    property color colorGridLineAxial: "#1AE3D1"
    property color colorDetected: "#75FDF1"
    property int tickLength: 4
    property int tickOffset: 2
    property int gridLineWidth: 2
    property int gridLineRadialSpacing: component_Pip_Radar.height * 0.125

    dev_ShowRect: false


    Item {
        id: groupRadarVisualizer

        anchors{
            top: parent.top
            bottom: parent.bottom

            horizontalCenter: parent.horizontalCenter
        }

        width: height

        Rectangle{
            id: circleBg

            anchors.fill: parent

            color: "#80000000"

            radius: height * 0.5
        }

        Rectangle {
            id: circleOuter

            color: "transparent"
            border{
                width: component_Pip_Radar.gridLineWidth
                color: component_Pip_Radar.colorGridLineRadial
            }

            anchors.fill: parent
            anchors.margins: component_Pip_Radar.tickLength + component_Pip_Radar.tickOffset

            radius: width * 0.5
        }

        Rectangle {
            id: circleInner_1

            color: "transparent"
            border{
                width: component_Pip_Radar.gridLineWidth
                color: component_Pip_Radar.colorGridLineRadial
            }

            anchors.fill: circleOuter
            anchors.margins: component_Pip_Radar.gridLineRadialSpacing

            radius: width * 0.5
        }

        Rectangle {
            id: circleInner_2

            color: "transparent"
            border{
                width: component_Pip_Radar.gridLineWidth
                color: component_Pip_Radar.colorGridLineRadial
            }

            anchors.fill: circleInner_1
            anchors.margins: component_Pip_Radar.gridLineRadialSpacing

            radius: width * 0.5
        }

        Rectangle {
            id: circleInner_3

            color: "transparent"
            border{
                width: component_Pip_Radar.gridLineWidth
                color: component_Pip_Radar.colorGridLineRadial
            }

            anchors.fill: circleInner_2
            anchors.margins: component_Pip_Radar.gridLineRadialSpacing

            radius: width * 0.5
        }

    }

    Item{
        id: groupRadarSysInfo

        visible: !isPIPMode

        height: parent.height * 0.2
        anchors{
            left: parent.left
            top: parent.top
            right: groupRadarVisualizer.left

        }

        Rectangle{
            anchors.fill: parent
            color: "transparent"
            border{
                width: 1
                color: "white"
            }
        }

        CompLabel{
            id: lblRadarSysInfo

            text: "SYSTEM"

            anchors{
                top: parent.top
                left: parent.left
            }
        }
    }

    Item{
        id: groupRadarAlerts

        visible: !isPIPMode

        anchors{
            left: parent.left
            top: groupRadarSysInfo.bottom
            bottom:groupRadarCursorAndMarkerInfo.top
            right: groupRadarVisualizer.left

        }

        Rectangle{
            anchors.fill: parent
            color: "transparent"
            border{
                width: 1
                color: "white"
            }
        }

        CompLabel{
            id: lblRadarAlerts

            text: "ALERTS"

            anchors{
                top: parent.top
                left: parent.left
            }
        }
    }

    Item{
        id: groupRadarCursorAndMarkerInfo

        visible: !isPIPMode

        height: parent.height * 0.2
        anchors{
            left: parent.left
            bottom: parent.bottom
            right: groupRadarVisualizer.left

        }


        Rectangle{
            anchors.fill: parent

            color: "transparent"

            border{
                width: 1
                color: "white"
            }
        }

        CompLabel{
            id: lblCursoMarkerInfo

            text: "CURSOR INFO"

            anchors{
                top: parent.top
                left: parent.left
            }
        }
    }

    Item {
        id: groupRadarTargetList

        visible: !isPIPMode

        anchors {
            right: parent.right
            top: groupRadarOwnShipInfo.bottom
            bottom:groupRadarIndicators.top
            left: groupRadarVisualizer.right

        }

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border{
                width: 1
                color: "white"
            }
        }

        CompLabel {
            id: lblRadarTargetList

            text: "TARGETS"

            anchors{
                top: parent.top
                right: parent.right
            }
        }
    }

    Item {
        id: groupRadarOwnShipInfo

        visible: !isPIPMode

        height: parent.height * 0.2
        anchors{
            right: parent.right
            top: parent.top
            left: groupRadarVisualizer.right

        }

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border{
                width: 1
                color: "white"
            }
        }

        CompLabel {
            id: lblRadarOwnShipInfo

            text: "OWN SHIP INFO"

            anchors{
                top: parent.top
                right: parent.right
            }
        }
    }

    Item {
        id: groupRadarIndicators

        visible: !isPIPMode

        height: parent.height * 0.2
        anchors{
            right: parent.right
            bottom: parent.bottom
            left: groupRadarVisualizer.right

        }


        Rectangle{
            anchors.fill: parent

            color: "transparent"

            border{
                width: 1
                color: "white"
            }
        }

        CompLabel{
            id: lblRadaraIndicators

            text: "INDICATORS"

            anchors{
                top: parent.top
                right: parent.right
            }
        }
    }

}
