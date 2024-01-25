import QtQuick 2.12
import QtQuick.Controls 2.12

Label {
    id: lblScreenName

    text: "Asset Dashboard"

    font.pixelSize: 50
    font.family: "Lato"
    font.weight: Font.Normal

    opacity: enabled ? 1.0 : 0.3
    color: "White"
    //elide: Text.ElideRight

}
