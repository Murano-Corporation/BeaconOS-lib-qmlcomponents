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



    Item{
        id: groupContents

        anchors{
            top: parent.top
            topMargin: 16
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Item {
            id: rectZoneSelect

            CompGradientRect{
                anchors.fill: parent
            }

            anchors{
                top: isDelta ? parent.top : compBeaconOsInduct_ZoneHighlighter.bottom
                topMargin: isDelta ? 0 : 20
                left: parent.left
                right: isDelta ? undefined : parent.right
                bottom: parent.bottom
                bottomMargin: isDelta ? 0 : 100
            }

            width: isDelta ? (parent.width * 0.48) : parent.width

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

                height: isDelta ? 41 : 100


            }

            ListView{
                id: listViewZones
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                model: subscreenInductSelectDoor_Root.listOfZones
                spacing: 32
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
                    height: isDelta ? 90 : 120

                    property real sidePadding: 20

                    width: listViewZones.width

                    Rectangle{
                        id: rectBg

                        anchors.fill: parent

                        color: "#10ffffff"
                    }

                    CompLabel{
                        id: lblZoneName

                        text: modelData.name
                        color: "white"
                        font.pixelSize: isDelta ? 25 : 35
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
                            font.pixelSize: isDelta ? 25 : 35
                            height: btnInspectZone.height


                            color: "white"
                            verticalAlignment: Text.AlignVCenter
                            anchors.verticalCenter: btnInspectZone.verticalCenter
                        }

                        CompImageIcon{
                            id: iconDoc

                            visible: modelData.isComplete

                            height: btnInspectZone.height
                            width: height
                            source: "file:///usr/share/BeaconOS-lib-images/images/ReferenceFill.svg"
                            color: "#9287ED"
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

                            height: isDelta ? (parent.height * 0.3) : (parent.height*0.5)
                            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/RightFill.svg"

                            iconColor: modelData.tags.length > 0 ? "#ffff00" : "#ffffff"

                            anchors.verticalCenter: parent.verticalCenter

                            onClicked: subscreenInductSelectDoor_Root.zoneSelected("18.10 + 18.12")

                        }
                    }
                }
            }

        }


        Rectangle{
            id: compBeaconOsInduct_ZoneHighlighter

            property color colorContrast: "#80000000"
            property color colorFade: "#809287ED"
            property color colorAssetImg: "#818181"

            anchors{
                top: isDelta ? rectZoneSelect.top : parent.top
                topMargin: isDelta ? 0 : 16
                right: parent.right
                rightMargin: isDelta ? 0 : 40
                left: isDelta ? undefined : parent.left
                leftMargin: isDelta ? 0 : 40
                bottom: isDelta ? rectZoneSelect.bottom : undefined

            }

            width: isDelta ? rectZoneSelect.width : 400
            height: isDelta ? undefined : 400
            color: "transparent"

            border{
                color: "transparent"
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
                visible: isDelta

                source: subscreenInductSelectDoor_Root.assetImgPath

                anchors{
                    fill: parent
                    margins: 80


                }
                color: compBeaconOsInduct_ZoneHighlighter.colorAssetImg

            }

            CompImageIcon{
                id: imgAssetOmega
                visible: !isDelta

                source: subscreenInductSelectDoor_Root.assetImgPath

                anchors{
                    fill: parent
                    margins: 80


                }
                transform: Rotation{
                    origin.x: imgAssetOmega.width * 0.5
                    origin.y: imgAssetOmega
                    .height * 0.5
                    angle: 90
                }
                color: compBeaconOsInduct_ZoneHighlighter.colorAssetImg

            }
        }
    }


}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.5;height:914;width:1800}
}
##^##*/
