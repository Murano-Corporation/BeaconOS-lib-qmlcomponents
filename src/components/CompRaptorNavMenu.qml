import QtQuick 2.0

Item {

    id: compRaptorNavMenuRoot
    property string selectedScreen: "Raptor"

    Column{
        id: col

        anchors.fill: parent
        spacing: 30

        CompRaptorNavMenuItem {
            id: menuItemRaptor
            opacity: compRaptorNavMenuRoot.selectedScreen === "Raptor" ? 1.0 : 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Icon_Raptor.svg"

            onClicked: compRaptorNavMenuRoot.selectedScreen = "Raptor"
        }
        CompRaptorNavMenuItem {
            id: menuItemControl
            opacity: compRaptorNavMenuRoot.selectedScreen === "Control" ? 1.0 : 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Control.svg"

            onClicked: compRaptorNavMenuRoot.selectedScreen = "Control"
        }
        CompRaptorNavMenuItem {
            id: menuItemFlightPlanner
            opacity: compRaptorNavMenuRoot.selectedScreen === "FlightPlanner" ? 1.0 : 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/FlightPlannerIcon.svg"

            onClicked: compRaptorNavMenuRoot.selectedScreen = "FlightPlanner"
        }
        CompRaptorNavMenuItem {
            id: menuItem3DReconstruction
            opacity: compRaptorNavMenuRoot.selectedScreen === "3DReconstruction" ? 1.0 : 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/3DReconstruction.svg"

            onClicked: compRaptorNavMenuRoot.selectedScreen = "3DReconstruction"
        }
    }

}
