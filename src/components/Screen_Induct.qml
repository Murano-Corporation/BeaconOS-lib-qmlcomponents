import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Screen__BASE {
    id: screenRepairRoot

    property color colorNavButton1: "#8BBEC4"
    property var listStatesBreadcrumb: []

    property string assetNameSelected: ""
    property string assetInductionDateSelected: ""
    property string assetDetailsSelected
    property string assetImagePath: ""
    property string selectedQuadrant: ""
    property string bureauNumberSelected: ""
    property string zoneIdSelected: ""
    property string subscreenTitleText: ""
    property string titleText: {
        var retString = ""

        if(assetNameSelected !== "")
        {
            retString += assetNameSelected
        }

        if(bureauNumberSelected !== "")
        {
            retString += ": " + bureauNumberSelected
        }

        if(selectedQuadrant !== "")
        {
            retString += "  |  " + selectedQuadrant
        }

        if(zoneIdSelected !== "")
        {
            retString += "  |  " + zoneIdSelected
        }

        if(retString !== "")
        {
            retString += ": "
        }

        retString += subscreenTitleText

        return retString
    }

    signal signal_InductAsset();
    signal signal_StartInspect();
    signal signal_ContinueInspect();

    anchors.fill: parent

    onSignal_InductAsset: {
        setState("Select")
    }

    onSignal_StartInspect: {
        setState("Select")
    }

    onSignal_ContinueInspect: {
        setState("Select")
    }

    onStateChanged: {
        console.log("State changed to: " + state)

        if(state === "Start")
        {
            listStatesBreadcrumb = ["Start"]
            return
        }
    }

    onAssetNameSelectedChanged: {
        console.log("Asset Name Selected now: " + assetNameSelected)
    }

    onAssetInductionDateSelectedChanged: {
        console.log("Asset Induction Date Selected now: " + assetInductionDateSelected)
    }

    onAssetDetailsSelectedChanged: {
        console.log("Asset Details Selected now: " + assetDetailsSelected)
    }

    onAssetImagePathChanged: {
        console.log("Asset Img Path Selected now: " + assetImagePath)
    }

    function selectBuNo(buNo)
    {
        screenRepairRoot.bureauNumberSelected = buNo

        setState("Select_Quadrant")
    }

    function selectAsset(name, inductionDate, details, imgPath)
    {

        console.log("Setting Asset:")

        screenRepairRoot.assetNameSelected = name
        screenRepairRoot.assetInductionDateSelected = inductionDate
        screenRepairRoot.assetDetailsSelected = details
        screenRepairRoot.assetImagePath = imgPath

        setState("Identify")
    }

    function selectZoneId(zoneId)
    {
        screenRepairRoot.zoneIdSelected = zoneId

        setState("Inspect")
    }

    function selectQuadrant(quadrantId)
    {
        screenRepairRoot.selectedQuadrant = quadrantId

        setState("Select_Zone")
    }


    function setState(toState)
    {

        addStateBreadcrumb(screenRepairRoot.state)
        screenRepairRoot.state = toState
    }

    state:  "Start"

    function goBack(){
        var targetState = listStatesBreadcrumb[ listStatesBreadcrumb.length - 1 ]
        listStatesBreadcrumb.pop()

        state = targetState
    }

    function addStateBreadcrumb(stateName)
    {
        listStatesBreadcrumb.push( stateName )
    }

    states: [
        State {
            name: "Start"

            PropertyChanges {
                target: screenRepairRoot
                restoreEntryValues: false
                explicit: true
                assetNameSelected: ""
                assetInductionDateSelected: ""
                assetDetailsSelected: ""
                assetImagePath: ""
                selectedQuadrant: ""
                bureauNumberSelected: ""
                zoneIdSelected: ""
                subscreenTitleText: ""

            }

        },
        State{
            name: "Select"

            PropertyChanges {
                target: screenRepairRoot
                explicit: true
                restoreEntryValues: false
                assetDetailsSelected: ""
                assetImagePath: ""
                assetNameSelected: ""
                assetInductionDateSelected: ""
                selectedQuadrant: ""
                bureauNumberSelected: ""
                zoneIdSelected: ""
                subscreenTitleText: "Select Asset for Inspection"

            }
        },
        State{
            name: "Identify"

            PropertyChanges {
                target: screenRepairRoot
                explicit: true
                restoreEntryValues: false
                selectedQuadrant: ""
                bureauNumberSelected: ""
                zoneIdSelected: ""
                subscreenTitleText: "Identify Aircraft via Bureau Number"

            }
        },
        State{
            name: "Select_Quadrant"

            PropertyChanges {
                target: screenRepairRoot
                explicit: true
                restoreEntryValues: false
                selectedQuadrant: ""
                zoneIdSelected: ""
                subscreenTitleText: "Select Quadrant for Inspection"

            }
        },
        State{
            name: "Select_Zone"

            PropertyChanges {
                target: screenRepairRoot
                explicit: true
                restoreEntryValues: false
                zoneIdSelected: ""
                subscreenTitleText: "Select Door for Inspection"

            }

        },
        State{
            name: "Inspect"

            PropertyChanges {
                target: screenRepairRoot
                explicit: true
                restoreEntryValues: false
                subscreenTitleText: ""

            }
        }
    ]

    CompBtnBreadcrumb {
        id: compBtnArrow

        text: "BACK"

        anchors{
            top: parent.top
            topMargin: 32
            left: parent.left
        }

        visible: screenRepairRoot.state !== "Start"

        onClicked: {
            screenRepairRoot.goBack()
        }
    }


    CompLabel{
        id: lblTitle

        visible: compBtnArrow.visible
        text: screenRepairRoot.titleText

        anchors{
            left: compBtnArrow.right
            leftMargin: 40
            verticalCenter: compBtnArrow.verticalCenter
        }

    }

    Item{
        id: contentRoot

        anchors{
            top: compBtnArrow.visible ? compBtnArrow.bottom : parent.top
            topMargin: compBtnArrow.visible ? 40 : 0
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 40
        }

        Loader{
            active: screenRepairRoot.state === "Start" || screenRepairRoot.state === "Select"
            anchors.fill: parent
            asynchronous: true
            sourceComponent: Subscreen_Induct_Start{

                visible: screenRepairRoot.state === "Start"

                onInductAssetClicked: {
                    //console.log("It were clicked")

                    screenRepairRoot.setState("Select")
                }

                onStartInspectClicked: {
                    //console.log("It were clicked")

                    screenRepairRoot.setState("Select")
                }

                onContinueInspectClicked: {
                    //console.log("It were clicked")

                    screenRepairRoot.setState("Select")
                }
            }
        }



        Loader{
            active: screenRepairRoot.state === "Select" || screenRepairRoot.state === "Start" || screenRepairRoot.state === "Identify"
            asynchronous: true
            anchors.fill: parent

            sourceComponent: Subscreen_Induct_Select{
                id: subscreen_Select

                visible: screenRepairRoot.state === "Select"

                onAssetSelected: {
                    screenRepairRoot.selectAsset(
                                subscreen_Select.assetNameSelected,
                                subscreen_Select.assetInductionDateSelected,
                                subscreen_Select.assetDetailsSelected,
                                subscreen_Select.assetImagePath
                                )
                }
            }

        }

        Loader{
            active: screenRepairRoot.state === "Identify"  || screenRepairRoot.state === "Start" || screenRepairRoot.state === "Select"
            anchors.fill: parent
            asynchronous: true
            sourceComponent: Subscreen_Induct_IdentifyViaBuNo{
                id: subscreen_Identify
                visible: screenRepairRoot.state === "Identify"

                onNextClicked: {
                    screenRepairRoot.selectBuNo(subscreen_Identify.indexOfBuNoSelected)
                }

                assetImagePath: screenRepairRoot.assetImagePath
                assetName: screenRepairRoot.assetNameSelected
                assetInductionDate: screenRepairRoot.assetInductionDateSelected
                assetDetails: screenRepairRoot.assetDetailsSelected
            }

        }


        Loader{
            active: screenRepairRoot.state === "Select_Quadrant"  || screenRepairRoot.state === "Identify" || screenRepairRoot.state === "Select"
            anchors.fill: parent
            asynchronous: true
            sourceComponent: Subscreen_Induct_SelectQuadrant{
                id: subscreenSelectQuadrant
                visible: screenRepairRoot.state === "Select_Quadrant"
                onQuadrantSelected: quadrantId => {

                                        screenRepairRoot.selectQuadrant(quadrantId)
                                    }
            }

        }

        Loader{
            active: screenRepairRoot.state === "Select_Zone"  || screenRepairRoot.state === "Select_Quadrant" || screenRepairRoot.state === "Inspect"
            anchors.fill: parent
            asynchronous: true
            sourceComponent: Subscreen_Induct_SelectDoor{
                id: subscreenSelectZone
                visible: screenRepairRoot.state === "Select_Zone"

                quadrantId: screenRepairRoot.selectedQuadrant
                assetImgPath: screenRepairRoot.assetImagePath
                assetName: screenRepairRoot.assetNameSelected

                onZoneSelected: zone => {
                                    screenRepairRoot.selectZoneId(zone)
                                }

            }

        }

        Loader{
            anchors.fill: parent
            asynchronous: true
            active: screenRepairRoot.state === "Inspect"  || screenRepairRoot.state === "Select_Zone"
            sourceComponent: Subscreen_Induct_Inspect{
                id: subscreenInspect
                visible: screenRepairRoot.state === "Inspect"

                assetName: screenRepairRoot.assetNameSelected
                quadrantId: screenRepairRoot.selectedQuadrant
                zoneId:  screenRepairRoot.zoneIdSelected

            }
        }


    }



}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.33;height:1080;width:1920}
}
##^##*/
