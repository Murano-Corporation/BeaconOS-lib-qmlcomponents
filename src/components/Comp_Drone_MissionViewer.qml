import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0

Comp__BASE {
    id: comp_Drone_MissionViewer_ROOT


    Item{
        id: areaControls_Top

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: 60

        Row{
            id: rowControls_Top

            anchors.fill: parent

            RoundButton{
                text: "+"

                height: parent.height
                width: height
            }
        }
    }

    TableView{
        id: tableView_Main

        anchors{
            top: areaControls_Top.bottom
            left: areaControls_Top.left
            right: areaControls_Top.right
            bottom: parent.bottom
        }


        //Rectangle{
        //    width: parent.width
        //    height: 60

        //    color: "green"
        //    z: -1
        //}

        model: TableModel{

            TableModelColumn{ display: "ID"}
            TableModelColumn{ display: "Command"}
            TableModelColumn{ display: "P1"}
            TableModelColumn{ display: "P2"}
            TableModelColumn{ display: "P3"}
            TableModelColumn{ display: "P4"}
            TableModelColumn{ display: "Lat"}
            TableModelColumn{ display: "Lon"}
            TableModelColumn{ display: "Alt"}
            TableModelColumn{ display: "Frame"}
            TableModelColumn{ display: "Delete"}
            TableModelColumn{ display: "UNKNOWN_1"}
            TableModelColumn{ display: "UNKNOWN_2"}
            TableModelColumn{ display: "Grad"}
            TableModelColumn{ display: "Angle"}
            TableModelColumn{ display: "Dist"}
            TableModelColumn{ display: "AZ"}

            rows: [
                {

                    Command: "Lift-Off",
                    P1: "a",
                    P2: "b",
                    P3: "c",
                    P4: "d",
                    Lat: 70.0,
                    Lon: -30.0,
                    Alt: 100.0,
                    Frame: 0,
                    Delete: false,
                    UNKNOWN_1: "?",
                    UNKNOWN_2: "??",
                    Grad: 0.5,
                    Angle: 0.8,
                    Dist: 100,
                    AZ: "???"
                },
                {

                    Command: "Lift-Off",
                    P1: "a",
                    P2: "b",
                    P3: "c",
                    P4: "d",
                    Lat: 70.0,
                    Lon: -30.0,
                    Alt: 100.0,
                    Frame: 0,
                    Delete: false,
                    UNKNOWN_1: "?",
                    UNKNOWN_2: "??",
                    Grad: 0.5,
                    Angle: 0.8,
                    Dist: 100,
                    AZ: "???"
                }

            ]
        }

        delegate: delChooser


        DelegateChooser{
            id: delChooser

            role: "display"

            DelegateChoice{
                column: 0

                CompLabel{

                    text: model.row + 1
                    padding: 12
                    color: "black"
                }

            }

            DelegateChoice{


                CompLabel{

                    text: model.display
                    padding: 12
                    color: "black"
                }
            }


        }

        Row {
            id: columHeader

            y: tableView_Main.contentY
            z: 2

            Repeater {
                model: 16

                Rectangle{

                    property int col: index

                    width: isDelta ? 625 : 450
                    height: isDelta ? 52 : 100

                    color: "#333958"

                    //Connections{
                    //    target: tableView
                    //
                    //    function onColumnWidthsUpdated(){
                    //        width = tableView.listOfColumnWidthsCurrent[index]
                    //    }
                    //}

                    Rectangle{
                        anchors{
                            left: parent.left
                            top: parent.top
                            bottom: parent.bottom
                        }

                        width: (parent.col === 0 ? 2 : 1)
                        color: tableView_Main.gridLineColor
                    }

                    Rectangle{

                        anchors{
                            right: parent.right
                            top: parent.top
                            bottom: parent.bottom
                        }

                        width: ((parent.col === (tableView.columns - 1)) ? 2 : 1)
                        color: tableView_Main.gridLineColor
                    }

                    Rectangle{

                        anchors{
                            right: parent.right
                            left: parent.left
                            top: parent.top

                        }

                        height: 2
                        color: tableView_Main.gridLineColor
                    }

                    Rectangle{

                        anchors{
                            right: parent.right
                            left: parent.left
                            bottom: parent.bottom

                        }

                        height: 2
                        color: tableView_Main.gridLineColor
                    }

                    CompLabel{

                        anchors{
                            fill: parent
                        }

                        //text: tableView_Main.model ? tableView_Main.model.headerData(modelData, Qt.Horizontal) : ""
                        font{
                            pixelSize: isDelta ? 20 : 35
                        }

                        horizontalAlignment: "AlignHCenter"
                        verticalAlignment: "AlignVCenter"
                    }

                }


            }
        }
    }

}
