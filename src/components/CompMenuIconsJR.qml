import QtQuick 2.0

Item {
    id: compMenuIconJR_Root

    property alias textName: lblText.text
    property alias iconPathMain: imgMain.source
    property alias iconPathSub: imgSecondary.source
    property string iconPlacementSub: "Top-Right"

    CompLabel {
        id: lblText

        text: "DATA"
        color: "black"

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

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: lblText.top
            topMargin: 1
            rightMargin: 1
            leftMargin: 1
        }


        height: 6
        width: 8

        color: "blue"

    }

    Rectangle{
        anchors.fill: imgMain

        color: "blue"
    }

    CompImageIcon {
        id: imgSecondary

        source: "file:///usr/share/BeaconOS-lib-images/images/Electric.svg"
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




        height: 60
        width: 60


    }

    Rectangle{
        anchors.fill: imgSecondary

        color: "green"
    }
}
