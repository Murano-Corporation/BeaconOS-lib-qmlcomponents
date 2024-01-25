import QtQuick 2.12
import QtQuick.Controls 2.12

ScrollView {
    

    property real scrollBarHorizontalPos: ScrollBar.horizontal.position
    property real scrollBarVerticalPos: ScrollBar.vertical.position

    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
}
