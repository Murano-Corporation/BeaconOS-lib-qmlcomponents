import QtQuick 2.15

Comp__BASE {
    id: compMenuIconJR_Root

    property alias textName: lblText.text
    property alias iconPathMain: imgMain.source
    property alias iconPathSub: imgSecondary.source
    property string iconPlacementSub: "Top-Right"

    height: 53
    width: 55

    CompLabel {
        id: lblText

        text: "DATA"
        color: "black"
        fontPixelSize: 14

        horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignBottom"

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right

            bottomMargin: 1
            rightMargin: 1
            leftMargin: 1
        }

    }

    CompImageIcon {
        id: imgMain
        height: 32
        width: 40
        color: "blue"

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: lblText.top
            topMargin: 10
            rightMargin: 10
            leftMargin: 10
        }
    }

    // Rectangle{
    //     anchors.fill: imgMain

    //     color: "blue"
    // }

    CompImageIcon {
        id: imgSecondary
        height: 20
        width: 26
        //source: "file:///usr/share/BeaconOS-lib-images/images/Electric.svg"
        color: "green"
        //sourceSize
        //{
        //    height: imgSecondary.height
        //    width: imgSecondary.width
        //}
        ////color: "Black"

        anchors{
            top: (compMenuIconJR_Root.iconPlacementSub === "Top-Left" || compMenuIconJR_Root.iconPlacementSub === "Top-Right") ? parent.top : undefined
            left: (compMenuIconJR_Root.iconPlacementSub === "Top-Left" || compMenuIconJR_Root.iconPlacementSub === "Bottom-Left") ? parent.left : undefined
            bottom: (compMenuIconJR_Root.iconPlacementSub === "Bottom-Left" || compMenuIconJR_Root.iconPlacementSub === "Bottom-Right") ? parent.bottom : undefined
            right: (compMenuIconJR_Root.iconPlacementSub === "Top-Right" || compMenuIconJR_Root.iconPlacementSub === "Bottom-Right") ? parent.right : undefined

            margins: 20
        }
    }

    // Rectangle{
    //     anchors.fill: imgSecondary
    //     color: "green"
    // }
}
