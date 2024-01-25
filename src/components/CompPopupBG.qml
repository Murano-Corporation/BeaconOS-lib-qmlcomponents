import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: compPopupBGRoot

    property alias colorBG: rectBG.color
    property alias radiusBG: rectBG.radius
    property alias dropShadowXOffset: efxDropShadow.horizontalOffset
    property alias dropShadowYOffset: efxDropShadow.verticalOffset
    property alias dropShadowRadius: efxDropShadow.radius
    property bool showDropShadow: true

    anchors.fill: parent

    Rectangle{
        id: rectBG
        visible: !compPopupBGRoot.showDropShadow
        radius: 16

        color: "#1C2533"

        anchors.fill: parent
    }

    DropShadow{
        id: efxDropShadow

        visible: compPopupBGRoot.showDropShadow

        source: rectBG

        anchors{
            fill: rectBG
        }

        verticalOffset: 0
        horizontalOffset: 0
        radius: 8.0
        samples: 17
    }

}
