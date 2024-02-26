import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: compHealthDashboardContentMTConnect

    property bool canShowGraphView: view === 'Graph' && graphViewTarget !== 'null'
    property var listOfHeaders: ["Name", "Value", "Units","Min", "Max"]
    property var listOfParams: TableModelHealthDashboard
    property string graphViewTarget: 'null'
    property string graphViewUnits: "UNITS"
    property string view: "List"
    property var dataModel: TableModelMTConnect

    signal forceViewType(string viewType)
    signal forceViewModeMaximized()
    signal setGridBtnVisible(bool isVisible);
    signal setListBtnVisible(bool isVisible);
    signal paramSelected(string paramName);


    Item{
        id: groupFilters

        property real comboSpacing: 17
        property real comboWidth: ((width - (comboSpacing * 3)) * 0.25)
        property real comboHeight: 41
        property real comboFontPixelSize: 20

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: comboCategory.height

        CompCombobox {
            id: comboCategory

            anchors{
                top: parent.top
                left: parent.left
            }

            width: parent.comboWidth
            height: parent.comboHeight

            displayText: qsTr("Category")
            fontPixelSize: parent.comboFontPixelSize
        }

        CompCombobox {
            id: comboSample

            anchors{
                top: comboCategory.top
                left: comboCategory.right
                leftMargin: parent.comboSpacing
            }

            width: comboCategory.width
            height: comboCategory.height

            displayText: qsTr("Sample")
            fontPixelSize: comboCategory.fontPixelSize
        }

        CompCombobox {
            id: comboConentration

            anchors{
                top: comboSample.top
                left: comboSample.right
                leftMargin: parent.comboSpacing
            }

            width: comboSample.width
            height: comboSample.height

            displayText: qsTr("Concentration")
            fontPixelSize: comboCategory.fontPixelSize
        }

        CompCombobox {
            id: comboItem

            anchors{
                top: comboConentration.top
                left: comboConentration.right
                leftMargin: parent.comboSpacing
            }

            width: comboConentration.width
            height: comboConentration.height

            displayText: qsTr("Item")
            fontPixelSize: comboCategory.fontPixelSize
        }

    }

    TableView{
        id: tableView

        property int selectedRow: -1
        property color gridLineColor: "#4D4A5F"
        //property var listOfColumnWidths: [600, 150, 150, 200, 200]
        //property var listOfColumnWidthRatios: [0.45, 0.15, 0.10, 0.15, 0.15]
        //property var listOfColumnWidthsCurrent: [600,150,200,200,200]
        property real tableWidthMax: 1717

        signal columnWidthsUpdated()

        onWidthChanged: {
            //console.log("Table width now: " + width)
            forceLayout()
            //update()
        }

        onRowsChanged: {
            console.log("Rows now " + rows)
        }

        anchors{
            top: groupFilters.bottom
            left: groupFilters.left
            right: groupFilters.right
            bottom: parent.bottom

            topMargin: (groupFilters.visible ? 34 : 0)
        }


        clip: true
        visible: true
        topMargin: 51
        rightMargin: 8

        model: visible ? compHealthDashboardContentMTConnect.dataModel : undefined
        boundsBehavior: Flickable.StopAtBounds

        rowHeightProvider: row => {
                               return 51;
                           }

        columnWidthProvider: col => {

                                 ////console.log("Updating column widths")
                                 //
                                 //var widthRatio = tableView.listOfColumnWidthRatios[col]
                                 //var widthMin = tableView.listOfColumnWidths[col]
                                 //var tableWidthCurrent = tableView.width
                                 //var widthCalcd = tableWidthCurrent * widthRatio
                                 //var maxWidth = Math.max(widthMin, widthCalcd)
                                 //
                                 //tableView.listOfColumnWidthsCurrent[col] = maxWidth
                                 //tableView.columnWidthsUpdated()


                                 return 300
                             }


        delegate: CompHealthDashboardTableItemDel_Params {
            myModel: model

            property int myRow: model.row
            property int myCol: model.column
            property var myData: model.value_string

            gridLineColor: tableView.gridLineColor
            rows: tableView.rows
            columns: tableView.columns
            selectedRow: tableView.selectedRow

            opacity: selectedRow === -1 ? 1.0 : (selectedRow === myRow ? 1.0 : 0.5)

            dataType: "text"

            onClicked: {
                if(selectedRow === myRow)
                {
                    tableView.selectedRow = -1
                    compHealthDashboardContentParams.graphViewTarget= "null"
                    compHealthDashboardContentParams.graphViewUnits="UNITS"
                } else {
                    tableView.selectedRow = myRow
                    compHealthDashboardContentParams.graphViewTarget = paramName
                    compHealthDashboardContentParams.graphViewUnits=myModel.units
                }

            }

            onActionClickedShowGraph: paramName => {

                                          compHealthDashboardContentParams.graphViewTarget = paramName
                                      }

        }

        Row{
            id: columHeader

            y: tableView.contentY
            z: 2

            Repeater {
                model: tableView.columns > 0 ? tableView.columns : 1

                Rectangle{

                    property int col: index

                    width: 300
                    height: 52

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
                        color: tableView.gridLineColor
                    }

                    Rectangle{

                        anchors{
                            right: parent.right
                            top: parent.top
                            bottom: parent.bottom
                        }

                        width: ((parent.col === (tableView.columns - 1)) ? 2 : 1)
                        color: tableView.gridLineColor
                    }

                    Rectangle{

                        anchors{
                            right: parent.right
                            left: parent.left
                            top: parent.top

                        }

                        height: 2
                        color: tableView.gridLineColor
                    }

                    Rectangle{

                        anchors{
                            right: parent.right
                            left: parent.left
                            bottom: parent.bottom

                        }

                        height: 2
                        color: tableView.gridLineColor
                    }

                    CompLabel{

                        anchors{
                            fill: parent
                        }

                        text: tableView.model ? tableView.model.headerData(modelData, Qt.Horizontal) : ""
                        font{
                            pixelSize: 20
                        }

                        horizontalAlignment: "AlignHCenter"
                        verticalAlignment: "AlignVCenter"
                    }

                }


            }
        }

        ScrollBar.horizontal: ScrollBar{
            policy:  ScrollBar.AsNeeded

            height: 8
        }

        ScrollBar.vertical: ScrollBar{
            policy:  ScrollBar.AsNeeded
            width: 8
            //topInset: 51
            topPadding: 51
        }

    }
}
