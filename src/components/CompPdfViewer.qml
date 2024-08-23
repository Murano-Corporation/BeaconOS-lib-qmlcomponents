import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.platform 1.0
import org.docviewer.poppler 1.0

Flickable {
    id: compPdfViewerRoot

    property alias path: poppler.path
    property alias loaded: poppler.loaded
    property real zoom: base.isDelta ? 3 : 2
    property int count: poppler.pages.length
    property int currentPage: -1

    property color searchHighlightColor: Qt.rgba(1, 1, .2, .4)
    property string fileUrl

    signal error(string errorMessage)
    signal searchNotFound
    signal searchRestartedFromTheBeginning

    onFileUrlChanged: {

        if (fileUrl === "")
            return

        compPdfViewerRoot.path = listviewPages.urlToPath(fileUrl)
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

        function urlToPath(urlString) {
            var s

            //console.log("urlToPath input: " + urlString)
            if (urlString.startsWith("file:///")) {
                var k = urlString.charAt(9) === ':' ? 8 : 7
                s = urlString.substring(k)
            } else {
                s = urlString
            }
            //console.log("urlToPath input parsed: " + s)
            var retUri = decodeURIComponent(s)

            //console.log("urlToPath returning: " + retUri)
            return retUri
        }

        // Current page
        function __updateCurrentPage() {
            var p = listviewPages.indexAt(
                        listviewPages.width / 2,
                        listviewPages.contentY + listviewPages.height / 2)
            if (p === -1)
                p = listviewPages.indexAt(
                            listviewPages.width / 2, listviewPages.contentY
                            + listviewPages.height / 2 + listviewPages.spacing)
            compPdfViewerRoot.currentPage = p
        }

        function __goTo(destination) {
            listviewPages.positionViewAtIndex(destination.page,
                                              ListView.Beginning)
            var pageHeight = poppler.pages[destination.page].size.height * compPdfViewerRoot.zoom
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
                            listviewPages.width / 2, listviewPages.contentY
                            + listviewPages.height / 2 + listviewPages.spacing)

            var pageHeight = poppler.pages[destination.page].size.height * compPdfViewerRoot.zoom
            var pageY = i.y - compPdfViewerRoot.contentY

            var bottomDistance = listviewPages.height - (pageY + Math.round(
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
            width: compPdfViewerRoot.width
            height: pageImage.height
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

                Repeater {
                    model: modelData.links
                    delegate: MouseArea {
                        x: Math.round(modelData.rect.x * parent.width)
                        y: Math.round(modelData.rect.y * parent.height)
                        width: Math.round(modelData.rect.width * parent.width)
                        height: Math.round(
                                    modelData.rect.height * parent.height)

                        cursorShape: Qt.PointingHandCursor
                        onClicked: listviewPages.__goTo(modelData.destination)
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
            target: compPdfViewerRoot

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
