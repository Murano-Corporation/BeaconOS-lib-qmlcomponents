import QtQuick 2.12

import QtQuick.Controls 2.12
import Qt.labs.qmlmodels 1.0

Rectangle{
    id: compHealthDashboardUnhandledType

    height: gridView.cellHeight - 61
    width: gridView.cellWidth - 75
    radius: 16

    color: "#80ffff00";

    CompLabel{
        anchors{
            centerIn: parent
        }

        text: qsTr("UNHANDLED DATA TYPE\n" + model.data_type)
        font{
            pixelSize: 12
        }
    }
}
