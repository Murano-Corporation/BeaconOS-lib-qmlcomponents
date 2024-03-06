import QtQuick 2.12
import QtGraphicalEffects 1.12

Comp__BASE {
    id: compGlassRectRoot

    opacity: 0.5
    property alias border: borderImg.border
    property alias sourceSize: borderImg.sourceSize

    anchors{
        fill: parent
    }


    BorderImage {
        id: borderImg
        source: "file:/usr/share/BeaconOS-lib-images/images/RoundedRect_599x377.png"

        anchors{
            fill: parent
        }

        border.left: 20; border.top: 20
        border.right: 20; border.bottom: 20
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.5;height:480;width:640}
}
##^##*/
