import QtQuick 2.12

Comp__BASE_Label {
    id: lblScreenName

    text: "Asset Dashboard"
    property alias fontWeight: lblScreenName.font.weight
    property alias fontFamily: lblScreenName.font.family
    property alias fontPixelSize: lblScreenName.font.pixelSize

    fontPixelSize: 25
    fontWeight: Font.Normal
    fontFamily: "Lato"

    opacity: enabled ? 1.0 : 0.3
    color: "White"
    //elide: Text.ElideRight

}
