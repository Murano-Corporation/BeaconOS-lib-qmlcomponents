import QtQuick 2.15

Screen__BASE {
    id: screen_Drone_RoutePlanner_Root

    CompMapViewer{
        id: mapView

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: droneMissionViewer.top
        }
    }

    Comp_Drone_MissionViewer{
        id: droneMissionViewer

        height: 400

        anchors{
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
}
