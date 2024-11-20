import QtQuick 2.15
import QtQuick.Controls 2.15
import SyntaxHighlight_Bash 1.0
import SyntaxHighlight_Py 1.0
import QtLocation 5.12
import QtPositioning 5.12

Screen__BASE {
    id: screenGalleryRoot

    property string viewMode: TableModelGalleryApp.sFileTypeFilter
    property string fileName_Selected
    property string filePath_Selected
    property string fileExt_Selected
    property color colorViewMode_Selected: "#4C8FBE"
    property color colorViewMode_Unselected: "#A3A0A0"
    property var galleryFileESearch :[""]
    property string searchFieldText
    Connections {
        target: ElasticSearchController

        function onSignal_SearchResultsReady(filename_ESearch) {
            galleryFileESearch = filename_ESearch
        }
    }

    property var selectedItemMapData: ""

    readonly property bool shouldBottomControlsLoad: {
        return screenGalleryRoot.viewMode !== "*"
                && screenGalleryRoot.isFilePathValid
    }

    readonly property bool shouldDBViewerLoad: {
        return (screenGalleryRoot.viewMode === "Database"
                || screenGalleryRoot.viewMode === '*')
                && screenGalleryRoot.isFilePathValid
                && FileHandler.isDatabaseFile(filePath_Selected)
    }

    readonly property bool shouldImageViewerLoad: {
        return (screenGalleryRoot.viewMode === "Image"
                || screenGalleryRoot.viewMode === "*")
                && screenGalleryRoot.isFilePathValid && FileHandler.isImageFile(
                    filePath_Selected)
    }

    readonly property bool shouldTextViewerLoad: {

        var bRet = (screenGalleryRoot.viewMode === "Document"
                    || screenGalleryRoot.viewMode === "*")
                && screenGalleryRoot.fileExt_Selected !== "pdf"
                && screenGalleryRoot.isFilePathValid && FileHandler.isTextFile(
                    filePath_Selected)

        return bRet
    }

    readonly property bool shouldPdfViewerLoad: {

        var bRet = (screenGalleryRoot.viewMode === "Document"
                    || screenGalleryRoot.viewMode === "*")
                && screenGalleryRoot.fileExt_Selected === "pdf"
                && screenGalleryRoot.isFilePathValid && FileHandler.isTextFile(
                    filePath_Selected)
        return bRet
    }

    readonly property bool should3DViewerLoad: {
        return (screenGalleryRoot.viewMode === "3D Drawing"
                || screenGalleryRoot.viewMode === '*')
                && screenGalleryRoot.isFilePathValid && FileHandler.is3DFile(
                    filePath_Selected)
    }

    readonly property bool shouldAudioViewerLoad: {
        return (screenGalleryRoot.viewMode === "Audio"
                || screenGalleryRoot.viewMode === "*")
                && screenGalleryRoot.isFilePathValid && FileHandler.isAudioFile(
                    filePath_Selected)
    }

    readonly property bool shouldVideoViewerLoad: {
        return (screenGalleryRoot.viewMode === "Video"
                || screenGalleryRoot.viewMode === '*')
                && screenGalleryRoot.isFilePathValid && FileHandler.isVideoFile(
                    filePath_Selected)
    }

    readonly property bool isFilePathValid: {
        return filePath_Selected !== ""
    }

    screenName: "Gallery"

    signal onCloseClicked

    Component.onCompleted: DatabaseController.getGalleryDocument()

    onSelectedItemMapDataChanged: {
        if (selectedItemMapData === "") {
            loaderMapViewer.active = false
            return
        }

        loaderMapViewer.active = true
    }

    onViewModeChanged: {
        filePath_Selected = ""

        loaderMapViewer.active = false
    }

    function onFolderClicked(indexClicked) {
        var fullPath = listviewDirectoryContents.model[indexClicked].fullPath
        FileHandler.searchPath = fullPath
    }

    function onItemClicked(indexClicked, fileExt) {
        filePath_Selected = "/home/murano/docker_data" + indexClicked
        fileExt_Selected = fileExt
    }

    function onItemLongClicked(indexClicked) {
        filePath_Selected = listviewDirectoryContents.model[indexClicked].fullPath
        fileExt_Selected = listviewDirectoryContents.model[indexClicked].extension
        fileName_Selected = listviewDirectoryContents.model[indexClicked].fileName

        showFileInfoViewer()
    }

    function onEmployeeIdClicked(employeeId) {
        popupEmpoyeeInfoViewer.open()
        compEmployeeInfoViewer.employeeNameToSearch = employeeId
    }

    Rectangle {
        id: rectBg

        anchors.fill: parent
        color: "#ffffff"
    }

    Rectangle {
        id: rectPopupInfo

        color: "#ffffff"
        height: 64

        anchors {
            top: parent.top
            topMargin: 20
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
        }

        CompIconBtn {
            id: btnUpload

            iconColor: "#1B4A60"
            visible: false
            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }
        }

        CompCustomisableTextField {
            id: searchField

            placeholderText: "Search..."
            placeholderTextColor: "#80000000"
            textColor: colorViewMode_Selected
            width: 600
            outlineRect {
                border.color: "#80000000"
                //color: colorViewMode_Selected
            }
            iconColor: colorViewMode_Selected
            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }
            onEnterPressed: {
                var text = searchField.text
                DatabaseController.getGallerySearchInformation(text)
                ElasticSearchController.submitSearch(text)
                searchFieldText = text
            }
        }

        Row {
            id: rowTopControls

            layoutDirection: Qt.RightToLeft
            spacing: 20
            anchors {
                top: btnUpload.top
                left: btnUpload.right
                right: btnClose.visible ? btnClose.left : parent.right
                bottom: btnUpload.bottom
            }

            Repeater {
                model: ListModel {
                    ListElement {
                        text: "A"
                        filterString: "Audio"
                        iconPath: "MicrophoneFill.svg"
                    }

                    ListElement {
                        text: "G"
                        filterString: "Graph"
                        iconPath: "chart.svg"
                    }

                    ListElement {
                        text: "3D"
                        filterString: "3D Drawing"
                        iconPath: "cube.svg"
                    }

                    ListElement {
                        text: "D"
                        filterString: "Document"
                        iconPath: "file-pdf.svg"
                    }

                    ListElement {
                        text: "C"
                        filterString: "Image"
                        iconPath: "image.svg"
                    }

                    ListElement {
                        text: "V"
                        filterString: "Video"
                        iconPath: "video.svg"
                    }

                    ListElement {
                        text: "*"
                        filterString: "*"
                        iconPath: "globe.svg"
                    }
                }

                delegate: CompIconBtn {

                    property bool isCurrent: screenGalleryRoot.viewMode === model.filterString

                    iconColor: isCurrent ? screenGalleryRoot.colorViewMode_Selected : colorViewMode_Unselected
                    iconUrl: "file:///usr/share/BeaconOS-lib-images/images/" + model.iconPath
                    height: rowTopControls.height

                    onClicked: TableModelGalleryApp.setFileTypeFilter(
                                   model.filterString)
                }
            }
        }

        CompButton {
            id: btnClose
            visible: bIsPopup ? true : false
            text: "X"

            anchors {
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }

            width: height

            onClicked: screenGalleryRoot.onCloseClicked()
        }
    }

    Rectangle {
        id: rectContents

        color: "#ffffff"
        anchors {
            top: rectPopupInfo.bottom
            topMargin: 20
            left: rectPopupInfo.left
            leftMargin: 10
            bottom: rectControls.visible ? rectControls.top : rectControls.bottom
            right: rectPopupInfo.right
            rightMargin: 10
        }
    }

    Item {
        id: comp_Gallery_GridView

        visible: screenGalleryRoot.filePath_Selected === "" || fileExt_Selected == "stl"

        anchors.fill: rectContents
        anchors.leftMargin: 60
        anchors.topMargin: 40

        CompLabel {
            id: lblNoresultsToDisplay

            visible: gridviewContents.count === 0

            anchors.centerIn: parent
            text: "No media available"
            font {
                pixelSize: 40
            }

            color: "#80000000"
        }

        GridView {
            id: gridviewContents

            visible: count > 0
            anchors.fill: parent
            anchors.margins: 20

            model: TableModelGalleryApp
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            cellHeight: 400
            cellWidth: 400

            delegate: Item {

                height: gridviewContents.cellHeight
                width: gridviewContents.cellWidth

                Comp_Gallery_GridViewItem {

                    // anchors.fill: parent
                    filterVisible : galleryFileESearch.some(fileNameSearch => model.ELECTRONIC_DOCUMENT_FILE_LOCATION.includes(fileNameSearch)) ? true : false
                    anchors.fill: filterVisible ? parent : undefined
                    anchors.margins: 20

                    messageFormat: model.MESSAGE_FORMAT
                    fileName: model.TITLE
                    fileAuthor: model.DISPLAY_OWNER
                    fileViewsString: model.DISPLAY_VIEWS
                    fileAgeString: model.DISPLAY_AGE
                    filePathUrl: model.ELECTRONIC_DOCUMENT_FILE_LOCATION
                    fileType: model.TAG
                    fileRecordCreator: model.RECORD_CREATOR
                    searchText :  searchFieldText

                    onSignalIconClicked: (filePath, fileExt) => {
                                             screenGalleryRoot.onItemClicked(
                                                 filePath, fileExt)
                                         }

                    onSignalMapButtonClicked: {
                        var modelIndexMapData = {
                            "type": model.TAG,
                            "location": model.DISPLAY_LOCATION,
                            "mapMode": 'STREET'
                        }

                        screenGalleryRoot.selectedItemMapData = modelIndexMapData
                    }

                    onSignalSatelliteButtonClicked: {
                        var modelIndexMapData = {
                            "type": model.TAG,
                            "location": model.DISPLAY_LOCATION,
                            "mapMode": 'SATELLITE'
                        }

                        screenGalleryRoot.selectedItemMapData = modelIndexMapData
                    }

                    onSignalAuthorClicked: author => {
                                               screenGalleryRoot.onEmployeeIdClicked(
                                                   author)
                                           }
                }
            }
        }
    }

    Loader {

        asynchronous: true
        active: screenGalleryRoot.shouldTextViewerLoad

        anchors.fill: rectContents

        sourceComponent: CompTextEditor {

            textEdit.text: FileHandler.loadedFileText
            fileName: screenGalleryRoot.fileName_Selected
            fileExtension: screenGalleryRoot.fileExt_Selected

            onTextEditTextChanged: popupPleaseWait.close()
        }
    }

    Loader {

        asynchronous: true
        active: screenGalleryRoot.shouldPdfViewerLoad
        onActiveChanged: "PDF Loader is active: " + active
        anchors.fill: rectContents

        sourceComponent: CompPdfViewer {
            id: pdfView

            zoom: 2.0
            fileUrl: screenGalleryRoot.filePath_Selected

            //Rectangle {
            //    anchors.fill: parent

            //    color: '#80ff0000'
            //}
        }
    }

    Loader {
        asynchronous: true
        active: screenGalleryRoot.viewMode === "File Info"
                && screenGalleryRoot.isFilePathValid

        anchors.fill: rectContents

        sourceComponent: Item {
            id: compGalleryFileInfoView

            CompLabel {

                text: screenGalleryRoot.filePath_Selected
                anchors.centerIn: parent
            }
        }
    }

    Loader {
        asynchronous: true
        active: screenGalleryRoot.viewMode === "Unknown"
                && screenGalleryRoot.isFilePathValid

        anchors.fill: rectContents

        sourceComponent: Item {
            id: compGalleryUnknownTypeView

            CompLabel {

                text: "Unknown File Type: " + screenGalleryRoot.fileExt_Selected
                anchors.centerIn: parent
            }
        }
    }

    Loader {
        asynchronous: true
        active: screenGalleryRoot.shouldAudioViewerLoad
                || screenGalleryRoot.shouldVideoViewerLoad
        anchors.fill: rectContents

        sourceComponent: CompAudioVideoPlayer {
            id: compAudioVideoPlayer
        }
    }

    Loader {
        asynchronous: true
        active: screenGalleryRoot.should3DViewerLoad
        visible: false
        // anchors.fill: rectContents

        // sourceComponent: Item {

        //     Screen_3dViewer {
        //         anchors.fill: parent
        //     }
        // }
    }

    Loader {
        asynchronous: true
        active: screenGalleryRoot.shouldDBViewerLoad

        anchors.fill: rectContents

        sourceComponent: Item {

            CompLabel {

                text: "Database File View: " + screenGalleryRoot.fileExt_Selected
                anchors.centerIn: parent
            }
        }
    }

    Loader {
        asynchronous: true
        active: screenGalleryRoot.shouldImageViewerLoad

        anchors.fill: rectContents

        sourceComponent: Flickable {

            clip: true
            boundsBehavior: Flickable.StopAtBounds

            Image {
                id: imageViewer

                source: "file://" + screenGalleryRoot.filePath_Selected
                asynchronous: true
                sourceSize: Qt.size(width, height)
                fillMode: Image.PreserveAspectFit

                onSourceChanged: {
                    height = parent.height
                    width = parent.width
                }
            }
        }
    }

    Loader {
        id: loaderMapViewer

        asynchronous: true
        active: false

        anchors.fill: rectContents

        sourceComponent: CompMapViewer {

            Component.onCompleted: {
                var mapData = screenGalleryRoot.selectedItemMapData
                var locationSplit = mapData.location.split(',')
                var lat = locationSplit[0]
                var lon = locationSplit[1]
                var mapType = mapData.mapMode

                setActiveMapTypeIndex(mapType === "STREET" ? 1 : 4)
                addPoint_Custom(lat, lon, compCustomMapItem)
                setZoomLevel(17.5)
            }
        }
    }

    Comp__BASE_Popup {
        id: popupEmpoyeeInfoViewer

        popupName: "Employee Info Viewer"
        modal: false
        background: Rectangle {
            color: "#80000000"

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    popupEmpoyeeInfoViewer.close()
                }
            }
        }

        CompPopupBG {
            colorBG: "#ffffff"
            anchors.fill: compEmployeeInfoViewer
            anchors.margins: -20

            MouseArea {
                anchors.fill: parent
            }
        }

        Comp_EmployeeInfoViewer {
            id: compEmployeeInfoViewer

            anchors.centerIn: parent
        }
    }

    Component {
        id: compCustomMapItem

        MapQuickItem {

            anchorPoint: Qt.point(sourceItem.width * 0.5,
                                  sourceItem.height * 0.5)

            onCoordinateChanged: {
                sourceItem.coords = coordinate
                console.log("compClickableMapItem:: Coordinates now " + coordinate)
            }

            sourceItem: CompImageIcon {
                id: imgSub
                height: 40
                width: 40

                property var coords
                applyColoring: false
                source: "file:///usr/share/BeaconOS-lib-images/images/locator.png"
            }
        }
    }

    Rectangle {
        id: rectControls

        visible: screenGalleryRoot.shouldBottomControlsLoad

        color: "#80000000"
        anchors {
            left: rectPopupInfo.left
            bottom: rectBg.bottom
            bottomMargin: 20
            right: rectPopupInfo.right
        }

        height: 90
    }

    //PopupPleaseWait {
    //    id: popupPleaseWait
    //    timeoutEnabled: false

    //    Connections {
    //        target: FileHandler

    //        //signal_FileLoadingStarted
    //        function onSignal_FileLoadingStarted() {
    //            console.log("popup opening")
    //            popupPleaseWait.open()
    //        }
    //    }
    //}
}
