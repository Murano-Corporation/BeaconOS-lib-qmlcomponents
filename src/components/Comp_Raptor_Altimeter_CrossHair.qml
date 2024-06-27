import QtQuick 2.15

Rectangle {
    id: compRaptorAltimeterCrossHairRoot

    height: 40
    width: 436
    //border.color: "lightgreen"
        color: "transparent"
    Image {
        id: crosshairImage
        //z: 0

        source: "file:///usr/share/BeaconOS-lib-images/images/Crosshair.svg"
    }

}
