import QtQuick 2.0
import CONSTANTS 1.0

Comp__BASE {
    id: compGalleryGridItemRoot

    property string messageFormat: ""
    property string fileType: ""
    property string fileName: "Unnammd"
    property string fileAuthor: "???"
    property string fileViewsString: "? Views"
    property string fileAgeString: "Unknown"
    property string fileRecordCreator: ""
    property int fileButtonFlags: 0
    property string filePathUrl
    property color colorLabelName: "#000000"
    property color colorLabelAuthor: "#000000"
    property color colorLabelMetaData: "#000000"
    property size sizeMetaDataButtons: Qt.size(32, 32)

    readonly property int metaDataFontSize: 14
    readonly property string filePathImages: "file:///usr/share/BeaconOS-lib-images/images/"

    signal signalMetaDataButtonClicked(int btn_id)
    signal signalMapButtonClicked
    signal signalSatelliteButtonClicked
    signal signalIconClicked(string filePathUrl, string fileExt)
    signal signalAuthorClicked(string fileRecordCreator)

    Item {
        id: areaIcon

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: areaMetaData.top

            bottomMargin: 10
        }

        Rectangle {
            id: rectIconAreaBg

            anchors.fill: parent
            color: "#F5F5F5"
        }

        CompImageIcon {

            source: {
                var type = compGalleryGridItemRoot.messageFormat

                if (type === "Document") {
                    return filePathImages + "file-pdf.svg"
                } else if (type === "Audio") {
                    return filePathImages + "audio.svg"
                } else if (type === "Graph") {
                    return filePathImages + "chart.svg"
                } else if (type === "3D Drawing") {
                    return filePathImages + "cube.svg"
                } else if (type === "Image") {
                    return filePathImages + "image.svg"
                } else if (type === "Video") {
                    return filePathImages + "video.svg"
                } else {
                    return filePathImages + "HelpFill.svg"
                }
            }

            anchors.fill: parent
            anchors.leftMargin: parent.width * 0.33
            anchors.rightMargin: parent.width * 0.33

            color: "#F9CC64"
        }

        MouseArea {
                    anchors.fill: parent

                    onClicked: {
                                compGalleryGridItemRoot.signalIconClicked(
                                   compGalleryGridItemRoot.filePathUrl,
                                   compGalleryGridItemRoot.fileType)
                        console.log("File type of clicked item is : ", compGalleryGridItemRoot.fileType)
                        if (compGalleryGridItemRoot.fileType == "stl"){
                            Viewer_3D_rendered.showViewer()
                        }
                    }
                }
            }

    Item {
        id: areaMetaData

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: colMetaData.height

        Column {
            id: colMetaData
            spacing: 2

            width: parent.width

            CompLabel {
                id: lblFileName

                width: parent.width
                color: compGalleryGridItemRoot.colorLabelName
                text: compGalleryGridItemRoot.fileName
                elide: Text.ElideRight

                font.pixelSize: compGalleryGridItemRoot.metaDataFontSize
            }

            CompLabel {
                id: lblFileAuthor

                color: compGalleryGridItemRoot.colorLabelAuthor
                text: compGalleryGridItemRoot.fileAuthor
                width: parent.width
                MouseArea {
                    anchors.fill: parent

                    onClicked: compGalleryGridItemRoot.signalAuthorClicked(
                                   compGalleryGridItemRoot.fileRecordCreator)
                }

                font.pixelSize: lblFileName.font.pixelSize
            }

            Row {
                id: rowMetaData
                spacing: 10
                CompLabel {
                    id: lblFileViews

                    color: compGalleryGridItemRoot.colorLabelMetaData
                    text: compGalleryGridItemRoot.fileViewsString + " Views"

                    font.pixelSize: lblFileName.font.pixelSize
                    font.bold: true
                }

                CompLabel {
                    text: "|"
                    color: lblFileViews.color
                    font.pixelSize: lblFileName.font.pixelSize
                }

                CompLabel {
                    id: lblFileAge

                    color: lblFileViews.color
                    text: compGalleryGridItemRoot.fileAgeString

                    font.pixelSize: lblFileName.font.pixelSize
                }

                CompLabel {
                    text: "|"

                    color: lblFileViews.color
                    font.pixelSize: lblFileName.font.pixelSize
                }

                CompIconBtn {
                    id: btnMap

                    height: compGalleryGridItemRoot.sizeMetaDataButtons.height
                    width: compGalleryGridItemRoot.sizeMetaDataButtons.height
                    applyColoring: false
                    //iconColor: "#DB594F"
                    iconUrl: compGalleryGridItemRoot.filePathImages + "locator.png"

                    onClicked: compGalleryGridItemRoot.signalMapButtonClicked()
                }

                CompIconBtn {
                    id: btnSatellite

                    height: btnMap.height
                    width: btnMap.width
                    applyColoring: false
                    //iconColor: "#4C8FBE"
                    iconUrl: compGalleryGridItemRoot.filePathImages + "satellite.png"

                    onClicked: compGalleryGridItemRoot.signalSatelliteButtonClicked()
                }

                CompIconBtn {
                    id: btnDrone

                    height: btnMap.height
                    width: btnMap.width
                    applyColoring: false
                    //iconColor: "#90C036"
                    iconUrl: compGalleryGridItemRoot.filePathImages + "drone.png"
                }
            }
        }
    }
}
