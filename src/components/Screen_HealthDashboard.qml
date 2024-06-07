import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.qmlmodels 1.0
import CONSTANTS 1.0

Screen__BASE {
    id: screenHealthDashboardRoot
    anchors.fill: parent

    property string beaconID: AssetInfo.beaconID
    property string assetName: AssetInfo.assetName
    property string serial: AssetInfo.serialNumber
    property string materialId: AssetInfo.materialID
    property string assetStatus: AssetInfo.assetState
    property string assetType: AssetInfo.assetType
    property string viewTabCurrent: "Parameters"
    property string viewModeselected: "list"
    property string searchFieldValue: ""
    property string filterAssetTypeSelected: "null"
    property string filterSystemTypeSelected: "null"
    property string filterContext1Selected: "null"
    property string filterContext2Selected: "null"
    property string parameterNameSelected: "null"
    property string searchFieldPlaceholderText: "Search list of parameters"
    property var listOfNotifications: []
    property var listOfHotParams
    property bool isViewMaximized: false
    property bool isDrawerDisplayed: true
    property string currentView: ChatControllerAI.chatSessionActive ? "Live Data" : ""

    bCanLeaveScreen: !ChatControllerAI.chatSessionActive

    onBAttemptingToLeaveScreenChanged: {
        if(!bAttemptingToLeaveScreen)
            return;

        dlgYesNo.headerText = qsTr("Leave Screen and Exit Chat?")
        dlgYesNo.bodyText = qsTr("You are attempting to leave the screen while an AI Chat Session is in progress.Really leave the screen and terminate the AI Chat Session?")
        dlgYesNo.funcOnYes = function(){
            dlgYesNo.close();
            ChatControllerAI.chatSessionActive = false;
            SingletonScreenManager.screenLeaveResponse_OK();
        }

        dlgYesNo.funcOnNo = function(){
            dlgYesNo.close();
        }

        bAttemptingToLeaveScreen = false
        dlgYesNo.open()
    }



    onParameterNameSelectedChanged: {
        //console.log('-----------------------------------------------------------------------PAramName selected now: ' + parameterNameSelected)
        LiveGraphController.targetDataId = parameterNameSelected
    }

    Component.onCompleted: {
        //console.log("Child level on completed")
        LiveGraphController.targetAssetId = beaconID

        MqttTopicBeaconIdDict.slot_Subscribe();
        MqttTopicHealth.slot_Subscribe();

        isDrawerDisplayed = Settings.getHealthDashboardDefaultDrawerOpen()
        if(!isDelta)
            tmrDelayOpenDrawerOnCompleted.start()
    }

    function setOverlayDefaults(){
        //console.log("Setting child level values...")
        var openSize = Qt.size(651,706)
        var openOrigin = Qt.point(40, 307)


        SingletonOverlayManager.setPerScreenPopupOpenRect("Chat AI", openOrigin, openSize);

        openSize = Qt.size(651, 706)
        openOrigin = Qt.point(723, 307)
        SingletonOverlayManager.setPerScreenPopupOpenRect("NSN Viewer", openOrigin, openSize);

        openSize = Qt.size(1920,1080)
        openOrigin = Qt.point(0, 0)
        SingletonOverlayManager.setPerScreenPopupOpenRect("WiFi Viewer", openOrigin, openSize);
    }


    onAssetTypeChanged: {
        listOfHotParams = Settings.getListOfHotParamsForType(assetType)
    }

    function toggleViewMaximized(){
        isViewMaximized = !isViewMaximized
    }

    function toggleDrawerDisplayed(){
        isDrawerDisplayed = !isDrawerDisplayed
    }
    Timer{
        id: tmrDelayOpenDrawerOnCompleted
        interval: 200

        onTriggered: {
            if(ChatControllerAI.chatSessionActive){
                screenHealthDashboardRoot.currentView = "Live Data";
            }
            else {
                drawerAssetDashboardMenu.open()
            }
        }
    }

    Loader {
        id: delta_health_dashboard
        active: screenHealthDashboardRoot.isDelta
        anchors.fill: parent
        sourceComponent: Screen_HealthDashboard_Delta{
        }
    }

    Loader {
        id: omega_health_dashboard
        active: !screenHealthDashboardRoot.isDelta

        onActiveChanged: {
            console.log("Omega Health Dashboard is active: " + active)
        }

        anchors.fill: parent

        sourceComponent: Screen_HealthDashboard_Omega {}


    }

    DrawerAssetDashboardMenu {
        id: drawerAssetDashboardMenu
        visible: !isDelta

        currentScreen: screenHealthDashboardRoot.currentView

        onItemClicked: function(itemName)
        {
            screenHealthDashboardRoot.currentView = itemName
        }
    }

    CompIconBtn {

        id: iconBtnAssetInfo
        visible: !isDelta

        anchors {
            top: parent.top
            left: parent.left
            topMargin: 80
            leftMargin: 66
        }

        height: 100
        width: 100
        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/ListFill.svg"
        iconColor: "White"

        onClicked: {
            drawerAssetDashboardMenu.open()
        }
    }

    Loader{
        id: loaderCameraPopup
        anchors.fill: parent

        active: false

        sourceComponent: Screen_Camera_Delta{
            isOverlayMode: true
            beaconId: AssetInfo.beaconID
            assetId: AssetInfo.assetName

            onCancelClicked: loaderCameraPopup.active = false

            onViewFullGalleryClicked: {
                comHealthDashboardContent.setSystemTypeSelection('Camera Gallery')
                loaderCameraPopup.active = false
            }


        }
    }

    Loader{
        id: loaderMapView

        active: false

        height: parent.height
        width: parent.width

        property point centerOnPoint
        sourceComponent: Popup{
            id: popupMapView

            property point centerOnPoint: Qt.point(0,0)
            onCenterOnPointChanged: {
                if(popupMapView.centerOnPoint.x !== 0 && popupMapView.centerOnPoint.y !== 0)
                {
                    //console.log('Opening map view')
                    mapViewer.addPoint(centerOnPoint.x, centerOnPoint.y, "Vehicle")
                    popupMapView.open()
                }
            }

            Component.onCompleted:{
                popupMapView.centerOnPoint = loaderMapView.centerOnPoint
            }

            onVisibleChanged: {
                if(visible === true)
                {
                    return
                }

                loaderMapView.centerOnPoint = undefined
                loaderMapView.active = false
            }

            background: Rectangle{
                color: '#21000000'
            }



            CompMapViewer{
                id: mapViewer
                width: 600
                height: 400

                centerPoint: popupMapView.centerOnPoint

                anchors{
                    centerIn: parent
                }
            }
        }


    }

    DlgYesNo {
        id: dlgYesNo
    }

}
