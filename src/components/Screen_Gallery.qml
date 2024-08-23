import QtQuick 2.0
import QtQuick.Controls 2.15
import SyntaxHighlight_Bash 1.0
import SyntaxHighlight_Py 1.0

Screen__BASE {
    id: screenGalleryRoot

    property string viewMode: "None"
    property string fileName_Selected
    property string filePath_Selected
    property string fileExt_Selected

    screenName: "Gallery"

    signal onCloseClicked

    function onFolderClicked(indexClicked) {
        var fullPath = listviewDirectoryContents.model[indexClicked].fullPath
        FileHandler.searchPath = fullPath
    }

    function onItemClicked(indexClicked) {
        filePath_Selected = listviewDirectoryContents.model[indexClicked].fullPath
        fileExt_Selected = listviewDirectoryContents.model[indexClicked].extension
        fileName_Selected = listviewDirectoryContents.model[indexClicked].fileName

        if (FileHandler.isAudioFile(filePath_Selected)) {
            showAudioPlayer()
        } else if (FileHandler.isVideoFile(filePath_Selected)) {
            showVideoPlayer()
        } else if (FileHandler.isDatabaseFile(filePath_Selected)) {
            showDatabaseViewer()
        } else if (FileHandler.isTextFile(filePath_Selected)) {

            showPlainTextViewer()
        } else if (FileHandler.isImageFile(filePath_Selected)) {
            showImageViewer()
        } else {
            showUnknownFileTypeViewer()
        }
    }

    function onItemLongClicked(indexClicked) {
        filePath_Selected = listviewDirectoryContents.model[indexClicked].fullPath
        fileExt_Selected = listviewDirectoryContents.model[indexClicked].extension
        fileName_Selected = listviewDirectoryContents.model[indexClicked].fileName

        showFileInfoViewer()
    }

    function showFileInfoViewer() {
        screenGalleryRoot.viewMode = "File Info"
    }

    function showUnknownFileTypeViewer() {
        screenGalleryRoot.viewMode = "Unknown"
    }

    function showDatabaseViewer() {
        screenGalleryRoot.viewMode = "Database"
    }

    function showVideoPlayer() {
        screenGalleryRoot.viewMode = "Video"
    }

    function showAudioPlayer() {
        screenGalleryRoot.viewMode = "Audio"
    }

    function showImageViewer() {
        screenGalleryRoot.viewMode = "Image"
        imageViewer.source = "file://" + filePath_Selected
    }

    function showPlainTextViewer() {
        screenGalleryRoot.viewMode = "Text"

        FileHandler.loadText(filePath_Selected)
    }

    Rectangle {
        id: rectBg

        anchors.fill: parent
        color: "#80000000"
    }

    Rectangle {
        id: rectPopupInfo

        color: "#80000000"
        height: 64

        anchors {
            top: parent.top
            topMargin: 20
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
        }

        CompLabel {
            id: lblTitle

            text: "Gallery - " + FileHandler.searchPath_Root
            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
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
        id: rectFileList

        width: 400
        color: "#80000000"
        anchors {
            top: rectPopupInfo.bottom
            topMargin: 20
            left: rectPopupInfo.left
            bottom: rectControls.top
            bottomMargin: 20
        }

        ListView {
            id: listviewDirectoryContents

            property int itemHeight: 64

            clip: true
            boundsBehavior: Flickable.StopAtBounds
            anchors.fill: parent
            anchors.margins: 10
            spacing: 32
            model: FileHandler.listOfDirContent

            delegate: Item {
                id: compDirContentItem

                property var myModel: FileHandler.listOfDirContent[index]
                readonly property string fileName: myModel.fileName
                readonly property string fileExtension: myModel.extension
                readonly property string fullPath: myModel.fullPath
                readonly property bool isDir: myModel.isDirectory
                readonly property bool isHidden: myModel.isHidden
                readonly property bool isSelected: screenGalleryRoot.filePath_Selected === fullPath

                enabled: !isSelected
                height: 90
                width: listviewDirectoryContents.width

                function itemClicked() {
                    if (isDir)
                        screenGalleryRoot.onFolderClicked(index)
                    else
                        screenGalleryRoot.onItemClicked(index)
                }

                Item {
                    id: rectItemIcon

                    //color: parent.isDir ? "#00FF00" : "#00000000"
                    width: height
                    anchors {
                        left: parent.left
                        top: parent.top
                        topMargin: 10
                        bottom: parent.bottom
                        bottomMargin: 10
                    }
                    CompImageIcon {

                        readonly property string filePath_ROOT: "file:///usr/share/BeaconOS-lib-images/images/"
                        readonly property string filePath_FolderIcon: filePath_ROOT + "Folder.svg"
                        readonly property string filePath_Current: compDirContentItem.isDir ? filePath_FolderIcon : ""
                        source: filePath_Current
                        anchors.fill: parent
                    }
                }

                CompLabel {
                    id: lblFileName

                    text: parent.fileName
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter

                    anchors {
                        top: rectItemIcon.top
                        left: rectItemIcon.right
                        leftMargin: 20
                        bottom: rectItemIcon.bottom
                        right: parent.right
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: compDirContentItem.itemClicked()

                    onPressAndHold: screenGalleryRoot.onItemLongClicked(index)
                }
            }
        }
    }

    Rectangle {
        id: rectContents

        color: "#80000000"
        anchors {
            top: rectFileList.top
            left: rectFileList.right
            leftMargin: 20
            bottom: rectFileList.bottom
            right: rectPopupInfo.right
        }
    }

    CompTextEditor {
        id: textEditor

        visible: screenGalleryRoot.viewMode === "Text"
                 && screenGalleryRoot.fileExt_Selected !== "pdf"
        textEdit.text: FileHandler.loadedFileText
        fileName: screenGalleryRoot.fileName_Selected
        fileExtension: screenGalleryRoot.fileExt_Selected
        anchors.fill: rectContents

        onTextEditTextChanged: popupPleaseWait.close()
    }

    CompPdfViewer {
        id: pdfView

        visible: screenGalleryRoot.viewMode === "Text"
                 && screenGalleryRoot.fileExt_Selected === "pdf"
        fileUrl: visible ? screenGalleryRoot.filePath_Selected : "undefined"
        anchors.fill: rectContents
    }

    Item {
        id: compGalleryFileInfoView

        visible: screenGalleryRoot.viewMode === "File Info"
        anchors.fill: rectContents

        CompLabel {

            text: screenGalleryRoot.filePath_Selected
            anchors.centerIn: parent
        }
    }

    Item {
        id: compGalleryUnknownTypeView

        visible: screenGalleryRoot.viewMode === "Unknown"
        anchors.fill: rectContents

        CompLabel {

            text: "Unknown File Type: " + screenGalleryRoot.fileExt_Selected
            anchors.centerIn: parent
        }
    }

    Item {
        id: compGalleryAudioView

        visible: screenGalleryRoot.viewMode === "Audio"
        anchors.fill: rectContents

        CompLabel {

            text: "Audio File View: " + screenGalleryRoot.fileExt_Selected
            anchors.centerIn: parent
        }
    }

    Item {
        id: compGalleryVideoView

        visible: screenGalleryRoot.viewMode === "Video"
        anchors.fill: rectContents

        CompLabel {

            text: "Video File View: " + screenGalleryRoot.fileExt_Selected
            anchors.centerIn: parent
        }
    }

    Item {
        id: compGalleryDatabaseView

        visible: screenGalleryRoot.viewMode === "Database"
        anchors.fill: rectContents

        CompLabel {

            text: "Database File View: " + screenGalleryRoot.fileExt_Selected
            anchors.centerIn: parent
        }
    }

    Flickable {
        id: flickableImageViewer

        visible: screenGalleryRoot.viewMode === "Image"

        clip: true
        boundsBehavior: Flickable.StopAtBounds
        anchors.fill: rectContents

        Image {
            id: imageViewer

            asynchronous: true
            sourceSize: Qt.size(width, height)
            fillMode: Image.PreserveAspectFit

            onSourceChanged: {
                height = flickableImageViewer.height
                width = flickableImageViewer.width
            }
        }
    }

    Rectangle {
        id: rectControls

        color: "#80000000"
        anchors {
            left: rectPopupInfo.left
            bottom: rectBg.bottom
            bottomMargin: 20
            right: rectPopupInfo.right
        }

        height: 90
    }

    PopupPleaseWait {
        id: popupPleaseWait
        timeoutEnabled: false

        Connections {
            target: FileHandler

            //signal_FileLoadingStarted
            function onSignal_FileLoadingStarted() {
                console.log("popup opening")
                popupPleaseWait.open()
            }
        }
    }
}
