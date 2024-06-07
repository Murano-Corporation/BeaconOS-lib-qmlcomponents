import QtQuick 2.12

import QtQuick.Controls 2.12
import Qt.labs.qmlmodels 1.0
import CONSTANTS 1.0

Comp__BASE {
    id: compHealthDashboardContentParams

    property bool canShowGraphView: view === 'Graph' && graphViewTarget !== 'null'
    property var listOfHeaders: ["Name", "Value", "Units","Min", "Max"]
    property var listOfParams: TableModelHealthDashboard
    property string graphViewTarget: 'null'
    property string graphViewUnits: "UNITS"
    property string view: "List"

    /** Possible Values:
      - params = Non-MTConnect Parameters
      - params_mtc = MTConnect Parameters
      - gallery = Camera Gallery
    */
    property string targetData: 'params'
    property var dataModel: (targetData === 'params' ? TableModelHealthDashboard : (targetData === 'gallery' ? TableModelCameraGallery : undefined))
    property int tableViewSelectedRow: -1
    property int galleryInstanceId: -1
    property bool showGalleryInstance: galleryInstanceId !== -1

    property string floatingBreadCrumbName: 'null'

    signal forceViewModeMaximized()
    signal forceViewType(string viewType);
    signal setGridBtnVisible(bool isVisible);
    signal setListBtnVisible(bool isVisible);
    signal paramSelected(string paramName);


    onGraphViewTargetChanged: {
        paramSelected(graphViewTarget)
        floatingBreadCrumbName = graphViewTarget
        LiveGraphController.targetDataId = graphViewTarget
    }

    onFloatingBreadCrumbNameChanged: {
        if(floatingBreadCrumbName === 'null')
        {
            galleryInstanceId = -1
            graphViewTarget = 'null'

            tableViewSelectedRow = -1
        }
    }

    onTargetDataChanged: {
        if(targetData === 'gallery')
        {

            if(Settings.cameraGalleryPrefsPreferGridViewForImageData)
            {
                forceViewType('Grid')
            }

            if(Settings.cameraGalleryPrefsAutoMaximizeOnGalleryTarget)
            {    forceViewModeMaximized()}
        } else {
            //console.log("Enforcing list view for params")

            if(true)
                forceViewType('Grid')
            else
                forceViewType('List')
        }
    }

    onGalleryInstanceIdChanged: {
        if(galleryInstanceId === -1)
        {
            return;
        }

        if(Settings.cameraGalleryPrefsAutoMaximizeOnIndexChange)
        {
            forceViewModeMaximized();
        }
    }

    Item{
        id: groupFilters

        visible: (targetData === "param_mtc")

        property real comboSpacing: 17
        property real comboWidth: ((width - (comboSpacing * 3)) * 0.25)
        property real comboHeight: 41
        property real comboFontPixelSize: 20

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: (visible ? childrenRect.height : 0 )

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


    Loader{
        id: loaderTableView

        active: compHealthDashboardContentParams.view === "List"
                && !compHealthDashboardContentParams.showGalleryInstance
                && !loaderGraphView.active

        anchors {
            top: groupFilters.bottom
            left: groupFilters.left
            right: groupFilters.right
            bottom: parent.bottom

            topMargin: (groupFilters.visible ? 34 : 0)
        }

        asynchronous: true

        sourceComponent:
            TableView {
            id: tableView

            property int selectedRow: -1
            property color gridLineColor: "#4D4A5F"
            //property var listOfColumnWidths: [600, 150, 150, 200, 200]
            //property var listOfColumnWidthRatios: [0.45, 0.15, 0.10, 0.15, 0.15]
            //property var listOfColumnWidthsCurrent: [600,150,200,200,200]
            property real tableWidthMax: 1717
            property real startingWidth: 0

            signal columnWidthsUpdated()


            Connections{
                target: compHealthDashboardContentParams

                function onTableViewSelectedRowChanged(){
                    tableView.selectedRow = compHealthDashboardContentParams.tableViewSelectedRow
                }
            }

            Component.onCompleted: {
                startingWidth = width
                //tmrDelayPopulate.start()
                tableView.model = visible ? Qt.binding(function(){ return compHealthDashboardContentParams.dataModel}) : undefined

                tableView.selectedRow = compHealthDashboardContentParams.tableViewSelectedRow
            }

            //onRowsChanged: {
            //    //console.log("Table width now: " + width)

            //    forceLayout()
            //    //update()
            //}

            clip: true

            onVisibleChanged: {

                if(visible === false)
                {
                    return
                }

                setGridBtnVisible(true)
                setListBtnVisible(true)

            }

            boundsBehavior: Flickable.StopAtBounds

            delegate: CompHealthDashboardTableItemDel_Params {
                myModel: model
                tableModelRef: tableView.model

                property int myRow: model.row
                property int myCol: model.column
                property var myData: model.value_string
                property bool isSelected: selectedRow === myRow

                gridLineColor: tableView.gridLineColor
                rows: tableView.rows
                columns: tableView.columns
                selectedRow: tableView.selectedRow

                opacity: selectedRow === -1 ? 1.0 : (selectedRow === myRow ? 1.0 : 0.5)

                dataType: (targetData === "params" ? (model.column === 5 ? "actions" : "text") : (model.column === 1 ? "image" :  "text"))

                onClicked: {
                    if(selectedRow === myRow)
                    {
                        tableView.selectedRow = -1
                        compHealthDashboardContentParams.tableViewSelectedRow = -1
                        compHealthDashboardContentParams.graphViewTarget= "null"
                        compHealthDashboardContentParams.graphViewUnits= "UNITS"
                    } else {
                        tableView.selectedRow = myRow
                        compHealthDashboardContentParams.tableViewSelectedRow = myRow
                        compHealthDashboardContentParams.graphViewTarget = paramName
                        compHealthDashboardContentParams.graphViewUnits= myModel.unit
                    }

                }

                onPressAndHold: {
                    tooltip1.open()
                }

                CompTooltip{
                    id: tooltip1
                    text: parent.myModel.tooltip_text
                    contentItem: Text {
                        text: tooltip1.text
                        font.pixelSize: isDelta ? 20 : 35
                        color: "#ffffff"
                    }

                    background: Rectangle {
                        radius: 5
                        color: "#000000"
                    }
                }


                onActionClickedShowGraph: paramName => {

                                              compHealthDashboardContentParams.graphViewTarget = paramName
                                          }

            }


            rowHeightProvider: row => {
                                   if(isDelta)
                                   return 51;
                                   else
                                   return 100;

                               }

            columnWidthProvider: col => {
                                     if(!tableView.model || tableView.model === undefined)
                                     return;

                                     var varICol = col + 0;
                                     //console.log("Updating column width for " + varICol)
                                     //var widthRatio = tableView.listOfColumnWidthRatios[col]
                                     //var widthMin = tableView.listOfColumnWidths[col]
                                     //var tableWidthCurrent = tableView.width
                                     //var widthCalcd = tableWidthCurrent * widthRatio
                                     //var maxWidth = Math.max(widthMin, widthCalcd)

                                     //tableView.listOfColumnWidthsCurrent[col] = maxWidth
                                     //tableView.columnWidthsUpdated()
                                     var ret = tableView.model.headerData(varICol, Qt.Horizontal ,Constants.DataRole_HeaderData_ColumnWidth)

                                     return ret
                                 }

            topMargin: isDelta ? 51 : 100
            rightMargin: 8


            Row{
                id: columHeader

                y: tableView.contentY
                z: 2

                Repeater {
                    model: tableView.columns > 0 ? tableView.columns : 1

                    Rectangle{

                        property int col: index

                        width: tableView.columnWidthProvider(index)
                        height: isDelta ? 52 : 100

                        color: "#333958"

                        //Connections{
                        //    target: tableView

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
                                pixelSize: isDelta ? 20 : 35
                            }

                            horizontalAlignment: "AlignHCenter"
                            verticalAlignment: "AlignVCenter"
                        }

                    }


                }
            }


            //            ScrollBar.horizontal: ScrollBar{
            //                policy:  ScrollBar.AsNeeded

            //                height: 8
            //            }

            ScrollBar.vertical: ScrollBar{
                policy:  ScrollBar.AsNeeded
                width: 8
                //topInset: 51
                topPadding: 51
            }

        }

    }

    Loader{
        id: loaderGridView

        active: compHealthDashboardContentParams.view === "Grid" && !compHealthDashboardContentParams.showGalleryInstance && !loaderGraphView.active
        onActiveChanged: {

            if(active === false)
            {
                return
            }

            setGridBtnVisible(true)
            setListBtnVisible(true)
        }
        asynchronous: true
        anchors{
            top: groupFilters.bottom
            left: groupFilters.left
            right: groupFilters.right
            bottom: parent.bottom
            topMargin: isDelta ? 0 : 50
            bottomMargin: isDelta ? 0 : 50
            leftMargin: isDelta ? 0 : 155
        }

        sourceComponent: GridView {
            id: gridView

            property real cellPadding: 37

            clip: true

            cellWidth: isDelta ? (compHealthDashboardContentParams.targetData === 'params' ? 354.33 : (387 + cellPadding)) : 600
            cellHeight: isDelta ? (compHealthDashboardContentParams.targetData === 'params' ? 355 : (375 + cellPadding)) : 600
            model: visible ? compHealthDashboardContentParams.dataModel : undefined
            onModelChanged: {

                //console.log('TableViewSelectedRow now: ' + compHealthDashboardContentParams.tableViewSelectedRow)
                gridView.currentIndex = compHealthDashboardContentParams.tableViewSelectedRow
                gridView.positionViewAtIndex(compHealthDashboardContentParams.tableViewSelectedRow, GridView.Center)
            }

            onCurrentIndexChanged: {
                //console.log('Current index is now ' + currentIndex)
                compHealthDashboardContentParams.tableViewSelectedRow = currentIndex
            }

            DelegateChooser{
                id: delChooser
                role: "data_type"

                DelegateChoice{
                    roleValue: 0; //UNKNOWN
                    CompHealthDashboardUnhandledType{

                    }

                }

                DelegateChoice{
                    roleValue: 1; //Gauge

                    Item{
                        height: gridView.cellHeight
                        width: gridView.cellWidth

                        CompParamView_Gauge {
                            id: gaugeRoot
                            property var myModel: model
                            property int myRow: model.row
                            property bool isMultiSystemPresent: model.is_multisystem_present
                            property var myIndexParent: model.parent
                            property int dataValueType: model.data_value_type
                            property real valueNum: model.value
                            property string valueString: model.value_string
                            property string sourceID: model.source
                            property real valueMin: model.min ? model.min : -1
                            property real valueMax: model.max ? model.max : 1
                            property int valueSeverity: model.severity

                            height: gridView.cellHeight - 61
                            width: gridView.cellWidth - 75

                            anchors.centerIn: parent

                            value: valueNum
                            min: valueMin
                            max: valueMax
                            paramName: model.ParamName + (isMultiSystemPresent ? ("\n[" + sourceID + "]") : "")
                            units: model.unit
                            severity: valueSeverity
                            valueText: SingletonUtils.convertNumberToString(value, 'f', 0)
                            stepSize: 0.01



                            MouseArea{
                                id: mouseAreaGauges

                                anchors{
                                    fill: parent
                                }

                                onClicked: {
                                    compHealthDashboardContentParams.graphViewTarget  = parent.paramName
                                    compHealthDashboardContentParams.graphViewUnits = parent.units
                                    gridView.currentIndex = index
                                }

                                onPressAndHold: {
                                    tooltip2.open()
                                }

                                CompTooltip{
                                    id: tooltip2
                                    text: gaugeRoot.myModel.tooltip_text
                                    contentItem: Text {
                                        text: tooltip2.text
                                        font.pixelSize: isDelta ? 25 : 35
                                    }

                                    background: Rectangle {
                                        radius: 5
                                        color: "#9287ED"
                                    }
                                }
                            }


                        }


                    }

                }

                DelegateChoice{
                    roleValue: 2 //STATUS TEXT

                    Item{
                        height: gridView.cellHeight
                        width: gridView.cellWidth

                        CompParamView_Text {
                            id: compParamView_Text

                            property bool isMultiSystemPresent: model.is_multisystem_present
                            property string sourceID: model.source

                            paramName: model.ParamName + (isMultiSystemPresent ? ("\n[" + sourceID + "]") : '')
                            valueText: model.value

                            height: gridView.cellHeight - 61
                            width: gridView.cellWidth - 75
                            anchors.centerIn: parent

                        }

                    }
                }

                DelegateChoice{
                    roleValue: 3; //INDICATOR
                    CompHealthDashboardUnhandledType{

                    }
                }

                DelegateChoice{
                    roleValue: 4; //MTConnect...
                    CompHealthDashboardUnhandledType{


                    }


                }

                DelegateChoice{
                    roleValue: 5 //GALLERY ITEM
                    Item{
                        height: gridView.cellHeight
                        width: gridView.cellWidth

                        CompProcdImageItem{
                            imgSourceName: model ? model.img_path : ''

                            property int myIndex: model ? model.row : -1
                            property string idPrefix: qsTr("IMG ")
                            imgId: idPrefix + (myIndex <= 8 ? ("0"+ (myIndex+1)) : (myIndex+1))

                            imgTimestamp: model ? model.timestamp_short : ''

                            //result: model ? model.inference : ''

                            height: gridView.cellHeight - gridView.cellPadding
                            width: gridView.cellWidth - gridView.cellPadding
                            anchors.centerIn: parent

                            onClicked: {
                                compHealthDashboardContentParams.galleryInstanceId = myIndex
                            }

                        }

                    }
                }

                DelegateChoice{
                    roleValue: 6

                    Item{
                        width: gridView.cellWidth
                        height: gridView.cellHeight

                        CompParamView_LED{
                            property bool isMultiSystemPresent: model.is_multisystem_present
                            property string sourceID: model.source

                            paramName: model.ParamName + (isMultiSystemPresent ? ("\n[" + sourceID + "]") : '')
                            valueText: model.value

                            height: gridView.cellHeight - 61
                            width: gridView.cellWidth - 75
                            anchors.centerIn: parent


                        }

                    }

                }

                DelegateChoice{
                    roleValue: 7
                    Item{
                        height: gridView.cellHeight
                        width: gridView.cellWidth

                        CompParamView_LED{
                            property bool isMultiSystemPresent: model.is_multisystem_present
                            property string sourceID: model.source

                            isOnBad: true

                            paramName: model.ParamName + (isMultiSystemPresent ? ("\n[" + sourceID + "]") : '')
                            valueText: model.value

                            height: gridView.cellHeight - 61
                            width: gridView.cellWidth - 75
                            anchors.centerIn: parent

                        }

                    }

                }
            }

            delegate: delChooser;

            highlight: Item {
                width: gridView.cellWidth; height: gridView.cellHeight
                CompGlassRect {}
            }
            highlightFollowsCurrentItem: true
            focus: true

            ScrollBar.vertical: ScrollBar{
                policy:  ScrollBar.AsNeeded
                width: 8
                //topInset: 51
                topPadding: 51
            }

            Component.onCompleted: {
                gridView.currentIndex = compHealthDashboardContentParams.tableViewSelectedRow
                gridView.positionViewAtIndex(compHealthDashboardContentParams.tableViewSelectedRow, GridView.Center)
            }

        }


    }


    Loader{
        id: loaderGalleryInstanceView

        active: compHealthDashboardContentParams.showGalleryInstance && !loaderGraphView.active
        onActiveChanged:{
            if(active === false)
            {
                return
            }

            compHealthDashboardContentParams.setGridBtnVisible(false)
            compHealthDashboardContentParams.setListBtnVisible(false)
        }
        asynchronous: true
        anchors{
            top: groupFilters.bottom
            left: groupFilters.left
            right: groupFilters.right
            bottom: parent.bottom
        }

        sourceComponent:    CompGalleryInstanceView {
            id: galleryInstanceView

            visible: compHealthDashboardContentParams.showGalleryInstance && !compHealthDashboardContentGraphView.visible
            onVisibleChanged: {

            }




            imageIndex: compHealthDashboardContentParams.galleryInstanceId
            maxImageIndex: CameraController.processedImgCount

            onBreadcrumbNameChanged: {
                compHealthDashboardContentParams.floatingBreadCrumbName = galleryInstanceView.breadcrumbName
            }

            onIndexChanged: newIndex => {
                                compHealthDashboardContentParams.galleryInstanceId = newIndex
                            }
        }

    }


    Loader{
        id: loaderGraphView

        active: compHealthDashboardContentParams.canShowGraphView
        anchors{
            top: groupFilters.bottom
            left: groupFilters.left
            right: groupFilters.right
            bottom: parent.bottom
        }

        sourceComponent:     CompHealthDashboardContentGraphView {
            id: compHealthDashboardContentGraphView


            valueUnits: compHealthDashboardContentParams.graphViewUnits



        }
    }


}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
