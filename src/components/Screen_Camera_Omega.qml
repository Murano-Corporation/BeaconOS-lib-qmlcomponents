import QtQuick 2.12
import QtQuick.Controls 2.12
import QtMultimedia 5.12
import Qt.labs.platform 1.1
import CONSTANTS 1.0



Screen__BASE {
    id: screenCameraRoot

    anchors{
        fill: parent
    }

    property bool dev_mode: Settings.cameraDevModeEnabled
    property bool isDevModeCamSwitchVisible: Settings.cameraDevModeCamSwitchVisible
    property bool isCameraAvailable: availableCameras.length > 0
    property bool isCaptureDistanceEnabled: Settings.cameraCaptureDistanceEnabled
    property bool dev_useDevImages: false
    property bool dev_forceUseCamera: false
    property string dev_devImgPath: ""

    property int cameraRotationOffset: Settings.cameraRotationOffset

    property var availableCameras: QtMultimedia.availableCameras
    property int indexOfSelectedCamera: -1
    property string selectedCameraDevId: availableCameras.length >= 3 ? QtMultimedia.availableCameras[2].deviceId : ""
    property int imgsCaptured: -1
    property string beaconId: "test"
    property string assetId: "test"
    property string pleaseWaitMessage: qsTr("Capturing Image '" + (screenCameraRoot.imgsCaptured + 1) + "' of '" + CameraController.imgsPerCaptureCount)
    property string imgSaveFileName: "/home/murano/camera/temp/capt_" + beaconId + "_" + (screenCameraRoot.imgsCaptured - 1)
    property string imgSaveFileNameDist: "/home/murano/camera/temp/capt_" + beaconId + "_" + (screenCameraRoot.imgsCaptured - 1) + "_dist"
    property string processedImgUrl: ""
    property string processedImgResult: ""
    property bool isViewingProcdImage: (processedImgUrl !== "")
    property bool isOverlayMode: false
    property bool isMiniGalleryShown: false
    property bool rightCaptBtnInit: false;
    property string selectedThumbnailId: ''
    property int selectedThumbnailIndex: -1
    property var processedImageData: undefined
    property int captureTarget: 3
    property bool qualityTargetGood: true
    property Camera cameraMain

    signal viewFullGalleryClicked()
    signal cancelClicked()

    onIsCameraAvailableChanged: {
        console.log("Cameras available now: " + isCameraAvailable)
    }

    onAvailableCamerasChanged: {
        console.log("Available cameras now: " + availableCameras.length)

        for(var i = 0; i < availableCameras.length; i++)
        {
            var camObj = availableCameras[i]
            console.log("-Device: " + i)
            console.log("--DeviceId: " + camObj.deviceId)
            console.log("--Display Name: " + camObj.displayName)
            console.log("--Position: " + camObj.position)
            console.log("--Orientation: " + camObj.orientation)
        }
    }

    onSelectedThumbnailIndexChanged: {
        console.log('Selected thumbnail index now: ' + selectedThumbnailIndex)
    }

    function onAccepImage(){
        //console.log("GUI::Accepting img...");
        MqttTopicCmdBRX.slot_ClearLastImageData()

        processedImgResult = ""
        processedImgUrl = ""

        CameraController.slot_SaveImage(beaconId, processedImageData)

        screenCameraRoot.state = "capture"
    }

    function onDiscardImage(){
        //console.log("GUI::Discarding img...");
        processedImgUrl = ""
        messageConfirmDelete.open()

    }

    function showPleaseWaitPopup(){

        popupPleaseWait.contentCenterPoint = mapToItem(
                    root.contentItem,
                    rectBg.x,
                    rectBg.y,
                    rectBg.width,
                    rectBg.height
                    )

        popupPleaseWait.open()

    }

    Rectangle{
        id: rectBg

        anchors{
            fill: parent
        }

        radius: 17

        color: "#1A2432"
    }

    Component.onCompleted: {
        //console.log("Found cameras: " + QtMultimedia.availableCameras.length)

        //MqttTopicCmdBOS.slot_TEST_UserCaptdLoop();

        CameraController.slot_SetTargetBeaconId(beaconId)
        screenCameraRoot.state = "capture"

    }

    Connections{
        target: CameraController

        function onSignal_ImageProcessingComplete(mapData){
            //console.log("Image Capture Complete")
            screenCameraRoot.processedImageData = mapData
            //console.log("Map Data now: " + mapData)

            screenCameraRoot.imgCaptureComplete()
        }

        function onSignal_DEVMODE_CopyDevImgToTemp_Complete(){
            screenCameraRoot.stepImgCapture()
        }

        function onSignal_ClearAllFromTemp_Complete(){
            screenCameraRoot.stepImgCapture();
        }
    }

    function startImgCapture() {
        screenCameraRoot.processedImgUrl = ""
        screenCameraRoot.imgsCaptured = 0
        screenCameraRoot.pleaseWaitMessage = qsTr("Removing old images...")
        screenCameraRoot.state = "process"
        showPleaseWaitPopup();
        CameraController.slot_ClearAllFromTemp()

    }

    function imgCaptureComplete() {
        popupPleaseWait.close()
        screenCameraRoot.imgsCaptured = -1

        screenCameraRoot.processedImgUrl = MqttTopicCmdBRX.processedImgUrl
        screenCameraRoot.processedImgResult = MqttTopicCmdBRX.processedImgResult

        //console.log("GUI Img url is now: " + screenCameraRoot.processedImgUrl)
        //console.log("GUI Img Result is now: " + screenCameraRoot.processedImgResult)
        screenCameraRoot.state = "audit"
    }

    function stepImgCapture(){
        screenCameraRoot.imgsCaptured += 1

        if(screenCameraRoot.imgsCaptured <= CameraController.imgsPerCaptureCount && screenCameraRoot.imgsCaptured >= 0)
        {
            screenCameraRoot.pleaseWaitMessage = qsTr("Capturing Image '" + (screenCameraRoot.imgsCaptured) + "' of '" + CameraController.imgsPerCaptureCount + "'...")
            tmrCaptDelay.start();
        } else if(screenCameraRoot.imgsCaptured > CameraController.imgsPerCaptureCount){
            stepImgAnalysis();
        } else {
            stepImgCapture();
        }
    }

    function stepImgAnalysis(){

        //console.log("Camera Rotation Offset is: " + screenCameraRoot.cameraRotationOffset)

        if(screenCameraRoot.cameraRotationOffset === 0)
        {
            stepImgProcess();
            return;
        }

        screenCameraRoot.pleaseWaitMessage = qsTr("Analysing Image...")

        CameraController.signal_ImageAnalysisComplete.connect(stepImgProcess);
        CameraController.slot_AnalyiseImages()
    }


    function stepImgProcess(){
        CameraController.signal_ImageAnalysisComplete.disconnect(stepImgProcess);
        screenCameraRoot.pleaseWaitMessage = qsTr("Processing Image...")
        MqttTopicCmdBOS.slot_Camera_UserCaptured(screenCameraRoot.beaconId, screenCameraRoot.assetId, captureTarget)
    }

    state: "capture"

    states: [
        State{
            name: "capture"

            PropertyChanges {
                target: compCVResults
                visible: false

            }

            PropertyChanges {
                target: btnCaptureLeft
                visible: true
                enabled: true

            }



            PropertyChanges{
                target: drawerMiniGallery

                visible: true
                enabled: true
            }

            PropertyChanges {
                target: btnAccept
                visible: false

            }

            PropertyChanges {
                target: btnDiscard
                visible: false

            }

            PropertyChanges {
                target: rectBg
                color: "#1a2432"
            }

        },

        State{
            name: "preview"
        },

        State{
            name: "stash"
        },

        State{
            name: "process"

            PropertyChanges {
                target: btnCaptureLeft
                visible: true
                enabled: false

            }

            PropertyChanges {
                target: compCVResults
                visible: false

            }


            PropertyChanges{
                target: drawerMiniGallery

                visible: true
                enabled: false
            }

            PropertyChanges {
                target: btnAccept
                visible: false

            }

            PropertyChanges {
                target: btnDiscard
                visible: false

            }
        },
        State{
            name: "review"


            PropertyChanges {
                target: compCVResults
                visible: true

                x: rectMainBg.x + rectMainBg.width - compCVResults.width - 20
                y: rectMainBg.y + 20

            }

            PropertyChanges {
                target: btnCaptureLeft
                visible: false

            }

            PropertyChanges{
                target: drawerMiniGallery

                visible: true
                enabled: true

            }

            PropertyChanges {
                target: btnAccept
                visible: true

            }

            PropertyChanges {
                target: btnDiscard
                visible: true

            }
        },
        State{
            name: "audit"



            PropertyChanges {
                target: compCVResults
                visible: true

                x: rectMainBg.x + rectMainBg.width - compCVResults.width - 20
                y: rectMainBg.y + 20

            }

            PropertyChanges {
                target: btnCaptureLeft
                visible: false

            }


            PropertyChanges {
                target: compCVResults
                visible: true

            }

            PropertyChanges {
                target: drawerMiniGallery
                visible: false

            }

            PropertyChanges {
                target: btnAccept
                visible: true


            }

            PropertyChanges {
                target: btnDiscard
                visible: true

            }
        }
    ]

    Timer {
        id: tmrCaptDelay
        interval: 200;
        onTriggered: {

            if(dev_mode && !dev_forceUseCamera)
            {
                console.log('Using dev images')
                CameraController.slot_DEVMODE_CopyDevImgToTemp(screenCameraRoot.beaconId, screenCameraRoot.imgsCaptured - 1, captureTarget, screenCameraRoot.dev_devImgPath)

            } else {
                cameraMain.imageCapture.captureToLocation(screenCameraRoot.imgSaveFileName)
            }
        }
    }



    Loader{
        id: loaderCameraDistance

        active: isCaptureDistanceEnabled

        anchors{
            fill: rectMainBg
        }

        sourceComponent:
            VideoOutput{
            id: videoOutAlt

            visible: !screenCameraRoot.isViewingProcdImage

            source: Camera {
                id: cameraAlt

                deviceId: QtMultimedia.availableCameras[1].deviceId


                imageCapture.onImageCaptured: {
                    //console.log("Image Captured")
                }

                imageCapture.onImageSaved: function (reqId, path){
                    console.log(" ALT Image saved to: " + path + "for reqID " + reqId);

                    screenCameraRoot.stepImgCapture();
                }
            }
            orientation: cameraRotationOffset


        }



    }
    CompBtnBreadcrumb{
        id: btnCancel

        visible: isOverlayMode

        anchors{
            right: parent.right
            rightMargin: 20
            top: parent.top
            topMargin: 20
        }

        height: 50
        width: 90

        text: qsTr("Back")

        onClicked: {
           cancelClicked()
        }

    }
    Rectangle {
        id: rectMainBg
        anchors{
            top: parent.top
            topMargin: isOverlayMode ? 200 : 150

            left: parent.left
            leftMargin: compCameraViewFinder.viewFinderHorizontalOffset + 10
            right: parent.right


            rightMargin: compCameraViewFinder.viewFinderHorizontalOffset + 10


            bottom: btnCaptureLeft.top
            bottomMargin: 60

        }

        radius: 16
        color: "#80000000"

        CompCameraViewFinder {
            id: compCameraViewFinder

            isViewMode: imgProcessed.visible

            anchors.fill: parent
            //anchors.topMargin: 60
        }


        Loader{
            id: loaderVideoOut
            active: screenCameraRoot.isCameraAvailable

            onActiveChanged: {
                if(loaderVideoOut.active)
                {
                    console.log("Loading camera viewer...")
                } else {
                    console.log("Unloading camera viewer...")
                }
            }

            anchors {
                fill: parent
                //topMargin: 60
            }

            sourceComponent: VideoOutput{
                id: videoOut

                visible: !imgProcessed.visible

                Component.onCompleted:{
                    console.log("Main Video out loaded!")
                }

                source: Camera {

                    deviceId: QtMultimedia.availableCameras[2].deviceId

                    imageCapture.onImageSaved: function (reqId, path){
                        //console.log("Main Image saved to: " + path + "for reqID " + reqId);

                        if(isCaptureDistanceEnabled)
                            cameraAlt.imageCapture.captureToLocation(screenCameraRoot.imgSaveFileNameDist)
                        else{
                            screenCameraRoot.stepImgCapture()
                        }
                    }

                    Component.onCompleted:{
                        console.log("Main Camera out loaded!")
                        screenCameraRoot.cameraMain = this
                    }
                }
                orientation: cameraRotationOffset

            }
        }

        Loader {
            id: loaderNoCameras
            visible: !imgProcessed.visible
            active: (screenCameraRoot.isCameraAvailable === false)

            anchors{
                centerIn: parent
            }

            sourceComponent: CompLabel{
                text: qsTr("Camera Unavailable")
            }
        }

        Image{
            id: imgProcessed

            visible: screenCameraRoot.processedImgUrl !== "" || screenCameraRoot.selectedThumbnailIndex !== -1

            property real scaleX: 1.0
            property real scaleY: 1.0
            property int offsetX: 0

            anchors.fill: parent


            //anchors.topMargin: 100

            fillMode: Image.PreserveAspectFit
            asynchronous: true
            cache: false
            onSourceSizeChanged: {

                var widthSource = sourceSize.width
                var widthActual = paintedWidth
                var heightSource = sourceSize.height
                var heightActual = paintedHeight
                var xOffset = Math.abs(widthSource - widthActual)
                //console.log("SOURCE SIZE OF IMAGE IS: " + widthSource + "x" + heightSource)
                //console.log("ACTUAL SIZE IS: " + width + "x" + height)
                //console.log("PAINTED SIZE: " + paintedWidth + "x" + paintedHeight)

                imgProcessed.offsetX = xOffset * 0.5
                imgProcessed.scaleX = widthActual / widthSource
                imgProcessed.scaleY = heightActual / heightSource
            }

            Connections{
                target: screenCameraRoot

                function onProcessedImgUrlChanged(){
                    if(screenCameraRoot.processedImgUrl === "")
                    {
                        imgProcessed.source = ""
                        return
                    }

                    imgProcessed.source = ("file://" + screenCameraRoot.processedImgUrl)
                }

                function onSelectedThumbnailIndexChanged(){
                    if(screenCameraRoot.selectedThumbnailIndex === -1)
                    {
                        imgProcessed.source = ""
                        return
                    }

                    var imgPath = "file://"
                    var modelIndex = TableModelCameraGallery.index(screenCameraRoot.selectedThumbnailIndex, 0)
                    var dataPath = TableModelCameraGallery.data(modelIndex, Constants.DataRole_ImgPath)
                    imgPath += dataPath

                    imgProcessed.source = imgPath
                }
            }
        }

        //Rectangle{
        //    id: areaSourceSize
        //
        //    anchors.centerIn: imgProcessed
        //
        //    height: imgProcessed.sourceSize.height
        //    width: imgProcessed.sourceSize.width
        //
        //    color: "#80ff0000"
        //}

        Item{
            id: areaImgPainted

            anchors{
                centerIn: imgProcessed
            }

            height: imgProcessed.paintedHeight
            width: imgProcessed.paintedWidth

            //Rectangle{
            //    anchors.fill: parent
            //
            //    color: "#8000ff00"
            //}

            Rectangle{
                id: rectBoundingBox

                visible: imgProcessed.visible

                property bool isValid: imgProcessed.visible

                property real bbX: 0
                property real bbY: 0
                property real bbW: 0
                property real bbH: 0


                property size imgProcessedSourceSize: imgProcessed.sourceSize
                property real imgProcessedSourceSizeX: imgProcessedSourceSize ? imgProcessedSourceSize.width : 1.0
                property real imgProcessedSourceSizeY: imgProcessedSourceSize ? imgProcessedSourceSize.height : 1.0
                property real imgProcessedPaintedWidth: imgProcessed.paintedWidth
                property real imgProcessedPaintedHeight: imgProcessed.paintedHeight
                property real ratioOriginX:((bbX * imgProcessedPaintedWidth) / imgProcessedSourceSizeX)
                property real ratioOriginY:((bbY * imgProcessedPaintedHeight) / imgProcessedSourceSizeY)
                property real scaleX: imgProcessed.scaleX
                property real scaleY: imgProcessed.scaleY

                Connections{
                    target: screenCameraRoot

                    function onProcessedImageDataChanged(){
                        if(screenCameraRoot.processedImageData === undefined)
                        {
                            rectBoundingBox.bbX = 0
                            rectBoundingBox.bbY = 0
                            rectBoundingBox.bbW = 0
                            rectBoundingBox.bbH = 0
                            return
                        }
                        var mapData = screenCameraRoot.processedImageData
                        var jsonBoundBox = mapData.bb

                        rectBoundingBox.bbX = jsonBoundBox.x
                        rectBoundingBox.bbY = jsonBoundBox.y
                        rectBoundingBox.bbW = jsonBoundBox.w
                        rectBoundingBox.bbH = jsonBoundBox.h
                    }

                    function onSelectedThumbnailIndexChanged(){


                        if(screenCameraRoot.selectedThumbnailIndex === -1)
                        {
                            rectBoundingBox.bbX = 0
                            rectBoundingBox.bbY = 0
                            rectBoundingBox.bbW = 0
                            rectBoundingBox.bbH = 0
                            return
                        }

                        var modelIndex = TableModelCameraGallery.index(screenCameraRoot.selectedThumbnailIndex, 0)
                        var jsonBoundBox = TableModelCameraGallery.data(modelIndex, Constants.DataRole_BoundingBox)
                        if(!jsonBoundBox)
                        {
                            rectBoundingBox.bbX = 0
                            rectBoundingBox.bbY = 0
                            rectBoundingBox.bbW = 0
                            rectBoundingBox.bbH = 0
                            return
                        }
                        rectBoundingBox.bbX = jsonBoundBox.x
                        rectBoundingBox.bbY = jsonBoundBox.y
                        rectBoundingBox.bbW = jsonBoundBox.w
                        rectBoundingBox.bbH = jsonBoundBox.h

                    }
                }

                x: ratioOriginX
                y: ratioOriginY
                width: bbW * scaleX
                height: bbH * scaleY

                border{
                    color: "Red"
                    width: 4
                }

                radius: 10

                color: "transparent"

            }

        }


    }

    Item{
        id: drawerMiniGallery

        opacity: enabled ? 1.0 : 0.3

        anchors{
            left: parent.left
            leftMargin: 30

            right: btnCaptureLeft.left
            rightMargin: 75

            top: rectMainBg.bottom
            topMargin: 30
            bottom: parent.bottom
            bottomMargin: 30
        }

        width: 225

        Item {
            id: btnViewFullGallery

            visible:  false

            property alias text: lblText.text
            property string alignment: "center"

            anchors{
                top: parent.top
                left: parent.left
                right: parent.right
            }

            CompRoundGlassBG{
                anchors.fill: parent
            }

            Item{
                id: contents

                anchors{
                    centerIn:  parent
                }

                height: parent.height

                width: (imgIcon.width + 9 + lblText.width)

                CompImageIcon {
                    id: imgIcon

                    anchors{
                        top: parent.top
                        topMargin: 9
                        left: parent.left

                        bottom: parent.bottom
                        bottomMargin: 9

                    }

                    width: height
                    color: "White"
                    source: "file:///usr/share/BeaconOS-lib-images/images/Gallery.svg"
                }

                CompLabel {
                    id: lblText

                    anchors{
                        verticalCenter: imgIcon.verticalCenter
                        left: imgIcon.right
                        leftMargin: 9
                    }

                    text: qsTr("View Full Gallery")
                    font{
                        pixelSize: 18
                    }
                }

            }




            //text: qsTr("View Full Gallery")


            height: 36

            MouseArea{
                anchors.fill: parent

                onClicked: screenCameraRoot.viewFullGalleryClicked()
            }

        }

        ListView {
            id: listThumbnails
            clip: true

            opacity: 0.5

            anchors{
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            model: TableModelCameraGallery
            layoutDirection: ListView.LeftToRight
            orientation: ListView.Horizontal
            spacing: 45

            delegate: Image{

                property bool isSelected: screenCameraRoot.selectedThumbnailId === model.image_id
                property int myIndex: index

                height: listThumbnails.height

                source: "file://" + model.img_path
                fillMode: Image.PreserveAspectFit

                CompCameraViewFinder{
                    anchors.fill: parent

                    visible: parent.isSelected === true

                    viewFinderVerticalOffset: 0-viewFinderHeight
                    viewFinderHorizontalOffset: 0+viewFinderHeight
                    viewFinderHeight: 4
                    viewFinderWidth: 24
                }

                MouseArea{
                    anchors.fill: parent

                    onClicked: {


                        if(screenCameraRoot.selectedThumbnailIndex === parent.myIndex)
                        {
                            screenCameraRoot.selectedThumbnailIndex = -1
                            screenCameraRoot.selectedThumbnailId = ''
                            screenCameraRoot.state = "capture"
                        } else {
                            screenCameraRoot.selectedThumbnailIndex = parent.myIndex
                            screenCameraRoot.selectedThumbnailId = model.image_id
                            screenCameraRoot.state = "review"
                        }


                    }
                }


            }

        }
    }



    CompCVResults{
        id: compCVResults
        visible: isViewingProcdImage || selectedThumbnailIndex !== -1

        height: 300
        width: 500

        Connections{
            target: screenCameraRoot

            function onSelectedThumbnailIndexChanged(id){

                if(screenCameraRoot.selectedThumbnailIndex === -1)
                    return;

                var modelIndex = TableModelCameraGallery.index(screenCameraRoot.selectedThumbnailIndex, 0)
                console.log('Updating targetted data: ' + modelIndex)
                console.log('Looking for GPS Coords at role: ' + Constants.DataRole_GpsCoords)
                console.log('Looking for Inference at role: ' + Constants.DataRole_Inference)

                compCVResults.timestamp = TableModelCameraGallery.data(modelIndex, Constants.DataRole_Timestamp)
                compCVResults.gpsCoords = TableModelCameraGallery.data(modelIndex, Constants.DataRole_GpsCoords)
                compCVResults.inference = TableModelCameraGallery.data(modelIndex, Constants.DataRole_Inference)

            }

            function onProcessedImageDataChanged()
            {
                var mapData = screenCameraRoot.processedImageData
                if(mapData === undefined)
                {
                    console.log('Map data undefined!')
                    return
                }

                console.log('Settings from valid map data...')

                compCVResults.timestamp = SingletonUtils.getLongPrettyDate(mapData.capt_time)
                compCVResults.gpsCoords = mapData.gps_coords
                compCVResults.inference = mapData.inference


            }
        }
    }

    CompIconBtn {
        id: btnAccept

        anchors{
            right: parent.right
            rightMargin: 20
            verticalCenter: btnCaptureLeft.verticalCenter
        }

        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/CheckFill.svg"
        iconColor: "White"

        height: 128
        width: 128


        MouseArea{
            anchors{
                fill: parent
            }

            onClicked: {
                screenCameraRoot.onAccepImage()
            }
        }
    }

    CompIconBtn {
        id: btnDiscard

        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/CancelFill.svg"
        iconColor: "white"

        anchors{
            right: btnAccept.left
            rightMargin: 64
            bottom: btnAccept.bottom

        }

        height: btnAccept.height
        width: btnAccept.width


        MouseArea{
            anchors{
                fill: parent
            }

            onClicked: {

                screenCameraRoot.onDiscardImage()
            }
        }
    }

    CompBtnCameraCapture {
        id: btnCaptureLeft


        enabled: dev_mode ? (dev_devImgPath !== "" || dev_forceUseCamera) : true

        height: 128
        width: height

        anchors{
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 60

        }

        onClicked: {

            if(screenCameraRoot.selectedThumbnailIndex !== -1)
            {
                screenCameraRoot.selectedThumbnailIndex = -1
                return
            }

            rightCaptBtnInit = false
            screenCameraRoot.startImgCapture()
        }

    }


    Loader{
        id: loaderCaptureTarget
        visible: screenCameraRoot.dev_mode
        active: screenCameraRoot.dev_mode


        sourceComponent: devControls

    }

    Component{
        id: devControls

        CompResizableMoveableContainer{

            height: devControlsColumn.height + 100
            width: devControlsColumn.width + 100

            CompPopupBG{}

            Column{
                id: devControlsColumn
                visible: true

                anchors.centerIn: parent

                spacing: 20
                CompLabel{
                    text: qsTr("DEV TOOLS")
                }
                FileDialog{
                    id: devDevImgPicker

                    onFileChanged: {
                        screenCameraRoot.dev_devImgPath = file
                        console.log('Dev img path now: ' + file)
                    }
                }

                CompCombobox{
                    id: devComboCaptTarget

                    model: ["Tire","Tread", "Classify", "Full"]
                    currentIndex: 3
                    displayText: model[currentIndex]

                    onActivated: function(index){
                        console.log("Activated index: " + index)
                        screenCameraRoot.captureTarget = index
                    }
                }

                Switch{
                    id: devSwitchUseDevImages

                    enabled: isCameraAvailable
                    text: checked ? qsTr("Using Dev Images") : qsTr("Using Camera")

                    checked: true
                    onCheckedChanged:{
                        screenCameraRoot.dev_forceUseCamera = !checked
                    }
                    contentItem: CompLabel{
                        text: parent.text

                        font{
                            pixelSize: 12
                        }
                        color: parent.down ? "White" : "#80ffffff"
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: parent.indicator.width + parent.spacing

                    }
                }

                Button{

                    visible: devSwitchUseDevImages.visible && devSwitchUseDevImages.checked

                    text: qsTr("Select Dev Image")
                    onClicked: {
                        var folderPath = 'file://' + SingletonUtils.getDevImagesPath()

                        devDevImgPicker.folder = folderPath
                        devDevImgPicker.open()


                    }
                }

            }


        }


    }

    MessageDialog{
        id: messageConfirmDelete

        text: qsTr("Do you really want to discard this image?")
        buttons: MessageDialog.Yes | MessageDialog.No

        onYesClicked: {
            MqttTopicCmdBRX.slot_ClearLastImageData()

            processedImgResult = ""
            processedImgUrl = ""

            messageConfirmDelete.close()
            screenCameraRoot.state = "capture"
        }
    }

    PopupPleaseWait {
        id: popupPleaseWait

        pleaseWaitMessage: screenCameraRoot.pleaseWaitMessage

    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.5;height:1920;width:1080}
}
##^##*/
