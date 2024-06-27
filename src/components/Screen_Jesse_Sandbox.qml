import QtQuick 2.15

Screen__BASE {
    id: jesseroot

    screenName: "Jesse: Sandbox"
    height: 1080
    width: 1920

    Comp_Raptor_Altimeter {
        id: comp_Raptor_Altimeter

        height: 653
        width: 653

        anchors.centerIn: parent
    }



    // Comp_Raptor_Menu_SideBars {
    //     id: menuSidebars

    //     x: jesseroot.width * 0.01
    //     y: jesseroot.height * 0.05
    // }

    // Comp_Raptor_Menu_BottomBars {
    //     id: menuBottombars

    //     anchors.horizontalCenter: jesseroot.horizontalCenter
    //     y: jesseroot.height * 0.88
    // }

    // Rectangle {
    //     id: leftCrossHairText

    //     x: (jesseroot.width / 2) - (leftCrossHairText.width / 2) - 330
    //     y: crosshair.y - 22

    //     height: 50
    //     width: 200

    //     color: "transparent"
    //     Text {
    //         anchors.verticalCenter: parent.verticalCenter
    //         horizontalAlignment: Text.AlignRight
    //         color: "green"
    //         text: "test"
    //         font.pixelSize: 36
    //         font.family: "Lato"
    //     }

    //     //color: "yellow"
    // }
}
