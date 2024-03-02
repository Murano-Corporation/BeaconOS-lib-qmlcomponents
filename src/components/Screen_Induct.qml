import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Screen__BASE {
    id: screenRepairRoot

    property color colorNavButton1: "#8BBEC4"
    property var listStatesBreadcrumb: []

    property string assetNameSelected: "F/A-18: 168267"
    property string assetInductionDateSelected: "01-02-2024 16:43:05"
    property string assetDetailsSelected
    property string assetImagePath: "file:///usr/share/BeaconOS-lib-images/images/Induct_Asset_Growler.png"
    property string selectedQuadrant: "Q4"
    property string bureauNumberSelected
    property string zoneIdSelected: "18.10, 18.12"

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


    function selectBuNo(buNo)
    {
        screenRepairRoot.bureauNumberSelected = buNo

        setState("Select_Quadrant")
    }

    function selectAsset(name, inductionDate, details, imgPath)
    {
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
    onStateChanged: {
        if(state === "Start")
        {
            listStatesBreadcrumb = ["Start"]
            return
        }
    }

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
        },
        State{
            name: "Select"
        },
        State{
            name: "Identify"
        },
        State{
            name: "Select_Quadrant"
        },
        State{
            name: "Select_Zone"

        },
        State{
            name: "Inspect"
        }
    ]

    CompBtnBreadcrumb {
        id: compBtnArrow

        text: "BACK"

        anchors{
            top: parent.top
            left: parent.left
        }

        visible: screenRepairRoot.state !== "Start"

        onClicked: {
            screenRepairRoot.goBack()
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
            active: screenRepairRoot.state === "Start"
            anchors.fill: parent
            asynchronous: true
            sourceComponent: Subscreen_Induct_Start{

                onInductAssetClicked: {
                    console.log("It were clicked")

                    screenRepairRoot.setState("Select")
                }

                onStartInspectClicked: {
                    console.log("It were clicked")

                    screenRepairRoot.setState("Select")
                }

                onContinueInspectClicked: {
                    console.log("It were clicked")

                    screenRepairRoot.setState("Select")
                }
            }
        }



        Loader{
            active: screenRepairRoot.state === "Select"
            asynchronous: true
            anchors.fill: parent

            sourceComponent: Subscreen_Induct_Select{
                id: subscreen_Select

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
            active: screenRepairRoot.state === "Identify"
            anchors.fill: parent
            asynchronous: true
            sourceComponent: Subscreen_Induct_IdentifyViaBuNo{
                id: subscreen_Identify

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
            active: screenRepairRoot.state === "Select_Quadrant"
            anchors.fill: parent
            asynchronous: true
            sourceComponent: Subscreen_Induct_SelectQuadrant{
                id: subscreenSelectQuadrant

                onQuadrantSelected: quadrantId => {

                                        screenRepairRoot.selectQuadrant(quadrantId)
                                    }
            }

        }

        Loader{
            active: screenRepairRoot.state === "Select_Zone"
            anchors.fill: parent
            asynchronous: true
            sourceComponent: Subscreen_Induct_SelectDoor{
                id: subscreenSelectZone

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
            active: screenRepairRoot.state === "Inspect"
            sourceComponent: Subscreen_Induct_Inspect{
                id: subscreenInspect
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