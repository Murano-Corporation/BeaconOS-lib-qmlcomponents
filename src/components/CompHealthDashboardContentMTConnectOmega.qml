import QtQuick 2.12
import QtQuick.Controls 2.12

Screen__BASE {
    id: compHealthDashboardContentMTConnect

    property bool canShowGraphView: view === 'Graph' && graphViewTarget !== 'null'
    property string context1Selected: "*"
    property string graphViewTarget: 'null'
    property string graphViewUnits: "UNITS"
    property string view: "List"
    property var dataModel: TableModelMTConnect_Context1
    property var mainDataModel: TableModelMTConnect
    property string searchFieldText: ""
    property bool isTooltipVisible: false

    signal forceViewType(string viewType);
    signal forceViewModeMaximized();
    signal setGridBtnVisible(bool isVisible);
    signal setListBtnVisible(bool isVisible);
    signal paramSelected(string paramName);

    function filterDisplayData(componentName) {
        //console.log("TableModelMTConnect.headerData : "+TableModelMTConnect.headerData(TableModelMTConnect, Qt.Horizontal));
        compHealthDashboardContentMTConnect.mainDataModel.setContext1MTC(componentName);
        //TableModelMTConnect.setContext1MTC(componentName)
        isDataVisible = true;
    }

    onContext1SelectedChanged: {
        filterDisplayData(context1Selected)
    }

    onSearchFieldTextChanged: {
        TableModelMTConnect.setSearchFieldText(searchFieldText)
    }

    Item{
        id: groupFilters

        property real comboSpacing: 17
        property real comboWidth: ((width - (comboSpacing * 3)) * 0.25)
        property real comboHeight: 100
        property real comboFontPixelSize: 35

        anchors{
            top: parent.top
            topMargin: 20
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
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
        property real tableWidthMax: 1717

        signal columnWidthsUpdated()

        visible: isDataVisible

        onWidthChanged: {
            forceLayout()
        }

        anchors{
            top: groupFilters.bottom
            left: groupFilters.left
            right: groupFilters.right
            bottom: parent.bottom

            topMargin: (groupFilters.visible ? 34 : 0)
        }


        clip: true
        topMargin: 100
        rightMargin: 8


        model: visible ? compHealthDashboardContentMTConnect.mainDataModel : undefined
        boundsBehavior: Flickable.StopAtBounds

        rowHeightProvider: row => {
                               return 100;
                           }

        columnWidthProvider: col => {
                                 return 450;
                             }


        delegate: CompHealthDashboardTableItemDel_Params {
            myModel: model
            tableModelRef: tableView.model
            property int myRow: model.row
            property int myCol: model.column
            property var myData: model.value_string

            gridLineColor: tableView.gridLineColor
            rows: tableView.rows
            columns: tableView.columns
            selectedRow: tableView.selectedRow

            dataContent.font.pixelSize: 35

            opacity: selectedRow === -1 ? 1.0 : (selectedRow === myRow ? 1.0 : 0.5)


            dataType: "text"

            onClicked: {
                if(selectedRow === myRow)
                {
//                    console.log("model.display in IF = " + model.paramName + " " + model.display);
                    tableView.selectedRow = -1
                    compHealthDashboardContentMTConnect.graphViewTarget= "null"
                    compHealthDashboardContentMTConnect.graphViewUnits="UNITS"
                } else {
                    //console.log("display name = " + model.name + " " + model.display);
                    tableView.selectedRow = myRow
                    compHealthDashboardContentMTConnect.graphViewTarget = paramName
                    compHealthDashboardContentMTConnect.graphViewUnits=myModel.units
                }
            }

            onActionClickedShowGraph: paramName => {
                compHealthDashboardContentParams.graphViewTarget = paramName
           }

            onPressAndHold: {
                tooltip.open()
            }

            CompTooltip{
                id: tooltip
                text: parent.myModel.tooltip_text

//                height:100
//                width:300

                contentItem: Text {
                          text: tooltip.text
                          font.pixelSize: 35
                      }

                      background: Rectangle {
                          color: "#9287ED"
                      }
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

                    width: 450
                    height: 100

                    color: "#333958"

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
                            pixelSize: 35
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
            topPadding: 51
        }

    }

//    Item{
//        id: viewContext1_MTC

//        property real btnSpacing: 25
//        property real btnHeight: 140
//        property real btnWidth: 892
//        property int fontPixelSize: 35

//        visible: !isDataVisible

//        anchors{
//            top: groupFilters.bottom
//            left: groupFilters.left
//            right: groupFilters.right
//            bottom: parent.bottom

//            topMargin: (groupFilters.visible ? 34 : 0)
//        }

//        GridView {
//            id: rowDynamicContexts
//            clip: true
//            boundsBehavior: Flickable.StopAtBounds

//            anchors{
//                fill: parent
//            }

//            model: visible ? compHealthDashboardContentMTConnect.dataModel : undefined

//            cellHeight: viewContext1_MTC.btnHeight + viewContext1_MTC.btnSpacing
//            cellWidth: viewContext1_MTC.btnWidth + viewContext1_MTC.btnSpacing
//            delegate: CompHealthContextNavBtnOmega{

//                width: viewContext1_MTC.btnWidth
//                height: viewContext1_MTC.btnHeight

//                text: model.display
//                fontPixelSize: viewContext1_MTC.fontPixelSize

//                onClicked: function(txt){
//                    filterDisplayData(txt)
//                }

//            }

//        }

//    }
}
