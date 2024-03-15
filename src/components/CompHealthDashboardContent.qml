import QtQuick 2.12

Comp__BASE {
    id: compHealthDashboardContentRoot



    property string searchFieldPlaceholderText: "Search all parameters"

    property int alertCount: 0
    property CompHealthDashboardViewNavBtn viewTabCurrent: btnViewParameters
    property string viewTabCurrentName: viewTabCurrent.tabName
    property string searchFieldValue: ""
    property string systemTypeSelected: "null"
    property string context1Selected: "null"
    property string context2Selected: "null"
    property string paramNameSelected: "null"
    property string floatingBreadcrumbBtntext: "null"
    property string paramViewMode: "List"
    property string paramViewMode_Last: paramViewMode
    property string assetType: AssetInfo.assetType
    property int galleryInstanceId: -1
    property string graphViewTarget: 'null'
    property CompHealthDashboardContentContextNav navObject: null

    property bool isBtnGridViewVisible: false
    property bool isBtnListViewVisible: false
    property bool isBtnGraphViewVisible: false

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
        compHealthDashboardContentContextNav.systemSelected = sSystemType
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

    //onParamViewModeChanged: {
    //    console.log("ParamView Mode now: " + paramViewMode)
    //
    //
    //}

    onContextNavCompletenessCheckChanged: {
        //console.log("ContextNavComplete?: " + contextNavCompletenessCheck)

        if(contextNavCompletenessCheck )
        {
            if(systemTypeSelected === 'Camera Gallery')
                contentState = 'gallery'
            else if(assetType === 'CNC')
                if(systemTypeSelected === 'Beacon Metrics')
                    contentState = 'params'
                else
                    contentState = 'params_mtconnect'
            else
                contentState = context1Selected === 'Tire' ? 'gallery' : 'params'
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
        {

            return;
        }

        updateModelDataFilters()

    }

    onSystemTypeSelectedChanged: {

        //console.log('System type changed to: ' + systemTypeSelected)
        btnViewParameters.clicked()
        checkContextNavCompleteness()
        if(blockModelDataFilterSignal)
        {
            //console.log('...Blocked')
            return;
        }

        blockModelDataFilterSignal = true
        context1Selected = "null"
        context2Selected = "null"
        paramNameSelected = "null"
        floatingBreadcrumbBtntext = "null"

        blockModelDataFilterSignal = false
        updateModelDataFilters()



    }

    onContext1SelectedChanged: {

        //console.log("Context 1 is now: " + context1Selected)

        btnViewParameters.clicked()
        checkContextNavCompleteness()
        if(blockModelDataFilterSignal)
        {
            //console.log('...Blocked')
            return;}

        blockModelDataFilterSignal = true

        context2Selected = "null"
        paramNameSelected = "null"
        floatingBreadcrumbBtntext = "null"

        blockModelDataFilterSignal = false
        updateModelDataFilters()


    }

    onContext2SelectedChanged: {

        //console.log("Context 2 is now: " + context2Selected)

        btnViewParameters.clicked()
        checkContextNavCompleteness()
        if(blockModelDataFilterSignal)
        {
            //console.log('...Blocked')
            return;
        }

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
            compHealthDashboardContentRoot.contextNavCompletenessCheck = true;
            return;
        }

        if(isComplete && (systemTypeSelected === 'Asset Metrics') && (assetType === 'CNC'))
        {
            compHealthDashboardContentRoot.contextNavCompletenessCheck = true;
            return;
        }

        isComplete &= (context1Selected !== 'null')
        if(isComplete && (systemTypeSelected === 'Beacon Metrics'))
        {
            compHealthDashboardContentRoot.contextNavCompletenessCheck = true;
            return;
        }

        if(isComplete && (systemTypeSelected === 'Asset Metrics') && (context1Selected === 'Tire'))
        {
            compHealthDashboardContentRoot.contextNavCompletenessCheck = true;
            return;
        }


        isComplete &= (context2Selected !== 'null')


        //console.log("...returning: " + isComplete)
        compHealthDashboardContentRoot.contextNavCompletenessCheck = isComplete

    }

    Rectangle{
        id: groupContentBg

        anchors{
            fill: parent
            topMargin: 95
        }

        color: "#14818087"
        rotation: 0
    }

    Rectangle {
        id: rectSelectedTabBg

        anchors{
            verticalCenter: groupContentBg.top
            left: parent.left
            leftMargin: -2
            right: parent.right
            rightMargin: -2
        }

        height: 6
        radius: 3
        color: "#4D4A5F"
    }

    Item {
        id: groupButtons
        height: 32

        property real btnWidth: (width * 0.3333)
        property color colorSelected: "#D9177D89"
        property color colorIdle: "#80177D89"
        property real iconSize: 32

        anchors{
            bottom: rectSelectedTabBg.top
            bottomMargin: 23
            left: parent.left
            right: parent.right
        }

        CompHealthDashboardViewNavBtn {
            id: btnViewSeverity

            enabled: false
            tabName: 'alerts'
            anchors.left: parent.left
            anchors.top: parent.top

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

        CompHealthDashboardViewNavBtn {
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
                compHealthDashboardContentRoot.viewTabCurrent = btnViewParameters
                rectSelectedTab.state = "parameters"
            }
        }

        CompHealthDashboardViewNavBtn {
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

                compHealthDashboardContentRoot.viewTabCurrent = btnViewCustom
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
                //horizontalCenter: compHealthDashboardContentRoot.viewTabCurrent.horizontalCenter
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

        onTextChanged: compHealthDashboardContentRoot.searchFieldValue = text

        anchors{
            top: rectSelectedTabBg.bottom
            topMargin: 34
            left: parent.left
            leftMargin: 34
            right: (btnGridView.visible ? btnGridView.left : (btnListView.visible ? btnListView.left : (btnGraphView.visible ? btnGraphView.left : (btnExpandShrink.visible ? btnExpandShrink.left : parent.right))))
            rightMargin: (!btnGridView.visible && !btnListView.visible && !btnExpandShrink.visible && !btnGraphView.visible ) ? 0 : 19
        }

        height: 48

        text: ""
        placeholderText: compHealthDashboardContentRoot.searchFieldPlaceholderText

    }

    CompIconBtn {
        id: btnGridView

        visible: compHealthDashboardContentRoot.isBtnGridViewVisible
        anchors{
            top:txtfldSearch.top
            bottom: txtfldSearch.bottom
            right: btnListView.left
            rightMargin: 20
        }

        iconColor: (compHealthDashboardContentRoot.paramViewMode === "Grid") ? "White" : "#80ffffff"
        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/GridFill.svg"
        height: 50

        onClicked: compHealthDashboardContentRoot.paramViewMode = "Grid"
    }

    CompIconBtn {
        id: btnListView

        visible: compHealthDashboardContentRoot.isBtnListViewVisible

        anchors{
            top:txtfldSearch.top
            bottom: txtfldSearch.bottom
            right: btnGraphView.visible ? btnGraphView.left : btnExpandShrink.left
            rightMargin: 20
        }

        iconColor: (compHealthDashboardContentRoot.paramViewMode === "List") ? "White" : "#80ffffff"
        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/ListFill.svg"
        height: 50

        onClicked: compHealthDashboardContentRoot.paramViewMode = "List"
    }

    CompIconBtn {
        id: btnGraphView
        enabled: compHealthDashboardContentRoot.paramNameSelected !== "null"
        visible: compHealthDashboardContentRoot.isBtnGraphViewVisible
        anchors {
            top:txtfldSearch.top
            bottom: txtfldSearch.bottom
            right: btnExpandShrink.left
            rightMargin: 20
        }

        iconColor: (compHealthDashboardContentRoot.paramViewMode === "Graph") ? "White" : "#80ffffff"
        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/GraphFill.svg"
        height: 50

        onClicked: {
            compHealthDashboardContentRoot.paramViewMode_Last = compHealthDashboardContentRoot.paramViewMode
            compHealthDashboardContentRoot.floatingBreadcrumbBtntext = compHealthDashboardContentRoot.paramNameSelected
            compHealthDashboardContentRoot.paramViewMode = "Graph"
        }
    }

    CompIconBtn {
        id: btnExpandShrink

        iconUrl: topControlGroup.state === "normal" ? "file:///usr/share/BeaconOS-lib-images/images/Expand.png" : "file:///usr/share/BeaconOS-lib-images/images/Shrink.png"
        iconColor: "White"
        onClicked: compHealthDashboardContentRoot.toggleViewModeClicked()

        anchors{
            top: txtfldSearch.top
            right: parent.right
            rightMargin: 34
            bottom: txtfldSearch.bottom
        }

        width: height
    }

    Flickable {
        id: groupBreadcrumbs

        property real spacing: 10
        clip: true
        visible: (compHealthDashboardContentRoot.systemTypeSelected !== "null")

        boundsBehavior: Flickable.StopAtBounds

        anchors{
            top: txtfldSearch.bottom
            topMargin: 19
            left: txtfldSearch.left
            right: btnExpandShrink.right
        }

        contentHeight: height
        contentWidth: contentItem.implicitWidth

        height: (groupBreadcrumbs.visible ? 60 : 0)

        CompBtnBreadcrumb {
            id: btnBreadcrumb1

            visible: compHealthDashboardContentRoot.systemTypeSelected !== "null"

            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top

            text: compHealthDashboardContentRoot.systemTypeSelected

            onClicked: {

                if(compHealthDashboardContentRoot.navObject === null)
                    compHealthDashboardContentRoot.systemTypeSelected = "null"
                else
                    compHealthDashboardContentRoot.navObject.systemSelected = "null"
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

            visible: (compHealthDashboardContentRoot.context1Selected !== "null" && btnBreadcrumb1.visible)

            anchors{
                top: parent.top
                left: sep1.right
                leftMargin: groupBreadcrumbs.spacing
                bottom: parent.bottom
            }

            onClicked: {
                if(compHealthDashboardContentRoot.navObject === null)
                    compHealthDashboardContentRoot.context1Selected = "null"
                else
                    compHealthDashboardContentRoot.navObject.context1Selected = "null"
            }

            text: compHealthDashboardContentRoot.context1Selected

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

            visible: (compHealthDashboardContentRoot.context2Selected !== "null" && btnBreadcrumb2.visible)

            anchors{
                top: parent.top
                left: sep2.right
                leftMargin: groupBreadcrumbs.spacing
                bottom: parent.bottom
            }

            onClicked: {

                if(compHealthDashboardContentRoot.navObject === null)
                    compHealthDashboardContentRoot.context2Selected = "null"
                else
                    compHealthDashboardContentRoot.navObject.context2Selected = "null"
            }

            text: compHealthDashboardContentRoot.context2Selected

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

            visible: (compHealthDashboardContentRoot.floatingBreadcrumbBtntext !== "null")

            anchors{
                top: parent.top
                left: sep3.right
                leftMargin: groupBreadcrumbs.spacing
                bottom: parent.bottom
            }

            onClicked: {
                compHealthDashboardContentRoot.floatingBreadcrumbBtntext = "null"
                compHealthDashboardContentRoot.paramNameSelected = 'null'
            }

            text: compHealthDashboardContentRoot.floatingBreadcrumbBtntext

            height: parent.height

        }
    }

    Item {
        id: viewContents


        property real contentsWidth: parent.width
        property real btnWidth: ((parent.width * 0.25) - ((btnSpacing * 0.33) * 4))
        property real btnSpacing: 41

        anchors{
            top: groupBreadcrumbs.bottom
            topMargin: 20
            left: groupBreadcrumbs.left
            bottom: parent.bottom
            bottomMargin: 20

            right: groupBreadcrumbs.right
        }

        Loader{
            id: loaderContentNav
            active: (compHealthDashboardContentRoot.contentState === "context_nav")
            onActiveChanged:{
                if(active === false)
                {
                    compHealthDashboardContentRoot.navObject = null
                    return
                }

                compHealthDashboardContentRoot.isBtnGridViewVisible = false
                compHealthDashboardContentRoot.isBtnListViewVisible = false
            }

            asynchronous: true
            anchors.fill: parent
            sourceComponent: CompHealthDashboardContentContextNav {
                id: compHealthDashboardContentContextNav

                onSystemSelectedChanged: {
                    compHealthDashboardContentRoot.systemTypeSelected = compHealthDashboardContentContextNav.systemSelected
                }

                onContext1SelectedChanged: {
                    compHealthDashboardContentRoot.context1Selected = compHealthDashboardContentContextNav.context1Selected
                }

                onContext2SelectedChanged: {
                    compHealthDashboardContentRoot.context2Selected = compHealthDashboardContentContextNav.context2Selected
                }

                Component.onCompleted: {
                    compHealthDashboardContentRoot.navObject = this

                    systemSelected = compHealthDashboardContentRoot.systemTypeSelected
                    context1Selected = compHealthDashboardContentRoot.context1Selected
                    context2Selected = compHealthDashboardContentRoot.context2Selected

                }
            }
        }



        Loader{
            id: loaderContentParams

            active: (compHealthDashboardContentRoot.contentState !== "context_nav" && compHealthDashboardContentRoot.contentState !== 'params_mtconnect')

            asynchronous: true
            anchors.fill: parent

            sourceComponent: CompHealthDashboardContentParams {
                id: compHealthDashboardContentParams

                targetData: (visible ? (compHealthDashboardContentRoot.contentState) : "")
                view: compHealthDashboardContentRoot.paramViewMode

                onForceViewType: txt => compHealthDashboardContentRoot.paramViewMode = txt

                onFloatingBreadCrumbNameChanged: {
                    compHealthDashboardContentRoot.floatingBreadcrumbBtntext = compHealthDashboardContentParams.floatingBreadCrumbName
                }

                onForceViewModeMaximized: {
                    compHealthDashboardContentRoot.forceViewModeMaximized()
                }

                onParamSelected: txt => compHealthDashboardContentRoot.paramNameSelected = txt

                onSetGridBtnVisible: isVis => {
                                         compHealthDashboardContentRoot.isBtnGridViewVisible = isVis
                                     }

                onSetListBtnVisible: isVis => {
                                         compHealthDashboardContentRoot.isBtnListViewVisible = isVis
                                     }

                Connections{
                    target: compHealthDashboardContentRoot

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

            active: compHealthDashboardContentRoot.contentState === 'params_mtconnect'

            asynchronous: true
            anchors.fill: parent
            sourceComponent:         CompHealthDashboardContentMTConnect {
                id: compHealthDashboardContentMTConnect


                view: compHealthDashboardContentRoot.paramViewMode
                searchFieldText: compHealthDashboardContentRoot.searchFieldValue
                onForceViewType: txt => compHealthDashboardContentRoot.paramViewMode = txt

                //onFloatingBreadCrumbNameChanged: {
                //    compHealthDashboardContentRoot.floatingBreadcrumbBtntext = compHealthDashboardContentParams.floatingBreadCrumbName
                //}

                onForceViewModeMaximized: {
                    compHealthDashboardContentRoot.forceViewModeMaximized()
                }

                onParamSelected: txt => compHealthDashboardContentRoot.paramNameSelected = txt

                onSetGridBtnVisible: isVis => {
                                         compHealthDashboardContentRoot.isBtnGridViewVisible = isVis
                                     }

                onSetListBtnVisible: isVis => {
                                         compHealthDashboardContentRoot.isBtnListViewVisible = isVis
                                     }

            }
        }




    }
}
