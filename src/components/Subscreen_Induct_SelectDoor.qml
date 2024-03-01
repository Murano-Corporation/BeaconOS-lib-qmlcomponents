import QtQuick 2.0

Item {
    id: subscreenInductSelectDoor_Root
    anchors.fill: parent

    property string assetName: "[ASSET NAME]"
    property string quadrantId: "Q1"
    property string assetImgPath: "file:///usr/share/BeaconOS-lib-images/images/Induct_Asset_Growler.png"
    readonly property string title: assetName + " | " + quadrantId + ": Select Door for Inspection"
    property var listOfZones: [
        {
            "name": "[Zone Name]",
            "isComplete": true,
            "tags": ["BR"]
        },
        {
            "name": "[Zone Name]",
            "isComplete": false,
            "tags": ["KV"]
        },
        {
            "name": "[Zone Name]",
            "isComplete": false,
            "tags": ["KV", "JS"]
        },
        {
            "name": "[Zone Name]",
            "isComplete": false,
            "tags": ["SR"]
        },
        {
            "name": "Door 22: Zone 18.10 +18.12",
            "isComplete": false,
            "tags": []
        },
        {
            "name": "[Zone Name]",
            "isComplete": false,
            "tags": ["KV"]
        }
    ]


    signal zoneSelected(string zoneId)

    CompLabel{
        id: lblTitle

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }

        text: subscreenInductSelectDoor_Root.title
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

        Rectangle{
            id: rectZoneSelect

            radius: 42

            anchors{
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }

            width: parent.width * 0.48

            CompCustomisableTextField{
                id: searchField

                anchors{
                    top: parent.top
                    topMargin: 42
                    left: parent.left
                    leftMargin: 42
                    right: parent.right
                    rightMargin: 42
                }


            }

            ListView{
                id: listViewZones

                model: subscreenInductSelectDoor_Root.listOfZones
                spacing: 10
                anchors{
                    top:searchField.bottom
                    topMargin: 32
                    left: searchField.left
                    right: searchField.right
                    bottom: parent.bottom
                    bottomMargin: 42

                }

                delegate: Item{
                    id: compBeaconOsInduct_ZoneListItem
                    height: 90

                    property real sidePadding: 20

                    width: listViewZones.width

                    Rectangle{
                        id: rectBg

                        anchors.fill: parent

                        color: "#05000000"
                    }

                    CompLabel{
                        id: lblZoneName

                        text: modelData.name
                        color: "black"
                        font.pixelSize: 16
                        verticalAlignment: Text.AlignVCenter

                        anchors{
                            left: parent.left
                            top: parent.top
                            bottom: parent.bottom
                        }

                        leftPadding: compBeaconOsInduct_ZoneListItem.sidePadding
                    }

                    Row{

                        spacing: 20
                        anchors{
                            right: parent.right
                            rightMargin: compBeaconOsInduct_ZoneListItem.sidePadding
                            top: parent.top
                            bottom: parent.bottom
                        }

                        CompLabel{
                            id: lblViewWorkOrder

                            visible: modelData.isComplete

                            text: "View Work Order"
                            font.pixelSize: height * 0.75
                            height: btnInspectZone.height


                            color: "#000000"
                            verticalAlignment: Text.AlignVCenter
                            anchors.verticalCenter: btnInspectZone.verticalCenter
                        }

                        CompImageIcon{
                            id: iconDoc

                            visible: modelData.isComplete

                            height: btnInspectZone.height
                            width: height
                            source: "file:///usr/share/BeaconOS-lib-images/images/ReferenceFill.svg"
                            color: "#A21A30"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Row{
                            height: parent.height

                            spacing: -4

                            Repeater{
                                model: modelData.tags

                                CompBeaconOsInduct_QuadrantTag{
                                    text: modelData

                                    height:iconDone.height
                                    width: height
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }




                        CompImageIcon{
                            id: iconDone

                            visible: modelData.isComplete


                            height: btnInspectZone.height
                            width: height
                            source: "file:///usr/share/BeaconOS-lib-images/images/CheckFill.svg"
                            color: "#00ff10"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        CompIconBtn{
                            id: btnInspectZone

                            visible: !modelData.isComplete

                            height: parent.height * 0.3
                            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/RightFill.svg"
                            anchors.verticalCenter: parent.verticalCenter

                            onClicked: subscreenInductSelectDoor_Root.zoneSelected("TEST")

                        }
                    }
                }
            }

        }


        Rectangle{
            id: compBeaconOsInduct_ZoneHighlighter

            property color colorContrast: "#80000000"
            property color colorFade: "#8000ffff"
            property color colorAssetImg: "#818181"

            anchors{
                top: rectZoneSelect.top
                right: parent.right
                bottom: rectZoneSelect.bottom

            }

            width: rectZoneSelect.width
            color: "#E6EAEE"

            border{
                color: "#C0C2C4"
                width: 4
            }



            Rectangle{
                id: rectBlurTL

                anchors{
                    left: parent.left
                    top: parent.top

                    margins: compBeaconOsInduct_ZoneHighlighter.border.width
                }

                width: (parent.width * 0.5)- compBeaconOsInduct_ZoneHighlighter.border.width
                height: (parent.height * 0.5) - compBeaconOsInduct_ZoneHighlighter.border.width

                color:  subscreenInductSelectDoor_Root.quadrantId === "Q1" ? compBeaconOsInduct_ZoneHighlighter.colorFade : compBeaconOsInduct_ZoneHighlighter.colorContrast
            }

            Rectangle{
                id: rectBlurTR

                anchors{
                    right: parent.right
                    top: parent.top

                    margins: compBeaconOsInduct_ZoneHighlighter.border.width
                }

                width: rectBlurTL.width
                height: rectBlurTL.height

                color:  subscreenInductSelectDoor_Root.quadrantId === "Q2" ? compBeaconOsInduct_ZoneHighlighter.colorFade : compBeaconOsInduct_ZoneHighlighter.colorContrast
            }

            Rectangle{
                id: rectBlurBR

                anchors{
                    right: parent.right
                    bottom: parent.bottom
                    margins: compBeaconOsInduct_ZoneHighlighter.border.width

                }

                width: rectBlurTL.width
                height: rectBlurTL.height

                color:  subscreenInductSelectDoor_Root.quadrantId === "Q3" ? compBeaconOsInduct_ZoneHighlighter.colorFade : compBeaconOsInduct_ZoneHighlighter.colorContrast
            }

            Rectangle{
                id: rectBlurBL

                anchors{
                    left: parent.left
                    bottom: parent.bottom
                    margins: compBeaconOsInduct_ZoneHighlighter.border.width

                }

                width: rectBlurTL.width
                height: rectBlurTL.height

                color:  subscreenInductSelectDoor_Root.quadrantId === "Q4" ? compBeaconOsInduct_ZoneHighlighter.colorFade : compBeaconOsInduct_ZoneHighlighter.colorContrast
            }

            CompImageIcon{
                id: imgAsset

                source: subscreenInductSelectDoor_Root.assetImgPath

                anchors{
                    fill: parent
                    margins: 80


                }
                color: compBeaconOsInduct_ZoneHighlighter.colorAssetImg

            }
        }
    }


}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.33;height:914;width:1800}
}
##^##*/
