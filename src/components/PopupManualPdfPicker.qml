import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.platform 1.0
import org.docviewer.poppler 1.0

Popup {
    id: popupManualPdfPicker

    property var tableModel
    property string fileNameSelected: ""
    property string filePathSelected: ""
    property rect mappedObj: Qt.rect(0,0,300,400)
    property string fileNameOnOpen
    property int viewMode: 0
    //property int fileNameFontSize: 20
    property alias lblTitleComp : lblTitle
    property alias lblFileNameSize: listContents.fileNameFontSize
    property alias groupControlscomp: groupControls
    property alias btnCancelComp: btnCancel
    property alias referenceManualGrid: tableContents


    signal searchTextChanged(string text)
    signal itemSelected()

    anchors.centerIn: Overlay.overlay
    height: root.contentItem.height
    width: root.contentItem.width

    background: Rectangle{
        color: "#80000000"
    }





    CompPopupBG{
        id: rectBG

        height: popupManualPdfPicker.mappedObj.height
        width: popupManualPdfPicker.mappedObj.width

        anchors.fill: undefined

        x: popupManualPdfPicker.mappedObj.x
        y: popupManualPdfPicker.mappedObj.y


        Item{
            id: rowPdfPickerToolbar

            height: 60

            anchors{
                top: parent.top
                topMargin: 20
                left: lblTitle.left
                right: lblTitle.right

            }

            CompCustomisableTextField{
                id: search

                anchors{
                    top: parent.top
                    left: parent.left
                    right: btnView_List.left
                    rightMargin: 20
                    bottom: parent.bottom
                }



                onTextChanged: {
                    popupManualPdfPicker.searchTextChanged(text)

                }
            }

            CompIconBtn{
                id: btnView_List

                anchors{
                    top: parent.top
                    bottom: parent.bottom
                    right: btnView_Grid.left
                    rightMargin: 20
                }

                width: height

                iconUrl: "file:///usr/share/BeaconOS-lib-images/images/ListFill.svg"

                iconColor: (popupManualPdfPicker.viewMode === 0 ? "white" : "#80ffffff")

                onClicked: {
                    popupManualPdfPicker.viewMode = 0
                }
            }

            CompIconBtn{
                id: btnView_Grid

                anchors{
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }

                width: height

                iconUrl: "file:///usr/share/BeaconOS-lib-images/images/GridFill.svg"

                iconColor: (popupManualPdfPicker.viewMode === 1 ? "white" : "#80ffffff")

                onClicked: {
                    popupManualPdfPicker.viewMode = 1
                }
            }

        }



        Rectangle{
            id: sepHorizontal2

            anchors{
                top: rowPdfPickerToolbar.bottom
                topMargin: 20
                left: rowPdfPickerToolbar.left
                right: rowPdfPickerToolbar.right
            }

            height: 2

            color: "#30FFFFFF"
        }

        CompLabel{
            id: lblTitle

            anchors{
                top: sepHorizontal2.bottom
                left: parent.left
                right: parent.right

                margins: 20
            }

            text: qsTr("Please select a Manual to review")
            font{
                pixelSize: 20
                weight: Font.Bold
            }

            color: "white"
        }

        Rectangle{
            id: rectBG_Contents

            anchors{
                fill: listContents
                margins: -5
            }

            radius: 20

            color: "#80000000"
        }

        GridView {
            id: tableContents

            visible: popupManualPdfPicker.viewMode === 1

            boundsBehavior: Flickable.StopAtBounds

            cellHeight: height / 3
            cellWidth: width / 5

            clip: true

            anchors{
                fill: listContents
            }

            model: popupManualPdfPicker.tableModel

            delegate: CompReferenceGridItem{

                fileName: model.display

                height: tableContents.cellHeight
                width: tableContents.cellWidth

                colorHover: "#809287ED"
                colorSelected: "#9287ED"
                colorIdle: "transparent"
                isSelected: popupManualPdfPicker.fileNameSelected === model.display
                isHighlighted: listContents.fileNameHovered === model.display

                onClicked: {
                    popupManualPdfPicker.filePathSelected = model.file_path
                    popupManualPdfPicker.fileNameSelected = model.display
                }

                onDoubleClicked: {
                    popupManualPdfPicker.filePathSelected = model.file_path
                    popupManualPdfPicker.fileNameSelected = model.display
                    popupManualPdfPicker.itemSelected()
                    popupManualPdfPicker.close()
                }

                onEntered: {

                    listContents.fileNameHovered = model.display
                }

                onExited: {
                    if(listContents.fileNameHovered === model.display)
                    {
                        listContents.fileNameHovered = ""
                    }
                }
            }
        }

        ListView {
            id: listContents

            visible: popupManualPdfPicker.viewMode === 0

            property real itemHeight: 100
            property string fileNameHovered: ""
            property real fileNameFontSize: 20


            clip: true
            focus: true
            boundsBehavior: Flickable.StopAtBounds

            anchors{
                left: lblTitle.left
                right: lblTitle.right
                top: lblTitle.bottom
                topMargin: 20
                bottom: groupControls.top

                bottomMargin: 20
            }

            height: 0

            model: popupManualPdfPicker.tableModel


            delegate: Rectangle{

                property color colorHovered: "#809287ED"
                property color colorSelected: "#9287ED"
                property color colorIdle: "transparent"
                property bool isCurrent: popupManualPdfPicker.fileNameSelected === model.display
                property bool isHovered: listContents.fileNameHovered === model.display
                property color colorBgCurrent: (isCurrent ? colorSelected : (isHovered ? colorHovered : colorIdle))

                height: listContents.itemHeight
                width: listContents.width
                radius: rectBG_Contents.radius + rectBG_Contents.anchors.margins

                color: colorBgCurrent

                CompLabel{
                    id: lblFileName

                    anchors{
                        left: parent.left
                        leftMargin: parent.radius
                        verticalCenter: parent.verticalCenter
                    }

                    text: model.display

                    font{
                        pixelSize: listContents.fileNameFontSize
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        popupManualPdfPicker.filePathSelected = model.file_path
                        popupManualPdfPicker.fileNameSelected = model.display
                    }

                    onDoubleClicked: {
                        popupManualPdfPicker.filePathSelected = model.file_path
                        popupManualPdfPicker.fileNameSelected = model.display
                        popupManualPdfPicker.itemSelected()
                        popupManualPdfPicker.close()
                    }

                    onEntered: {
                        //listContents.currentItem = this
                        console.log("Entered " + model.display)
                        listContents.fileNameHovered = model.display
                    }

                    onExited: {
                        if(listContents.fileNameHovered === model.display)
                        {
                            console.log("Exited " + model.display)
                            listContents.fileNameHovered = ""
                        }
                    }
                }

            }
        }

        Item{
            id: groupControls

            //property real btnHeight: 60
            property real btnWidth: 200
            property real btnSpacing: 40

            height: 60

            anchors{
                left: lblTitle.left
                right: lblTitle.right
                bottom: parent.bottom
                bottomMargin: 20
            }

            CompBtnBreadcrumb{
                id: btnCancel

                enabled: (popupManualPdfPicker.fileNameOnOpen !== "")

                anchors{
                    right: parent.right
                    bottom: parent.bottom
                }

                height: groupControls.height
                width: groupControls.btnWidth

                font.pixelSize: 20

                text: qsTr("Back")

                onClicked: {
                    popupManualPdfPicker.fileNameSelected = popupManualPdfPicker.fileNameOnOpen
                    popupManualPdfPicker.close()
                }

            }

            CompBtnBreadcrumb{
                id: btnOpen

                enabled: (popupManualPdfPicker.fileNameSelected !== "" && popupManualPdfPicker.fileNameOnOpen !== popupManualPdfPicker.fileNameSelected)

                anchors{
                    right: btnCancel.left
                    rightMargin: groupControls.btnSpacing
                    bottom: btnCancel.bottom
                }

                height: btnCancel.height
                width: btnCancel.width

                font.pixelSize: btnCancel.font.pixelSize

                text: qsTr("Open")

                //iconSource: "file:///usr/share/BeaconOS-lib-images/images/5G.svg"

                onClicked: {
                    popupManualPdfPicker.itemSelected()
                    popupManualPdfPicker.close()
                }
            }
        }

    }


}

