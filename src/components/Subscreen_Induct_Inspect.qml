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

            CompGradientRect{
                anchors.fill: parent
            }

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
                    topMargin: 20
                    left: parent.left
                    leftMargin: 20
                    right: parent.right
                    rightMargin: 20
                }

                CompLabel{
                    id: lblStep

                    text: "Inspection Step"

                }

                Item{
                    id: rectStepBg

                    width: parent.width
                    height: 142

                    CompHealthPanelBg{
                        anchors.fill: parent
                    }

                    CompLabel{
                        id: lblStep_Value

                        anchors{
                            fill: parent

                            margins: 40
                        }

                        text: "Inspect (RH & LH) door 22 substructure, attach sills and fastener holes, for corrosion."
                        font.pixelSize: 28
                        color: "white"
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
                    leftMargin: 20
                    right: parent.right
                    rightMargin: 20
                }

                text: "Document Discrepancies"

            }

            Item{
                id: rectBG_Discrepancies

                anchors{
                    top: lblDiscrepancy.bottom
                    left: parent.left
                    leftMargin: 20
                    right: parent.right
                    rightMargin: 20
                    bottom: rowButtons.top
                    bottomMargin: 40

                }

                CompHealthPanelBg{
                    anchors.fill: parent
                }

                CompLabel{
                    id: btnSaveAsDraft

                    anchors{
                        top: parent.top
                        topMargin: 20
                        right: parent.right
                        rightMargin: 40
                    }

                    text: "Save as Draft"
                    font.pixelSize: 28
                    color: "#9287ED"
                }

                TextArea{
                    id: edtNotes

                    anchors{
                        top: btnSaveAsDraft.bottom
                        topMargin: 20
                        left: parent.left
                        leftMargin: 40
                        right: parent.right
                        rightMargin: 40
                        bottom: rowDiscrepancyControls.top
                        bottomMargin: 32
                    }



                    placeholderText: "Add discrepancy note"
                    color: "black"

                    background: Rectangle{

                    }
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
                        visible: false
                        height: 64

                        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/HelpFill.svg"
                        iconColor: "#9287ED"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CompIconBtn{
                        id: btnCamera

                        height: 64

                        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/CameraFill.svg"
                        iconColor: "#9287ED"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CompIconBtn{
                        id: btnVideo

                        height: 64

                        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/VideoFill.svg"
                        iconColor: "#9287ED"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CompIconBtn{
                        id: btnMic

                        height: 64

                        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/MicrophoneFill.svg"
                        iconColor: "#9287ED"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CompIconBtn{
                        id: btnImage
                        visible: false
                        height: 64

                        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/HelpFill.svg"
                        iconColor: "#9287ED"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CompIconBtn{
                        id: btnAttach
                        visible: false
                        height: 64

                        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/HelpFill.svg"
                        iconColor: "#9287ED"
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
                    leftMargin: 20
                    right: parent.right
                    rightMargin: 20
                    bottom: parent.bottom
                    bottomMargin: 20
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
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.5;height:914;width:1800}
}
##^##*/
