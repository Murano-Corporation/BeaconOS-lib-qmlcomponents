import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.qmlmodels 1.0
import CONSTANTS 1.0

Item {
    property alias comHealthDashboardContent: inner_comHealthDashboardContent
    //property alias hotParamLocation: inner_hotParamLocation
    property alias topControlGroup: inner_topControlGroup
    property alias compFlippableAssetMetaData: inner_compFlippableAssetMetaData
    property alias compDrawerInfo: inner_compDrawerInfo

    width: 1818
    //clip: true
    anchors{
        horizontalCenter: parent.horizontalCenter
        top: parent.top
        bottom: parent.bottom
    }


    Item{
        id: inner_topControlGroup
        clip: true
        anchors{
            left: parent.left
            top: parent.top
            right: parent.right
        }

        height: compFlippableAssetMetaData.height
        state: "normal"

        Connections{
            target: comHealthDashboardContent

            function onToggleViewModeClicked(){

                //console.log("FRONTEND::TOGGLE VIEW MODE CLICKED")

                if (topControlGroup.state === "normal")
                {
                    topControlGroup.state = "maximized"

                } else {
                    topControlGroup.state = "normal"
                }
            }

            function onForceViewModeMaximized(){
                topControlGroup.state = "maximized"
            }
        }


        CompFlippableAssetMetaData {
            id: inner_compFlippableAssetMetaData

            assetType: screenHealthDashboardRoot.assetType

            anchors.bottom: parent.bottom


        }

        GridView{
            anchors{
                left: compFlippableAssetMetaData.right
                leftMargin: 30

                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }

            boundsBehavior: Flickable.StopAtBounds

            cellWidth: width * 0.33333
            cellHeight: height * 0.5

            model: screenHealthDashboardRoot.listOfHotParams


            delegate: CompAssetHotParam {
                id: inner_hotParamLocation

                property var myModel: modelData
                property bool isGpsLocation: paramName === 'GPS LOCATION'


                paramName: Settings.getDataMapKeyForHotParam(modelData)
                displayName: Settings.getDisplayStringForHotParam(modelData)
                value1: Settings.getDefaultValueForHotParam(modelData)
                value2: Settings.getDefaultUnitForHotParam(modelData)
                color2: "#9287ED"
                color1: "#709060"
                iconPath: Settings.getIconPathForHotParam(modelData)

                //Connections{
                //    target: TableModelHealthDashboard
                //
                //    function onDataChanged(indexLeft, indexRight, role)
                //    {
                //        console.log("Data changed signal got!")
                //    }
                //}

                Component.onCompleted: {
                    //console.log("Connecting to signal!")
                    TableModelHealthDashboard.dataChanged.connect(onDataChanged)
                }

                Component.onDestruction: {

                    if(!TableModelHealthDashboard)
                        return

                    TableModelHealthDashboard.dataChanged.disconnect(onDataChanged)
                }

                function onDataChanged(indexLeft, indexRight, role)
                {

                    //console.log("Data Changed!")
                    if(!TableModelHealthDashboard)
                        return

                    if(isGpsLocation)
                    {
                        //console.log("GPS Data Changed; Fetching pretty string!")
                        value1 = TableModelHealthDashboard.getGpsLocationString();
                        return;
                    }

                    var dataChangedName = TableModelHealthDashboard.data(indexLeft, Constants.DataRole_ParamName)
                    //console.log("Param Data Changed " + dataChangedName)
                    if(dataChangedName === paramName)
                    {
                        //console.log('My data changed!!!')
                        value1 = TableModelHealthDashboard.data(indexLeft, Constants.DataRole_Value)
                        value2 = TableModelHealthDashboard.data(indexLeft, Constants.DataRole_Unit)
                    }

                    //console.log('DataChanged for ' + dataChangedName)
                    //console.log('My Paramname is ' + paramName)
                }

                MouseArea{
                    visible: isGpsLocation

                    anchors.fill: parent

                    onClicked: {
                        var ptCenter = Qt.point(0,0)
                        var lat = AssetInfo.gpsLatValue
                        var lon = AssetInfo.gpsLonValue
                        ptCenter.x = lat
                        ptCenter.y = lon

                        loaderMapView.centerOnPoint = ptCenter
                        loaderMapView.active = true

                    }
                }
            }

        }


        states:[
            State{
                name: "normal"

                PropertyChanges{
                    target: topControlGroup

                    height: compFlippableAssetMetaData.height
                }
            },
            State{
                name: "maximized"

                PropertyChanges{
                    target: topControlGroup

                    height: -40

                }
            }
        ]

        transitions: [
            Transition {
                from: "normal"
                to: "maximized"

                PropertyAnimation{
                    properties: "height"
                    duration: 250
                }

            },
            Transition{
                from: "maximized"
                to: "normal"

                PropertyAnimation{
                    properties: "height"
                    duration: 250
                }
            }
        ]
    }

    CompDrawerInfo {
        id: inner_compDrawerInfo

        signal showComplete();
        signal hideComplete();

        beaconID: screenHealthDashboardRoot.beaconID
        assetID: screenHealthDashboardRoot.assetName

        isOpen: true
        clip: false

        onShowBtnClicked: screenHealthDashboardRoot.isDrawerDisplayed = true
        onHideBtnClicked: screenHealthDashboardRoot.isDrawerDisplayed = false
        onGalleryBtnClicked: {
            compDrawerInfo.hideComplete.connect(navigateToGallery)
            screenHealthDashboardRoot.isDrawerDisplayed = false
        }
        onCameraBtnClicked: {
            compDrawerInfo.hideComplete.connect(showCameraOverlay)
            screenHealthDashboardRoot.isDrawerDisplayed = false
        }

        function navigateToGallery(){
            compDrawerInfo.hideComplete.disconnect(navigateToGallery)
            topControlGroup.state = 'maximized'
            comHealthDashboardContent.setViewMode_Grid()
            comHealthDashboardContent.setSystemTypeSelection('Camera Gallery')
        }

        function showCameraOverlay(){
            compDrawerInfo.hideComplete.disconnect(showCameraOverlay)
            loaderCameraPopup.active = true
        }

        anchors{

            top: topControlGroup.bottom
            topMargin: 33
            left: topControlGroup.left
            leftMargin: 0
            bottom: parent.bottom
            bottomMargin: 55
        }

        width: compFlippableAssetMetaData.width

        state: screenHealthDashboardRoot.isDrawerDisplayed ? "show" : "hide"
        globalOpacity: screenHealthDashboardRoot.isDrawerDisplayed ? 1.0 : 0.0

        states: [
            State {
                name: "hide"
                PropertyChanges { target: compDrawerInfo; anchors.leftMargin: (-(compDrawerInfo.width))}
            },
            State {
                name: "show"
                PropertyChanges { target: compDrawerInfo; anchors.leftMargin: 0 }
            }
        ]

        transitions: [
            Transition {

                from: "hide"
                to: "show"

                onRunningChanged: {
                    if(running === true)
                    {

                        compDrawerInfo.isOpen = true
                        compDrawerInfo.globalOpacity = 1.0
                    } else{
                        compDrawerInfo.showComplete()
                    }
                }

                PropertyAnimation {
                    properties: "anchors.leftMargin"
                    duration: 250

                }
            },
            Transition {
                from: "show"
                to: "hide"

                onRunningChanged: {
                    if(running === false)
                    {

                        compDrawerInfo.isOpen = false
                        compDrawerInfo.globalOpacity = 0.0
                        compDrawerInfo.hideComplete()
                    }
                }

                PropertyAnimation {
                    properties: "anchors.leftMargin"
                    duration: 250

                }
            }
        ]

    }

    CompHealthDashboardContent {
        id: inner_comHealthDashboardContent

        //onToggleViewModeClicked: screenHealthDashboardRoot.toggleViewMaximized()

        anchors{
            bottom: parent.bottom
            bottomMargin: 55
            left: compDrawerInfo.right
            leftMargin:  compDrawerInfo.isOpen ? 33 : 90
            right: parent.right
            top: topControlGroup.bottom
            topMargin: 33
        }

        onParamNameSelectedChanged: {
            //console.log('Paramname changed relay A')
            screenHealthDashboardRoot.parameterNameSelected = comHealthDashboardContent.paramNameSelected
        }


    }
}
