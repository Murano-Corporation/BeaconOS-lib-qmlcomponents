import QtQuick 2.15
import QtQuick.Controls 2.15

Row{
    id: compCheckableLabelledTextEdit

    property alias propertyName: edtConnectionName.lblText
    property alias text: edtConnectionName.text
    property alias checked: chkboxConnecitonName.checked

    spacing: 60
    height: 60


    CheckBox{
        id: chkboxConnecitonName
        text: "Enabled?"

        anchors.verticalCenter: parent.verticalCenter
    }


    CompTextField{
        id: edtConnectionName
        enabled: chkboxConnecitonName.checked
        lblWidth: 250

        height: parent.height
    }

}
