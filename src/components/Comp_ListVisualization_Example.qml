import QtQuick 2.0

Item {

    height: 1080
    width: 1920


    GridView{
        anchors.fill: parent

        cellHeight: 55
        cellWidth: 360

        model: ListModel{

            ListElement{
                name: "DATA"
                sourceMain: "/usr/share/BeaconOS-lib-images/images/paper.png"
                sourceSub: "/usr/share/BeaconOS-lib-images/images/plane.png"
                subPosition: "Top-Right"


            }

            ListElement{
                name: "PLAN"
                sourceMain: "/usr/share/BeaconOS-lib-images/images/paper.png"
                sourceSub: "/usr/share/BeaconOS-lib-images/images/plane.png"
                subPosition: "Top-Right"
            }

            ListElement{
                name: "SETUP"
                sourceMain: "/usr/share/BeaconOS-lib-images/images/paper.png"
                sourceSub: "/usr/share/BeaconOS-lib-images/images/plane.png"
                subPosition: "Top-Right"
            }

            ListElement{
                name: "CONFIG"
                sourceMain: "/usr/share/BeaconOS-lib-images/images/paper.png"
                sourceSub: "/usr/share/BeaconOS-lib-images/images/plane.png"
                subPosition: "Top-Right"
            }


            ListElement{
                name: "SIMULATION"
                sourceMain: "/usr/share/BeaconOS-lib-images/images/paper.png"
                sourceSub: "/usr/share/BeaconOS-lib-images/images/plane.png"
                subPosition: "Top-Right"
            }

            ListElement{
                name: "HELP"
                sourceMain: "/usr/share/BeaconOS-lib-images/images/paper.png"
                sourceSub: "/usr/share/BeaconOS-lib-images/images/plane.png"
                subPosition: "Top-Right"
            }

        }


        delegate: CompMenuIconsJR{

            textName: model.name
        }


    }


}
