import QtQuick 2.0
import QtQuick.Controls 2.12

Item {
    id: subscreenInduct_Inspect_Root

    anchors.fill: parent

    property string assetName: "F/A-18: 168267"
    property string quadrantId: "Q4"
    property string zoneId: "18.10, 18.12"
    property string discrepancyNotes


    readonly property string title: assetName + " | " + quadrantId + " | " + zoneId

    signal viewIetmClicked()
    signal viewAssetManualClicked()
    signal saveAndExitClicked()
    signal saveAsDraftClicked()
    signal captureImageClicked()
    signal captureVideoClicked()
    signal captureVoiceMemoClicked()
    signal attachImnageClicked()
    signal attachDocumentClicked()

    CompLabel{
        id: lblTitle

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }

        text: subscreenInduct_Inspect_Root.title
        font.pixelSize: 38
    }

    Item{
        id: groupContents

        anchors{
            top: lblTitle.bottom
            topMargin: 32
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        CompBeaconOsInduct_InspectInfoPanel {
            id: compBeaconOsInduct_InspectInfoPanel

            anchors{
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }

            width: parent.width * 0.48


        }


        Item{
            id: compBeaconOsInduct_InspectStepPanel

            anchors{
                top: parent.top
                right: parent.right
                bottom: parent.bottom

            }

            width: compBeaconOsInduct_InspectInfoPanel.width

            Column{
                id: colStep

                anchors{
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                CompLabel{
                    id: lblStep

                    text: "Inspection Step"

                }

                Rectangle{
                    id: rectStepBg

                    width: parent.width
                    height: 142
                    CompLabel{
                        id: lblStep_Value

                        anchors{
                            fill: parent

                            margins: 40
                        }

                        text: "Inspect (RH & LH) door 22 substructure, attach sills and fastener holes, for corrosion."
                        font.pixelSize: 28
                        color: "black"
                        wrapMode: Text.WordWrap
                    }
                }
            }

            CompLabel{
                id: lblDiscrepancy

                anchors{
                    top: colStep.bottom
                    topMargin: 40
                    left: parent.left
                    right: parent.right
                }

                text: "Document Discrepancies"

            }

            Rectangle{
                id: rectBG_Discrepancies

                anchors{
                    top: lblDiscrepancy.bottom
                    left: parent.left
                    right: parent.right
                    bottom: rowButtons.top
                    bottomMargin: 40

                }

                CompLabel{
                    id: btnSaveAsDraft

                    anchors{
                        top: parent.top
                        right: parent.right
                    }

                    text: "Save as Draft"
                    color: "#00ffff"
                }

                TextArea{
                    id: edtNotes

                    anchors{
                        top: btnSaveAsDraft.bottom
                        left: parent.left
                        right: parent.right
                    }

                    height: 64

                    placeholderText: "Add discrepancy note"
                }

                Row{
                    id: rowDiscrepancyControls
                    spacing: 32
                    anchors{
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right

                        margins: 32
                    }

                    height: 72

                    CompIconBtn{
                        id: btnAdd

                        height: 64

                        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/HelpFill.svg"

                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CompIconBtn{
                        id: btnCamera

                        height: 64

                        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/CameraFill.svg"

                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CompIconBtn{
                        id: btnVideo

                        height: 64

                        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/VideoFill.svg"

                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CompIconBtn{
                        id: btnMic

                        height: 64

                        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/MicrophoneFill.svg"

                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CompIconBtn{
                        id: btnImage

                        height: 64

                        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/HelpFill.svg"

                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CompIconBtn{
                        id: btnAttach

                        height: 64

                        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/HelpFill.svg"

                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Row{
                id: rowButtons

                height: 64
                spacing: 32
                anchors{
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                CompBtnBreadcrumb{
                    id: btnViewIetm

                    text: "View IETM"
                    width: ((rowButtons.width - (2 *rowButtons.spacing)) * 0.33333)
                }

                CompBtnBreadcrumb{
                    id: btnViewLesJx

                    text: "View LES JX F18-0242"

                    width: btnViewIetm.width
                }

                CompBtnBreadcrumb{
                    id: btnSaveAndExit

                    text: "Save and Exit"
                    width: btnViewIetm.width
                }

            }

        }

    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.33;height:914;width:1800}
}
##^##*/
