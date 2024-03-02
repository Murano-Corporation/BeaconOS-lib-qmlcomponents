import QtQuick 2.0
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import QtQuick.Shapes 1.12

Item {
    id: subscreenInduct_SelectQuadrant_Root



    anchors.fill: parent

    signal quadrantSelected(string quadrantId)

    CompLabel{
        id: lblTitle

        anchors{
            top: parent.top
            left: parent.left
            right: compProgressBar.left
        }

        text: "Select Quadrant for Inspection"
        font.pixelSize: 38
    }

    CompProgressBar {
        id: compProgressBar

        anchors{
            top: lblTitle.top
            right: parent.right
            bottom: lblTitle.bottom
        }
    }

    Item{
        id: compBeaconOsInduct_QuadrantPicker

        property string assetImagePath: "file:///usr/share/BeaconOS-lib-images/images/Induct_Asset_Growler.png"

        anchors{
            top: lblTitle.bottom
            topMargin: 32
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        CompGradientRect
        {
            id: rectBg

            anchors.fill: parent

            radius: 45
        }

        CompImageIcon{

            anchors.fill: parent

            source: compBeaconOsInduct_QuadrantPicker.assetImagePath
            transform: Translate{
                x: -100
            }

            color: "#80ffffff"
        }

        Grid{
            id: gridCells
            //visible: false
            property color colorIdle: "#40ffffff"
            property color colorIdleAlt: "#20ffffff"

            anchors.fill: parent

            columns: 2
            CompBeaconOsInduct_QuadrantCell {
                quadrantId: "Q1"
                colorIdle: gridCells.colorIdle
                onClicked: {
                    subscreenInduct_SelectQuadrant_Root.quadrantSelected(quadrantId)
                }
            }
            CompBeaconOsInduct_QuadrantCell {
                quadrantId: "Q2"
                infoAlignedLeft: false
                colorIdle: gridCells.colorIdleAlt
                onClicked: {
                    subscreenInduct_SelectQuadrant_Root.quadrantSelected(quadrantId)
                }

            }
            CompBeaconOsInduct_QuadrantCell {
                quadrantId: "Q4"
                infoAlignedLeft: true
                infoAlignedTop: false
                colorIdle: gridCells.colorIdleAlt
                onClicked: {
                    subscreenInduct_SelectQuadrant_Root.quadrantSelected(quadrantId)
                }
            }
            CompBeaconOsInduct_QuadrantCell {
                quadrantId: "Q3"
                infoAlignedLeft: false
                infoAlignedTop: false
                colorIdle: gridCells.colorIdle
                onClicked: {
                    subscreenInduct_SelectQuadrant_Root.quadrantSelected(quadrantId)
                }
            }

        }





    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.33;height:900;width:1800}
}
##^##*/
