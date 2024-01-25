import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

ApplicationWindow {
    id: root
    width: 1920
    height: 1080
    visible: true
    title: qsTr("Beacon OS")
    visibility: "FullScreen"

    property string screenToLoad: "Welcome"
    property bool showToolbar: false
    property var screenMetaData
    
    Connections {
        target: SingletonScreenManager

        onSignal_CurrentScreenChanged: function onSignal_CurrentScreenChanged(screenName, metaData) {
            screenMetaData = metaData
            screenToLoad = screenName
        }

        onSignal_ShowToolbarChanged: function onSignal_ShowToolbarChanged(bShowToolbar) {
            showToolbar = bShowToolbar
        }
    }

    Connections {
        target: SingletonOverlayManager

        function onSignal_OverlayOpened(overlayName, metaData) {

            if (overlayName === 'MsgBoxInfo') {
                //console.log('FRONTEND:: OPEN OVERLAY:: ' + overlayName + " METADATA: " + metaData)
                overlayMsgBoxInfo.textTitle = metaData.title
                overlayMsgBoxInfo.textMessage = metaData.msg
                overlayMsgBoxInfo.open()
            }
        }
    }



    CompAnimatedGradientBg{
        id: rectBg_Home
        anchors.fill: parent

        visible: screenToLoad === 'Home' || screenToLoad === 'Welcome' || screenToLoad === "Login"
    }

    Rectangle{
        id: rectBg_Default

        anchors.fill: root.contentItem
        visible: false

    }

    LinearGradient{
        id: gradientBgDefault

        anchors.fill: rectBg_Default

        visible: !rectBg_Home.visible

        source: rectBg_Default
        start: Qt.point(0, height)
        end: Qt.point(0,0)
        cached: true
        antialiasing: true

        layer.smooth: true
        smooth: true
        gradient: Gradient{


            GradientStop{
                position: 0.0
                color: "#031125"
            }

            GradientStop{
                position: 1.0
                color: "#1C252E"
            }


        }
    }



    Item{
        id: areaToolbar

        anchors{
            top: root.contentItem.top
            left: root.contentItem.left
            right: root.contentItem.right

            topMargin: 34
            rightMargin: 38
            leftMargin: 38

        }

        height: (loaderToolbar.active ? 30 : 1)

        Loader {
            id: loaderToolbar
            active: showToolbar

            anchors{
                fill: parent
            }

            z: 100

            sourceComponent: CompToolbar {}
        }


    }



    Item {
        id: areaContent

        anchors{
            top: areaToolbar.bottom
            topMargin: 20
            left: areaToolbar.left
            right: areaToolbar.right
            bottom: root.contentItem.bottom
        }

        Loader {
            id: loaderLogin
            anchors.fill: parent
            active: screenToLoad === "Login"
            sourceComponent: Screen_Login {}

            onActiveChanged: {
                if (loaderLogin.active)
                    SingletonScreenManager.showToolbar = false
            }
        }

        Loader {
            id: loaderWelcome

            anchors.fill: areaContent
            active: screenToLoad === "Welcome"
            sourceComponent: Screen_Welcome {}

            onActiveChanged: {
                if (loaderWelcome.active)
                    SingletonScreenManager.showToolbar = false
            }
        }

        Loader {
            id: loaderHome
            active: screenToLoad === "Home"
            anchors.fill: areaContent
            sourceComponent: Screen_Home {}

            onActiveChanged: {
                if (loaderHome.active) {
                    SingletonScreenManager.showToolbar = true
                }
            }
        }

        Loader {
            id: loaderHealth
            active: screenToLoad === "Asset Dashboard"
            anchors.fill: areaContent
            sourceComponent: Screen_AssetDashboard {}
        }

        Loader {
            anchors.fill: areaContent
            active: screenToLoad === "Health Dashboard"
            sourceComponent: Screen_HealthDashboard {

                Connections{
                    target: root

                    onScreenMetaDataChanged: {
                        loadMetaData();
                    }
                }

                Component.onCompleted:
                {
                    loadMetaData();


                }

                function loadMetaData(){
                    if(root.screenMetaData !== undefined)
                    {
                        var beaconID = SingletonUtils.getBeaconIDFromMapData(root.screenMetaData);
                        if(beaconID === "")
                        {
                            console.log("Failed pre-setting beacon ID for Health Dashboard")


                        } else {
                            MQTT.slot_SetCurrentBeacon(beaconID)
                            CameraController.slot_SetTargetBeaconId(beaconID)
                        }

                    }
                }

            }
        }

        Loader {
            anchors.fill: areaContent
            active: screenToLoad === "Camera"
            sourceComponent: Screen_Camera {
            }
        }

        Loader {
            anchors.fill: areaContent
            active: screenToLoad === "Chrome"
            sourceComponent: Screen_Browser {}
        }

        Loader {
            id: loaderReference

            anchors.fill: areaContent
            active: screenToLoad === "Reference"
            sourceComponent: Screen_Reference {}
        }

        Loader {
            id: loaderWIP

            anchors.fill: areaContent
            active: (
                        screenToLoad === "App Store" ||
                        screenToLoad === "Model Store")
            sourceComponent: Screen_WIP {}
        }
    }

    Item{
        id:areaOverlay

        anchors.fill: parent
    }

    Overlay_MessageBox_Info {
        id: overlayMsgBoxInfo
    }


    Loader {
        id: loaderPopupChatAI

        property var mapData

        active: false
        anchors{
            fill: root.contentItem
        }

        sourceComponent: CompConversationalAIChat{

            onClosed: {
                loaderPopupChatAI.active = false
            }

            Component.onCompleted:{
                open()
            }
        }

        Connections{
            target: ApplicationsController

            onSignal_Request_OpenChatAI: function(mapData){
                //console.log("Requesting open Chat AI viewer")
                loaderPopupChatAI.mapData = mapData
                loaderPopupChatAI.active = true
            }
        }

    }

    Loader{
        id: loaderPopupNsnViewer

        active: false

        anchors{
            fill: root.contentItem
        }

        property var nsnMapData

        sourceComponent: Popup_NsnViewer{
            id: popupNsnViewer
            nsn: loaderPopupNsnViewer.nsnMapData

            onClosed: {
                loaderPopupNsnViewer.active = false
            }

            Component.onCompleted:{

                console.log("Opening NSN viewer")
                open()
            }


        }

        Connections{
            target: ApplicationsController

            onSignal_Request_OpenNsnViewer: function(mapData){
                console.log("Requesting open NSN viewer to: " + mapData.nsn)
                loaderPopupNsnViewer.nsnMapData = mapData.nsn
                loaderPopupNsnViewer.active = true
            }
        }


    }

}
