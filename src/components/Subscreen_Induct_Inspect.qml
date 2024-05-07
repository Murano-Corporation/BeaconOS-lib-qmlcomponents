import QtQuick 2.0
import QtQuick.Controls 2.12

Item {
    id: subscreenInduct_Inspect_Root

    anchors.fill: parent

    property string assetName: "F/A-18: 168267"
    property string quadrantId: "Q4"
    property string zoneId: "18.10, 18.12"
    property string discrepancyNotes

    property int fontSizeHeaders: isDelta ? 25 : 35
    property int fontSizeContent: isDelta ? 25 : 35
    property real iconButtonHeight: isDelta ? 32 : 75

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

    Item{
        id: groupContents

        anchors{
            top: parent.top
            topMargin: 16
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        CompBeaconOsInduct_InspectInfoPanel {
            id: compBeaconOsInduct_InspectInfoPanel
            visible: isDelta

            fontSizeContent: subscreenInduct_Inspect_Root.fontSizeContent
            fontSizeHeaders: subscreenInduct_Inspect_Root.fontSizeHeaders

            anchors{
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }

            width: parent.width * 0.48


        }

        Flickable{
            id: scrollInspectInfoPnel
            visible: !isDelta
            anchors{
                top: parent.top
                left: parent.left
                right: parent.right
                //bottom: parent.bottom
            }
            height:550
            clip: true

            contentHeight: compBeaconOsInduct_InspectInfoPanelOmega.height
            contentWidth: compBeaconOsInduct_InspectInfoPanelOmega.width

            CompBeaconOsInduct_InspectInfoPanel {
                id: compBeaconOsInduct_InspectInfoPanelOmega

                fontSizeContent: subscreenInduct_Inspect_Root.fontSizeContent
                fontSizeHeaders: subscreenInduct_Inspect_Root.fontSizeHeaders

                height: 700
                width: scrollInspectInfoPnel.width
            }
        }

        Item{
            id: compBeaconOsInduct_InspectStepPanel

            CompGradientRect{
                anchors.fill: parent
            }

            anchors{
                top: isDelta ? parent.top : scrollInspectInfoPnel.bottom
                right: parent.right
                bottom: parent.bottom
                bottomMargin: isDelta ? 0 : 80

            }

            width: isDelta ? compBeaconOsInduct_InspectInfoPanel.width : scrollInspectInfoPnel.width

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

                    font.pixelSize: subscreenInduct_Inspect_Root.fontSizeHeaders

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
                        font.pixelSize: subscreenInduct_Inspect_Root.fontSizeContent
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
                font.pixelSize: subscreenInduct_Inspect_Root.fontSizeHeaders

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
                    font.pixelSize: subscreenInduct_Inspect_Root.fontSizeHeaders
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
                    font.pixelSize: subscreenInduct_Inspect_Root.fontSizeContent
                    background: Rectangle{

                    }
                }

                Row{
                    id: rowDiscrepancyControls
                    spacing: isDelta ? 32 : 40
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
                        height: subscreenInduct_Inspect_Root.iconButtonHeight

                        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/HelpFill.svg"
                        iconColor: "#9287ED"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CompIconBtn{
                        id: btnCamera

                        height: subscreenInduct_Inspect_Root.iconButtonHeight

                        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/CameraFill.svg"
                        iconColor: "#9287ED"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CompIconBtn{
                        id: btnVideo

                        height: subscreenInduct_Inspect_Root.iconButtonHeight

                        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/VideoFill.svg"
                        iconColor: "#9287ED"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CompIconBtn{
                        id: btnMic

                        height: subscreenInduct_Inspect_Root.iconButtonHeight

                        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/MicrophoneFill.svg"
                        iconColor: "#9287ED"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CompIconBtn{
                        id: btnImage
                        visible: false
                        height: subscreenInduct_Inspect_Root.iconButtonHeight

                        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/HelpFill.svg"
                        iconColor: "#9287ED"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CompIconBtn{
                        id: btnAttach
                        visible: false
                        height: subscreenInduct_Inspect_Root.iconButtonHeight

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
                    bottomMargin: isDelta ? 20 : 30
                }

                CompBtnBreadcrumb{
                    id: btnViewIetm

                    text: "View IETM"
                    width: ((rowButtons.width - (2 *rowButtons.spacing)) * 0.33333)
                    height: isDelta ? 60 : 100
                }

                CompBtnBreadcrumb{
                    id: btnViewLesJx

                    text: "View LES JX F18-0242"

                    width: btnViewIetm.width
                    height: isDelta ? 60 : 100
                }

                CompBtnBreadcrumb{
                    id: btnSaveAndExit

                    text: "Save and Exit"
                    width: btnViewIetm.width
                    height: isDelta ? 60 : 100
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
