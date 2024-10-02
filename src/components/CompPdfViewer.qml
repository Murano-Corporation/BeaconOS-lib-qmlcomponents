import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.0
import org.docviewer.poppler 1.0

Item {
    id: compPdfViewerRoot

    property alias path: poppler.path
    property alias loaded: poppler.loaded
    property real zoom: base.isDelta ? 3 : 2
    property real zoom_perceived: 1.0
    property real zoomFactor_Pinch: 0.1
    property int count: poppler.pages.length
    property int currentPage: -1
    property int pageWidth_Current
    property color searchHighlightColor: Qt.rgba(1, 1, .2, .4)
    property string fileUrl
    property point pointPinchCenter

    property real loadProgress: 1.0
    property bool showTopToolbar: false
    readonly property color colorThumbnailContentBG: "#D7D7DB"
    readonly property color colorSpacer: "#80ffffff"
    readonly property color colorToolbarBG: "#F9F9FA"
    readonly property color colorThumbnailToolbarBG: "green" //colorToolbarBG

    readonly property int toolbarHeight: 40
    readonly property int toolbarControlHeight: 32
    readonly property int pageCurrentWidth: 60

    signal error(string errorMessage)
    signal searchNotFound
    signal searchRestartedFromTheBeginning

    onFileUrlChanged: {

        if (fileUrl === "")
            return

        compPdfViewerRoot.path = listviewPages.urlToPath(fileUrl)
    }

    //contentHeight: listviewPages.height
    clip: true

    Rectangle {
        id: rectAreaTopControls

        visible: showTopToolbar
        color: colorToolbarBG

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: visible ? compPdfViewerRoot.toolbarHeight : 0

        CompIconBtn {
            id: btnShowThumbnails

            height: parent.height
            width: height

            anchors {
                left: parent.left
            }

            onClicked: {
                rectAreaThumbnails.toggle()
            }
        }

        Item {
            id: spacer1

            width: 32

            anchors {
                left: btnShowThumbnails.right
            }
        }

        Row {
            height: parent.height

            anchors {
                left: spacer1.right
            }

            CompIconBtn {
                id: btnSearch

                height: btnShowThumbnails.height
                width: btnShowThumbnails.width
            }

            CompIconBtn {
                id: btnPageUp

                height: btnShowThumbnails.height
                width: btnShowThumbnails.width
            }

            Rectangle {
                width: 2
                height: parent.height

                color: compPdfViewerRoot.colorSpacer
            }

            CompIconBtn {
                id: btnPageDown

                height: btnShowThumbnails.height
                width: btnShowThumbnails.width
            }

            TextInput {
                id: pageNumberCurrent

                height: parent.height
                width: compPdfViewerRoot.pageCurrentWidth

                text: "1"

                horizontalAlignment: Text.AlignRight
            }

            CompLabel {
                id: lblPageCount

                height: parent.height

                text: "of ###"
            }
        }

        Row {
            id: groupZoomControls

            height: parent.height
            anchors.centerIn: parent

            CompIconBtn {
                id: btnZoomDecrease

                height: compPdfViewerRoot.toolbarControlHeight
                width: height
            }

            Rectangle {
                width: 2
                height: parent.height

                color: compPdfViewerRoot.colorSpacer
            }

            CompIconBtn {
                id: btnZoomIncrease

                height: compPdfViewerRoot.toolbarControlHeight
                width: height
            }

            CompCombobox {
                id: comboZoom

                height: parent.height
                width: 140
            }
        }

        Row {
            id: groupFileControls

            height: parent.height
            anchors.right: parent.right

            CompIconBtn {
                id: btnEdit

                height: compPdfViewerRoot.toolbarControlHeight
                width: height
            }

            CompIconBtn {
                id: btnSave

                height: compPdfViewerRoot.toolbarControlHeight
                width: height
            }

            CompIconBtn {
                id: btnPresent

                height: compPdfViewerRoot.toolbarControlHeight
                width: height
            }

            CompIconBtn {
                id: btnDownloadTo

                height: compPdfViewerRoot.toolbarControlHeight
                width: height
            }

            Rectangle {
                width: 2
                height: parent.height

                color: compPdfViewerRoot.colorSpacer
            }

            CompIconBtn {
                id: btnFileActionMenu

                height: compPdfViewerRoot.toolbarControlHeight
                width: height
            }
        }
    }

    onZoomChanged: {
        listviewPages.x = (listviewPages.width * 0.5)
    }

    Rectangle {
        id: rectAreaProgressbar

        visible: compPdfViewerRoot.loadProgress < 1.0

        anchors {
            top: rectAreaTopControls.bottom
            left: rectAreaTopControls.left
            right: rectAreaTopControls.right
        }
        height: 4

        Rectangle {
            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }

            width: parent.width * compPdfViewerRoot.loadProgress

            color: "green"
        }

        color: "#80000000"

        Rectangle {}
    }

    Rectangle {
        id: rectAreaThumbnails

        readonly property int xShow: 0
        readonly property int xHide: 0 - rectAreaThumbnails.width
        readonly property bool isShowing: rectAreaThumbnails.x > xHide

        color: compPdfViewerRoot.colorThumbnailToolbarBG

        x: xHide
        width: 200

        anchors {
            top: rectAreaTopControls.bottom
            bottom: parent.bottom
        }

        function toggle() {
            if (rectAreaThumbnails.isShowing) {
                rectAreaThumbnails.hide()
            } else {
                rectAreaThumbnails.show()
            }
        }

        function show() {
            rectAreaThumbnails.x = rectAreaThumbnails.xShow
        }

        function hide() {
            rectAreaThumbnails.x = rectAreaThumbnails.xHide
        }

        Behavior on x {
            NumberAnimation {
                duration: 250
            }
        }

        Rectangle {
            id: rectAreaThumbnailControls

            height: compPdfViewerRoot.toolbarHeight
            anchors {
                left: parent.left
                top: parent.top
                right: parent.right
            }
        }

        Rectangle {
            id: rectAreaThumbnailContents

            color: compPdfViewerRoot.colorThumbnailContentBG
            anchors {
                top: rectAreaThumbnailControls.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            ListView {
                id: listViewThumbnails

                anchors {
                    fill: parent
                    leftMargin: 20
                    rightMargin: 20
                }
            }
        }
    }

    Rectangle {
        id: rectContentBG

        anchors.fill: rectContent

        color: "#EDEDF0"
    }

    Flickable {
        id: rectContent

        anchors {
            top: rectAreaTopControls.bottom
            left: rectAreaThumbnails.right
            right: parent.right
            bottom: parent.bottom
        }

        contentWidth: listviewPages.width
        clip: true
        onWidthChanged: {
            listviewPages.autoCenter()
        }

        ListView {
            id: listviewPages

            property string __currentSearchTerm
            property int __currentSearchResultIndex: -1
            property var __currentSearchResults
            property var __currentSearchResult: __currentSearchResultIndex > -1 ? __currentSearchResults[__currentSearchResultIndex] : {
                                                                                      "page": -1,
                                                                                      "rect": Qt.rect(0, 0, 0, 0)
                                                                                  }

            anchors {
                top: parent.top
                bottom: parent.bottom

                margins: 10
            }
            width: compPdfViewerRoot.pageWidth_Current
            onWidthChanged: {
                autoCenter()
            }

            function autoCenter() {
                listviewPages.x = (rectContent.width * 0.5) - (listviewPages.width * 0.5)
            }

            //transform: Scale {
            //    xScale: compPdfViewerRoot.zoom_perceived
            //    yScale: compPdfViewerRoot.zoom_perceived

            //    origin {
            //        x: compPdfViewerRoot.pointPinchCenter.x
            //        y: compPdfViewerRoot.pointPinchCenter.y
            //    }
            //}
            function urlToPath(urlString) {
                var s

                console.log("urlToPath input: " + urlString)
                if (urlString.startsWith("file:///")) {
                    var k = urlString.charAt(9) === ':' ? 8 : 7
                    s = urlString.substring(k)
                } else {
                    s = urlString
                }
                console.log("urlToPath input parsed: " + s)
                var retUri = decodeURIComponent(s)

                console.log("urlToPath returning: " + retUri)
                return retUri
            }

            // Current page
            function __updateCurrentPage() {
                var p = listviewPages.indexAt(
                            listviewPages.width / 2,
                            listviewPages.contentY + listviewPages.height / 2)
                if (p === -1)
                    p = listviewPages.indexAt(
                                listviewPages.width / 2,
                                listviewPages.contentY + listviewPages.height
                                / 2 + listviewPages.spacing)
                compPdfViewerRoot.currentPage = p
            }

            function __goTo(destination) {
                destination.page -= 1
                listviewPages.positionViewAtIndex(destination.page,
                                                  ListView.Beginning)
                var pageHeight = poppler.pages[destination.page].size.height
                        * compPdfViewerRoot.zoom
                var scroll = Math.round(destination.top * pageHeight)
                listviewPages.contentY += scroll
            }

            function __scrollTo(destination) {
                if (destination.page !== compPdfViewerRoot.currentPage) {
                    listviewPages.positionViewAtIndex(destination.page,
                                                      ListView.Beginning)
                }

                var i = listviewPages.itemAt(
                            listviewPages.width / 2,
                            listviewPages.contentY + listviewPages.height / 2)
                if (i === null)
                    i = listviewPages.itemAt(
                                listviewPages.width / 2,
                                listviewPages.contentY + listviewPages.height
                                / 2 + listviewPages.spacing)

                var pageHeight = poppler.pages[destination.page].size.height
                        * compPdfViewerRoot.zoom
                var pageY = i.y - compPdfViewerRoot.contentY

                var bottomDistance = listviewPages.height
                        - (pageY + Math.round(
                               destination.rect.bottom * pageHeight))
                var topDistance = pageY + Math.round(
                            destination.rect.top * pageHeight)
                if (bottomDistance < 0) {
                    // The found term is lower than the bottom of viewport
                    listviewPages.contentY -= bottomDistance - listviewPages.spacing
                } else if (topDistance < 0) {
                    listviewPages.contentY += topDistance - listviewPages.spacing
                }
            }

            spacing: 20
            boundsBehavior: Flickable.StopAtBounds
            model: poppler.pages
            focus: true
            clip: true
            ScrollBar.vertical: ScrollBar {
                minimumSize: 0.04
            }
            ScrollBar.horizontal: ScrollBar {
                minimumSize: 0.04
            }
            header: Item {
                height: 10
            }
            footer: Item {
                height: 10
            }
            delegate: Item {
                width: pageImage.width
                height: pageImage.height

                onWidthChanged: {
                    compPdfViewerRoot.pageWidth_Current = width
                }

                Image {
                    id: pageImage
                    x: Math.round((parent.width - sourceSize.width) / 2)

                    cache: false
                    fillMode: Image.Pad

                    sourceSize.width: Math.round(
                                          modelData.size.width * compPdfViewerRoot.zoom)

                    sourceSize.height: Math.round(
                                           modelData.size.height * compPdfViewerRoot.zoom)
                    source: modelData.image
                    width: sourceSize.width
                    height: sourceSize.height

                    //Rectangle {
                    //    anchors.fill: parent
                    //    color: "#8000ff00"
                    //}
                    Repeater {
                        model: modelData.links
                        delegate: Rectangle {
                            x: Math.round(modelData.rect.x * parent.width)
                            y: Math.round(modelData.rect.y * parent.height)
                            width: Math.round(
                                       modelData.rect.width * parent.width)
                            height: Math.round(
                                        modelData.rect.height * parent.height)

                            color: "#100000ff"

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: listviewPages.__goTo(
                                               modelData.destination)
                            }
                        }
                    }

                    Rectangle {
                        visible: listviewPages.__currentSearchResult.page === index
                        color: compPdfViewerRoot.searchHighlightColor
                        x: Math.round(
                               listviewPages.__currentSearchResult.rect.x * parent.width)
                        y: Math.round(
                               listviewPages.__currentSearchResult.rect.y * parent.height)
                        width: Math.round(
                                   listviewPages.__currentSearchResult.rect.width * parent.width)
                        height: Math.round(
                                    listviewPages.__currentSearchResult.rect.height * parent.height)
                    }
                }
            }

            Connections {
                target: rectContent

                function onContentYChanged() {
                    listviewPages.__updateCurrentPage()
                }
            }

            Poppler {
                id: poppler
                onLoadedChanged: {
                    listviewPages.__updateCurrentPage()
                    listviewPages.__currentSearchTerm = ''
                    listviewPages.__currentSearchResultIndex = -1
                    listviewPages.__currentSearchResults = []
                }
                onError: compPdfViewerRoot.error(errorMessage)
            }

            Comp__BASE {
                id: base
            }
        }
    }
}
