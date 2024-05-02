import QtQuick 2.12

Item {
    id: compHealthDashboardContentRootOmega



    property string searchFieldPlaceholderText: "Search all parameters"

    property int alertCount: 0
    property CompHealthDashboardViewNavBtnOmega viewTabCurrent: btnViewParameters
    property string viewTabCurrentName: viewTabCurrent.tabName
    property string searchFieldValue: ""
    property string systemTypeSelected: "null"
    property string context1Selected: "null"
    property string context2Selected: "null"
    property string paramNameSelected: "null"
    property string mtcSortFilterString: "null"
    property string floatingBreadcrumbBtntext: "null"
    property string paramViewMode: "List"
    property string paramViewMode_Last: paramViewMode
    property string assetType: AssetInfo.assetType
    property int galleryInstanceId: -1
    property string graphViewTarget: 'null'
    property CompHealthDashboardContentContextNavOmega navObject: null

    property bool isBtnGridViewVisible: false
    property bool isBtnListViewVisible: false
    property bool isBtnGraphViewVisible: false
    property bool isDataVisible: false

    /** POSSIBLE CONTENT STATES
      * - context_nav : User is choosing contexts
      * - params_mtconnect : Displaying MTConnect parameters
      * - params : Displaying non-MTConnect parameters
      * - gallery : Displaying image gallery
      * - graph : Displaying the live-graph
      */
    property string contentState: "context_nav"
    property int animDuration: 250
    property bool blockModelDataFilterSignal: false
    property bool contextNavCompletenessCheck: false

    signal toggleViewModeClicked()
    signal forceViewModeMaximized();
    signal forceViewType(string sViewType)

    function setViewMode_List(){
        paramViewMode = ('List')
    }

    function setViewMode_Grid(){
        paramViewMode = ('Grid')
    }

    function setViewMode_Graph(){
        paramViewMode = ('Graph')
    }

    function setSystemTypeSelection(sSystemType)
    {
        compHealthDashboardContentContextNavOmega.systemSelected = sSystemType
    }

    onParamNameSelectedChanged: {

    }

    onViewTabCurrentChanged: {
        if(viewTabCurrent.tabName === btnViewParameters.tabName)
        {
            paramNameSelected = 'null'
            checkContextNavCompleteness()
        }
    }

//    onParamViewModeChanged: {
//        console.log("ParamView Mode now: " + paramViewMode)


//    }

    onContextNavCompletenessCheckChanged: {
        console.log("ContextNavComplete?: " + contextNavCompletenessCheck)

        if(contextNavCompletenessCheck )
        {
            if(systemTypeSelected === 'Camera Gallery')
            {contentState = 'gallery'}
            else if(assetType === 'CNC'){
                if(systemTypeSelected === 'Beacon Metrics')
                {contentState = 'params'}
                else{
                    contentState = 'params_mtconnect'
                }
            }
            else
            {contentState = context1Selected === 'Tire' ? 'gallery' : 'params'}
        } else {
            contentState = 'context_nav'
        }
    }


    onFloatingBreadcrumbBtntextChanged: {

        if(floatingBreadcrumbBtntext === 'null')
        {
            compHealthDashboardContentRoot.galleryInstanceId = -1
            compHealthDashboardContentRoot.graphViewTarget = 'null'

            if(paramViewMode === "Graph"){
                compHealthDashboardContentRoot.paramViewMode = paramViewMode_Last
            }

        }
    }

    onContentStateChanged: {

        console.log("Content State: " + contentState)

        if(contentState === 'gallery' || contentState === 'context_nav')
        {
            setViewBtnsVisible(false)
        } else {
            setViewBtnsVisible(true)
        }
    }

    onSearchFieldValueChanged: {
        checkContextNavCompleteness()

        if(blockModelDataFilterSignal)
            return;

        updateModelDataFilters()

    }

    onSystemTypeSelectedChanged: {
        btnViewParameters.clicked()
        checkContextNavCompleteness()
        if(blockModelDataFilterSignal)
            return;

        blockModelDataFilterSignal = true
        context1Selected = "null"
        context2Selected = "null"
        paramNameSelected = "null"
        floatingBreadcrumbBtntext = "null"

        blockModelDataFilterSignal = false
        updateModelDataFilters()



    }

    onContext1SelectedChanged: {
        btnViewParameters.clicked()
        checkContextNavCompleteness()
        if(blockModelDataFilterSignal)
            return;

        blockModelDataFilterSignal = true

        context2Selected = "null"
        paramNameSelected = "null"
        floatingBreadcrumbBtntext = "null"

        blockModelDataFilterSignal = false
        updateModelDataFilters()


    }

    onContext2SelectedChanged: {
        btnViewParameters.clicked()
        checkContextNavCompleteness()
        if(blockModelDataFilterSignal)
            return;

        blockModelDataFilterSignal = true
        paramNameSelected = "null"
        blockModelDataFilterSignal = false

        updateModelDataFilters()

        floatingBreadcrumbBtntext = "null"


    }

    function setViewBtnsVisible(isVisible)
    {
        setListViewBtnVisible(isVisible)
        setGridViewBtnVisible(isVisible)
        setGraphViewBtnVisible(isVisible)
    }

    function setListViewBtnVisible(isVisible)
    {
        isBtnListViewVisible = isVisible
    }

    function setGridViewBtnVisible(isVisible)
    {
        isBtnGridViewVisible = isVisible
    }

    function setGraphViewBtnVisible(isVisible)
    {
        isBtnGraphViewVisible = isVisible
    }

    function updateModelDataFilters(){

        //void slot_SetFilters(QString sSearch, QString sMetricsType, QString sContext1, QString sContext2, QString sContext3, QString sContext4);
        TableModelHealthDashboard.slot_SetFilters(searchFieldValue, systemTypeSelected, context1Selected, context2Selected, "null", "null")
    }

    function checkContextNavCompleteness() {

        var isComplete = true
        //console.log("Checking for nav completion: sys:" + systemTypeSelected + " aType:" + assetType + " c1:" + context1Selected + " c2:" + context2Selected + " p:" + paramNameSelected)

        isComplete &= (systemTypeSelected !== 'null')
        if(isComplete && (systemTypeSelected === 'Camera Gallery'))
        {
            compHealthDashboardContentRootOmega.contextNavCompletenessCheck = true;
            return;
        }

        if(isComplete && (systemTypeSelected === 'Asset Metrics') && (assetType === 'CNC'))
        {
            compHealthDashboardContentRootOmega.contextNavCompletenessCheck = (context1Selected !== 'null');
            return;
        }

        isComplete &= (context1Selected !== 'null')
        if(isComplete && (systemTypeSelected === 'Beacon Metrics'))
        {
            compHealthDashboardContentRootOmega.contextNavCompletenessCheck = true;
            return;
        }

        if(isComplete && (systemTypeSelected === 'Asset Metrics') && (context1Selected === 'Tire'))
        {
            compHealthDashboardContentRootOmega.contextNavCompletenessCheck = true;
            return;
        }


        isComplete &= (context2Selected !== 'null')
        compHealthDashboardContentRootOmega.contextNavCompletenessCheck = isComplete

    }



    //    Rectangle {
    //        anchors {
    //            fill: parent
    //        }
    //        color: "#3C3F65"
    //    }

    Rectangle {
        id: groupContentBg

        anchors{
            fill: parent
            topMargin: 400
        }

        color: "#14818087"
        rotation: 0
    }

    CompLabel{

        id: lblAssetName

        text: screenHealthDashboardRoot.assetName
        font {
            pixelSize: 75
        }
        color: "White"
        anchors {
            right: parent.right
            rightMargin: 20
            bottom: groupContentBg.top
            bottomMargin: 120
        }


    }
    Rectangle {
        id: rectSelectedTabBg

        anchors{
            verticalCenter: groupContentBg.top
            left: parent.left
            right: parent.right
        }

        height: 6
        radius: 3
        color: "#4D4A5F"
    }

    Item {
        id: groupButtons
        height: 100

        property real btnWidth: (width * 0.3333)
        property color colorSelected: "#D9177D89"
        property color colorIdle: "#80177D89"
        property real iconSize: 90

        anchors{
            bottom: rectSelectedTabBg.top
            bottomMargin: 23
            left: parent.left
            right: parent.right
            top: lblAssetName.bottom
        }


        CompHealthDashboardViewNavBtnOmega {
            id: btnViewSeverity

            enabled: false
            tabName: 'alerts'
            anchors.left: parent.left

            source: "file:///usr/share/BeaconOS-lib-images/images/AlertFill.svg"

            height: groupButtons.height
            width: groupButtons.btnWidth

            iconHeight: groupButtons.iconSize
            iconWidth: iconHeight

            onClicked: {
                compHealthDashboardContentRoot.viewTabCurrent = btnViewSeverity
                rectSelectedTab.state = "alerts"
            }
        }

        CompHealthDashboardViewNavBtnOmega {
            id: btnViewParameters


            tabName: 'params'
            anchors.left: btnViewSeverity.right
            anchors.top: btnViewSeverity.top

            source: "file:///usr/share/BeaconOS-lib-images/images/HealthFill.svg"

            height: groupButtons.height
            width: groupButtons.btnWidth

            iconHeight: groupButtons.iconSize
            iconWidth: iconHeight

            onClicked: {
                compHealthDashboardContentRootOmega.viewTabCurrent = btnViewParameters
                rectSelectedTab.state = "parameters"
            }
        }

        CompHealthDashboardViewNavBtnOmega{
            id: btnViewCustom

            enabled: false
            tabName: 'custom'
            anchors.left: btnViewParameters.right
            anchors.top: btnViewParameters.top

            source: "file:///usr/share/BeaconOS-lib-images/images/CustomFill.svg"

            height: groupButtons.height
            width: groupButtons.btnWidth

            iconHeight: groupButtons.iconSize
            iconWidth: iconHeight

            onClicked: {

                compHealthDashboardContentRootOmega.viewTabCurrent = btnViewCustom
                rectSelectedTab.state = "custom"
            }
        }

        Rectangle{
            id: rectSelectedTab

            width: btnViewParameters.width
            height: rectSelectedTabBg.height
            radius: rectSelectedTabBg.radius
            color: "#9287ED"

            state: "parameters"

            anchors{
                //horizontalCenter: compHealthDashboardContentRootOmega.viewTabCurrent.horizontalCenter
                verticalCenter: parent.bottom
                verticalCenterOffset: parent.anchors.bottomMargin + (height * 0.5)
            }

            states: [
                State{
                    name: "alerts"

                    AnchorChanges{
                        target: rectSelectedTab
                        anchors.horizontalCenter: btnViewSeverity.horizontalCenter
                    }
                },
                State{
                    name: "parameters"

                    AnchorChanges{
                        target: rectSelectedTab
                        anchors.horizontalCenter: btnViewParameters.horizontalCenter
                    }
                },
                State{
                    name: "custom"

                    AnchorChanges{
                        target: rectSelectedTab
                        anchors.horizontalCenter: btnViewCustom.horizontalCenter
                    }
                }
            ]

            transitions: [
                Transition{


                    AnchorAnimation{
                        duration: 250
                    }
                }
            ]
        }
    }

    CompCustomisableTextField {
        id: txtfldSearch

        onTextChanged: compHealthDashboardContentRootOmega.searchFieldValue = text

        anchors{
            top: rectSelectedTabBg.bottom
            topMargin: 34
            left: parent.left
            leftMargin: 34
            right: (btnGridView.visible ? btnGridView.left : (btnListView.visible ? btnListView.left : (btnGraphView.visible ? btnGraphView.left : parent.right)))
            rightMargin: (!btnGridView.visible && !btnListView.visible && !btnGraphView.visible ) ? 34 : 19
        }

        height: 100

        text: ""
        placeholderText: compHealthDashboardContentRootOmega.searchFieldPlaceholderText
        textFontSize: 40
        btnClearSize: 60

    }

    CompIconBtn {
        id: btnGridView

        visible: compHealthDashboardContentRootOmega.isBtnGridViewVisible
        anchors{
            top:txtfldSearch.top
            bottom: txtfldSearch.bottom
            right: btnListView.left
            rightMargin: 20
        }

        iconColor: (compHealthDashboardContentRootOmega.paramViewMode === "Grid") ? "White" : "#80ffffff"
        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/GridFill.svg"
        height: 100

        onClicked: compHealthDashboardContentRootOmega.paramViewMode = "Grid"
    }

    CompIconBtn {
        id: btnListView

        visible: compHealthDashboardContentRootOmega.isBtnListViewVisible
        //enabled: false

        anchors{
            top:txtfldSearch.top
            bottom: txtfldSearch.bottom
            right: btnGraphView.visible ? btnGraphView.left : parent.right
            rightMargin: 20
        }

        iconColor: (compHealthDashboardContentRootOmega.paramViewMode === "List") ? "White" : "#80ffffff"
        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/ListFill.svg"
        height: 100

        onClicked: compHealthDashboardContentRootOmega.paramViewMode = "List"
    }

    CompIconBtn {
        id: btnGraphView
        enabled: compHealthDashboardContentRootOmega.paramNameSelected !== "null"

        visible: compHealthDashboardContentRootOmega.isBtnGraphViewVisible
        anchors {
            top:txtfldSearch.top
            bottom: txtfldSearch.bottom
            right: parent.right
            rightMargin: 20
        }

        iconColor: (compHealthDashboardContentRootOmega.paramViewMode === "Graph") ? "White" : "#80ffffff"
        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/GraphFill.svg"
        height: 100
        onClicked: {
            compHealthDashboardContentRootOmega.paramViewMode_Last = compHealthDashboardContentRootOmega.paramViewMode
            compHealthDashboardContentRootOmega.floatingBreadcrumbBtntext = compHealthDashboardContentRootOmega.paramNameSelected
            compHealthDashboardContentRootOmega.paramViewMode = "Graph"
        }
    }

    //    CompIconBtn {
    //        id: btnExpandShrink

    //        iconUrl: topControlGroup.state === "normal" ? "file:///usr/share/BeaconOS-lib-images/images/Expand.png" : "file:///usr/share/BeaconOS-lib-images/images/Shrink.png"
    //        iconColor: "White"
    //        onClicked: compHealthDashboardContentRootOmega.toggleViewModeClicked()

    //        anchors{
    //            top: txtfldSearch.top
    //            right: parent.right
    //            rightMargin: 34
    //            bottom: txtfldSearch.bottom
    //        }

    //        width: height
    //    }

    Flickable {
        id: groupBreadcrumbs

        property real spacing: 10
        clip: true
        visible: (compHealthDashboardContentRootOmega.systemTypeSelected !== "null")

        boundsBehavior: Flickable.StopAtBounds

        anchors{
            top: txtfldSearch.bottom
            topMargin: 19
            left: txtfldSearch.left
            right: parent.right
        }

        contentHeight: height
        //contentWidth: contentItem.childrenRect.width

        height: (groupBreadcrumbs.visible ? 120 : 0)

        CompBtnBreadcrumb {
            id: btnBreadcrumb1

            visible: compHealthDashboardContentRootOmega.systemTypeSelected !== "null"

            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top

            font.pixelSize: 40

            text: compHealthDashboardContentRootOmega.systemTypeSelected

            onClicked: {
                compHealthDashboardContentRootOmega.isDataVisible = false

                if(compHealthDashboardContentRootOmega.navObject === null)
                    compHealthDashboardContentRootOmega.systemTypeSelected = "null"
                else
                    compHealthDashboardContentRootOmega.navObject.systemSelected = "null"
            }
        }

        CompIconRightFill {
            id: sep1
            anchors{
                left: btnBreadcrumb1.right
                leftMargin: groupBreadcrumbs.spacing
                top: parent.top
                bottom: parent.bottom
            }

            visible: btnBreadcrumb2.visible
        }

        CompBtnBreadcrumb{
            id: btnBreadcrumb2

            visible: (compHealthDashboardContentRootOmega.context1Selected !== "null" && btnBreadcrumb1.visible)

            anchors{
                top: parent.top
                left: sep1.right
                leftMargin: groupBreadcrumbs.spacing
                bottom: parent.bottom
            }

            onClicked: {
                if(compHealthDashboardContentRootOmega.navObject === null)
                    compHealthDashboardContentRootOmega.context1Selected = "null"
                else
                    compHealthDashboardContentRootOmega.navObject.context1Selected = "null"
            }

            font.pixelSize: 40

            text: compHealthDashboardContentRootOmega.context1Selected

            height: parent.height

        }

        CompIconRightFill {
            id: sep2

            visible: btnBreadcrumb3.visible

            anchors{
                left: btnBreadcrumb2.right
                leftMargin: groupBreadcrumbs.spacing
                top: parent.top
                bottom: parent.bottom
            }
        }

        CompBtnBreadcrumb{
            id: btnBreadcrumb3

            visible: (compHealthDashboardContentRootOmega.context2Selected !== "null" && btnBreadcrumb2.visible)

            anchors{
                top: parent.top
                left: sep2.right
                leftMargin: groupBreadcrumbs.spacing
                bottom: parent.bottom
            }

            onClicked: {
                if(compHealthDashboardContentRootOmega.navObject === null)
                    compHealthDashboardContentRootOmega.context2Selected = "null"
                else
                    compHealthDashboardContentRootOmega.navObject.context2Selected = "null"
            }

            font.pixelSize: 40

            text: compHealthDashboardContentRootOmega.context2Selected

            height: parent.height

        }

        CompIconRightFill {
            id: sep3

            visible: btnBreadcrumb4.visible

            property CompBtnBreadcrumb leftObject: (btnBreadcrumb3.visible ? btnBreadcrumb3 : (btnBreadcrumb2.visible ? btnBreadcrumb2 : btnBreadcrumb1))

            anchors{
                left: sep3.leftObject.right
                leftMargin: groupBreadcrumbs.spacing
                top: parent.top
                bottom: parent.bottom
            }
        }

        CompBtnBreadcrumb{
            id: btnBreadcrumb4

            visible: (compHealthDashboardContentRootOmega.floatingBreadcrumbBtntext !== "null")

            anchors{
                top: parent.top
                left: sep3.right
                leftMargin: groupBreadcrumbs.spacing
                bottom: parent.bottom
            }

            onClicked: {
                compHealthDashboardContentRootOmega.floatingBreadcrumbBtntext = "null"
                compHealthDashboardContentRootOmega.paramNameSelected = 'null'
            }

            font.pixelSize: 40

            text: compHealthDashboardContentRootOmega.floatingBreadcrumbBtntext

            height: parent.height

        }
    }

    Item {
        id: viewContents


        property real contentsWidth: parent.width
        property real btnWidth: ((parent.width * 0.25) - ((btnSpacing * 0.33) * 4))
        property real btnSpacing: 41

        Rectangle {
            anchors {
                fill: parent
            }
            color: "#3C3F65"
        }

        anchors{
            top: groupBreadcrumbs.bottom
            topMargin: 20
            left: groupBreadcrumbs.left
            bottom: parent.bottom
            bottomMargin: 20

            right: groupBreadcrumbs.right
            rightMargin: 34
        }

        Loader{
            id: loaderContentNav
            active: (compHealthDashboardContentRootOmega.contentState === "context_nav")
            onActiveChanged:{
                if(active === false)
                {
                    compHealthDashboardContentRootOmega.navObject = null
                    return
                }

                compHealthDashboardContentRootOmega.isBtnGridViewVisible = false
                compHealthDashboardContentRootOmega.isBtnListViewVisible = false
            }

            asynchronous: true
            anchors.fill: parent
            sourceComponent: CompHealthDashboardContentContextNavOmega {
                id: compHealthDashboardContentContextNavOmega

                isMTConnectData: (assetType === "CNC")

                onSystemSelectedChanged: {
                    compHealthDashboardContentRootOmega.systemTypeSelected = compHealthDashboardContentContextNavOmega.systemSelected
                }

                onContext1SelectedChanged: {
                    compHealthDashboardContentRootOmega.context1Selected = compHealthDashboardContentContextNavOmega.context1Selected
                }

                onContext2SelectedChanged: {
                    compHealthDashboardContentRootOmega.context2Selected = compHealthDashboardContentContextNavOmega.context2Selected
                }

                onMtcSortFilterStringChanged: {
                    compHealthDashboardContentRootOmega.mtcSortFilterString = compHealthDashboardContentContextNavOmega.mtcSortFilterString
                }

                Component.onCompleted: {
                    compHealthDashboardContentRootOmega.navObject = this

                    systemSelected = compHealthDashboardContentRootOmega.systemTypeSelected
                    context1Selected = compHealthDashboardContentRootOmega.context1Selected
                    context2Selected = compHealthDashboardContentRootOmega.context2Selected

                }
            }
        }

        Loader{
            id: loaderContentParams

            active: (compHealthDashboardContentRootOmega.contentState !== "context_nav" && compHealthDashboardContentRootOmega.contentState !== 'params_mtconnect')

            asynchronous: true
            anchors.fill: parent

            sourceComponent: CompHealthDashboardContentParamsOmega {
                id: compHealthDashboardContentParams

                targetData: (visible ? (compHealthDashboardContentRootOmega.contentState) : "")
                view: compHealthDashboardContentRootOmega.paramViewMode

                onForceViewType: txt => compHealthDashboardContentRootOmega.paramViewMode = txt

                onFloatingBreadCrumbNameChanged: {
                    compHealthDashboardContentRootOmega.floatingBreadcrumbBtntext = compHealthDashboardContentParams.floatingBreadCrumbName
                }

                onForceViewModeMaximized: {
                    compHealthDashboardContentRootOmega.forceViewModeMaximized()
                }

                onParamSelected: txt => compHealthDashboardContentRootOmega.paramNameSelected = txt

                onSetGridBtnVisible: isVis => {
                                         compHealthDashboardContentRootOmega.isBtnGridViewVisible = isVis
                                     }

                onSetListBtnVisible: isVis => {
                                         compHealthDashboardContentRootOmega.isBtnListViewVisible = isVis
                                     }

                Connections{
                    target: compHealthDashboardContentRootOmega

                    function onGalleryInstanceIdChanged(id)
                    {
                        compHealthDashboardContentParams.galleryInstanceId = id
                    }

                    function onGraphViewTargetChanged(targ)
                    {
                        compHealthDashboardContentParams.graphViewTarget = targ
                    }
                }
            }
        }

        Loader{
            id: loaderContentMTConnect

            active: compHealthDashboardContentRootOmega.contentState === 'params_mtconnect'

            asynchronous: true
            anchors.fill: parent
            sourceComponent:CompHealthDashboardContentMTConnectOmega {
                id: compHealthDashboardContentMTConnect


                view: compHealthDashboardContentRootOmega.paramViewMode
                searchFieldText: compHealthDashboardContentRootOmega.searchFieldValue
                onForceViewType: txt => compHealthDashboardContentRootOmega.paramViewMode = txt

                //onFloatingBreadCrumbNameChanged: {
                //    compHealthDashboardContentRootOmega.floatingBreadcrumbBtntext = compHealthDashboardContentParams.floatingBreadCrumbName
                //}

                onForceViewModeMaximized: {
                    compHealthDashboardContentRootOmega.forceViewModeMaximized()
                }

                onParamSelected: txt => compHealthDashboardContentRootOmega.paramNameSelected = txt

                onSetGridBtnVisible: isVis => {
                                         compHealthDashboardContentRootOmega.isBtnGridViewVisible = isVis
                                     }

                onSetListBtnVisible: isVis => {
                                         compHealthDashboardContentRootOmega.isBtnListViewVisible = isVis
                                     }
                context1Selected: compHealthDashboardContentRootOmega.mtcSortFilterString

            }
        }


    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#000000";formeditorZoom:0.66;height:1920;width:1080}
}
##^##*/
