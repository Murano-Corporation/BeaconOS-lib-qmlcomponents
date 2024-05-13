import QtQuick 2.15
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import CONSTANTS 1.0

Item {
    id: screen_Configuration_View_Nano_BeaconBus

    //property var yamlRootNode: Nano.beaconbusYamlRoot

    //CompLabelledTextEdit{
    //    id: dev_TextEdit

    //    height: 90

    //    text: "File Path"
    //    value: "/home/murano/beaconbus_write_test_qml.yaml"

    //}

    Item{
        id: areaNode

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: areaControls.top
        }
    }


    TreeView {
        id: treeView
        anchors.fill: areaNode

        TableViewColumn {
            title: "Key"
            role: "key"
            width: 600
        }

        TableViewColumn {
            title: "Value"
            role: "value"
            width: 100
        }

        //contentItem.anchors.leftMargin: 60

        style: TreeViewStyle {
            branchDelegate: Rectangle {

                height: 60
                width: 60

                color: styleData.isExpanded ? "green" : "blue"

                border {
                    color: "black"
                    width: 2
                }

                x: 60
            }
        }

        model: TableModelYaml

        rowDelegate: Rectangle {
            height: 60

            color: (styleData.alternate ? "#80000000" : "#80ffffff")
        }

        itemDelegate: Item {

            height: 60

            CompTextField {
                property var modelIndex: styleData.index
                ///member name = modelIndex
                ///read function = var getModelIndex();
                ///write function = void setModeilIndex(var newIndex);

                property string lastValue

                visible: (styleData.column === 1 && styleData.value !== "" && !styleData.hasChildren)

                height: parent.height

                text: styleData.value ? styleData.value : ""
                lblText: ""

                backgroundRect {
                    color: (styleData.alternate ? "#80ffffff" : "#80000000")
                }

                onTextChanged: {
                    if(lastValue === text || !modelIndex || styleData.column !== 1)
                        return;

                    lastValue = text
                    treeView.model.setData( modelIndex, text,  Constants.DataRole_Value)
                }

                //verticalAlignment: Text.AlignVCenter

                //font{
                //    family: "Lato"
                //    pointSize: 24
                //}

                //color: "Black"

            }

            CompLabel {
                text: styleData.value ? styleData.value : ""

                visible: styleData.column === 0

                color: "black"
                height: parent.height

                verticalAlignment: Text.AlignVCenter
                leftPadding: styleData.column === 0 ? 90 : 0
                // Rectangle {
                //    id: rectExpander

                //    visible: styleData.hasChildren && (styleData.column === 0)

                //    height: 60
                //    width: 60

                //    color: styleData.isExpanded ? "Green" : "Purple"

                //    anchors {
                //        left: parent.left
                //    }

                //    MouseArea {
                //        anchors.fill: parent

                //        onClicked: styleData.isExpanded ? treeView.collapse(styleData.index) : treeView.expand(styleData.index)
                //    }
                // }
            }


        }

    }

    Item{
        id: areaControls

        anchors{
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        height: 60

        Row{
            anchors.fill: parent
            spacing: 60
            Button{
                id: btnRestore

                text: "READ"

                height: 60

                onClicked: {
                    Nano.beaconbus_ReadConfigFile()
                }

            }

            Button{
                id: btnSave

                height: 60

                text: "WRITE"

                onClicked: {
                    //TableModelYaml.setWritePath( dev_TextEdit.value );
                    Nano.beaconbus_WriteConfigFile()
                }
            }
        }
    }
}
