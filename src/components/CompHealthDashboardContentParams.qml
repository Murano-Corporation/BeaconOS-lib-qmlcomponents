import QtQuick 2.12

import QtQuick.Controls 2.12
import Qt.labs.qmlmodels 1.0

Item{
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
    }

    onFloatingBreadCrumbNameChanged: {
        if(floatingBreadCrumbName === 'null')
        {
            galleryInstanceId = -1
            graphViewTarget = 'null'
            tableView.selectedRow = -1
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


    TableView{
        id: tableView
        property int selectedRow: -1
        onSelectedRowChanged: {
            console.log('Selected row now: ' + selectedRow)
        }

        property color gridLineColor: "#4D4A5F"
        property var listOfColumnWidths: [600, 150, 150, 200, 200]
        property var listOfColumnWidthRatios: [0.45, 0.15, 0.10, 0.15, 0.15]
        property var listOfColumnWidthsCurrent: [600,150,200,200,200]
        property real tableWidthMax: 1717

        signal columnWidthsUpdated()

        onWidthChanged: {
            //console.log("Table width now: " + width)
            forceLayout()
            //update()
        }

        clip: true
        visible: compHealthDashboardContentParams.view === "List" && !compHealthDashboardContentParams.showGalleryInstance && !compHealthDashboardContentGraphView.visible


        onVisibleChanged: {

            if(visible === false)
            {
                return
            }

            setGridBtnVisible(true)
            setListBtnVisible(true)

        }

        model: visible ? compHealthDashboardContentParams.dataModel : undefined
        boundsBehavior: Flickable.StopAtBounds

        anchors {
            top: groupFilters.bottom
            left: groupFilters.left
            right: groupFilters.right
            bottom: parent.bottom

            topMargin: (groupFilters.visible ? 34 : 0)
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

            dataType: (targetData === "params" ? (model.column === 5 ? "actions" : "text") : (model.column === 1 ? "image" :  "text"))

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


        rowHeightProvider: row => {
                               return 51;
                           }

        columnWidthProvider: col => {

                                 //console.log("Updating column widths")

                                 var widthRatio = tableView.listOfColumnWidthRatios[col]
                                 var widthMin = tableView.listOfColumnWidths[col]
                                 var tableWidthCurrent = tableView.width
                                 var widthCalcd = tableWidthCurrent * widthRatio
                                 var maxWidth = Math.max(widthMin, widthCalcd)

                                 tableView.listOfColumnWidthsCurrent[col] = maxWidth
                                 tableView.columnWidthsUpdated()


                                 return maxWidth
                             }

        topMargin: 51
        rightMargin: 8
        Row{
            id: columHeader

            y: tableView.contentY
            z: 2

            Repeater {
                model: tableView.columns > 0 ? tableView.columns : 1

                Rectangle{

                    property int col: index

                    width: tableView.listOfColumnWidthsCurrent[index]
                    height: 52

                    color: "#333958"

                    Connections{
                        target: tableView

                        onColumnWidthsUpdated:{
                            width = tableView.listOfColumnWidthsCurrent[index]
                        }
                    }

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


    GridView {
        id: gridView

        property real cellPadding: 37

        visible: compHealthDashboardContentParams.view === "Grid" && !compHealthDashboardContentParams.showGalleryInstance && !compHealthDashboardContentGraphView.visible
        onVisibleChanged: {

            if(visible === false)
            {
                return
            }

            setGridBtnVisible(true)
            setListBtnVisible(true)

        }

        clip: true
        anchors{
            top: groupFilters.bottom
            left: groupFilters.left
            right: groupFilters.right
            bottom: parent.bottom
        }

        cellWidth: compHealthDashboardContentParams.targetData === 'params' ? 340 : (387 + cellPadding)
        cellHeight: compHealthDashboardContentParams.targetData === 'params' ? 355 : (375 + cellPadding)
        //targetData === 'gallery' 387, 375 : 340,355
        model: visible ? compHealthDashboardContentParams.dataModel : undefined

        DelegateChooser{
            id: delChooser
            role: "data_type"

            DelegateChoice{
                roleValue: 0; //UNKNOWN
                CompHealthDashboardUnhandledType{}

            }

            DelegateChoice{
                roleValue: 1; //Gauge
                CompParamView_Gauge {

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

                    value: valueNum
                    min: valueMin
                    max: valueMax
                    paramName: model.ParamName + (isMultiSystemPresent ? ("\n[" + sourceID + "]") : "")
                    units: model.unit
                    severity: valueSeverity
                    valueText: SingletonUtils.convertNumberToString(value, 'f', 0)
                    stepSize: 0.01

                    MouseArea{
                        anchors{
                            fill: parent
                        }

                        onClicked: {
                            compHealthDashboardContentParams.graphViewTarget  = parent.paramName
                            compHealthDashboardContentParams.graphViewUnits = parent.units
                        }
                    }
                }

            }

            DelegateChoice{
                roleValue: 2 //STATUS TEXT

                CompParamView_Text {
                    id: compParamView_Text

                    property bool isMultiSystemPresent: model.is_multisystem_present
                    property string sourceID: model.source

                    paramName: model.ParamName + (isMultiSystemPresent ? ("\n[" + sourceID + "]") : '')
                    valueText: model.value

                    height: gridView.cellHeight - 61
                    width: gridView.cellWidth - 75
                }
            }

            DelegateChoice{
                roleValue: 3; //INDICATOR
                CompHealthDashboardUnhandledType{}
            }

            DelegateChoice{
                roleValue: 4; //MTConnect...
                CompHealthDashboardUnhandledType{}
            }

            DelegateChoice{
                roleValue: 5 //GALLERY ITEM

                CompProcdImageItem{
                    imgSourceName: model ? model.img_path : ''

                    property int myIndex: model ? model.row : -1
                    property string idPrefix: qsTr("IMG ")
                    imgId: idPrefix + (myIndex <= 8 ? ("0"+ (myIndex+1)) : (myIndex+1))

                    imgTimestamp: model ? model.timestamp_short : ''

                    //result: model ? model.inference : ''

                    height: gridView.cellHeight - gridView.cellPadding
                    width: gridView.cellWidth - gridView.cellPadding

                    onClicked: {
                        compHealthDashboardContentParams.galleryInstanceId = myIndex
                    }

                }
            }

            DelegateChoice{
                roleValue: 6
                CompParamView_LED{
                    property bool isMultiSystemPresent: model.is_multisystem_present
                    property string sourceID: model.source

                    paramName: model.ParamName + (isMultiSystemPresent ? ("\n[" + sourceID + "]") : '')
                    valueText: model.value

                    height: gridView.cellHeight - 61
                    width: gridView.cellWidth - 75
                }
            }

            DelegateChoice{
                roleValue: 7
                CompParamView_LED{
                    property bool isMultiSystemPresent: model.is_multisystem_present
                    property string sourceID: model.source

                    isOnBad: true

                    paramName: model.ParamName + (isMultiSystemPresent ? ("\n[" + sourceID + "]") : '')
                    valueText: model.value

                    height: gridView.cellHeight - 61
                    width: gridView.cellWidth - 75
                }
            }
        }

        delegate: delChooser;

    }


    CompGalleryInstanceView {
        id: galleryInstanceView

        visible: compHealthDashboardContentParams.showGalleryInstance && !compHealthDashboardContentGraphView.visible
        onVisibleChanged: {
            if(visible === false)
            {
                return
            }

            compHealthDashboardContentParams.setGridBtnVisible(false)
            compHealthDashboardContentParams.setListBtnVisible(false)
        }


        anchors{
            top: groupFilters.bottom
            left: groupFilters.left
            right: groupFilters.right
            bottom: parent.bottom
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

    CompHealthDashboardContentGraphView {
        id: compHealthDashboardContentGraphView

        visible: compHealthDashboardContentParams.canShowGraphView
        valueUnits: compHealthDashboardContentParams.graphViewUnits
        anchors{
            top: groupFilters.bottom
            left: groupFilters.left
            right: groupFilters.right
            bottom: parent.bottom
        }


    }


    //CompScrollView{
    //    id: scrollViewRows

    //    clip: true

    //    anchors {
    //        top: scrollViewHeaders.bottom
    //        left: scrollViewHeaders.left
    //        right: scrollViewHeaders.right
    //        bottom: parent.bottom
    //    }

    //    ListView {
    //        id: listRows

    //        anchors{
    //            top: scrollViewRows.top
    //            left: scrollViewRows.left
    //        }

    //        model: compHealthDashboardContentParams.listOfParams

    //        delegate: CompTableRowItemDelegate {
    //            id: compTableRowItemDelegate

    //            paramName: modelData.ParamName
    //            value: modelData.scaled_val
    //            min: modelData.min
    //            max: modelData.max
    //        }
    //    }

    //}

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
