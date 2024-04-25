import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.platform 1.0
import org.docviewer.poppler 1.0

Screen__BASE {
    id: screenReferenceRoot

    property string preloadPDF: ""
    property string currentPDF: ""
    property bool isCheckForManuals: false
    property color toolbarBgColor: "#808080"
    property var tableModel: TableModelManuals
    property int viewMode: 1

    function populateAvailableManualsList(){
        SingletonUtils.checkManuals()
    }

    function onCheckManualsComplete(iResult)
    {
        //0 == OK

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

        return retUri;
    }

    function showFilePickerPopup(){

        popupManualPdfPicker.mappedObj = mapToItem(Overlay.overlay,
                                                   groupContents.x - (groupContents.anchors.leftMargin * 0.5) - 2,
                                                   groupContents.y - 16,
                                                   groupContents.width,
                                                   groupContents.height


                                                   )

        popupManualPdfPicker.open()
    }

    Item{
        id: toolBar

        anchors{
            top: parent.top
            left: pdfView.left
            right: pdfView.right
            topMargin: isDelta ? 0 : 150
        }

        height: isDelta ? 40 : 75

        Rectangle{
            id: rectToolbarBg

            anchors{
                fill: parent
            }

            color: screenReferenceRoot.toolbarBgColor
        }

        CompIconBtn{
            id: btnHideQuickView

            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/HamburgerMenu.svg"

            anchors{
                left: parent.left
                top: parent.top
                bottom: parent.bottom

                margins: 10
            }

            width: height

            onClicked: {
                popupManualPdfPicker.open()
            }
        }

        CompLabel{
            id: lblToolbarCurrentFileName

            anchors{
                top: btnHideQuickView.top
                bottom: btnHideQuickView.bottom
                left: btnHideQuickView.right
                leftMargin: 10
            }

            text: popupManualPdfPicker.fileNameSelected
            elide: Text.ElideRight
            font{
                pixelSize: isDelta ? height : (height * 0.8)
            }
        }

        Row{
            id: rowToolbarNavControls
            spacing: 10
            anchors{
                top: lblToolbarCurrentFileName.top
                bottom: lblToolbarCurrentFileName.bottom
                horizontalCenter: parent.horizontalCenter
            }

            Row{
                id: rowToolbarPageNav
                spacing: 5
                TextEdit{
                    id: edtPageNumCurrent
                    height: rowToolbarNavControls.height
                    text: view.currentIndex >= 0 ? view.currentIndex + 1 : '-'
                    inputMethodHints: Qt.ImhDigitsOnly
                    font{
                        family: lblPageNumMax.font.family
                        weight: Font.Bold
                        pixelSize: lblPageNumMax.font.pixelSize
                    }

                    color: lblPageNumMax.color
                }

                CompLabel{
                    id: lblPageNumMax

                    text: "/ " + (view.count >= 1 ? view.count : '-')
                    height: edtPageNumCurrent.height
                    font{
                        pixelSize: lblToolbarCurrentFileName.font.pixelSize
                    }

                }

            }

            CompLabel{

                height: rowToolbarNavControls.height

                font{
                    pixelSize: lblToolbarCurrentFileName.font.pixelSize
                }

                text: qsTr("|")
            }

            Row{
                id: rowToolbarZoomControls
                spacing: 5
                CompLabel{
                    id: btnZoomOut
                    height: rowToolbarNavControls.height

                    font{
                        pixelSize: lblToolbarCurrentFileName.font.pixelSize
                    }

                    text: qsTr("-")
                }

                TextEdit{
                    id: edtZoomCurrent
                    height: rowToolbarNavControls.height
                    text: '100%'

                    font{
                        pixelSize: edtPageNumCurrent.font.pixelSize
                        family: edtPageNumCurrent.font.family
                        weight: edtPageNumCurrent.font.weight
                    }

                    color: edtPageNumCurrent.color
                }

                CompLabel{
                    id: btnZoomIn
                    height: rowToolbarNavControls.height

                    font{
                        pixelSize: lblToolbarCurrentFileName.font.pixelSize
                    }

                    text: qsTr("+")
                }
            }


        }


        Row{
            id: rowToolbarActions

            spacing: 10

            anchors{
                top: rowToolbarNavControls.top
                bottom: rowToolbarNavControls.bottom
                right: parent.right
                rightMargin: 20
            }

            CompImageIcon{
                id: btnHelp

                source: "file:///usr/share/BeaconOS-lib-images/images/HelpFill.svg"

                height: rowToolbarActions.height

                width: height
            }

            CompImageIcon{
                id: btnOptions

                source: "file:///usr/share/BeaconOS-lib-images/images/GearFill.svg"

                height: rowToolbarActions.height

                width: height
            }
        }
    }

    CompButton{
        id: btnOpenFileBrowser

        visible: false

        anchors{
            top: parent.top
            left: parent.left
        }
        height: 40

        text: qsTr("Choose PDF")
        font{
            pixelSize: 12
        }

        onClicked: {
            fileDialog.open()
        }
    }


//    Poppler {
//        id: poppler

//        onPagesChanged: {
//            console.log("POPPLER PLUGIN PAGES CHANGED: " + pages.length)
//            view.model = poppler.pages
//        }

//        onError: {
//            console.log("POPPLER PLUGIN ERROR: " + errorMessage)
//        }
//    }

    PDFView {
      id: pdfView
      //anchors.fill: parent
      anchors{
          bottom: parent.bottom
          left: parent.left
          right: parent.right
          top: toolBar.bottom
          topMargin: 20
      }

      focus: true
      zoom: isDelta ? 3 : 2

      clip: true
      //path: fileDialog.file.toString().substring(6)
      ScrollBar.vertical: ScrollBar {
        minimumSize: 0.04
      }
      ScrollBar.horizontal: ScrollBar {
        minimumSize: 0.04
      }
    }

    Timer {
        id: timer
        interval: 100; repeat: false
        onTriggered: {
            pdfView.path = urlToPath(""+popupManualPdfPicker.filePathSelected)
            view.focus = true
        }
    }

    Item{
        id: groupContents

        visible: !popupManualPdfPicker.visible

        anchors{
            left: parent.left
            leftMargin: 20
            top: btnOpenFileBrowser.bottom
            topMargin: 20
            bottom: parent.bottom
            bottomMargin: 20
            right: parent.right
            rightMargin: 20
        }

        ListView{
            id: view
            clip: true

            width: 100
            spacing: 40
            anchors{
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }



            model: pdfView.count
            onModelChanged:{
                console.log("Model Changed")

                if(pdfView.count <= 0)
                {
                    return
                }

                screenReferenceRoot.currentPDF = model[0].image
            }

            delegate:  Image{
                id: image

                property var myModelData: modelData
                cache: false
                width: parent.width + (rectSelected.anchors.margins * 2)
                anchors.horizontalCenter: parent.horizontalCenter
                source: pdfView.loaded? modelData.image : ""
                sourceSize.width: width

                Rectangle{
                    id: rectSelected
                    visible: (view.currentIndex === index)

                    anchors.fill: parent

                    color: "#8000FF00"
                }

                Rectangle{
                    id: rectLblBg

                    anchors{
                        fill: lblIndex
                    }

                    radius: 10
                    color: "#C1000000"
                }

                CompLabel{
                    id: lblIndex

                    anchors{
                        top: parent.top
                        topMargin: 5
                        right: parent.right
                        rightMargin: 5
                    }

                    text: index+1
                    font{
                        pixelSize: 12
                        weight: Font.Bold
                    }
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignRight

                    padding: 5
                }



                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        view.currentIndex = index
                        view.focus = true
                        screenReferenceRoot.currentPDF = modelData.image
//                        flickablePdf.cancelFlick()
//                        flickablePdf.flick(0, bigImage.height)
//                        console.log("Clicked index: " + index)
                    }
                }
            }
        }
//        Flickable {
//            id: flickablePdf
//            clip: true

//            anchors{
//                top: parent.top
//                left: view.right
//                leftMargin: 20
//                right: parent.right
//                bottom: parent.bottom
//            }

//            contentWidth: bigImage.width;
//            contentHeight: bigImage.height
//            boundsBehavior: Flickable.StopAtBounds
//            Image{
//                id: bigImage
//                sourceSize.width: flickablePdf.width
//                source: (view.currentIndex >= 0)? screenReferenceRoot.currentPDF : ""
//            }
//        }

    }


    PopupManualPdfPicker {
        id: popupManualPdfPicker

        tableModel: screenReferenceRoot.tableModel

        onAboutToShow: {
            screenReferenceRoot.populateAvailableManualsList()
            popupManualPdfPicker.fileNameOnOpen = lblToolbarCurrentFileName.text
        }

        onSearchTextChanged: function(txt){
            screenReferenceRoot.tableModel.slot_SetFilter_FileName(txt)
        }

        onItemSelected: {
            view.model = undefined
            timer.running = true
        }

        Component.onCompleted:{

            if(screenReferenceRoot.preloadPDF !== "")
            {
                filePathSelected = screenReferenceRoot.filePathSelected
                timer.running = true
                return
            }

            screenReferenceRoot.showFilePickerPopup()
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.75;height:480;width:640}
}
##^##*/
